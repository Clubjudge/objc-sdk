//
//  CityTests.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 25/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CJCity.h"

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
  beforeAll(^{
    city = [[CJCity alloc] initWithInfo:stub];
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
});

SPEC_END
