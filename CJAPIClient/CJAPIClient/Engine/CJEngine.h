//
//  CJEngine.h
//  CJAPIClient
//
//  Created by Bruno Abrantes on 14/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>

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

@end
