//
//  CJAPIRequestSerializer.h
//  CJKit
//
//  Created by Bruno Abrantes on 08/05/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "AFURLRequestSerialization.h"

@interface CJAPIRequestSerializer : AFJSONRequestSerializer

@property (nonatomic, assign) NSURLRequestCachePolicy cachePolicy;

- (instancetype)initWithCachePolicy:(NSURLRequestCachePolicy)cachePolicy;

@end
