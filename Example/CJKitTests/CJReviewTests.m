//
//  CJReviewTests.m
//  CJKit
//
//  Created by Bruno Abrantes on 20/05/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <CJKit/CJReview.h>
#import <CJKit/CJRating.h>
#import <CJKit/CJAPIRequest.h>
#import <CJKit/CJUser.h>
#import <CJKit/CJVenue.h>
#import <CJKit/CJEngineConfiguration.h>

SPEC_BEGIN(CJREVIEWSPEC)

describe(@"Review Model", ^{
  NSDictionary *stub = @{
                         @"id": @"b9108e81436aed16",
                         @"points": @13,
                         @"targetId": @2150,
                         @"targetType": @"venue",
                         @"type": @"medium",
                         @"userId": @443,
                         @"values": @[
                                      @{
                                        @"id": @"entertainment",
                                        @"score": @10
                                      },
                                      @{
                                        @"id": @"crowd",
                                        @"score": @2
                                      },
                                      @{
                                        @"id": @"facilities",
                                        @"score": @6
                                      },
                                      @{
                                        @"id": @"musicAndLineup",
                                        @"score": @6
                                      },
                                      @{
                                        @"id": @"global",
                                        @"score": @5.885714285714286
                                      }
                                    ]
                         };
  
  __block CJReview *review;
  beforeAll(^{
    review = [[CJReview alloc] initWithInfo:stub];
  });
  
  context(@"Mapping", ^{
    describe(@"#Id", ^{
      it(@"produces a correct mapping", ^{
        [[review.Id should] equal:stub[@"id"]];
      });
    });
    
    describe(@"#points", ^{
      it(@"produces a correct mapping", ^{
        [[review.points should] equal:stub[@"points"]];
      });
    });
    
    describe(@"#targetId", ^{
      it(@"produces a correct mapping", ^{
        [[review.targetId should] equal:stub[@"targetId"]];
      });
    });
    
    describe(@"#targetType", ^{
      it(@"produces a correct mapping", ^{
        [[review.targetType should] equal:stub[@"targetType"]];
      });
    });
    
    describe(@"#type", ^{
      it(@"produces a correct mapping", ^{
        [[theValue(review.type) should] equal:theValue(kReviewTypeMedium)];
      });
    });
    
    describe(@"#userId", ^{
      it(@"produces a correct mapping", ^{
        [[review.userId should] equal:stub[@"userId"]];
      });
    });
    
    describe(@"#values", ^{
      it(@"produces a correct mapping", ^{
        [[review.values[0] should] beKindOfClass:[CJRating class]];
      });
    });
  });
  
  describe(@"#requestForUser", ^{
    it(@"sets the correct path", ^{
      CJAPIRequest *request = [review requestForUser];
      NSString *version = [CJEngineConfiguration sharedConfiguration].APIVersion;
      
      [[request.path should] equal:[NSString stringWithFormat:@"/%@/users/443.json", version]];
    });
    
    it(@"sets the correct model class", ^{
      CJAPIRequest *request = [review requestForUser];
      [[theValue(request.modelClass) should] equal:theValue([CJUser class])];
    });
  });
  
  describe(@"#requestForTarget", ^{
    it(@"sets the correct path", ^{
      CJAPIRequest *request = [review requestForTarget];
      NSString *version = [CJEngineConfiguration sharedConfiguration].APIVersion;
      
      [[request.path should] equal:[NSString stringWithFormat:@"/%@/venues/2150.json", version]];
    });
    
    it(@"sets the correct model class", ^{
      CJAPIRequest *request = [review requestForTarget];
      [[theValue(request.modelClass) should] equal:theValue([CJVenue class])];
    });
  });
});

SPEC_END

