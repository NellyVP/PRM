//
//  PRMTopViewController.h
//  PremierObjC
//
//  Created by Nilofar Vahab poor on 02/01/2018.
//  Copyright © 2018 Deliveroo. All rights reserved.
//

#import "PRMTopViewController.h"
#import "PRMServiceHandler.h"
#import "Reachability.h"

static const CGFloat kWarningHeight = 30.0f;

@interface PRMTopViewController ()
@property (nonatomic, strong) PRMServiceHandler* serviceHandler;
@property (nonatomic, strong) IBOutlet UIView* contentView;
@property (nonatomic, strong) IBOutlet UIView* warningView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* warningHeight;
@property (nonatomic, strong) IBOutlet UILabel* warningLabel;

@property (nonatomic, assign) BOOL controllerLoaded;
@property (nonatomic, assign) BOOL showingWarning;



@end

@implementation PRMTopViewController

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.controllerLoaded = YES;
    if (self.contentViewController) {
        [self addContentViewController:_contentViewController];
    }
    
    self.contentView.autoresizesSubviews = YES;    
    [self.view layoutSubviews];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _serviceHandler = [[PRMServiceHandler alloc] init];
    [self setConstraintsWithStatusOn:!self.serviceHandler.networkAccessible animated:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onConnectionNotification:)
                                                 name:PRMServiceConnectionChange
                                               object:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) setContentViewController:(UIViewController *)contentViewController {
    if (self.controllerLoaded && self.contentViewController) {
        [self removeContentViewController:_contentViewController];
    }
    _contentViewController = contentViewController;
    if (self.controllerLoaded) {
        [self addContentViewController:_contentViewController];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void) addContentViewController:(UIViewController*)viewController {
    [self addChildViewController:viewController];
    viewController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
}

- (void) removeContentViewController:(UIViewController*)viewController {
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
}

- (void) onConnectionNotification:(NSNotification*)notification {
    [self setConstraintsWithStatusOn:!self.serviceHandler.networkAccessible animated:YES];
}

- (void) setConstraintsWithStatusOn:(BOOL)on animated:(BOOL)animated {
    self.warningHeight.constant = 20.0f;
    if (on) {
        self.warningView.alpha = 1.0f;
        self.warningHeight.constant += kWarningHeight;
    }
    else {
        self.warningView.alpha = 0.0f;
    }
    if (!animated) {
        [self.view layoutIfNeeded];
        self.warningLabel.alpha = on ? 1.0f : 0.0f;
    }
    else {
        typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.1f
                              delay:0.5f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [weakSelf.view layoutIfNeeded];
                             weakSelf.warningLabel.alpha = on ? 1.0f : 0.0f;
                         }
                         completion:^(BOOL finished) {
                         }];
    }
}

@end
