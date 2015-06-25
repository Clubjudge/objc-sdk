//
//  CJReview.h
//  CJKit
//
//  Created by Bruno Abrantes on 19/05/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJModel.h"
#import "CJAPIRequest.h"

@interface CJReview : CJModel

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, assign) BOOL edited;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *negativeComments;
@property (nonatomic, strong) NSString *positiveComments;
@property (nonatomic, strong) NSDictionary *scores;
@property (nonatomic, strong) NSNumber *targetId;
@property (nonatomic, assign) NSString *type;
@property (nonatomic, strong) NSNumber *userId;

#pragma mark - Initializers
+ (instancetype)reviewWithInfo:(NSDictionary *)info;

#pragma mark - Helpers
- (CJAPIRequest *)requestForUser;

@end
