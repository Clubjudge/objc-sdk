//
//  CJAPIRequest.m
//  CJAPIClient
//
//  Created by Bruno Abrantes on 16/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

#import "CJAPIRequest.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "CJLinksInfo.h"

NSString *const kRequestMethodGET = @"GET";
NSString *const kRequestMethodPOST = @"POST";
NSString *const kRequestMethodPUT = @"PUT";
NSString *const kRequestMethodDELETE = @"DELETE";
NSString *const kRequestPathPrefix = @"/";

NSString *const kRequestClientId = @"clientId";
NSString *const kRequestAccessToken = @"token";

@interface CJAPIRequest()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

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
  
  NSAssert([methods containsObject:method], @"%@ is not a supported method", method);
  
  _method = method;
}

- (void)setPath:(NSString *)path
{
  unless([path hasPrefix:kRequestPathPrefix]) {
    path = [kRequestPathPrefix stringByAppendingString:path];
  }
  
  path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
  _path = path;
}

#pragma mark - Actions

- (void)performWithSuccess:(void (^)(id response, CJPaginationInfo *pagination, CJLinksInfo *links))success
                   failure:(CJFailureBlock)failure
{
  void (^selectedMethod)() = @{
                               kRequestMethodGET : ^{
                                 [self GETWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
                                   NSString *sourceKey = [[[responseObject allKeys] reject:^BOOL(id object) {
                                     return [(NSString *)object hasPrefix:@"_"];
                                   }] first];
                                   
                                   NSDictionary *source = [responseObject objectForKey:sourceKey];
                                   
                                   CJPaginationInfo *pagination = [[CJPaginationInfo alloc] initWithInfo:responseObject[@"_pagination"]];
                                   CJLinksInfo *links = [[CJLinksInfo alloc] initWithInfo:responseObject[@"_links"]];
                                   
                                   success([self parseSource:source], pagination, links);
                                   
                                 }
                                              failure:failure];
                               },
                               kRequestMethodPOST : ^{
                                 [self POSTWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
                                   success(responseObject, nil, nil);
                                 }
                                               failure:failure];
                               },
                               kRequestMethodPUT : ^{
                                 [self PUTWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
                                   success(responseObject, nil, nil);
                                 }
                                              failure:failure];
                               },
                               kRequestMethodDELETE : ^{
                                 [self DELETEWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
                                   success(responseObject, nil, nil);
                                 }
                                                 failure:failure];
                               }
                               }[self.method];
  
  selectedMethod();
}

- (void)GETWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
               failure:(CJFailureBlock)failure
{
  [self.sessionManager GET:self.path
                parameters:[self prepareParameters]
                   success:success
                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                     [self processErrorWithTask:task error:error block:failure];
                   }];
}

- (void)POSTWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(CJFailureBlock)failure
{
  [self.sessionManager POST:self.path
                 parameters:[self prepareParameters]
                    success:success
                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                      [self processErrorWithTask:task error:error block:failure];
                    }];
}

- (void)PUTWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
               failure:(CJFailureBlock)failure
{
  [self.sessionManager PUT:self.path
                parameters:[self prepareParameters]
                   success:success
                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                     [self processErrorWithTask:task error:error block:failure];
                   }];
}

- (void)DELETEWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                  failure:(CJFailureBlock)failure
{
  [self.sessionManager DELETE:self.path
                   parameters:[self prepareParameters]
                      success:success
                      failure:^(NSURLSessionDataTask *task, NSError *error) {
                        [self processErrorWithTask:task error:error block:failure];
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
    
  } else {
    jsonError = @{
                  @"developerMessage": [[error userInfo] objectForKey:@"NSLocalizedDescription"]
                  };
  }
  
  NSLog(@"%@", [self developerMessageFromResponse:response error:jsonError]);
  
  if (block) {
    block(jsonError, [NSNumber numberWithInt:response.statusCode]);
  }
}

- (NSString *)developerMessageFromResponse:(NSHTTPURLResponse *)response
                                     error:(NSDictionary *)error
{
  NSString *message = [NSString stringWithFormat:@"%@ request to %@ returned an error with code %d: %@", self.method, self.path, response.statusCode, [error objectForKey:@"developerMessage"]];
  
  return message;
}

#pragma mark - Helpers
- (id)parseSource:(id)source
{
  if (_modelClass) {
    id model = [_modelClass alloc];
    
    NSAssert([model respondsToSelector:@selector(initWithInfo:)], @"Model with class %@ must implement initWithInfo:", [_modelClass description]);
    
    BOOL multiple = [source isKindOfClass:[NSArray class]];
    
    if (multiple) {
      NSArray *objects = [(NSArray *)source map:^id(id object) {
        return [model initWithInfo:object];
      }];
      
      return objects;
    } else {
      model = [model initWithInfo:source];
      return model;
    }
    
  }
  
  return source;
}

@end
