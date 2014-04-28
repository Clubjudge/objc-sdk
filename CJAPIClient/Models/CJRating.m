//
//  CJRating.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 24/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJRating.h"

@implementation CJRating

- (instancetype)initWithInfo:(NSDictionary *)info
{
  self = [super initWithInfo:info];
  if (self && info) {
    // Core properties
    _score = info[kRatingScore];
  }
  return self;
}

@end
