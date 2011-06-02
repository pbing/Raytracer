//
//  Body.m
//  Raytracer
//
//  Created by Bernd Beuster on 28.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Body.h"


@implementation Body

- (id) init {
	[super init];
	
	/* default: only ambient shading */
	ka=1.0;
	kd=0.0;
	ks=0.0;
	alpha=0.0;

	return self;
}

- (float)t {return t;}

- (float4)normalVector {return normalVector;}

- (float)ka {return ka;}
	
- (float)kd {return kd;}

- (float)ks {return ks;}

- (float)alpha {return alpha;}

- (void)setKa:(float)a {ka=a;}

- (void)setKd:(float)d {kd=d;}

- (void)setKs:(float)s {ks=s;}

- (void)setAlpha:(float)a {alpha=a;}

- (NSColor*)color {return color;}

- (void)setColor:(NSColor*)c {
	color=[c colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
}

- (BOOL)intersect:(Ray*)ray {return FALSE;}

@end
