//
//  Sphere.m
//  Raytracer
//
//  Created by Bernd Beuster on 27.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <math.h>
#import "Sphere.h"

#define DOT(v1,v2) (v1[0]*v2[0]+v1[1]*v2[1]+v1[2]*v2[2])

#define ADD(dest,v1,v2) \
	dest[0]=v1[0]+v2[0]; \
	dest[1]=v1[1]+v2[1]; \
	dest[2]=v1[2]+v2[2]

#define SUB(dest,v1,v2) \
	dest[0]=v1[0]-v2[0]; \
	dest[1]=v1[1]-v2[1]; \
	dest[2]=v1[2]-v2[2]

#define SMUL(dest,v1,s) \
	dest[0]=s*v1[0]; \
	dest[1]=s*v1[1]; \
	dest[2]=s*v1[2]

@implementation Sphere

- (void)setCenter:(float*)c {
	center[0]=c[0];
	center[1]=c[1];
	center[2]=c[2];
}

- (void)setRadius:(float)r {radius=r;}

//- (float)t {return t;}

- (BOOL)intersect:(Ray*)ray {
	float *orig=[ray origin];
	float *dir=[ray direction];
	
	float tvec[3];
	
	/* calulate distance from center to ray origin */
	SUB(tvec,orig,center);
	
	/* calculate discriminant */
	float a=DOT(dir,dir);
	float b=2*DOT(dir,tvec);
	float c=DOT(tvec,tvec)-radius*radius;
	float discr=b*b-4*a*c;
	
	/* if discrimant is negative, he ray has missed the sphere */
	if(discr<0.0) return FALSE;

	float sqrt_discr=sqrtf(discr);
	float q;
	
	if(b<0.0)
		q=(-b+sqrt_discr)/(2.0*a);
	else
		q=(-b-sqrt_discr)/(2.0*a);
	
    float t0=q/a;
    float t1=c/q;
	
    /* 
	 * If t1 is less than zero, the object is in the ray's negative direction
	 * and consequently the ray misses the sphere. 
	 */
    if(t1<0) return FALSE;
	
    if(t1<t0) t=t1; else t=t0;

	/* calculate normal vector */
	float ivec[3]; // intersection
	SMUL(ivec,dir,t);
	ADD(ivec,ivec,orig);
	
	float nvec[3]; // normal vector
	SUB(nvec,ivec,center);
	float scale=1.0/sqrtf(DOT(nvec,nvec));
	SMUL(normalVector,nvec,scale);

	return TRUE;	
}

@end
