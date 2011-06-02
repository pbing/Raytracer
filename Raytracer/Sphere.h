//
//  Sphere.h
//  Raytracer
//
//  Created by Bernd Beuster on 27.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Body.h"
#import "Ray.h"


@interface Sphere : Body {
	float center[3];
	float radius;
}

- (void)setCenter:(float*)c;
- (void)setRadius:(float)r;
- (BOOL)intersect:(Ray*)ray;
@end
