//
//  LeaderBoardViewController.m
//  Treasure-Quest
//
//  Created by Michael Sweeney on 8/5/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

#import "LeaderBoardViewController.h"
//#import <Parse/Parse.h>
#import "Quest.h"

@import Parse;


@interface LeaderBoardViewController () 
@property (strong, nonatomic) IBOutlet UIView *pushTestButton;
@property (weak, nonatomic) IBOutlet UIButton *textSendButton;
@property (strong, nonatomic) Quest *currentQuest;

@end




@implementation LeaderBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}
- (IBAction)sendTextButtonPressed:(id)sender {
 
}

- (IBAction)pushTestButtonPressed:(id)sender {
    NSLog(@"got it");
    
//    @"LuX5l9Yirp"
//    [[PFUser currentUser] fetch];
    
    NSString *message = [NSString stringWithFormat:@"%@ has joined the quest!", [PFUser currentUser].username];
    [PFCloud callFunctionInBackground:@"iosPushTest"
                       withParameters:@{@"text": message }
                                block:^(NSString *response, NSError *error) {
                                    if (!error) {
                                        // ratings is 4.5
                                        NSLog(@"%@",response );
                                    }
                                }];
    [PFCloud callFunctionInBackground:@"iosPushToChannel"
                       withParameters:@{@"text": @"TEST CHANNEL SEND",
                                        @"channel": [[PFUser currentUser] objectForKey:@"currentQuestId"]}
                                block:^(NSString *response, NSError *error) {
                                    if (!error) {
                                        // ratings is 4.5
                                        NSLog(@"%@",response );
                                    }
                                }];
}

- (void) setup {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    
    
    [currentInstallation addUniqueObject:[[PFUser currentUser] objectForKey:@"currentQuestId"] forKey:@"channels"];
    [currentInstallation saveInBackground];
    NSLog(@"%@",[PFInstallation currentInstallation].channels);
    
    
//    PFQuery *query= [PFQuery queryWithClassName:@"Quest"];
//    [query getObjectWithId:@"LuX5l9Yirp"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
//    {
//        PFObject *obj = [objects firstObject];
//        NSLog(@"%@", obj);
//    }];

    
}


@end
