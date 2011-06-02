//
//  Sphere.m
//  Raytracer
//
//  Created by Bernd Beuster on 27.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Sphere.h"

@implementation Sphere

- (void)setCenter:(float4)aCenter {center=aCenter;}

- (void)setRadius:(float)aRadius {radius=aRadius;}

- (BOOL)intersect:(Ray*)ray {
	float4 orig=[ray origin];
	float4 dir=[ray direction];
	
	/* calulate distance from center to ray origin */
	float4 tvec=orig-center;
	
	/* calculate discriminant */
	float a=dot(dir,dir);
	float b=2*dot(dir,tvec);
	float c=dot(tvec,tvec)-radius*radius;
	float discr=b*b-4*a*c;
	
	/* if discrimant is negative, he ray has missed the sphere */
	if(discr<0.0f) return FALSE;

	float sqrt_discr=sqrtf(discr);
	float q;
	
	if(b<0.0f)
		q=(-b+sqrt_discr)/(2*a);
	else
		q=(-b-sqrt_discr)/(2*a);
	
    float t0=q/a;
    float t1=c/q;
	
    /* 
	 * If t1 is less than zero, the object is in the ray's negative direction
	 * and consequently the ray misses the sphere. 
	 */
    if(t1<0.0f) return FALSE;
	
    if(t1<t0) t=t1; else t=t0;

	/* calculate normal vector */
	float4 ivec=t*dir+orig; // intersection
	
	float4 nvec=ivec-center; // normal vector
	float scale=1.0/sqrtf(dot(nvec,nvec));
	float4 normal=scale*nvec;
    normalVector[0]=normal.x;
    normalVector[1]=normal.y;
    normalVector[2]=normal.z;

	return TRUE;	
}

@end
