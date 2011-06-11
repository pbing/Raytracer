/* Demo 1 */

#import <Cocoa/Cocoa.h>
#import "Raytrace.h"

void Demo1(NSMutableArray *scene,NSMutableArray *lights) {    
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
    
	Sphere *sphere1=[[Sphere alloc] init];
	[sphere1 setCenter:(float4){0.0,-2.0,7.0,0.0}];
	[sphere1 setRadius:1.0];
	[sphere1 setColor:[NSColor greenColor]];
	[sphere1 setKDiff:0.5];	
	[sphere1 setKSpec:0.4];	
	[sphere1 setAlpha:50];
	[sphere1 setCRefl:0.2];
	[scene addObject:sphere1];
    [sphere1 release];
	
	Sphere *sphere2=[[Sphere alloc] init];
	[sphere2 setCenter:(float4){-0.5,0.4,5.6,0.0}];
    //	[sphere2 setCenter:(float4){-1.0,-2.0,7.0,0.0}]; // FIXME: intersected objects
	[sphere2 setRadius:1.0];	
	[sphere2 setColor:[NSColor yellowColor]];
	[sphere2 setKDiff:0.5];
	[sphere2 setKSpec:0.4];
	[sphere2 setAlpha:50];	
	[sphere2 setCRefl:0.2];
	[scene addObject:sphere2];
    [sphere2 release];
	
	Triangle *triangle1=[[Triangle alloc] init];
	[triangle1 setV0:(float4){0.5,-0.5,6.0,0.0}];
	[triangle1 setV1:(float4){1.5,0.5,5.0,0.0}];
	[triangle1 setV2:(float4){2.5,-0.5,4.0,0.0}];
	[triangle1 setColor:[NSColor blueColor]];
	[triangle1 setKDiff:0.5];
	[triangle1 setCRefl:0.2];
	[scene addObject:triangle1];
    [triangle1 release];
	
	Triangle *triangle2=[[Triangle alloc] init];
	[triangle2 setV0:(float4){0.0,1.0,3.0,0.0}];
	[triangle2 setV1:(float4){1.0,1.5,3.0,0.0}];
	[triangle2 setV2:(float4){1.5,-1.0,3.0,0.0}];
	[triangle2 setColor:[NSColor redColor]];
	[triangle2 setKDiff:0.5];
	[triangle2 setCRefl:0.2];
	[scene addObject:triangle2];
    [triangle2 release];
}