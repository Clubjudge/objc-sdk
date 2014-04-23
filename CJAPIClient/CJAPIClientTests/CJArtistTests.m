//
//  CJArtistTests.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 23/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CJArtist.h"
#import "CJAPIRequest.h"
#import "CJEvent.h"

SPEC_BEGIN(CJARTISTSPEC)

describe(@"Artist Model", ^{
  NSDictionary *stub = @{
                         @"id": @1981,
                         @"name": @"Tiësto",
                         @"follow": @NO,
                         @"followersCount": @55,
                         @"friendsFollowingCount": @10,
                         @"commentsCount": @20,
                         @"email": @"",
                         @"websiteUrl": @"http://www.tiesto.com/",
                         @"upcomingEventsCount": @10,
                         @"socialMentionsCount": @9,
                         @"avatars": @[],
                         @"address": @{
                           @"city": @{
                             @"id": [NSNull null],
                             @"name": [NSNull null],
                             @"lonLat": [NSNull null],
                             @"venuesCount": @24
                           },
                           @"country": [NSNull null],
                           @"region": [NSNull null],
                           @"composedName": [NSNull null]
                         },
                         @"background": @{},
                         @"description": @"<p style=\"margin-left:25px;\">As world-dominating DJ, Ti&euml;sto can be called a true phenomenon. His breakthrough was in 1997, when he and Arny Bink founded Black Hole Recordings. Releases like the In Search of Sunrise CD series and the track &#39;Magik&#39; put him on the universal map indefinitely. In 2001 his first solo album &#39;In My Memory&#39; was born, featuring major hits like &#39;Silence&#39;. His booming career resulted into even more impressive performances, giving him the honour to play live at the Opening Ceremony at the 2004 Summer Olympics in Athens, Greece. He was nominated for a Grammy Award, for several MTV awards and was voted &#39;Best DJ worldwide&#39; by numerous media. Not only does this Dutchie create music by producing own tracks and remixing songs of other famous artists, he also hosts his globally known radio show Club Life. Even though this DJ has been around the EDM scene for quite some years, Ti&euml;sto still is on top of his game. An own record label called &#39;Musical Freedom&#39;, gigs wordlwide, regular performances at <a href=\"/venues/2631/hakkasan-mgm-grand\" target=\"_self\">Hakkasan Las Vegas</a>, touring with <a href=\"/artists/10609/calvin-harris\" target=\"_self\">Calvin Harris</a>, pioneering The States to take EDM to the next level. Unstoppable, would be the right definition...&nbsp;</p>\r\n",
                         @"socialLinks": @[
                                          @{
                                            @"name": @"Facebook",
                                            @"slug": @"facebook",
                                            @"href": @"https://www.facebook.com/tiesto?fref=ts"
                                          },
                                          @{
                                            @"name": @"Twitter",
                                            @"slug": @"twitter",
                                            @"href": @"https://twitter.com/tiesto"
                                          },
                                          @{
                                            @"name": @"YouTube",
                                            @"slug": @"youtube",
                                            @"href": @"http://www.youtube.com/user/officialtiesto"
                                          },
                                          @{
                                            @"name": @"Google+",
                                            @"slug": @"google",
                                            @"href": @"https://plus.google.com/+Tiësto/"
                                          },
                                          @{
                                            @"name": @"SoundCloud",
                                            @"slug": @"soundcloud",
                                            @"href": @"https://soundcloud.com/tiesto"
                                          }
                                         ],
                         @"_links": @{
                           @"events": @"http://local.clubjudge.com:5000/v1/artists/1981/events.json",
                           @"followers": @"http://local.clubjudge.com:5000/v1/artists/1981/followers.json",
                           @"comments": @"http://local.clubjudge.com:5000/v1/artists/1981/comments.json",
                           @"musicGenres": @"http://local.clubjudge.com:5000/v1/artists/1981/musicGenres.json"
                         },
                         @"events": @{@"source": @[
                                          @{@"id": @10},
                                          @{@"id": @5}
                                        ]}
                      };
  
  __block CJArtist *artist;
  beforeAll(^{
    artist = [[CJArtist alloc] initWithInfo:stub];
  });
  
  context(@"Mapping", ^{
    describe(@"#Id", ^{
      it(@"produces a correct mapping", ^{
        [[artist.Id should] equal:stub[@"id"]];
      });
    });
    
    describe(@"#name", ^{
      it(@"produces a correct mapping", ^{
        [[artist.name should] equal:stub[@"name"]];
      });
    });
    
    describe(@"#description", ^{
      it(@"produces a correct mapping", ^{
        [[artist.description should] equal:stub[@"description"]];
      });
    });

    describe(@"#following", ^{
      it(@"produces a correct mapping", ^{
        [[theValue(artist.following) should] equal:stub[@"follow"]];
      });
    });
    
    describe(@"#followersCount", ^{
      it(@"produces a correct mapping", ^{
        [[artist.followersCount should] equal:stub[@"followersCount"]];
      });
    });
    
    describe(@"#commentsCount", ^{
      it(@"produces a correct mapping", ^{
        [[artist.commentsCount should] equal:stub[@"commentsCount"]];
      });
    });
    
    describe(@"#friendsFollowingCount", ^{
      it(@"produces a correct mapping", ^{
        [[artist.friendsFollowingCount should] equal:stub[@"friendsFollowingCount"]];
      });
    });
    
    describe(@"Embeddables", ^{
      describe(@"Events", ^{
        it(@"produces an array of CJEvents", ^{
          [artist.events each:^(id event) {
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
      [artist follow];
      [[theValue(artist.following) should] beYes];
    });
    
    it(@"creates a POST request to /artists/:id/followers", ^{
      [artist follow];
      
      [[request.method should] equal:@"POST"];
      [[request.path should] equal:@"/artists/1981/followers.json"];
    });
    
    it(@"sets the following property to NO if the failure block is executed", ^{
      KWCaptureSpy *spy = [request captureArgument:@selector(performWithSuccess:failure:)
                                           atIndex:1];
      
      [artist follow];
      
      void (^block)(NSError *error, NSNumber *statusCode) = spy.argument;
      NSError *error = nil;
      block(error, [NSNumber numberWithInteger:500]);
      
      
      [[theValue(artist.following) should] beNo];
    });
  });
  
  describe(@"#unfollow", ^{
    __block CJAPIRequest *request;
    beforeEach(^{
      request = [CJAPIRequest alloc];
      [CJAPIRequest stub:@selector(alloc) andReturn:request];
    });
    
    it(@"sets the following property to NO", ^{
      [artist unfollow];
      [[theValue(artist.following) should] beNo];
    });
    
    it(@"creates a DELETE request to /artists/:id/followers", ^{
      [artist unfollow];
      
      [[request.method should] equal:@"DELETE"];
      [[request.path should] equal:@"/artists/1981/followers.json"];
    });
    
    it(@"sets the following property to NO if the failure block is executed", ^{
      KWCaptureSpy *spy = [request captureArgument:@selector(performWithSuccess:failure:)
                                           atIndex:1];
      
      [artist unfollow];
      
      void (^block)(NSError *error, NSNumber *statusCode) = spy.argument;
      NSError *error = nil;
      block(error, [NSNumber numberWithInteger:500]);
      
      
      [[theValue(artist.following) should] beYes];
    });
  });
});

SPEC_END
