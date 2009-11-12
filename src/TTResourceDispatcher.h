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
#import "TTResourceDelegate.h"


@interface TTResourceDispatcher : NSObject <TTURLRequestDelegate> 

+ (id)dispatcher;

+ (TTURLRequest*) post:(NSString *)body to:(NSString *)url receiver:(id)receiver delegate:(id<TTResourceDelegate>)delegate;
+ (TTURLRequest*) post:(NSString *)body to:(NSString *)url withUser:(NSString *)user andPassword:(NSString *)password receiver:(id)receiver delegate:(id<TTResourceDelegate>)delegate;

+ (TTURLRequest*) get:(NSString *)url withUser:(NSString *)user andPassword:(NSString *)password receiver:(id)receiver delegate:(id<TTResourceDelegate>)delegate;
+ (TTURLRequest*) get:(NSString *)url receiver:(id)receiver delegate:(id<TTResourceDelegate>)delegate;

+ (TTURLRequest*) put:(NSString *)body to:(NSString *)url withUser:(NSString *)user andPassword:(NSString *)password receiver:(id)receiver delegate:(id<TTResourceDelegate>)delegate;

+ (TTURLRequest*) delete:(NSString *)url withUser:(NSString *)user andPassword:(NSString *)password receiver:(id)receiver delegate:(id<TTResourceDelegate>)delegate;

//This probably isn't necessary. New to Three20 and want this functionality? 
//          Check out TTURLRequestQueue's cancel and pause functions
//+ (void) cancelAllActiveConnections; //xxtodo - Necessary?

@end
