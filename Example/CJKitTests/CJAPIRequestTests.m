//
//  CJAPIRequestTests.m
//  CJKit
//
//  Created by Bruno Abrantes on 16/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <CJKit/CJAPIRequest.h>
#import <AFNetworking/AFNetworking.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <CJKit/CJEngine+CJPersistentQueueController.h>
#import <CJKit/CJPaginationInfo.h>
#import <CJKit/CJLinksInfo.h>
#import "MockModel.h"
#import <CJKit/CJAPIRequest+PromiseKit.h>
#import <PromiseKit/Promise.h>
#import <ObjectiveSugar/ObjectiveSugar.h>

@interface CJAPIRequest()

- (void)GETWithSuccess:(void (^)(id response, id pagination, id links))success
               failure:(CJFailureBlock)failure;

- (void)POSTWithSuccess:(void (^)(id response))success
                failure:(CJFailureBlock)failure;

- (void)PUTWithSuccess:(void (^)(id response))success
               failure:(CJFailureBlock)failure;

- (void)DELETEWithSuccess:(void (^)(id response))success
                  failure:(CJFailureBlock)failure;

- (NSString *)developerMessageFromResponse:(NSHTTPURLResponse *)response
                                     error:(NSDictionary *)error;

- (BOOL)willDeleteCached;

- (void)saveRequestForLater;

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

SPEC_BEGIN(CJAPIREQUESTSPEC)

