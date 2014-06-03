//
//  CJPaginationInfo.h
//  CJKit
//
//  Created by Bruno Abrantes on 22/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJPaginationInfo : NSObject

@property (readonly) NSNumber *currentPage;
@property (readonly) NSNumber *perPage;
@property (readonly) NSNumber *totalPages;
@property (readonly) NSNumber *totalItems;

- (instancetype)initWithInfo:(NSDictionary *)info;

@end
