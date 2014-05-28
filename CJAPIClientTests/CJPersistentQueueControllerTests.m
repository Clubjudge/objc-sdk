//
//  CJPersistentQueueControllerTests.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 27/05/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "CJPersistentQueueController.h"
#import "CJAPIRequest.h"
#import <BAPersistentOperationQueue/BAPersistentOperation.h>

SPEC_BEGIN(CJPERSISTENTQUEUECONTROLLERSPEC)

describe(@"CJPersistentQueueController", ^{
  describe(@".sharedController", ^{
    it(@"returns a shared object", ^{
      CJPersistentQueueController *controller = [CJPersistentQueueController sharedController];
      CJPersistentQueueController *controller2 = [CJPersistentQueueController sharedController];
      
      [[controller should] beKindOfClass:[CJPersistentQueueController class]];
      [[controller should] equal:controller2];
    });
    
    it(@"sets up a queue", ^{
      [[[CJPersistentQueueController sharedController].queue shouldNot] beNil];
    });
  });
  
  describe(@"Reachability", ^{
    __block CJPersistentQueueController *controller;
    beforeEach(^{
      controller = [CJPersistentQueueController sharedController];
    });
  
    context(@"When the network can be reached", ^{
      it(@"starts the queue", ^{
        [[controller.queue shouldEventually] receive:@selector(startWorking)];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AFNetworkingReachabilityDidChangeNotification
                                                            object:nil
                                                          userInfo:@{AFNetworkingReachabilityNotificationStatusItem: @(AFNetworkReachabilityStatusReachableViaWWAN)}];
      });
    });
    
    context(@"When the network cannot be reached", ^{
      it(@"stops the queue", ^{
        [[controller.queue should] receive:@selector(stopWorking)];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AFNetworkingReachabilityDidChangeNotification
                                                            object:nil
                                                          userInfo:@{AFNetworkingReachabilityNotificationStatusItem: @(AFNetworkReachabilityStatusNotReachable)}];
      });
    });
  });
  
  describe(@"#startMonitoring", ^{
    __block CJPersistentQueueController *controller;
    __block KWCaptureSpy *spy;
    beforeEach(^{
      controller = [CJPersistentQueueController sharedController];
      spy = [[AFNetworkReachabilityManager sharedManager] captureArgument:@selector(setReachabilityStatusChangeBlock:)
                                                                  atIndex:0];
    });
    
    context(@"When the network can be reached", ^{
      it(@"starts the queue", ^{
        [[controller.queue should] receive:@selector(startWorking)];
        
        [controller startMonitoring];
        
        void (^block)(AFNetworkReachabilityStatus) = spy.argument;
        block(AFNetworkReachabilityStatusReachableViaWiFi);
      });
    });
    
    context(@"When the network can be reached", ^{      
      it(@"starts the queue", ^{
        [[controller.queue should] receive:@selector(stopWorking)];
        
        [controller startMonitoring];
        
        void (^block)(AFNetworkReachabilityStatus) = spy.argument;
        block(AFNetworkReachabilityStatusNotReachable);
      });
    });
  });
  
  describe(@"#persistentOperationQueueSerializeObject:", ^{
    __block CJAPIRequest *request;
    __block CJPersistentQueueController *queueController;
    beforeEach(^{
      queueController = [CJPersistentQueueController sharedController];
      
      request = [[CJAPIRequest alloc] initWithMethod:@"POST" andPath:@"bla"];
      [request setEmbeds:@[@"venue"]];
      [request setFields:@[@"name"]];
      [request setParameters:@{@"foo": @"bar"}];
    });
    
    it(@"serializes a CJAPIRequest into a dictionary", ^{
      NSDictionary *data = [queueController persistentOperationQueueSerializeObject:request];
      
      [[data[@"path"] should] equal:[request.path stringByReplacingOccurrencesOfString:@"/v1" withString:@""]];
      [[data[@"method"] should] equal:request.method];
      [[data[@"embeds"] should] equal:request.embeds];
      [[data[@"fields"] should] equal:request.fields];
      [[data[@"parameters"] should] equal:request.parameters];
    });
  });
  
  describe(@"#persistentOperationQueueStartedOperation:", ^{
    __block BAPersistentOperation *operation;
    __block CJPersistentQueueController *queueController;
    __block id allocation;
    __block CJAPIRequest *request = [[CJAPIRequest alloc] init];
    __block NSDictionary *data = @{
                                   @"path": @"bla",
                                   @"method": @"POST",
                                   @"embeds": @[@"venue"],
                                   @"fields": @[@"name"],
                                   @"parameters": @{@"foo": @"bar"}
                                   };
    beforeEach(^{
      queueController = [CJPersistentQueueController sharedController];
      operation = [[BAPersistentOperation alloc] initWithTimestamp:1000
                                                           andData:data];
      allocation = [CJAPIRequest alloc];
      [CJAPIRequest stub:@selector(alloc) andReturn:allocation];
      [allocation stub:@selector(initWithMethod:andPath:) andReturn:request];
    });
    
    it(@"serializes a dictionary into a CJAPIRequest", ^{
      [[allocation should] receive:@selector(initWithMethod:andPath:)
                  withArguments:@"POST", @"bla", nil];
      
      [[request should] receive:@selector(setEmbeds:) withArguments:@[@"venue"], nil];
      [[request should] receive:@selector(setFields:) withArguments:@[@"name"], nil];
      [[request should] receive:@selector(setParameters:) withArguments:@{@"foo": @"bar"}, nil];
      
      [queueController persistentOperationQueueStartedOperation:operation];
    });
    
    it(@"performs the request", ^{
      [[request should] receive:@selector(performWithSuccess:failure:)];
      
      [queueController persistentOperationQueueStartedOperation:operation];
    });
    
    context(@"When request succeeds", ^{
      it(@"finishes the operation", ^{
        KWCaptureSpy *spy = [request captureArgument:@selector(performWithSuccess:failure:) atIndex:0];
        
        [queueController persistentOperationQueueStartedOperation:operation];
        
        void (^block)(id response, CJPaginationInfo *pagination, CJLinksInfo *links) = spy.argument;
        
        [[operation should] receive:@selector(finish)];
        
        block(nil, nil, nil);
      });
    });
    
    context(@"When request fails", ^{
      __block KWCaptureSpy *spy;
      beforeEach(^{
        spy = [request captureArgument:@selector(performWithSuccess:failure:) atIndex:1];
        [queueController persistentOperationQueueStartedOperation:operation];
      });
      
      it(@"finishes the operation", ^{
        void (^block)(id response, CJPaginationInfo *pagination, CJLinksInfo *links) = spy.argument;
        
        [[operation should] receive:@selector(finish)];
        
        block(nil, nil, nil);
      });
      
      it(@"re-adds the request to the queue", ^{
        void (^block)(id response, CJPaginationInfo *pagination, CJLinksInfo *links) = spy.argument;
        
        [[queueController.queue should] receive:@selector(addObject:) withArguments:request,nil];
        
        block(nil, nil, nil);
      });
    });
  });
});

SPEC_END
