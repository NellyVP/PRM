//
//  PRMServiceHandler.m
//  PremierObjC
//
//  Created by Nilofar Vahab poor on 02/01/2018.
//  Copyright © 2018 Deliveroo. All rights reserved.
//


#import "PRMServiceHandler.h"
#import <AFNetworking/AFNetworking.h>
#import "PRMAppDelegate.h"
#import "PRMServiceHandler.h"
#import "PRMRequest.h"
#import "Reachability.h"
#import "PRMModelFactory.h"


static NSString* const PRMRequestInsecureProtocol    = @"http://";
static NSString* const PRMRequestProtocol            = @"https://";
static NSString* const PRMRequestBaseURL             = @"api.themoviedb.org";
static NSString* const PRMRequestTopMovies           = @"/3/movie/top_rated?api_key=";
static NSString* const PRMAPIKey                     = @"e4f9e61f6ffd66639d33d3dde7e3159b";

NSString* PRMServiceConnectionChange      = @"PRMServiceConnectionChange";
NSString* PRMServiceImagesBaseURL         = @"https://image.tmdb.org/t/p/original";

//@"https://api.themoviedb.org/3/movie/top_rated?api_key=e4f9e61f6ffd66639d33d3dde7e3159b"


@interface PRMServiceHandler()
@property (nonatomic, assign) BOOL active;
@property (nonatomic, strong, readwrite) NSString* adHocNumber;

@property (nonatomic, strong) Reachability* tcpipReachability;
@property (nonatomic, strong) Reachability* hostReachability;

@property (nonatomic, assign) BOOL useOperatorBearer;
@property (nonatomic, assign, readwrite) BOOL networkAccessible;
@property (nonatomic, assign, readwrite) BOOL networkAccessibleLast;

@end

@implementation PRMServiceHandler

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype) init {
    if (self = [super init]) {
        _active = NO;
        _useOperatorBearer = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        _tcpipReachability = [Reachability reachabilityForInternetConnection];
        self.networkAccessible = (self.tcpipReachability.currentReachabilityStatus != NotReachable);
    }
    return self;
}


#pragma mark Matrix product services

- (void) activate {
    NSAssert(!_active, @"Attempting to activate when already activated");
    
    [self deactivate];
    [_tcpipReachability startNotifier];
    
    _hostReachability = [Reachability reachabilityWithHostName:[NSString stringWithFormat:@"%@%@", PRMRequestProtocol, PRMRequestBaseURL]];
    [_hostReachability startNotifier];
    
    _active = YES;
}

- (void) deactivate {
    [_tcpipReachability stopNotifier];
    [_hostReachability  stopNotifier];
    
    _hostReachability = nil;
    
    _active = NO;
}
- (PRMRequest*) retrieveTopMoviesWithCompletion:(void (^)(NSDictionary* dict, NSError* error))completion {
    NSAssert(_active, @"Attempting requests before activated");
    
    NSURL* baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PRMRequestProtocol, PRMRequestBaseURL]];
    PRMRequest* configRequest = [[PRMRequest alloc] initWithBaseURL:baseURL];
    
    typeof(self) __weak weakSelf = self;
    
    [configRequest issueGET:[[NSString stringWithFormat:@"%@%@", PRMRequestTopMovies, PRMAPIKey]
                             stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]
               withJSONBody:nil
               onCompletion:^(PRMRequest* request, NSDictionary* info, NSError* error) {
                   typeof(self) __strong strongSelf = weakSelf;
                   [strongSelf handleRequestResponse:request ignoreAuth:YES];
                   if (completion) {
                       completion(info, error);
                   }
               }];
    return configRequest;
}

- (BOOL) hostAccessible {
    if (!_useOperatorBearer) {
        return (_hostReachability.currentReachabilityStatus == ReachableViaWiFi);
    }
    return (_hostReachability.currentReachabilityStatus != NotReachable);
}

- (void) reachabilityChanged:(NSNotification*) notification {
    self.networkAccessibleLast = self.networkAccessible;
    switch (_tcpipReachability.currentReachabilityStatus) {
        case ReachableViaWiFi:
            self.networkAccessible = (self.tcpipReachability.currentReachabilityStatus != NotReachable);
            break;
        case ReachableViaWWAN:
            self.networkAccessible = self.useOperatorBearer;
            break;
            
        case NotReachable:
        default:
            self.networkAccessible = NO;
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PRMServiceConnectionChange object:[NSNumber numberWithInteger:_tcpipReachability.currentReachabilityStatus]];

}

- (void) handleRequestResponse:(PRMRequest*)request ignoreAuth:(BOOL)ignore {
    if (request.responseCode / 100 == 5) {
        // Oops. Server error. Mark unreachable.
        
    }
    
}
@end
