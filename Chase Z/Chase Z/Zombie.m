//
//  Zombie.m
//  Chase Z
//
//  Created by James Coughlan on 02/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import "Zombie.h"

@implementation Zombie

-(id) initWithPosition:(CLLocationCoordinate2D) position
{
    self = [self init];
    self.currentPosition = position;
    return self;
}


@end
