//
//  TweetCell.m
//  twitter
//
//  Created by drealin on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // user image can be tapped
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.userImageView addGestureRecognizer:profileTapGestureRecognizer];
    [self.userImageView setUserInteractionEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)didTapFavorite:(id)sender {
    
    
    if (self.tweet.favorited) { // already favorited this tweet
        // Update the local tweet model
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        
        // Update cell UI
        [self refreshData];
        
        // Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    else { // has not favorited this tweet
        // Update the local tweet model
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        
        // Update cell UI
        [self refreshData];
        
        // Send a POST request to the POST favorites/destroy endpoint
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    
}
- (IBAction)didTapRetweet:(id)sender {
    if (self.tweet.retweeted) { // already retweeted this tweet
        // Update the local tweet model
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        
        // Update cell UI
        [self refreshData];
        
        // Send a POST request to the POST retweet endpoint
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    else { // has not retweeted this tweet
        // Update the local tweet model
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        
        // Update cell UI
        [self refreshData];
        
        // Send a POST request to the POST unretweet endpoint
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
}

- (void)refreshData {
    // update the cell's view based on the tweet and user models
    
    self.nameLabel.text = self.tweet.user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.tweetTextLabel.text = self.tweet.text;
    self.dateLabel.text = self.tweet.createdAtString;
    
    
    UIImage *favorIcon = [UIImage imageNamed:@"favor-icon"];
    [self.favoriteIconButton setImage:favorIcon forState:UIControlStateNormal];
    
    UIImage *favorIconRed = [UIImage imageNamed:@"favor-icon-red"];
    [self.favoriteIconButton setImage:favorIconRed forState:UIControlStateSelected];
    
    UIImage *retweetIcon = [UIImage imageNamed:@"retweet-icon"];
    [self.retweetIconButton setImage:retweetIcon forState:UIControlStateSelected];
    
    UIImage *retweetIconGreen = [UIImage imageNamed:@"retweet-icon-green"];
    [self.retweetIconButton setImage:retweetIconGreen forState:UIControlStateSelected];
    
    if (self.tweet.favorited) {
        [self.favoriteIconButton setSelected:YES];
    }
    else {
        [self.favoriteIconButton setSelected:NO];
    }
    
    if (self.tweet.retweeted) {
        [self.retweetIconButton setSelected:YES];
    }
    else {
        [self.retweetIconButton setSelected:NO];
    }
    
    [self.retweetButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.retweetCount] forState:UIControlStateNormal];
    [self.favoriteButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.favoriteCount] forState:UIControlStateNormal];
    
    NSString *URLString = self.tweet.user.profilePictureURL;
    
    NSURL *URL = [NSURL URLWithString:URLString];
    
    // make profile pic a circle
    CALayer *imageLayer = self.userImageView.layer;
    [imageLayer setCornerRadius:self.userImageView.frame.size.width/2];
    [imageLayer setMasksToBounds:YES];
    
    [self.userImageView setImageWithURL:URL];
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    [self.delegate tweetCell:self didTap:self.tweet.user];
}

@end
