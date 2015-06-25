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
#import "CJTag.h"
#import "CJComment.h"
#import "CJRating.h"
#import "CJReview.h"
#import "CJLinksInfo.h"
#import "CJModel+Distance.h"
#import <ObjectiveSugar/ObjectiveSugar.h>
#import "CJModel+Images.h"

@implementation CJVenue

static NSString *kVenueCreatedAt = @"createdAt";
static NSString *kVenueUpdatedAt = @"updatedAt";
static NSString *kVenueName = @"name";
static NSString *kVenueClosed = @"closed";
static NSString *kVenueReviewsCount = @"reviewsCount";
static NSString *kVenueCommentsCount = @"commentsCount";
static NSString *kVenueFollowersCount = @"followersCount";
static NSString *kUpcomingEventsCount = @"upcomingEventsCount";
static NSString *kKeywords = @"keywords";
static NSString *kVenueTypes = @"venueTypes";
static NSString *kVenueLogo = @"logo";
static NSString *kVenueBackground = @"background";
static NSString *kVenueAddress = @"address";
static NSString *kVenueScores = @"scores";

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
static NSString *kVenueLinkDetails = @"details";

@synthesize geolocation = _geolocation;

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
      _createdAt = [NSDate dateWithISO8601String:info[kVenueCreatedAt]];
      _updatedAt = [NSDate dateWithISO8601String:info[kVenueUpdatedAt]];
      _name = info[kVenueName];
      _closed = [info[kVenueClosed] boolValue];
      _reviewsCount = info[kVenueReviewsCount];
      _commentsCount = info[kVenueCommentsCount];
      _followersCount = info[kVenueFollowersCount];
      _upcomingEventsCount = info[kVenueUpcomingEvents];
      _keywords = info[kKeywords];
      
      NSMutableArray *venueTypes = [NSMutableArray new];
      if(info[kVenueTypes]) {
          for(NSDictionary *venueTypeInfo in info[kVenueTypes]) {
              [venueTypes addObject:[CJTag tagWithInfo:venueTypeInfo]];
          }
      }
      _venueTypes = venueTypes;
    
      _background = [info[kVenueBackground] isEqual:[NSNull null]] ? [NSDictionary new] : info[kVenueBackground];
      _address = [info[kVenueAddress] isEqual:[NSNull null]] ? [NSDictionary new] : info[kVenueAddress];
      _logo = [info[kVenueLogo] isEqual:[NSNull null]] ? [NSDictionary new] : info[kVenueLogo];
      _scores = [info[kVenueScores] isEqual:[NSNull null]] ? [NSDictionary new] : info[kVenueScores];
    
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
      _details = [CJVenueDetails venueDetailsWithInfo:info[kVenueLinkDetails][@"source"]];
  }
  return self;
}

-(CLLocationCoordinate2D) geolocation {
    NSDictionary *geolocationDic = nil;
    if(![_address[@"geolocation"] isEqual:[NSNull null]]) {
        geolocationDic = _address[@"geolocation"];
    }
    else if(![_address[@"city"] isEqual:[NSNull null]] && ![_address[@"city"][@"geolocation"] isEqual:[NSNull null]]) {
        geolocationDic = _address[@"city"][@"geolocation"];
    }
    if(geolocationDic) {
        double latitute = [geolocationDic[@"lat"] doubleValue];
        double longitude = [geolocationDic[@"lon"] doubleValue];
        
        _geolocation = CLLocationCoordinate2DMake(latitute, longitude);
    }
    
    return _geolocation;
}

#pragma mark - Actions

+ (CJAPIRequest *)requestForSearchWithTerm:(NSString *)term
{
  CJAPIRequest *request = [[CJAPIRequest alloc] initWithMethod:@"get"
                                                       andPath:@"venues/search"];
  
  [request setModelClass:[CJVenue class]];
  [request setParameters:@{@"term": term}];
  
  // Searches rarely change, so cache this more aggressively
  [request setCachePolicy:CJAPIRequestReturnCacheDataElseLoad];
  
  return request;
}

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
    if(CLLocationCoordinate2DIsValid([self geolocation])) {
        CLLocation *venueLocation = [[CLLocation alloc] initWithLatitude:[self geolocation].latitude longitude:[self geolocation].longitude];
        
        return [self distanceToLocation:venueLocation
                           fromLocation:location];
    }
    
    return NSNotFound;
}

- (NSString *)imagePathForLogoWithSize:(NSString *)size
{
  return [self imagePathForImageInfo:_logo andSize:size];
}

- (NSString *)imagePathForBackgroundWithSize:(NSString *)size
{
  return [self imagePathForImageInfo:_background andSize:size];
}

@end
