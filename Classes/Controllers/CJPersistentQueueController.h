//
//  CJPersistentQueueController.h
//  CJKit
//
//  Created by Bruno Abrantes on 27/05/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BAPersistentOperationQueue/BAPersistentOperationQueue.h>

@interface CJPersistentQueueController : NSObject <BAPersistentOperationQueueDelegate>

@property (nonatomic, strong) BAPersistentOperationQueue *queue;

#pragma mark - Initialization
/**
 *  Returns a shared singleton instance of a queue controller.
 *
 *  @return The shared queue controller.
 */
+ (CJPersistentQueueController *)sharedController;

#pragma mark - Database Path

/**
 *  Gets the database path used in the shared queue
 *
 *  @return The database path.
 */
+ (NSString *)databasePath;

/**
 *  Sets the database path used in the shared queue
 *
 *  @param path The path for the database used to store the queued requests
 */
+ (void)setDatabasePath:(NSString *)path;

/**
 Tells the queue to start monitoring.

 @warning If a network connection is available, the queue starts processing requests immediately.
 */
- (void)startMonitoring;

@end
