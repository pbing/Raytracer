//
//  SRGBColor.m
//  Raytracer
//
//  Created by Bernd Beuster on 29.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RayColor.h"

/* sRGB gamma correction. */
float sRGBGamma(float color) {
	if(color>0.0031308f)
		return 1.055f*powf(color,1.0f/2.4f)-0.055f;
	else
		return 12.92f*color;
}	


@implementation NSColor (RayColor)

- (NSColor*) sRGBColor {
	return [NSColor colorWithCalibratedRed:sRGBGamma([self redComponent])
									 green:sRGBGamma([self greenComponent])
									  blue:sRGBGamma([self blueComponent])
									 alpha:1.0];
}

- (NSColor*) addColor:(NSColor*)color {
	return [self addColor:self color:color];
}

- (NSColor*) addColor:(NSColor*)color1 color:(NSColor*)color2 {
	float   red=[color1   redComponent]+[color2  redComponent];
	float green=[color1 greenComponent]+[color2 greenComponent];
	float  blue=[color1  blueComponent]+[color2  blueComponent];
	
	return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:1.0];
}

@end
