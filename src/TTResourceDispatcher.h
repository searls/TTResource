//
//  TTResourceDispatcher.h
//  TTResource
//
//  Created by vickeryj on 1/29/09.
//  Copyright 2009 Joshua Vickery. All rights reserved.
//  Modified by Justin Searls on 10/27/09.
//  Copyright 2009 Justin Searls. All rights reserved.
//
// For those porting over from ObjectiveResource, this 
//  class is analagous to Connection.h

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>


@interface TTResourceDispatcher : NSObject <TTURLRequestDelegate> 

+ (TTURLRequest*) post:(NSString *)body to:(NSString *)url;
+ (TTURLRequest*) post:(NSString *)body to:(NSString *)url withUser:(NSString *)user andPassword:(NSString *)password;

+ (TTURLRequest*) get:(NSString *)url withUser:(NSString *)user andPassword:(NSString *)password;
+ (TTURLRequest*) get:(NSString *)url;

+ (TTURLRequest*) put:(NSString *)body to:(NSString *)url withUser:(NSString *)user andPassword:(NSString *)password;

+ (TTURLRequest*) delete:(NSString *)url withUser:(NSString *)user andPassword:(NSString *)password;

//xxtodo - Verify, but this probably isn't necessary. New to Three20 and want this? 
//          Check out TTURLRequestQueue
//+ (void) cancelAllActiveConnections; //xxtodo - Necessary?

@end
