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
#import "Three20/Three20.h"
#import "NSData+Additions.h"

@interface TTResourceDispatcher()

+ (void)sendRequest:(TTURLRequest *)request withUser:(NSString *)user andPassword:(NSString *)password;
+ (TTURLRequest *)sendBy:(NSString *)method withBody:(NSString *)body to:(NSString *)url withUser:(NSString *)user andPassword:(NSString *)password;

+ (NSString*)urlContainingAuthString:(NSString*)authString forUrl:(NSString*)url;

@end


@implementation TTResourceDispatcher

#pragma mark -
#pragma mark Public Methods

+ (TTURLRequest *)post:(NSString *)body to:(NSString *)url {
	return [self post:body to:url withUser:nil andPassword:nil];
}

+ (TTURLRequest *)post:(NSString *)body to:(NSString *)url withUser:(NSString *)user andPassword:(NSString *)password{
	return [self sendBy:@"POST" withBody:body to:url withUser:user andPassword:password];
}

+ (TTURLRequest *)put:(NSString *)body to:(NSString *)url withUser:(NSString *)user andPassword:(NSString *)password{
	return [self sendBy:@"PUT" withBody:body to:url withUser:user andPassword:password];
}

+ (TTURLRequest *)get:(NSString *)url {
	return [self get:url withUser:nil andPassword:nil];
}

+ (TTURLRequest *)get:(NSString *)url withUser:(NSString *)user andPassword:(NSString *)password {  
  return [self sendBy:@"GET" withBody:nil to:url withUser:user andPassword:password];
}

+ (TTURLRequest *)delete:(NSString *)url withUser:(NSString *)user andPassword:(NSString *)password {
  return [self sendBy:@"DELETE" withBody:nil to:url withUser:user andPassword:password];
}

#pragma mark -
#pragma mark TTURLRequestDelegate

/**
 * The request has loaded data has loaded and been processed into a response.
 *
 * If the request is served from the cache, this is the only delegate method that will be called.
 */
- (void)requestDidFinishLoad:(TTURLRequest*)request {
 /* Replace this gunk.
  Response *resp = [Response responseFrom:(NSHTTPURLResponse *)connectionDelegate.response 
                                 withBody:connectionDelegate.data 
                                 andError:connectionDelegate.error];
  */
  
  /* And do so elegantly for each of these methods that call the dispatcher:
   
   Find Remote & Find All Remote [+ (TTURLRequest *)findRemote:(NSString *)elementId] & [+ (TTURLRequest *)findAllRemote]
    [self performSelector:[self getRemoteParseDataMethod] withObject:res.body]
   
   Create remote at path [- (TTURLRequest *)createRemoteAtPath:(NSString *)path]
     NSDictionary *newProperties = [[[self class] performSelector:[[self class] getRemoteParseDataMethod] withObject:res.body] properties];
     [self setProperties:newProperties];
     return YES;
   
   Update remote at path [-(TTURLRequest *)updateRemoteAtPath:(NSString *)path]
     if([(NSString *)[res.headers objectForKey:@"Content-Length"] intValue] > 1) {
     NSDictionary *newProperties = [[[self class] performSelector:[[self class] getRemoteParseDataMethod] withObject:res.body] properties];
     [self setProperties:newProperties];
     }
   
   Destroy [-(TTURLRequest *)destroyRemoteAtPath:(NSString *)path]
      //do nothing
   
   
   
   */
   
   

}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
  //xxtodo - oops, we lost the reference to the calling object, so we don't have a delegate
  //            to phone home to. We'll have to wire that into the methods above.
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
  
  //2. Create a Data Response Object
  request.response = [[[TTURLDataResponse alloc] init] autorelease];  
  
  //3. xxtodo - will need to add a userinfo object that identifies which type of request we're processing. It could store the selector for all I care.
  

  //4. Send
  [request send];
}


+ (TTURLRequest *)sendBy:(NSString *)method withBody:(NSString *)body to:(NSString *)url withUser:(NSString *)user andPassword:(NSString *)password {
  TTURLRequest *request = [TTURLRequest requestWithURL:url delegate:self];
  request.httpMethod = method;
  if(body) {
    request.httpBody = [body dataUsingEncoding:NSUTF8StringEncoding];
  }
  
  [self sendRequest:request withUser:user andPassword:password];
  
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
