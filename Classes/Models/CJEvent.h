//
//  CJEvent.h
//  CJKit
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
@property(nonatomic, strong) NSDictionary *background;
@property(nonatomic, strong) NSDictionary *contest;
@property(nonatomic, strong) NSDictionary *expertReviewRatings;
@property(nonatomic, strong) NSDictionary *globalRating;

#pragma mark - Embeddables

@property(nonatomic, strong) NSArray *artists;
@property(nonatomic, strong) CJVenue *venue;
@property(nonatomic, strong) NSArray *musicGenres;
@property(nonatomic, strong) NSArray *followers;

#pragma mark - Initializers

+ (instancetype)eventWithInfo:(NSDictionary *)info;

#pragma mark - Actions

- (void)follow;
- (void)unfollow;

- (NSUInteger)distanceFromLocation:(CLLocation *)location;

- (NSString *)imagePathForFlyerAtPosition:(NSInteger)position
                                 withSize:(NSString *)size;

- (NSString *)imagePathForBackgroundwithSize:(NSString *)size;

@end
