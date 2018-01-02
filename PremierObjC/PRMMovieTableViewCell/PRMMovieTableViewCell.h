//
//  PRMMovieTableViewCell.h
//  PremierObjC
//
//  Created by Nilofar Vahab poor on 02/01/2018.
//  Copyright © 2018 Deliveroo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PRMMovie;

@interface PRMMovieTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *movieImg;

- (void) configueWithitem:(PRMMovie*)movie;
- (void) updateImageViewWithImage:(UIImage*)image;
@end
