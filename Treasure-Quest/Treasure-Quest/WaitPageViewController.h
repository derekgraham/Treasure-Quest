//
//  WaitPageViewController.h
//  Treasure-Quest
//
//  Created by Rick  on 8/5/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Quest.h"


@interface WaitPageViewController : UIViewController

@property(strong, nonatomic)NSString *questName;
@property(strong, nonatomic)NSString *gameDescription;
@property(strong, nonatomic)NSString *gameCode;
@property(strong, nonatomic)NSNumber *maxPlayers;
@property(strong, nonatomic)NSMutableArray *players;
@property(strong, nonatomic)NSNumber *objectives;
@property(strong, nonatomic)NSNumber *teamNumber;
@property(strong, nonatomic)Quest *createdQuest;

@end
