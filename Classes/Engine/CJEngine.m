//
//  CJEngine.m
//  CJKit
//
//  Created by Bruno Abrantes on 14/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJEngine.h"
#import "CJUser.h"
#import "CJCity.h"

enum
{
  CJAPISessionManagerMainManager = 0,
  CJAPISessionManagerAuthManager = 1
};
typedef NSUInteger CJAPISessionManager;

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
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [CJEngine setVersion:1];
    [self setCachePolicy:CJAPIRequestUseProtocolCachePolicy];
  }
  
  return self;
}

#pragma mark - Authentication

- (void)authenticateWithFacebookToken:(NSString *)facebookToken
                          withSuccess:(CJLoginSuccessBlock)success
                           andFailure:(CJLoginFailureBlock)failure
{
  [self.authSessionManager POST:@"tokens"
                     parameters:@{@"facebook_token": facebookToken, @"app_key": [self clientKey]}
                        success:^(id operation, id responseObject) {
                          NSString *token = responseObject[@"token"];
                          [self setUserToken:token];
                          
                          if (success) {
                            success(token);
                          }
                        }
                        failure:^(id operation, NSError *error) {
                          [self setUserToken:nil];
                          
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
  [self.authSessionManager POST:@"tokens"
                     parameters:@{@"email": username, @"password": password, @"app_key": [self clientKey]}
                        success:^(id operation, id responseObject) {
                          NSString *token = responseObject[@"token"];
                          [self setUserToken:token];
                          
                          if (success) {
                            success(token);
                          }
                        }
                        failure:^(id operation, NSError *error) {
                          [self setUserToken:nil];
                          
                          if (failure) {
                            failure(error);
                          }
                        }];
}

- (void)registerWithUser:(CJUser *)user
             withSuccess:(CJRegisterSuccessBlock)success
              andFailure:(CJRegisterFailureBlock)failure
{
  NSString *username = user.email;
  NSString *password = user.password;
  NSString *firstName = user.firstName;
  NSString *lastName = user.lastName;
    CJCity *city = [CJCity cityWithInfo:user.city];
  
  [self.authSessionManager POST:@"users"
                     parameters:@{
                                  @"email": username,
                                  @"password": password,
                                  @"first_name": firstName,
                                  @"last_name": lastName,
                                  @"city": @{@"id": city.Id},
                                  @"app_key": [self clientKey]
                                  }
                        success:^(id operation, id responseObject) {
                          CJUser *user = [[CJUser alloc] initWithInfo:responseObject[@"user"]];
                          
                          if (success) {
                            success(user);
                          }
                        }
                        failure:^(id operation, NSError *error) {
                          if (failure) {
                            failure(error);
                          }
                        }];
}

#pragma mark - Custom

- (void)setCachePolicy:(CJAPIRequestCachePolicy)cachePolicy
{
  _cachePolicy = cachePolicy;
  
  self.sessionManager.requestSerializer.cachePolicy = [self cachePolicyForManager:CJAPISessionManagerMainManager];
}

- (void)setupSessionManager
{
  NSURL *url = [NSURL URLWithString:[self apiURL]];
  
  NSAssert(url, @"Base URL not valid: %@", url);
  
  #ifdef IS_OS_7_OR_LATER
  
  NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
  
  self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url
                                                 sessionConfiguration:sessionConfiguration];
  
  #else
    self.sessionManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
  #endif
  
  self.sessionManager.responseSerializer = [JSONResponseSerializerWithData new];
  self.sessionManager.requestSerializer = [self requestSerializerForManager:CJAPISessionManagerMainManager];
}

- (void)setupAuthManager
{
  NSURL *url = [NSURL URLWithString:[self authURL]];
  
  NSAssert(url, @"Base Auth URL not valid: %@", url);
  
  #ifdef IS_OS_7_OR_LATER
  
  NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
  self.authSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url
                                                     sessionConfiguration:sessionConfiguration];
  
  #else
    self.authSessionManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
  #endif
  
  self.authSessionManager.responseSerializer = [JSONResponseSerializerWithData new];
  self.authSessionManager.requestSerializer = [self requestSerializerForManager:CJAPISessionManagerAuthManager];
}

- (AFHTTPRequestSerializer *)requestSerializerForManager:(NSInteger)manager
{
  CJAPIRequestSerializer *serializer = [[CJAPIRequestSerializer alloc] init];
  serializer.cachePolicy = [self cachePolicyForManager:manager];
  
  return serializer;
}

- (NSInteger)cachePolicyForManager:(NSInteger)manager
{
  NSURLRequestCachePolicy cachePolicy;
  
  switch (manager) {
    case CJAPISessionManagerMainManager: {
      cachePolicy = self.cachePolicy;
      
      if (cachePolicy == CJAPIRequestReturnCacheDataThenLoad) {
        cachePolicy = NSURLRequestReturnCacheDataElseLoad;
      }
      
      break;
    }
      
    case CJAPISessionManagerAuthManager:
      cachePolicy = CJAPIRequestReloadIgnoringCacheData;
      break;
      
    default:
      cachePolicy = CJAPIRequestUseProtocolCachePolicy;
  }
  
  return cachePolicy;
}

@end
