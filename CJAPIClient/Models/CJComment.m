//
//  CJComment.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 24/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJComment.h"
#import "CJUser.h"
#import "NSDate+StringParsing.h"

@implementation CJComment

static NSString *kCommentMessage = @"message";
static NSString *kCommentCreatedAt = @"timestamp";
static NSString *kCommentType = @"type";
static NSString *kCommentUser = @"user";

- (instancetype)initWithInfo:(NSDictionary *)info
{
  self = [super initWithInfo:info];
  if (self && info) {
    // Core properties
    _message = info[kCommentMessage];
    _createdAt = [NSDate dateWithISO8601String:info[kCommentCreatedAt]];
    _type = [self commentTypeForString:info[kCommentType]];
    _user = [[CJUser alloc] initWithInfo:info[kCommentUser]];
  }
  return self;
}

#pragma mark - Helpers
- (CommentType)commentTypeForString:(NSString *)string
{
  CommentType type = kCommentTypeComment;
  
  if ([string isEqualToString:@"activity"]) {
    type = kCommentTypeActivity;
  }
  
  return type;
}

@end
