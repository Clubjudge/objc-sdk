//
//  CJRating.h
//  CJAPIClient
//
//  Created by Bruno Abrantes on 24/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJModel.h"

@interface CJRating : CJModel

#pragma mark - Core properties
@property (nonatomic, strong) NSString* Id;
@property (nonatomic, readonly) NSNumber *score;
@property (nonatomic, readonly) NSString *textReview;

@end
