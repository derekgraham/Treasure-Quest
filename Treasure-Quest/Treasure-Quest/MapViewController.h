//
//  MapViewController.h
//  Treasure-Quest
//
//  Created by Michael Sweeney on 8/5/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

@interface MapViewController : UIViewController

@property CLLocationDirection currentHeading;
@property (strong, nonatomic) CLLocation *currentUserLocation;

@end
