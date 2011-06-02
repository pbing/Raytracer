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

- (float4)origin;
- (float4)direction;

- (void)setOrigin:(float4)anOrigin;
- (void)setDirection:(float4)aDirection;

@end
