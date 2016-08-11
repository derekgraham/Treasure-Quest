//
//  Route.h
//  Treasure-Quest
//
//  Created by Michael Sweeney on 8/4/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//


#import "Playfield.h"

@interface Route : NSObject

@property CLLocationCoordinate2D finalDestination;
@property (strong, nonatomic) Playfield *playfield;
@property (strong, nonatomic) NSMutableArray *waypoints;
+(Route *)demoRoute;
+(Route *)gameRoute: (NSNumber *)minRadius maxRadius:(NSNumber *)maxRadius;
+(double)totalDistanceCrowFlies:(Route *)route;
+(Route *)randomizeRoute:(Route *)originalRoute;
+(NSMutableArray *)verifyDistanceRange:(Route *)originalRoute players:(int)players;

@end
