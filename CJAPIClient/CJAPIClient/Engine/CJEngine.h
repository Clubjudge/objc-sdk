//
//  CJEngine.h
//  CJAPIClient
//
//  Created by Bruno Abrantes on 14/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "JSONResponseSerializerWithData.h"

@interface CJEngine : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

#pragma mark - Initialisers

+ (CJEngine *)sharedEngine;

- (id)init;

#pragma mark - Client Key
+ (NSString *)clientKey;
+ (void)setClientKey:(NSString *)clientKey;

#pragma mark - User Token
+ (NSString *)userToken;
+ (void)setUserToken:(NSString *)userToken;

#pragma mark - Environment
- (void)setEnvironment:(NSString *)environment;

#pragma mark - Authentication
- (void)authenticateWithFacebookToken:(NSString *)facebookToken;
- (void)authenticateWithUsername:(NSString *)username andPassword:(NSString *)password;

@end
