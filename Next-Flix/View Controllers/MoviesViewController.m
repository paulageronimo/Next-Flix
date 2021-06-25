//
//  MoviesViewController.m
//  Next-Flix
//
//  Created by Paula Leticia Geronimo on 6/25/21.
//

// create outlet to table view
// implement the two interfaces needed
// told table view that the data souce is the main reference, obj passing
// implemented two data source methods
// created & config a cell
// // // // // // // // formula for table view uwu

// aspect fit/fill is better than scale to fit.
// if aspect fill, clip to bounds [x]


#import "MoviesViewController.h"
#import "MovieCell.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate> // implementing a protocal is a promise to find inside...
// DataSource: two required components (rows/section and data path)
// Delegate: no required

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies; // property, bc it is a thing... duh.... + type and name; getter and setter array
// nonatomic, strong, defines the getter and setter
@property (nonatomic, strong) UIRefreshControl *refreshControl; // established variable
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MoviesViewController // warning

- (void)viewDidLoad {
    // Start the activity indicator
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self; // setting it to the view controller
    self.tableView.delegate = self; // expecting it
    
    [self fetchMovies];
    
    // setting up refresh control
    
    self.refreshControl = [[UIRefreshControl alloc] init]; // not attached to anything yet
    // [self.tableView addSubview:self.refreshControl]; // create nested structure, inserted at any place in the "z level"
    // once triggered, where does it go? hmm
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged]; // under the hood, target action pair, calling a particular method
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self.tableView addSubview:self.refreshControl];
    
}
-(void)fetchMovies {
    [self.activityIndicator startAnimating];

    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=1901d344fe219bef0495b3e27f38a318"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
                // could show error view
            }
            else {
                
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"%@", dataDictionary);
                //NSArray *movies = dataDictionary[@"results"];
                
                self.movies = dataDictionary[@"results"]; // instead of saving it locally, it will be an instace property ready for table view
                for (NSDictionary *movie in self.movies) {
                    NSLog(@"%@", movie[@"title"]); // @ @ @ @ @ @
                }
                
                [self.tableView reloadData]; // says "hey call the data source methods bc movies might have changed"
                
                // TODO: Get the array of movies
                // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data
            }
        [self.refreshControl endRefreshing];
        // Stop the activity indicator
        // Hides automatically if "Hides When Stopped" is enabled
        [self.activityIndicator stopAnimating];
        
        }];
    [task resume]; // forgot to add this.. idk why but it fixed a bug.
}
// - is instace method

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count; // instead of 20, called on startup, then not called again??
    // after recieving network request back, add the line [55] for the reload data
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [[UITableViewCell alloc] init];
    // in obj c, objs are contrs in a diff way. nameOfClass() -> but []
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
// previous formatting:
    //    NSLog(@"%@", [NSString stringWithFormat:@"row:%d, section %d", indexPath.row, indexPath.section]);
//    cell.textLabel.text = [NSString stringWithFormat:@"row:%d, section %d", indexPath.row, indexPath.section];
    //NSLog: outputs within the log box...
    //cell.textLabel.text = movie[@"title"];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    // glue the above together :)
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString]; // same as a string, but it checks to see if it is a valid URL
    cell.posterView.image = nil; // blanks cell before downloading new one
    [cell.posterView setImageWithURL:posterURL];
    return cell;
}

//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    // "hey table view, I have this cell of yours. Can you tell me the index path? pls n ty"
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    
    DetailsViewController *detailViewController = [segue destinationViewController];
    detailViewController.movie = movie;
    
    // "hey we're about to leave, do you want to give us anything?"
    // "sure, here's the movie I last selected"
    // NSLog(@"Tapping on a movie!");
    // sender: obj that triggered the event
    
}


@end
