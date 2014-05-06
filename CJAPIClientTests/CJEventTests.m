//
//  CJEventTests.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 22/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CJEvent.h"
#import "CJAPIRequest.h"
#import "CJArtist.h"
#import "CJVenue.h"
#import "CJUser.h"
#import "CJMusicGenre.h"
#import <ObjectiveSugar/ObjectiveSugar.h>

@interface CJEvent()

- (BOOL)isRetinaDisplay;

@end

SPEC_BEGIN(CJEVENTSPEC)

describe(@"Event Model", ^{
  NSDictionary *stub = @{
                         @"id": @55,
                         @"followersCount": @10,
                         @"commentsCount": @40,
                         @"description": @"Lorem ipsum sit dolor amet",
                         @"flyers": @[
                                       @{
                                         @"square_32": @"http://local.clubjudge.com:3000//flyers/87251/square_32.png",
                                         @"square_60": @"http://local.clubjudge.com:3000//flyers/87251/square_60.png",
                                         @"square_90": @"http://local.clubjudge.com:3000//flyers/87251/square_90.png",
                                         @"square_120": @"http://local.clubjudge.com:3000//flyers/87251/square_120.png",
                                         @"square_160": @"http://local.clubjudge.com:3000//flyers/87251/square_160.png",
                                         @"square_180": @"http://local.clubjudge.com:3000//flyers/87251/square_180.png",
                                         @"square_250": @"http://local.clubjudge.com:3000//flyers/87251/square_250.png",
                                         @"portrait_600": @"http://local.clubjudge.com:3000//flyers/87251/portrait_600.png"
                                       }
                                    ],
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
                         @"artists": @{
                              @"source": @[
                                  @{@"id": @55}
                                  ]
                             },
                         @"followers": @{
                             @"source": @[
                                 @{@"id": @55}
                                 ]
                             },
                         @"musicGenres": @{
                             @"source": @[
                                 @{@"id": @55}
                                 ]
                             },
                         @"venue": @{
                              @"id": @55
                             },
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
  
  context(@"Mapping", ^{
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
      it(@"produces a correct mapping", ^{
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone fromDate:event.startsAt];
        
        [[theValue(components.day) should] equal:theValue(21)];
        [[theValue(components.month) should] equal:theValue(4)];
        [[theValue(components.year) should] equal:theValue(2014)];
        [[theValue(components.hour) should] equal:theValue(18)];
        [[theValue(components.minute) should] equal:theValue(0)];
        [[theValue(components.second) should] equal:theValue(0)];
      });
    });
    
    describe(@"#endsAt", ^{
      it(@"produces a correct mapping", ^{
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone fromDate:event.endsAt];
        
        [[theValue(components.day) should] equal:theValue(21)];
        [[theValue(components.month) should] equal:theValue(4)];
        [[theValue(components.year) should] equal:theValue(2014)];
        [[theValue(components.hour) should] equal:theValue(20)];
        [[theValue(components.minute) should] equal:theValue(59)];
        [[theValue(components.second) should] equal:theValue(0)];
      });
    });
    
    describe(@"#updatedAt", ^{
      it(@"produces a correct mapping", ^{
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone fromDate:event.updatedAt];
        
        [[theValue(components.day) should] equal:theValue(22)];
        [[theValue(components.month) should] equal:theValue(4)];
        [[theValue(components.year) should] equal:theValue(2014)];
        [[theValue(components.hour) should] equal:theValue(16)];
        [[theValue(components.minute) should] equal:theValue(14)];
        [[theValue(components.second) should] equal:theValue(34)];
      });
    });
    
    describe(@"#reviewEndsAt", ^{
      it(@"produces a correct mapping", ^{
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone fromDate:event.reviewEndsAt];
        
        [[theValue(components.day) should] equal:theValue(28)];
        [[theValue(components.month) should] equal:theValue(4)];
        [[theValue(components.year) should] equal:theValue(2014)];
        [[theValue(components.hour) should] equal:theValue(18)];
        [[theValue(components.minute) should] equal:theValue(0)];
        [[theValue(components.second) should] equal:theValue(0)];
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
    
    describe(@"Embeddables", ^{
      describe(@"Artists", ^{
        it(@"produces an array of CJArtists", ^{
          [event.artists each:^(id artist) {
            [[artist should] beKindOfClass:[CJArtist class]];
          }];
        });
      });
      
      describe(@"Venue", ^{
        it(@"produces a CJVenue", ^{
          [[event.venue should] beKindOfClass:[CJVenue class]];
        });
      });
      
      describe(@"Followers", ^{
        it(@"produces an array of CJUsers", ^{
          [event.followers each:^(id user) {
            [[user should] beKindOfClass:[CJUser class]];
          }];
        });
      });
      
      describe(@"Music Genres", ^{
        it(@"produces an array of CJMusicGenres", ^{
          [event.musicGenres each:^(id genre) {
            [[genre should] beKindOfClass:[CJMusicGenre class]];
          }];
        });
      });
    });
  });
  
  describe(@"#follow", ^{
    
    __block CJAPIRequest *request;
    beforeEach(^{
      request = [CJAPIRequest alloc];
      [CJAPIRequest stub:@selector(alloc) andReturn:request];
    });
    
    it(@"sets the following property to YES", ^{
      [event follow];
      [[theValue(event.following) should] beYes];
    });
    
    it(@"creates a POST request to /events/:id/followers", ^{
      [event follow];
      
      [[request.method should] equal:@"POST"];
      [[request.path should] equal:@"/v1/events/55/followers.json"];
    });
    
    it(@"sets the following property to NO if the failure block is executed", ^{
      KWCaptureSpy *spy = [request captureArgument:@selector(performWithSuccess:failure:)
                                           atIndex:1];
      
      [event follow];
      
      void (^block)(NSError *error, NSNumber *statusCode) = spy.argument;
      NSError *error = nil;
      block(error, [NSNumber numberWithInteger:500]);
      
      
      [[theValue(event.following) should] beNo];
    });
  });
  
  describe(@"#unfollow", ^{
    __block CJAPIRequest *request;
    beforeEach(^{
      request = [CJAPIRequest alloc];
      [CJAPIRequest stub:@selector(alloc) andReturn:request];
    });
    
    it(@"sets the following property to NO", ^{
      [event unfollow];
      [[theValue(event.following) should] beNo];
    });
    
    it(@"creates a DELETE request to /events/:id/followers", ^{
      [event unfollow];
      
      [[request.method should] equal:@"DELETE"];
      [[request.path should] equal:@"/v1/events/55/followers.json"];
    });
    
    it(@"sets the following property to NO if the failure block is executed", ^{
      KWCaptureSpy *spy = [request captureArgument:@selector(performWithSuccess:failure:)
                                           atIndex:1];
      
      [event unfollow];
      
      void (^block)(NSError *error, NSNumber *statusCode) = spy.argument;
      NSError *error = nil;
      block(error, [NSNumber numberWithInteger:500]);
      
      
      [[theValue(event.following) should] beYes];
    });
  });
  
  describe(@"#imagePathForFlyerAtPosition:withSize:", ^{
    context(@"when device has a 1x resolution", ^{
      it(@"returns a URL string", ^{
        [event stub:@selector(isRetinaDisplay) andReturn:theValue(NO)];
        
        NSString *path = [event imagePathForFlyerAtPosition:0
                                                withSize:120];
        
        [[path should] equal:@"http://local.clubjudge.com:3000//flyers/87251/square_120.png"];
      });
    });
    
    context(@"when device has a 2x resolution", ^{
      it(@"returns a URL string with an @2x modifier", ^{
        [event stub:@selector(isRetinaDisplay) andReturn:theValue(YES)];
        
        NSString *path = [event imagePathForFlyerAtPosition:0
                                                   withSize:120];
        
        [[path should] equal:@"http://local.clubjudge.com:3000//flyers/87251/square_120@2x.png"];
      });
    });
  });
});

SPEC_END
