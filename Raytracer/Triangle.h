//
//  Triangle.h
//  Raytracer
//
//  Created by Bernd Beuster on 27.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Body.h"
#import "Ray.h"

@interface Triangle : Body {
	float v0[3],v1[3],v2[3];
	float u,v;
}

- (float)u;
- (float)v;

- (void)setV0:(float[3])p;
- (void)setV1:(float[3])p;
- (void)setV2:(float[3])p;

- (BOOL)intersect:(Ray *)ray;
@end
