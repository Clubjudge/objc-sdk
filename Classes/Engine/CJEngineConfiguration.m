//
//  CJEngineConfiguration.m
//  CJKit
//
//  Created by Bruno Abrantes on 14/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJEngineConfiguration.h"

@interface CJEngineConfiguration()

@end

@implementation CJEngineConfiguration

static NSString *kAPIVersion = @"v1";
static NSString *CJConfigurationAPIBaseUrl = @"kAPIBaseURL";
static NSString *CJConfigurationAuthAPIBaseUrl = @"kAuthAPIBaseURL";

#pragma mark - Initialisers

+ (CJEngineConfiguration *)sharedConfiguration
{
  static CJEngineConfiguration *_sharedConfiguration = nil;
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    _sharedConfiguration = [[self alloc] init];
  });
  
  return _sharedConfiguration;
}

#pragma mark - Environment

static NSString* theEnvironment = @"development";
+ (NSString *)environment
{
  return theEnvironment;
}

+ (void)setEnvironment:(NSString *)environment
{
  NSArray *environments = @[@"development", @"staging", @"production"];
  NSAssert([environments containsObject:environment], @"%@ is not a supported environment", environment);
  
  theEnvironment = environment;
}


#pragma mark - Configuration keys

static NSDictionary* configurations = nil;
- (NSDictionary *)configurationForEnvironment:(NSString *)environment
{
  NSAssert(environment, @"An environment is needed!");
  
  if (configurations == nil) {
    configurations = [NSDictionary dictionaryWithObjects:@[
                                                           @{
                                                             @"kAPIBaseURL": @"http://local.clubjudge.com:5000",
                                                             @"kAuthAPIBaseURL": @"http://auth.local.clubjudge.com:3000"
                                                             },
                                                           @{
                                                             @"kAPIBaseURL": @"http://bifrost.staging.clubjudge.com",
                                                             @"kAuthAPIBaseURL": @"http://auth.staging.clubjudge.com"
                                                             },
                                                           @{
                                                             @"kAPIBaseURL": @"https://bifrost.clubjudge.com",
                                                             @"kAuthAPIBaseURL": @"https://auth.clubjudge.com"
                                                             },
                                                           ]
                                                 forKeys:@[@"development", @"staging", @"production"]];
  }
  
  NSDictionary *configuration = [configurations objectForKey:environment];
  
  NSAssert(configuration, @"Configuration for %@ not found!", configuration);
  
  return configuration;
}

#pragma mark - Keys

- (NSString *)APIVersion
{
  return kAPIVersion;
}

- (NSString *)APIBaseURL {
  CJEngineConfiguration *sharedConfiguration = [CJEngineConfiguration sharedConfiguration];
  NSDictionary *configuration = [sharedConfiguration configurationForEnvironment:[CJEngineConfiguration environment]];
  NSString *baseUrl = [configuration objectForKey:CJConfigurationAPIBaseUrl];
  
  return [NSString stringWithFormat:@"%@/%@", baseUrl, [self APIVersion]];
}

- (NSString *)authAPIBaseURL {
  CJEngineConfiguration *sharedConfiguration = [CJEngineConfiguration sharedConfiguration];
  NSDictionary *configuration = [sharedConfiguration configurationForEnvironment:[CJEngineConfiguration environment]];
  NSString *baseUrl = [configuration objectForKey:CJConfigurationAuthAPIBaseUrl];
  
  return [NSString stringWithFormat:@"%@", baseUrl];
}

@end
