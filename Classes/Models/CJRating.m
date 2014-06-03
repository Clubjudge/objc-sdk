//
//  CJRating.m
//  CJKit
//
//  Created by Bruno Abrantes on 24/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJRating.h"

@implementation CJRating

static NSString *kRatingScore = @"score";

- (instancetype)initWithInfo:(NSDictionary *)info
{
  self = [super initWithInfo:info];
  if (self && info) {
    // Core properties
    if ([info[kRatingScore] isKindOfClass:[NSNumber class]]) {
      _score = info[kRatingScore];
    } else if ([info[kRatingScore] isKindOfClass:[NSString class]]) {
      _textReview = info[kRatingScore];
    }
  }
  return self;
}

@end
