//
//  RayColor.h
//  Raytracer
//
//  Created by Bernd Beuster on 29.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSColor (RayColor)

+ (NSColor*)colorWithSRGBGammaRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

@end
