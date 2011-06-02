//
//  Ray.m
//  Raytracer
//
//  Created by Bernd Beuster on 27.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <math.h>
#import "Ray.h"


@implementation Ray

- (float*)origin {return origin;}

- (float*)direction {return direction;}

- (void)setOrigin:(float[3])v {
	origin[0]=v[0];
	origin[1]=v[1];
	origin[2]=v[2];
}

- (void)setDirection:(float[3])v {
	float vv=v[0]*v[0]+v[1]*v[1]+v[2]*v[2];
	float scale=1.0/sqrt(vv);
	
	direction[0]=scale*v[0];
	direction[1]=scale*v[1];
	direction[2]=scale*v[2];
}

@end
