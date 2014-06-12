//
//  CJUser.h
//  CJKit
//
//  Created by Bruno Abrantes on 24/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJModel.h"

@interface CJUser : CJModel

#pragma mark - Core properties

@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) NSDictionary *address;
@property(nonatomic, strong) NSString *firstName;
@property(nonatomic, strong) NSString *lastName;
@property(nonatomic, strong) NSString *fullName;
@property(nonatomic, strong) NSString *avatarURL;
@property(nonatomic, strong) NSDate *createdAt;
@property(nonatomic, strong) NSNumber *reviewCount;
@property(nonatomic, strong) NSNumber *expertReviewCount;
@property(nonatomic, strong) NSNumber *friendsCount;
@property(nonatomic, strong) NSNumber *mutualFriendsCount;
@property(nonatomic, strong) NSNumber *upcomingEventsCount;
@property(nonatomic, strong) NSNumber *pastEventsCount;
@property(nonatomic, strong) NSDictionary *score;
@property(nonatomic, strong) NSString *gender;
@property(nonatomic, strong) NSDate *birthdate;
@property (nonatomic, assign) BOOL friend;
@property (nonatomic, assign) BOOL pendingFriend;
@property (nonatomic, assign) BOOL isFacebook;

@end
