//
//  OpenGLData.h
//  Chase Z
//
//  Created by James Coughlan on 07/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

@interface OpenGLData : NSObject

    
    @property GLuint _positionSlot;
    @property GLuint _projectionUniform;
    @property GLuint _modelViewUniform;
    @property float _currentRotation;

@end
