//
//  UINavigationBar+PRMNavBarStyle.m
//  PremierObjC
//
//  Created by Nilofar Vahab poor on 03/01/2018.
//  Copyright © 2018 Deliveroo. All rights reserved.
//

#import "UINavigationBar+PRMNavBarStyle.h"

@implementation UINavigationBar (UINavigationBar_PRMNavBarStyle)

- (void) updateNavBarStyle {
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    self.layer.shadowRadius = 0.0;
    self.layer.shadowOpacity = 1.0;
}
@end

