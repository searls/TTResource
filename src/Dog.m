//
//  Dog.m
//  active_resource
//
//  Created by vickeryj on 8/21/08.
//  Copyright 2008 Joshua Vickery. All rights reserved.
//

#import "Dog.h"
#import "Person.h"
#import "TTResource.h"

@implementation Dog

@synthesize name=_name, dogId=_dogId, createdAt=_createdAt, 
            updatedAt=_updatedAt, personId=_personId;

- (void) dealloc {
  [_createdAt release];
  [_updatedAt release];
  [_dogId release];
	[_name release];
	[_personId release];
	[super dealloc];
}


#pragma mark -
#pragma mark NSObject(ObjectiveResource)

+ (NSString *)getRemoteCollectionPath {
  //Meaningless without a person instance.
  [[NSException exceptionWithName:@"Dog collections must be invoked on a dog instance, not the Dog class." 
                           reason:@"Dogs are nested beneath people, so to retrieve a collection of dogs, a personId must be known." 
                         userInfo:nil] 
   raise];
  return nil;
}

- (NSString*)getRemoteCollectionPath {
  return [NSString stringWithFormat:@"%@%@/%@/%@%@", 
          [[self class] getRemoteSite],
          [Person getRemoteCollectionName],
          _personId,
          [[self class] getRemoteCollectionName],
          [[self class] getRemoteProtocolExtension]];  
}

@end
