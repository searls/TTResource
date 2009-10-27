//
//  TTResourceConfig.h
//  TTResource
//
//  Created by vickeryj on 1/29/09.
//  Copyright 2009 Joshua Vickery. All rights reserved.
//  Modified by Justin Searls on 10/27/09.
//  Copyright 2009 Justin Searls. All rights reserved.

#import <Foundation/Foundation.h>
#import "TTResource.h"

@interface TTResourceConfig : NSObject

+ (NSString *)getSite;
+ (void)setSite:(NSString*)siteURL;
+ (NSString *)getUser;
+ (void)setUser:(NSString *)user;
+ (NSString *)getPassword;
+ (void)setPassword:(NSString *)password;
+ (SEL)getParseDataMethod;
+ (void)setParseDataMethod:(SEL)parseMethod;
+ (SEL) getSerializeMethod;
+ (void) setSerializeMethod:(SEL)serializeMethod;
+ (NSString *)protocolExtension;
+ (void)setProtocolExtension:(NSString *)protocolExtension;
+ (void)setResponseType:(TTResponseFormat) format;
+ (TTResponseFormat)getResponseType;

@end
