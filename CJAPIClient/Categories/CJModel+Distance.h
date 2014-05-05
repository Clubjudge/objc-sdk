//
//  CJModel+Distance.h
//  CJAPIClient
//
//  Created by Bruno Abrantes on 28/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

/**
 CJModel+Distance is a category on CJModel that adds physical distance calculations to the target model.
 */

#import "CJModel.h"
#import <CoreLocation/CoreLocation.h>

@interface CJModel (Distance)

/**
 Returns the distance between two points
 */
- (NSUInteger)distanceToLocation:(CLLocation *)start
                    fromLocation:(CLLocation *)destination;

@end
