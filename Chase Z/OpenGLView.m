//
//  OpenGLView.m
//  HelloOpenGL
//
//  Created by Ray Wenderlich on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OpenGLView.h"
#import "CC3GLMatrix.h"

@implementation OpenGLView


#define TEX_COORD_MAX   4



+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)setupLayer {
    _eaglLayer = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque = YES;
}

- (void)setupContext {
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}

- (void)setupRenderBuffer {
   // GLuint colourRenderBuffer = openGlData._colorRenderBuffer;
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER,_colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}

- (void)setupDepthBuffer {
   
    glGenRenderbuffers(1, &_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);
}

- (void)setupFrameBuffer {
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
}



- (void)render:(CADisplayLink*)displayLink {
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    glClearColor(1.0f, 1.0f, 1.0f, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    
    CC3GLMatrix *projection = [CC3GLMatrix matrix];
    //float h = 4.0f * self.frame.size.height / self.frame.size.width;
    [projection populateFromFrustumLeft:-100  andRight:100 andBottom:-100 andTop:100 andNear:-1 andFar:10];
    glUniformMatrix4fv(openGlData._projectionUniform, 1, 0, projection.glMatrix);
    
    CC3GLMatrix *modelView = [CC3GLMatrix matrix];
    [modelView populateIdentity];
    [modelView populateFromTranslation:CC3VectorMake(1,1,1)];
    //openGlData._currentRotation += displayLink.duration * 90;
    //[modelView rotateBy:CC3VectorMake(openGlData._currentRotation, openGlData._currentRotation, 0)];
    glUniformMatrix4fv(openGlData._modelViewUniform, 1, 0, modelView.glMatrix);
    
    // 1
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
   [line draw:openGlData];
     
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)setupDisplayLink {
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    openGlData = [[OpenGLData alloc] init];
    if (self) {
        [self setupLayer];
        [self setupContext];
        [self setupDepthBuffer];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        shaderManager = [[Shader alloc]initWithOpenGLData:openGlData];
        //init models
        Vertex* a = [[Vertex alloc]initWithXYZ:0 y:0 z:0];
        Vertex* b = [[Vertex alloc]initWithXYZ:9 y:89 z:9];

        line = [[Line alloc]initWithOrigin:a to:b];
        //[self setupVBOs];
        
        [self setupDisplayLink];
    }
    return self;
}

- (void)dealloc
{
    //[_context release];
    _context = nil;
    //[super dealloc];
}

@end
