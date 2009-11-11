//
//  TTResourceDispatcher.m
//  TTResource
//
//  Created by vickeryj on 1/29/09.
//  Copyright 2009 Joshua Vickery. All rights reserved.
//  Modified by Justin Searls on 10/27/09.
//  Copyright 2009 Justin Searls. All rights reserved.
//

#import "TTResourceDispatcher.h"
#import "TTResourceConfig.h"
#import "TTResourceDelegate.h"
#import "Three20/Three20.h"
#import "NSData+Additions.h"
#import "NSObject+TTResource.h"
#import "NSObject+PropertySupport.h"

@interface TTResourceDispatcher()

+ (void)sendRequest:(TTURLRequest *)request withUser:(NSString *)user andPassword:(NSString *)password;
+ (TTURLRequest *)sendBy:(NSString *)method withBody:(NSString *)body to:(NSString *)url 
                withUser:(NSString *)user andPassword:(NSString *)password receiver:(id)receiver 
                delegate:(id<TTResourceDelegate>)delegate;

+ (NSString*)urlContainingAuthString:(NSString*)authString forUrl:(NSString*)url;

@end


@implementation TTResourceDispatcher

#pragma mark -
#pragma mark Public Methods

+ (TTURLRequest *)post:(NSString *)body to:(NSString *)url receiver:(id)receiver delegate:(id<TTResourceDelegate>)delegate{
	return [self post:body to:url withUser:nil andPassword:nil receiver:receiver delegate:delegate];
}

+ (TTURLRequest *)post:(NSString *)body to:(NSString *)url withUser:(NSString *)user andPassword:(NSString *)password receiver:(id)receiver delegate:(id<TTResourceDelegate>)delegate{
	return [self sendBy:@"POST" withBody:body to:url withUser:user andPassword:password receiver:receiver delegate:delegate];
}

+ (TTURLRequest *)put:(NSString *)body to:(NSString *)url withUser:(NSString *)user andPassword:(NSString *)password receiver:(id)receiver delegate:(id<TTResourceDelegate>)delegate{
	return [self sendBy:@"PUT" withBody:body to:url withUser:user andPassword:password receiver:receiver delegate:delegate];
}

+ (TTURLRequest *)get:(NSString *)url receiver:(id)receiver delegate:(id<TTResourceDelegate>)delegate{
	return [self get:url withUser:nil andPassword:nil receiver:receiver delegate:delegate];
}

+ (TTURLRequest *)get:(NSString *)url withUser:(NSString *)user andPassword:(NSString *)password receiver:(id)receiver delegate:(id<TTResourceDelegate>)delegate{
  return [self sendBy:@"GET" withBody:nil to:url withUser:user andPassword:password receiver:receiver delegate:delegate];
}

+ (TTURLRequest *)delete:(NSString *)url withUser:(NSString *)user andPassword:(NSString *)password receiver:(id)receiver delegate:(id<TTResourceDelegate>)delegate{
  return [self sendBy:@"DELETE" withBody:nil to:url withUser:user andPassword:password receiver:receiver delegate:delegate];
}

#pragma mark -
#pragma mark TTURLRequestDelegate

/**
 * The request has loaded data has loaded and been processed into a response.
 *
 * If the request is served from the cache, this is the only delegate method that will be called.
 */
