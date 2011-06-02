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

- (void)setWidth:(int)w setHeight:(int)h setOversampling:(int)o;
- (void)setWidth:(int)w setHeight:(int)h;
- (void)setScene:(NSMutableArray*)scn setLights:(NSMutableArray*)lgts setCamera:(id)cam;
- (void)setBackgroundColor:(NSColor*)bgcolor;

- (NSBitmapImageRep *)raytrace;
- (NSColor*)trace:(Ray*)ray;
- (NSColor*)shade:(Ray*)ray body:(Body*)b;

- (NSColor*)phongIllumination:(Ray*)ray body:(Body*)bdy light:(Light*)lgt;
@end
