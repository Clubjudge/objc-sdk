//
//  CJVenue.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 23/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJVenue.h"
#import "CJModel+Following.h"
#import "NSDate+StringParsing.h"
#import "CJEvent.h"
#import "CJUser.h"

@implementation CJVenue

- (instancetype)initWithInfo:(NSDictionary *)info
{
  self = [super initWithInfo:info];
  if (self && info) {
    // Core properties
    _name = info[kVenueName];
    _description = info[kVenueDescription];
    _updatedAt = [NSDate dateWithISO8601String:info[kVenueUpdatedAt]];
    _following = [info[kVenueFollowing] boolValue];
    _followersCount = info[kVenueFollowersCount];
    _commentsCount = info[kVenueCommentsCount];
    _socialMentionsCount = info[kVenueSocialMentionsCount];
    _reviewCount = info[kVenueReviewCount];
    _socialLinks = info[kVenueSocialLinks];
    
    double lat = [info[kVenueGeolocation][@"lat"] doubleValue];
    double lon = [info[kVenueGeolocation][@"lon"] doubleValue];
    _geolocation = CLLocationCoordinate2DMake(lat, lon);
    
    _background = info[kVenueBackground];
    _address = info[kVenueAddress];
    _logos = info[kVenueLogos];
    _email = info[kVenueEmail];
    _websiteURL = info[kVenueWebsiteURL];
    _phoneNumber = info[kVenuePhoneNumber];
    
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

- (void)follow
{
  [self followEntity:@"venue"];
}

- (void)unfollow
{
  [self unfollowEntity:@"venue"];
}

@end
