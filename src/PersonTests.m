//
//  PersonTests.m
//  TTResource
//
//  Created by Justin Searls on 10/31/09.
//  Copyright 2009 Justin Searls. All rights reserved.
//

#import "PersonTests.h"
#import "TTResource.h"
#import "Person.h"

@interface PersonTests()

- (void)waitForRequestToComplete:(TTURLRequest*)request;

@end


@implementation PersonTests

- (void)setUp {
  [TTResourceConfig setSite:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"RailsTestURL"]];
}

- (void)waitForRequestToComplete:(TTURLRequest*)request {
  NSRunLoop *theRL = [NSRunLoop currentRunLoop];
  while (request.isLoading && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);  
}

- (void) testSimlePersonCRUD {
  Person *bob = [[[Person alloc] init] autorelease];
  bob.name = @"Bob";
  [self waitForRequestToComplete:[bob createRemote]]; 

  
  //Now Verify
  STAssertNotNil(bob.personId, @"the person ID should be populated upon return from the server.");
}


@end
