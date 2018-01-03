//
//  PRMMovie.m
//  PremierObjC
//
//  Created by Nilofar Vahab poor on 02/01/2018.
//  Copyright © 2018 Deliveroo. All rights reserved.
//

#import "PRMMovie.h"
@interface PRMMovie ()
@property (nonatomic, strong, readwrite) NSNumber* movieId;
@property (nonatomic, strong, readwrite) NSNumber* voteAverage;
@property (nonatomic, strong, readwrite) NSNumber* popularity;
@property (nonatomic, strong, readwrite) NSString* imgPath;
@property (nonatomic, strong, readwrite) NSString* movieTitle;
@property (nonatomic, strong, readwrite) NSString* overview;
@property (nonatomic, strong, readwrite) NSString* originalLanguage;
@property (nonatomic, strong, readwrite) NSNumber* voteCount;
@property (nonatomic, strong, readwrite) NSString* releaseDate;
@end

@implementation PRMMovie

- (instancetype) initWithId:(NSNumber*)mId
                    voteAvg:(NSNumber*)voteAverage
                 popularity:(NSNumber*)popularity
                        imgPath:(NSString*)imgPath
                      title:(NSString*)mTitle
                   overView:(NSString*)overview
                    orgLang:(NSString*)origLanguage
                      count:(NSNumber*)voteCount
                       date:(NSString*)releaseDate {
    
    if (self = [super init]) {
        self.movieId        = mId;
        self.voteAverage    = voteAverage;
        self.popularity     = popularity;
        self.imgPath        = imgPath;
        self.movieTitle     = mTitle;
        self.overview       = overview;
        self.voteCount      = voteCount;
        self.releaseDate    = releaseDate;
        self.originalLanguage = origLanguage;
    }
    
    return self;
}

@end
