//
//  CJEvent.m
//  CJKit
//
//  Created by Bruno Abrantes on 22/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJEvent.h"
#import "NSDate+StringParsing.h"
#import "CJModel+Following.h"
#import "CJArtist.h"
#import "CJVenue.h"
#import "CJUser.h"
#import "CJMusicGenre.h"
#import "CJLinksInfo.h"
#import "CJComment.h"
#import "CJTicket.h"
#import <ObjectiveSugar/ObjectiveSugar.h>
#import "CJModel+Images.h"

@implementation CJEvent

static NSString *kEventName = @"name";
static NSString *kEventFlyers = @"flyers";
static NSString *kEventBackground = @"background";
static NSString *kEventDescription = @"description";
static NSString *kEventStartsAt = @"startsAt";
static NSString *kEventEndsAt = @"endsAt";
static NSString *kEventReviewEndsAt = @"reviewEndsAt";
static NSString *kEventUpdatedAt = @"updatedAt";
static NSString *kEventFeatured = @"featured";
static NSString *kEventFollowing = @"follow";
static NSString *kEventLineupTBA = @"lineupToBeAnnounced";
static NSString *kEventReviewable = @"reviewable";
static NSString *kEventPublished = @"published";
static NSString *kEventFollowersCount = @"followersCount";
static NSString *kEventCommentsCount = @"commentsCount";
static NSString *kEventFriendsFollowingCount = @"friendsFollowingCount";
static NSString *kEventReviewCount = @"reviewCount";
static NSString *kEventUserData = @"userData";
static NSString *kEventContest = @"contest";
static NSString *kEventExpertReviewRatings = @"expertReviewRatings";
static NSString *kEventGlobalRating = @"globalRating";

static NSString *kEventArtists = @"artists";
static NSString *kEventVenue = @"venue";
static NSString *kEventMusicGenres = @"musicGenres";
static NSString *kEventFollowers = @"followers";

static NSString *kEventLinkArtists = @"artists";
static NSString *kEventLinkComments = @"comments";
static NSString *kEventLinkInvitations = @"invitations";
static NSString *kEventLinkFollowers = @"followers";
static NSString *kEventLinkGenres = @"musicGenres";
static NSString *kEventLinkTickets = @"tickets";
static NSString *kEventLinkVenue = @"venue";

+ (instancetype)eventWithInfo:(NSDictionary *)info
{
  return [[CJEvent alloc] initWithInfo:info];
}

- (instancetype)initWithInfo:(NSDictionary *)info
{
  self = [super initWithInfo:info];
  if (self && info) {
    // Core properties
    _name = info[kEventName];
    _background = info[kEventBackground];
    _flyers = info[kEventFlyers];
    _about = info[kEventDescription];
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
    
    // Links
    self.links.mapping = @{
                           @"artists": [CJArtist class],
                           @"comments": [CJComment class],
                           @"followers": [CJUser class],
                           @"musicGenres": [CJMusicGenre class],
                           @"tickets": [CJTicket class],
                           @"venue": [CJVenue class]
                           };
    
    // Embeddables
    _artists = [(NSArray *) info[kEventArtists][@"source"] map:^id(NSDictionary *artist) {
      return [[CJArtist alloc] initWithInfo:artist];
    }];
    _venue = [[CJVenue alloc] initWithInfo:info[kEventVenue][@"source"]];
    _musicGenres = [(NSArray *) info[kEventMusicGenres][@"source"] map:^id(NSDictionary *genre) {
      return [[CJMusicGenre alloc] initWithInfo:genre];
    }];
    _followers = [(NSArray *) info[kEventFollowers][@"source"] map:^id(NSDictionary *user) {
      return [[CJUser alloc] initWithInfo:user];
    }];
  }
  return self;
}

#pragma mark - Actions

+ (CJAPIRequest *)requestForSearchWithTerm:(NSString *)term
{
  CJAPIRequest *request = [[CJAPIRequest alloc] initWithMethod:@"get"
                                                       andPath:@"events/search"];
  
  [request setModelClass:[CJEvent class]];
  [request setParameters:@{@"term": term}];
  
  // Searches rarely change, so cache this more aggressively
  [request setCachePolicy:CJAPIRequestReturnCacheDataElseLoad];
  
  return request;
}

- (void)follow
{
  [self followEntity:@"event"];
}

- (void)unfollow
{
  [self unfollowEntity:@"event"];
}

- (NSUInteger)distanceFromLocation:(CLLocation *)location
{
  NSAssert(self.venue, @"You need to embed a CJVenue model for this to work!");
  
  return [self.venue distanceFromLocation:location];
}

- (NSString *)imagePathForFlyerAtPosition:(NSInteger)position
                                 withSize:(NSString *)size
{
  NSAssert((position < _flyers.count), @"There is no flyer at position %lu", (long)position);
  
  NSDictionary *flyer = [_flyers objectAtIndex:position];
  
  return [self imagePathForImageInfo:flyer andSize:size];
}

- (NSString *)imagePathForBackgroundwithSize:(NSString *)size
{
  return [self imagePathForImageInfo:_background andSize:size];
}

@end
