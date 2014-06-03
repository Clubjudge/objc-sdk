//
//  CJPaginationInfo.m
//  CJKit
//
//  Created by Bruno Abrantes on 22/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJPaginationInfo.h"

@implementation CJPaginationInfo

static NSString *kCurrentPage = @"currentPage";
static NSString *kPerPage = @"perPage";
static NSString *kTotalPages = @"totalPages";
static NSString *kTotalItems = @"totalItems";

- (instancetype) initWithInfo:(NSDictionary *)info
{
  self = [super init];
  
  if (self && info) {
    
    _currentPage = info[kCurrentPage];
    _perPage = info[kPerPage];
    _totalPages = info[kTotalPages];
    _totalItems = info[kTotalItems];
    
    return self;
  }
  
  return nil;
}

@end
