//
//  LatLon.h
//  Chase Z
//
//  Created by James Coughlan on 02/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern double radians(double degrees);
extern double degrees(double radians);

extern CLLocationCoordinate2D LatLonDestPoint(CLLocationCoordinate2D origin, double brearing, CLLocationDistance distance);