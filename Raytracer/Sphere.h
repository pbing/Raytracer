//
//  Sphere.h
//  Raytracer
//
//  Created by Bernd Beuster on 27.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "float4.h"
#import "Body.h"
#import "Ray.h"


@interface Sphere : Body {
	float4 center;
	float radius;
}

- (void)setCenter:(float4)aCenter;
- (void)setRadius:(float)aRadius;
- (BOOL)intersect:(Ray*)ray;
@end
