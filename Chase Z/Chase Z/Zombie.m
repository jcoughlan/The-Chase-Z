//
//  Zombie.m
//  Chase Z
//
//  Created by James Coughlan on 02/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import "Zombie.h"

@implementation Zombie

#define ALERT_VISIBILITY 1000
#define CHASE_VISIBILITY 700
#define ATTACK_VISIBILITY 5

#define KPH_CHASING        12.0
#define KPH_WANDERING       3.0
#define KPH_ATTACKING       5.0
#define KPH_ALERTED           7.0

#define FPS        30.0

-(id) initWithPosition:(CLLocationCoordinate2D) position
{
    self = [self init];
    self.currentPosition = position;
    self.bearingToUser = -1.0;
    self.zombieState = [[ZombieState alloc]initWithState:ZombieStateWandering];
    return self;
}

-(void) update:(CLLocationCoordinate2D) userLoc
{
    
    [self checkIfCanSeeUser:userLoc];
    BOOL requiresMovementTowardsUser = NO;
    float finalMovement = 0.0;
    if (self.zombieState.currentState == ZombieStateAttacking)
    {
        requiresMovementTowardsUser = YES;
        float speedInMetresPerHour = KPH_ATTACKING*1000;
        float speedInMetresPerMinute = speedInMetresPerHour/60.0f;
        float speedInMetresPerSecond = (speedInMetresPerMinute/60.0f);
        finalMovement = speedInMetresPerSecond/FPS;
    }
    else if (self.zombieState.currentState == ZombieStateChasing)
    {
        requiresMovementTowardsUser = YES;
        float speedInMetresPerHour = KPH_CHASING*1000;
        float speedInMetresPerMinute = speedInMetresPerHour/60.0f;
        float speedInMetresPerSecond = (speedInMetresPerMinute/60.0f);
        finalMovement = speedInMetresPerSecond/FPS;
        
    }
    else if (self.zombieState.currentState == ZombieStateAllerted)
    {
        requiresMovementTowardsUser = YES;
        requiresMovementTowardsUser = YES;
        float speedInMetresPerHour = KPH_ALERTED*1000;
        float speedInMetresPerMinute = speedInMetresPerHour/60.0f;
        float speedInMetresPerSecond = (speedInMetresPerMinute/60.0f);
        finalMovement = speedInMetresPerSecond/FPS;
    }
    else if (self.zombieState.currentState == ZombieStateWandering)
    {
        CLLocation* userLocation = [[CLLocation alloc] initWithLatitude:userLoc.latitude longitude:userLoc.longitude];
        CLLocation* zombLocation = [[CLLocation alloc] initWithLatitude:self.currentPosition .latitude longitude:self.currentPosition .longitude];
        
        double bearing = [MathHelpers bearingToLocation:userLocation   startLoc:zombLocation];
        self.bearingToUser = bearing;
    }
    else{
        
    }
    
    if (requiresMovementTowardsUser)
    {
        CLLocation* userLocation = [[CLLocation alloc] initWithLatitude:userLoc.latitude longitude:userLoc.longitude];
        CLLocation* zombLocation = [[CLLocation alloc] initWithLatitude:self.currentPosition .latitude longitude:self.currentPosition .longitude];
        
        double bearing = [MathHelpers bearingToLocation:userLocation   startLoc:zombLocation];
        
        CLLocationCoordinate2D newLocation = [MathHelpers coordinateFromCoord:zombLocation.coordinate atDistanceKm:finalMovement/1000 atBearingDegrees:bearing];
        
        [self.annotation setCoordinate:newLocation];
        self.currentPosition = newLocation;
        
        self.bearingToUser = bearing;
    }
    
    
  
    
}

-(void) checkIfCanSeeUser:(CLLocationCoordinate2D) userLocation
{
    CLLocation* userLoc = [[CLLocation alloc] initWithLatitude:userLocation.latitude longitude:userLocation.longitude];
    CLLocation* zombLoc = [[CLLocation alloc] initWithLatitude:self.currentPosition .latitude longitude:self.currentPosition .longitude];
    double distanceMeters = [zombLoc distanceFromLocation:userLoc];
    
    
    if(distanceMeters < ATTACK_VISIBILITY)
        self.zombieState.currentState = ZombieStateAttacking;
    else if (distanceMeters < CHASE_VISIBILITY)
        self.zombieState.currentState = ZombieStateChasing;
    else if (distanceMeters < ALERT_VISIBILITY)
        self.zombieState.currentState = ZombieStateAllerted;
    else
        self.zombieState.currentState = ZombieStateWandering;
}

@end
