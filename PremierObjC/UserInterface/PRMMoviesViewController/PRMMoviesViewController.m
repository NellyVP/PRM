#import "PRMMoviesViewController.h"
#import "PRMModelController.h"
#import "PRMMovieTableViewCell.h"
#import "PRMMovie.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"

static NSString* const kPRMMovieTableViewCell        = @"PRMMovieTableViewCell";

@interface PRMMoviesViewController () <PRMModelControllerDelegate>
@property (nonatomic, strong) PRMModelController *controller;
@property (nonatomic, strong) MBProgressHUD* firstRefreshHUD;
@property (nonatomic, copy) NSArray *movies;

@end

@implementation PRMMoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Top Movies";
    [self.tableView registerNib:[UINib nibWithNibName:kPRMMovieTableViewCell bundle:nil] forCellReuseIdentifier:kPRMMovieTableViewCell];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    self.tableView.tableFooterView = [[UIView alloc]
                                      initWithFrame:CGRectZero];
    
    self.firstRefreshHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.firstRefreshHUD.mode = MBProgressHUDModeIndeterminate;
    
    self.controller = [[PRMModelController alloc] init];
    self.controller.delegate = self;
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.firstRefreshHUD hideAnimated:YES];
    self.firstRefreshHUD = nil;
    self.controller.delegate = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PRMMovieTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:kPRMMovieTableViewCell forIndexPath:indexPath];
    PRMMovie *movie = self.movies[indexPath.row];
    [tableCell configueWithitem:movie];
    [tableCell.movieImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PRMMovieImageBaseURL, movie.imgPath]] placeholderImage:[UIImage imageNamed:@"topmovie.png"]];

    return tableCell;
}

- (void)controller:(PRMModelController *)controller searchEndedWithResults:(NSArray *)results {
    self.movies = results;
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [self.firstRefreshHUD hideAnimated:YES];
    self.firstRefreshHUD = nil;
}


@end
