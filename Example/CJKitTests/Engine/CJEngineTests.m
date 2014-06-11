//
//  CJEngineTests.m
//  CJKit
//
//  Created by Bruno Abrantes on 14/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "CJEngine.h"
#import "CJEngineConfiguration.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "CJEngine+PromiseKit.h"
#import "CJUser.h"
#import "CJCity.h"

@interface CJEngine()

#ifdef IS_OS_7_OR_LATER
@property (nonatomic, strong) AFHTTPSessionManager *authSessionManager;
#else
@property (nonatomic, strong) AFHTTPRequestOperationManager *authSessionManager;
#endif

@end

SPEC_BEGIN(CJENGINESPEC)

describe(@"Engine", ^{
  
  beforeEach(^{
    [OHHTTPStubs removeAllStubs];
  });
  
  afterEach(^{
    [OHHTTPStubs removeAllStubs];
  });
  
  context(@"When initialising", ^{
    it(@"returns a shared object", ^{
      CJEngine *engine = [CJEngine sharedEngine];
      CJEngine *engine2 = [CJEngine sharedEngine];
      
      [[engine should] beKindOfClass:[CJEngine class]];
      [[engine should] equal:engine2];
    });
    
    describe(@"Request Session manager", ^{
      __block CJEngine *engine = nil;
      beforeAll(^{
        engine = [[CJEngine sharedEngine] init];
      });
      
      it(@"instantiates a session manager", ^{
        [[engine.sessionManager should] beNonNil];
      });
      
      it(@"sets a request serializer with the Engine's default cache policy", ^{
        [[theValue(engine.sessionManager.requestSerializer.cachePolicy) should] equal:theValue(CJAPIRequestUseProtocolCachePolicy)];
      });
    });
    
    describe(@"Auth Session manager", ^{
      __block CJEngine *engine = nil;
      beforeAll(^{
        engine = [CJEngine sharedEngine];
      });
      
      it(@"instantiates a session manager", ^{
        [[engine.authSessionManager should] beNonNil];
      });
      
      it(@"sets a request serializer with a no cache policy", ^{
        [[theValue(engine.authSessionManager.requestSerializer.cachePolicy) should] equal:theValue(CJAPIRequestReloadIgnoringCacheData)];
      });
    });
  });
  
  describe(@".setClientKey", ^{
    it(@"sets the clientKey class property", ^{
      [CJEngine setClientKey:@"kittens"];
      
      [[[CJEngine clientKey] should] equal:@"kittens"];
    });
  });
  
  describe(@".setUserToken", ^{
    it(@"sets the userToken class property", ^{
      [CJEngine setUserToken:@"a_user_token"];
      
      [[[CJEngine userToken] should] equal:@"a_user_token"];
    });
  });
  
  describe(@"#cachePolicy", ^{
    __block CJEngine *engine = nil;
    beforeAll(^{
      engine = [CJEngine sharedEngine];
    });
    
    it(@"sets the cachePolicy for the engine's sessionManager request serializer", ^{
      [engine setCachePolicy:CJAPIRequestReturnCacheDataElseLoad];
      [[theValue(engine.sessionManager.requestSerializer.cachePolicy) should] equal:theValue(CJAPIRequestReturnCacheDataElseLoad)];
    });
    
    context(@"when the cache policy is CJAPIRequestReturnCacheDataThenLoad", ^{
      beforeAll(^{
        [engine setCachePolicy:CJAPIRequestReturnCacheDataThenLoad];
      });
      
      it(@"sets the cachePolicy to CJAPIRequestReturnCacheDataElseLoad", ^{
        [[theValue(engine.sessionManager.requestSerializer.cachePolicy) should] equal:theValue(CJAPIRequestReturnCacheDataElseLoad)];
      });
    });
  });
  
  describe(@"#authenticateWithFacebookToken:withSuccess:andFailure", ^{
    it(@"POSTs a request to the authentication API", ^{
      CJEngine *engine = [CJEngine sharedEngine];
      
      KWCaptureSpy *pathSpy = [engine.authSessionManager captureArgument:@selector(POST:parameters:success:failure:) atIndex:0];
      KWCaptureSpy *tokenSpy = [engine.authSessionManager captureArgument:@selector(POST:parameters:success:failure:) atIndex:1];
      
      [engine authenticateWithFacebookToken:@"12345667abcd"
                                withSuccess:nil
                                 andFailure:nil];
      
      [[expectFutureValue(pathSpy.argument) shouldEventually] equal:@"tokens"];
      [[expectFutureValue(tokenSpy.argument) shouldEventually] equal:@{@"facebook_token": @"12345667abcd", @"app_key": [CJEngine clientKey]}];
    });
    
    context(@"when POST succeeds", ^{
      __block NSDictionary *stubbedResponse;
      __block id<OHHTTPStubsDescriptor> stub = nil;
      
      beforeEach(^{
        stubbedResponse = @{
                            @"token": @"a_token"
                            };
        
        stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *req) {
          return ([req.URL.path isEqualToString:@"/tokens"]);
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *req) {
          NSError *error;
          NSData *data = [NSJSONSerialization dataWithJSONObject:stubbedResponse
                                                         options:kNilOptions
                                                           error:&error];
          
          return [OHHTTPStubsResponse responseWithData:data
                                            statusCode:200
                                               headers:@{@"Content-Type":@"text/json"}];
        }];
        
        stub.name = @"postSucceeds";
      });
      
      afterEach(^{
        [OHHTTPStubs removeStub:stub];
      });
      
      it(@"sets the Engine's .userToken to the \"token\" key in the response", ^{
        CJEngine *engine = [CJEngine sharedEngine];
        [engine authenticateWithFacebookToken:@"123456" withSuccess:nil andFailure:nil];
        [[expectFutureValue([CJEngine userToken]) shouldEventually] equal:@"a_token"];
      });
      
      it(@"invokes the success block with the token as an argument", ^{
        CJEngine *engine = [CJEngine sharedEngine];
        __block NSString *expectedToken = nil;
        
        [engine authenticateWithFacebookToken:@"123456"
                                  withSuccess:^(NSString *token) {
                                    expectedToken = token;
                                  }
                                   andFailure:nil];
        
        [[expectFutureValue(expectedToken) shouldEventually] equal:@"a_token"];
      });
    });
    
    context(@"when POST fails", ^{
      __block NSDictionary *stubbedResponse;
      __block id<OHHTTPStubsDescriptor> stub = nil;
      
      beforeEach(^{
        stubbedResponse = @{
                            @"error": @"bla"
                            };
        
        [CJEngine setUserToken:@"something"];
        
        stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *req) {
          return ([req.URL.path isEqualToString:@"/tokens"]);
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *req) {
          NSError *error;
          NSData *data = [NSJSONSerialization dataWithJSONObject:stubbedResponse
                                                         options:kNilOptions
                                                           error:&error];
          
          return [OHHTTPStubsResponse responseWithData:data
                                            statusCode:500
                                               headers:@{@"Content-Type":@"text/json"}];
        }];
        
        stub.name = @"postSucceeds";
      });
      
      afterEach(^{
        [OHHTTPStubs removeStub:stub];
      });
      
      it(@"sets the Engine's .userToken to nil", ^{
        CJEngine *engine = [CJEngine sharedEngine];
        [engine authenticateWithFacebookToken:@"123456" withSuccess:nil andFailure:nil];
        [[expectFutureValue([CJEngine userToken]) shouldEventually] beNil];
      });
      
      it(@"invokes the failure block with the error as an argument", ^{
        CJEngine *engine = [CJEngine sharedEngine];
        __block NSError *expectedError = nil;
        
        [engine authenticateWithFacebookToken:@"123456"
                                  withSuccess:nil
                                   andFailure:^(NSError *error) {
                                     expectedError = error;
                                   }];
        
        [[expectFutureValue(expectedError) shouldEventually] beNonNil];
      });
      
      describe(@"PromiseKit support", ^{
        it(@"returns a Promise", ^{
          CJEngine *engine = [CJEngine sharedEngine];
          id promise = [engine authenticateWithFacebookToken:@"123456"];
          [[promise should] beKindOfClass:[Promise class]];
        });
      });

    });
  });
  
  
  describe(@"#authenticateWithUsername:andPassword:withSuccess:andFailure", ^{
    it(@"POSTs a request to the authentication API", ^{
      CJEngine *engine = [CJEngine sharedEngine];
      
      KWCaptureSpy *pathSpy = [engine.authSessionManager captureArgument:@selector(POST:parameters:success:failure:) atIndex:0];
      KWCaptureSpy *tokenSpy = [engine.authSessionManager captureArgument:@selector(POST:parameters:success:failure:) atIndex:1];
      
      [engine authenticateWithUsername:@"a_username"
                           andPassword:@"a_password"
                           withSuccess:nil
                            andFailure:nil];
      
      [[expectFutureValue(pathSpy.argument) shouldEventually] equal:@"tokens"];
      [[expectFutureValue(tokenSpy.argument) shouldEventually] equal:@{@"email": @"a_username", @"password": @"a_password", @"app_key": [CJEngine clientKey]}];
    });
    
    context(@"when POST succeeds", ^{
      __block NSDictionary *stubbedResponse;
      __block id<OHHTTPStubsDescriptor> stub = nil;
      
      beforeEach(^{
        stubbedResponse = @{
                            @"token": @"a_token"
                            };
        
        stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *req) {
          return ([req.URL.path isEqualToString:@"/tokens"]);
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *req) {
          NSError *error;
          NSData *data = [NSJSONSerialization dataWithJSONObject:stubbedResponse
                                                         options:kNilOptions
                                                           error:&error];
          
          return [OHHTTPStubsResponse responseWithData:data
                                            statusCode:200
                                               headers:@{@"Content-Type":@"text/json"}];
        }];
        
        stub.name = @"postSucceeds";
      });
      
      afterEach(^{
        [OHHTTPStubs removeStub:stub];
      });
      
      it(@"sets the Engine's .userToken to the \"token\" key in the response", ^{
        CJEngine *engine = [CJEngine sharedEngine];
        [engine authenticateWithUsername:@"a_username"
                             andPassword:@"a_password"
                             withSuccess:nil
                              andFailure:nil];
        
        [[expectFutureValue([CJEngine userToken]) shouldEventually] equal:@"a_token"];
      });
      
      it(@"invokes the success block with the token as an argument", ^{
        CJEngine *engine = [CJEngine sharedEngine];
        __block NSString *expectedToken = nil;
        
        [engine authenticateWithUsername:@"a_username"
                             andPassword:@"a_password"
                             withSuccess:^(NSString *token) {
                               expectedToken = token;
                             }
                              andFailure:nil];

        [[expectFutureValue(expectedToken) shouldEventually] equal:@"a_token"];
      });
    });
    
    context(@"when POST fails", ^{
      __block NSDictionary *stubbedResponse;
      __block id<OHHTTPStubsDescriptor> stub = nil;
      
      beforeEach(^{
        stubbedResponse = @{
                            @"error": @"bla"
                            };
        
        [CJEngine setUserToken:@"something"];
        
        stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *req) {
          return ([req.URL.path isEqualToString:@"/tokens"]);
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *req) {
          NSError *error;
          NSData *data = [NSJSONSerialization dataWithJSONObject:stubbedResponse
                                                         options:kNilOptions
                                                           error:&error];
          
          return [OHHTTPStubsResponse responseWithData:data
                                            statusCode:500
                                               headers:@{@"Content-Type":@"text/json"}];
        }];
        
        stub.name = @"postSucceeds";
      });
      
      afterEach(^{
        [OHHTTPStubs removeStub:stub];
      });
      
      it(@"sets the Engine's .userToken to nil", ^{
        CJEngine *engine = [CJEngine sharedEngine];
        [engine authenticateWithUsername:@"a_username"
                             andPassword:@"a_password"
                             withSuccess:nil
                              andFailure:nil];
        
        [[expectFutureValue([CJEngine userToken]) shouldEventually] beNil];
      });
      
      it(@"invokes the failure block with the error as an argument", ^{
        CJEngine *engine = [CJEngine sharedEngine];
        __block NSError *expectedError = nil;
        
        [engine authenticateWithUsername:@"a_username"
                             andPassword:@"a_password"
                             withSuccess:nil
                              andFailure:^(NSError *error) {
                                expectedError = error;
                              }];
        
        [[expectFutureValue(expectedError) shouldEventually] beNonNil];
      });
      
      describe(@"PromiseKit support", ^{
        it(@"returns a Promise", ^{
          CJEngine *engine = [CJEngine sharedEngine];
          id promise = [engine authenticateWithUsername:@"a_username"
                                            andPassword:@"a_password"];
          
          [[promise should] beKindOfClass:[Promise class]];
        });
      });
      
    });
  });
  
  describe(@"#registerWithUser:withSuccess:andFailure", ^{
    
    __block CJUser *user;
    beforeEach(^{
      CJCity *city = [CJCity new];
      city.Id = @55;
      
      user = [CJUser new];
      user.email = @"a_username";
      user.password = @"a_password";
      user.firstName = @"John";
      user.lastName = @"Doe";
      user.address = @{@"city": city};
    });
    
    it(@"POSTs a request to the authentication API", ^{
      CJEngine *engine = [CJEngine sharedEngine];
      
      KWCaptureSpy *pathSpy = [engine.authSessionManager captureArgument:@selector(POST:parameters:success:failure:) atIndex:0];
      KWCaptureSpy *tokenSpy = [engine.authSessionManager captureArgument:@selector(POST:parameters:success:failure:) atIndex:1];
      
      [engine registerWithUser:user
                   withSuccess:nil
                    andFailure:nil];
      
      [[expectFutureValue(pathSpy.argument) shouldEventually] equal:@"users"];
      [[expectFutureValue(tokenSpy.argument) shouldEventually] equal:@{
                                                                       @"email": @"a_username",
                                                                       @"password": @"a_password",
                                                                       @"first_name": @"John",
                                                                       @"last_name": @"Doe",
                                                                       @"city": @{@"id": @55},
                                                                       @"app_key": [CJEngine clientKey]}];
    });

    context(@"when POST succeeds", ^{
      __block NSDictionary *stubbedResponse;
      __block id<OHHTTPStubsDescriptor> stub = nil;
      
      beforeEach(^{
        stubbedResponse = @{};
        
        stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *req) {
          return ([req.URL.path isEqualToString:@"/users"]);
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *req) {
          NSError *error;
          NSData *data = [NSJSONSerialization dataWithJSONObject:stubbedResponse
                                                         options:kNilOptions
                                                           error:&error];
          
          return [OHHTTPStubsResponse responseWithData:data
                                            statusCode:200
                                               headers:@{@"Content-Type":@"text/json"}];
        }];
        
        stub.name = @"postSucceeds";
      });
      
      afterEach(^{
        [OHHTTPStubs removeStub:stub];
      });
      
      it(@"invokes the success block", ^{
        CJEngine *engine = [CJEngine sharedEngine];
        __block BOOL executed = NO;
        
        [engine registerWithUser:user
                     withSuccess:^{
                       executed = YES;
                     }
                      andFailure:nil];
        
        [[expectFutureValue(theValue(executed)) shouldEventually] beYes];
      });
    });
    
    context(@"when POST fails", ^{
      __block NSDictionary *stubbedResponse;
      __block id<OHHTTPStubsDescriptor> stub = nil;
      
      beforeEach(^{
        stubbedResponse = @{
                            @"error": @"bla"
                            };
        
        stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *req) {
          return ([req.URL.path isEqualToString:@"/users"]);
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *req) {
          NSError *error;
          NSData *data = [NSJSONSerialization dataWithJSONObject:stubbedResponse
                                                         options:kNilOptions
                                                           error:&error];
          
          return [OHHTTPStubsResponse responseWithData:data
                                            statusCode:500
                                               headers:@{@"Content-Type":@"text/json"}];
        }];
        
        stub.name = @"postFails";
      });
      
      afterEach(^{
        [OHHTTPStubs removeStub:stub];
      });
      
      it(@"invokes the failure block with the error as an argument", ^{
        CJEngine *engine = [CJEngine sharedEngine];
        __block NSError *expectedError = nil;
        
        [engine registerWithUser:user
                     withSuccess:nil
                      andFailure:^(NSError *error) {
                        expectedError = error;
                      }];
        
        [[expectFutureValue(expectedError) shouldEventually] beNonNil];
      });

      describe(@"PromiseKit support", ^{
        it(@"returns a Promise", ^{
          CJEngine *engine = [CJEngine sharedEngine];
          id promise = [engine authenticateWithUsername:@"a_username"
                                            andPassword:@"a_password"];
          
          [[promise should] beKindOfClass:[Promise class]];
        });
      });

    });
  });
});

SPEC_END
