#import "UIKit+PRMStyles.h"

@implementation UIColor (PRMStyles)

+ (UIColor *)titleTextColor {
    return self.darkGrayColor;
}

+ (UIColor *)bodyTextColor {
    return self.grayColor;
}

@end

@implementation UIFont (PRMStyles)

+ (UIFont *)titleFont {
    return [self preferredFontForTextStyle:UIFontTextStyleTitle1];
}

+ (UIFont *)bodyFont {
    return [self preferredFontForTextStyle:UIFontTextStyleBody];
}

@end
