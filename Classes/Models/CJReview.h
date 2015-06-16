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

@property (nonatomic, strong) NSNumber *points;
@property (nonatomic, strong) NSNumber *targetId;
@property (nonatomic, strong) NSString *targetType;
@property (nonatomic, assign) ReviewType type;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSArray *values;

#pragma mark - Initializers
+ (instancetype)reviewWithInfo:(NSDictionary *)info;

#pragma mark - Helpers
- (CJAPIRequest *)requestForUser;
- (CJAPIRequest *)requestForTarget;
- (NSString *)textRating;

@end
