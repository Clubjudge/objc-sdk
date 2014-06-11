//
//  CJEngine.h
//  CJKit
//
//  Created by Bruno Abrantes on 14/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

/**
  `CJEngine` is a singleton that provides core utilities for CJKit. These include a shared Session Manager, environment, client key and user token facilities as well as user authentication methods.
 */

#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#import <Foundation/Foundation.h>

#ifdef IS_OS_7_OR_LATER
  #import <AFNetworking/AFHTTPSessionManager.h>
#else
  #import <AFNetworking/AFHTTPRequestOperationManager.h>
#endif

#import "JSONResponseSerializerWithData.h"
#import "CJAPIRequestSerializer.h"

@class CJUser;

enum
{
  CJAPIRequestUseProtocolCachePolicy = 0,
  
  CJAPIRequestReloadIgnoringLocalCacheData = 1,
  CJAPIRequestReloadIgnoringLocalAndRemoteCacheData = 4, // Unimplemented
  CJAPIRequestReloadIgnoringCacheData = CJAPIRequestReloadIgnoringLocalCacheData,
  
  CJAPIRequestReturnCacheDataElseLoad = 2,
  CJAPIRequestReturnCacheDataDontLoad = 3,
  
  CJAPIRequestReloadRevalidatingCacheData = 5, // Unimplemented
  
  CJAPIRequestReturnCacheDataThenLoad = 6,
};
typedef NSUInteger CJAPIRequestCachePolicy;

@interface CJEngine : NSObject <NSObject>

/**
 The shared request manager used by all requests to the ClubJudge API.
 
 @warning Requests for user authentication are handled by another, private manager.
 */
#ifdef IS_OS_7_OR_LATER
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
#else
@property (nonatomic, strong) AFHTTPRequestOperationManager *sessionManager;
#endif

/**
 The cache policy to use when performing CJAPIRequests. The default is CJAPIRequestUseProtocolCachePolicy, which is the same as NSURLRequestUseProtocolCachePolicy
 */
@property (nonatomic, assign) CJAPIRequestCachePolicy cachePolicy;

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
+ (void)setEnvironment:(NSString *)environment;

///---------------------
/// @name User Authentication
///---------------------

#pragma mark - Authentication

/**
 A block used for successful login requests. It includes the user's access token. */
typedef void (^CJLoginSuccessBlock)(NSString *token);

/**
 A block used for failed login requests. It contains the raw error object.
 */
typedef void (^CJLoginFailureBlock)(NSError *error);

/**
 A block used for successful register requests.
 */
typedef void (^CJRegisterSuccessBlock)();

/**
 A block used for failed login requests. It contains the raw error object.
 */
typedef void (^CJRegisterFailureBlock)(NSError *error);

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

/**
 Registers a new user given a CJUser object.
 */
- (void)registerWithUser:(CJUser *)user
             withSuccess:(CJRegisterSuccessBlock)success
              andFailure:(CJRegisterFailureBlock)failure;

@end
