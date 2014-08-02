//
//  MathHelpers.m
//  Chase Z
//
//  Created by James Coughlan on 02/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import "MathHelpers.h"
#define ARC4RANDOM_MAX 0x100000000
@implementation MathHelpers



+ (float)randomFloatBetween:(float)minRange and:(float)maxRange {
    double val = ((double)arc4random() / ARC4RANDOM_MAX)
    * (maxRange - minRange)
    + minRange;
    return val;
}

+(CLLocation*) offsetLocation:(CLLocation*)startLocation and:(double)offsetMeters also:(double)bearing
{
	
	double EARTH_MEAN_RADIUS_METERS = 6372796.99;
	double lat2 = asin( sin(startLocation.coordinate.latitude) * cos(offsetMeters/EARTH_MEAN_RADIUS_METERS) + cos(startLocation.coordinate.latitude) * sin(offsetMeters/EARTH_MEAN_RADIUS_METERS) * cos(bearing) );
	double lon2 = startLocation.coordinate.longitude + atan2( sin(bearing) * sin(offsetMeters/EARTH_MEAN_RADIUS_METERS) * cos(startLocation.coordinate.latitude), cos(offsetMeters/EARTH_MEAN_RADIUS_METERS) - sin(startLocation.coordinate.latitude) * sin(lat2));
	CLLocation *tempLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lon2];
    
	return tempLocation;
}

+ (double) Rad2Deg:(double)angle {
    static double ratio = 180.0 / 3.141592653589793238;
    return angle * ratio;
}


+(float) bearingBetweenStartLocation:(CLLocation *)startLocation andEndLocation:(CLLocation *)endLocation{
    
    CLLocation *northPoint = [[CLLocation alloc] initWithLatitude:(startLocation.coordinate.latitude)+.01 longitude:endLocation.coordinate.longitude] ;
    float magA = [northPoint distanceFromLocation:startLocation];
    float magB = [endLocation distanceFromLocation:startLocation];
    CLLocation *startLat = [[CLLocation alloc] initWithLatitude:startLocation.coordinate.latitude longitude:0] ;
    CLLocation *endLat = [[CLLocation alloc] initWithLatitude:endLocation.coordinate.latitude longitude:0] ;
    float aDotB = magA*[endLat distanceFromLocation:startLat];
    return [MathHelpers Rad2Deg:(acosf(aDotB/(magA*magB)))];
}

+ (double)radiansFromDegrees:(double)degrees
{
    return degrees * (M_PI/180.0);
}

+ (double)degreesFromRadians:(double)radians
{
    return radians * (180.0/M_PI);
}

+ (CLLocationCoordinate2D)coordinateFromCoord:
(CLLocationCoordinate2D)fromCoord
                                 atDistanceKm:(double)distanceKm
                             atBearingDegrees:(double)bearingDegrees
{
    double distanceRadians = distanceKm / 6371.0;
    //6,371 = Earth's radius in km
    double bearingRadians = [self radiansFromDegrees:bearingDegrees];
    double fromLatRadians = [self radiansFromDegrees:fromCoord.latitude];
    double fromLonRadians = [self radiansFromDegrees:fromCoord.longitude];
    
    double toLatRadians = asin( sin(fromLatRadians) * cos(distanceRadians)
                               + cos(fromLatRadians) * sin(distanceRadians) * cos(bearingRadians) );
    
    double toLonRadians = fromLonRadians + atan2(sin(bearingRadians)
                                                 * sin(distanceRadians) * cos(fromLatRadians), cos(distanceRadians)
                                                 - sin(fromLatRadians) * sin(toLatRadians));
    
    // adjust toLonRadians to be in the range -180 to +180...
    toLonRadians = fmod((toLonRadians + 3*M_PI), (2*M_PI)) - M_PI;
    
    CLLocationCoordinate2D result;
    result.latitude = [self degreesFromRadians:toLatRadians];
    result.longitude = [self degreesFromRadians:toLonRadians];
    return result;
}

double DegreesToRadians(double degrees) {return degrees * M_PI / 180.0;};
double RadiansToDegrees(double radians) {return radians * 180.0/M_PI;};

+(double) bearingToLocation:(CLLocation *) destinationLocation startLoc:(CLLocation*)startLocation{
    
    double lat1 = DegreesToRadians(startLocation.coordinate.latitude);
    double lon1 = DegreesToRadians(startLocation.coordinate.longitude);
    
    double lat2 = DegreesToRadians(destinationLocation.coordinate.latitude);
    double lon2 = DegreesToRadians(destinationLocation.coordinate.longitude);
    
    double dLon = lon2 - lon1;
    
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double radiansBearing = atan2(y, x);
    
    return RadiansToDegrees(radiansBearing);
}
@end
