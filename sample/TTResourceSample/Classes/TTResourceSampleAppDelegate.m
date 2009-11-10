//
//  TTResourceSampleAppDelegate.m
//  TTResourceSample
//
//  Created by Justin Searls on 10/31/09.
//  Copyright Justin Searls 2009. All rights reserved.
//

#import "TTResourceSampleAppDelegate.h"
#import "Person.h"

@implementation TTResourceSampleAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
  
  // Override point for customization after application launch
  [window makeKeyAndVisible];
  
  
  
  //Create Bob
  [TTResourceConfig setSite:@"http://localhost:3000/"];
  [TTResourceConfig setResponseType:TTResponseFormatXML];
  Person *bob = [[[Person alloc] init] autorelease];
  bob.name = @"Bob";
  [bob createRemote];
  
  
  
  
}


- (void)dealloc {
  [window release];
  [super dealloc];
}


@end
