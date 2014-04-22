//
//  CJEvent.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 22/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJEvent.h"
#import "NSDate+StringParsing.h"

@implementation CJEvent

- (instancetype)initWithInfo:(NSDictionary *)info
{
  self = [super initWithInfo:info];
  if (self && info) {
    // Core properties
    _name = [NSString stringWithString:info[kEventName]];
    _flyers = [NSArray arrayWithArray:info[kEventFlyers]];
    _description = [NSString stringWithString:info[kEventDescription]];
    _startsAt = [NSDate dateWithISO8601String:info[kEventStartsAt]];
    _endsAt = [NSDate dateWithISO8601String:info[kEventEndsAt]];
    _reviewEndsAt = [NSDate dateWithISO8601String:info[kEventReviewEndsAt]];
    _updatedAt = [NSDate dateWithISO8601String:info[kEventUpdatedAt]];
    _featured = [info[kEventFeatured] boolValue];
    _following = [info[kEventFollowing] boolValue];
    _lineupToBeAnnounced = [info[kEventLineupTBA] boolValue];
    _reviewable = [info[kEventReviewable] boolValue];
    _published = [info[kEventPublished] boolValue];
    _followersCount = info[kEventFollowersCount];
    _commentsCount = info[kEventCommentsCount];
    _friendsFollowingCount = info[kEventFriendsFollowingCount];
    _reviewCount = info[kEventReviewCount];
    _userData = info[kEventUserData];
    _contest = info[kEventContest];
    _expertReviewRatings = info[kEventExpertReviewRatings];
    _globalRating = info[kEventGlobalRating];
    
    // Embeddables
    // TODO: proper mapping to models
    _artists = [NSArray arrayWithArray:info[kEventArtists]];
    _venue = [NSDictionary dictionaryWithDictionary:info[kEventVenue]];
    _musicGenres = [NSArray arrayWithArray:info[kEventMusicGenres]];
    _followers = [NSArray arrayWithArray:info[kEventFollowers]];
  }
  return self;
}

- (void)follow
{
  NSLog(@"Follow not yet implemented");
}

- (void)unfollow
{
  NSLog(@"Unfollow not yet implemented");
}

@end
