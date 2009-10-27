//
//  NSObject+TTResource.m
//  TTResource
//
//  Created by vickeryj on 1/29/09.
//  Copyright 2009 Joshua Vickery. All rights reserved.
//  Modified by Justin Searls on 10/27/09.
//  Copyright 2009 Justin Searls. All rights reserved.
//

#import "NSObject+TTResource.h"
#import <Three20/Three20.h>
#import "TTResourceDispatcher.h"
#import "CoreSupport.h"
#import "XMLSerializableSupport.h"
#import "JSONSerializableSupport.h"

static NSString *_activeResourceSite = nil;
static NSString *_activeResourceUser = nil;
static NSString *_activeResourcePassword = nil;
static SEL _activeResourceParseDataMethod = nil;
static SEL _activeResourceSerializeMethod = nil;
static NSString *_activeResourceProtocolExtension = @".xml";
static TTResponseFormat _format;

@implementation NSObject (ObjectiveResource)

#pragma mark -
#pragma mark Class Methods

#pragma mark configuration methods
+ (NSString *)getRemoteSite {
	return _activeResourceSite;
}

+ (void)setRemoteSite:(NSString *)siteURL {
	if (_activeResourceSite != siteURL) {
		[_activeResourceSite autorelease];
		_activeResourceSite = [siteURL copy];
	}
}

+ (NSString *)getRemoteUser {
	return _activeResourceUser;
}

+ (void)setRemoteUser:(NSString *)user {
	if (_activeResourceUser != user) {
		[_activeResourceUser autorelease];
		_activeResourceUser = [user copy];
	}
}

+ (NSString *)getRemotePassword {
	return _activeResourcePassword;
}

+ (void)setRemotePassword:(NSString *)password {
	if (_activeResourcePassword != password) {
		[_activeResourcePassword autorelease];
		_activeResourcePassword = [password copy];
	}
}

+ (void)setRemoteResponseType:(TTResponseFormat) format {
	_format = format;
	switch (format) {
		case JSONResponse:
			[[self class] setRemoteProtocolExtension:@".json"];
			[[self class] setRemoteParseDataMethod:@selector(fromJSONData:)];
			[[self class] setRemoteSerializeMethod:@selector(toJSONExcluding:)];
			break;
		default:
			[[self class] setRemoteProtocolExtension:@".xml"];
			[[self class] setRemoteParseDataMethod:@selector(fromXMLData:)];
			[[self class] setRemoteSerializeMethod:@selector(toXMLElementExcluding:)];
			break;
	}
}

+ (TTResponseFormat)getRemoteResponseType {
	return _format;
}

+ (SEL)getRemoteParseDataMethod {
	return (nil == _activeResourceParseDataMethod) ? @selector(fromXMLData:) : _activeResourceParseDataMethod;
}

+ (void)setRemoteParseDataMethod:(SEL)parseMethod {
	_activeResourceParseDataMethod = parseMethod;
}

+ (SEL) getRemoteSerializeMethod {
	return (nil == _activeResourceSerializeMethod) ? @selector(toXMLElementExcluding:) : _activeResourceSerializeMethod;
}

+ (void) setRemoteSerializeMethod:(SEL)serializeMethod {
	_activeResourceSerializeMethod = serializeMethod;
}

+ (NSString *)getRemoteProtocolExtension {
	return _activeResourceProtocolExtension;
}

+ (void)setRemoteProtocolExtension:(NSString *)protocolExtension {
	if (_activeResourceProtocolExtension != protocolExtension) {
		[_activeResourceProtocolExtension autorelease];
		_activeResourceProtocolExtension = [protocolExtension copy];
	}
}

#pragma mark URL Construction Accessors

+ (NSString *)getRemoteElementName {
	return [[NSStringFromClass([self class]) stringByReplacingCharactersInRange:NSMakeRange(0, 1) 
                                                                   withString:[[NSStringFromClass([self class]) substringWithRange:NSMakeRange(0,1)] lowercaseString]] underscore];
}

+ (NSString *)getRemoteCollectionName {
	return [[self getRemoteElementName] stringByAppendingString:@"s"];
}

+ (NSString *)getRemoteElementPath:(NSString *)elementId {
	return [NSString stringWithFormat:@"%@%@/%@%@", [self getRemoteSite], [self getRemoteCollectionName], elementId, [self getRemoteProtocolExtension]];
}

+ (NSString *)getRemoteCollectionPath {
	return [[[self getRemoteSite] stringByAppendingString:[self getRemoteCollectionName]] stringByAppendingString:[self getRemoteProtocolExtension]];
}

+ (NSString *)getRemoteCollectionPathWithParameters:(NSDictionary *)parameters {
	return [self populateRemotePath:[self getRemoteCollectionPath] withParameters:parameters];
}	

+ (NSString *)populateRemotePath:(NSString *)path withParameters:(NSDictionary *)parameters {
	
	// Translate each key to have a preceeding ":" for proper URL param notation
	NSMutableDictionary *parameterized = [NSMutableDictionary dictionaryWithCapacity:[parameters count]];
	for (NSString *key in parameters) {
		[parameterized setObject:[parameters objectForKey:key] forKey:[NSString stringWithFormat:@":%@", key]];
	}
	return [path gsub:parameterized];
}


#pragma mark Remote Find methods

// Find all items
+ (TTURLRequest *)findAllRemote {
  return [TTResourceDispatcher get:[self getRemoteCollectionPath] 
                          withUser:[[self class] getRemoteUser] 
                       andPassword:[[self class]  getRemotePassword]];
}

//Find one item
+ (TTURLRequest *)findRemote:(NSString *)elementId {
	return [TTResourceDispatcher get:[self getRemoteElementPath:elementId] 
                          withUser:[[self class] getRemoteUser] 
                       andPassword:[[self class]  getRemotePassword]];
}

