//
//  CJArtist.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 23/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJArtist.h"
#import "CJEvent.h"
#import "CJAPIRequest.h"

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
    _events = [(NSArray *) info[kArtistEvents] map:^id(NSDictionary *event) {
      return [[CJEvent alloc] initWithInfo:event];
    }];
    _musicGenres = [NSArray arrayWithArray:info[kArtistMusicGenres]];
    _followers = [NSArray arrayWithArray:info[kArtistFollowers]];
  }
  return self;
}

- (void)follow
{
  NSString *path = [NSString stringWithFormat:@"/artists/%@/followers.json", self.Id];
  CJAPIRequest *request = [[CJAPIRequest alloc] initWithMethod:@"POST"
                                                       andPath:path];
  
  _following = YES;
  
  
  [request performWithSuccess:nil
                      failure:^(NSDictionary *error, NSNumber *statusCode) {
                        self.following = NO;
                      }];
}

- (void)unfollow
{
  NSString *path = [NSString stringWithFormat:@"/artists/%@/followers.json", self.Id];
  CJAPIRequest *request = [[CJAPIRequest alloc] initWithMethod:@"DELETE"
                                                       andPath:path];
  
  _following = NO;
  
  [request performWithSuccess:nil
                      failure:^(NSDictionary *error, NSNumber *statusCode) {
                        self.following = YES;
                      }];
}

@end
