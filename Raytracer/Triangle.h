//
//  Triangle.h
//  Raytracer
//
//  Created by Bernd Beuster on 27.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "float4.h"
#import "Body.h"
#import "Ray.h"

@interface Triangle : Body {
	float4 v0,v1,v2;
	float u,v;
}

@property float4 v0,v1,v2;
@property (readonly) float u,v;

@end
