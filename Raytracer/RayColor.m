//
//  RayColor.m
//  Raytracer
//
//  Created by Bernd Beuster on 29.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RayColor.h"

/* sRGB gamma correction. */
static inline float sRGBGamma(float color) {
	if(color>0.0031308f)
		return 1.055f*powf(color,1.0f/2.4f)-0.055f;
	else
		return 12.92f*color;
}	


@implementation NSColor (RayColor)

+ (NSColor*)colorWithSRGBGammaRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
	return [NSColor colorWithCalibratedRed:sRGBGamma(red) green:sRGBGamma(green) blue:sRGBGamma(blue) alpha:alpha];
}

@end
