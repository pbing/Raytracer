//
//  float4.h
//  Raytracer
//
//  Created by Bernd Beuster on 02.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/* Clang extention */
typedef float float4 __attribute__((ext_vector_type(4)));

/*
 * All vector functions are for a three element vector.
 * The type 'float4' is needed for SSE.
 */
extern float dot(float4 a,float4 b);
extern float4 cross(float4 a,float4 b);
extern float norm(float4 v);
extern float4 normalize(float4 v);