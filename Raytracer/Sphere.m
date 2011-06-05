//
//  Sphere.m
//  Raytracer
//
//  Created by Bernd Beuster on 27.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Sphere.h"

@implementation Sphere

@synthesize center,radius;

- (float)intersect:(Ray*)ray {
	float4 orig=[ray origin];
	float4 dir=[ray direction];
	
	/* calulate distance from center to ray origin */
	float4 tvec=orig-center;
	
	/* calculate discriminant */
	float a=dot(dir,dir);
	float b=2*dot(dir,tvec);
	float c=dot(tvec,tvec)-radius*radius;
	float discr=b*b-4*a*c;
	
	/* If discrimant is negative, the ray has missed the sphere. */
	if(discr<0.0f) return -1.0f;

	float sqrt_discr=sqrtf(discr);
	float q;
	
	if(b<0.0f)
		q=(-b+sqrt_discr)/(2*a);
	else
		q=(-b-sqrt_discr)/(2*a);
	
    float t0=q/a;
    float t1=c/q;
    return (t1<t0)?t1:t0;
}

- (float4)normalVector:(float4)surfacePoint {
    return normalize(surfacePoint-center);
}
@end
