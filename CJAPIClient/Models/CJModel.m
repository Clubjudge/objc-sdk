//
//  CJModel.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 21/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJModel.h"
#import "CJLinksInfo.h"

@implementation CJModel

static NSString *kID = @"id";
static NSString *kLinks = @"_links";

- (id)initWithInfo:(NSDictionary *)info
{
  self = [super init];
  if (self && info) {
    _Id = info[kID];
    
    // Links
    _links = [[CJLinksInfo alloc] initWithInfo:info[kLinks]];
  }
  return self;
}

@end
