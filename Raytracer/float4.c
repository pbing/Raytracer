//
//  float4.c
//  Raytracer
//
//  Created by Bernd Beuster on 02.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include <math.h>
#include "float4.h"

/* dot product a•b */
inline float dot(float4 a,float4 b) {
    float4 c=a*b;
    return c.x+c.y+c.z;
}

/* cross product a×b */
inline float4 cross(float4 a,float4 b) {
    float4 a1=__builtin_shufflevector(a,a,1,2,0,3);
    float4 b1=__builtin_shufflevector(b,b,2,0,1,3);
    float4 c1=a1*b1;
    
    float4 a2=__builtin_shufflevector(a,a,2,0,1,3);
    float4 b2=__builtin_shufflevector(b,b,1,2,0,3);
    float4 c2=a2*b2;
    
    return c1-c2;
}

/* norm (lenght) of vector */
inline float norm(float4 v) {
    return sqrtf(dot(v,v));
}

/* normalize vector */
inline float4 normalize(float4 v) {
    return v/norm(v);
}