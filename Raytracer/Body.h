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
	float t;
	float normalVector[3];
	
	NSColor *color;
	float ka;    // ambient reflection factor
	float kd;    // diffuse reflection factor
	float ks;    // specular reflection factor
	float alpha; // shininess
}

- (float)t;
- (float*)normalVector;

- (NSColor*)color;
- (float)ka;
- (float)kd;
- (float)ks;
- (float)alpha;

- (void)setColor:(NSColor*)c;
- (void)setKa:(float)a;
- (void)setKd:(float)d;
- (void)setKs:(float)s;
- (void)setAlpha:(float)a;

- (BOOL)intersect:(Ray*)ray;
@end
