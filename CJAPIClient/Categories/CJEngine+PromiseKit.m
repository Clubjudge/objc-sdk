//
//  CJEngine+PromiseKit.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 05/05/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJEngine+PromiseKit.h"

@implementation CJEngine (PromiseKit)

- (Promise *)authenticateWithFacebookToken:(NSString *)facebookToken
{
  return [Promise new:^(PromiseResolver fulfiller, PromiseResolver rejecter) {
    [self authenticateWithFacebookToken:facebookToken withSuccess:^(NSString *token) {
      fulfiller(token);
    } andFailure:^(NSError *error) {
      rejecter(error);
    }];
  }];
}

- (Promise *)authenticateWithUsername:(NSString *)username
                          andPassword:(NSString *)password
{
  return [Promise new:^(PromiseResolver fulfiller, PromiseResolver rejecter) {
    [self authenticateWithUsername:username
                       andPassword:password
                       withSuccess:^(NSString *token) {
                         fulfiller(token);
                       }
                        andFailure:^(NSError *error) {
                          rejecter(error);
                        }];
  }];
}

@end
