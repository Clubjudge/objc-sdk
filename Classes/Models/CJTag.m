//
//  CJTag.m
//  Pods
//
//  Created by João Santos on 15/06/15.
//
//

#import "CJTag.h"

@implementation CJTag

static NSString *kTagName = @"name";
static NSString *kTypeName = @"type";

+(instancetype) tagWithInfo:(NSDictionary *)info {
    return [[CJTag alloc] initWithInfo:info];
}

-(instancetype) initWithInfo:(NSDictionary *) info {
    if(self && info) {
        _name = info[kTagName];
        _type = info[kTypeName];
    }
    return self;
}

@end
