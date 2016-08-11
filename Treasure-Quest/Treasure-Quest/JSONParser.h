//
//  JSONParser.h
//  Treasure-Quest
//
//  Created by Sean Champagne on 8/6/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoursquareAPI.h"

@interface JSONParser : NSObject

+(NSArray *)foursquareJSONData:(NSDictionary *)jsonData;
+(FoursquareAPI *)dataFromJSON:(NSDictionary *)data;

@end
