//
//  CJVenueTests.m
//  CJKit
//
//  Created by Bruno Abrantes on 23/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//


#import <Kiwi/Kiwi.h>
#import <CJKit/CJVenue.h>
#import <CJKit/CJAPIRequest.h>
#import <CJKit/CJEvent.h>
#import <CJKit/CJUser.h>
#import <ObjectiveSugar/ObjectiveSugar.h>

@interface CJVenue()

- (BOOL)isRetinaDisplay;

@end

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
                         @"background": @{
                           @"square_32": @"http://local.clubjudge.com:3000//venues/2150/background//square_32.png",
                           @"square_60": @"http://local.clubjudge.com:3000//venues/2150/background//square_60.png",
                           @"square_90": @"http://local.clubjudge.com:3000//venues/2150/background//square_90.png",
                           @"square_120": @"http://local.clubjudge.com:3000//venues/2150/background//square_120.png",
                           @"square_160": @"http://local.clubjudge.com:3000//venues/2150/background//square_160.png",
                           @"square_180": @"http://local.clubjudge.com:3000//venues/2150/background//square_180.png",
                           @"square_250": @"http://local.clubjudge.com:3000//venues/2150/background//square_250.png",
                           @"portrait_600": @"http://local.clubjudge.com:3000//venues/2150/background//portrait_600.png"
                         },
                         @"logos": @[
                                     @{
                                       @"square_32": @"http://local.clubjudge.com:3000//venues/2150/square_32.jpg",
                                       @"square_60": @"http://local.clubjudge.com:3000//venues/2150/square_60.jpg",
                                       @"square_90": @"http://local.clubjudge.com:3000//venues/2150/square_90.jpg",
                                       @"square_120": @"http://local.clubjudge.com:3000//venues/2150/square_120.jpg",
                                       @"square_160": @"http://local.clubjudge.com:3000//venues/2150/square_160.jpg",
                                       @"square_180": @"http://local.clubjudge.com:3000//venues/2150/square_180.jpg",
                                       @"square_250": @"http://local.clubjudge.com:3000//venues/2150/square_250.jpg",
                                       @"portrait_600": @"http://local.clubjudge.com:3000//venues/2150/portrait_600.jpg"
                                     }
                                    ],
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
                         @"events": @{@"source": @[
                             @{@"id": @10},
                             @{@"id": @5}
                             ]},
                         @"upcoming": @{@"source": @[
                                        @{@"id": @10},
                                        @{@"id": @5}
                                        ]},
                         @"recent": @{@"source": @[
                                      @{@"id": @10},
                                      @{@"id": @5}
                                      ]}
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
    
    describe(@"#address", ^{
      it(@"produces a correct mapping", ^{
        [[venue.address should] equal:stub[@"address"]];
      });
    });
    
    describe(@"#background", ^{
      it(@"produces a correct mapping", ^{
        [[venue.background should] equal:stub[@"background"]];
      });
    });
    
    describe(@"#logos", ^{
      it(@"produces a correct mapping", ^{
        [[venue.logos should] equal:stub[@"logos"]];
      });
    });
    
    describe(@"#socialLinks", ^{
      it(@"produces a correct mapping", ^{
        [[venue.socialLinks should] equal:stub[@"socialLinks"]];
      });
    });
    
    describe(@"#email", ^{
      it(@"produces a correct mapping", ^{
        [[venue.email should] equal:stub[@"email"]];
      });
    });
    
    describe(@"#websiteURL", ^{
      it(@"produces a correct mapping", ^{
        [[venue.websiteURL should] equal:stub[@"websiteUrl"]];
      });
    });
    
    describe(@"#phoneNumber", ^{
      it(@"produces a correct mapping", ^{
        [[venue.phoneNumber should] equal:stub[@"phoneNumber"]];
      });
    });
    
    describe(@"#reviewCount", ^{
      it(@"produces a correct mapping", ^{
        [[venue.reviewCount should] equal:stub[@"reviewCount"]];
      });
    });
    
    describe(@"#geolocation", ^{
      it(@"maps to a CLCoordinate2D", ^{
        [[theValue(venue.geolocation.longitude) should] equal:@4.911916];
        [[theValue(venue.geolocation.latitude) should] equal:@52.3537109];
      });
    });
    
    describe(@"#updatedAt", ^{
      it(@"produces a correct mapping", ^{
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone fromDate:venue.updatedAt];
        
        [[theValue(components.day) should] equal:theValue(17)];
        [[theValue(components.month) should] equal:theValue(12)];
        [[theValue(components.year) should] equal:theValue(2013)];
        [[theValue(components.hour) should] equal:theValue(13)];
        [[theValue(components.minute) should] equal:theValue(01)];
        [[theValue(components.second) should] equal:theValue(21)];
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
      
      describe(@"Followers", ^{
        it(@"produces an array of CJUsers", ^{
          [venue.followers each:^(id user) {
            [[user should] beKindOfClass:[CJUser class]];
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
      [[request.path should] equal:@"/v1/venues/2150/followers.json"];
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
      [[request.path should] equal:@"/v1/venues/2150/followers.json"];
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
  
  describe(@"#distanceFromCoordinate:location", ^{
    it(@"returns the distance in meters to the model´s geolocation property", ^{
      CLLocation *location = [[CLLocation alloc] initWithLatitude:53.3537109 longitude:5.9119169];
      NSUInteger meters = [venue distanceFromLocation:location];
      
      [[theValue(meters) should] equal:theValue(130084)];
    });
  });
  
  describe(@"#imagePathForLogoWithSize:", ^{
    context(@"when device has a 1x resolution", ^{
      it(@"returns a URL string", ^{
        [venue stub:@selector(isRetinaDisplay) andReturn:theValue(NO)];
        
        NSString *path = [venue imagePathForLogoWithSize:@"square_120"];
        
        [[path should] equal:@"http://local.clubjudge.com:3000//venues/2150/square_120.jpg"];
      });
    });
    
    context(@"when device has a 2x resolution", ^{
      it(@"returns a URL string with an @2x modifier", ^{
        [venue stub:@selector(isRetinaDisplay) andReturn:theValue(YES)];
        
        NSString *path = [venue imagePathForLogoWithSize:@"square_120"];
        
        [[path should] equal:@"http://local.clubjudge.com:3000//venues/2150/square_120@2x.jpg"];
      });
    });
  });
  
  describe(@"#imagePathForBackgroundWithSize:", ^{
    context(@"when device has a 1x resolution", ^{
      it(@"returns a URL string", ^{
        [venue stub:@selector(isRetinaDisplay) andReturn:theValue(NO)];
        
        NSString *path = [venue imagePathForBackgroundWithSize:@"square_120"];
        
        [[path should] equal:@"http://local.clubjudge.com:3000//venues/2150/background//square_120.png"];
      });
    });
    
    context(@"when device has a 2x resolution", ^{
      it(@"returns a URL string with an @2x modifier", ^{
        [venue stub:@selector(isRetinaDisplay) andReturn:theValue(YES)];
        
        NSString *path = [venue imagePathForBackgroundWithSize:@"square_120"];
        
        [[path should] equal:@"http://local.clubjudge.com:3000//venues/2150/background//square_120@2x.png"];
      });
    });
  });
});

SPEC_END

