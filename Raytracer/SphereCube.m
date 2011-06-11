/* Cube of N*N*N spheres */

#import <Cocoa/Cocoa.h>
#import "Raytrace.h"

void SphereCube(NSMutableArray *scene,NSMutableArray *lights,int N) {    
    const float radius=0.5;
    const float PHI=(1.0+sqrtf(5))/2.0;
    float4 center;
    float ds=2.0*PHI*radius;
    
	Light *light1=[[Light alloc] init];
	[light1 setLocation:(float4){10.0,10.0,0.0,0.0}];
	[lights addObject:light1];
    [light1 release];
    
	Light *light2=[[Light alloc] init];
	[light2 setLocation:(float4){-17.3,5.8,0.0,0.0}];
	[light2 setColor:[NSColor colorWithCalibratedRed:0.3 green:0.3 blue:0.3 alpha:1.0]]; 
	[lights addObject:light2];
    [light2 release];
    
	Light *light3=[[Light alloc] init];
	[light3 setLocation:(float4){0.0,0.0,20.0,0.0}];
	[light3 setColor:[NSColor colorWithCalibratedRed:0.5 green:0.5 blue:0.5 alpha:1.0]]; 
	[lights addObject:light3];
    [light3 release];

    for(int k=0;k<N;k++)
        for(int j=0;j<N;j++)
            for(int i=0;i<N;i++) {
                Sphere *sphere=[[Sphere alloc] init];
                center.x=((float)i-(float)(N-1)/2.0)*ds;
                center.y=((float)j-(float)(N-1)/2.0)*ds;
                center.z=(k+N)*ds;
                
                [sphere setColor:[NSColor colorWithCalibratedRed:(float)i/(float)(N-1) green:(float)j/(float)(N-1) blue:(float)k/(float)(N-1) alpha:1.0]];
                [sphere setCenter:center];
                [sphere setRadius:radius];
                [sphere setKDiff:0.8];
                [sphere setKSpec:0.2];
                [sphere setAlpha:150]; // shininess 
                [sphere setBeta:0.5];  // 0.0=plastic 1.0=metal
                [sphere setCRefl:0.2];
                
                [scene addObject:sphere];
                [sphere release];
            }
}