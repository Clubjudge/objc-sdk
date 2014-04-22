//
//  CJLinksInfo.h
//  CJAPIClient
//
//  Created by Bruno Abrantes on 22/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CJAPIRequest;

@interface CJLinksInfo : NSObject

@property (readonly) NSDictionary *links;

#pragma mark - Initialisation
- (instancetype)initWithInfo:(NSDictionary *)info;

#pragma mark - Request
- (CJAPIRequest *)requestForLink:(NSString *)link;

@end

#define kLinksFirst     @"first"
#define kLinksPrevious  @"previous"
#define kLinksSelf      @"self"
#define kLinksNext      @"next"
#define kLinksLast      @"last"