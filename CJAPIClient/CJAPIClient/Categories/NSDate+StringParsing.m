//
//  NSDate+StringParsing.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 22/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "NSDate+StringParsing.h"

@implementation NSDate (StringParsing)

+ (NSDate *)dateWithISO8601String:(NSString *)dateString
{
  if (!dateString || [dateString isKindOfClass:[NSNull class]]) return nil;
  
  NSError *error = NULL;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\.\\d*Z"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:&error];
  dateString = [regex stringByReplacingMatchesInString:dateString
                                               options:0
                                                 range:NSMakeRange(0, [dateString length])
                                          withTemplate:@"$2$1"];
  
  return [self dateFromString:dateString
                   withFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
}

+ (NSDate *)dateFromString:(NSString *)dateString
                withFormat:(NSString *)dateFormat
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:dateFormat];
  
  NSLocale *locale = [[NSLocale alloc]
                      initWithLocaleIdentifier:@"en_US_POSIX"];
  [dateFormatter setLocale:locale];
  [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
  
  NSDate *date = [dateFormatter dateFromString:dateString];
  return date;
}

@end
