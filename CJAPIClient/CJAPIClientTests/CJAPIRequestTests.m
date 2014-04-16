//
//  CJAPIRequestTests.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 16/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CJAPIRequest.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "CJEngine.h"

@interface CJAPIRequest()

@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;

@end

SPEC_BEGIN(CJAPIREQUESTSPEC)

describe(@"CJAPIRequest", ^{
  context(@"When initialising", ^{
    describe(@".method", ^{
      it(@"sets the method property", ^{
        CJAPIRequest *request = [[CJAPIRequest alloc] initWithMethod:@"GET"
                                                             andPath:@"a/path"];
        
        [[request.method should] equal:@"GET"];
      });
      
      it(@"works with lowercase methods", ^{
        CJAPIRequest *request = [[CJAPIRequest alloc] initWithMethod:@"get"
                                                             andPath:@"a/path"];
        
        [[request.method should] equal:@"GET"];
      });
    });
    
    describe(@".path", ^{
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
    });
    
    describe(@".operationManager", ^{
      it(@"sets the operationManager property to the shared engine's operationManager", ^{
        CJEngine *engine = [CJEngine sharedEngine];
        CJAPIRequest *request = [[CJAPIRequest alloc] initWithMethod:@"GET"
                                                             andPath:@"a/path/"];
        
        [[request.operationManager should] equal:engine.operationManager];
      });
    });
  });
});

SPEC_END