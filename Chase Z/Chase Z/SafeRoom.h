//
//  SafeRoom.h
//  Chase Z
//
//  Created by James Coughlan on 02/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SafeRoomAnnotation.h"
@interface SafeRoom : NSObject

-(id) initWithLocation:(CLLocationCoordinate2D) location;
-(void) update:(CLLocationCoordinate2D) playerLocation;

@property SafeRoomAnnotation* annotation;
@property CLLocationCoordinate2D safeRoomLocation;
@end
