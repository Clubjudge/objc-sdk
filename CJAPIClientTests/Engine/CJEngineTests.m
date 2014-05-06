//
//  CJEngineTests.m
//  CJAPIClient
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
    
    it(@"instantiates a session manager", ^{
      CJEngine *engine = [CJEngine sharedEngine];
      
      [[engine.sessionManager should] beNonNil];
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
  
  describe(@"#authenticateWithFacebookToken:withSuccess:andFailure", ^{
    it(@"POSTs a request to the authentication API", ^{
      CJEngine *engine = [CJEngine sharedEngine];
      
      KWCaptureSpy *pathSpy = [engine.authSessionManager captureArgument:@selector(POST:parameters:success:failure:) atIndex:0];
      KWCaptureSpy *tokenSpy = [engine.authSessionManager captureArgument:@selector(POST:parameters:success:failure:) atIndex:1];
      
      [engine authenticateWithFacebookToken:@"12345667abcd"];
      
      [[expectFutureValue(pathSpy.argument) shouldEventually] equal:@"facebook_token"];
      [[expectFutureValue(tokenSpy.argument) shouldEventually] equal:@{@"token": @"12345667abcd"}];
    });
    
    context(@"when POST succeeds", ^{
      __block NSDictionary *stubbedResponse;
      __block id<OHHTTPStubsDescriptor> stub = nil;
      
      beforeEach(^{
        stubbedResponse = @{
                            @"access_token": @"a_token"
                            };
        
        stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *req) {
          return ([req.URL.path isEqualToString:@"/baws/auth/facebook_token"]);
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
      
      it(@"sets the Engine's .userToken to the \"access_token\" key in the response", ^{
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
          return ([req.URL.path isEqualToString:@"/baws/auth/facebook_token"]);
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
        [engine authenticateWithFacebookToken:@"123456"];
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
});

SPEC_END
