//
//  ProfileViewController.h
//  twitter
//
//  Created by drealin on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController
@property (nonatomic, strong) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;

@end

NS_ASSUME_NONNULL_END
