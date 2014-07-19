//
//  CJMe.m
//  CJKit
//
//  Created by Bruno Abrantes on 24/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJMe.h"
#import "CJAPIRequest.h"

@implementation CJMe

static NSString *kMePreferences = @"preferences";

#pragma mark - Initializers

+ (instancetype)meWithInfo:(NSDictionary *)info
{
  return [[CJMe alloc] initWithInfo:info];
}

- (instancetype)initWithInfo:(NSDictionary *)info
{
  self = [super initWithInfo:info];
  if (self && info) {
    // Core properties
    _preferences = info[kMePreferences];
  }
  return self;
}

#pragma mark - Actions
- (CJAPIRequest *)requestForUpdate
{
  CJAPIRequest *request = [[CJAPIRequest alloc] initWithMethod:@"PUT"
                                                       andPath:@"me"];
  
  request.parameters = _preferences;
  
  return request;
}

@end
