//
//  Raytrace.h
//  Raytracer
//
//  Created by Bernd Beuster on 28.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Ray.h"
#import "RayColor.h"
#import "Light.h"
#import "Body.h"
#import "Sphere.h"
#import "Triangle.h"

#define MAX_RAYTRACE_RECURSION 8

@interface Raytrace : NSObject {
	int width;
	int height;
	int oversampling;
	
	NSMutableArray *scene;
	NSMutableArray *lights;
	id camera;

	NSBitmapImageRep *bitmap;
	NSColor *backgroundColor;
}
- (NSBitmapImageRep*)bitmap;

- (void)setWidth:(int)aWidth setHeight:(int)aHeight setOversampling:(int)aOversampling;
- (void)setWidth:(int)aWidth setHeight:(int)aHeight;
- (void)setScene:(NSMutableArray*)aScene setLights:(NSMutableArray*)theLights setCamera:(id)aCamera;
- (void)setBackgroundColor:(NSColor*)bgColor;

- (NSBitmapImageRep *)raytrace;
- (NSColor*)trace:(Ray*)ray;
- (NSColor*)shade:(Ray*)ray body:(Body*)body distanceToIntersection:(float)distance;
- (BOOL)occluded:(Ray*)ray distanceToLight:(float)distance;
@end