describe(@"CJAPIRequest", ^{
  
  beforeEach(^{
    [OHHTTPStubs removeAllStubs];
  });
  
  afterEach(^{
    [OHHTTPStubs removeAllStubs];
  });
  
  beforeAll(^{
    [CJEngine setVersion:1];
  });
  
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
    
    describe(@"#cachePolicy", ^{
      it(@"sets the cachePolicy for this request", ^{
        CJAPIRequest *request = [CJAPIRequest new];
        request.cachePolicy = CJAPIRequestReloadIgnoringCacheData;
        
        [[theValue(request.cachePolicy) should] equal:theValue(CJAPIRequestReloadIgnoringCacheData)];
      });
      
      context(@"When it is set to nil", ^{
        __block CJAPIRequest *request;
        beforeEach(^{
          request = [CJAPIRequest new];
          request.cachePolicy = (int)nil;

          [CJEngine sharedEngine].cachePolicy = CJAPIRequestReloadIgnoringCacheData;
        });
        
        it(@"defaults to the cachePolicy set in CJEngine", ^{
          [[theValue(request.cachePolicy) should] equal:theValue(CJAPIRequestReloadIgnoringCacheData)];
        });
      });
    });
    
    describe(@"#path", ^{
      it(@"defaults to /", ^{
        CJAPIRequest *request = [CJAPIRequest new];
        
        [[request.path should] equal:@"/"];
      });
      
      it(@"sets the path property", ^{
        CJAPIRequest *request = [[CJAPIRequest alloc] initWithMethod:@"GET"
                                                             andPath:@"/a/path.json"];
        
        [[request.path should] equal:@"/v1/a/path.json"];
      });
      
      it(@"adds forward slashes at the beginning", ^{
        CJAPIRequest *request = [[CJAPIRequest alloc] initWithMethod:@"GET"
                                                             andPath:@"a/path.json"];
        
        [[request.path should] equal:@"/v1/a/path.json"];
      });
      
      it(@"encodes the path using UTF-8", ^{
        CJAPIRequest *request = [[CJAPIRequest alloc] initWithMethod:@"GET"
                                                            andPath:@"a/path.json?foo=bar bar"];
        
        [[request.path should] equal:@"/v1/a/path.json?foo=bar%20bar"];
      });
      
      it(@"automatically adds .json at the end", ^{
        CJAPIRequest *request = [[CJAPIRequest alloc] initWithMethod:@"GET"
                                                             andPath:@"a/path"];
        
        [[request.path should] equal:@"/v1/a/path.json"];
      });
      
      it(@"automatically adds the API version to the path", ^{
        CJAPIRequest *request = [[CJAPIRequest alloc] initWithMethod:@"GET"
                                                             andPath:@"a/path"];
        
        [[request.path should] equal:@"/v1/a/path.json"];
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
    
    context(@"parameters is uninitialized", ^{
      beforeEach(^{
        request = [[CJAPIRequest alloc] init];
        parameters = @{
                       @"key1": @"value1",
                       @"key2": @"value2"
                       };
      });
      
      it(@"sets correctly", ^{
        [request setParameters:parameters];
        
        [[request.parameters should] equal:parameters];
      });
    });
    
    context(@"parameters is initialized", ^{
      
      __block NSDictionary *newParameters;
      
      beforeEach(^{
        request = [[CJAPIRequest alloc] init];
        parameters = @{
                       @"key1": @"value1",
                       @"key2": @"value2"
                       };
        newParameters = @{
                          @"key3": @"value3",
                          @"key4": @"value4"
                          };
      
      });
      
      it(@"sets parameters preserving previously set values", ^{
        [request setParameters:parameters];
        [[request.parameters should] equal:parameters];
        
        [request setParameters:newParameters];
        
        NSMutableArray *allKeys = [NSMutableArray arrayWithArray:parameters.allKeys];
        [allKeys addObjectsFromArray:newParameters.allKeys];

        [[[request.parameters.allKeys sort] should] equal:[allKeys sort]];
        
        NSMutableArray *allValues = [NSMutableArray arrayWithArray:parameters.allValues];
        [allValues addObjectsFromArray:newParameters.allValues];
        
        [[[request.parameters.allValues sort] should] equal:[allValues sort]];
      });
    });
  });
  
  describe(@"#prepareParameters", ^{
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
    
    it(@"adds the fields array as a comma separated string if the request has one", ^{
      request.fields = @[@"name", @"id"];
      parameters = [request prepareParameters];
      
      [[parameters[@"fields"] should] equal:@"name,id"];
    });
    
    it(@"adds the embeds array as a comma separated string if the request has one", ^{
      request.embeds = @[@"venue", @"artists"];
      parameters = [request prepareParameters];
      
      [[parameters[@"embeds"] should] equal:@"venue,artists"];
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
        request = [[CJAPIRequest alloc] initWithMethod:@"GET"
                                               andPath:@"/a/path"];
      });
      
      it(@"calls the GETWithSuccess:failure: method", ^{
        [[request should] receive:@selector(GETWithSuccess:failure:)];
        
        [request performWithSuccess:nil failure:nil];
      });
      
      it(@"requests the given path", ^{
        KWCaptureSpy *spy = [request.sessionManager captureArgument:@selector(GET:parameters:success:failure:)
                                                            atIndex:0];
        
        [request performWithSuccess:nil failure:nil];
        
        [[expectFutureValue(spy.argument) shouldEventually] equal:request.path];
      });
      
      context(@"when GET succeeds", ^{
        __block NSDictionary *stubbedResponse;
        __block id<OHHTTPStubsDescriptor> stub = nil;
        
        beforeEach(^{          
          stubbedResponse = @{
                              @"events": @[
                                  @{@"id": @"5"},
                                  @{@"id": @"10"}
                                  ],
                              @"_pagination": @{
                                  @"currentPage": @1,
                                  @"perPage": @10,
                                  @"totalPages": @5,
                                  @"totalItems": @47
                                  },
                              @"_links": @{
                                  @"artists": @"http://artists",
                                  @"venue": @"http://venue"
                                  }
                              };
          
          stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *req) {
            return [req.URL.path isEqualToString:@"/v1/a/path.json"];
          } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *req) {
            NSError *error;
            NSData *data = [NSJSONSerialization dataWithJSONObject:stubbedResponse
                                                               options:kNilOptions
                                                                 error:&error];
            
            return [OHHTTPStubsResponse responseWithData:data
                                              statusCode:200
                                                 headers:@{@"Content-Type":@"text/json"}];
          }];
          
          stub.name = @"getSucceeds";
        });
        
        afterEach(^{
          [OHHTTPStubs removeStub:stub];
        });
        
        it(@"executes the success block with the source, pagination and links info", ^{
          
          __block CJPaginationInfo *thePagination = nil;
          __block CJLinksInfo *theLinks = nil;
          __block NSDictionary *theResponse = nil;
          
          [request performWithSuccess:^(id response, CJPaginationInfo *pagination, CJLinksInfo *links) {
            theResponse = response;
            thePagination = pagination;
            theLinks = links;
          } failure:nil];
          
          [[expectFutureValue(theResponse) shouldEventually] equal:stubbedResponse[@"events"]];
          [[expectFutureValue(thePagination.currentPage) shouldEventually] equal:stubbedResponse[@"_pagination"][@"currentPage"]];
          [[expectFutureValue(theLinks.links) shouldEventually] equal:stubbedResponse[@"_links"]];
        });
  
        context(@"When the cache policy is not CJAPIRequestReturnCacheDataThenLoad", ^{
          beforeAll(^{
            [CJEngine sharedEngine].cachePolicy = CJAPIRequestReturnCacheDataElseLoad;
          });
          
          afterAll(^{
            [CJEngine sharedEngine].cachePolicy = CJAPIRequestUseProtocolCachePolicy;
          });
          
          it(@"performs the request only once", ^{
            __block NSInteger requestCount = 0;
            
            [request performWithSuccess:^(id response, id pagination, id links) {
              requestCount++;
            } failure:nil];
            
            [[expectFutureValue(theValue(requestCount)) shouldEventually] equal:theValue(1)];
          });
        });
        
        context(@"When the cache policy is CJAPIRequestReturnCacheDataThenLoad", ^{
          beforeAll(^{
            [CJEngine sharedEngine].cachePolicy = CJAPIRequestReturnCacheDataThenLoad;
          });
          
          afterAll(^{
            [CJEngine sharedEngine].cachePolicy = CJAPIRequestUseProtocolCachePolicy;
          });
          
          context(@"when the network is reachable", ^{
            beforeEach(^{
              [[AFNetworkReachabilityManager sharedManager] stub:@selector(isReachable) andReturn:theValue(YES)];
            });
            
            context(@"when there is a cached result", ^{
              beforeEach(^{
                [request stub:@selector(willDeleteCached) andReturn:theValue(YES)];
                request.retries = 0;
              });
              
              it(@"performs the request twice", ^{
                __block NSInteger requestCount = 0;
                
                [request performWithSuccess:^(id response, id pagination, id links) {
                  requestCount++;
                } failure:nil];
                
                [[expectFutureValue(theValue(requestCount)) shouldEventually] equal:theValue(2)];
              });
            });
            
            context(@"when there isn't a cached result", ^{
              beforeEach(^{
                [request stub:@selector(willDeleteCached) andReturn:theValue(NO)];
              });
              
              it(@"performs the request only once", ^{
                __block NSInteger requestCount = 0;
                
                [request performWithSuccess:^(id response, id pagination, id links) {
                  requestCount++;
                } failure:nil];
                
                [[expectFutureValue(theValue(requestCount)) shouldEventually] equal:theValue(1)];
              });
            });
          });
          
          context(@"when the network is not reachable", ^{
            beforeEach(^{
              [[AFNetworkReachabilityManager sharedManager] stub:@selector(isReachable) andReturn:theValue(NO)];
            });
            
            it(@"performs the request only once", ^{
              __block NSInteger requestCount = 0;
              
              [request performWithSuccess:^(id response, id pagination, id links) {
                requestCount++;
              } failure:nil];
              
              [[expectFutureValue(theValue(requestCount)) shouldEventually] equal:theValue(1)];
            });
            
            it(@"does not delete the cache", ^{
              [[request shouldNotEventually] receive:@selector(willDeleteCached)];
              [request performWithSuccess:nil failure:nil];
            });
          });
        });
        
        context(@"When a model class is defined", ^{
          
          beforeEach(^{
            request.modelClass = [MockModel class];
          });
          
          context(@"When the response is a single entity", ^{
            beforeAll(^{
              stubbedResponse = @{
                                  @"event": @{
                                      @"id": @"5",
                                      @"_links": @{
                                        @"artists": @"http://artists",
                                        @"venue": @"http://venue"
                                      }
                                    }
                                  };
            });
            
            it(@"Returns a model object to the success block if a modelClass property is defined", ^{
              __block id theResponse = nil;
              
              [request performWithSuccess:^(id response, CJPaginationInfo *pagination, CJLinksInfo *links) {
                theResponse = response;
              } failure:nil];
              
              [[expectFutureValue(theResponse) shouldEventually] beKindOfClass:[request.modelClass class]];
            });
          });
          
          context(@"When the response is an array of entities", ^{
            it(@"Returns an array of model objects to the success block if a modelClass property is defined", ^{
              __block id theResponse = nil;
              
              [request performWithSuccess:^(id response, CJPaginationInfo *pagination, CJLinksInfo *links) {
                theResponse = response;
              } failure:nil];
              
              [[expectFutureValue(theResponse) shouldEventually] beKindOfClass:[NSArray class]];
              [[expectFutureValue(theResponse[0]) shouldEventually] beKindOfClass:[request.modelClass class]];
              [[expectFutureValue(theResponse[1]) shouldEventually] beKindOfClass:[request.modelClass class]];
            });
          });
        });
        
        it(@"returns a CJPaginationInfo model to the success block", ^{
          __block id thePagination = nil;
          
          [request performWithSuccess:^(id response, id pagination, id links) {
            thePagination = pagination;
          } failure:nil];
          
          [[expectFutureValue(thePagination) shouldEventually] beKindOfClass:[CJPaginationInfo class]];
        });
      });
    });
    
    context(@"When the method is POST", ^{
      
      __block CJAPIRequest *request;
      __block NSDictionary *params;
      beforeEach(^{
        request = [[CJAPIRequest alloc] initWithMethod:@"POST"
                                               andPath:@"/a/post/path"];
        params = @{
                   @"foo": @"bar",
                   @"bla": @[@"ble", @"bli"],
                   @"cat": @{
                       @"name": @"Mittens",
                       @"breed": @"Persian"
                       }
                   };
        request.parameters = params;
      });
      
      it(@"calls the POSTWithSuccess:failure: method", ^{
        [[request should] receive:@selector(POSTWithSuccess:failure:)];
        
        [request performWithSuccess:nil failure:nil];
      });
      
      it(@"requests the given path", ^{
        KWCaptureSpy *spy = [request.sessionManager captureArgument:@selector(POST:parameters:success:failure:)
                                                            atIndex:0];
        
        [request performWithSuccess:nil failure:nil];
        
        [[expectFutureValue(spy.argument) shouldEventually] equal:request.path];
      });
      
      it(@"sends all parameters", ^{
        KWCaptureSpy *spy = [request.sessionManager captureArgument:@selector(POST:parameters:success:failure:)
                                                            atIndex:1];
        
        [request performWithSuccess:nil failure:nil];
        
        params = [NSMutableDictionary dictionaryWithDictionary:params];
        [params setValue:[CJEngine userToken] forKeyPath:@"token"];
        [params setValue:[CJEngine clientKey] forKeyPath:@"clientId"];
        
        [[expectFutureValue(spy.argument) shouldEventually] equal:params];
      });
      
      context(@"when POST succeeds", ^{
        __block id<OHHTTPStubsDescriptor> stub = nil;
        
        beforeEach(^{
          request = [[CJAPIRequest alloc] initWithMethod:@"POST"
                                                 andPath:@"/a/post/path"];
          
          stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *req) {
            return [req.URL.path isEqualToString:@"/v1/a/post/path.json"];
          } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *req) {
            NSError *error;
            NSData *data = [NSJSONSerialization dataWithJSONObject:@{}
                                                           options:kNilOptions
                                                             error:&error];
            
            return [OHHTTPStubsResponse responseWithData:data
                                              statusCode:201
                                                 headers:@{@"Content-Type":@"text/json"}];
          }];
          
          stub.name = @"postSucceeds";
        });
        
        afterEach(^{
          [OHHTTPStubs removeStub:stub];
        });
        
        it(@"executes the success block", ^{
          
          __block BOOL responseProcessed = NO;
          
          [request performWithSuccess:^(id response, id pagination, id links) {
            responseProcessed = YES;
          } failure:nil];
          
          [[expectFutureValue(theValue(responseProcessed)) shouldEventually] beTrue];
        });
      });
    });
    
    context(@"When the method is PUT", ^{
      
      __block CJAPIRequest *request;
      __block NSDictionary *params;
      beforeEach(^{
        request = [[CJAPIRequest alloc] initWithMethod:@"PUT"
                                               andPath:@"/a/put/path"];
        params = @{
                   @"foo": @"bar",
                   @"bla": @[@"ble", @"bli"],
                   @"cat": @{
                       @"name": @"Mittens",
                       @"breed": @"Persian"
                       }
                   };
        request.parameters = params;
      });
      
      it(@"calls the PUTWithSuccess:failure: method", ^{
        [[request should] receive:@selector(PUTWithSuccess:failure:)];
        
        [request performWithSuccess:nil failure:nil];
      });
      
      it(@"requests the given path", ^{
        KWCaptureSpy *spy = [request.sessionManager captureArgument:@selector(PUT:parameters:success:failure:)
                                                            atIndex:0];
        
        [request performWithSuccess:nil failure:nil];
        
        [[expectFutureValue(spy.argument) shouldEventually] equal:request.path];
      });
      
      it(@"sends all parameters", ^{
        KWCaptureSpy *spy = [request.sessionManager captureArgument:@selector(PUT:parameters:success:failure:)
                                                            atIndex:1];
        
        [request performWithSuccess:nil failure:nil];
        
        params = [NSMutableDictionary dictionaryWithDictionary:params];
        [params setValue:[CJEngine userToken] forKeyPath:@"token"];
        [params setValue:[CJEngine clientKey] forKeyPath:@"clientId"];
        
        [[expectFutureValue(spy.argument) shouldEventually] equal:params];
      });
      
      context(@"when PUT succeeds", ^{
        __block id<OHHTTPStubsDescriptor> stub = nil;
        
        beforeEach(^{
          stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *req) {
            return [req.URL.path isEqualToString:@"/v1/a/put/path.json"];
          } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *req) {
            NSError *error;
            NSData *data = [NSJSONSerialization dataWithJSONObject:@{}
                                                           options:kNilOptions
                                                             error:&error];
            
            return [OHHTTPStubsResponse responseWithData:data
                                              statusCode:201
                                                 headers:@{@"Content-Type":@"text/json"}];
          }];
          
          stub.name = @"putSucceeds";
        });
        
        afterEach(^{
          [OHHTTPStubs removeStub:stub];
        });
        
        it(@"executes the success block", ^{
          
          __block BOOL responseProcessed = NO;
          
          [request performWithSuccess:^(id response, id pagination, id links) {
            responseProcessed = YES;
          } failure:nil];
          
          [[expectFutureValue(theValue(responseProcessed)) shouldEventually] beTrue];
        });
      });
    });
    
    context(@"When the method is DELETE", ^{
      
      __block CJAPIRequest *request;
      beforeEach(^{
        request = [[CJAPIRequest alloc] initWithMethod:@"DELETE"
                                               andPath:@"/a/delete/path"];
      });
      
      it(@"calls the DELETEWithSuccess:failure: method", ^{
        [[request should] receive:@selector(DELETEWithSuccess:failure:)];
        
        [request performWithSuccess:nil failure:nil];
      });
      
      it(@"requests the given path", ^{
        KWCaptureSpy *spy = [request.sessionManager captureArgument:@selector(DELETE:parameters:success:failure:)
                                                            atIndex:0];
        
        [request performWithSuccess:nil failure:nil];
        
        [[expectFutureValue(spy.argument) shouldEventually] equal:request.path];
      });
      
      context(@"when DELETE succeeds", ^{
        __block id<OHHTTPStubsDescriptor> stub = nil;
        
        beforeEach(^{
          stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *req) {
            return [req.URL.path isEqualToString:@"/v1/a/delete/path.json"];
          } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *req) {
            NSError *error;
            NSData *data = [NSJSONSerialization dataWithJSONObject:@{}
                                                           options:kNilOptions
                                                             error:&error];
            
            return [OHHTTPStubsResponse responseWithData:data
                                              statusCode:204
                                                 headers:@{@"Content-Type":@"text/json"}];
          }];
          
          stub.name = @"deleteSucceeds";
        });
        
        afterEach(^{
          [OHHTTPStubs removeStub:stub];
        });
        
        it(@"executes the success block", ^{
          
          __block BOOL responseProcessed = NO;
          
          [request performWithSuccess:^(id response, id pagination, id links) {
            responseProcessed = YES;
          } failure:nil];
          
          [[expectFutureValue(theValue(responseProcessed)) shouldEventually] beTrue];
        });
      });
    });
  });
  
  describe(@"Error handling", ^{
    describe(@"#developerMessageFromRequest:error:", ^{
      
      __block CJAPIRequest *request;
      __block id responseMock;
      __block NSDictionary *error;
      
      beforeEach(^{
        request = [[CJAPIRequest alloc] initWithMethod:@"GET"
                                               andPath:@"/a/get/error/path"];
        
        responseMock = [NSHTTPURLResponse mock];
        [[responseMock should] receive:@selector(statusCode) andReturn:theValue(500)];
        
        error = @{
                  @"developerMessage": @"A developer message"
                  };
      });
      
      it(@"produces a formatted message for logging", ^{
        NSString *message = [request developerMessageFromResponse:responseMock
                                                            error:error];
        
        [[message should] equal:@"GET request to /v1/a/get/error/path.json returned an error with code 500: A developer message"];
        
      });
    });
    
    context(@"GET requests", ^{
      
      __block id<OHHTTPStubsDescriptor> stub = nil;
      __block CJAPIRequest *request;
      beforeEach(^{
        request = [[CJAPIRequest alloc] initWithMethod:@"GET"
                                               andPath:@"/a/get/error/path"];
        
        stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *req) {
          return [req.URL.path isEqualToString:@"/v1/a/get/error/path.json"];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *req) {
          NSError *error;
          NSData *data = [NSJSONSerialization dataWithJSONObject:@{
                                                                   @"developerMessage": @"There was an error while processing this request. There is probably something wrong with the API server.",
                                                                   @"userMessage": @"There was an error while processing this request.",
                                                                   @"errorCode": @500
                                                                   }
                                                         options:kNilOptions
                                                           error:&error];
          
          return [OHHTTPStubsResponse responseWithData:data
                                            statusCode:500
                                               headers:@{@"Content-Type":@"text/json"}];
        }];
        
        stub.name = @"getError";
      });
      
      afterEach(^{
        [OHHTTPStubs removeAllStubs];
      });
      
      it(@"executes the failure block", ^{
        __block NSString *developerMessage;
        __block NSString *userMessage;
        __block NSNumber *errorCode;
        
        [request performWithSuccess:nil
                            failure:^(NSDictionary *error, NSNumber *statusCode) {
                              developerMessage = [error objectForKey:@"developerMessage"];
                              userMessage = [error objectForKey:@"userMessage"];
                              errorCode = statusCode;
                            }];
        
        [[expectFutureValue(developerMessage) shouldEventually] equal:@"There was an error while processing this request. There is probably something wrong with the API server."];
        [[expectFutureValue(userMessage) shouldEventually] equal:@"There was an error while processing this request."];
        [[expectFutureValue(errorCode) shouldEventually] equal:@500];
      });
      
      it(@"logs the error message", ^{
        [[request shouldEventually] receive:@selector(developerMessageFromResponse:error:)];
        
        [request performWithSuccess:nil
                            failure:nil];
      });
    });
    
    context(@"POST requests", ^{
      
      __block id<OHHTTPStubsDescriptor> stub = nil;
      __block CJAPIRequest *request;
      beforeEach(^{
        request = [[CJAPIRequest alloc] initWithMethod:@"POST"
                                               andPath:@"/a/post/error/path"];
        
        stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *req) {
          return [req.URL.path isEqualToString:@"/v1/a/post/error/path.json"];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *req) {
          NSError *error;
          NSData *data = [NSJSONSerialization dataWithJSONObject:@{
                                                                   @"developerMessage": @"There was an error while processing this request. There is probably something wrong with the API server.",
                                                                   @"userMessage": @"There was an error while processing this request.",
                                                                   @"errorCode": @500
                                                                   }
                                                         options:kNilOptions
                                                           error:&error];
          
          return [OHHTTPStubsResponse responseWithData:data
                                            statusCode:500
                                               headers:@{@"Content-Type":@"text/json"}];
        }];
        
        stub.name = @"postError";
      });
      
      afterEach(^{
        [OHHTTPStubs removeStub:stub];
      });
      
      it(@"executes the failure block", ^{
        __block NSString *developerMessage;
        __block NSString *userMessage;
        __block NSNumber *errorCode;
        
        [request performWithSuccess:nil
                            failure:^(NSDictionary *error, NSNumber *statusCode) {
                              developerMessage = [error objectForKey:@"developerMessage"];
                              userMessage = [error objectForKey:@"userMessage"];
                              errorCode = statusCode;
                            }];
        
        [[expectFutureValue(developerMessage) shouldEventually] equal:@"There was an error while processing this request. There is probably something wrong with the API server."];
        [[expectFutureValue(userMessage) shouldEventually] equal:@"There was an error while processing this request."];
        [[expectFutureValue(errorCode) shouldEventually] equal:@500];
      });
    });
    
    context(@"PUT requests", ^{
      
      __block id<OHHTTPStubsDescriptor> stub = nil;
      __block CJAPIRequest *request;
      beforeEach(^{
        request = [[CJAPIRequest alloc] initWithMethod:@"PUT"
                                               andPath:@"/a/put/error/path"];
        
        stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *req) {
          return [req.URL.path isEqualToString:@"/v1/a/put/error/path.json"];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *req) {
          NSError *error;
          NSData *data = [NSJSONSerialization dataWithJSONObject:@{
                                                                   @"developerMessage": @"There was an error while processing this request. There is probably something wrong with the API server.",
                                                                   @"userMessage": @"There was an error while processing this request.",
                                                                   @"errorCode": @500
                                                                   }
                                                         options:kNilOptions
                                                           error:&error];
          
          return [OHHTTPStubsResponse responseWithData:data
                                            statusCode:500
                                               headers:@{@"Content-Type":@"text/json"}];
        }];
        
        stub.name = @"putError";
      });
      
      afterEach(^{
        [OHHTTPStubs removeStub:stub];
      });
      
      it(@"executes the failure block", ^{
        __block NSString *developerMessage;
        __block NSString *userMessage;
        __block NSNumber *errorCode;
        
        [request performWithSuccess:nil
                            failure:^(NSDictionary *error, NSNumber *statusCode) {
                              developerMessage = [error objectForKey:@"developerMessage"];
                              userMessage = [error objectForKey:@"userMessage"];
                              errorCode = statusCode;
                            }];
        
        [[expectFutureValue(developerMessage) shouldEventually] equal:@"There was an error while processing this request. There is probably something wrong with the API server."];
        [[expectFutureValue(userMessage) shouldEventually] equal:@"There was an error while processing this request."];
        [[expectFutureValue(errorCode) shouldEventually] equal:@500];
      });
      
      it(@"logs the error message", ^{
        [[request shouldEventually] receive:@selector(developerMessageFromResponse:error:)];
        
        [request performWithSuccess:nil
                            failure:nil];
      });
    });
    
    context(@"DELETE requests", ^{
      
      __block id<OHHTTPStubsDescriptor> stub = nil;
      __block CJAPIRequest *request;
      beforeEach(^{
        request = [[CJAPIRequest alloc] initWithMethod:@"DELETE"
                                               andPath:@"/a/delete/error/path"];
        
        stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *req) {
          return [req.URL.path isEqualToString:@"/v1/a/delete/error/path.json"];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *req) {
          NSError *error;
          NSData *data = [NSJSONSerialization dataWithJSONObject:@{
                                                                   @"developerMessage": @"There was an error while processing this request. There is probably something wrong with the API server.",
                                                                   @"userMessage": @"There was an error while processing this request.",
                                                                   @"errorCode": @500
                                                                   }
                                                         options:kNilOptions
                                                           error:&error];
          
          return [OHHTTPStubsResponse responseWithData:data
                                            statusCode:500
                                               headers:@{@"Content-Type":@"text/json"}];
        }];
        
        stub.name = @"deleteError";
      });
      
      afterEach(^{
        [OHHTTPStubs removeStub:stub];
      });
      
      it(@"executes the failure block", ^{
        __block NSString *developerMessage;
        __block NSString *userMessage;
        __block NSNumber *errorCode;
        
        [request performWithSuccess:nil
                            failure:^(NSDictionary *error, NSNumber *statusCode) {
                              developerMessage = [error objectForKey:@"developerMessage"];
                              userMessage = [error objectForKey:@"userMessage"];
                              errorCode = statusCode;
                            }];
        
        [[expectFutureValue(developerMessage) shouldEventually] equal:@"There was an error while processing this request. There is probably something wrong with the API server."];
        [[expectFutureValue(userMessage) shouldEventually] equal:@"There was an error while processing this request."];
        [[expectFutureValue(errorCode) shouldEventually] equal:@500];
      });
      
      it(@"logs the error message", ^{
        [[request shouldEventually] receive:@selector(developerMessageFromResponse:error:)];
        
        [request performWithSuccess:nil
                            failure:nil];
      });
    });
  });
  
  context(@"PromiseKit support", ^{
    __block CJAPIRequest *request;
    beforeEach(^{
      request = [[CJAPIRequest alloc] initWithMethod:@"GET"
                                             andPath:@"/a/path"];
      
    });
    
    describe(@"#perform", ^{
      it(@"returns a Promise", ^{
        id promise = [request perform];
        [[promise should] beKindOfClass:[PMKPromise class]];
      });
      
      context(@"when the request succeeds", ^{
        __block NSDictionary *stubbedResponse;
        __block id<OHHTTPStubsDescriptor> stub = nil;
        
        beforeEach(^{
          stubbedResponse = @{
                              @"events": @[
                                  @{@"id": @"5"},
                                  @{@"id": @"10"}
                                  ],
                              @"_pagination": @{
                                  @"currentPage": @1,
                                  @"perPage": @10,
                                  @"totalPages": @5,
                                  @"totalItems": @47
                                  },
                              @"_links": @{
                                  @"artists": @"http://artists",
                                  @"venue": @"http://venue"
                                  }
                              };
          
          stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *req) {
            return [req.URL.path isEqualToString:@"/v1/a/path.json"];
          } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *req) {
            NSError *error;
            NSData *data = [NSJSONSerialization dataWithJSONObject:stubbedResponse
                                                           options:kNilOptions
                                                             error:&error];
            
            return [OHHTTPStubsResponse responseWithData:data
                                              statusCode:200
                                                 headers:@{@"Content-Type":@"text/json"}];
          }];
          
          stub.name = @"getSucceeds";
        });
        
        it(@"executes #then with a response dictionary", ^{
          PMKPromise *myRequest = [request perform];
          
          __block BOOL hasResponse = NO;
          __block BOOL hasPagination = NO;
          __block BOOL hasLinks = NO;
          
          myRequest.then(^(NSDictionary *result){
            hasResponse = [result hasKey:@"response"];
            hasPagination = [result hasKey:@"pagination"];
            hasLinks = [result hasKey:@"links"];
          });
          
          [[expectFutureValue(theValue(hasResponse)) shouldEventually] beYes];
          [[expectFutureValue(theValue(hasPagination)) shouldEventually] beYes];
          [[expectFutureValue(theValue(hasLinks)) shouldEventually] beYes];
        });
      });
      
      context(@"when the request fails", ^{
        __block id<OHHTTPStubsDescriptor> stub = nil;
        
        beforeEach(^{
          [request setPath:@"/an/error/path"];
          
          stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *req) {
            return [req.URL.path isEqualToString:@"/v1/an/error/path.json"];
          } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *req) {
            NSError *error;
            NSData *data = [NSJSONSerialization dataWithJSONObject:@{
                                                                     @"developerMessage": @"There was an error while processing this request. There is probably something wrong with the API server.",
                                                                     @"userMessage": @"There was an error while processing this request.",
                                                                     @"errorCode": @500
                                                                     }
                                                           options:kNilOptions
                                                             error:&error];
            
            return [OHHTTPStubsResponse responseWithData:data
                                              statusCode:500
                                                 headers:@{@"Content-Type":@"text/json"}];
          }];
          
          stub.name = @"getError";
        });
        
        it(@"executes #catch with an error dictionary", ^{
          PMKPromise *myRequest = [request perform];
          
          __block BOOL hasError = NO;
          
          myRequest.catch(^(NSError *error){
            hasError = YES;
          });
          
          [[expectFutureValue(theValue(hasError)) shouldEventually] beYes];
        });
      });
      
      context(@"When cache policy is CJAPIRequestReturnCacheDataThenLoad", ^{
        __block NSDictionary *stubbedResponse;
        __block id<OHHTTPStubsDescriptor> stub = nil;
        
        beforeEach(^{
          [[CJEngine sharedEngine] setCachePolicy:CJAPIRequestReturnCacheDataThenLoad];
          request = [[CJAPIRequest alloc] initWithMethod:@"GET"
                                                 andPath:@"/a/path"];
          request.retries = 0;
          
          [request stub:@selector(willDeleteCached) andReturn:theValue(YES)];
          
          stubbedResponse = @{
                              @"events": @[
                                  @{@"id": @"5"},
                                  @{@"id": @"10"}
                                  ],
                              @"_pagination": @{
                                  @"currentPage": @1,
                                  @"perPage": @10,
                                  @"totalPages": @5,
                                  @"totalItems": @47
                                  },
                              @"_links": @{
                                  @"artists": @"http://artists",
                                  @"venue": @"http://venue"
                                  }
                              };
          
          stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *req) {
            return [req.URL.path isEqualToString:@"/v1/a/path.json"];
          } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *req) {
            NSError *error;
            NSData *data = [NSJSONSerialization dataWithJSONObject:stubbedResponse
                                                           options:kNilOptions
                                                             error:&error];
            
            return [OHHTTPStubsResponse responseWithData:data
                                              statusCode:200
                                                 headers:@{@"Content-Type":@"text/json"}];
          }];
          
          stub.name = @"getSucceeds";
        });
        
        afterEach(^{
          request.retries = 0;
        });
        
        it(@"fulfills with a Promise as its second argument", ^{
          __block id theNextRequest = nil;
          
          [request perform]
          .then(^(id data, id nextRequest) {
            theNextRequest = nextRequest;
          });
          
          [[expectFutureValue(theNextRequest) shouldEventually] beKindOfClass:[PMKPromise class]];
        });
        
        it(@"fulfills the new Promise with fresh data", ^{
          __block BOOL hasResponse = NO;
          __block BOOL hasPagination = NO;
          __block BOOL hasLinks = NO;
          
          [request perform]
          .then(^(id data, PMKPromise *nextRequest) {
            return nextRequest;
          })
          .then(^(NSDictionary *result){
            hasResponse = [result hasKey:@"response"];
            hasPagination = [result hasKey:@"pagination"];
            hasLinks = [result hasKey:@"links"];
          });
          
          [[expectFutureValue(theValue(hasResponse)) shouldEventually] beYes];
          [[expectFutureValue(theValue(hasPagination)) shouldEventually] beYes];
          [[expectFutureValue(theValue(hasLinks)) shouldEventually] beYes];
        });
      });
    });
  });
  
  describe(@"Persistent Queue support", ^{
    __block CJAPIRequest *request;
    __block CJPersistentQueueController *queueController;
    
    context(@"When it's a POST request", ^{
      beforeEach(^{
        request = [[CJAPIRequest alloc] initWithMethod:@"POST" andPath:@"/bla"];
        
        queueController = [CJPersistentQueueController sharedController];
      });
      
      context(@"When the network is available", ^{
        beforeEach(^{
          [[AFNetworkReachabilityManager sharedManager] stub:@selector(isReachable)
                                                   andReturn:theValue(YES)];
        });
        
        it(@"does not add the request to the queue", ^{
          [[queueController.queue shouldNot] receive:@selector(addObject:)];
          [request performWithSuccess:nil failure:nil];
        });
      });
      
      context(@"When the network is unavailable", ^{
        beforeEach(^{
          [[AFNetworkReachabilityManager sharedManager] stub:@selector(isReachable)
                                                   andReturn:theValue(NO)];
        });
        
        it(@"adds the request to the queue", ^{
          [[queueController.queue should] receive:@selector(addObject:)];
          [request performWithSuccess:nil failure:nil];
        });
        
        it(@"invokes it's success block immediately with nil values", ^{
          
          [request stub:@selector(saveRequestForLater)];
          __block BOOL invoked = NO;
          
          [request performWithSuccess:^(id response, CJPaginationInfo *pagination, CJLinksInfo *links) {
            invoked = YES;
          }
                              failure:nil];
          
          [[expectFutureValue(theValue(invoked)) shouldEventually] beTrue];
        });
      });
    });
    
    context(@"When it's a PUT request", ^{
      beforeEach(^{
        request = [[CJAPIRequest alloc] initWithMethod:@"PUT" andPath:@"/bla"];
        
        queueController = [CJPersistentQueueController sharedController];
      });
      
      context(@"When the network is available", ^{
        beforeEach(^{
          [[AFNetworkReachabilityManager sharedManager] stub:@selector(isReachable)
                                                   andReturn:theValue(YES)];
        });
        
        it(@"does not add the request to the queue", ^{
          [[queueController.queue shouldNot] receive:@selector(addObject:)];
          [request performWithSuccess:nil failure:nil];
        });
      });
      
      context(@"When the network is unavailable", ^{
        beforeEach(^{
          [[AFNetworkReachabilityManager sharedManager] stub:@selector(isReachable)
                                                   andReturn:theValue(NO)];
        });
        
        it(@"adds the request to the queue", ^{
          [[queueController.queue should] receive:@selector(addObject:)];
          [request performWithSuccess:nil failure:nil];
        });
        
        it(@"invokes it's success block immediately with nil values", ^{
          
          [request stub:@selector(saveRequestForLater)];
          __block BOOL invoked = NO;
          
          [request performWithSuccess:^(id response, CJPaginationInfo *pagination, CJLinksInfo *links) {
            invoked = YES;
          }
                              failure:nil];
          
          [[expectFutureValue(theValue(invoked)) shouldEventually] beTrue];
        });
      });
    });
    
    context(@"When it's a DELETE request", ^{
      beforeEach(^{
        request = [[CJAPIRequest alloc] initWithMethod:@"DELETE" andPath:@"/bla"];
        
        queueController = [CJPersistentQueueController sharedController];
      });
      
      context(@"When the network is available", ^{
        beforeEach(^{
          [[AFNetworkReachabilityManager sharedManager] stub:@selector(isReachable)
                                                   andReturn:theValue(YES)];
        });
        
        it(@"does not add the request to the queue", ^{
          [[queueController.queue shouldNot] receive:@selector(addObject:)];
          [request performWithSuccess:nil failure:nil];
        });
      });
      
      context(@"When the network is unavailable", ^{
        beforeEach(^{
          [[AFNetworkReachabilityManager sharedManager] stub:@selector(isReachable)
                                                   andReturn:theValue(NO)];
        });
        
        it(@"adds the request to the queue", ^{
          [[queueController.queue should] receive:@selector(addObject:)];
          [request performWithSuccess:nil failure:nil];
        });
        
        it(@"invokes it's success block immediately with nil values", ^{
          
          [request stub:@selector(saveRequestForLater)];
          __block BOOL invoked = NO;
          
          [request performWithSuccess:^(id response, CJPaginationInfo *pagination, CJLinksInfo *links) {
            invoked = YES;
          }
                              failure:nil];
          
          [[expectFutureValue(theValue(invoked)) shouldEventually] beTrue];
        });
      });
    });
  });
});

SPEC_END