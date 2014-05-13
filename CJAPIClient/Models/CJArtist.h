//
//  CJArtist.h
//  CJAPIClient
//
//  Created by Bruno Abrantes on 23/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJModel.h"

@interface CJArtist : CJModel

#pragma mark - Core properties

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *description;
@property(nonatomic, assign) BOOL following;
@property(nonatomic, strong) NSNumber *followersCount;
@property(nonatomic, strong) NSNumber *commentsCount;
@property(nonatomic, strong) NSNumber *friendsFollowingCount;
@property(nonatomic, strong) NSNumber *upcomingEventsCount;
@property(nonatomic, strong) NSNumber *socialMentionsCount;
@property(nonatomic, strong) NSArray *socialLinks;
@property(nonatomic, strong) NSArray *avatars;
@property(nonatomic, strong) NSDictionary *address;
@property(nonatomic, strong) NSDictionary *background;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *websiteURL;

#pragma mark - Embeddables

@property(nonatomic, strong) NSArray *events;
@property(nonatomic, strong) NSArray *musicGenres;
@property(nonatomic, strong) NSArray *followers;

#pragma mark - Actions

- (void)follow;
- (void)unfollow;

- (NSString *)imagePathForAvatarWithSize:(NSInteger)size;
- (NSString *)imagePathForBackgroundWithSize:(NSInteger)size;

@end

#pragma mark - Mapping

#define kArtistName @"name"
#define kArtistDescription @"description"
#define kArtistFollowing @"follow"
#define kArtistFollowersCount @"followersCount"
#define kArtistCommentsCount @"commentsCount"
#define kArtistFriendsFollowingCount @"friendsFollowingCount"
#define kArtistUpcomingEventsCount @"upcomingEventsCount"
#define kArtistSocialMentionsCount @"socialMentionsCount"
#define kArtistSocialLinks @"socialLinks"
#define kArtistAvatars @"avatars"
#define kArtistAddress @"address"
#define kArtistBackground @"background"
#define kArtistEmail @"email"
#define kArtistWebsiteURL @"websiteUrl"

#define kArtistEvents @"events"
#define kArtistMusicGenres @"musicGenres"
#define kArtistFollowers @"followers"

#define kArtistLinkEvents @"events"
#define kArtistLinkComments @"comments"
#define kArtistLinkFollowers @"followers"
#define kArtistLinkGenres @"musicGenres"
