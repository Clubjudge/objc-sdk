//
//  CJRatingTests.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 24/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CJRating.h"

SPEC_BEGIN(CJRATINGSPEC)

describe(@"Rating Model", ^{
  NSDictionary *stub = @{
                         @"id": @"crowd",
                         @"score": @7.5
                         };
  
  __block CJRating *rating;
  beforeAll(^{
    rating = [[CJRating alloc] initWithInfo:stub];
  });
  
  context(@"Mapping", ^{
    describe(@"#Id", ^{
      it(@"produces a correct mapping", ^{
        [[rating.Id should] equal:stub[@"id"]];
      });
    });
    
    describe(@"#score", ^{
      it(@"produces a correct mapping", ^{
        [[rating.score should] equal:stub[@"score"]];
      });
    });
  });
});

SPEC_END
