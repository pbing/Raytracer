//
//  Light.m
//  Raytracer
//
//  Created by Bernd Beuster on 29.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Light.h"


@implementation Light

-(id) init {
	[super init];
	
	[self setLocation:(float4){0.0,0.0,0.0,0.0}];
	[self setColor:[[NSColor whiteColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace]];
	 
	return self;
}

-(float4)location {return location;}

-(NSColor*)color {return color;}

-(void) setLocation:(float4)aLocation {location=aLocation;}

-(void) setColor:(NSColor*)aColor {color=aColor;}

@end
