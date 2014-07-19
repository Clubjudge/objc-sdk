//
//  CJReview.h
//  CJKit
//
//  Created by Bruno Abrantes on 19/05/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJModel.h"
#import "CJAPIRequest.h"

typedef enum {
  kReviewTypeShort,
  kReviewTypeMedium,
  kReviewTypeExpert,
} ReviewType;

@interface CJReview : CJModel

@property (readonly) NSNumber *points;
@property (readonly) NSNumber *targetId;
@property (readonly) NSString *targetType;
@property (readonly) ReviewType type;
@property (readonly) NSNumber *userId;
@property (readonly) NSArray *values;

#pragma mark - Initializers
+ (instancetype)reviewWithInfo:(NSDictionary *)info;

#pragma mark - Helpers
- (CJAPIRequest *)requestForUser;
- (CJAPIRequest *)requestForTarget;

@end
