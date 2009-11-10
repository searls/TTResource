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
  /*xxtodo - Creates Bob in the remote, but still thinks HTTP 201 is an error:
   
   TTResourceSample[3628:207] ERROR: Error Domain=NSURLErrorDomain Code=201 
   "Operation could not be completed. (NSURLErrorDomain error 201.)"
   
   */
  
  
  
}


- (void)dealloc {
  [window release];
  [super dealloc];
}


@end
