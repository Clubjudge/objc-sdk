//
//  CJAPIRequest+PromiseKit.h
//  CJKit
//
//  Created by Bruno Abrantes on 05/05/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJAPIRequest.h"
#import <PromiseKit/Promise.h>

@interface CJAPIRequest (PromiseKit)

/**
 * Returns a Promise that overlays a kitten image.
 * @return A Promise that will `then` a `UIImage *` object.
 */
- (Promise *)perform;

@end
