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
#import "TabBarViewController.h"
#import <AudioToolbox/AudioServices.h>

@interface MapViewController () <MKMapViewDelegate, LocationControllerDelegate>
- (IBAction)completeButtonSelected:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property float angleToNextObjective;
@property (strong, nonatomic) MKPinAnnotationView *userPin;

@end

@implementation MapViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    //    NSLog(@"mapview view did load %@",((TabBarViewController *)self.parentViewController).currentQuest.name);
    //    NSLog(@"string value? %@",((TabBarViewController *)self.parentViewController).mystring);
    [self.mapView.layer setCornerRadius:20.0];
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setDelegate:self];
    [self.mapView setZoomEnabled:NO];
    [self.mapView setScrollEnabled:NO];
    [self.mapView setRotateEnabled:NO];
    [self.mapView setShowsBuildings:NO];
    [self.mapView setPitchEnabled:YES];
    [self.mapView setShowsPointsOfInterest:YES];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    self.mapView.camera.pitch = 80;

    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"XYZ" style:UIBarButtonSystemItemStop target:self action:@selector(completeButtonSelected:)];

    self.navigationItem.rightBarButtonItem = anotherButton;
    ((TabBarViewController *)self.parentViewController).navigationItem.rightBarButtonItem = anotherButton;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[LocationController sharedController]setDelegate:self];
    [[[LocationController sharedController]locationManager]startUpdatingLocation];
    [[[LocationController sharedController] locationManager]startUpdatingHeading];
    //    ProgressListViewController *progressListVC = (ProgressListViewController *)[self.tabBarController.viewControllers objectAtIndex:0];
    //    self.tabbar.currentQuest = progressListVC.currentQuest;
    [self setupObjectiveAnnotations];
}


-(void)setupObjectiveAnnotations {

    NSUInteger index = 0;

    Objective *current = [[Objective alloc]init];
    current = ((TabBarViewController *)self.parentViewController).currentQuest.objectives[index];

    while (current.completed == YES && index < ((TabBarViewController *)self.parentViewController).currentQuest.objectives.count) {
        NSLog(@"completed: %@", current.name);
        index++;

        if(index == ((TabBarViewController *)self.parentViewController).currentQuest.objectives.count){
            NSLog(@"end of array reached");
            return;
        }

        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(current.latitude, current.longitude);
        MKPointAnnotation *newPoint = [[MKPointAnnotation alloc]init];
        newPoint.coordinate = loc;
        newPoint.title = current.name;
        [self.mapView addAnnotation:newPoint];

        current = ((TabBarViewController *)self.parentViewController).currentQuest.objectives[index];

    }

    ((TabBarViewController *)self.parentViewController).currentObjective = current;
}

-(void)setRegionForCoordinate:(MKCoordinateRegion)region {

    [self.mapView setRegion:region animated:YES];

}

-(void)locationControllerDidUpdateLocation:(CLLocation *)location{

    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(location.coordinate, 50, 50) animated:YES];
    self.mapView.camera.altitude = 250;
    CLLocation *locationPointer = [[CLLocation alloc]initWithLatitude:((TabBarViewController *)self.parentViewController).currentObjective.latitude longitude:((TabBarViewController *)self.parentViewController).currentObjective.longitude];
    [self calculateAngleToNewObjective:location objectiveLocation:locationPointer];
    self.currentUserLocation = location;
    [self calculateAngleToNewObjective:self.currentUserLocation objectiveLocation:locationPointer];
    [self changeUserAnnotationColor:self.userPin];

}

-(void)locationControllerDidUpdateHeading:(CLHeading *)heading {

//    NSLog(@"current device heading: %@", heading);
    self.mapView.camera.heading = heading.trueHeading;

    CLLocation *locationPointer = [[CLLocation alloc]initWithLatitude:((TabBarViewController *)self.parentViewController).currentObjective.latitude longitude:((TabBarViewController *)self.parentViewController).currentObjective.longitude];

//    NSLog(@"current objectives latitude from tabbar! = %f", ((TabBarViewController *)self.parentViewController).currentObjective.latitude);


    self.mapView.camera.altitude = 250;
    self.currentHeading = heading.trueHeading;
    [self calculateAngleToNewObjective:self.currentUserLocation objectiveLocation:locationPointer];

//   NSLog(@"User Heading: %f   Angle to next: %f", self.currentHeading, self.angleToNextObjective);
    [self changeUserAnnotationColor:self.userPin];

}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {

    if ([annotation isKindOfClass:[MKUserLocation class]]) {

        self.userPin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"userAnno"];
        self.userPin.pinTintColor = [UIColor purpleColor];

        return [self changeUserAnnotationColor:self.userPin];

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

#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) (x * 180.0 / M_PI)

- (float)getHeadingForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc
{
    float fLat = degreesToRadians(fromLoc.latitude);
    float fLng = degreesToRadians(fromLoc.longitude);
    float tLat = degreesToRadians(toLoc.latitude);
    float tLng = degreesToRadians(toLoc.longitude);
    
    float degree = radiansToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));
    
    if (degree >= 0) {
        return degree;
    } else {
        return 360+degree;
    }
}

