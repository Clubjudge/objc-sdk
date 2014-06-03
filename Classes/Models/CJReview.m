//
//  CJReview.m
//  CJKit
//
//  Created by Bruno Abrantes on 19/05/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJReview.h"
#import "CJRating.h"
#import "CJUser.h"
#import "CJVenue.h"
#import "CJEvent.h"
#import <ObjectiveSugar/ObjectiveSugar.h>

@implementation CJReview

static NSString *kReviewPoints = @"points";
static NSString *kReviewTargetId = @"targetId";
static NSString *kReviewTargetType = @"targetType";
static NSString *kReviewType = @"type";
static NSString *kReviewUserId = @"userId";
static NSString *kReviewValues = @"values";

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
  CJAPIRequest *request = [[CJAPIRequest alloc] initWithMethod:@"GET"
                                                       andPath:[NSString stringWithFormat:@"/%@s/%@", self.targetType, self.targetId]];
  request.modelClass = [self classForTargetType:self.targetType];
  
  return request;
}

- (CJAPIRequest *)requestForUser
{
  CJAPIRequest *request =[[CJAPIRequest alloc] initWithMethod:@"GET"
                                                      andPath:[NSString stringWithFormat:@"/users/%@", self.userId]];
  request.modelClass = [CJUser class];
  
  return request;
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

- (Class)classForTargetType:(NSString *)type
{
  Class class = [CJVenue class];
  
  if ([type isEqualToString:@"event"]) {
    class = [CJEvent class];
  }
  
  return class;
}

@end
