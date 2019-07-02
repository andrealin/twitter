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

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tweets;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweets = tweets;
            NSLog(@"😎😎😎 Successfully loaded home timeline");
//            for (Tweet *dictionary in tweets) {
//////                NSLog(@"loop");
//                NSString *text = dictionary.text;
//                NSLog(@"%@", text);
////                NSLog(@"%@", dictionary);
//            }
            [self.tableView reloadData]; // forgot about this line!
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
    NSLog(@"number of rows function called");
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" ];
    
    Tweet *tweet = self.tweets[indexPath.row];
    
    cell.nameLabel.text = tweet.user.name;
    cell.usernameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    cell.tweetTextLabel.text = tweet.text;
    cell.dateLabel.text = tweet.createdAtString;
    [cell.retweetButton setTitle:[NSString stringWithFormat:@"Retweet: %d", tweet.retweetCount] forState:UIControlStateNormal];
    [cell.favoriteButton setTitle:[NSString stringWithFormat:@"Favorite: %d", tweet.favoriteCount] forState:UIControlStateNormal];
    
    return cell;
}

@end
