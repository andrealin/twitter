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
    
    NSString *URLString = tweet.user.profilePictureURL;
    
    NSURL *URL = [NSURL URLWithString:URLString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    [cell.userImageView setImageWithURLRequest:request placeholderImage:nil
                                    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                        
                                        // imageResponse will be nil if the image is cached
                                        if (imageResponse) {
                                            NSLog(@"Image was NOT cached, fade in image");
                                            cell.userImageView.alpha = 0.0;
                                            cell.userImageView.image = image;
                                            
                                            //Animate UIImageView back to alpha 1 over 0.3sec
                                            [UIView animateWithDuration:0.3 animations:^{
                                                cell.userImageView.alpha = 1.0;
                                            }];
                                        }
                                        else {
                                            NSLog(@"Image was cached so just update the image");
                                            cell.userImageView.image = image;
                                        }
                                    }
                                    failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                                        // do something for the failure condition
                                    }];
    
    
    return cell;
}

@end
