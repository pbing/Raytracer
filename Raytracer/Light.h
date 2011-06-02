//
//  Light.h
//  Raytracer
//
//  Created by Bernd Beuster on 29.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "float4.h"

@interface Light : NSObject {
	float4 location;
	NSColor *color;
}

-(float4)location;
-(NSColor*)color;
-(void) setLocation:(float4)aLocation;
-(void) setColor:(NSColor*)aColor;
@end