- (void)requestDidFinishLoad:(TTURLRequest*)request {  
  NSObject<TTResourceDelegate> *delegate = [(TTUserInfo*)request.userInfo strong];
  id receiver = [(TTUserInfo*)request.userInfo weak];
  NSData *body = [(TTURLDataResponse*)request.response data];
  
  if(!receiver) {
    //xxtodo - Now what? Throw an error? Freak out
    TTLOG(@"No receiver (expected to adhere to TTResourceDelegate)");
    return;
  }
  
  if([request.httpMethod isEqualToString:@"GET"]) { //Find    
    
    NSArray *results = [receiver performSelector:[receiver getRemoteParseDataMethod] 
                                      withObject:body];
    
    [[delegate class] foundObjects:results forRequest:request];
    //xxtodo - Write a bunch of tests for this delegate call; the finder methods are class methods so we know the
    //          TTResourceDelegate is really a class.    
  } else if([request.httpMethod isEqualToString:@"POST"]) { //Create
    NSDictionary *newProperties = [[[receiver class] 
                                    performSelector:[[receiver class] getRemoteParseDataMethod] 
                                    withObject:body] properties];
    [receiver setProperties:newProperties];

    [delegate createdObject:receiver forRequest:request];
    
  } else if([request.httpMethod isEqualToString:@"PUT"]) { //Update 
    if([(NSString *)[request.headers objectForKey:@"Content-Length"] intValue] > 1) {
      NSDictionary *newProperties = [[[receiver class] performSelector:[[receiver class] getRemoteParseDataMethod] 
                                                            withObject:body] properties];
      [receiver setProperties:newProperties];
    }    
    [delegate updatedObject:receiver forRequest:request];
  } else if([request.httpMethod isEqualToString:@"DELETE"]) { //Destroy
    [delegate destroyedObject:receiver forRequest:request];
  } else {
    //This shouldn't happen; xxtodo - raise exception
  }
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
  //xxtodo call failure delegate method (include action type in failure?)
  NSLog(@"%@",[error localizedDescription]);
}



#pragma mark -
#pragma mark Private methods

+ (void)sendRequest:(TTURLRequest *)request withUser:(NSString *)user andPassword:(NSString *)password {
	
  //1. Hammer out the URL and header if Basic HTTP Authentication needs to be added
	if(user && password) {
    NSString *authString = [NSString stringWithFormat:@"%@:%@",user, password];
    request.URL = [TTResourceDispatcher urlContainingAuthString:authString forUrl:request.URL];
    [request.headers setObject:[[authString dataUsingEncoding:NSUTF8StringEncoding] base64Encoding] 
                        forKey:@"Authorization"];
	}
  
  //2. Set MIME type for Content-Type and Accept headers

  switch ([TTResourceConfig getResponseType]) {
		case TTResponseFormatJSON:
      request.contentType = @"application/json";
//      [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];      
			break;
		default:
      request.contentType = @"application/xml";
//      [request setValue:@"application/xml" forHTTPHeaderField:@"Accept"];   
      break;
	}
  
  request.shouldHandleCookies = YES;
  
  //2. Create a Data Response Object
  request.response = [[[TTURLDataResponse alloc] init] autorelease];  
  

  //3. Send
  [request send];
}


+ (TTURLRequest *)sendBy:(NSString *)method withBody:(NSString *)body to:(NSString *)url 
                withUser:(NSString *)user andPassword:(NSString *)password 
                receiver:(id)receiver 
                delegate:(id<TTResourceDelegate>)delegate{
  TTURLRequest *request = [TTURLRequest requestWithURL:url delegate:self];
  request.httpMethod = method;
  if(body) {
    request.httpBody = [body dataUsingEncoding:NSUTF8StringEncoding];
  }
  
  [self sendRequest:request withUser:user andPassword:password];
  
  request.userInfo = [TTUserInfo topic:method strong:delegate weak:receiver];
  
	return request;
}

+ (NSString*)urlContainingAuthString:(NSString*)authString forUrl:(NSString*)url {  
  //Convert to NSURL and rebuild w/ the user/pass in place. xxtodo roundabout and could be replaced by regex.
  NSURL *urlObject = [NSURL URLWithString:url];    
  NSString *escapedAuthString = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, 
                                                                                     (CFStringRef)authString, NULL, (CFStringRef)@"@.:", kCFStringEncodingUTF8) autorelease];
  NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@://%@@%@",[urlObject scheme],escapedAuthString,[urlObject host],nil];
  if([urlObject port]) {
    [urlString appendFormat:@":%@",[urlObject port],nil];
  }
  [urlString appendString:[urlObject path]];
  if([urlObject query]){
    [urlString appendFormat:@"?%@",[urlObject query],nil];
  }

  return [urlObject absoluteString];
}


@end
