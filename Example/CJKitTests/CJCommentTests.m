//
//  CJCommentTests.m
//  CJKit
//
//  Created by Bruno Abrantes on 24/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <CJKit/CJComment.h>
#import <CJKit/CJUser.h>

SPEC_BEGIN(CJCOMMENTSPEC)

describe(@"Comment Model", ^{
  NSDictionary *stub = @{
                         @"id": @"dab8df0390b14949",
                         @"message": @"This is awesome",
                         @"timestamp": @"2014-04-24T15:31:05.785Z",
                         @"user": @{
                             @"id": @443,
                             @"email": @"",
                             @"address": @{
                               @"city": @{
                                 @"id": @"891",
                                 @"name": @"Lisbon",
                                 @"lonLat": @[
                                            @-9.13333,
                                            @38.71667
                                            ],
                                 @"venuesCount": @10
                               },
                               @"country": @{
                                 @"id": @49,
                                 @"name": @"Portugal",
                                 @"isocode": @"PT"
                               },
                               @"region": @{
                                 @"id": @2646,
                                 @"name": @"Lisbon",
                                 @"isocode": [NSNull null]
                               },
                               @"composedName": @"Lisbon,Portugal"
                             },
                             @"firstName": @"Bruno",
                             @"lastName": @"Abrantes",
                             @"fullName": @"Bruno Abrantes",
                             @"avatarUrl": @"https://graph.facebook.com/628632955/picture?type=large&width=150&height=150",
                             @"createdAt": [NSNull null],
                             @"reviewsCount": @0,
                             @"expertReviewsCount": @0,
                             @"friendsCount": @0,
                             @"mutualFriendsCount": @0,
                             @"isFriend": @NO,
                             @"isPendingFriend": @NO,
                             @"upcomingEventsCount": @0,
                             @"pastEventsCount": @0,
                             @"score": @{
                             },
                             @"gender": @"",
                             @"bornOn": [NSNull null]
                             }
                         };
  
  __block CJComment *comment;
  beforeEach(^{
    comment = [[CJComment alloc] initWithInfo:stub];
  });
  
  describe(@".commentWithInfo:", ^{
    it(@"Returns a new instance of a CJComment with the provided info", ^{
      comment = [CJComment commentWithInfo:stub];
      
      [[comment.Id should] equal:stub[@"id"]];
    });
  });
  
  context(@"Mapping", ^{
    describe(@"#Id", ^{
      it(@"produces a correct mapping", ^{
        [[comment.Id should] equal:stub[@"id"]];
      });
    });
    
    describe(@"#message", ^{
      it(@"produces a correct mapping", ^{
        [[comment.message should] equal:stub[@"message"]];
      });
    });
    
    describe(@"#createdAt", ^{
      it(@"produces a correct mapping", ^{
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone fromDate:comment.createdAt];
        
        [[theValue(components.day) should] equal:theValue(24)];
        [[theValue(components.month) should] equal:theValue(4)];
        [[theValue(components.year) should] equal:theValue(2014)];
        [[theValue(components.hour) should] equal:theValue(16)];
        [[theValue(components.minute) should] equal:theValue(31)];
        [[theValue(components.second) should] equal:theValue(5)];
      });
    });
    
    describe(@"#user", ^{
      it(@"maps to a CJUser", ^{
        [[comment.user should] beKindOfClass:[CJUser class]];
        [[comment.user.Id should] equal:stub[@"user"][@"id"]];
      });
    });
    
  });
});

SPEC_END
