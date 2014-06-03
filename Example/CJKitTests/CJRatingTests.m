//
//  CJRatingTests.m
//  CJKit
//
//  Created by Bruno Abrantes on 24/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <CJKit/CJRating.h>

SPEC_BEGIN(CJRATINGSPEC)

describe(@"Rating Model", ^{
  NSDictionary *stub = @{
                         @"id": @"crowd",
                         @"score": @7.5
                         };
  
  NSDictionary *textStub = @{
                         @"id": @"crowd",
                         @"score": @"Lorem ipsum"
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
    
    context(@"When score is a number", ^{
      describe(@"#score", ^{
        it(@"produces a correct mapping", ^{
          [[rating.score should] equal:stub[@"score"]];
        });
      });
    });
    
    context(@"When score is a string", ^{
      beforeEach(^{
        rating = [[CJRating alloc] initWithInfo:textStub];
      });
      
      describe(@"#textReview", ^{
        it(@"produces a correct mapping", ^{
          [[rating.textReview should] equal:textStub[@"score"]];
        });
      });
    });
  });
});

SPEC_END
