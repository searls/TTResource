//
//  Dog.h
//  active_resource
//
//  Created by vickeryj on 8/21/08.
//  Copyright 2008 Joshua Vickery. All rights reserved.
//

#import "TTResource.h"

@interface Dog : NSObject {
	
	NSString * _name;
  NSString * _dogId;
	NSString * _personId;
  NSDate   * _updatedAt;
  NSDate   * _createdAt;
  
}

@property (nonatomic , retain) NSDate *createdAt;
@property (nonatomic , retain) NSDate  *updatedAt;
@property (nonatomic , retain) NSString  *dogId;
@property (nonatomic , retain) NSString *name;
@property (nonatomic , retain) NSString *personId;
@end
