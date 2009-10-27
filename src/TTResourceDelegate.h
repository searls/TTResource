//
//  TTResourceDelegate.h
//  TTResource
//
//  Created by Justin Searls on 10/27/09.
//  Copyright 2009 Justin Searls. All rights reserved.
//

#import <Three20/Three20.h>

typedef enum {  
  TTResourceActionCreate,
  TTResourceActionFind,  
  TTResourceActionUpdate,
  TTResourceActionDestroy,
} TTResourceActionType;

@protocol TTResourceDelegate<NSObject>

@optional
- (void)request:(TTURLRequest*)request completedAction:(TTResourceActionType)action onObjects:(NSArray*)objects;
- (void)request:(TTURLRequest*)request failedAction:(TTResourceActionType)action onObjects:(NSArray*)objects withError:(NSError*)error;

@end
