//
//  Triangle.m
//  Raytracer
//
//  Created by Bernd Beuster on 27.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Triangle.h"

@implementation Triangle

@synthesize v0,v1,v2,u,v;

- (float)intersect:(Ray *)ray {
	float4 orig=[ray origin];
	float4 dir=[ray direction];
	
	float4 edge1,edge2,tvec,pvec,qvec;
	float det,inv_det;
	
	/* find vectors for two edges sharing vert0 */
	edge1=v1-v0;
	edge2=v2-v0;
	
	/* begin calulation determinant - also used to calculate U parameter */
	pvec=cross(dir,edge2);
	
	/* if determinant is near zero, ray lies on plane of triangle */
	det=dot(edge1,pvec);	
	if(det<0.0f) return -1.0;
	
	/* calulate distance from vert0 to ray origin */
	tvec=orig-v0;
	
	/*calculate U parameter and test bounds */
	u=dot(tvec,pvec);
	if(u<0.0f || u>det) return -1.0;
	
	/* prepare t test V parameter */
	qvec=cross(tvec,edge1);
	
	/* calculate V parameter and test bounds */
	v=dot(dir,qvec);
	if(v<0.0f || u+v>det) return -1.0;
	
	/* calculate t, scale parameters, ray intersects triangle */
	float t=dot(edge2,qvec);
	inv_det=1.0f/det;
	t*=inv_det;
	u*=inv_det;
	v*=inv_det;
	
    /* calulate intersection point */
	//intersectionPoint=t*dir+orig;

	/* calculate normal vector */
	//normalVector=
	return t;
}

- (float4)normalVector:(float4)surfacePoint {
    float4 edge1=v1-v0,edge2=v2-v0;
    return normalize(cross(edge1,edge2));
}
@end
