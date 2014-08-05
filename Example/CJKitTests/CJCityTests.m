//
//  CJCityTests.m
//  CJKit
//
//  Created by Bruno Abrantes on 25/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <CJKit/CJCity.h>
#import <ObjectiveSugar/ObjectiveSugar.h>

SPEC_BEGIN(CJCITYSPEC)

describe(@"City Model", ^{
  NSDictionary *stub = @{
                         @"id": @55,
                         @"name": @"Lisbon",
                         @"aliases": @[@"Lissabon"],
                         @"region": @{
                           @"id": @2646,
                           @"name": @"Lisbon",
                           @"isocode": [NSNull null]
                         },
                         @"country": @{
                           @"id": @49,
                           @"name": @"Portugal",
                           @"isocode": @"PT"
                         },
                         @"geolocation": @{
                                            @"lat": @55.04434,
                                            @"lon": @9.41741
                                          }
                         };
  
  __block CJCity *city;
  beforeEach(^{
    city = [[CJCity alloc] initWithInfo:stub];
  });
  
  describe(@".cityWithInfo:", ^{
    it(@"Returns a new instance of a CJCity with the provided info", ^{
      city = [CJCity cityWithInfo:stub];
      
      [[city.Id should] equal:stub[@"id"]];
    });
  });
  
  context(@"Mapping", ^{
    describe(@"#Id", ^{
      it(@"produces a correct mapping", ^{
        [[city.Id should] equal:stub[@"id"]];
      });
    });
    
    describe(@"#name", ^{
      it(@"produces a correct mapping", ^{
        [[city.name should] equal:stub[@"name"]];
      });
    });
    
    describe(@"#aliases", ^{
      it(@"produces a correct mapping", ^{
        [[city.aliases should] equal:stub[@"aliases"]];
      });
    });
    
    describe(@"#region", ^{
      it(@"produces a correct mapping", ^{
        [[city.region should] equal:stub[@"region"]];
      });
    });
    
    describe(@"#country", ^{
      it(@"produces a correct mapping", ^{
        [[city.country should] equal:stub[@"country"]];
      });
    });
    
    describe(@"#geolocation", ^{
      it(@"maps to a CLCoordinate2D", ^{
        [[theValue(city.geolocation.latitude) should] equal:@55.04434];
        [[theValue(city.geolocation.longitude) should] equal:@9.41741];
      });
    });
  });
  
  describe(@".requestForSearchWithTerm:", ^{
    it(@"Produces a correctly configured CJAPIRequest for searching for venues", ^{
      CJAPIRequest *searchRequest = [CJCity requestForSearchWithTerm:@"berlin"];
      
      [[theValue([searchRequest.path containsString:@"cities/search"]) should] beYes];
      [[searchRequest.modelClass should] equal:[CJCity class]];
      [[searchRequest.parameters[@"term"] should] equal:@"berlin"];
      [[theValue(searchRequest.cachePolicy) should] equal:theValue(CJAPIRequestReturnCacheDataElseLoad)];
    });
  });
});

SPEC_END
