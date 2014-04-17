//
//  CJAPIRequest.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 16/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJAPIRequest.h"
#import <AFNetworking/AFHTTPSessionManager.h>

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
    _method = @"GET";
    _path = @"/";
  }
  
  return self;
}


#pragma mark - Custom setters

- (void)setMethod:(NSString *)method
{
  NSArray *methods = @[@"GET", @"POST", @"PUT", @"DELETE"];
  method = [method uppercaseString];
  
  NSAssert([methods containsObject:method], @"%@ is not a supported method", method);
  
  _method = method;
}

- (void)setPath:(NSString *)path
{
  unless([path hasPrefix:@"/"]) {
    path = [@"/" stringByAppendingString:path];
  }
  
  _path = path;
}

#pragma mark - Actions

- (void)performWithSuccess:(void (^)(id response, id pagination, id links))success
                   failure:(CJFailureBlock)failure
{

}

@end
