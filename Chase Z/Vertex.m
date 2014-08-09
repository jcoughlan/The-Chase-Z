//
//  Vertex.m
//  Chase Z
//
//  Created by James Coughlan on 07/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import "Vertex.h"

@implementation Vertex

-(id) initWithXYZ:(float)x y:(float)y z:(float)z
{
    self = [self init];
    self.x = x;
    self.y = y;
    self.z = z;
    return self;
}


@end
