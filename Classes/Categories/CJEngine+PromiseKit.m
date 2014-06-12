//
//  CJEngine+PromiseKit.m
//  CJKit
//
//  Created by Bruno Abrantes on 05/05/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJEngine+PromiseKit.h"

@implementation CJEngine (PromiseKit)

- (Promise *)authenticateWithFacebookToken:(NSString *)facebookToken
{
  return [Promise new:^(PromiseFulfiller fulfiller, PromiseRejecter rejecter) {
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
  return [Promise new:^(PromiseFulfiller fulfiller, PromiseRejecter rejecter) {
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

- (Promise *)registerWithUser:(CJUser *)user
{
  return [Promise new:^(PromiseFulfiller fulfiller, PromiseRejecter rejecter) {
    [self registerWithUser:user withSuccess:^{
      fulfiller(@YES);
    } andFailure:^(NSError *error) {
      rejecter(error);
    }];
  }];
}

@end
