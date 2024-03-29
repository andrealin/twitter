//
//  TweetCell.h
//  twitter
//
//  Created by drealin on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN


@protocol TweetCellDelegate;

@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteIconButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetIconButton;
@property (weak, nonatomic) Tweet *tweet;
@property (nonatomic, weak) id<TweetCellDelegate> delegate;

- (void)refreshData;

@end

@protocol TweetCellDelegate
- (void)tweetCell:(TweetCell *) tweetCell didTap: (User *)user;
@end


NS_ASSUME_NONNULL_END
