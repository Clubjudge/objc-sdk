//
//  CJVenue.h
//  CJKit
//
//  Created by Bruno Abrantes on 23/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJAPIRequest.h"
#import "CJModel.h"
#import "CJVenueDetails.h"
#import <CoreLocation/CoreLocation.h>

@interface CJVenue : CJModel

#pragma mark - Core properties

@property(nonatomic, strong) NSDate *createdAt;
@property(nonatomic, strong) NSDate *updatedAt;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, assign) BOOL closed;
@property(nonatomic, strong) NSNumber *reviewsCount;
@property(nonatomic, strong) NSNumber *commentsCount;
@property(nonatomic, strong) NSNumber *followersCount;
@property(nonatomic, strong) NSNumber *upcomingEventsCount;
@property(nonatomic, strong) NSArray *keywords;
@property(nonatomic, strong) NSArray *venueTypes;
@property(nonatomic, strong) NSDictionary *logo;
@property(nonatomic, strong) NSDictionary *background;
@property(nonatomic, strong) NSDictionary *address;
@property(nonatomic, strong) NSDictionary *scores;

#pragma mark - Helper Properties
@property(nonatomic, assign, readonly) CLLocationCoordinate2D geolocation;

#pragma mark - Embeddables

@property(nonatomic, strong) NSArray *events;
@property(nonatomic, strong) NSArray *upcomingEvents;
@property(nonatomic, strong) NSArray *recentEvents;
@property(nonatomic, strong) NSArray *followers;
@property(nonatomic, strong) CJVenueDetails *details;

#pragma mark - Initializers

+ (instancetype)venueWithInfo:(NSDictionary *)info;

#pragma mark - Actions

+ (CJAPIRequest *)requestForSearchWithTerm:(NSString *)term;

- (void)follow;
- (void)unfollow;

- (NSUInteger)distanceFromLocation:(CLLocation *)location;

- (NSString *)imagePathForLogoWithSize:(NSString *)size;
- (NSString *)imagePathForBackgroundWithSize:(NSString *)size;

@end
