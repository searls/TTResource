//
//  NSObject+TTResource.h
//  TTResource
//
//  Created by vickeryj on 1/29/09.
//  Copyright 2009 Joshua Vickery. All rights reserved.
//  Modified by Justin Searls on 10/27/09.
//  Copyright 2009 Justin Searls. All rights reserved.

#import <Foundation/Foundation.h>
#import "TTResourceDelegate.h"
#import <Three20/Three20.h>

@interface NSObject (TTResource) <TTResourceDelegate>


// Response Formats
typedef enum {
	XmlResponse = 0, //xxtodo once initially ported, change to TTResponseFormatXML
	JSONResponse, //and this to TTResponseFormatJSON
} TTResponseFormat;

#pragma mark -
#pragma mark Class Methods

#pragma mark Configuration methods
+ (NSString *)getRemoteSite;
+ (void)setRemoteSite:(NSString*)siteURL;
+ (NSString *)getRemoteUser;
+ (void)setRemoteUser:(NSString *)user;
+ (NSString *)getRemotePassword;
+ (void)setRemotePassword:(NSString *)password;
+ (SEL)getRemoteParseDataMethod;
+ (void)setRemoteParseDataMethod:(SEL)parseMethod;
+ (SEL) getRemoteSerializeMethod;
+ (void) setRemoteSerializeMethod:(SEL)serializeMethod;
+ (NSString *)getRemoteProtocolExtension;
+ (void)setRemoteProtocolExtension:(NSString *)protocolExtension;
+ (void)setRemoteResponseType:(TTResponseFormat) format;
+ (TTResponseFormat)getRemoteResponseType;

#pragma mark URL Construction Accessors
+ (NSString *)getRemoteElementName;
+ (NSString *)getRemoteCollectionName;
+ (NSString *)getRemoteElementPath:(NSString *)elementId;
+ (NSString *)getRemoteCollectionPath;
+ (NSString *)getRemoteCollectionPathWithParameters:(NSDictionary *)parameters;
+ (NSString *)populateRemotePath:(NSString *)path withParameters:(NSDictionary *)parameters;

//Remote - Finders
+ (TTURLRequest *)findAllRemote;
+ (TTURLRequest *)findRemote:(NSString *)elementId;

#pragma mark -
#pragma mark Instance methods

#pragma mark Remote - Create, Update, Destroy
- (TTURLRequest *)createRemote;
- (TTURLRequest *)createRemoteWithParameters:(NSDictionary *)parameters;
- (TTURLRequest *)updateRemote;
- (TTURLRequest *)destroyRemote;
- (TTURLRequest *)saveRemote;

- (TTURLRequest *)createRemoteAtPath:(NSString *)path;
- (TTURLRequest *)updateRemoteAtPath:(NSString *)path;
- (TTURLRequest *)destroyRemoteAtPath:(NSString *)path;

#pragma mark ID methods
- (id)getRemoteId;
- (void)setRemoteId:(id)orsId;
- (NSString *)getRemoteClassIdName;

#pragma mark Instance helpers for getting at commonly used class-level values
- (NSString *)getRemoteCollectionPath;
- (NSString *)convertToRemoteExpectedType;

#pragma mark Equality test for remote enabled objects based on class name and remote id
- (BOOL)isEqualToRemote:(id)anObject;
- (NSUInteger)hashForRemote;

#pragma mark Methods for users to override

//Override to exclude specific properties from being propogated
- (NSArray *)excludedPropertyNames;

//The TTResourceDelegate is called upon the completion of any activity.
//Override if some other entity needs to be delegate.
- (id<TTResourceDelegate>)useResourceDelegate;

@end
