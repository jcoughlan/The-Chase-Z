//
//  Line.h
//  Chase Z
//
//  Created by James Coughlan on 07/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mesh.h"

@interface Line : NSObject

-(id) initWithOrigin: (Vertex*)from to:(Vertex*) to;
-(void) draw:(OpenGLData*) openglData;

@property Mesh* mesh;

@end
