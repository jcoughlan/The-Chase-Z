//
//  PlayerState.h
//  Chase Z
//
//  Created by James Coughlan on 03/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum PlayerStateType : NSInteger PlayerStateType;
enum PlayerStateType : NSInteger {
    PlayerStateWaitingForInitialisation,
    PlayerStatePlaying,
    PlayerStatePaused
};

@interface PlayerState : NSObject
-(id) initWithState:(PlayerStateType) state;

@property PlayerStateType currentState;
@end
