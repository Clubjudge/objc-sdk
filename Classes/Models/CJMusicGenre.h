//
//  CJMusicGenre.h
//  CJKit
//
//  Created by Bruno Abrantes on 24/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJModel.h"

@interface CJMusicGenre : CJModel

#pragma mark - Core properties
@property (nonatomic, strong) NSNumber *parentId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL inferred;

@end