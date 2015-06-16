//
//  CJVenueDetails.m
//  Pods
//
//  Created by João Santos on 15/06/15.
//
//

#import "CJVenueDetails.h"
#import "NSDate+StringParsing.h"

@implementation CJVenueDetails

static NSString *kVenueEmail = @"email";
static NSString *kVenueHideEmail = @"hideEmail";
static NSString *kVenueWebsiteUrl = @"websiteUrl";
static NSString *kVenuePhoneNumber = @"phoneNumber";
static NSString *kVenueHidePhoneNumber = @"hidePhoneNumber";
static NSString *kVenueDescription = @"description";
static NSString *kVenueEscapedDescription = @"escapedDescription";
static NSString *kVenueShortescription = @"shortDescription";
static NSString *kVenueOpenSince = @"openSince";
static NSString *kVenueCapacity = @"capacity";
static NSString *kVenueMinimumAge = @"minimumAge";
static NSString *kVenueVipAccess = @"vipAccess";
static NSString *kVenuePriceRange = @"priceRange";
static NSString *kVenueVipPrivateArea = @"vipPrivateArea";
static NSString *kVenueParking = @"parking";
static NSString *kVenuePublicTransportation = @"publicTransportation";
static NSString *kVenuePaymentOptions = @"paymentOptions";
static NSString *kVenueServices = @"services";
static NSString *kVenueHouseRules = @"houseRules";

+ (instancetype)venueDetailsWithInfo:(NSDictionary *)info {
    return [[CJVenueDetails alloc] initWithInfo:info];
}

- (instancetype) initWithInfo:(NSDictionary *)info {
    if(self && info) {
    
        _email = info[kVenueEmail];
        _hideEmail = [info[kVenueHideEmail] isEqual:[NSNull null]] ? false : [info[kVenueHideEmail] boolValue];
        _websiteUrl = info[kVenueWebsiteUrl];
        _phoneNumber = info[kVenuePhoneNumber];
        _hidePhoneNumber = [info[kVenueHidePhoneNumber] isEqual:[NSNull null]] ? false : [info[kVenueHidePhoneNumber] boolValue];
        _about = info[kVenueDescription];
        _escapedAbout = info[kVenueEscapedDescription];
        _shortAbout = info[kVenueShortescription];
        _openSince = [info[kVenueOpenSince] isEqual:[NSNull null]] ? nil : [NSDate dateFromString:info[kVenueOpenSince] withFormat:@"yyyy-MM-dd"];
        _capacity = [info[kVenueCapacity] isEqual:[NSNull null]] ? nil : [NSNumber numberWithInteger:[info[kVenueCapacity] integerValue]];
        _minimumAge = [info[kVenueMinimumAge] isEqual:[NSNull null]] ? nil : [NSNumber numberWithInteger:[info[kVenueMinimumAge] integerValue]];
        _vipAccess = [info[kVenueVipAccess] isEqual:[NSNull null]] ? false : [info[kVenueVipAccess] boolValue];
        _priceRange = [info[kVenuePriceRange] isEqual:[NSNull null]] ? nil : [NSNumber numberWithInteger:[info[kVenuePriceRange] integerValue]];
        _vipPrivateArea = [info[kVenueVipPrivateArea] isEqual:[NSNull null]] ? false : [info[kVenueVipPrivateArea] boolValue];
        _parking = info[kVenueParking];
        _publicTransportation = info[kVenuePublicTransportation];
        _paymentOptions = info[kVenuePaymentOptions];
        _services = info[kVenueServices];
        _houseRules = info[kVenueHouseRules];
        
    }
    return self;
}

@end
