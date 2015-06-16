//
//  CJTag.h
//  Pods
//
//  Created by João Santos on 15/06/15.
//
//

#import <Foundation/Foundation.h>

@interface CJTag : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *type;

#pragma mark - Initializers

+ (instancetype)tagWithInfo:(NSDictionary *)info;

@end
