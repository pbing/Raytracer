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
	self=[super init];
	
	[self setLocation:(float4){0.0,0.0,0.0,0.0}];
	[self setColor:[NSColor whiteColor]];
	 
	return self;
}

@synthesize location;

-(NSColor*)color {return color;}

-(void) setColor:(NSColor*)aColor {
    color=[aColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
}

@end