-(void) calculateAngleToNewObjective:(CLLocation *)userLocation objectiveLocation: (CLLocation *)objectiveLocation {

    //OLD CODE
//    float userLat = userLocation.coordinate.latitude;
//    float userLong = userLocation.coordinate.longitude;
//
//    float objectiveLat = objectiveLocation.coordinate.latitude;
//    float objectiveLong = objectiveLocation.coordinate.longitude;
//
    
    //NEW CODE
    float userLatRadians = degreesToRadians(userLocation.coordinate.latitude);
    float userLongRadians = degreesToRadians(userLocation.coordinate.longitude);
    
    float objectiveLatRadians = degreesToRadians(objectiveLocation.coordinate.latitude);
    float objectiveLongRadians = degreesToRadians(objectiveLocation.coordinate.longitude);

    //Intersection @ 2nd and broad
//    float objectiveLat = 47.618216495037395;
//    float objectiveLong = -122.35081493854524;
    
    //Space Needle
//    float objectiveLat = 47.62042219645017;
//    float objectiveLong = -122.34931290149687;
    
    // South of Home
//    float objectiveLat = 47.640048839626715;
//    float objectiveLong = -122.40581631660461;
    
    // West of Home
//    float objectiveLat =  47.64596900612188;
//    float objectiveLong = -122.41194784641266;

    // North of Home
//    float objectiveLat =  47.647194158250265;
//    float objectiveLong = -122.40559637546538;
  
    // East of Home
//    float objectiveLat =  47.64595816393936;
//    float objectiveLong = -122.4032950401306;
    
//    float objectiveLatRadians = degreesToRadians(objectiveLat);
//    float objectiveLongRadians = degreesToRadians(objectiveLong);
   
//    MKPointAnnotation *anno = [[MKPointAnnotation alloc]init];
//
//    anno.coordinate = CLLocationCoordinate2DMake(objectiveLat, objectiveLong);
//    [self.mapView addAnnotation:anno];

    float deltaLong = objectiveLongRadians - userLongRadians;
    float y = sin(deltaLong) * cos(objectiveLatRadians);
    float x = cos(userLatRadians) * sin(objectiveLatRadians) - sin(userLatRadians) * cos(objectiveLatRadians) * cos(deltaLong);
    float bearingInRadians = atan2f(y, x);
//    float degrees = fmod(((bearingInRadians * 180 / M_PI) + 360), 360);
    self.angleToNextObjective = fmod(((bearingInRadians * 180 / M_PI) + 360), 360);

    
//    NSLog(@"Degrees: %@ vs: degree: %@", degrees, degree);
    
//    float degree = radiansToDegrees(atan2(sin(objectiveLongRadians-userLongRadians)*cos(objectiveLatRadians), cos(userLatRadians)*sin(objectiveLatRadians)-sin(userLatRadians)*cos(objectiveLatRadians)*cos(objectiveLongRadians-userLongRadians)));
//
//    
//    if (degree >= 0) {
//        self.angleToNextObjective = degree;
//    } else {
//        self.angleToNextObjective = 360 + degree;
//    }
    
//    NSLog(@"Degrees: %f vs: degree: %f", degrees, self.angleToNextObjective);


}

-(MKPinAnnotationView*)changeUserAnnotationColor: (MKPinAnnotationView *)userPin {
    //TODO: adjust opacity based on accuracy percentage
    //float difference = fabs(self.currentHeading - self.angleToNextObjective);

    if (self.currentHeading <= self.angleToNextObjective + 10 && self.currentHeading >= self.angleToNextObjective - 10) {

        self.userPin.pinTintColor = [UIColor greenColor];
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        return userPin;

    }

        else if(self.currentHeading <= self.angleToNextObjective + 50 && self.currentHeading >= self.angleToNextObjective - 50) {
            self.userPin.pinTintColor = [UIColor yellowColor];
            return userPin;
    
        }

    else {

        self.userPin.pinTintColor = [UIColor redColor];
        return userPin;
    }

}

-(void)completeCurrentObjective {
    NSUInteger index = 0;
    ((TabBarViewController *)self.parentViewController).currentObjective.completed = YES;
    //    [self.currentObjective save];

    NSArray *objectives = [[NSArray alloc]init];
    objectives = ((TabBarViewController *)self.parentViewController).currentQuest.objectives;

    while (index < ((TabBarViewController *)self.parentViewController).currentQuest.objectives.count) {
        Objective *objective = [objectives objectAtIndex: index];
        if (objective.completed == NO){
            break;
        }
        index++;
    }

    if (index == ((TabBarViewController *)self.parentViewController).currentQuest.objectives.count){
        NSLog(@"end of the line");
        return;
    }

    ((TabBarViewController *)self.parentViewController).currentObjective = ((TabBarViewController *)self.parentViewController).currentQuest.objectives[index];

    //    NSLog(@"Objective complete! Next objective is objective %@", self.tabbar.currentObjective.name);
    [self setupObjectiveAnnotations];
    [self setUpRegion:((TabBarViewController *)self.parentViewController).currentObjective];
}

-(void) setUpRegion: (Objective *)objective {

    objective.range = @50;
    NSLog(@"Dis mah range bruh: %@", objective.range);

    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(objective.latitude, objective.longitude);

    if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
        CLCircularRegion *eventRegion = [[CLCircularRegion alloc]initWithCenter: coord radius:objective.range.floatValue identifier:objective.name];
        [[[LocationController sharedController]locationManager]startMonitoringForRegion:eventRegion];

        MKCircle *circle = [MKCircle circleWithCenterCoordinate:coord radius:objective.range.floatValue];

        [self.mapView addOverlay:circle];
    }

}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{

    MKCircleRenderer *circleRender = [[MKCircleRenderer alloc]initWithOverlay:overlay];
    circleRender.strokeColor = [UIColor blueColor];
    circleRender.lineWidth = 1;

    circleRender.fillColor = [UIColor redColor];
    circleRender.alpha = 0.25;

    return circleRender;

}

- (IBAction)completeButtonSelected:(UIButton *)sender {

    [self completeCurrentObjective];
    NSLog(@"button pressed!");

}
@end
