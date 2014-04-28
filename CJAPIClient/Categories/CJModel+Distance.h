//
//  CJModel+Distance.h
//  CJAPIClient
//
//  Created by Bruno Abrantes on 28/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJModel.h"
#import <CoreLocation/CoreLocation.h>

@interface CJModel (Distance)

- (NSUInteger)distanceToLocation:(CLLocation *)start
                    fromLocation:(CLLocation *)destination;

@end
