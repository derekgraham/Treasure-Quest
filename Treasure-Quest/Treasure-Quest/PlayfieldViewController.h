//
//  PlayfieldViewController.h
//  Treasure-Quest
//
//  Created by Rick  on 8/4/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Quest.h"
#import "LocationController.h"
@import MapKit;

@interface PlayfieldViewController : UIViewController

@property(strong, nonatomic)NSString *questName;
@property(strong, nonatomic)NSString *gameDescription;
@property(strong, nonatomic)NSNumber *players;
@property(strong, nonatomic)NSNumber *objectives;
@property(strong, nonatomic)NSString *currentLat;
@property(strong, nonatomic)NSString *currentLong;
@property (strong, nonatomic) CLLocation *currentUserLocation;

@end
