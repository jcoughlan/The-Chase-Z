//
//  Shader.fsh
//  Chase Z
//
//  Created by James Coughlan on 30/07/2014.
//  Copyright (c) 2014 James Coughlan. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
