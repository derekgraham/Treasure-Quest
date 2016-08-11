//
//  Route.m
//  Treasure-Quest
//
//  Created by Michael Sweeney on 8/4/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

#import "Route.h"
#import "Objective.h"
#import "LocationController.h"
#import "PlayfieldViewController.h"
#import "SummaryViewController.h"
#import "FoursquareAPI.h"

@implementation Route

//@synthesize finalDestination;
//@synthesize playfield;
//@synthesize waypoints;
//
//+(void)load{
//    [self registerSubclass];
//
//}
//
//+(NSString *)parseClassName{
//    return @"Route";
//}



+(Route *)demoRoute{
    
    Route *ourRoute = [[Route alloc]init];
    ourRoute.finalDestination = CLLocationCoordinate2DMake(47.618217, -122.3540207);
    ourRoute.playfield.coordinate = CLLocationCoordinate2DMake(47.618217, -122.3540207);
    ourRoute.playfield.minRadius =  @100.0;
    ourRoute.playfield.maxRadius = @100.00;
    
    ourRoute.waypoints = [[NSMutableArray alloc]initWithObjects:
                                                                   [Objective initWith:@"World Class Coffee" imageURL:@"picture.com" info:@"sweet objective" category:@"Bar" range:@10.0 latitude:47.617212 longitude:-122.3536802],
                                                                   [Objective initWith:@"Space Needle Park" imageURL:@"2ndPicture.com" info:@"kinda cool" category:@"Landmark" range:@10.0 latitude:47.6192848 longitude:-122.3503663],
                                                                   [Objective initWith:@"Olympic Sculpture Park" imageURL:@"3rdPicture.com" info:@"worst" category:@"Local Shitty Art" range:@10.0 latitude:47.6170897 longitude:-122.3533829],
                                                                   [Objective initWith:@"Buckleys" imageURL:@"4thPicture.com" info:@"Best" category:@"Artwork" range:@10.0 latitude:47.6145925 longitude:-122.3491382
                                                                   ], nil];
    
    
    
    return ourRoute;
}

+ (double)totalDistanceCrowFlies:(Route *)route {
    double totalDistance = 0.00;
    for (int i = 1; i < route.waypoints.count; i++) {
        Objective *first = route.waypoints[i-1];
        Objective *second = route.waypoints[i];
        CLLocation *firstLocation =  [[CLLocation alloc]initWithLatitude:first.latitude longitude:first.longitude];
        CLLocation *secondLocation =  [[CLLocation alloc]initWithLatitude:second.latitude longitude:second.longitude];
        
        totalDistance += [firstLocation distanceFromLocation:secondLocation];
    }
    return totalDistance;
}


+(Route *)gameRoute: (NSNumber *)minRadius maxRadius:(NSNumber *)maxRadius
{
    Route *goRoute = [[Route alloc]init];
    CLLocationCoordinate2D pinLoc = [LocationController sharedController].pinLocation.coordinate;
    goRoute.finalDestination = pinLoc;

    return goRoute;
}

+ (Route *)randomizeRoute:(Route *)originalRoute {
    Route *copyRoute = [[Route alloc]init];
    copyRoute.finalDestination = originalRoute.finalDestination;
    copyRoute.playfield.coordinate = originalRoute.playfield.coordinate;
    copyRoute.playfield.minRadius = originalRoute.playfield.minRadius;
    copyRoute.playfield.maxRadius = originalRoute.playfield.maxRadius;
    copyRoute.waypoints = [[NSMutableArray alloc]init];

    NSMutableArray *objectivesCopy = [originalRoute.waypoints mutableCopy];

    while (objectivesCopy.count > 1) {
        int index = (int)(arc4random() * objectivesCopy.count % ( objectivesCopy.count - 1 ));
        [copyRoute.waypoints addObject:[objectivesCopy objectAtIndex:index]];
        [objectivesCopy removeObjectAtIndex:index];
    }
    [copyRoute.waypoints addObject:objectivesCopy.lastObject];
    return copyRoute;
}

+ (NSMutableArray *)verifyDistanceRange:(Route *)originalRoute players:(int)players{
    
    NSMutableArray *fairObjectives = [[NSMutableArray alloc]init];
    double averageDistance = 0;
    int othercount = 0;
    for (int i = 0; i < 25; i++) {
        averageDistance += [self totalDistanceCrowFlies:[self randomizeRoute:originalRoute]];
        othercount ++;
    }
    
    averageDistance = averageDistance/25;
    NSLog(@"%d and average: %f", othercount, averageDistance);
    while (fairObjectives.count < players) {
        Route *randomRoute = [self randomizeRoute:originalRoute];
        if (averageDistance * 0.925 < [self totalDistanceCrowFlies:randomRoute] && averageDistance * 1.075 > [self totalDistanceCrowFlies:randomRoute]) {
            [fairObjectives addObject:randomRoute];
        }
    }
    //FOR TESTING PURPOSES.. CAN BE DELETED IF TEST ARE DONE AND IT WORKS
    int count = 1;
    for (Route *objective in fairObjectives) {
        NSLog(@"Player %i,: %f", count, [self totalDistanceCrowFlies:objective]);
        count ++;
    }
    return fairObjectives;
}


@end
