//
//  MathHelpers.h
//  Chase Z
//
//  Created by James Coughlan on 02/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MathHelpers : NSObject

+ (float)randomFloatBetween:(float)minRange and:(float)maxRange;

+( CLLocation*) offsetLocation:(CLLocation*)startLocation and:(double)offsetMeters also:(double)bearing;

+(float) bearingBetweenStartLocation:(CLLocation *)startLocation andEndLocation:(CLLocation *)endLocation;

+ (double) Rad2Deg:(double)angle;

+ (double)degreesFromRadians:(double)radians;

+ (double)radiansFromDegrees:(double)degrees;

+(double) bearingToLocation:(CLLocation *) destinationLocation startLoc:(CLLocation*)startLocation;

+ (CLLocationCoordinate2D)coordinateFromCoord:
(CLLocationCoordinate2D)fromCoord
                                 atDistanceKm:(double)distanceKm
                             atBearingDegrees:(double)bearingDegrees;
@end
