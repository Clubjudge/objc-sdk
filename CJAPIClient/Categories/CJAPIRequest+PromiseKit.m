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
  return [Promise new:^(PromiseResolver fulfiller, PromiseResolver rejecter) {
    [self performWithSuccess:^(id response, CJPaginationInfo *pagination, CJLinksInfo *links) {
      NSDictionary *responseObject = @{@"response": response, @"pagination": pagination, @"links": links};
      fulfiller(responseObject);
    } failure:^(NSDictionary *error, NSNumber *statusCode) {
      rejecter(error);
    }];
  }];
}

@end
