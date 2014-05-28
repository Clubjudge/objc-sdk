//
//  CJPersistentQueueController.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 27/05/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJPersistentQueueController.h"
#import "CJAPIRequest.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

@implementation CJPersistentQueueController {
  id observer;
}

#pragma mark - Initialization

+ (CJPersistentQueueController *)sharedController
{
  static CJPersistentQueueController *sharedController = nil;
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    sharedController = [[self alloc] init];
  });
  
  return sharedController;
}

- (instancetype)init
{
  if (self = [super init]) {
    [self setupQueue];
    [self setupNotifications];
  }
  
  return self;
}

#pragma mark - Lifecycle
- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

#pragma mark - Database Path

static NSString* theDatabasePath = nil;
+ (NSString *)databasePath
{
  return theDatabasePath;
}

+ (void)setDatabasePath:(NSString *)path
{
  theDatabasePath = path;
}

#pragma mark - BAPersistentOperationQueueDelegate

- (NSDictionary *)persistentOperationQueueSerializeObject:(id)object
{
  CJAPIRequest *request = (CJAPIRequest *)object;
  
  NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithCapacity:5];
  
  if (request.path) {
    data[@"path"] = [request.path stringByReplacingOccurrencesOfString:@"/v1" withString:@""];
  }
  
  if (request.method) {
    data[@"method"] = request.method;
  }
  
  if (request.embeds) {
    data[@"embeds"] = request.embeds;
  }
  
  if (request.fields) {
    data[@"fields"] = request.fields;
  }
  
  if (request.parameters) {
    data[@"parameters"] = request.parameters;
  }
  
  return data;
}

- (void)persistentOperationQueueStartedOperation:(BAPersistentOperation *)operation
{
  CJAPIRequest *request = [[CJAPIRequest alloc] initWithMethod:operation.data[@"method"]
                                                       andPath:operation.data[@"path"]];
  
  request.embeds = operation.data[@"embeds"];
  request.fields = operation.data[@"fields"];
  request.parameters = operation.data[@"parameters"];
  
  __weak typeof(self)weakSelf = self;
  
  [request performWithSuccess:^(id response, CJPaginationInfo *pagination, CJLinksInfo *links) {
    [operation finish];
  }
                      failure:^(NSDictionary *error, NSNumber *statusCode) {
                        [operation finish];
                        [weakSelf.queue addObject:request];
                      }];
}

#pragma mark - Custom

- (void)startMonitoring
{
  ([AFNetworkReachabilityManager sharedManager].isReachable) ? [self.queue startWorking] : [self.queue stopWorking];
}

- (void)setupQueue
{
  self.queue = [[BAPersistentOperationQueue alloc] initWithDatabasePath:theDatabasePath];
  self.queue.delegate = self;
}

- (void)setupNotifications
{
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
  
  __weak typeof(self)weakSelf = self;
  
  observer = [center addObserverForName:AFNetworkingReachabilityDidChangeNotification
                                 object:nil
                                  queue:nil
                             usingBlock:^(NSNotification *note) {
                               AFNetworkReachabilityStatus status = [note.userInfo[AFNetworkingReachabilityNotificationStatusItem] intValue];
                                
                               if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) {
                                 [weakSelf.queue stopWorking];
                               } else {
                                 [weakSelf.queue startWorking];
                               }
                             }];
}

@end
