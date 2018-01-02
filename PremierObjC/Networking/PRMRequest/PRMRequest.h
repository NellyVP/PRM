//
//  PRMRequest.h
//  PremierObjC
//
//  Created by Nilofar Vahab poor on 02/01/2018.
//  Copyright © 2018 Deliveroo. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CMRequestType) {
    kCMRequestTypeNotIssued = 0,
    kCMRequestTypeGET,
    kCMRequestTypePOST,
    kCMRequestTypePUT,
    kCMRequestTypeDELETE
};

@interface PRMRequest : NSObject
@property (nonatomic, strong, readonly) NSString*          relativeURL;
@property (nonatomic, assign, readonly) NSInteger          responseCode;
@property (nonatomic, strong, readonly) NSDictionary*      responseInfo;
@property (nonatomic, strong, readonly) NSError*           responseError;
@property (nonatomic, assign, readonly) CMRequestType  type;
@property (nonatomic, assign)           NSString*          userIdentifier;


- (instancetype) initWithBaseURL:(NSURL*)baseURL;

- (void) issueGET:(NSString*)relativeURL
     withJSONBody:(NSDictionary*)body
     onCompletion:(void (^)(PRMRequest* request, NSDictionary* info, NSError* error))completion;

- (void) issuePOST:(NSString*)relativeURL
      withJSONBody:(NSDictionary*)body
      onCompletion:(void (^)(PRMRequest* request, NSDictionary* info, NSError* error))completion;

- (void) issuePUT:(NSString*)relativeURL
     withJSONBody:(NSDictionary*)body
     onCompletion:(void (^)(PRMRequest* request, NSDictionary* info, NSError* error))completion;

- (void) issueDELETE:(NSString*)relativeURL
        withJSONBody:(NSDictionary*)body
        onCompletion:(void (^)(PRMRequest* request, NSDictionary* info, NSError* error))completion;

- (void) cancel;

@end
