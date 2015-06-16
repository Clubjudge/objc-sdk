//
//  CJVenueDetails.h
//  Pods
//
//  Created by João Santos on 15/06/15.
//
//

#import <Foundation/Foundation.h>
#import "CJModel.h"

@interface CJVenueDetails : CJModel

@property(nonatomic, strong) NSString *email;
@property(nonatomic, assign) BOOL hideEmail;
@property(nonatomic, strong) NSString *websiteUrl;
@property(nonatomic, strong) NSString *phoneNumber;
@property(nonatomic, assign) BOOL hidePhoneNumber;
@property(nonatomic, strong) NSString *about;
@property(nonatomic, strong) NSString *escapedAbout;
@property(nonatomic, strong) NSString *shortAbout;
@property(nonatomic, strong) NSDate *openSince;
@property(nonatomic, strong) NSNumber *capacity;
@property(nonatomic, strong) NSNumber *minimumAge;
@property(nonatomic, assign) BOOL vipAccess;
@property(nonatomic, strong) NSNumber *priceRange;
@property(nonatomic, assign) BOOL vipPrivateArea;
@property(nonatomic, strong) NSDictionary *parking;
@property(nonatomic, strong) NSString *publicTransportation;
@property(nonatomic, strong) NSDictionary *paymentOptions;
@property(nonatomic, strong) NSDictionary *services;
@property(nonatomic, strong) NSString *houseRules;

#pragma mark - Initializers

+ (instancetype)venueDetailsWithInfo:(NSDictionary *)info;

@end
