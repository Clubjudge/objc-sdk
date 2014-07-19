//
//  CJLinksInfo.h
//  CJKit
//
//  Created by Bruno Abrantes on 22/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CJAPIRequest;

@interface CJLinksInfo : NSObject

@property (readonly) NSDictionary *links;
@property (nonatomic, strong) NSDictionary *mapping;

#pragma mark - Initializers

+ (instancetype)linksWithInfo:(NSDictionary *)info;
- (instancetype)initWithInfo:(NSDictionary *)info;

#pragma mark - Request

- (CJAPIRequest *)requestForLink:(NSString *)link;

@end