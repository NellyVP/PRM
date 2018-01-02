//
//  PRMServiceHandler.h
//  PremierObjC
//
//  Created by Nilofar Vahab poor on 02/01/2018.
//  Copyright © 2018 Deliveroo. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "PRMRequest.h"

extern NSString* PRMServiceConnectionChange;


@interface PRMServiceHandler : NSObject
@property (nonatomic, assign, readonly) BOOL active;
@property (nonatomic, assign, readonly) BOOL networkAccessible;
@property (nonatomic, assign, readonly) BOOL networkAccessibleLast;
@property (nonatomic, assign, readonly) BOOL serialisedURLList;


- (void) activate;
- (void) deactivate;
- (BOOL) networkAccessible;
- (BOOL) hostAccessible;


- (PRMRequest*) retrieveTopMoviesWithCompletion:(void (^)(NSDictionary* dict, NSError* error))completion;


@end
