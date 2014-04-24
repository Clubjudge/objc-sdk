//
//  CJCity.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 25/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJCity.h"

@implementation CJCity

- (instancetype)initWithInfo:(NSDictionary *)info
{
  self = [super initWithInfo:info];
  if (self && info) {
    // Core properties
    _name = info[kCityName];
    _aliases = info[kCityAliases];
    _region = info[kCityRegion];
    _country = info[kCityCountry];
    
    double lat = [info[kCityGeolocation][@"lat"] doubleValue];
    double lon = [info[kCityGeolocation][@"lon"] doubleValue];
    _geolocation = CLLocationCoordinate2DMake(lat, lon);
  }
  return self;
}

@end
