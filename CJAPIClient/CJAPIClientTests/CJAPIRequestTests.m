//
//  CJAPIRequestTests.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 16/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CJAPIRequest.h"
#import <AFNetworking/AFNetworking.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "CJEngine.h"
#import "CJPaginationInfo.h"
#import "CJLinksInfo.h"

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

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

SPEC_BEGIN(CJAPIREQUESTSPEC)

describe(@"CJAPIRequest", ^{
  
  beforeAll(^{
    [OHHTTPStubs removeAllStubs];
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
            return [req.URL.path isEqualToString:@"/a/path"];
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
            return [req.URL.path isEqualToString:@"/a/post/path"];
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
            return [req.URL.path isEqualToString:@"/a/put/path"];
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
            return [req.URL.path isEqualToString:@"/a/delete/path"];
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
        
        [[message should] equal:@"GET request to /a/get/error/path returned an error with code 500: A developer message"];
        
      });
    });
    
    context(@"GET requests", ^{
      
      __block id<OHHTTPStubsDescriptor> stub = nil;
      __block CJAPIRequest *request;
      beforeEach(^{
        request = [[CJAPIRequest alloc] initWithMethod:@"GET"
                                               andPath:@"/a/get/error/path"];
        
        stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *req) {
          return [req.URL.path isEqualToString:@"/a/get/error/path"];
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
          return [req.URL.path isEqualToString:@"/a/post/error/path"];
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
      
      it(@"logs the error message", ^{
        [[request shouldEventually] receive:@selector(developerMessageFromResponse:error:)];
        
        [request performWithSuccess:nil
                            failure:nil];
      });
    });
    
    context(@"PUT requests", ^{
      
      __block id<OHHTTPStubsDescriptor> stub = nil;
      __block CJAPIRequest *request;
      beforeEach(^{
        request = [[CJAPIRequest alloc] initWithMethod:@"PUT"
                                               andPath:@"/a/put/error/path"];
        
        stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *req) {
          return [req.URL.path isEqualToString:@"/a/put/error/path"];
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
          return [req.URL.path isEqualToString:@"/a/delete/error/path"];
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
});

SPEC_END