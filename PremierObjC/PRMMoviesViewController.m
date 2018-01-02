#import "PRMMoviesViewController.h"
#import "PRMModelController.h"
#import "PRMMovieTableViewCell.h"
#import "PRMMovie.h"
#import "MBProgressHUD.h"

@interface PRMMoviesViewController () <PRMModelControllerDelegate>
@property (nonatomic, strong) PRMModelController *controller;

@property (nonatomic, copy) NSArray *movies;

@end

@implementation PRMMoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Top Movies";
    [self.tableView registerNib:[UINib nibWithNibName:@"PRMMovieTableViewCell" bundle:nil] forCellReuseIdentifier:@"PRMMovieTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.controller = [[PRMModelController alloc] init];
    self.controller.delegate = self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PRMMovieTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:@"PRMMovieTableViewCell" forIndexPath:indexPath];
    PRMMovie *movie = self.movies[indexPath.row];
    [tableCell configueWithitem:movie];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSData *imgData = [self.controller getImageDataFromPath:movie.imgPath];
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            [tableCell updateImageViewWithImage:[UIImage imageWithData:imgData]];
//        });
//    });
    return tableCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[PRMMovieTableViewCell class]] ) {
        PRMMovieTableViewCell *tableCell = (PRMMovieTableViewCell*)cell;
        PRMMovie *movie = self.movies[indexPath.row];
        [tableCell configueWithitem:movie];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imgData = [self.controller getImageDataFromPath:movie.imgPath];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [tableCell updateImageViewWithImage:[UIImage imageWithData:imgData]];
            });
        });
    }
}

- (void)controller:(PRMModelController *)controller searchEndedWithResults:(NSArray *)results {
    self.movies = results;
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}


@end
