//
//  CJModelTests.m
//  CJKit
//
//  Created by Bruno Abrantes on 21/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <CJKit/CJModel.h>

SPEC_BEGIN(CJMODELSPEC)

describe(@"CJ Model", ^{
  describe(@"#initWithInfo", ^{
    it(@"assigns \"id\" from the dictionary to the Id property", ^{
      CJModel *model = [[CJModel alloc] initWithInfo:@{
                                                       @"id": @55
                                                       }];
      
      [[model.Id should] equal:theValue(55)];
    });
  });
});

SPEC_END
