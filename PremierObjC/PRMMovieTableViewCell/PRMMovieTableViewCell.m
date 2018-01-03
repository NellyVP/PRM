//
//  PRMMovieTableViewCell.m
//  PremierObjC
//
//  Created by Nilofar Vahab poor on 02/01/2018.
//  Copyright © 2018 Deliveroo. All rights reserved.
//

#import "PRMMovieTableViewCell.h"
#import "PRMMovie.h"
#import "UIKit+PRMStyles.h"

@interface PRMMovieTableViewCell()
@property (nonatomic, weak) IBOutlet UILabel *movieTitle;
@property (nonatomic, weak) IBOutlet UILabel *movieOverview;
@property (nonatomic, weak) IBOutlet UILabel *movieRating;
@property (nonatomic, weak) IBOutlet UILabel *movieReleaseDate;


@end
@implementation PRMMovieTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) configureDisplay {
    self.movieTitle.font    = [UIFont titleFont];
    self.movieRating.font   = [UIFont bodyFont];
    self.movieOverview.font = [UIFont bodyFont];
    self.movieReleaseDate.font = [UIFont bodyFont];

    self.movieTitle.textColor       = [UIColor titleTextColor];
    self.movieOverview.textColor    = [UIColor bodyTextColor];
    self.movieRating.textColor      = [UIColor bodyTextColor];
    self.movieReleaseDate.textColor = [UIColor bodyTextColor];
}

- (void) configueWithitem:(PRMMovie*)movie {
    self.movieTitle.text        = movie.movieTitle;
    self.movieOverview.text     = movie.overview;
    self.movieRating.text       = [NSString stringWithFormat:@"Rating: %@", movie.voteAverage.stringValue];
    self.movieReleaseDate.text  = [NSString stringWithFormat:@"Release Date: %@", movie.releaseDate];
}


@end
