//
//  Player.m
//  Chase Z
//
//  Created by James Coughlan on 02/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import "Player.h"

@implementation Player

#define HIT_POINTS 100.0
-(id) initWithLocation:(CLLocationCoordinate2D)location
{
    self = [self init];
    self.playerLocation = location;
    self.hitPoints = HIT_POINTS;
    self.playerState = [[PlayerState alloc]initWithState:PlayerStateWaitingForInitialisation];
    return self;
}

-(void) update:(CLLocationCoordinate2D) playerLoc
{
    self.playerLocation = playerLoc;
    
    //TODO check if he is being hit
}

@end
