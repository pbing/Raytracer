//
//  Raytrace.h
//  Raytracer
//
//  Created by Bernd Beuster on 28.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Ray.h"
#import "Body.h"
#import "Light.h"

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
- (NSColor*)shade:(Ray*)ray body:(Body*)body;

- (NSColor*)phongIllumination:(Ray*)ray body:(Body*)body light:(Light*)light;
@end
