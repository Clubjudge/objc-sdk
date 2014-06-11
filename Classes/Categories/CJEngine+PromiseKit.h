//
//  CJEngine+PromiseKit.h
//  CJKit
//
//  Created by Bruno Abrantes on 05/05/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJEngine.h"
#import <PromiseKit/Promise.h>
@class CJUser;

@interface CJEngine (PromiseKit)

/**
 * Returns a Promise for a request for a user access token given a Facebook OAuth token
 */
- (Promise *)authenticateWithFacebookToken:(NSString *)facebookToken;

/**
 * Returns a Promise for a request for a user access token given a username/password combo
 */
- (Promise *)authenticateWithUsername:(NSString *)username
                          andPassword:(NSString *)password;

/**
 * Returns a Promise for a request to register a user
 */
- (Promise *)registerWithUser:(CJUser *)user;

@end
