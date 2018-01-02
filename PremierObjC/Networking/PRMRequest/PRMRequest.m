//
//  PRMRequest.m
//  PremierObjC
//
//  Created by Nilofar Vahab poor on 02/01/2018.
//  Copyright © 2018 Deliveroo. All rights reserved.
//


#import "PRMRequest.h"
#import <AFNetworking/AFHTTPSessionManager.h>

typedef void (^CompletionBlock)(PRMRequest* request, NSDictionary* info, NSError* error);

/* Retains a strong pointer to requests issued, until completion */
static NSMutableSet* outstandingRequests;

@interface PRMRequest() <NSURLConnectionDelegate>
@property (nonatomic, copy)   CompletionBlock  completion;
@property (nonatomic, strong) NSURL*           baseURL;
@property (nonatomic, strong) NSDictionary*    responseInfo;
@property (nonatomic, strong) NSError*         responseError;
@property (nonatomic, strong) AFHTTPSessionManager* requestManager;
@property (nonatomic, assign, readwrite) NSInteger responseCode;
@property (nonatomic, assign) BOOL fakeRequest;
@end

@implementation PRMRequest
- (void) dealloc {
    [self removeFromOutstanding];
}
- (instancetype) init {
    NSAssert(NO, @"Use initWithBaseURL:baseURL");
    return nil;
}

- (instancetype) initWithBaseURL:(NSURL*)baseURL{
    if (self = [super init]) {
        _baseURL = baseURL;
        _type = kCMRequestTypeNotIssued;
        _requestManager = [AFHTTPSessionManager manager];
        _requestManager.operationQueue.maxConcurrentOperationCount = 1;
        _fakeRequest = NO;
    }
    return self;
}

- (void) issueGET:(NSString*)url
     withJSONBody:(NSDictionary*)body
     onCompletion:(void (^)(PRMRequest* request, NSDictionary* info, NSError* error))completion {
    
    _relativeURL = url;
    _completion = completion;
    _type = kCMRequestTypeGET;
    _responseCode = 0;
    _fakeRequest = NO;
    
    [self addToOutstanding];
    [self prepareRequestManager];
    
    NSURL* absoluteURL = nil;
    if (![[_baseURL absoluteString] hasSuffix:@"/"] && ![_relativeURL hasPrefix:@"/"]) {
        absoluteURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [_baseURL absoluteURL], _relativeURL]];
    }
    else {
        absoluteURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [_baseURL absoluteURL], _relativeURL]];
    }
    typeof (self) __weak weakSelf = self;
    [_requestManager GET:[absoluteURL absoluteString] parameters:body progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        typeof(self) __strong strongSelf = weakSelf;
        
        if (responseObject) {
           // NSAssert([responseObject isKindOfClass:[NSDictionary class]], @"Unexpected object type");
        }
        [strongSelf updateResponseCodeForDataTask:task];
        strongSelf.responseInfo = responseObject;
        [strongSelf completeWithSuccess:responseObject];
        
    } failure:^(NSURLSessionTask * task, NSError * error) {
        typeof(self) __strong strongSelf = weakSelf;
        [strongSelf updateResponseCodeForDataTask:task];
        strongSelf.responseError = error;
        [strongSelf completeWithFailure:error];
    }];
}

- (void) issuePOST:(NSString*)url
      withJSONBody:(NSDictionary*)body
      onCompletion:(void (^)(PRMRequest* request, NSDictionary* info, NSError* error))completion {
    
    _relativeURL = url;
    _completion = completion;
    _type = kCMRequestTypePOST;
    _responseCode = 0;
    _fakeRequest = NO;
    
    [self addToOutstanding];
    [self prepareRequestManager];
    
    typeof (self) __weak weakSelf = self;
    
    [_requestManager POST:[[_baseURL absoluteString] stringByAppendingPathComponent:_relativeURL] parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        typeof(self) __strong strongSelf = weakSelf;
        if (responseObject) {
             NSAssert([responseObject isKindOfClass:[NSDictionary class]], @"Unexpected object type");
        }
        [strongSelf updateResponseCodeForDataTask:task];

        
        strongSelf.responseInfo = responseObject;
        [strongSelf completeWithSuccess:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        typeof(self) __strong strongSelf = weakSelf;
        [strongSelf updateResponseCodeForDataTask:task];

        strongSelf.responseError = error;
        [strongSelf completeWithFailure:error];
        
        
        
    }];
}

