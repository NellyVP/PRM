//
//  PRMModelController.m
//  PremierObjC
//
//  Created by Nilofar Vahab poor on 02/01/2018.
//  Copyright © 2018 Deliveroo. All rights reserved.
//

#import "PRMModelController.h"
#import "PRMRequest.h"
#import "PRMServiceHandler.h"
#import "PRMModelFactory.h"

static NSString* kRequestGetTopMovies   = @"RequestTopMovies";
NSString* PRMMovieImageBaseURL          = @"https://image.tmdb.org/t/p/original";


@interface PRMModelController ()
@property (nonatomic, weak) PRMRequest* outstandingRequest;
@property (nonatomic, strong) PRMServiceHandler *serviceHandler;


@end
@implementation PRMModelController


- (void) dealloc {
    // Cancel any outstanding requests.
    [self.outstandingRequest cancel];
}

- (instancetype) init {
    if (self = [super init]) {
        _serviceHandler = [[PRMServiceHandler alloc] init];
        [_serviceHandler activate];
        [self getListOfTopMovies];
    }
    return self;
}

- (void) getListOfTopMovies {
    NSAssert(_serviceHandler, @"No service handler on refresh");
    if ([self.outstandingRequest.userIdentifier isEqualToString:kRequestGetTopMovies]) {
        return;
    }
    
    typeof(self) __weak weakSelf = self;
    self.outstandingRequest = [_serviceHandler retrieveTopMoviesWithCompletion:^(NSDictionary *dict, NSError *error) {
        typeof(self) __strong strongSelf = weakSelf;
        
        if ([strongSelf.outstandingRequest.userIdentifier isEqualToString:kRequestGetTopMovies]) {
            strongSelf.outstandingRequest = nil;
        }
        NSArray *arrayOfMovies = [PRMModelFactory moviesArrayFromDictionary:dict];
        [strongSelf informDownloadCompletedWithResults:arrayOfMovies andError:error];
    }];
    self.outstandingRequest.userIdentifier = kRequestGetTopMovies;
}

#pragma mark Internal helper methods
- (void) informDownloadCompletedWithResults:(NSArray*)results andError:(NSError*)error{
    if ([self.delegate respondsToSelector:@selector(controller:searchEndedWithResults:andError:)]) {
        [self.delegate controller:self searchEndedWithResults:results andError:error];
    }
}

- (void) cancelAnyRefresh {
    if ([self.outstandingRequest.userIdentifier isEqualToString:kRequestGetTopMovies]) {
        [self.outstandingRequest cancel];
        self.outstandingRequest = nil;
    }
}


@end
