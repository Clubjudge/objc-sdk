//
//  CJMeTests.m
//  CJKit
//
//  Created by Bruno Abrantes on 24/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <CJKit/CJMe.h>
#import <CJKit/CJAPIRequest.h>

SPEC_BEGIN(CJMESPEC)

describe(@"Me Model", ^{
  NSDictionary *stub = @{
                         @"id": @443,
                         @"preferences": @{
                             @"musicGenres": @[
                                             @"62",
                                             @"1"
                                             ],
                             @"city": @{
                               @"id": @"891",
                               @"name": @"Lisbon",
                               @"lonLat": @[
                                          @-9.13333,
                                          @38.71667
                                          ],
                               @"venuesCount": @10
                             },
                             @"birthdatePreferences": @{
                               @"showOnProfile": @NO,
                               @"hideYear": @NO
                             }
                           }
                         };
  
  __block CJMe *me;
  beforeEach(^{
    me = [[CJMe alloc] initWithInfo:stub];
  });
  
  describe(@".meWithInfo:", ^{
    it(@"Returns a new instance of a CJMe with the provided info", ^{
      me = [CJMe meWithInfo:stub];
      
      [[me.Id should] equal:stub[@"id"]];
    });
  });
  
  context(@"Mapping", ^{
    describe(@"#preferences", ^{
      it(@"produces a correct mapping", ^{
        [[me.preferences should] equal:stub[@"preferences"]];
      });
    });
  });
  
  describe(@"requestForUpdate", ^{
    it(@"returns a CJAPIRequest", ^{
      id request = [me requestForUpdate];
      [[request should] beKindOfClass:[CJAPIRequest class]];
    });
    
    it(@"returns a request with a PUT method", ^{
      CJAPIRequest *request = [me requestForUpdate];
      [[request.method should] equal:@"PUT"];
    });
    
    it(@"returns a request with a path to /me.json", ^{
      CJAPIRequest *request = [me requestForUpdate];
      [[request.path should] equal:@"/v1/me.json"];
    });
    
    it(@"returns a request with the user's preferences as its parameters", ^{
      CJAPIRequest *request = [me requestForUpdate];
      [[request.parameters should] equal:stub[@"preferences"]];
    });
  });
});

SPEC_END
