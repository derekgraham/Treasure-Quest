//
//  SummaryViewController.h
//  Treasure-Quest
//
//  Created by Rick  on 8/4/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayfieldViewController.h"
#import "LocationController.h"

@interface SummaryViewController : UIViewController

@property(strong, nonatomic)NSString *questName;
@property(strong, nonatomic)NSString *gameDescription;
@property(strong, nonatomic)NSNumber *players;
@property(strong, nonatomic)NSNumber *objectives;
@property(strong, nonatomic)NSString *finalLat;
@property(strong, nonatomic)NSString *finalLong;
@property(strong, nonatomic)NSMutableArray *creatorObjectives;
@property(nonatomic)CLLocationCoordinate2D finalCoordinate;
@property(strong, nonatomic)NSNumber *maxDistance;


@end
