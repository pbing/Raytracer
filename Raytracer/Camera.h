//
//  Camera.h
//  Raytracer
//
//  Created by Bernd Beuster on 11.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ray.h"

@interface Camera : NSObject {
@private
    float4 location;
    float4 direction;
    float4 right;
    float4 up;
    float4 sky;
    float4 lookAt;
    float angle;
}

@property (readonly) float4 location,direction,right,up,sky,lookAt;
@property (readonly) float angle;

- (void)setLocation:(float4)locationVector;
- (void)setDirection:(float4)directionVector;
- (void)setRight:(float4)rightVector;
- (void)setUp:(float4)upVector;
- (void)setSky:(float4)skyVector;
- (void)setLookAt:(float4)lookAtVector;
- (void)setAngle:(float)anAngle;
@end
