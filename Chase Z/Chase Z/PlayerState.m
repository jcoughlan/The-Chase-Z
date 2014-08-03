//
//  PlayerState.m
//  Chase Z
//
//  Created by James Coughlan on 03/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import "PlayerState.h"

@implementation PlayerState
-(id) initWithState:(PlayerStateType) state
{
    self = [self init];
    self.currentState = state;
    return self;
}
@end
