//
//  JSONResponseSerializerWithData.m
//  CJKit
//
//  Created by Bruno Abrantes on 21/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "JSONResponseSerializerWithData.h"

@implementation JSONResponseSerializerWithData

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
	id JSONObject = [super responseObjectForResponse:response data:data error:error];
	if (*error != nil) {
		NSMutableDictionary *userInfo = [(*error).userInfo mutableCopy];
		if (data == nil) {
			userInfo[JSONResponseSerializerWithDataKey] = [NSData data];
		} else {
			userInfo[JSONResponseSerializerWithDataKey] = data;
		}
		NSError *newError = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:userInfo];
		(*error) = newError;
	}
  
	return (JSONObject);
}

@end
