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

@end
