//
//  CJAPIRequest.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 16/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJAPIRequest.h"
#import <AFNetworking/AFHTTPSessionManager.h>

NSString *const kRequestMethodGET = @"GET";
NSString *const kRequestMethodPOST = @"POST";
NSString *const kRequestMethodPUT = @"PUT";
NSString *const kRequestMethodDELETE = @"DELETE";
NSString *const kRequestPathPrefix = @"/";

@interface CJAPIRequest()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation CJAPIRequest

#pragma mark - Initialisers

- (instancetype)initWithMethod:(NSString *)method
                       andPath:(NSString *)path
{
  if (self = [self init]) {
    [self setMethod:method];
    [self setPath:path];
    self.sessionManager = [[CJEngine sharedEngine] sessionManager];
  }
  
  return self;
}

- (instancetype)init
{
  if (self = [super init]) {
    _method = kRequestMethodGET;
    _path = kRequestPathPrefix;
  }
  
  return self;
}


#pragma mark - Custom setters

- (void)setMethod:(NSString *)method
{
  NSArray *methods = @[kRequestMethodGET, kRequestMethodPOST, kRequestMethodPUT, kRequestMethodDELETE];
  method = [method uppercaseString];
  
  NSAssert([methods containsObject:method], @"%@ is not a supported method", method);
  
  _method = method;
}

- (void)setPath:(NSString *)path
{
  unless([path hasPrefix:kRequestPathPrefix]) {
    path = [kRequestPathPrefix stringByAppendingString:path];
  }
  
  _path = path;
}

#pragma mark - Actions

- (void)performWithSuccess:(void (^)(id response, id pagination, id links))success
                   failure:(CJFailureBlock)failure
{
  void (^selectedMethod)() = @{
                             kRequestMethodGET : ^{
                               [self GETWithSuccess:success
                                            failure:failure];
                             },
                             kRequestMethodPOST : ^{
                               NSLog(@"POST method not implemented yet");
                             },
                             kRequestMethodPUT : ^{
                               NSLog(@"PUT method not implemented yet");
                             },
                             kRequestMethodDELETE : ^{
                               NSLog(@"DELETE method not implemented yet");
                             }
                             }[self.method];
  
  selectedMethod();
}

- (void)GETWithSuccess:(void (^)(id response, id pagination, id links))success
               failure:(CJFailureBlock)failure
{

}

@end
