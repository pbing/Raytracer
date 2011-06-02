//
//  Triangle.m
//  Raytracer
//
//  Created by Bernd Beuster on 27.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Triangle.h"

#define CROSS(dest,v1,v2) \
	dest[0]=v1[1]*v2[2]-v1[2]*v2[1]; \
	dest[1]=v1[2]*v2[0]-v1[0]*v2[2]; \
	dest[2]=v1[0]*v2[1]-v1[1]*v2[0]

#define DOT(v1,v2) (v1[0]*v2[0]+v1[1]*v2[1]+v1[2]*v2[2])

#define SUB(dest,v1,v2) \
	dest[0]=v1[0]-v2[0]; \
	dest[1]=v1[1]-v2[1]; \
	dest[2]=v1[2]-v2[2]

#define SMUL(dest,v1,s) \
	dest[0]=s*v1[0]; \
	dest[1]=s*v1[1]; \
	dest[2]=s*v1[2]

@implementation Triangle

- (float)u {return u;}

- (float)v {return v;}

- (void)setV0:(float[3])p {
	v0[0]=p[0];
	v0[1]=p[1];
	v0[2]=p[2];
}

- (void)setV1:(float[3])p {
	v1[0]=p[0];
	v1[1]=p[1];
	v1[2]=p[2];
}

- (void)setV2:(float[3])p {
	v2[0]=p[0];
	v2[1]=p[1];
	v2[2]=p[2];
}

- (BOOL)intersect:(Ray *)ray {
	float *orig=[ray origin];
	float *dir=[ray direction];
	
	float edge1[3],edge2[3],tvec[3],pvec[3],qvec[3];
	float det,inv_det;
	
	/* find vectors for two edges sharing vert0 */
	SUB(edge1,v1,v0);
	SUB(edge2,v2,v0);
	
	/* begin calulation determinant - also used to calculate U parameter */
	CROSS(pvec,dir,edge2);
	
	/* if determinant is near zero, ray lies on plane of triangle */
	det=DOT(edge1,pvec);	
	if(det<0.0)	return FALSE;
	
	/* calulate distance from vert0 to ray origin */
	SUB(tvec,orig,v0);
	
	/*calculate U parameter and test bounds */
	u=DOT(tvec,pvec);
	if(u<0.0 || u>det) return FALSE;
	
	/* prepare t test V parameter */
	CROSS(qvec,tvec,edge1);
	
	/* calculate V parameter and test bounds */
	v=DOT(dir,qvec);
	if(v<0.0 || u+v>det) return FALSE;
	
	/* calculate t, scale parameters, ray intersects triangle */
	t=DOT(edge2,qvec);
	inv_det=1.0/det;
	t*=inv_det;
	u*=inv_det;
	v*=inv_det;
	
	/* calculate normal vector */
	float nvec[3];
	CROSS(nvec,edge1,edge2);
	
	/* nomalize */
	float scale=1.0/sqrtf(DOT(nvec,nvec));
	SMUL(normalVector,nvec,scale);
	
	return TRUE;
}

@end
