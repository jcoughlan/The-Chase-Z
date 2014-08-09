//
//  Shader.m
//  Chase Z
//
//  Created by James Coughlan on 07/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import "Shader.h"

@implementation Shader


-(id) initWithOpenGLData:(OpenGLData*) data
{
    self = [self init];
    
    self.openGlData = data;
    [self CompileShaders];
    return self;
    
}


- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
    
    // 1
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"glsl"];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    // 2
    GLuint shaderHandle = glCreateShader(shaderType);
    
    // 3
    const char * shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    // 4
    glCompileShader(shaderHandle);
    
    // 5
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    return shaderHandle;
    
}

-(void) CompileShaders
{
    
    // 1
    GLuint vertexShader = [self compileShader:@"ShaderVertex" withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"ShaderFragment" withType:GL_FRAGMENT_SHADER];
    
    // 2
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    
    // 3
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    // 4
    glUseProgram(programHandle);
    
    // 5
self.openGlData._positionSlot = glGetAttribLocation(programHandle, "Position");
  //  self.openGlData._colorSlot = glGetAttribLocation(programHandle, "SourceColor");
    glEnableVertexAttribArray(self.openGlData._positionSlot);
    //glEnableVertexAttribArray(self.openGlData._colorSlot);
    
    self.openGlData._projectionUniform = glGetUniformLocation(programHandle, "Projection");
    self.openGlData._modelViewUniform = glGetUniformLocation(programHandle, "Modelview");
    
   // self.openGlData._texCoordSlot = glGetAttribLocation(programHandle, "TexCoordIn");
    //glEnableVertexAttribArray(self.openGlData._texCoordSlot);
    //self.openGlData._textureUniform = glGetUniformLocation(programHandle, "Texture");
    
}
@end
