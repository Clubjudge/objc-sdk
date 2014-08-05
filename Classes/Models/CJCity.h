//
//  CJCity.h
//  CJKit
//
//  Created by Bruno Abrantes on 25/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJAPIRequest.h"
#import "CJModel.h"
#import <CoreLocation/CoreLocation.h>

@interface CJCity : CJModel

@property (readonly) NSString *name;
@property (readonly) NSArray *aliases;
@property (readonly) NSDictionary *region;
@property (readonly) NSDictionary *country;
@property (readonly) CLLocationCoordinate2D geolocation;

#pragma mark - Initializers

+ (instancetype)cityWithInfo:(NSDictionary *)info;

#pragma mark - Actions

+ (CJAPIRequest *)requestForSearchWithTerm:(NSString *)term;

@end
