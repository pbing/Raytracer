//
//  Body.m
//  Raytracer
//
//  Created by Bernd Beuster on 28.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Body.h"


@implementation Body

@synthesize kDiff,kSpec,alpha,beta,cRefl;

- (id) init {
	[super init];
	
	/* default: only ambient shading */
	kDiff=0.0;
	kSpec=0.0;
	alpha=0.0;
	beta=0.0;
    cRefl=0.0;

    [self setColor:[NSColor whiteColor]];
	return self;
}

- (NSColor*)color {return color;}

- (void)setColor:(NSColor*)aColor {
	color=[aColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
}

- (float)intersect:(Ray*)ray {return -1.0f;}

- (float4)normalVector:(float4)surfacePoint {return (float4){0.0,0.0,0.0,0.0};}

@end
