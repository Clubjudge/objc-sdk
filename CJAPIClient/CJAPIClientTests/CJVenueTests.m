//
//  CJVenueTests.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 23/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//


#import <Kiwi/Kiwi.h>
#import "CJVenue.h"
#import "CJAPIRequest.h"
#import "CJEvent.h"

SPEC_BEGIN(CJVENUESPEC)

describe(@"Venue Model", ^{
  NSDictionary *stub = @{
                         @"address": @{
                           @"city": @{
                             @"id": @3,
                             @"name": @"Amsterdam",
                             @"lonLat": @[
                                        @4.88969,
                                        @52.37403
                                        ],
                             @"venuesCount": @338
                           },
                           @"country": @{
                             @"id": @1,
                             @"name": @"Netherlands",
                             @"isocode": @"NL"
                           },
                           @"region": @{
                             @"id": @2381,
                             @"name": @"North Holland",
                             @"isocode": @"NH"
                           },
                           @"composedName": @"Amsterdam,NH,Netherlands",
                           @"street": @"Wibautstraat 150",
                           @"zipCode": @"1091 GR"
                         },
                         @"follow": @NO,
                         @"background": @{},
                         @"logos": @[],
                         @"socialLinks": @[
                                          @{
                                            @"name": @"Facebook",
                                            @"slug": @"facebook",
                                            @"href": @"https://www.facebook.com/DokaAmsterdam"
                                          }
                                         ],
                         @"socialMentionsCount": @0,
                         @"description": @"",
                         @"followersCount": @0,
                         @"commentsCount": @0,
                         @"id": @2150,
                         @"name": @"Doka",
                         @"email": @"",
                         @"websiteUrl": @"https://www.doka-amsterdam.nl",
                         @"phoneNumber": @"",
                         @"geolocation": @{
                           @"lat": @52.3537109,
                           @"lon": @4.911916
                         },
                         @"updatedAt": @"2013-12-17T13:01:21.000Z",
                         @"reviewCount": @1,
                         @"_links": @{
                           @"events": @"http://local.clubjudge.com:5000/v1/venues/2150/events.json",
                           @"upcoming": @"http://local.clubjudge.com:5000/v1/venues/2150/events.json?type=upcoming",
                           @"recent": @"http://local.clubjudge.com:5000/v1/venues/2150/events.json?type=recent",
                           @"comments": @"http://local.clubjudge.com:5000/v1/venues/2150/comments.json",
                           @"followers": @"http://local.clubjudge.com:5000/v1/venues/2150/followers.json",
                           @"ratings": @"http://local.clubjudge.com:5000/v1/venues/2150/ratings.json"
                         },
                         @"events": @[
                             @{@"id": @10},
                             @{@"id": @5}
                            ],
                         @"upcoming": @[
                             @{@"id": @10},
                             @{@"id": @5}
                            ],
                         @"recent": @[
                             @{@"id": @10},
                             @{@"id": @5}
                             ]
                         };
  
  __block CJVenue *venue;
  beforeAll(^{
    venue = [[CJVenue alloc] initWithInfo:stub];
  });
  
  context(@"Mapping", ^{
    describe(@"#Id", ^{
      it(@"produces a correct mapping", ^{
        [[venue.Id should] equal:stub[@"id"]];
      });
    });
    
    describe(@"#name", ^{
      it(@"produces a correct mapping", ^{
        [[venue.name should] equal:stub[@"name"]];
      });
    });
    
    describe(@"#description", ^{
      it(@"produces a correct mapping", ^{
        [[venue.description should] equal:stub[@"description"]];
      });
    });
    
    describe(@"#following", ^{
      it(@"produces a correct mapping", ^{
        [[theValue(venue.following) should] equal:stub[@"follow"]];
      });
    });
    
    describe(@"#followersCount", ^{
      it(@"produces a correct mapping", ^{
        [[venue.followersCount should] equal:stub[@"followersCount"]];
      });
    });
    
    describe(@"#commentsCount", ^{
      it(@"produces a correct mapping", ^{
        [[venue.commentsCount should] equal:stub[@"commentsCount"]];
      });
    });
    
    describe(@"#geolocation", ^{
      it(@"maps to a CLCoordinate2D", ^{
        [[theValue(venue.geolocation.longitude) should] equal:@4.911916];
        [[theValue(venue.geolocation.latitude) should] equal:@52.3537109];
      });
    });
    
    describe(@"Embeddables", ^{
      describe(@"Events", ^{
        it(@"produces an array of CJEvents", ^{
          [venue.events each:^(id event) {
            [[event should] beKindOfClass:[CJEvent class]];
          }];
        });
      });
      
      describe(@"Upcoming Events", ^{
        it(@"produces an array of CJEvents", ^{
          [venue.upcomingEvents each:^(id event) {
            [[event should] beKindOfClass:[CJEvent class]];
          }];
        });
      });
      
      describe(@"Recent Events", ^{
        it(@"produces an array of CJEvents", ^{
          [venue.recentEvents each:^(id event) {
            [[event should] beKindOfClass:[CJEvent class]];
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
      [venue follow];
      [[theValue(venue.following) should] beYes];
    });
    
    it(@"creates a POST request to /venues/:id/followers", ^{
      [venue follow];
      
      [[request.method should] equal:@"POST"];
      [[request.path should] equal:@"/venues/2150/followers.json"];
    });
    
    it(@"sets the following property to NO if the failure block is executed", ^{
      KWCaptureSpy *spy = [request captureArgument:@selector(performWithSuccess:failure:)
                                           atIndex:1];
      
      [venue follow];
      
      void (^block)(NSError *error, NSNumber *statusCode) = spy.argument;
      NSError *error = nil;
      block(error, [NSNumber numberWithInteger:500]);
      
      
      [[theValue(venue.following) should] beNo];
    });
  });
  
  describe(@"#unfollow", ^{
    __block CJAPIRequest *request;
    beforeEach(^{
      request = [CJAPIRequest alloc];
      [CJAPIRequest stub:@selector(alloc) andReturn:request];
    });
    
    it(@"sets the following property to NO", ^{
      [venue unfollow];
      [[theValue(venue.following) should] beNo];
    });
    
    it(@"creates a DELETE request to /venues/:id/followers", ^{
      [venue unfollow];
      
      [[request.method should] equal:@"DELETE"];
      [[request.path should] equal:@"/venues/2150/followers.json"];
    });
    
    it(@"sets the following property to NO if the failure block is executed", ^{
      KWCaptureSpy *spy = [request captureArgument:@selector(performWithSuccess:failure:)
                                           atIndex:1];
      
      [venue unfollow];
      
      void (^block)(NSError *error, NSNumber *statusCode) = spy.argument;
      NSError *error = nil;
      block(error, [NSNumber numberWithInteger:500]);
      
      
      [[theValue(venue.following) should] beYes];
    });
  });
});

SPEC_END

