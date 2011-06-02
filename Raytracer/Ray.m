//
//  Ray.m
//  Raytracer
//
//  Created by Bernd Beuster on 27.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Ray.h"

@implementation Ray

- (float4)origin {return origin;}

- (float4)direction {return direction;}

- (void)setOrigin:(float4)anOrigin {origin=anOrigin;}

- (void)setDirection:(float4)aDirection {direction=normalize(aDirection);}

@end
