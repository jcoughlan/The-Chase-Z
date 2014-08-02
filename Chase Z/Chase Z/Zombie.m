//
//  Zombie.m
//  Chase Z
//
//  Created by James Coughlan on 02/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import "Zombie.h"

@implementation Zombie

#define VISIBILITY 500
#define KPH        12.0
#define FPS        30.0

-(id) initWithPosition:(CLLocationCoordinate2D) position
{
    self = [self init];
    self.currentPosition = position;
    self.bearingToUser = -1.0;
    return self;
}

-(void) update:(CLLocationCoordinate2D) userLoc
{
    
    self.canSeeUser = [self checkIfCanSeeUser:userLoc];
    if (self.canSeeUser)
    {
        NSLog(@"Zombie can see user");
        //assuming we are updating at 30 fps
        //we need to send the zomboid towards the user at the
        //appropriate speed
        
        // TODO make this not be so awfully written
        float speedInMetresPerHour = KPH*1000;
        float speedInMetresPerMinute = speedInMetresPerHour/60.0f;
        float speedInMetresPerSecond = (speedInMetresPerMinute/60.0f);
        float finalMovement = speedInMetresPerSecond/FPS;
        
        //so we are moving finalMovement (meters) per second so move the zombie towards him at that pace
        
        CLLocation* userLocation = [[CLLocation alloc] initWithLatitude:userLoc.latitude longitude:userLoc.longitude];
        CLLocation* zombLocation = [[CLLocation alloc] initWithLatitude:self.currentPosition .latitude longitude:self.currentPosition .longitude];
        
        double bearing = [MathHelpers bearingToLocation:userLocation   startLoc:zombLocation];

        CLLocationCoordinate2D newLocation = [MathHelpers coordinateFromCoord:zombLocation.coordinate atDistanceKm:finalMovement/1000 atBearingDegrees:bearing];
        
        [self.annotation setCoordinate:newLocation];
        self.currentPosition = newLocation;
        
        self.bearingToUser = bearing;
    }
    else if(self.bearingToUser == -1.0){
        CLLocation* userLocation = [[CLLocation alloc] initWithLatitude:userLoc.latitude longitude:userLoc.longitude];
        CLLocation* zombLocation = [[CLLocation alloc] initWithLatitude:self.currentPosition .latitude longitude:self.currentPosition .longitude];
        
        double bearing = [MathHelpers bearingToLocation:userLocation   startLoc:zombLocation];
        self.bearingToUser = bearing;
    }
    
}

-(BOOL) checkIfCanSeeUser:(CLLocationCoordinate2D) userLocation
{
    CLLocation* userLoc = [[CLLocation alloc] initWithLatitude:userLocation.latitude longitude:userLocation.longitude];
    CLLocation* zombLoc = [[CLLocation alloc] initWithLatitude:self.currentPosition .latitude longitude:self.currentPosition .longitude];
    double distanceMeters = [zombLoc distanceFromLocation:userLoc];
    
    if (distanceMeters < VISIBILITY)
        return  YES;
    
    return NO;
}

@end
