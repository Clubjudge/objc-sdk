//
//  CJModel.h
//  CJAPIClient
//
//  Created by Bruno Abrantes on 21/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJModel : NSObject

@property (readonly) NSNumber* Id;

- (id)initWithInfo:(NSDictionary *)info;

@end

#define kID @"id"
