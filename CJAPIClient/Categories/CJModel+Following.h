//
//  CJModel+Following.h
//  CJAPIClient
//
//  Created by Bruno Abrantes on 23/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJModel.h"

@interface CJModel (Following)

- (void)followEntity:(NSString *)entity;
- (void)unfollowEntity:(NSString *)entity;

@end
