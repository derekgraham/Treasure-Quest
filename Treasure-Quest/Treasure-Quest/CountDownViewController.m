//
//  CountDownViewController.m
//  Treasure-Quest
//
//  Created by Rick  on 8/9/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

#import "CountDownViewController.h"
@import UIKit;

@interface CountDownViewController ()

@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;

@end

@implementation CountDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.countDownLabel.text = @"5";
    [self animateCountDown];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)animateCountDown {
    
    [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.countDownLabel.transform = CGAffineTransformScale(self.countDownLabel.transform, 2.0, 2.0);
        self.countDownLabel.alpha = 0;
    } completion:^(BOOL finished) {
        self.countDownLabel.transform = CGAffineTransformScale(self.countDownLabel.transform, 0.5, 0.5);
        self.countDownLabel.text = @"4";
        self.countDownLabel.alpha = 1.0;
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.countDownLabel.transform = CGAffineTransformScale(self.countDownLabel.transform, 2.1, 2.1);
            self.countDownLabel.alpha = 0;
        } completion:^(BOOL finished) {
            self.countDownLabel.transform = CGAffineTransformScale(self.countDownLabel.transform, 0.5, 0.5);
            self.countDownLabel.text = @"3";
            self.countDownLabel.alpha = 1.0;
            [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.countDownLabel.transform = CGAffineTransformScale(self.countDownLabel.transform, 2.2, 2.2);
                self.countDownLabel.alpha = 0;
            } completion:^(BOOL finished) {
                self.countDownLabel.transform = CGAffineTransformScale(self.countDownLabel.transform, 0.5, 0.5);
                self.countDownLabel.text = @"2";
                self.countDownLabel.alpha = 1.0;
                [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.countDownLabel.transform = CGAffineTransformScale(self.countDownLabel.transform, 2.3, 2.3);
                    self.countDownLabel.alpha = 0.5;
                } completion:^(BOOL finished) {
                    self.countDownLabel.transform = CGAffineTransformScale(self.countDownLabel.transform, 0.5, 0.5);
                    self.countDownLabel.text = @"1";
                    self.countDownLabel.alpha = 1.0;
                    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        self.countDownLabel.transform = CGAffineTransformScale(self.countDownLabel.transform, 2.4, 2.4);
                        self.countDownLabel.alpha = 0;
                    } completion:^(BOOL finished) {
                        self.countDownLabel.transform = CGAffineTransformScale(self.countDownLabel.transform, 0.85, 0.85);
                        self.countDownLabel.textColor = [UIColor greenColor];
                        self.countDownLabel.alpha = 0.8;
                        self.countDownLabel.text = @"GO!";
                        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            self.countDownLabel.alpha = 0.0;
                        } completion:^(BOOL finished) {
                            [self.joinButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                            }];
                    }];
                }];
            }];
        }];
    }];
}


@end
