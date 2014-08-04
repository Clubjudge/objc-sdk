//
//  CJVenue.m
//  CJKit
//
//  Created by Bruno Abrantes on 23/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJVenue.h"
#import "CJModel+Following.h"
#import "NSDate+StringParsing.h"
#import "CJEvent.h"
#import "CJUser.h"
#import "CJComment.h"
#import "CJRating.h"
#import "CJReview.h"
#import "CJLinksInfo.h"
#import "CJModel+Distance.h"
#import <ObjectiveSugar/ObjectiveSugar.h>
#import "CJModel+Images.h"

@implementation CJVenue

static NSString *kVenueName = @"name";
static NSString *kVenueDescription = @"description";
static NSString *kVenueFollowing = @"follow";
static NSString *kVenueUpdatedAt = @"updatedAt";
static NSString *kVenueFollowersCount = @"followersCount";
static NSString *kVenueCommentsCount = @"commentsCount";
static NSString *kVenueSocialMentionsCount = @"socialMentionsCount";
static NSString *kVenueReviewCount = @"reviewCount";
static NSString *kVenueSocialLinks = @"socialLinks";
static NSString *kVenueLogos = @"logos";
static NSString *kVenueAddress = @"address";
static NSString *kVenueBackground = @"background";
static NSString *kVenueGeolocation = @"geolocation";
static NSString *kVenueEmail = @"email";
static NSString *kVenueWebsiteURL = @"websiteUrl";
static NSString *kVenuePhoneNumber = @"phoneNumber";

static NSString *kVenueEvents = @"events";
static NSString *kVenueUpcomingEvents = @"upcoming";
static NSString *kVenueRecentEvents = @"recent";
static NSString *kVenueFollowers = @"followers";

static NSString *kVenueLinkEvents = @"events";
static NSString *kVenueLinkUpcomingEvents = @"upcoming";
static NSString *kVenueLinkRecentEvents = @"recent";
static NSString *kVenueLinkComments = @"comments";
static NSString *kVenueLinkFollowers = @"followers";
static NSString *kVenueLinkRatings = @"ratings";

#pragma mark - Initializers

+ (instancetype)venueWithInfo:(NSDictionary *)info
{
  return [[CJVenue alloc] initWithInfo:info];
}

- (instancetype)initWithInfo:(NSDictionary *)info
{
  self = [super initWithInfo:info];
  if (self && info) {
    // Core properties
    _name = info[kVenueName];
    _about = info[kVenueDescription];
    _updatedAt = [NSDate dateWithISO8601String:info[kVenueUpdatedAt]];
    _following = [info[kVenueFollowing] boolValue];
    _followersCount = info[kVenueFollowersCount];
    _commentsCount = info[kVenueCommentsCount];
    _socialMentionsCount = info[kVenueSocialMentionsCount];
    _reviewCount = info[kVenueReviewCount];
    _socialLinks = info[kVenueSocialLinks];
    
    _geolocation = kCLLocationCoordinate2DInvalid;
    if (info[kVenueGeolocation][@"lat"] != [NSNull null] && info[kVenueGeolocation][@"lon"] != [NSNull null]) {
      double lat = [info[kVenueGeolocation][@"lat"] doubleValue];
      double lon = [info[kVenueGeolocation][@"lon"] doubleValue];
      _geolocation = CLLocationCoordinate2DMake(lat, lon);
    }
    
    _background = info[kVenueBackground];
    _address = info[kVenueAddress];
    _logos = info[kVenueLogos];
    _email = info[kVenueEmail];
    _websiteURL = info[kVenueWebsiteURL];
    _phoneNumber = info[kVenuePhoneNumber];
    
    // Links
    self.links.mapping = @{
                           @"events": [CJEvent class],
                           @"upcoming": [CJEvent class],
                           @"recent": [CJEvent class],
                           @"comments": [CJComment class],
                           @"followers": [CJUser class],
                           @"ratings": [CJRating class],
                           @"reviews": [CJReview class]
                           };
    
    // Embeddables
    _events = [(NSArray *) info[kVenueEvents][@"source"] map:^id(NSDictionary *event) {
      return [[CJEvent alloc] initWithInfo:event];
    }];
    _recentEvents = [(NSArray *) info[kVenueRecentEvents][@"source"] map:^id(NSDictionary *event) {
      return [[CJEvent alloc] initWithInfo:event];
    }];
    _upcomingEvents = [(NSArray *) info[kVenueUpcomingEvents][@"source"] map:^id(NSDictionary *event) {
      return [[CJEvent alloc] initWithInfo:event];
    }];
    _followers = [(NSArray *) info[kVenueFollowers][@"source"] map:^id(NSDictionary *user) {
      return [[CJUser alloc] initWithInfo:user];
    }];
  }
  return self;
}

#pragma mark - Actions

- (void)follow
{
  [self followEntity:@"venue"];
}

- (void)unfollow
{
  [self unfollowEntity:@"venue"];
}

- (NSUInteger)distanceFromLocation:(CLLocation *)location
{
  CLLocation *venueLocation = [[CLLocation alloc] initWithLatitude:self.geolocation.latitude longitude:self.geolocation.longitude];
  
  return [self distanceToLocation:venueLocation
                     fromLocation:location];
}

- (NSString *)imagePathForLogoWithSize:(NSString *)size
{
  return [self imagePathForImageInfo:[_logos firstObject] andSize:size];
}

- (NSString *)imagePathForBackgroundWithSize:(NSString *)size
{
  return [self imagePathForImageInfo:_background andSize:size];
}

@end
