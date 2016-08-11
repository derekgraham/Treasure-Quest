//
//  TabBarViewController.m
//  Treasure-Quest
//
//  Created by Michael Sweeney on 8/10/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSLog(@"Did load the tab bar");
    self.currentQuest = [[Quest alloc]init];
//    self.currentQuest.name = @"tab bar quest name";
    self.mystring = @"testing....";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
