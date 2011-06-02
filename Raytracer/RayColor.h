//
//  SRGBColor.h
//  Raytracer
//
//  Created by Bernd Beuster on 29.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSColor (RayColor)

- (NSColor*) sRGBColor;

- (NSColor*) addColor:(NSColor*)color;
- (NSColor*) addColor:(NSColor*)color1 color:(NSColor*)color2;

@end
