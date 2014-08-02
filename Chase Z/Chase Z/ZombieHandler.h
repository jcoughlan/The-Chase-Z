//
//  NSObject+ZombieHandler.h
//  Chase Z
//
//  Created by James Coughlan on 01/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Zombie.h"
#import "MathHelpers.h"
#import "SafeRoom.h"
#import "Player.h"
//#import "MapViewController.h"
@interface  ZombieHandler : NSObject

-(id) initWithUserLocation:(CLLocationCoordinate2D) userLoc;

-(void) update:(CLLocationCoordinate2D) userLoc;
@property (strong, nonatomic) NSMutableArray* zombies;
@property CLLocationCoordinate2D userLocation;
@property SafeRoom* safeRoom;
@property Player* player;
//@property (strong, nonatomic) MapViewController* mapViewController;
@end
