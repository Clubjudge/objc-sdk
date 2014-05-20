//
//  CJComment.h
//  CJAPIClient
//
//  Created by Bruno Abrantes on 24/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJModel.h"
@class CJUser;

typedef enum {
  kCommentTypeComment,
  kCommentTypeActivity,
} CommentType;

@interface CJComment : CJModel

#pragma mark - Core properties
@property (nonatomic, strong) NSString* Id;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, assign) CommentType type;
@property (nonatomic, strong) CJUser *user;

@end