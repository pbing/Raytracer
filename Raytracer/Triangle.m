//
//  Triangle.m
//  Raytracer
//
//  Created by Bernd Beuster on 27.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Triangle.h"

@implementation Triangle

- (float)u {return u;}

- (float)v {return v;}

- (void)setV0:(float4)p {v0=p;}

- (void)setV1:(float4)p {v1=p;}

- (void)setV2:(float4)p {v2=p;}

- (BOOL)intersect:(Ray *)ray {
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
	if(det<0.0f) return FALSE;
	
	/* calulate distance from vert0 to ray origin */
	tvec=orig-v0;
	
	/*calculate U parameter and test bounds */
	u=dot(tvec,pvec);
	if(u<0.0f || u>det) return FALSE;
	
	/* prepare t test V parameter */
	qvec=cross(tvec,edge1);
	
	/* calculate V parameter and test bounds */
	v=dot(dir,qvec);
	if(v<0.0f || u+v>det) return FALSE;
	
	/* calculate t, scale parameters, ray intersects triangle */
	t=dot(edge2,qvec);
	inv_det=1.0f/det;
	t*=inv_det;
	u*=inv_det;
	v*=inv_det;
	
	/* calculate normal vector */
	normalVector=normalize(cross(edge1,edge2));

	return TRUE;
}

@end
