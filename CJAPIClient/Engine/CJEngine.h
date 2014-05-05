//
//  CJEngine.h
//  CJAPIClient
//
//  Created by Bruno Abrantes on 14/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

/**
  `CJEngine` is a singleton that provides core utilities for CJKit. These include a shared Session Manager, environment, client key and user token facilities as well as user authentication methods.
 */

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "JSONResponseSerializerWithData.h"

@interface CJEngine : NSObject

/**
 The shared `AFHTTPSessionManager` used by all requests to the ClubJudge API.
 
 @warning Requests for user authentication are handled by another, private manager.
 */
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

///---------------------
/// @name Initialization
///---------------------

#pragma mark - Initialisers

/**
 Creates and returns a `CJEngine` object.
 */
+ (CJEngine *)sharedEngine;

///---------------------
/// @name Client Key
///---------------------

#pragma mark - Client Key

/**
 Gets the client key that is used in all requests
 */
+ (NSString *)clientKey;

/**
 Sets the client key to be used in all requests
 */
+ (void)setClientKey:(NSString *)clientKey;

///---------------------
/// @name User Token
///---------------------

#pragma mark - User Token

/**
 Gets the user access token that is used in all requests
 */
+ (NSString *)userToken;

/**
 Sets the user access token to be used in all requests
 */
+ (void)setUserToken:(NSString *)userToken;

///---------------------
/// @name Environment
///---------------------

#pragma mark - Environment
/**
 Sets the environment (development, staging or production) to make requests against
 */
- (void)setEnvironment:(NSString *)environment;

///---------------------
/// @name User Authentication
///---------------------

#pragma mark - Authentication

/**
 A block used for successful login requests. It includes the user's access token. */
typedef void (^CJLoginSuccessBlock)(NSString *token);

/**
 A block used for failed login requests. It contains raw error object.
 */
typedef void (^CJLoginFailureBlock)(NSError *error);

/**
 Requests a user access token given a Facebook OAuth token, with success and failure blocks
 */
- (void)authenticateWithFacebookToken:(NSString *)facebookToken
                          withSuccess:(CJLoginSuccessBlock)success
                           andFailure:(CJLoginFailureBlock)failure;

/**
 Requests a user access token given a username/password combo, with success and failure blocks
 */
- (void)authenticateWithUsername:(NSString *)username
                     andPassword:(NSString *)password
                     withSuccess:(CJLoginSuccessBlock)success
                      andFailure:(CJLoginFailureBlock)failure;
@end
