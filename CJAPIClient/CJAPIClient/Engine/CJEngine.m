//
//  CJEngine.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 14/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJEngine.h"
#import "CJEngineConfiguration.h"

@implementation CJEngine

#pragma mark - Initialisers

+ (CJEngine *)sharedEngine
{
  static CJEngine *sharedEngine = nil;
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    sharedEngine = [[self alloc] init];
  });
  
  return sharedEngine;
}

- (id)init
{
  if (self = [super init]) {
    NSURL *url = [NSURL URLWithString:[[CJEngineConfiguration sharedConfiguration] APIBaseURL]];
    
    NSAssert(url, @"Base URL not valid: %@", url);
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url
                                                   sessionConfiguration:sessionConfiguration];

    self.sessionManager.responseSerializer = [AFJSONResponseSerializer new];
  }
  
  return self;
}


#pragma mark - Environment
- (void)setEnvironment:(NSString *)environment
{
  [CJEngineConfiguration setEnvironment:environment];
}

#pragma mark - Client Key

static NSString* theClientKey = nil;
+ (NSString *)clientKey
{
  return theClientKey;
}

+ (void)setClientKey:(NSString *)clientKey
{
  theClientKey = clientKey;
}

#pragma mark - User Token

static NSString* theUserToken = nil;
+ (NSString *)userToken
{
  return theUserToken;
}

+ (void)setUserToken:(NSString *)userToken
{
  theUserToken = userToken;
}

@end
