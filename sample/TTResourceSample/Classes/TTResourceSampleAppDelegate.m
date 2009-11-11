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
  
  [TTResourceConfig setSite:@"http://localhost:3000/"];
  [TTResourceConfig setResponseType:TTResponseFormatXML];
  
  //Find all the bobs
  //xxtodo
  
  //Delete all the Bobs
  //xxtodo
  
  
  
  //Create a Bob
  Person *bob = [[[Person alloc] init] autorelease];
  bob.name = @"Bob";
  [bob createRemote];  
  
  //Find that bob
  //xxtodo
  
  //Update a Bob
  //xxtodo
  
  //Destroy my bob
  //xxtodo
  
  
  NSLog(@"Finn.");
}


- (void)dealloc {
  [window release];
  [super dealloc];
}


@end
