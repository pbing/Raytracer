//
//  Light.h
//  Raytracer
//
//  Created by Bernd Beuster on 29.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Light : NSObject {
	float location[3];
	NSColor *color;
}

-(float*)location;
-(NSColor*)color;
-(void) setLocation:(float[3])loc;
-(void) setColor:(NSColor*)col;
@end
