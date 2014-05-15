//
//  CJAPIRequest+PromiseKit.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 05/05/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJAPIRequest+PromiseKit.h"

@implementation CJAPIRequest (PromiseKit)

- (Promise *)perform
{
  __block PromiseResolver freshFulfiller;
  __block PromiseResolver freshRejecter;
  Promise *freshDataPromise = [Promise new:^(PromiseResolver fulfiller, PromiseResolver rejecter) {
    freshFulfiller = fulfiller;
    freshRejecter = rejecter;
  }];
  
  return [Promise new:^(PromiseResolver fulfiller, PromiseResolver rejecter) {
    [self performWithSuccess:^(id response, CJPaginationInfo *pagination, CJLinksInfo *links) {
      NSMutableDictionary *responseObject = [NSMutableDictionary dictionaryWithDictionary:@{@"response": response}];
      
      if (pagination) {
        responseObject[@"pagination"] = pagination;
      }
      
      if (links) {
        responseObject[@"links"] = links;
      }
      
      if ([CJEngine sharedEngine].cachePolicy == CJAPIRequestReturnCacheDataThenLoad) {
        if ([self.retries integerValue] < kRequestMaxRetries) {
          // Serving cached data, attach another Promise
          fulfiller(PMKManifold(responseObject, freshDataPromise));
        } else {
          // Serving fresh data
          freshFulfiller(responseObject);
        }
      } else {
        fulfiller(responseObject);
      }
    } failure:^(NSDictionary *error, NSNumber *statusCode) {
      if ([CJEngine sharedEngine].cachePolicy == CJAPIRequestReturnCacheDataThenLoad) {
        if ([self.retries integerValue] < kRequestMaxRetries) {
          // Serving cached data, attach another Promise
          rejecter(PMKManifold(error, freshDataPromise));
        } else {
          // Serving fresh data
          freshRejecter(error);
        }
      } else {
        rejecter(error);
      }
    }];
  }];
}

@end
