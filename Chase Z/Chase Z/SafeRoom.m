//
//  SafeRoom.m
//  Chase Z
//
//  Created by James Coughlan on 02/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import "SafeRoom.h"

@implementation SafeRoom

-(id) initWithLocation: (CLLocationCoordinate2D) location
{
    self = [self init];
    self.safeRoomLocation = location;
    return self;
}

@end
