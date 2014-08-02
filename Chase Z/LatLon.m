//
//  LatLon.m
//  Chase Z
//
//  Created by James Coughlan on 02/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import "LatLon.h"

const CLLocationDegrees kLatLonEarthRadius = 6371.0;

double radians(double degrees) {
    return degrees * M_PI / 180.0;
}

double degrees(double radians) {
    return radians * 180.0 / M_PI;
}

CLLocationCoordinate2D LatLonDestPoint(CLLocationCoordinate2D origin, double bearing, CLLocationDistance distance) {
    double brng = radians(bearing);
    double lat1 = radians(origin.latitude);
    double lon1 = radians(origin.longitude);
    
    CLLocationDegrees lat2 = asin(sin(lat1) * cos(distance / kLatLonEarthRadius) +
                                  cos(lat1) * sin(distance / kLatLonEarthRadius) * cos(brng));
    CLLocationDegrees lon2 = lon1 + atan2(sin(brng) * sinf(distance / kLatLonEarthRadius) * cos(lat1),
                                          cosf(distance / kLatLonEarthRadius) - sin(lat1) * sin(lat2));
    lon2 = fmod(lon2 + M_PI, 2.0 * M_PI) - M_PI;
    
    CLLocationCoordinate2D coordinate;
    if (! (isnan(lat2) || isnan(lon2))) {
        coordinate.latitude = degrees(lat2);
        coordinate.longitude = degrees(lon2);
    }
    
    return coordinate;
}

