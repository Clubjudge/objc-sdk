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
#import "NSDate+StringParsing.h"

@implementation CJReview

static NSString *kReviewCreatedAt = @"createdAt";
static NSString *kReviewUpdatedAt = @"updatedAt";
static NSString *kReviewEdited = @"edited";
static NSString *kReviewTitle = @"title";
static NSString *kReviewNegativeComments = @"negativeComments";
static NSString *kReviewPositiveComments = @"positiveComments";
static NSString *kReviewScores = @"scores";
static NSString *kReviewTargetId = @"targetId";
static NSString *kReviewType = @"type";
static NSString *kReviewUserId = @"userId";

#pragma mark - Initializers

+ (instancetype)reviewWithInfo:(NSDictionary *)info
{
  return [[CJReview alloc] initWithInfo:info];
}

- (instancetype)initWithInfo:(NSDictionary *)info
{
  self = [super initWithInfo:info];
  if (self && info) {
      // Core properties
      _createdAt = [NSDate dateWithISO8601String:info[kReviewCreatedAt]];
      _updatedAt = [NSDate dateWithISO8601String:info[kReviewUpdatedAt]];
      _edited = [info[kReviewEdited] boolValue];
      _title = info[kReviewTitle];
      _positiveComments = info[kReviewPositiveComments];
      _negativeComments = info[kReviewNegativeComments];
      _scores = [info[kReviewScores] isEqual:[NSNull null]] ? [NSDictionary new] : info[kReviewScores];
      _targetId = info[kReviewTargetId];
      _type = info[kReviewType];
      _userId = info[kReviewUserId];
  }
  return self;
}

#pragma mark - Helpers

- (CJAPIRequest *)requestForUser
{
  CJAPIRequest *request =[[CJAPIRequest alloc] initWithMethod:@"GET"
                                                      andPath:[NSString stringWithFormat:@"/users/%@", self.userId]];
  request.modelClass = [CJUser class];
  
  return request;
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
