//
//  ProfileViewController.m
//  twitter
//
//  Created by drealin on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = self.user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
    self.tweetsLabel.text = [NSString stringWithFormat:@"%@ Tweets", self.user.tweets];
    self.followingLabel.text = [NSString stringWithFormat:@"%@ Following", self.user.following];
    self.followersLabel.text = [NSString stringWithFormat:@"%@ Followers", self.user.followers];

    NSString *URLString = self.user.profilePictureURL;
    
    NSURL *URL = [NSURL URLWithString:URLString];
    
    // make profile pic a circle
    CALayer *imageLayer = self.userImageView.layer;
    [imageLayer setCornerRadius:self.userImageView.frame.size.width/2];
    [imageLayer setMasksToBounds:YES];
    
    [self.userImageView setImageWithURL:URL];
}
- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
