//
//  Ray.h
//  Raytracer
//
//  Created by Bernd Beuster on 27.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "float4.h"

@interface Ray : NSObject {
	float4 origin,direction;
}

@property float4 origin,direction;

- (id)initWithOrigin:(float4)anOrigin direction:(float4)aDirection;
- (float4)pointOnRay:(float)t;
@end
