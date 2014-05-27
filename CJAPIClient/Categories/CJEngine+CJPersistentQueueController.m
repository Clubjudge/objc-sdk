//
//  CJEngine+CJPersistentQueueController.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 27/05/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJEngine+CJPersistentQueueController.h"

@implementation CJEngine (CJPersistentQueueController)

- (CJPersistentQueueController *)persistentQueueController
{
  return [CJPersistentQueueController sharedController];
}

@end
