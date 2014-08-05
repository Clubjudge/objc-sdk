//
//  CJVenue.h
//  CJKit
//
//  Created by Bruno Abrantes on 23/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJAPIRequest.h"
#import "CJModel.h"
#import <CoreLocation/CoreLocation.h>

@interface CJVenue : CJModel

#pragma mark - Core properties

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *about;
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
