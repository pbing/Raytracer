//
//  float4.c
//  Raytracer
//
//  Created by Bernd Beuster on 02.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include <math.h>
#include "float4.h"

float dot(float4 a,float4 b) {
    float4 c=a*b;
    return c.x+c.y+c.z;
}

float4 cross(float4 a,float4 b) {
    float4 a1=__builtin_shufflevector(a,a,1,2,0,3);
    float4 b1=__builtin_shufflevector(b,b,2,0,1,3);
    float4 c1=a1*b1;
    
    float4 a2=__builtin_shufflevector(a,a,2,0,1,3);
    float4 b2=__builtin_shufflevector(b,b,1,2,0,3);
    float4 c2=a2*b2;
    
    return c1-c2;
}

float4 normalize(float4 v) {
    float scale=1.0f/sqrtf(dot(v,v));
    return scale*v;
}