//
//  Zombie.h
//  Chase Z
//
//  Created by James Coughlan on 02/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "LatLon.h"
@interface Zombie : NSObject

-(id) initWithPosition:(CLLocationCoordinate2D) position;
@property CLLocationCoordinate2D currentPosition;
@end