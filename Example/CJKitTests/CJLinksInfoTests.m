//
//  CJLinksInfoTests.m
//  CJKit
//
//  Created by Bruno Abrantes on 22/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <CJKit/CJLinksInfo.h>
#import <CJKit/CJAPIRequest.h>
#import "MockModel.h"

SPEC_BEGIN(CJLINKSINFOSPEC)

describe(@"Links info", ^{
  __block NSDictionary *linksData;
  __block CJLinksInfo *linksInfo;
  beforeAll(^{
    linksData = @{
                  @"first": @"http://local.clubjudge.com:5000/v1/events/31200/artists.json?page=1&foo=bar",
                  @"previous": [NSNull null],
                  @"self": @"http://local.clubjudge.com:5000/v1/events/31200/artists.json?page=1&foo=bar",
                  @"next": [NSNull null],
                  @"last": @"http://local.clubjudge.com:5000/v1/events/31200/artists.json?page=1&foo=bar"
                  };
    
    linksInfo = [[CJLinksInfo alloc] initWithInfo:linksData];
  });
  
  context(@"when initialising", ^{
    it(@"returns nil if pagination info is null", ^{
      CJLinksInfo *linksInfo = [[CJLinksInfo alloc] initWithInfo:nil];
      
      [[linksInfo should] beNil];
    });
    
    it(@"correctly sets the links property", ^{
      [[linksInfo.links should] equal:linksData];
    });
  });
  
  describe(@"#requestForLink:link", ^{
    __block CJAPIRequest *request;
    beforeEach(^{
      request = [linksInfo requestForLink:@"first"];
    });
    
    it(@"returns nil if the links property is nil", ^{
      CJLinksInfo *linksInfo = [[CJLinksInfo alloc] initWithInfo:nil];
      CJAPIRequest *request = [linksInfo requestForLink:@"foo"];
      
      [[request should] beNil];
    });
    
    it(@"returns nil if the link is nil", ^{
      CJAPIRequest *request = [linksInfo requestForLink:@"next"];
      [[request should] beNil];
    });
    
    it(@"returns a CJAPIRequest for a valid link", ^{
      [[request should] beKindOfClass:[CJAPIRequest class]];
    });
    
    it(@"creates a request using only the link's path component", ^{
      [[request.path should] equal:@"/v1/events/31200/artists.json"];
    });
    
    it(@"creates a request with the querystring components as parameters", ^{
      NSDictionary *params = @{
                               @"page": @1,
                               @"foo": @"bar"
                               };
      
      [[request.parameters should] equal:params];
    });
    
    context(@"has a mapping dictionary", ^{
      beforeAll(^{
        linksInfo.mapping = @{
                              @"first": [MockModel class]
                              };
        
        request = [linksInfo requestForLink:@"first"];
      });
      
      it(@"sets the request's modelClass", ^{
        [[theValue(request.modelClass) should] equal:theValue([MockModel class])];
      });
    });
  });
});

SPEC_END