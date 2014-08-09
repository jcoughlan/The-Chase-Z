//
//  OpenGLView.h
//  HelloOpenGL
//
//  Created by Ray Wenderlich on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

#include "Shader.h"
#include "Line.h"

@interface OpenGLView : UIView {
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    OpenGLData* openGlData;
    Shader* shaderManager;
    Line* line;
    
    GLuint _colorRenderBuffer;
    GLuint _depthRenderBuffer;
}



@end
