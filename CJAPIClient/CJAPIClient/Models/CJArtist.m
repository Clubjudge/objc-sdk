//
//  CJArtist.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 23/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJArtist.h"
#import "CJEvent.h"
#import "CJUser.h"
#import "CJModel+Following.h"

@implementation CJArtist

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
    
    // Embeddables
    // TODO: proper mapping to models
    _events = [(NSArray *) info[kArtistEvents][@"source"] map:^id(NSDictionary *event) {
      return [[CJEvent alloc] initWithInfo:event];
    }];
    _musicGenres = [NSArray arrayWithArray:info[kArtistMusicGenres]];
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

@end
