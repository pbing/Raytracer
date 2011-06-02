//
//  Ray.h
//  Raytracer
//
//  Created by Bernd Beuster on 27.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Ray : NSObject {
	float origin[3],direction[3];
}

- (float*)origin;
- (float*)direction;
- (void)setOrigin:(float[3])anOrigin;
- (void)setDirection:(float[3])aDirection;

@end
