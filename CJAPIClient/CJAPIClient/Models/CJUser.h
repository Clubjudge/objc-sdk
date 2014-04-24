//
//  CJUser.h
//  CJAPIClient
//
//  Created by Bruno Abrantes on 24/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJModel.h"

@interface CJUser : CJModel

#pragma mark - Core properties

@property(nonatomic, strong) NSString *email;
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

@end

#pragma mark - Mapping

#define kUserEmail @"email"
#define kUserAddress @"address"
#define kUserFirstName @"firstName"
#define kUserLastName @"lastName"
#define kUserFullName @"fullName"
#define kUserAvatarURL @"avatarUrl"
#define kUserCreatedAt @"createdAt"
#define kUserReviewsCount @"reviewsCount"
#define kUserExpertReviewsCount @"expertReviewsCount"
#define kUserFriendsCount @"friendsCount"
#define kUserMutualFriendsCount @"mutualFriendsCount"
#define kUserUpcomingEventsCount @"upcomingEventsCount"
#define kUserPastEventsCount @"pastEventsCount"
#define kUserScore @"score"
#define kUserGender @"gender"
#define kUserBirthdate @"bornOn"
#define kUserFriend @"isFriend"
#define kUserPendingFriend @"isPendingFriend"

#define kUserLinkEvents @"events"
