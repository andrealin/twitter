//
//  ComposeViewController.m
//  twitter
//
//  Created by drealin on 7/3/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)tweetAction:(id)sender {
    // get text
    NSString *tweetText = self.textView.text;
    
    // api manager post status with text
    [[APIManager shared] postStatusWithText:tweetText completion:^(Tweet *tweet, NSError *error){
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            NSLog(@"Compose Tweet Success!");
        }
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    
}

@end
