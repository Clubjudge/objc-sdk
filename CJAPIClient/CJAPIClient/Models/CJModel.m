//
//  CJModel.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 21/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJModel.h"

@implementation CJModel

- (id)initWithInfo:(NSDictionary *)info
{
  self = [super init];
  if (self && info) {
    _Id = [info objectForKey:kID];
  }
  return self;
}

@end
