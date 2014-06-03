//
//  CJEngineConfiguration.h
//  CJKit
//
//  Created by Bruno Abrantes on 14/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

/**
 `CJEngineConfiguration` is a singleton that provides core configuration for CJKit.
 */

#import <Foundation/Foundation.h>

@interface CJEngineConfiguration : NSObject

///---------------------
/// @name Initialization
///---------------------

#pragma mark - Initialisers
/**
 Creates and returns a `CJEngineConfiguration` object.
 */
+ (CJEngineConfiguration *)sharedConfiguration;

///---------------------
/// @name Environment
///---------------------

#pragma mark - Environment

/**
  Gets the current environment (development, staging, production)
 */
+ (NSString *)environment;

/**
 Sets the current environment (development, staging, production)
 */
+ (void)setEnvironment:(NSString *)environment;

///---------------------
/// @name Configuration Keys
///---------------------
#pragma mark - Configuration keys
/**
 Gets all the configuration keys for a given environment (development, staging, production)
 */
- (NSDictionary *)configurationForEnvironment:(NSString *)environment;

#pragma mark - Keys
/**
 Gets the API version for the current environment
 */
- (NSString *)APIVersion;

/**
 Gets the API base URL for the current environment
 */
- (NSString *)APIBaseURL;

/**
 Gets the Auth API base URL for the current environment
 */
- (NSString *)authAPIBaseURL;

@end
