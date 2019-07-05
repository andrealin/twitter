//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView; // view controller has a tableView as a subview
@property (nonatomic, strong) NSArray<Tweet *> *tweets; // view controller stores data passed into the completion handler

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // view controller becomes its dataSource and delegate in viewDidLoad
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // initial load of data
    [self fetchData];
    
    // refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
}

// Makes a network request to get updated data
// Updates the tableView with the new data
- (void) fetchData {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweets = tweets; // view controller stores data passed into the completion handler
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            
            // Reload the tableView now that there is new data
            [self.tableView reloadData]; // reload the table view. table view asks its dataSource for numberOfRows & cellForRowAt
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Does everything that self.fetchData does an also hides the RefreshControl
- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    
    // Get timeline
    // Make an API request
    // APIManager calls the completion handler passing back data
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweets = tweets; // view controller stores data passed into the completion handler
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            
            // Reload the tableView now that there is new data
            [self.tableView reloadData]; // reload the table view. table view asks its dataSource for numberOfRows & cellForRowAt
            
            // Tell the refreshControl to stop spinning
            [refreshControl endRefreshing];
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count; // numberOfRows returns the number of items returned from the API
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // cellForRow returns an instance of the custom cell with that reuse identifier with its elements populated with data at the index asked for
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" ]; // get the cell view at the index
    
    Tweet *tweet = self.tweets[indexPath.row]; // get the tweet model at the index
    
    cell.tweet = tweet;
    
    cell.delegate = self;
    
    [cell refreshData]; // refresh the UI based on the tweet data
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"profileSegue" isEqualToString:segue.identifier]) { // profile view controller
        // help me
        UINavigationController *navigationController = [segue destinationViewController];
        ProfileViewController *profileController = (ProfileViewController*)navigationController.topViewController;
        profileController.user = sender;
    }
    else if ([[segue destinationViewController] isKindOfClass:[UINavigationController class]]){ // compose tweet controller
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
}

- (void)didTweet:(Tweet *)tweet {
    [self fetchData]; // so that we can see the new tweet I just made on the home timeline
}

- (IBAction)logoutClicked:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user{
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}

@end
