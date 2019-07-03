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

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>

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
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Makes a network request to get updated data
// Updates the tableView with the new data
// Hides the RefreshControl
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
    // numberOfRows returns the number of items returned from the API
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // cellForRow returns an instance of the custom cell with that reuse identifier with its elements populated with data at the index asked for
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" ];
    
    Tweet *tweet = self.tweets[indexPath.row];
    
    cell.nameLabel.text = tweet.user.name;
    cell.usernameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    cell.tweetTextLabel.text = tweet.text;
    cell.dateLabel.text = tweet.createdAtString;
    [cell.retweetButton setTitle:[NSString stringWithFormat:@"%d", tweet.retweetCount] forState:UIControlStateNormal];
    [cell.favoriteButton setTitle:[NSString stringWithFormat:@"%d", tweet.favoriteCount] forState:UIControlStateNormal];
    
    NSString *URLString = tweet.user.profilePictureURL;
    
    NSURL *URL = [NSURL URLWithString:URLString];
    
    // make profile pic a circle
    CALayer *imageLayer = cell.userImageView.layer;
    [imageLayer setCornerRadius:cell.userImageView.frame.size.width/2];
    [imageLayer setMasksToBounds:YES];
    
    [cell.userImageView setImageWithURL:URL];
    
    return cell;
}

@end
