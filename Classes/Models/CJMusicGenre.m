//
//  CJMusicGenre.m
//  CJKit
//
//  Created by Bruno Abrantes on 24/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJMusicGenre.h"

@implementation CJMusicGenre

static NSString *kMusicGenreParentId = @"parentId";
static NSString *kMusicGenreName = @"name";
static NSString *kMusicGenreInferred = @"inferred";

#pragma mark - Initializers

+ (instancetype)musicGenreWithInfo:(NSDictionary *)info
{
  return [[CJMusicGenre alloc] initWithInfo:info];
}

- (instancetype)initWithInfo:(NSDictionary *)info
{
  self = [super initWithInfo:info];
  if (self && info) {
    // Core properties
    _parentId = info[kMusicGenreParentId];
    _name = info[kMusicGenreName];
    _inferred = [info[kMusicGenreInferred] boolValue];
  }
  return self;
}

@end
