//
//  CJTicketTests.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 24/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CJTicket.h"

SPEC_BEGIN(CJTICKETSPEC)

describe(@"Ticket Model", ^{
  NSDictionary *stub = @{
                         @"name": @"Door Sale",
                         @"cents": @5000,
                         @"currency": @"EUR",
                         @"text": @"€50.00"
                         };
  
  __block CJTicket *ticket;
  beforeAll(^{
    ticket = [[CJTicket alloc] initWithInfo:stub];
  });
  
  context(@"Mapping", ^{
    describe(@"#name", ^{
      it(@"produces a correct mapping", ^{
        [[ticket.name should] equal:stub[@"name"]];
      });
    });
    
    describe(@"#cents", ^{
      it(@"produces a correct mapping", ^{
        [[ticket.cents should] equal:stub[@"cents"]];
      });
    });
    
    describe(@"#currency", ^{
      it(@"produces a correct mapping", ^{
        [[ticket.currency should] equal:stub[@"currency"]];
      });
    });
    
    describe(@"#text", ^{
      it(@"produces a correct mapping", ^{
        [[ticket.text should] equal:stub[@"text"]];
      });
    });
  });
});

SPEC_END

