//
//  Ray.m
//  Raytracer
//
//  Created by Bernd Beuster on 27.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Ray.h"

@implementation Ray

- (id)initWithOrigin:(float4)anOrigin direction:(float4)aDirection {
    [super init];
    
    origin=anOrigin;
    direction=aDirection;
    
    return self;
}
@synthesize origin,direction;

- (float4)pointOnRay:(float)t {return t*direction+origin;}
@end
