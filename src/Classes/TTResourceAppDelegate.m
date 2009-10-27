//
//  TTResourceAppDelegate.m
//  TTResource
//
//  Created by Justin Searls on 10/27/09.
//  Copyright Crowe Horwath 2009. All rights reserved.
//

#import "TTResourceAppDelegate.h"
#import "RootViewController.h"


@implementation TTResourceAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

