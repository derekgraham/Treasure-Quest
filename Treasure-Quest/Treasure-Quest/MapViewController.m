//
//  MapViewController.m
//  Treasure-Quest
//
//  Created by Michael Sweeney on 8/5/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

#import "MapViewController.h"
@import MapKit;
#import "LocationController.h"
#import "Quest.h"
#import "Objective.h"
#import "ProgressListViewController.h"

@interface MapViewController () <MKMapViewDelegate, LocationControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) Quest *currentQuest;
@property float angleToNextObjective;
@property (strong, nonatomic) Objective *nextObjective;
@property (strong, nonatomic) MKPinAnnotationView *userLocation;

@end

@implementation MapViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.mapView.layer setCornerRadius:20.0];
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setDelegate:self];
    [self.mapView setZoomEnabled:NO];
    [self.mapView setScrollEnabled:NO];
    [self.mapView setRotateEnabled:NO];
    [self.mapView setShowsBuildings:YES];
    [self.mapView setPitchEnabled:YES];
    [self.mapView setShowsPointsOfInterest:YES];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    self.mapView.camera.pitch = 80;
    
    //demo objective
    self.nextObjective = [Objective initWith:@"World Class Coffee" imageURL:@"picture.com" info:@"sweet objective" category:@"Resturant" range:@10.0 latitude:47.617212 longitude:-122.3536802];
//    self.nextObjective = [Objective initWith:@"Space Needle Park" imageURL:@"2ndPicture.com" info:@"kinda cool" category:@"Landmark" range:@10.0 latitude:47.6192848 longitude:-122.3503663];
//    

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[LocationController sharedController]setDelegate:self];
    [[[LocationController sharedController]locationManager]startUpdatingLocation];
    [[[LocationController sharedController] locationManager]startUpdatingHeading];
    ProgressListViewController *progressListVC = (ProgressListViewController *)[self.tabBarController.viewControllers objectAtIndex:0];
    self.currentQuest = progressListVC.currentQuest;
//    NSLog(@"MAPS CURRENT OBJECTIVES: %@", self.currentQuest.route.waypoints);
    [self setupObjectiveAnnotations];
   
}


-(void)setupObjectiveAnnotations {

    NSArray *objectives = self.currentQuest.route.waypoints;

    Objective *firstCompleted = objectives[0];
    firstCompleted.completed = YES;

    for (Objective *objective in objectives) {

        if(objective.completed == YES){

          CLLocationCoordinate2D loc = objective.location.coordinate;
          MKPointAnnotation *newPoint = [[MKPointAnnotation alloc]init];
          newPoint.coordinate = loc;
          newPoint.title = objective.name;
          [self.mapView addAnnotation:newPoint];

        }
    }
}

-(void)setRegionForCoordinate:(MKCoordinateRegion)region {
    [self.mapView setRegion:region animated:YES];

}

-(void)locationControllerDidUpdateLocation:(CLLocation *)location{
    
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(location.coordinate, 50, 50) animated:YES];
    self.mapView.camera.altitude = 250;
    [self calculateAngleToNewObjective:location objectiveLocation:self.nextObjective.location];
    self.currentUserLocation = location;
    [self calculateAngleToNewObjective:self.currentUserLocation objectiveLocation:self.nextObjective.location];
    
}

-(void)locationControllerDidUpdateHeading:(CLHeading *)heading {

    NSLog(@"mapview current heading: %f", heading.trueHeading);
    self.mapView.camera.heading = heading.trueHeading;
    
    self.mapView.camera.pitch = 70;
    self.mapView.camera.altitude = 250;
    self.currentHeading = heading.trueHeading;
    [self calculateAngleToNewObjective:self.currentUserLocation objectiveLocation:self.nextObjective.location];
    [self changeUserAnnotationColor:self.userLocation];
 }

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {

    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        
       self.userLocation = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"userAnno"];
        self.userLocation.pinTintColor = [UIColor purpleColor];
        
        return [self changeUserAnnotationColor:self.userLocation];
    }

    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationView"];

    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"annotationView"];
    }

    annotationView.canShowCallout = YES;
    UIButton *calloutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = calloutButton;
    return annotationView;
}

-(void) calculateAngleToNewObjective:(CLLocation *)userLocation objectiveLocation: (CLLocation *)objectiveLocation {
   
    float userLat = userLocation.coordinate.latitude;
    float userLong = userLocation.coordinate.longitude;
    
    float objectiveLat = objectiveLocation.coordinate.latitude;
    float objectiveLong = objectiveLocation.coordinate.longitude;
    
    float deltaLong = objectiveLong - userLong;
    float y = sin(deltaLong) * cos(objectiveLat);
    float x = cos(userLat) * sin(objectiveLat) - sin(userLat) * cos(objectiveLat) * cos(deltaLong);
    float bearingInRadians = atan2f(y, x);
    
    self.angleToNextObjective = bearingInRadians * 180 / M_PI;
    
    NSLog(@"Angle to next objective: %f", self.angleToNextObjective);
}

-(MKPinAnnotationView*)changeUserAnnotationColor: (MKPinAnnotationView *)userPin {
    
     NSLog(@"current heading: %f      objective heading: %f", self.currentHeading, self.angleToNextObjective);
    if (self.currentHeading <= self.angleToNextObjective + 10 && self.currentHeading >= self.angleToNextObjective - 10) {
    
       
       self.userLocation.pinTintColor = [UIColor greenColor];
        return userPin;
        
    }
    
    else {
        
        self.userLocation.pinTintColor = [UIColor yellowColor];
        return userPin;
    }

}

-(void) compareHeadings:(float)userHeading destinationHeading:(float)destinationHeading  {
    
}

@end