#pragma mark -
#pragma mark Instance methods


#pragma mark Remote - Create, Update, Destroy

- (TTURLRequest *)createRemote {
	return [self createRemoteAtPath:[self getRemoteCollectionPath]];	
}

- (TTURLRequest *)createRemoteWithParameters:(NSDictionary *)parameters {
	return [self createRemoteAtPath:[[self class] getRemoteCollectionPathWithParameters:parameters]];
}

- (TTURLRequest *)updateRemote {
	id myId = [self getRemoteId];
	if (nil != myId) {
		return [self updateRemoteAtPath:[[self class] getRemoteElementPath:myId]];
	}
	else {
		[[NSException exceptionWithName:@"ID Was Nil" reason:@"updateRemote sent, but object had no ID" 
                           userInfo:nil] raise];
    return nil; //xxtodo - why is this necessary to avert a warning?
	}
}

- (TTURLRequest *)destroyRemote {
	id myId = [self getRemoteId];
	if (nil != myId) {
		return [self destroyRemoteAtPath:[[self class] getRemoteElementPath:myId]];
	}
	else {
		[[NSException exceptionWithName:@"ID Was Nil" reason:@"destroyRemote sent, but object had no ID" 
                           userInfo:nil] raise];
    return nil; //xxtodo - why is this necessary to avert a warning?    
  }
}

- (TTURLRequest *)saveRemote {
	id myId = [self getRemoteId];
	if (nil == myId) {
		return [self createRemote];
	}
	else {
		return [self updateRemote];
	}
}

- (TTURLRequest *)createRemoteAtPath:(NSString *)path {
	return [TTResourceDispatcher post:[self convertToRemoteExpectedType] to:path withUser:[[self class]  getRemoteUser] andPassword:[[self class]  getRemotePassword]];
}

-(TTURLRequest *)updateRemoteAtPath:(NSString *)path {	
  return [TTResourceDispatcher put:[self convertToRemoteExpectedType] to:path 
                          withUser:[[self class]  getRemoteUser] andPassword:[[self class]  getRemotePassword]];	
}

- (TTURLRequest *)destroyRemoteAtPath:(NSString *)path {
  return [TTResourceDispatcher delete:path withUser:[[self class]  getRemoteUser] andPassword:[[self class]  getRemotePassword]];
}

#pragma mark ID methods
- (id)getRemoteId {
	id result = nil;
	SEL idMethodSelector = NSSelectorFromString([self getRemoteClassIdName]);
	if ([self respondsToSelector:idMethodSelector]) {
		result = [self performSelector:idMethodSelector];
		if ([result respondsToSelector:@selector(stringValue)]) {
			result = [result stringValue];
		}
	}
	return result;
}
- (void)setRemoteId:(id)orsId {
	SEL setter = NSSelectorFromString([NSString stringWithFormat:@"set%@Id:",[self className]]);
	if ([self respondsToSelector:setter]) {
		[self performSelector:setter withObject:orsId];
	}
}


- (NSString *)getRemoteClassIdName {
	
	return [NSString stringWithFormat:@"%@Id",
          [NSStringFromClass([self class]) stringByReplacingCharactersInRange:NSMakeRange(0, 1) 
                                                                   withString:[[NSStringFromClass([self class]) substringWithRange:NSMakeRange(0,1)] lowercaseString]]];
	
}


#pragma mark Instance helpers for getting at commonly used class-level values

- (NSString *)getRemoteCollectionPath {
	return [[self class] getRemoteCollectionPath];
}

// Converts the object to the data format expected by the server
- (NSString *)convertToRemoteExpectedType {	  
  return [self performSelector:[[self class] getRemoteSerializeMethod] withObject:[self excludedPropertyNames]];
}

#pragma mark Equality test for remote enabled objects based on class name and remote id

//default equals methods for id and class based equality
- (BOOL)isEqualToRemote:(id)anObject {
	return 	[NSStringFromClass([self class]) isEqualToString:NSStringFromClass([anObject class])] &&
	[anObject respondsToSelector:@selector(getRemoteId)] && [[anObject getRemoteId]isEqualToString:[self getRemoteId]];
}
- (NSUInteger)hashForRemote {
	return [[self getRemoteId] intValue] + [NSStringFromClass([self class]) hash];
}

#pragma mark Methods for users to override

/*
 Override this in your model class to extend or replace the excluded properties
 eg.
 - (NSArray *)excludedPropertyNames {
 NSArray *exclusions = [NSArray arrayWithObjects:@"extraPropertyToExclude", nil];
 return [[super excludedPropertyNames] arrayByAddingObjectsFromArray:exclusions];
 }
 */
- (NSArray *)excludedPropertyNames {
  // exclude id , created_at , updated_at, the Three20 NSObjectAdditions category property URLValue 
  return [NSArray arrayWithObjects:[self getRemoteClassIdName],@"createdAt",@"updatedAt",@"URLValue",nil]; 
}

//Override if some other entity needs to be delegate.
- (id<TTResourceDelegate>)useResourceDelegate {
  return self;
}

#pragma mark -
#pragma mark TTResourceDelegate

- (void)request:(TTURLRequest*)request completedAction:(TTResourceActionType)action onObjects:(NSArray*)objects {
  TTLOG(@"TTResourceActionType[%d] successfull completed for objects:[%@]",action, [objects description]);  
}

- (void)request:(TTURLRequest*)request failedAction:(TTResourceActionType)action onObjects:(NSArray*)objects withError:(NSError*)error {
  TTLOG(@"TTResourceActionType[%d] failed with error['%@'] for objects:[%@]",action, [error localizedDescription],[objects description]);
}


@end