//
//  CJMe.h
//  CJAPIClient
//
//  Created by Bruno Abrantes on 24/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJUser.h"
@class CJAPIRequest;

@interface CJMe : CJUser

#pragma mark - Core properties
@property(nonatomic, strong) NSDictionary *preferences;

#pragma mark - Actions
- (CJAPIRequest *)requestForUpdate;

@end

#define kMePreferences @"preferences"
