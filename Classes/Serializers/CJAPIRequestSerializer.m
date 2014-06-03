//
//  CJAPIRequestSerializer.m
//  CJKit
//
//  Created by Bruno Abrantes on 08/05/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJAPIRequestSerializer.h"

@implementation CJAPIRequestSerializer

- (instancetype)initWithCachePolicy:(NSURLRequestCachePolicy)cachePolicy
{
  self = [super init];
  if (self) {
    self.cachePolicy = cachePolicy;
  }
  return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(NSDictionary *)parameters
                                     error:(NSError *__autoreleasing *)error
{
  NSMutableURLRequest *request = [super requestWithMethod:method URLString:URLString parameters:parameters error:error];
  
  if (self.cachePolicy) {
    [request setCachePolicy:self.cachePolicy];
  }
  
  return request;
}

@end
