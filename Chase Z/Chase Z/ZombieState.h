//
//  ZombieState.h
//  Chase Z
//
//  Created by James Coughlan on 03/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum ZombieStateType : NSInteger ZombieStateType;
enum ZombieStateType : NSInteger {
    ZombieStateWaitingForInitialisation,
    ZombieStateWandering,
    ZombieStateAllerted,
    ZombieStateAttacking,
    ZombieStateChasing
};

@interface ZombieState : NSObject

-(id) initWithState:(ZombieStateType) state;

@property ZombieStateType currentState;

@end
