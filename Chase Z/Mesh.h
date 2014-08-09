//
//  Model.h
//  Chase Z
//
//  Created by James Coughlan on 06/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shader.h"
#import "Vertex.h"
#import "Indices.h"
@interface Mesh : NSObject
{
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
}

-(id) initMesh;
- (void)setupVBOs;
-(void) draw;

-(GLuint*) getVBO;

@property NSArray* vertices;
@property NSArray* indices;
@property float* vertexArray;
@property GLubyte* indexArray;

@end
