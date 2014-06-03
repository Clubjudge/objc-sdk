//
//  CJModel+Following.m
//  CJKit
//
//  Created by Bruno Abrantes on 23/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJModel+Following.h"
#import "CJAPIRequest.h"

typedef enum {
  kFollow,
  kUnfollow,
} FollowType;

@interface CJModel()

@property (nonatomic, assign) BOOL following;

@end

@implementation CJModel (Following)

- (void)followEntity:(NSString *)entity
{
  [self followRequestForEntity:entity
                      withType:kFollow];
}

- (void)unfollowEntity:(NSString *)entity
{
  [self followRequestForEntity:entity
                      withType:kUnfollow];
}

- (void)followRequestForEntity:(NSString *)entity
                      withType:(FollowType)type;
{
  entity = [entity stringByAppendingString:@"s"];
  NSString *path = [NSString stringWithFormat:@"/%@/%@/followers.json", entity, self.Id];
  CJAPIRequest *request = [[CJAPIRequest alloc] initWithMethod:[self methodForType:type]
                                                       andPath:path];
  
  self.following = (type == kFollow) ? YES : NO;
  
  
  [request performWithSuccess:nil
                      failure:^(NSDictionary *error, NSNumber *statusCode) {
                        self.following = (type == kFollow) ? NO : YES;
                      }];
}

- (NSString *)methodForType:(FollowType)type
{
  switch (type) {
    case kFollow:
      return @"POST";
      break;
    
    case kUnfollow:
      return @"DELETE";
      break;
      
    default:
      return @"POST";
      break;
  }
}

@end
