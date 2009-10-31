//
//  NSObject+TTResourceTests.m
//  TTResource
//
//  Created by Justin Searls on 10/27/09.
//  Copyright 2009 Justin Searls.
//

#import "NSObject+TTResourceTests.h"
#import "TTResource.h"

@implementation NSObject_TTResourceTests

- (void)setUp {
  [TTResourceConfig setSite:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"RailsTestURL"]];
}

- (void)testTruth {
  STAssertTrue(TRUE,@"Truth should be true.");
}






@end
