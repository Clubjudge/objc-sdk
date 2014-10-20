//
//  CJTicket.h
//  CJKit
//
//  Created by Bruno Abrantes on 24/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJModel.h"

@interface CJTicket : CJModel

#pragma mark - Core properties
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *cents;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSURL *url;

#pragma mark - Initializers
+ (instancetype)ticketWithInfo:(NSDictionary *)info;

@end
