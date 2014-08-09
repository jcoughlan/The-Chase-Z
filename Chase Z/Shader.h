//
//  Shader.h
//  Chase Z
//
//  Created by James Coughlan on 07/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenGLData.h"

@interface Shader : NSObject

-(id) initWithOpenGLData:(OpenGLData*) data;

@property OpenGLData* openGlData;
//+(void) CompileShaders;

@end
