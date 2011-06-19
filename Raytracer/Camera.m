//
//  Camera.m
//  Raytracer
//
//  Created by Bernd Beuster on 11.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Camera.h"


@implementation Camera

@synthesize location,direction,up,right,sky,lookAt,angle;

- (id)init {
    [super init];
    
    location =(float4){0.0,0.0,0.0,0.0};
    right    =(float4){1.0,0.0,0.0,0.0};
    up       =(float4){0.0,1.0,0.0,0.0};
    sky      =up;
    [self setDirection:(float4){0.0,0.0,1.0,0.0}];

    return self;
}

- (void)setLocation:(float4)locationVector {
    location=locationVector;
    angle=360.0/M_PI*atanf(0.5*norm(right)/norm(direction));
}

- (void)setDirection:(float4)directionVector {
    direction=directionVector;
    lookAt=location+direction;
    angle=360.0/M_PI*atanf(0.5*norm(right)/norm(direction));
}

- (void)setRight:(float4)rightVector {
    right=rightVector;
    angle=360.0/M_PI*atanf(0.5*norm(right)/norm(direction));    
}

- (void)setUp:(float4)upVector {
    up=upVector;
    [self setAngle:angle];
}

- (void)setSky:(float4)skyVector {
    sky=skyVector;
}

- (void)setLookAt:(float4)lookAtVector {
    lookAt=lookAtVector;
    direction=norm(lookAt-location);
}

- (void)setAngle:(float)anAngle {
    angle=anAngle;
    direction=0.5f/tanf(0.5*angle)*cross(up,right);
}
@end
