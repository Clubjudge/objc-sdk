//
//  CJAPIRequest.h
//  CJAPIClient
//
//  Created by Bruno Abrantes on 16/04/14.
//  Copyright (c) 2014 Clubjudge. All rights reserved.
//

/**
 `CJAPIRequest` is the main request class for operations over the ClubJudge API. It supports GET, POST, PUT and DELETE HTTP operations.
 */

#import <Foundation/Foundation.h>
#import "CJEngine.h"
#import "CJPaginationInfo.h"
@class CJLinksInfo;

/**
 A block used for successful requests. It contains the response data (already parsed into models, if possible), pagination information and related resources information.
 */
typedef void (^CJSuccessBlock)(id response, CJPaginationInfo *pagination, CJLinksInfo *links);

/**
 A block used for failed requests. It contains the error returned by the API as well as the HTTP status code.
 */
typedef void (^CJFailureBlock)(NSDictionary* error, NSNumber *statusCode);

@interface CJAPIRequest : NSObject

/**
 The request method. Can be GET, POST, PUT or DELETE.
 */
@property (nonatomic, strong) NSString *method;

/**
 The relative request path, ie. `users/44`.
 */
@property (nonatomic, strong) NSString *path;

/**
 An array of model keys to be embedded in the response.
 */
@property (nonatomic, strong) NSArray *embeds;

/**
 An array of model keys to include in the response. All other keys are discarded.
 */
@property (nonatomic, strong) NSArray *fields;

/**
 A dictionary holding request parameters.
 */
@property (nonatomic, strong) NSDictionary *parameters;

/**
 The model class used to parse the response.
 */
@property (nonatomic, assign) Class modelClass;

/**
 The number of times the request has been performed. Useful when used in conjunction with the CJAPIRequestReturnCacheDataThenLoad cache policy.
 */
@property (nonatomic, strong) NSNumber *retries;

///---------------------
/// @name Initialization
///---------------------

#pragma mark - Initialisers
/**
 Creates and returns a `CJAPIRequest` object.
 */
- (instancetype)initWithMethod:(NSString *)method
                       andPath:(NSString *)path;

///---------------------
/// @name Actions
///---------------------
#pragma mark - Actions
/**
 Sends the request to the server. Executes a CJSuccessBlock if the request succeeds or a CJFailureBlock if it fails.
 */
- (void)performWithSuccess:(CJSuccessBlock)success
                   failure:(CJFailureBlock)failure;

#pragma mark - Parameters
/**
 Returns a dictionary of parameters that includes the client key and user token, if available.
 */
- (NSDictionary *)prepareParameters;

@end

#define kCJAPIRequestMaxRetries 1
