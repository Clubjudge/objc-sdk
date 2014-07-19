//
//  CJUser.m
//  CJKit
//
//  Created by Bruno Abrantes on 24/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJUser.h"
#import "CJLinksInfo.h"
#import "CJEvent.h"
#import "NSDate+StringParsing.h"

@implementation CJUser

static NSString*kUserEmail = @"email";
static NSString*kUserAddress = @"address";
static NSString*kUserFirstName = @"firstName";
static NSString*kUserLastName = @"lastName";
static NSString*kUserFullName = @"fullName";
static NSString*kUserAvatarURL = @"avatarUrl";
static NSString*kUserCreatedAt = @"createdAt";
static NSString*kUserReviewsCount = @"reviewsCount";
static NSString*kUserExpertReviewsCount = @"expertReviewsCount";
static NSString*kUserFriendsCount = @"friendsCount";
static NSString*kUserMutualFriendsCount = @"mutualFriendsCount";
static NSString*kUserUpcomingEventsCount = @"upcomingEventsCount";
static NSString*kUserPastEventsCount = @"pastEventsCount";
static NSString*kUserScore = @"score";
static NSString*kUserGender = @"gender";
static NSString*kUserBirthdate = @"bornOn";
static NSString*kUserFriend = @"isFriend";
static NSString*kUserPendingFriend = @"isPendingFriend";
static NSString*kUserIsFacebook = @"isFacebook";

static NSString*kUserLinkEvents = @"events";

#pragma mark - Initializers

+ (instancetype)userWithInfo:(NSDictionary *)info
{
  return [[CJUser alloc] initWithInfo:info];
}

- (instancetype)initWithInfo:(NSDictionary *)info
{
  self = [super initWithInfo:info];
  if (self && info) {
    // Core properties
    _email = info[kUserEmail];
    _address = info[kUserAddress];
    _firstName = info[kUserFirstName];
    _lastName = info[kUserLastName];
    _fullName = info[kUserFullName];
    _avatarURL = info[kUserAvatarURL];
    _createdAt = [NSDate dateWithISO8601String:info[kUserCreatedAt]];
    _reviewCount = info[kUserReviewsCount];
    _expertReviewCount = info[kUserExpertReviewsCount];
    _friendsCount = info[kUserFriendsCount];
    _mutualFriendsCount = info[kUserMutualFriendsCount];
    _upcomingEventsCount = info[kUserUpcomingEventsCount];
    _pastEventsCount = info[kUserPastEventsCount];
    _score = info[kUserScore];
    _gender = info[kUserGender];
    _birthdate = [NSDate dateWithISO8601String:info[kUserBirthdate]];
    _friend = [info[kUserFriend] boolValue];
    _pendingFriend = [info[kUserPendingFriend] boolValue];
    _isFacebook = [info[kUserIsFacebook] boolValue];
    
    // Links
    self.links.mapping = @{
                           @"events": [CJEvent class]
                           };
  }
  return self;
}

@end
