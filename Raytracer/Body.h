//
//  Body.h
//  Raytracer
//
//  Created by Bernd Beuster on 28.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Ray.h"


@interface Body : NSObject {
	NSColor *color;
	float kDiff; // diffuse reflection factor
	float kSpec; // specular reflection factor
	float alpha; // shininess
    float cRefl; // reflection coefficient
}

@property float kDiff,kSpec,alpha,cRefl;

- (NSColor*)color;
- (void)setColor:(NSColor*)aColor;

- (float)intersect:(Ray*)ray;
- (float4)normalVector:(float4)intersectionPoint;

@end
