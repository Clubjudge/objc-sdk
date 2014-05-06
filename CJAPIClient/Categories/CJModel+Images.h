//
//  CJModel+Images.h
//  CJAPIClient
//
//  Created by Bruno Abrantes on 06/05/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJModel.h"
#import <UIKit/UIKit.h>

@interface CJModel (Images)

- (NSString *)imagePathForImageInfo:(NSDictionary *)imageInfo
                            andSize:(NSInteger)size;

@end
