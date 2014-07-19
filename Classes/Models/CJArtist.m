//
//  CJArtist.m
//  CJKit
//
//  Created by Bruno Abrantes on 23/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJArtist.h"
#import "CJEvent.h"
#import "CJUser.h"
#import "CJMusicGenre.h"
#import "CJLinksInfo.h"
#import "CJComment.h"
#import "CJUser.h"
#import "CJModel+Following.h"
#import "CJModel+Images.h"
#import <ObjectiveSugar/ObjectiveSugar.h>

@implementation CJArtist

static NSString *kArtistName = @"name";
static NSString *kArtistDescription = @"description";
static NSString *kArtistFollowing = @"follow";
static NSString *kArtistFollowersCount = @"followersCount";
static NSString *kArtistCommentsCount = @"commentsCount";
static NSString *kArtistFriendsFollowingCount = @"friendsFollowingCount";
static NSString *kArtistUpcomingEventsCount = @"upcomingEventsCount";
static NSString *kArtistSocialMentionsCount = @"socialMentionsCount";
static NSString *kArtistSocialLinks = @"socialLinks";
static NSString *kArtistAvatars = @"avatars";
static NSString *kArtistAddress = @"address";
static NSString *kArtistBackground = @"background";
static NSString *kArtistEmail = @"email";
static NSString *kArtistWebsiteURL = @"websiteUrl";

static NSString *kArtistEvents = @"events";
static NSString *kArtistMusicGenres = @"musicGenres";
static NSString *kArtistFollowers = @"followers";

static NSString *kArtistLinkEvents = @"events";
static NSString *kArtistLinkComments = @"comments";
static NSString *kArtistLinkFollowers = @"followers";
static NSString *kArtistLinkGenres = @"musicGenres";

+ (instancetype)artistWithInfo:(NSDictionary *)info
{
  return [[CJArtist alloc] initWithInfo:info];
}

- (instancetype)initWithInfo:(NSDictionary *)info
{
  self = [super initWithInfo:info];
  if (self && info) {
    // Core properties
    _name = info[kArtistName];
    _description = info[kArtistDescription];
    _following = [info[kArtistFollowing] boolValue];
    _followersCount = info[kArtistFollowersCount];
    _commentsCount = info[kArtistCommentsCount];
    _friendsFollowingCount = info[kArtistFriendsFollowingCount];
    _upcomingEventsCount = info[kArtistUpcomingEventsCount];
    _socialMentionsCount = info[kArtistSocialMentionsCount];
    _socialLinks = info[kArtistSocialLinks];
    _avatars = info[kArtistAvatars];
    _address = info[kArtistAddress];
    _background = info[kArtistBackground];
    _email = info[kArtistEmail];
    _websiteURL = info[kArtistWebsiteURL];
    
    // Links
    self.links.mapping = @{
                           @"events": [CJEvent class],
                           @"comments": [CJComment class],
                           @"followers": [CJUser class],
                           @"musicGenres": [CJMusicGenre class],
                           };
    
    // Embeddables
    _events = [(NSArray *) info[kArtistEvents][@"source"] map:^id(NSDictionary *event) {
      return [[CJEvent alloc] initWithInfo:event];
    }];
    _musicGenres = [(NSArray *) info[kArtistMusicGenres][@"source"] map:^id(NSDictionary *genre) {
      return [[CJMusicGenre alloc] initWithInfo:genre];
    }];
    _followers = [(NSArray *) info[kArtistFollowers][@"source"] map:^id(NSDictionary *user) {
      return [[CJUser alloc] initWithInfo:user];
    }];
  }
  return self;
}

- (void)follow
{
  [self followEntity:@"artist"];
}

- (void)unfollow
{
  [self unfollowEntity:@"artist"];
}

- (NSString *)imagePathForAvatarWithSize:(NSString *)size
{
  return [self imagePathForImageInfo:[_avatars firstObject] andSize:size];
}

- (NSString *)imagePathForBackgroundWithSize:(NSString *)size
{
  return [self imagePathForImageInfo:_background andSize:size];
}

@end
