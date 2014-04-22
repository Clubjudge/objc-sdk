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
  if (!dateString) return nil;
  
  if ([dateString hasSuffix:@"Z"]) {
    dateString = [[dateString substringToIndex:(dateString.length-1)] stringByAppendingString:@"-0000"];
  }
  
  return [self dateFromString:dateString
                   withFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
}

+ (NSDate *)dateFromString:(NSString *)dateString
                withFormat:(NSString *)dateFormat
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:dateFormat];
  NSDate *date = [dateFormatter dateFromString:dateString];
  
  return date;
}

@end
