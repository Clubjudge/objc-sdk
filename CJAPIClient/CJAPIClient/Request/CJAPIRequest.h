//
//  CJAPIRequest.h
//  CJAPIClient
//
//  Created by Bruno Abrantes on 16/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJEngine.h"

@interface CJAPIRequest : NSObject

@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *path;

#pragma mark - Initialisers
- (instancetype)initWithMethod:(NSString *)method andPath:(NSString *)path;

@end
