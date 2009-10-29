//
//  TTResourceDelegate.h
//  TTResource
//
//  Created by Justin Searls on 10/27/09.
//  Copyright 2009 Justin Searls. All rights reserved.
//

#import <Three20/Three20.h>

@protocol TTResourceDelegate<NSObject>

@optional

/* This delegate will be invoked to return the results of either of these NSObject+TTResource
    category class methods:

 + (TTURLRequest *)findAllRemote;
 + (TTURLRequest *)findRemote:(NSString *)elementId;
 
 And no, TTResource does nothing to differentiate which one initiated the request here
 (it doesn't keep track of it). However, if the model class really wanted to keep 
 track of its "findAllRemote" results separately from any "findRemote:elementId" 
 results, it could retain and key off the TTURLRequests.
 */
+ (void)foundObjects:(NSArray*)objects forRequest:(TTURLRequest*)request;

/* This delegate will be invoked to return the results of either of these NSObject+TTResource
 category instance methods:
 
 - (TTURLRequest *)createRemote;
 - (TTURLRequest *)createRemoteWithParameters:(NSDictionary *)parameters;
 - (TTURLRequest *)createRemoteAtPath:(NSString *)path;
 
 */
- (void)createdObject:(id)object forRequest:(TTURLRequest*)request;

/* This delegate will be invoked to return the results of either of these NSObject+TTResource
 category instance methods:
 
 - (TTURLRequest *)updateRemote;
 - (TTURLRequest *)updateRemoteAtPath:(NSString *)path;
 
 and maybe even:
 - (TTURLRequest *)saveRemote;
 
 */
- (void)updatedObject:(id)object forRequest:(TTURLRequest*)request;

/* This delegate will be invoked to return the results of either of these NSObject+TTResource
 category instance methods:

 - (TTURLRequest *)destroyRemote;
 - (TTURLRequest *)destroyRemoteAtPath:(NSString *)path;
 
 */
- (void)destroyedObject:(id)object forRequest:(TTURLRequest*)request;

/* Returns the error for any request that failed 
 xxtodo return the object/objects and/or request type?
 */
- (void)requestFailed:(TTURLRequest*)request withError:(NSError*)error;

@end
