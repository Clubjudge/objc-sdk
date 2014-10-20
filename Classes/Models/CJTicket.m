//
//  CJTicket.m
//  CJKit
//
//  Created by Bruno Abrantes on 24/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJTicket.h"

@implementation CJTicket

static NSString *kTicketName = @"name";
static NSString *kTicketCents = @"cents";
static NSString *kTicketCurrency = @"currency";
static NSString *kTicketText = @"text";
static NSString *kTicketURL = @"url";

#pragma mark - Initializers

+ (instancetype)ticketWithInfo:(NSDictionary *)info
{
  return [[CJTicket alloc] initWithInfo:info];
}

- (instancetype)initWithInfo:(NSDictionary *)info
{
  self = [super initWithInfo:info];
  if (self && info) {
    // Core properties
    _name = info[kTicketName];
    _cents = info[kTicketCents];
    _currency = info[kTicketCurrency];
    _text = info[kTicketText];
    _url = [NSURL URLWithString:info[kTicketURL]];
  }
  return self;
}

@end
