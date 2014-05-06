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

#ifdef IS_OS_7_OR_LATER
@property (nonatomic, strong) AFHTTPSessionManager *authSessionManager;
#else
@property (nonatomic, strong) AFHTTPRequestOperationManager *authSessionManager;
#endif

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
    [CJEngine setVersion:1];
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
                        success:^(id operation, id responseObject) {
                          NSString *token = responseObject[@"access_token"];
                          [CJEngine setUserToken:token];
                          
                          if (success) {
                            success(token);
                          }
                        }
                        failure:^(id operation, NSError *error) {
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
  
  #ifdef IS_OS_7_OR_LATER
  
  NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
  
  self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url
                                                 sessionConfiguration:sessionConfiguration];
  
  #else
    self.sessionManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
  #endif
  
  self.sessionManager.responseSerializer = [JSONResponseSerializerWithData new];
}

- (void)setupAuthManager
{
  NSURL *url = [NSURL URLWithString:[[CJEngineConfiguration sharedConfiguration] authAPIBaseURL]];
  
  NSAssert(url, @"Base Auth URL not valid: %@", url);
  
  #ifdef IS_OS_7_OR_LATER
  
  NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
  self.authSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url
                                                     sessionConfiguration:sessionConfiguration];
  
  #else
    self.authSessionManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
  #endif
  
  self.authSessionManager.responseSerializer = [JSONResponseSerializerWithData new];
}

@end
