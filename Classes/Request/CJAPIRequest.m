//
//  CJAPIRequest.m
//  CJKit
//
//  Created by Bruno Abrantes on 16/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJAPIRequest.h"
#import "CJLinksInfo.h"
#import <ObjectiveSugar/ObjectiveSugar.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "CJPersistentQueueController.h"

#ifdef IS_OS_7_OR_LATER
#import <AFNetworking/AFHTTPSessionManager.h>
#else
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#endif

NSString *const kRequestMethodGET = @"GET";
NSString *const kRequestMethodPOST = @"POST";
NSString *const kRequestMethodPUT = @"PUT";
NSString *const kRequestMethodDELETE = @"DELETE";
NSString *const kRequestPathPrefix = @"/";

NSString *const kRequestClientId = @"clientId";
NSString *const kRequestAccessToken = @"token";
NSString *const kRequestFields = @"fields";
NSString *const kRequestEmbeds = @"embeds";

@interface CJAPIRequest() {
  dispatch_queue_t parseBackgroundQueue;
}

#ifdef IS_OS_7_OR_LATER
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
#else
@property (nonatomic, strong) AFHTTPRequestOperationManager *sessionManager;
#endif
@end

@implementation CJAPIRequest

#pragma mark - Initialisers

- (instancetype)initWithMethod:(NSString *)method
                       andPath:(NSString *)path
{
  if (self = [self init]) {
    [self setMethod:method];
    [self setPath:path];
    self.sessionManager = [[CJEngine sharedEngine] sessionManager];
    self.retries = 0;
    
    parseBackgroundQueue = dispatch_queue_create("background", NULL);
  }
  
  return self;
}

- (instancetype)init
{
  if (self = [super init]) {
    _method = kRequestMethodGET;
    _path = kRequestPathPrefix;
  }
  
  return self;
}


#pragma mark - Custom setters

- (void)setMethod:(NSString *)method
{
  NSArray *methods = @[kRequestMethodGET, kRequestMethodPOST, kRequestMethodPUT, kRequestMethodDELETE];
  method = [method uppercaseString];
  BOOL methodAllowed = [methods containsObject:method];
  
  NSAssert(methodAllowed, @"%@ is not a supported method", method);
  
  if (methodAllowed) {
    _method = method;
  }
}

- (void)setPath:(NSString *)path
{
  if([path hasPrefix:kRequestPathPrefix]) {
    path = [path substringFromIndex:1];
  }
  
  NSString *version = [NSString stringWithFormat:@"/v%ld/", (long)[CJEngine version]];
  
  path = [version stringByAppendingString:path];
  
  path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
  NSURL *url = [NSURL URLWithString:path];
  url = [url URLByDeletingPathExtension];
  url = [url URLByAppendingPathExtension:@"json"];
  
  path = [url relativeString];
  
  _path = path;
}

#pragma mark - Custom getter
- (CJAPIRequestCachePolicy)cachePolicy
{
  if (_cachePolicy) {
    return _cachePolicy;
  } else {
    return [CJEngine sharedEngine].cachePolicy;
  }
}

#pragma mark - Actions

- (void)performWithSuccess:(void (^)(id response, CJPaginationInfo *pagination, CJLinksInfo *links))success
                   failure:(CJFailureBlock)failure
{
  void (^selectedMethod)() = @{
                               kRequestMethodGET : ^{
                                 [self GETWithSuccess:^(id operation, id responseObject) {
                                   dispatch_async(parseBackgroundQueue, ^{
                                     NSString *sourceKey = [[[responseObject allKeys] reject:^BOOL(id object) {
                                       return [(NSString *)object hasPrefix:@"_"];
                                     }] first];
                                     
                                     NSDictionary *source = [responseObject objectForKey:sourceKey];
                                     
                                     CJPaginationInfo *pagination = [[CJPaginationInfo alloc] initWithInfo:responseObject[@"_pagination"]];
                                     CJLinksInfo *links = [[CJLinksInfo alloc] initWithInfo:responseObject[@"_links"]];
                                     id parsedResponse = [self parseSource:source];
                                     
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                       if (success) {
                                         success(parsedResponse, pagination, links);
                                       }
                                       
                                       if (self.cachePolicy == CJAPIRequestReturnCacheDataThenLoad && [[AFNetworkReachabilityManager sharedManager] isReachable]) {
                                         if ([self willDeleteCached] && [self.retries integerValue] < kCJAPIRequestMaxRetries) {
                                           self.retries = @([self.retries intValue] + 1);
                                           [self performWithSuccess:success failure:failure];
                                         }
                                       }
                                     });
                                   });
                                   
                                 }
                                              failure:failure];
                               },
                               kRequestMethodPOST : ^{
                                 [self POSTWithSuccess:^(id operation, id responseObject) {
                                   if (success) {
                                     success(responseObject, nil, nil);
                                   }
                                 }
                                               failure:failure];
                               },
                               kRequestMethodPUT : ^{
                                 [self PUTWithSuccess:^(id operation, id responseObject) {
                                   if (success) {
                                     success(responseObject, nil, nil);
                                   }
                                 }
                                              failure:failure];
                               },
                               kRequestMethodDELETE : ^{
                                 [self DELETEWithSuccess:^(id operation, id responseObject) {
                                   if (success) {
                                     success(responseObject, nil, nil);
                                   }
                                 }
                                                 failure:failure];
                               }
                               }[self.method];
  
  selectedMethod();
}

