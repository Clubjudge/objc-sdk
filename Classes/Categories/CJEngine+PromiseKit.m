//
//  CJEngine+PromiseKit.m
//  CJKit
//
//  Created by Bruno Abrantes on 05/05/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJEngine+PromiseKit.h"

@implementation CJEngine (PromiseKit)

- (PMKPromise *)authenticateWithFacebookToken:(NSString *)facebookToken
{
  return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
    [self authenticateWithFacebookToken:facebookToken withSuccess:^(NSString *token) {
      fulfiller(token);
    } andFailure:^(NSError *error) {
      rejecter(error);
    }];
  }];
}

- (PMKPromise *)authenticateWithUsername:(NSString *)username
                          andPassword:(NSString *)password
{
  return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
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

- (PMKPromise *)registerWithUser:(CJUser *)user
{
  return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
    [self registerWithUser:user withSuccess:^{
      fulfiller(@YES);
    } andFailure:^(NSError *error) {
      rejecter(error);
    }];
  }];
}

@end
