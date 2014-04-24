//
//  CJLinksInfo.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 22/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJLinksInfo.h"
#import "CJEngineConfiguration.h"
#import "CJAPIRequest.h"

@interface CJLinksInfo()

@property (nonatomic, strong) NSDictionary *links;

@end

@implementation CJLinksInfo

#pragma mark - Initialisation

- (instancetype) initWithInfo:(NSDictionary *)info
{
  self = [super init];
  
  if (self && info) {
    _links = [NSDictionary dictionaryWithDictionary:info];
    
    return self;
  }
  
  return nil;
}

#pragma mark - Request

- (CJAPIRequest *)requestForLink:(NSString *)link
{
  unless(_links) {
    return nil;
  }
  
  unless(_links[link] && ![_links[link] isKindOfClass:[NSNull class]]) {
    return nil;
  }
  
  NSURL *url = [NSURL URLWithString:_links[link]];
  
  CJAPIRequest *request = [[CJAPIRequest alloc] initWithMethod:@"GET"
                                                       andPath:[self pathComponentForURL:url]];
  
  request.parameters = [self dictionaryFromQuerystring:[url query]];
  
  if (_mapping[link]) {
    request.modelClass = _mapping[link];
  }
  
  return request;
}

#pragma mark - Helpers

- (NSString *)pathComponentForURL:(NSURL *)url
{
  NSString *version = [CJEngineConfiguration sharedConfiguration].APIVersion;
  
  NSArray *components = [[url pathComponents] reject:^BOOL(NSString *component) {
    return ([component isEqualToString:version] || [component isEqualToString:@"/"]);
  }];
  
  NSString *path = [components join:@"/"];

  return path;
}

- (NSDictionary *)dictionaryFromQuerystring:(NSString *)querystring
{
  NSArray *pairs = [querystring componentsSeparatedByString:@"&"];
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:pairs.count];
  
  [pairs each:^(NSString *pair) {
    NSArray *elements = [pair componentsSeparatedByString:@"="];
    NSString *key = [elements[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    id val = [elements[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // Try typecasting to NSNumber
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *number = [formatter numberFromString:val];
    
    if (number) {
      val = number;
    }
    
    [dict setObject:val
             forKey:key];
  }];
  
  return dict;
}

@end
