//
//  NSDate+StringParsing.h
//  CJAPIClient
//
//  Created by Bruno Abrantes on 22/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (StringParsing)

+ (NSDate *)dateWithISO8601String:(NSString *)dateString;

@end
