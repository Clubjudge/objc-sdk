//
//  CJEngine.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 14/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJEngine.h"
#import "CJEngineConfiguration.h"

@interface CJEngine()

@property (nonatomic, strong) AFHTTPSessionManager *authSessionManager;

@end

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
    [self setupSessionManager];
    [self setupAuthManager];
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

#pragma mark - Authentication

- (void)authenticateWithFacebookToken:(NSString *)facebookToken
                          withSuccess:(CJLoginSuccessBlock)success
                           andFailure:(CJLoginFailureBlock)failure
{
  [self.authSessionManager POST:@"facebook_token"
                     parameters:@{@"token": facebookToken}
                        success:^(NSURLSessionDataTask *task, id responseObject) {
                          NSString *token = responseObject[@"access_token"];
                          [CJEngine setUserToken:token];
                          
                          if (success) {
                            success(token);
                          }
                        }
                        failure:^(NSURLSessionDataTask *task, NSError *error) {
                          [CJEngine setUserToken:nil];
                          
                          if (failure) {
                            failure(error);
                          }
                        }];
}

- (void)authenticateWithUsername:(NSString *)username
                     andPassword:(NSString *)password
                     withSuccess:(CJLoginSuccessBlock)success
                      andFailure:(CJLoginFailureBlock)failure
{
  NSLog(@"Authenticating with username/password is not implemented yet!");
}

#pragma mark - Custom
- (void)setupSessionManager
{
  NSURL *url = [NSURL URLWithString:[[CJEngineConfiguration sharedConfiguration] APIBaseURL]];
  
  NSAssert(url, @"Base URL not valid: %@", url);
  
  NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
  
  self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url
                                                 sessionConfiguration:sessionConfiguration];
  
  self.sessionManager.responseSerializer = [JSONResponseSerializerWithData new];
}

- (void)setupAuthManager
{
  NSURL *url = [NSURL URLWithString:[[CJEngineConfiguration sharedConfiguration] authAPIBaseURL]];
  
  NSAssert(url, @"Base Auth URL not valid: %@", url);
  
  NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
  self.authSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url
                                                     sessionConfiguration:sessionConfiguration];
  
  self.authSessionManager.responseSerializer = [JSONResponseSerializerWithData new];
}

@end
