//
//  CJPaginationInfoTests.m
//  CJKit
//
//  Created by Bruno Abrantes on 22/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <CJKit/CJPaginationInfo.h>

SPEC_BEGIN(CJPAGINATIONINFOSPEC)

describe(@"Pagination Info", ^{
  __block NSDictionary *paginationData;
  __block CJPaginationInfo *paginationInfo;
  beforeAll(^{
    paginationData = @{
                       @"currentPage": @1,
                       @"perPage": @10,
                       @"totalPages": @1,
                       @"totalItems": @5
                       };
    
    paginationInfo = [[CJPaginationInfo alloc] initWithInfo:paginationData];
  });
  
  describe(@".paginationWithInfo", ^{
    it(@"returns a new instance of CJPaginationInfo with the supplied data", ^{
      CJPaginationInfo *paginationInfo = [CJPaginationInfo paginationWithInfo:paginationData];
      
      [[paginationInfo.currentPage should] equal:paginationData[@"currentPage"]];
    });
  });
  
  context(@"When initializing", ^{
    it(@"returns nil if pagination info is null", ^{
      CJPaginationInfo *paginationInfo = [[CJPaginationInfo alloc] initWithInfo:nil];
      
      [[paginationInfo should] beNil];
    });
    
    it(@"correctly assigns the currentPage property", ^{
      [[paginationInfo.currentPage should] equal:paginationData[@"currentPage"]];
    });
    
    it(@"correctly assigns the perPage property", ^{
      [[paginationInfo.perPage should] equal:paginationData[@"perPage"]];
    });
    
    it(@"correctly assigns the totalPages property", ^{
      [[paginationInfo.totalPages should] equal:paginationData[@"totalPages"]];
    });
    
    it(@"correctly assigns the totalItems property", ^{
      [[paginationInfo.totalItems should] equal:paginationData[@"totalItems"]];
    });
  });
});

SPEC_END
