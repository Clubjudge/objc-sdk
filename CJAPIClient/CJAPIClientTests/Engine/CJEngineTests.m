//
//  CJEngineTests.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 14/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "CJEngine.h"

@interface CJEngine()

@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;

@end

SPEC_BEGIN(CJENGINESPEC)

describe(@"Engine", ^{
  context(@"When initialising", ^{
    it(@"returns a shared object", ^{
      CJEngine *engine = [CJEngine sharedEngine];
      CJEngine *engine2 = [CJEngine sharedEngine];
      
      [[engine should] beKindOfClass:[CJEngine class]];
      [[engine should] equal:engine2];
    });
    
    it(@"instantiates an AFHTTPOperationManager", ^{
      CJEngine *engine = [CJEngine sharedEngine];
      
      [[engine.operationManager should] beKindOfClass:[AFHTTPRequestOperationManager class]];
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
});

SPEC_END
