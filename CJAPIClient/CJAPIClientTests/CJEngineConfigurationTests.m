//
//  CJEngineConfigurationTests.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 14/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CJEngineConfiguration.h"

SPEC_BEGIN(CJCONFIGURATIONSPEC)

describe(@"CJEngineConfiguration", ^{
  describe(@".setEnvironment", ^{
    it(@"sets the static environment property", ^{
      [CJEngineConfiguration setEnvironment:@"staging"];
      
      [[[CJEngineConfiguration environment] should] equal:@"staging"];
    });
  });
  
  describe(@"#configurationForEnvironment", ^{
    it(@"returns the development configuration", ^{
      NSDictionary *targetConfig = @{
                               @"kAPIBaseURL": @"http://local.clubjudge.com:5000",
                               @"kAuthAPIBaseURL": @"http://local.clubjudge.com:3000/baws/auth"
                               };
      
      NSDictionary *config = [[CJEngineConfiguration sharedConfiguration] configurationForEnvironment:@"development"];
      
      [[config should] equal:targetConfig];
    });
  });
  
  describe(@"#APIversion", ^{
    it(@"returns the appropriate version string", ^{
      [[[[CJEngineConfiguration sharedConfiguration] APIVersion] should] equal:@"v1"];
    });
  });
  
  describe(@"#APIBaseUrl", ^{
    beforeEach(^{
      [CJEngineConfiguration setEnvironment:@"development"];
    });
    
    it(@"returns a versioned URL", ^{
      [[[[CJEngineConfiguration sharedConfiguration] APIBaseURL] should] equal:@"http://local.clubjudge.com:5000/v1"];
    });
  });
  
  describe(@"#AuthAPIBaseURL", ^{
    beforeEach(^{
      [CJEngineConfiguration setEnvironment:@"development"];
    });
    
    it(@"returns the auth url", ^{
      [[[[CJEngineConfiguration sharedConfiguration] authAPIBaseURL] should] equal:@"http://local.clubjudge.com:3000/baws/auth"];
    });
  });
});

SPEC_END
