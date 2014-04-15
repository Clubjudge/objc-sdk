//
//  CJEngineConfiguration.h
//  CJAPIClient
//
//  Created by Bruno Abrantes on 14/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJEngineConfiguration : NSObject

#pragma mark - Initialisers
+ (CJEngineConfiguration *)sharedConfiguration;

#pragma mark - Environment
+ (NSString *)environment;
+ (void)setEnvironment:(NSString *)environment;

#pragma mark - Configuration keys
- (NSDictionary *)configurationForEnvironment:(NSString *)environment;

#pragma mark - Keys
- (NSString *)APIVersion;
- (NSString *)APIBaseURL;

@end
