//
//  CJReview.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 19/05/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJReview.h"
#import "CJRating.h"
#import <ObjectiveSugar/ObjectiveSugar.h>

@implementation CJReview

- (instancetype)initWithInfo:(NSDictionary *)info
{
  self = [super initWithInfo:info];
  if (self && info) {
    // Core properties
    _points = info[kReviewPoints];
    _targetId = info[kReviewTargetId];
    _targetType = info[kReviewTargetType];
    _type = [self typeForString:info[kReviewType]];
    _userId = info[kReviewUserId];
    _values = [info[kReviewValues] map:^CJRating *(NSDictionary *rating) {
      return [[CJRating alloc] initWithInfo:rating];
    }];
  }
  return self;
}

#pragma mark - Helpers
- (CJAPIRequest *)requestForTarget
{
  return[[CJAPIRequest alloc] initWithMethod:@"GET"
                                     andPath:[NSString stringWithFormat:@"/%@s/%@", self.targetType, self.targetId]];
}

- (CJAPIRequest *)requestForUser
{
  return[[CJAPIRequest alloc] initWithMethod:@"GET"
                                     andPath:[NSString stringWithFormat:@"/users/%@", self.userId]];
}

- (ReviewType)typeForString:(NSString *)string
{
  ReviewType type = kReviewTypeMedium;
  
  if ([string isEqualToString:@"expert"]) {
    type = kReviewTypeExpert;
  }
  
  if ([string isEqualToString:@"short"]) {
    type = kReviewTypeShort;
  }
  
  return type;
}

@end
