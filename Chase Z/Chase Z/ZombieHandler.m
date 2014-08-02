//
//  NSObject+ZombieHandler.m
//  Chase Z
//
//  Created by James Coughlan on 01/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import "ZombieHandler.h"

//how far away the safe room is
#define SAFE_ROOM_DISTANCE 3000

//only draw zomboids to x metres
#define MAP_BOUNDS 2000

//only allow max x % of the map to be covered in zomboids
#define MAX_DENSITY 0.05

//ensure min of x % is covered by zomboids
#define MIN_DENSITY 0.025

@implementation ZombieHandler : NSObject

-(id) initWithUserLocation:(CLLocationCoordinate2D)userLoc
{
    self = [self init];
   // self.mapViewController = mapView;
    self.userLocation = userLoc;
    [self populateScene];
    return self;
}


-(void) populateScene
{
    //find out how many zombies we need
    float low = MIN_DENSITY;
    float high = MAX_DENSITY;
    float density = [MathHelpers randomFloatBetween:low and:high];
    NSLog(@"Zombie to map Density: %f", density);
    
    int zombieAmount = MAP_BOUNDS*density;
    NSLog(@"Total amount of Zombies: %d",zombieAmount);
    
    self.zombies = [[NSMutableArray alloc] init];
    
    //find out how high we can go up and down in both latitude and longitude from current userlocation
   
    CLLocationCoordinate2D location = self.userLocation;
    
    //convert distance to km
    double distance = MAP_BOUNDS/1000.0f;
    
    CLLocationCoordinate2D right = LatLonDestPoint(location, 90.0, distance);
    CLLocationCoordinate2D top = LatLonDestPoint(location, 0.0, distance);
    CLLocationCoordinate2D left = LatLonDestPoint(location, 270.0, distance);
    CLLocationCoordinate2D bottom = LatLonDestPoint(location, 180.0, distance);
    
    
    double maxDistance = 0;
    for (int i = 0; i < zombieAmount; i++)
    {
        //generate coordinates for said zomboids and add to array
        CLLocationCoordinate2D zLocation;
        zLocation.latitude = [MathHelpers randomFloatBetween:top.latitude and:bottom.latitude];
        zLocation.longitude = [MathHelpers randomFloatBetween:left.longitude and:right.longitude];
        [self.zombies addObject:[[Zombie alloc]initWithPosition:(zLocation)]];
        
        CLLocation* userLoc = [[CLLocation alloc] initWithLatitude:self.userLocation.latitude longitude:self.userLocation.longitude];
        CLLocation* zombLoc = [[CLLocation alloc] initWithLatitude:zLocation.latitude longitude:zLocation.longitude];
        double distanceMeters = [zombLoc distanceFromLocation:userLoc];
       if (distanceMeters > maxDistance)
           maxDistance = distanceMeters;
    }
    NSLog(@"Highest distance from user %f", maxDistance);
    
    
    //set up safe room location
    
    //first get a random bearing
    double bearing = [MathHelpers randomFloatBetween:0.0 and:360.0];
    CLLocationCoordinate2D safeRoomLocation = [MathHelpers coordinateFromCoord:self.userLocation atDistanceKm:SAFE_ROOM_DISTANCE/1000.0 atBearingDegrees:bearing];
    self.safeRoom = [[SafeRoom alloc] initWithLocation:safeRoomLocation];
    
    self.player = [[Player alloc] initWithLocation:self.userLocation];
}

-(void) update:(CLLocationCoordinate2D) userLoc
{
    self.userLocation = userLoc;
    for (int i = 0 ; i < self.zombies.count; i++)
    {
        [[self.zombies objectAtIndex:i] update:userLoc];
    }
    
    [self.player update:userLoc];
    
    [self.safeRoom update:userLoc];
}

@end
