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
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end