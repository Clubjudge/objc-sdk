//
//  CJMusicGenreTests.c
//  CJKit
//
//  Created by Bruno Abrantes on 24/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <CJKit/CJMusicGenre.h>

SPEC_BEGIN(CJMUSICGENRESPEC)

describe(@"Music Genre Model", ^{
  NSDictionary *stub = @{
                         @"id": @1,
                         @"parentId": @50,
                         @"name": @"House",
                         @"inferred": @NO
                         };
  
  __block CJMusicGenre *genre;
  beforeEach(^{
    genre = [[CJMusicGenre alloc] initWithInfo:stub];
  });
  
  describe(@".musicGenreWithInfo:", ^{
    it(@"Returns a new instance of a CJMusicGenre with the provided info", ^{
      genre = [CJMusicGenre musicGenreWithInfo:stub];
      
      [[genre.Id should] equal:stub[@"id"]];
    });
  });
  
  context(@"Mapping", ^{
    describe(@"#Id", ^{
      it(@"produces a correct mapping", ^{
        [[genre.Id should] equal:stub[@"id"]];
      });
    });
    
    describe(@"#parentId", ^{
      it(@"produces a correct mapping", ^{
        [[genre.parentId should] equal:stub[@"parentId"]];
      });
    });
    
    describe(@"#name", ^{
      it(@"produces a correct mapping", ^{
        [[genre.name should] equal:stub[@"name"]];
      });
    });
    
    describe(@"#inferred", ^{
      it(@"produces a correct mapping", ^{
        [[theValue(genre.inferred) should] equal:stub[@"inferred"]];
      });
    });
  });
});

SPEC_END
