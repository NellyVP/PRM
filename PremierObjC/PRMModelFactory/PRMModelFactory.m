//
//  PRMModelFactory.m
//  PremierObjC
//
//  Created by Nilofar Vahab poor on 02/01/2018.
//  Copyright © 2018 Deliveroo. All rights reserved.
//

#import "PRMModelFactory.h"
#import "PRMMovie.h"



@implementation PRMModelFactory

+ (NSArray*) moviesArrayFromDictionary:(NSDictionary*)dict {
    NSAssert(dict, @"No dictionary supplied");
    NSMutableArray *arrayOfMovies = [[NSMutableArray alloc] initWithCapacity:dict.count];
    NSArray *moviesList = [dict objectForKey:@"results"];
    for (NSDictionary *entry in moviesList) {
        id value = [entry objectForKey:@"id"];
        NSNumber* movieId = [value isKindOfClass:[NSNumber class]] ? value : nil;
        
        value = [entry objectForKey:@"title"];
        NSString* title =  [value isKindOfClass:[NSString class]] ? value : nil;
        
        value = [entry objectForKey:@"vote_average"];
        NSNumber *avr_vote = [value isKindOfClass:[NSNumber class]] ? value : @"N/A";
        
        value = [entry objectForKey:@"popularity"];
        NSNumber* popularity = [value isKindOfClass:[NSNumber class]] ? value : nil;
        
        value = [entry objectForKey:@"poster_path"];
        UIImage *movieImage = nil;
        NSString* imgPath =  [value isKindOfClass:[NSString class]] ? value : nil;
        if (imgPath.length) {
            //movieImage = [[self class] imageFromPath:urlPath];
        }
        
        value = [entry objectForKey:@"release_date"];
        NSString* dateTimeString =  [value isKindOfClass:[NSString class]] ? value : @"N/A";

        NSString* language = nil;
        value = [entry objectForKey:@"original_language"];
        if ([value isKindOfClass:[NSString class]]) {
            NSAssert([value isKindOfClass:[NSString class]], @"id wrong type");
            NSString* languageCode = (NSString*)value;
            language = [[self class] languageNameForCode:languageCode];
        }
        
        value = [entry objectForKey:@"vote_count"];
        NSNumber* voteCount = [value isKindOfClass:[NSNumber class]] ? value : nil;
        
        value = [entry objectForKey:@"overview"];
        NSString *overview = [value isKindOfClass:[NSString class]] ? value : @"N/A";
        
        PRMMovie *topMoview = [[PRMMovie alloc] initWithId:movieId voteAvg:avr_vote popularity:popularity imgPath:imgPath title:title overView:overview orgLang:language count:voteCount date:dateTimeString];
        if (topMoview) {
            [arrayOfMovies addObject:topMoview];
        }
    }
    
    return arrayOfMovies;
}

+ (NSString*) languageNameForCode:(NSString*)code {
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    return [locale displayNameForKey:NSLocaleIdentifier value:code];
}

//+ (UIImage*) imageFromPath:(NSString*)imgPath {
//    NSString* newURL = [NSString stringWithFormat:@"%@%@",baseImageURLPath, imgPath];
//    NSError* error = nil;
//    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:newURL] options:NSDataReadingUncached error:&error];
//    return [UIImage imageWithData:data];
//}
@end
