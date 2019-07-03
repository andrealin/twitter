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
    
    // Get timeline
    // Make an API request
    // APIManager calls the completion handler passing back data
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweets = tweets; // view controller stores data passed into the completion handler
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            [self.tableView reloadData]; // reload the table view. table view asks its dataSource for numberOfRows & cellForRowAt
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [cell.retweetButton setTitle:[NSString stringWithFormat:@"Retweet: %d", tweet.retweetCount] forState:UIControlStateNormal];
    [cell.favoriteButton setTitle:[NSString stringWithFormat:@"Favorite: %d", tweet.favoriteCount] forState:UIControlStateNormal];
    
    NSString *URLString = tweet.user.profilePictureURL;
    
    NSURL *URL = [NSURL URLWithString:URLString];
    
    [cell.userImageView setImageWithURL:URL];
    
    return cell;
}

@end
