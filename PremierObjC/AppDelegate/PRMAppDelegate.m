#import "PRMAppDelegate.h"
#import "PRMMoviesViewController.h"
#import "PRMTopViewController.h"
#import "UINavigationBar+PRMNavBarStyle.h"

static NSString* const kPRMTopViewController = @"PRMTopViewController";


@interface PRMAppDelegate ()

@end

@implementation PRMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    PRMMoviesViewController *moviesViewController = [[PRMMoviesViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:moviesViewController];
    navigationController.navigationBar.translucent = NO;
    [navigationController.navigationBar updateNavBarStyle];
    
    PRMTopViewController* baseViewController = [[PRMTopViewController alloc] initWithNibName:kPRMTopViewController bundle:nil];
    baseViewController.contentViewController = navigationController;
    
    self.window.rootViewController = baseViewController;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

@end
