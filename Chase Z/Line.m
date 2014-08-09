//
//  Line.m
//  Chase Z
//
//  Created by James Coughlan on 07/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import "Line.h"

@implementation Line
-(id) initWithOrigin: (Vertex*)from to:(Vertex*)to;
{
    self = [self init];
    self.mesh = [[Mesh alloc] initMesh];
    self.mesh.vertices = [[NSArray alloc] initWithObjects:to, from, nil];
    self.mesh.indices = [[NSArray alloc] initWithObjects:0,1, nil];
    
    [self.mesh setupVBOs];
    return self;
}

-(void) draw:(OpenGLData*) openglData
{
   // [self.mesh draw];
    
    GLuint* vertexBuffer =  [self.mesh getVBO];
    glBindBuffer(GL_ARRAY_BUFFER, *vertexBuffer);
    //glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self.mesh._indexBuffer);
    
    // 2
    glVertexAttribPointer(openglData._positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(self.mesh.vertexArray), 0);
    //glVertexAttribPointer(openglData._colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(self.mesh.vertexArray), (GLvoid*) (sizeof(float) * 3));
    
   // glVertexAttribPointer(openglData._texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(self.mesh.vertexArray), (GLvoid*) (sizeof(float) * 7));
    
    //glActiveTexture(GL_TEXTURE0);
    //glBindTexture(GL_TEXTURE_2D, openglData._floorTexture);
   // glUniform1i(openglData._textureUniform, 0);
    
    // 3
    
//    for (int i  = 0; i < 6; i++)
//        NSLog(@"%d : %f", i,self.mesh.vertexArray[i]);
    glDrawArrays(GL_LINES, 0, 6);
    //glDrawElements(GL_LINES, sizeof(self.mesh.indices)/sizeof(self.mesh.indices[0]), GL_UNSIGNED_BYTE, 0);

}

@end
