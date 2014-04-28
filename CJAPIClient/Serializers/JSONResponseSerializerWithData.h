//
//  JSONResponseSerializerWithData.h
//  CJAPIClient
//
//  Created by Bruno Abrantes on 21/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <AFNetworking/AFURLResponseSerialization.h>

// NSError userInfo key that will contain response data
static NSString * const JSONResponseSerializerWithDataKey = @"JSONResponseSerializerWithDataKey";

@interface JSONResponseSerializerWithData : AFJSONResponseSerializer

@end