- (void) issuePUT:(NSString*)url
     withJSONBody:(NSDictionary*)body
     onCompletion:(void (^)(PRMRequest* request, NSDictionary* info, NSError* error))completion {
    
    _relativeURL = url;
    _completion = completion;
    _type = kCMRequestTypePUT;
    _responseCode = 0;
    _fakeRequest = NO;
    
    [self addToOutstanding];
    [self prepareRequestManager];
    
    typeof (self) __weak weakSelf = self;
    
    [_requestManager PUT:[[_baseURL absoluteString] stringByAppendingPathComponent:_relativeURL] parameters:body success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        typeof(self) __strong strongSelf = weakSelf;
        if (![(NSObject*)responseObject isKindOfClass:[NSDictionary class]]) {
            responseObject = nil;
        }
        [strongSelf updateResponseCodeForDataTask:task];
        strongSelf.responseInfo = responseObject;
        [strongSelf completeWithSuccess:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        typeof(self) __strong strongSelf = weakSelf;
        [strongSelf updateResponseCodeForDataTask:task];
        strongSelf.responseError = error;
        [strongSelf completeWithFailure:error];
        
    }];
    
}

- (void) issueDELETE:(NSString*)url
        withJSONBody:(NSDictionary*)body
        onCompletion:(void (^)(PRMRequest* request, NSDictionary* info, NSError* error))completion {
    
    _relativeURL = url;
    _completion = completion;
    _type = kCMRequestTypeDELETE;
    _responseCode = 0;
    _fakeRequest = NO;
    
    [self addToOutstanding];
    [self prepareRequestManager];
    
    typeof (self) __weak weakSelf = self;
    [_requestManager DELETE:[[_baseURL absoluteString] stringByAppendingPathComponent:_relativeURL] parameters:body success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        typeof(self) __strong strongSelf = weakSelf;
        if (responseObject) {
            NSAssert([responseObject isKindOfClass:[NSDictionary class]], @"Unexpected object type");
        }
        [strongSelf updateResponseCodeForDataTask:task];
        strongSelf.responseInfo = responseObject;
        [strongSelf completeWithSuccess:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        typeof(self) __strong strongSelf = weakSelf;
        [strongSelf updateResponseCodeForDataTask:task];
        strongSelf.responseError = error;
        [strongSelf completeWithFailure:error];
    }];
}

- (void) cancel {
    if (_fakeRequest) {
        _responseError = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:NSUserCancelledError
                                         userInfo:nil];
        _responseCode = 0;
        _responseInfo = nil;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(completeFakeRequest) withObject:nil afterDelay:0.01];
    }
    else {
        [_requestManager.operationQueue cancelAllOperations];
    }
    
    NSError* cancelError = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:nil];
    [self performSelector:@selector(completeWithFailure:) withObject:cancelError afterDelay:0.1];
}

#pragma mark Helper methods

- (void) addToOutstanding {
    //    NSAssert(![outstandingRequests containsObject:self], @"Trying to add a duplicate request!");
    if (!outstandingRequests) {
        outstandingRequests = [[NSMutableSet alloc] initWithCapacity:10]; // Why not 5??
    }
    if (![outstandingRequests containsObject:self]) {
        [outstandingRequests addObject:self];
    }
}

- (void) removeFromOutstanding {
    [outstandingRequests removeObject:self];
    if (outstandingRequests.count == 0) {
        outstandingRequests = nil;
    }
}

- (void) completeWithSuccess:(NSDictionary*)response {
    if (!_completion)
        return;
    _completion(self, response, nil);
    _completion = nil;
    [self removeFromOutstanding];
}

- (void) completeWithFailure:(NSError*)error {
    if([error code] == NSURLErrorCancelled) {
        return; // Ignore this error.
    }
    
    /*
     if timeout or 500 response.
     Send failure notification.
     */
    NSAssert(_responseError, @"Failing request with no error!");
    if (!_completion)
        return;
    if (_responseError.code != self.responseCode) {
        // Update the error.
        _responseError = [NSError errorWithDomain:_responseError.domain
                                             code:_responseCode
                                         userInfo:_responseError.userInfo];
    }
    _completion(self, nil, _responseError);
    _completion = nil;
    [self removeFromOutstanding];
}

- (void) updateResponseCodeForDataTask:(NSURLSessionTask*) task {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
    if ([httpResponse isKindOfClass:[NSHTTPURLResponse class]]) {
        self.responseCode = httpResponse.statusCode;
    }
    
}

- (void) prepareRequestManager {
    NSAssert(_baseURL, @"issueURLRequest - nil request");
    
    _requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    _requestManager.requestSerializer =  [AFJSONRequestSerializer serializer];
    [_requestManager.requestSerializer clearAuthorizationHeader];
    _requestManager.securityPolicy.allowInvalidCertificates = YES;
    _requestManager.securityPolicy.validatesDomainName = NO;
}

- (void) completeFakeRequest {
    if (_responseError)
        [self completeWithFailure:_responseError];
    else
        [self completeWithSuccess:_responseInfo];
}

@end


