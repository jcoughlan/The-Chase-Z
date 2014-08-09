//
//  Vertex.h
//  Chase Z
//
//  Created by James Coughlan on 07/08/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vertex : NSObject
-(id) initWithXYZ:(float)x y:(float)y z:(float)z;

@property float x;
@property float y;
@property float z;
@end
