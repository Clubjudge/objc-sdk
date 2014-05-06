//
//  CJEvent.h
//  CJAPIClient
//
//  Created by Bruno Abrantes on 22/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CJModel.h"
@class CJVenue;

@interface CJEvent : CJModel

#pragma mark - Core properties

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSArray *flyers;
@property(nonatomic, strong) NSString *description;
@property(nonatomic, strong) NSDate *startsAt;
@property(nonatomic, strong) NSDate *endsAt;
@property(nonatomic, strong) NSDate *reviewEndsAt;
@property(nonatomic, strong) NSDate *updatedAt;
@property(nonatomic, assign) BOOL featured;
@property(nonatomic, assign) BOOL following;
@property(nonatomic, assign) BOOL lineupToBeAnnounced;
@property(nonatomic, assign) BOOL reviewable;
@property(nonatomic, assign) BOOL published;
@property(nonatomic, strong) NSNumber *followersCount;
@property(nonatomic, strong) NSNumber *commentsCount;
@property(nonatomic, strong) NSNumber *friendsFollowingCount;
@property(nonatomic, strong) NSNumber *reviewCount;
@property(nonatomic, strong) NSDictionary *userData;
@property(nonatomic, strong) NSDictionary *contest;
@property(nonatomic, strong) NSDictionary *expertReviewRatings;
@property(nonatomic, strong) NSDictionary *globalRating;

#pragma mark - Embeddables

@property(nonatomic, strong) NSArray *artists;
@property(nonatomic, strong) CJVenue *venue;
@property(nonatomic, strong) NSArray *musicGenres;
@property(nonatomic, strong) NSArray *followers;

#pragma mark - Actions

- (void)follow;
- (void)unfollow;

- (NSUInteger)distanceFromLocation:(CLLocation *)location;

- (NSString *)imagePathForFlyerAtPosition:(NSInteger)position
                                 withSize:(NSInteger)size;

@end

#pragma mark - Mapping

#define kEventName @"name"
#define kEventFlyers @"flyers"
#define kEventDescription @"description"
#define kEventStartsAt @"startsAt"
#define kEventEndsAt @"endsAt"
#define kEventReviewEndsAt @"reviewEndsAt"
#define kEventUpdatedAt @"updatedAt"
#define kEventFeatured @"featured"
#define kEventFollowing @"follow"
#define kEventLineupTBA @"lineupToBeAnnounced"
#define kEventReviewable @"reviewable"
#define kEventPublished @"published"
#define kEventFollowersCount @"followersCount"
#define kEventCommentsCount @"commentsCount"
#define kEventFriendsFollowingCount @"friendsFollowingCount"
#define kEventReviewCount @"reviewCount"
#define kEventUserData @"userData"
#define kEventContest @"contest"
#define kEventExpertReviewRatings @"expertReviewRatings"
#define kEventGlobalRating @"globalRating"

#define kEventArtists @"artists"
#define kEventVenue @"venue"
#define kEventMusicGenres @"musicGenres"
#define kEventFollowers @"followers"

#define kEventLinkArtists @"artists"
#define kEventLinkComments @"comments"
#define kEventLinkInvitations @"invitations"
#define kEventLinkFollowers @"followers"
#define kEventLinkGenres @"musicGenres"
#define kEventLinkTickets @"tickets"
#define kEventLinkVenue @"venue"
