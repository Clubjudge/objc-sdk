//
//  CJModel.h
//  CJKit
//
//  Created by Bruno Abrantes on 21/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CJLinksInfo;

@interface CJModel : NSObject

@property (nonatomic, strong) id Id;

#pragma mark - Links
@property (readonly) CJLinksInfo *links;

#pragma mark - Actions
- (id)initWithInfo:(NSDictionary *)info;

@end
