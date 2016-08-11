//
//  PlayfieldViewController.m
//  Treasure-Quest
//
//  Created by Rick  on 8/4/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

#import "PlayfieldViewController.h"
#import "SummaryViewController.h"


@interface PlayfieldViewController () <MKMapViewDelegate, LocationControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *maxDistanceTextField;
@property (weak, nonatomic) IBOutlet UIButton *setButton;
@property (weak, nonatomic) IBOutlet UITextField *minDistanceTextField;
- (IBAction)set:(UIButton *)sender;


@end

@implementation PlayfieldViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mapView.layer setCornerRadius:20.0];
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setDelegate:self];
    self.maxDistanceTextField.delegate = self;
    self.minDistanceTextField.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[LocationController sharedController]setDelegate:self];
    [[[LocationController sharedController]locationManager]startUpdatingLocation];

    self.mapView.delegate = self;
    
    
}

-(void)locationControllerDidUpdateHeading:(CLHeading *)heading
{
    //
}


-(void)locationControllerDidUpdateLocation:(CLLocation *)location
{
     [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000) animated:YES];
    self.currentLat = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    self.currentLong = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    self.currentUserLocation = location;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SummaryViewController"]) {
        
        SummaryViewController *summaryViewController = (SummaryViewController *)segue.destinationViewController;
        summaryViewController.players = self.players;
        summaryViewController.questName = self.questName;
        summaryViewController.gameDescription = self.gameDescription;
        summaryViewController.objectives = self.objectives;
        
        if(!self.finalCoordinate.latitude) {
            self.finalCoordinate = CLLocationCoordinate2DMake(self.currentUserLocation.coordinate.latitude, self.currentUserLocation.coordinate.longitude);
        }
        if (!self.maxDistance) {
            self.maxDistance = [NSNumber numberWithInt:1000];;
        }
        summaryViewController.maxDistance = self.maxDistance;
        summaryViewController.finalCoordinate = self.finalCoordinate;
    }
}

- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        CGPoint touchPoint = [sender locationInView:self.mapView];
        
        CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        MKPointAnnotation *newPoint = [[MKPointAnnotation alloc]init];
        newPoint.coordinate = touchMapCoordinate;
        newPoint.title = @"Select Final Location!";
        newPoint.subtitle = @"End the quest here.";
        
        CLLocation *tempLocal = [[CLLocation alloc]initWithLatitude:newPoint.coordinate.latitude longitude:newPoint.coordinate.longitude];
        
        [LocationController sharedController].pinLocation = tempLocal;
        
        self.finalCoordinate = newPoint.coordinate;
        //newPoint.coordinate = CLLocationCoordinate2DMake(tempLocal.coordinate.latitude, tempLocal.coordinate.longitude);
        
        [self.mapView addAnnotation:newPoint];
        
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc]initWithOverlay:overlay];
    circleRenderer.fillColor = [UIColor blueColor];
    circleRenderer.alpha = 0.2;
    
    return circleRenderer;
}

- (IBAction)set:(UIButton *)sender {
    if (self.overlay) {
        [self.mapView removeOverlay:self.overlay];
    }
    CLLocationDistance distance = [self.maxDistanceTextField.text doubleValue];
    self.maxDistance = [NSNumber numberWithDouble:[self.maxDistanceTextField.text doubleValue]];
    if(!distance) {distance = 1000; }
    if(!self.finalCoordinate.latitude){self.finalCoordinate = self.currentUserLocation.coordinate; }
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.finalCoordinate radius:distance];
    
    self.overlay = circle;
    [self.mapView addOverlay:circle];
    
}


#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.maxDistanceTextField]) {
        [self set:self.setButton];
    }
    [textField resignFirstResponder];
    return YES;
}

@end
