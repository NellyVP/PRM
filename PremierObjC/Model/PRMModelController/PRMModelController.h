//
//  PRMModelController.h
//  PremierObjC
//
//  Created by Nilofar Vahab poor on 02/01/2018.
//  Copyright © 2018 Deliveroo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PRMModelController;
@class PRMServiceHandler;

extern NSString* PRMMovieImageBaseURL;


@protocol PRMModelControllerDelegate <NSObject>
- (void) controller:(PRMModelController*)controller searchEndedWithResults:(NSArray*)results;
@end


@interface PRMModelController : NSObject
@property (nonatomic, weak) id<PRMModelControllerDelegate> delegate;

@end
