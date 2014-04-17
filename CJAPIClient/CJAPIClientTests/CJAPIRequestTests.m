//
//  CJAPIRequestTests.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 16/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CJAPIRequest.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "CJEngine.h"

@interface CJAPIRequest()

- (void)GETWithSuccess:(void (^)(id response, id pagination, id links))success
               failure:(CJFailureBlock)failure;

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

SPEC_BEGIN(CJAPIREQUESTSPEC)

describe(@"CJAPIRequest", ^{
  context(@"When initialising", ^{
    describe(@"#method", ^{
      it(@"defaults to GET", ^{
        CJAPIRequest *request = [CJAPIRequest new];

        [[request.method should] equal:@"GET"];
      });
      
      it(@"sets the method property", ^{
        CJAPIRequest *request = [[CJAPIRequest alloc] initWithMethod:@"POST"
                                                             andPath:@"a/path"];
        
        [[request.method should] equal:@"POST"];
      });
      
      it(@"works with lowercase methods", ^{
        CJAPIRequest *request = [[CJAPIRequest alloc] initWithMethod:@"post"
                                                             andPath:@"a/path"];
        
        [[request.method should] equal:@"POST"];
      });
    });
    
    describe(@"#path", ^{
      it(@"defaults to /", ^{
        CJAPIRequest *request = [CJAPIRequest new];
        
        [[request.path should] equal:@"/"];
      });
      
      it(@"sets the path property", ^{
        CJAPIRequest *request = [[CJAPIRequest alloc] initWithMethod:@"GET"
                                                             andPath:@"/a/path/"];
        
        [[request.path should] equal:@"/a/path/"];
      });
      
      it(@"adds forward slashes at the beginning", ^{
        CJAPIRequest *request = [[CJAPIRequest alloc] initWithMethod:@"GET"
                                                             andPath:@"a/path/"];
        
        [[request.path should] equal:@"/a/path/"];
      });
      
      it(@"encodes the path using UTF-8", ^{
        CJAPIRequest *request = [[CJAPIRequest alloc] initWithMethod:@"GET"
                                                            andPath:@"a/path?foo=bar bar"];
        
        [[request.path should] equal:@"/a/path?foo=bar%20bar"];
      });
    });
    
    describe(@"#sessionManager", ^{
      it(@"sets the sessionManager property to the shared engine's sessionManager", ^{
        CJEngine *engine = [CJEngine sharedEngine];
        CJAPIRequest *request = [[CJAPIRequest alloc] initWithMethod:@"GET"
                                                             andPath:@"a/path/"];
        
        [[request.sessionManager should] equal:engine.sessionManager];
      });
    });
  });
  
  describe(@"#setEmbeds", ^{
    __block CJAPIRequest *request;
    __block NSArray *embeds;
    
    beforeEach(^{
      request = [[CJAPIRequest alloc] init];
      embeds = @[@"subresource1", @"subresource2"];
    });
    
    it(@"sets the embeds array", ^{
      [request setEmbeds:embeds];
      
      [[request.embeds should] equal:embeds];
    });
  });
  
  describe(@"#setFields", ^{
    __block CJAPIRequest *request;
    __block NSArray *fields;
    
    beforeEach(^{
      request = [[CJAPIRequest alloc] init];
      fields = @[@"field1", @"field2"];
    });
    
    it(@"sets the fields array", ^{
      [request setFields:fields];
      
      [[request.fields should] equal:fields];
    });
  });
  
  describe(@"#setParameters", ^{
    __block CJAPIRequest *request;
    __block NSDictionary *parameters;
    
    beforeEach(^{
      request = [[CJAPIRequest alloc] init];
      parameters = @{
                     @"key1": @"value1",
                     @"key2": @"value2"
                     };
    });
    
    it(@"sets the fields array", ^{
      [request setParameters:parameters];
      
      [[request.parameters should] equal:parameters];
    });
  });
  
  describe(@"prepareParameters", ^{
    __block CJAPIRequest *request;
    __block NSDictionary *parameters;
    
    beforeEach(^{
      [CJEngine setClientKey:@"kittens"];
      [CJEngine setUserToken:@"aToken"];
      
      request = [CJAPIRequest new];
      request.parameters = @{
                             @"foo": @"bar",
                             @"baz": @"zab"
                             };
      
      parameters = [request prepareParameters];
    });
    
    it(@"adds the clientId attribute if CJEngine has one", ^{
      [[[parameters objectForKey:@"clientId"] should] equal:@"kittens"];
    });
    
    it(@"adds the token attribute if CJEngine has one", ^{
      [[[parameters objectForKey:@"token"] should] equal:@"aToken"];
    });
    
    it(@"preserves the CJRequest's parameters property", ^{
      [[[parameters objectForKey:@"foo"] should] equal:@"bar"];
      [[[parameters objectForKey:@"baz"] should] equal:@"zab"];
    });
  });
  
  describe(@"#perform", ^{
    context(@"When the method is GET", ^{
      
      __block CJAPIRequest *request;
      beforeEach(^{
        request = [CJAPIRequest new];
        request.method = @"GET";
      });
      
      it(@"calls the GETWithSuccess:failure: method", ^{
        [[request should] receive:@selector(GETWithSuccess:failure:)];
        
        [request performWithSuccess:^(id response, id pagination, id links) {
          return;
        } failure:^(NSError *error) {
          return;
        }];
      });
    });
  });
});

SPEC_END