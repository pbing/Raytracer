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

- (void)setOrigin:(float[3])anOrigin {
	origin[0]=anOrigin[0];
	origin[1]=anOrigin[1];
	origin[2]=anOrigin[2];
}

- (void)setDirection:(float[3])aDirection {
	float vv=aDirection[0]*aDirection[0]+aDirection[1]*aDirection[1]+aDirection[2]*aDirection[2];
	float scale=1.0/sqrtf(vv);
	
	direction[0]=scale*aDirection[0];
	direction[1]=scale*aDirection[1];
	direction[2]=scale*aDirection[2];
}

@end
