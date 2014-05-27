//
//  CJPersistentQueueController.h
//  CJAPIClient
//
//  Created by Bruno Abrantes on 27/05/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BAPersistentOperationQueue/BAPersistentOperationQueue.h>

@interface CJPersistentQueueController : NSObject <BAPersistentOperationQueueDelegate>

@property (nonatomic, strong) BAPersistentOperationQueue *queue;

#pragma mark - Initialization

+ (CJPersistentQueueController *)sharedController;

#pragma mark - Database Path

/**
 Gets the database path used in the shared queue
 */
+ (NSString *)databasePath;

/**
 Sets the database path used in the shared queue
 */
+ (void)setDatabasePath:(NSString *)path;

@end
