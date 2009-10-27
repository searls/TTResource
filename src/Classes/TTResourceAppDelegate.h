//
//  TTResourceAppDelegate.h
//  TTResource
//
//  Created by Justin Searls on 10/27/09.
//  Copyright Crowe Horwath 2009. All rights reserved.
//

@interface TTResourceAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

