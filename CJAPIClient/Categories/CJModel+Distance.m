//
//  CJModel+Distance.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 28/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJModel+Distance.h"

@implementation CJModel (Distance)

- (NSUInteger)distanceToLocation:(CLLocation *)start
                    fromLocation:(CLLocation *)destination;
{
  CLLocationDistance distance = [start distanceFromLocation:destination];
  
  return (NSUInteger)distance;
}

@end
