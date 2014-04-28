//
//  CJUserTests.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 24/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CJUser.h"

SPEC_BEGIN(CJUSERSPEC)

describe(@"User Model", ^{
  NSDictionary *stub = @{
                           @"id": @443,
                           @"email": @"bruno.abrantes@clubjudge.com",
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
                           @"createdAt": @"2013-03-19T11:09:44.000Z",
                           @"reviewsCount": @14,
                           @"expertReviewsCount": @1,
                           @"friendsCount": @1,
                           @"mutualFriendsCount": @0,
                           @"isFriend": @NO,
                           @"isPendingFriend": @NO,
                           @"upcomingEventsCount": @1,
                           @"pastEventsCount": @2,
                           @"score": @{
                             @"totalPoints": @298,
                             @"usedPoints": @0,
                             @"availablePoints": @298,
                             @"availableTickets": @5
                           },
                           @"gender": @"male",
                           @"bornOn": @"1986-10-13T00:00:00.000Z",
                           @"_links": @{
                             @"events": @"http://local.clubjudge.com:5000/v1/users/443/events.json?type=upcoming"
                           }
                         };
  
  __block CJUser *user;
  beforeAll(^{
    user = [[CJUser alloc] initWithInfo:stub];
  });
  
  context(@"Mapping", ^{
    describe(@"#Id", ^{
      it(@"produces a correct mapping", ^{
        [[user.Id should] equal:stub[@"id"]];
      });
    });
    
    describe(@"#email", ^{
      it(@"produces a correct mapping", ^{
        [[user.email should] equal:stub[@"email"]];
      });
    });
    
    describe(@"#address", ^{
      it(@"produces a correct mapping", ^{
        [[user.address should] equal:stub[@"address"]];
      });
    });
    
    describe(@"#firstName", ^{
      it(@"produces a correct mapping", ^{
        [[user.firstName should] equal:stub[@"firstName"]];
      });
    });
    
    describe(@"#lastName", ^{
      it(@"produces a correct mapping", ^{
        [[user.lastName should] equal:stub[@"lastName"]];
      });
    });
    
    describe(@"#avatarURL", ^{
      it(@"produces a correct mapping", ^{
        [[user.avatarURL should] equal:stub[@"avatarUrl"]];
      });
    });
    
    describe(@"#createdAt", ^{
      it(@"produces a correct mapping", ^{
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone fromDate:user.createdAt];
        
        [[theValue(components.day) should] equal:theValue(19)];
        [[theValue(components.month) should] equal:theValue(03)];
        [[theValue(components.year) should] equal:theValue(2013)];
        [[theValue(components.hour) should] equal:theValue(11)];
        [[theValue(components.minute) should] equal:theValue(9)];
        [[theValue(components.second) should] equal:theValue(44)];
      });
    });
    
    describe(@"#reviewCount", ^{
      it(@"produces a correct mapping", ^{
        [[user.reviewCount should] equal:stub[@"reviewsCount"]];
      });
    });
    
    describe(@"#expertReviewCount", ^{
      it(@"produces a correct mapping", ^{
        [[user.expertReviewCount should] equal:stub[@"expertReviewsCount"]];
      });
    });
    
    describe(@"#friendsCount", ^{
      it(@"produces a correct mapping", ^{
        [[user.friendsCount should] equal:stub[@"friendsCount"]];
      });
    });
    
    describe(@"#mutualFriendsCount", ^{
      it(@"produces a correct mapping", ^{
        [[user.mutualFriendsCount should] equal:stub[@"mutualFriendsCount"]];
      });
    });
    
    describe(@"#friend", ^{
      it(@"produces a correct mapping", ^{
        [[theValue(user.friend) should] equal:stub[@"isFriend"]];
      });
    });
    
    describe(@"#pendingFriend", ^{
      it(@"produces a correct mapping", ^{
        [[theValue(user.pendingFriend) should] equal:stub[@"isPendingFriend"]];
      });
    });
    
    describe(@"#upcomingEventsCount", ^{
      it(@"produces a correct mapping", ^{
        [[user.upcomingEventsCount should] equal:stub[@"upcomingEventsCount"]];
      });
    });
    
    describe(@"#pastEventsCount", ^{
      it(@"produces a correct mapping", ^{
        [[user.pastEventsCount should] equal:stub[@"pastEventsCount"]];
      });
    });
    
    describe(@"#score", ^{
      it(@"produces a correct mapping", ^{
        [[user.score should] equal:stub[@"score"]];
      });
    });
    
    describe(@"#gender", ^{
      it(@"produces a correct mapping", ^{
        [[user.gender should] equal:stub[@"gender"]];
      });
    });
    
    describe(@"#birthdate", ^{
      it(@"produces a correct mapping", ^{
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone fromDate:user.birthdate];
        
        [[theValue(components.day) should] equal:theValue(13)];
        [[theValue(components.month) should] equal:theValue(10)];
        [[theValue(components.year) should] equal:theValue(1986)];
      });
    });
  });
});

SPEC_END
