//
//  CJAPIRequest.h
//  CJAPIClient
//
//  Created by Bruno Abrantes on 16/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJEngine.h"
#import "CJPaginationInfo.h"
@class CJLinksInfo;

typedef void (^CJFailureBlock)(NSDictionary* error, NSNumber *statusCode);

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
- (void)performWithSuccess:(void (^)(id response, CJPaginationInfo *pagination, CJLinksInfo *links))success
                   failure:(CJFailureBlock)failure;

#pragma mark - Parameters
- (NSDictionary *)prepareParameters;

@end
