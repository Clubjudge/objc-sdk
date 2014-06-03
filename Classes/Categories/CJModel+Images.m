//
//  CJModel+Images.m
//  CJKit
//
//  Created by Bruno Abrantes on 06/05/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJModel+Images.h"
#import <ObjectiveSugar/ObjectiveSugar.h>

@implementation CJModel (Images)

- (NSString *)imagePathForImageInfo:(NSDictionary *)imageInfo
                            andSize:(NSInteger)size
{
  __block NSString *path = nil;
  
  [imageInfo each:^(NSString *key, NSString *value) {
    NSRange range = [key rangeOfString:@"_"
                               options:NSBackwardsSearch];
    
    key = [key substringFromIndex:range.location+1];
    
    if ([key integerValue] == size) {
      if ([self isRetinaDisplay]) {
        NSURL *url = [NSURL URLWithString:value];
        NSString *extension = [url pathExtension];
        url = [url URLByDeletingPathExtension];
        
        path = [[url absoluteString] stringByAppendingString:@"@2x"];
        url = [NSURL URLWithString:path];
        
        url = [url URLByAppendingPathExtension:extension];
        
        path = [url absoluteString];
      } else {
        path = value;
      }
    }
  }];
  
  return path;
}

#pragma mark - Helpers

- (BOOL)isRetinaDisplay
{
	int scale = 1.0;
	UIScreen *screen = [UIScreen mainScreen];
  
	if ([screen respondsToSelector:@selector(scale)]) {
		scale = screen.scale;
  }
  
	return (scale == 2.0f);
}

@end
