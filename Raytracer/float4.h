//
//  float4.h
//  Raytracer
//
//  Created by Bernd Beuster on 02.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

typedef float float4 __attribute__((ext_vector_type(4)));

inline float dot(float4 a,float4 b);
inline float4 cross(float4 a,float4 b);
inline float4 normalize(float4 v);