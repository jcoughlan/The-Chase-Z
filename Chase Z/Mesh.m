//
//  Model.m
//  Chase Z
//
//  Created by James Coughlan on 06/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import "Mesh.h"

@implementation Mesh


-(id) initMesh;
{
    self = [self init];    return self;
}

-(void) draw
{
    
}

-(GLuint*) getVBO
{
    return &_vertexBuffer;
}

-(GLuint) getIBO
{
    return _indexBuffer;
}


- (void)setupVBOs {
    
    float *vertArray = malloc([self.vertices count] * sizeof(float) * 3);
    int index = 0;
    for (int i = 0; i < self.vertices.count; i++)
    {
        vertArray[index++] = [[self.vertices objectAtIndex:i]x];
        vertArray[index++] = [[self.vertices objectAtIndex:i]y];
        vertArray[index++] = [[self.vertices objectAtIndex:i]z];
    }
    self.vertexArray = vertArray;
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertArray), vertArray, GL_STATIC_DRAW);
    
    index = 0;
    GLubyte* indices = malloc([self.indices count] * sizeof(GLubyte));
    for (int i = 0 ; i < self.indices.count; i++)
    {
        indices[index++] = [[self.indices objectAtIndex:i] number];
    }
   // GLuint indexBuffer = self._indexBuffer;
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    self.indexArray = indices;
}

@end
