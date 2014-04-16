//
//  CJAPIRequest.h
//  CJAPIClient
//
//  Created by Bruno Abrantes on 16/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJEngine.h"

typedef void (^CJFailureBlock)(NSError* error);

@interface CJAPIRequest : NSObject

@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSArray *embeds;
@property (nonatomic, strong) NSArray *fields;
@property (nonatomic, strong) NSDictionary *parameters;

#pragma mark - Initialisers
- (instancetype)initWithMethod:(NSString *)method
                       andPath:(NSString *)path;

#pragma mark - Actions
- (void)performWithSuccess:(void (^)(id response, id pagination, id links))success
                   failure:(CJFailureBlock)failure;

@end
