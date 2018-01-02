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
NSString* baseImageURLPath              = @"https://image.tmdb.org/t/p/original";


@interface PRMModelController () {
    NSCache *imagesCache;
}

@property (nonatomic, weak) PRMRequest* outstandingRequest;
@property (nonatomic, strong) PRMServiceHandler *serviceHandler;


@end
@implementation PRMModelController


- (void) dealloc {
    // Cancel any outstanding requests.
    [self.outstandingRequest cancel];
}

- (instancetype) init {
    _serviceHandler = [[PRMServiceHandler alloc] init];
    [_serviceHandler activate];
    imagesCache = [[NSCache alloc] init];
    [self getListOfTopMovies];
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
        
        if (error) {
            NSLog(@"refreshConferenceSession error received: %@", error);
        }
        else {
            NSArray *arrayOfMovies = [PRMModelFactory moviesArrayFromDictionary:dict];
            [strongSelf informDownloadCompletedWithResults:arrayOfMovies];
        }
    }];
    self.outstandingRequest.userIdentifier = kRequestGetTopMovies;
}

- (NSData*) getImageDataFromPath:(NSString*)imgPath {
    NSData *imageData = [imagesCache objectForKey:imgPath];

    NSString* newURL = [NSString stringWithFormat:@"%@%@",baseImageURLPath, imgPath];
    NSError* error = nil;
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:newURL] options:NSDataReadingUncached error:&error];

    return data;
}
- (void) getImageDataFromPath:(NSString*)path withCompletion:(void (^)(NSData* data, NSError* error))completion {
    NSData *imageData = [imagesCache objectForKey:path];
    if (!imageData) {
        NSString* newURL = [NSString stringWithFormat:@"%@%@",baseImageURLPath, path];
        NSError* error = nil;
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:newURL] options:NSDataReadingUncached error:&error];
        [imagesCache setObject:data forKey:path];
        if (completion) {
            completion(data, error);
        }
    }
    completion(imageData, nil);
}
#pragma mark Internal helper methods
- (void) informDownloadCompletedWithResults:(NSArray*)results {
    if ([self.delegate respondsToSelector:@selector(controller:searchEndedWithResults:)]) {
        [self.delegate controller:self searchEndedWithResults:results];
    }
}

- (void) cancelAnyRefresh {
    if ([self.outstandingRequest.userIdentifier isEqualToString:kRequestGetTopMovies]) {
        [self.outstandingRequest cancel];
        self.outstandingRequest = nil;
    }
}


@end
