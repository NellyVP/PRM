//
//  PRMMovie.h
//  PremierObjC
//
//  Created by Nilofar Vahab poor on 02/01/2018.
//  Copyright © 2018 Deliveroo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PRMMovie : NSObject
@property (nonatomic, strong, readonly) NSNumber* movieId;
@property (nonatomic, strong, readonly) NSNumber* voteAverage;
@property (nonatomic, strong, readonly) NSNumber* popularity;
@property (nonatomic, strong, readonly) NSString* imgPath;
@property (nonatomic, strong, readonly) NSString* movieTitle;
@property (nonatomic, strong, readonly) NSString* overview;
@property (nonatomic, strong, readonly) NSString* originalLanguage;
@property (nonatomic, strong, readonly) NSNumber* voteCount;
@property (nonatomic, strong, readonly) NSString* releaseDate;


- (instancetype) initWithId:(NSNumber*)mId
                    voteAvg:(NSNumber*)voteAverage
                 popularity:(NSNumber*)popularity
                        imgPath:(NSString*)imgPath
                      title:(NSString*)mTitle
                   overView:(NSString*)overview
                    orgLang:(NSString*)origLanguage
                      count:(NSNumber*)voteCount
                       date:(NSString*)releaseDate;



@end
