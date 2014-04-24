//
//  CJUser.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 24/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJUser.h"
#import "NSDate+StringParsing.h"

@implementation CJUser

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
  }
  return self;
}

@end
