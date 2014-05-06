//
//  CJVenue.h
//  CJAPIClient
//
//  Created by Bruno Abrantes on 23/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJModel.h"
#import <CoreLocation/CoreLocation.h>

@interface CJVenue : CJModel

#pragma mark - Core properties

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *description;
@property(nonatomic, assign) BOOL following;
@property(nonatomic, strong) NSDate *updatedAt;
@property(nonatomic, strong) NSNumber *followersCount;
@property(nonatomic, strong) NSNumber *commentsCount;
@property(nonatomic, strong) NSNumber *socialMentionsCount;
@property(nonatomic, strong) NSNumber *reviewCount;
@property(nonatomic, strong) NSArray *socialLinks;
@property(nonatomic, assign) CLLocationCoordinate2D geolocation;
@property(nonatomic, strong) NSDictionary *background;
@property(nonatomic, strong) NSDictionary *address;
@property(nonatomic, strong) NSArray *logos;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *websiteURL;
@property(nonatomic, strong) NSString *phoneNumber;

#pragma mark - Embeddables

@property(nonatomic, strong) NSArray *events;
@property(nonatomic, strong) NSArray *upcomingEvents;
@property(nonatomic, strong) NSArray *recentEvents;
@property(nonatomic, strong) NSArray *followers;

#pragma mark - Actions

- (void)follow;
- (void)unfollow;

- (NSUInteger)distanceFromLocation:(CLLocation *)location;

- (NSString *)imagePathForLogoWithSize:(NSInteger)size;
- (NSString *)imagePathForBackgroundWithSize:(NSInteger)size;

@end

#pragma mark - Mapping

#define kVenueName @"name"
#define kVenueDescription @"description"
#define kVenueFollowing @"follow"
#define kVenueUpdatedAt @"updatedAt"
#define kVenueFollowersCount @"followersCount"
#define kVenueCommentsCount @"commentsCount"
#define kVenueSocialMentionsCount @"socialMentionsCount"
#define kVenueReviewCount @"reviewCount"
#define kVenueSocialLinks @"socialLinks"
#define kVenueLogos @"logos"
#define kVenueAddress @"address"
#define kVenueBackground @"background"
#define kVenueGeolocation @"geolocation"
#define kVenueEmail @"email"
#define kVenueWebsiteURL @"websiteUrl"
#define kVenuePhoneNumber @"phoneNumber"

#define kVenueEvents @"events"
#define kVenueUpcomingEvents @"upcoming"
#define kVenueRecentEvents @"recent"
#define kVenueFollowers @"followers"

#define kVenueLinkEvents @"events"
#define kVenueLinkUpcomingEvents @"upcoming"
#define kVenueLinkRecentEvents @"recent"
#define kVenueLinkComments @"comments"
#define kVenueLinkFollowers @"followers"
#define kVenueLinkRatings @"ratings"
