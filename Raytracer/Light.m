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
	
	[self setLocation:(float[3]){0.0,0.0,0.0}];
	[self setColor:[[NSColor whiteColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace]];
	 
	return self;
}

-(float*)location {return location;}

-(NSColor*)color {return color;}

-(void) setLocation:(float[3])loc {
	location[0]=loc[0];
	location[1]=loc[1];
	location[2]=loc[2];
}

-(void) setColor:(NSColor*)col {color=col;}

@end