- (void)GETWithSuccess:(void (^)(id operation, id responseObject))success
               failure:(CJFailureBlock)failure
{
  [self.sessionManager GET:self.path
                parameters:[self prepareParameters]
                   success:success
                   failure:^(id operation, NSError *error) {
                     [self processErrorWithTask:operation error:error block:failure];
                   }];
}

- (void)POSTWithSuccess:(void (^)(id operation, id responseObject))success
                failure:(CJFailureBlock)failure
{
  if ([self shouldSaveRequestForLater]) {
    [self saveRequestForLater];
    success(nil, nil);
    return;
  }
  
  [self.sessionManager POST:self.path
                 parameters:[self prepareParameters]
                    success:success
                    failure:^(id operation, NSError *error) {
                      [self processErrorWithTask:operation error:error block:failure];
                    }];
}

- (void)PUTWithSuccess:(void (^)(id operation, id responseObject))success
               failure:(CJFailureBlock)failure
{
  if ([self shouldSaveRequestForLater]) {
    [self saveRequestForLater];
    success(nil, nil);
    return;
  }
  
  [self.sessionManager PUT:self.path
                parameters:[self prepareParameters]
                   success:success
                   failure:^(id operation, NSError *error) {
                     [self processErrorWithTask:operation error:error block:failure];
                   }];
}

- (void)DELETEWithSuccess:(void (^)(id operation, id responseObject))success
                  failure:(CJFailureBlock)failure
{
  if ([self shouldSaveRequestForLater]) {
    [self saveRequestForLater];
    success(nil, nil);
    return;
  }
  
  [self.sessionManager DELETE:self.path
                   parameters:[self prepareParameters]
                      success:success
                      failure:^(id operation, NSError *error) {
                        [self processErrorWithTask:operation error:error block:failure];
                      }];
}

#pragma mark - Parameters
- (NSDictionary *)prepareParameters
{
  NSString *clientId = [CJEngine clientKey];
  NSString *accessToken = [CJEngine userToken];
  NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:self.parameters];
  
  if (clientId) {
    [parameters setObject:clientId
                   forKey:kRequestClientId];
  }
  
  if (accessToken) {
    [parameters setObject:accessToken
                   forKey:kRequestAccessToken];
  }
  
  if (_fields) {
    [parameters setObject:[_fields join:@","]
                   forKey:kRequestFields];
  }
  
  if (_embeds) {
    [parameters setObject:[_embeds join:@","]
                   forKey:kRequestEmbeds];
  }
  
  return parameters;
}

#pragma mark - Error handling
- (void)processErrorWithTask:(NSURLSessionDataTask *)task
                       error:(NSError *)error
                       block:(CJFailureBlock)block
{
  
  NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
  NSData *errorData = [[error userInfo] objectForKey:JSONResponseSerializerWithDataKey];
  
  NSDictionary *jsonError = @{};

  if (errorData) {
    NSError *parseError;
    jsonError = [NSJSONSerialization JSONObjectWithData:errorData
                                                options:kNilOptions
                                                  error:&parseError];
    unless(jsonError) jsonError = @{};    
  } else {
    jsonError = @{
                  @"developerMessage": [[error userInfo] objectForKey:@"NSLocalizedDescription"]
                  };
  }
  
  NSLog(@"%@", [self developerMessageFromResponse:response error:jsonError]);
  
  if (block) {
    block(jsonError, [NSNumber numberWithInteger:response.statusCode]);
  }
}

- (NSString *)developerMessageFromResponse:(NSHTTPURLResponse *)response
                                     error:(NSDictionary *)error
{
  NSString *message = [NSString stringWithFormat:@"%@ request to %@ returned an error with code %@: %@", self.method, self.path, [NSNumber numberWithInteger:response.statusCode], [error objectForKey:@"developerMessage"]];
  
  return message;
}

#pragma mark - Helpers
- (id)parseSource:(id)source
{
  if (_modelClass) {
    BOOL multiple = [source isKindOfClass:[NSArray class]];
    if (multiple) {
      NSArray *objects = [(NSArray *)source map:^id(id object) {
        return [self parseObject:object
                  withModelClass:_modelClass];
      }];
      
      return objects;
    } else {
      return [self parseObject:source
                withModelClass:_modelClass];
    }
    
  }
  
  return source;
}

- (id)parseObject:(id)object
   withModelClass:(id)modelClass
{
  id model = [_modelClass alloc];
  NSAssert([model respondsToSelector:@selector(initWithInfo:)], @"Model with class %@ must implement initWithInfo:", [_modelClass description]);
  
  return [model initWithInfo:object];
}

- (BOOL)willDeleteCached
{
  BOOL willDelete = NO;
  
  NSMutableURLRequest *request = [self.sessionManager.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:self.path relativeToURL:self.sessionManager.baseURL] absoluteString] parameters:[self prepareParameters] error:nil];
  
  NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
  
  if (cachedResponse) {
    willDelete = YES;
    
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
  }
  
  return willDelete;
}

- (BOOL)shouldSaveRequestForLater
{
  SEL queueSelector = NSSelectorFromString(@"persistentQueueController");
  BOOL hasSupport = [[CJEngine sharedEngine] respondsToSelector:queueSelector];
  BOOL isReachable = [AFNetworkReachabilityManager sharedManager].isReachable;
  
  return (hasSupport && !isReachable);
}

- (void)saveRequestForLater
{
  CJPersistentQueueController *queueController = [CJPersistentQueueController sharedController];
  [queueController.queue addObject:self];
}

@end
