//
//  CJMe.h
//  CJKit
//
//  Created by Bruno Abrantes on 24/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJUser.h"
@class CJAPIRequest;

@interface CJMe : CJUser

#pragma mark - Core properties
@property(nonatomic, strong) NSDictionary *preferences;

#pragma mark - Initializers
+ (instancetype)meWithInfo:(NSDictionary *)info;

#pragma mark - Actions
- (CJAPIRequest *)requestForUpdate;

@end
