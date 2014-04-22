//
//  CJEventTests.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 22/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CJEvent.h"

SPEC_BEGIN(CJEVENTSPEC)

describe(@"Event Model", ^{
  context(@"Mapping", ^{
    
    NSDictionary *stub = @{
                           @"id": @55,
                           @"followersCount": @10,
                           @"commentsCount": @40,
                           @"description": @"Lorem ipsum sit dolor amet",
                           @"flyers": @[],
                           @"name": @"Tiësto & Calvin Harris - Greater Than Tour",
                           @"startsAt": @"2014-04-21T18:00:00.000Z",
                           @"endsAt": @"2014-04-21T20:59:00.000Z",
                           @"featured": @NO,
                           @"updatedAt": @"2014-04-22T16:14:34.000Z",
                           @"follow": @YES,
                           @"reviewEndsAt": @"2014-04-28T18:00:00.000Z",
                           @"lineupToBeAnnounced": @NO,
                           @"reviewable": @YES,
                           @"published": @YES,
                           @"friendsFollowingCount": @2,
                           @"reviewCount": @5,
                           @"userData": @{},
                           @"contest": @{},
                           @"expertReviewRatings": @{},
                           @"globalRating": @{},
                           @"_links": @{
                               @"artists": @"http://local.clubjudge.com:5000/v1/events/31200/artists.json",
                               @"comments": @"http://local.clubjudge.com:5000/v1/events/31200/comments.json",
                               @"invitations": @"http://local.clubjudge.com:5000/v1/events/31200/invitations.json",
                               @"followers": @"http://local.clubjudge.com:5000/v1/events/31200/followers.json",
                               @"musicGenres": @"http://local.clubjudge.com:5000/v1/events/31200/musicGenres.json",
                               @"tickets": @"http://local.clubjudge.com:5000/v1/events/31200/tickets.json",
                               @"venue": @"http://local.clubjudge.com:5000/v1/events/31200/venue.json"
                               }
                           };
    
    __block CJEvent *event;
    beforeAll(^{
      event = [[CJEvent alloc] initWithInfo:stub];
    });
    
    describe(@"#Id", ^{
      it(@"produces a correct mapping", ^{
        [[event.Id should] equal:stub[@"id"]];
      });
    });
    
    describe(@"#name", ^{
      it(@"produces a correct mapping", ^{
        [[event.name should] equal:stub[@"name"]];
      });
    });
    
    describe(@"#startsAt", ^{
      xit(@"produces a correct mapping", ^{
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone fromDate:event.startsAt];
        
        NSInteger day = components.day;
        NSInteger month = components.month;
        NSInteger year = components.year;
        
        NSString *date = [event.startsAt description];
        
        [[theValue(components.day) should] equal:theValue(21)];
      });
    });
    
    describe(@"#flyers", ^{
      it(@"produces a correct mapping", ^{
        [[event.flyers should] equal:stub[@"flyers"]];
      });
    });
    
    describe(@"#description", ^{
      it(@"produces a correct mapping", ^{
        [[event.description should] equal:stub[@"description"]];
      });
    });
    
    describe(@"#featured", ^{
      it(@"produces a correct mapping", ^{
        [[theValue(event.featured) should] equal:stub[@"featured"]];
      });
    });
    
    describe(@"#following", ^{
      it(@"produces a correct mapping", ^{
        [[theValue(event.following) should] equal:stub[@"follow"]];
      });
    });
    
    describe(@"#lineupToBeAnnounced", ^{
      it(@"produces a correct mapping", ^{
        [[theValue(event.lineupToBeAnnounced) should] equal:stub[@"lineupToBeAnnounced"]];
      });
    });
    
    describe(@"#reviewable", ^{
      it(@"produces a correct mapping", ^{
        [[theValue(event.reviewable) should] equal:stub[@"reviewable"]];
      });
    });
    
    describe(@"#published", ^{
      it(@"produces a correct mapping", ^{
        [[theValue(event.published) should] equal:stub[@"published"]];
      });
    });
    
    describe(@"#followersCount", ^{
      it(@"produces a correct mapping", ^{
        [[event.followersCount should] equal:stub[@"followersCount"]];
      });
    });
    
    describe(@"#commentsCount", ^{
      it(@"produces a correct mapping", ^{
        [[event.commentsCount should] equal:stub[@"commentsCount"]];
      });
    });
    
    describe(@"#friendsFollowingCount", ^{
      it(@"produces a correct mapping", ^{
        [[event.friendsFollowingCount should] equal:stub[@"friendsFollowingCount"]];
      });
    });
    
    describe(@"#reviewCount", ^{
      it(@"produces a correct mapping", ^{
        [[event.reviewCount should] equal:stub[@"reviewCount"]];
      });
    });
    
    describe(@"#userData", ^{
      it(@"produces a correct mapping", ^{
        [[event.userData should] equal:stub[@"userData"]];
      });
    });
    
    describe(@"#contest", ^{
      it(@"produces a correct mapping", ^{
        [[event.contest should] equal:stub[@"contest"]];
      });
    });
    
    describe(@"#expertReviewRatings", ^{
      it(@"produces a correct mapping", ^{
        [[event.expertReviewRatings should] equal:stub[@"expertReviewRatings"]];
      });
    });
    
    describe(@"#globalRating", ^{
      it(@"produces a correct mapping", ^{
        [[event.globalRating should] equal:stub[@"globalRating"]];
      });
    });

  });
});

SPEC_END
