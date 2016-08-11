//
//  TabBarViewController.h
//  Treasure-Quest
//
//  Created by Michael Sweeney on 8/10/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Quest.h"
#import "Objective.h"

@interface TabBarViewController : UITabBarController

@property (strong, nonatomic) Quest *currentQuest;
@property (strong, nonatomic) Objective *currentObjective;
@property (strong, nonatomic) NSString *mystring;


@end
