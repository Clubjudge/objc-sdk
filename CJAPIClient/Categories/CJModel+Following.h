//
//  CJModel+Following.h
//  CJAPIClient
//
//  Created by Bruno Abrantes on 23/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

/**
 CJModel+Following is a category on CJModel that adds follow/unfollow capabilities to the target model.
 */

#import "CJModel.h"

@interface CJModel (Following)

/**
 Follows a given entity, ie. "artist"
 */
- (void)followEntity:(NSString *)entity;

/**
 Unfollows a given entity, ie. "artist"
 */
- (void)unfollowEntity:(NSString *)entity;

@end
