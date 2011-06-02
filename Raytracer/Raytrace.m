//
//  Raytrace.m
//  Raytracer
//
//  Created by Bernd Beuster on 28.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RayColor.h"
#import "Raytrace.h"

#define DOT(v1,v2) (v1[0]*v2[0]+v1[1]*v2[1]+v1[2]*v2[2])

#define ADD(dest,v1,v2) \
	dest[0]=v1[0]+v2[0]; \
	dest[1]=v1[1]+v2[1]; \
	dest[2]=v1[2]+v2[2]

#define SUB(dest,v1,v2) \
	dest[0]=v1[0]-v2[0]; \
	dest[1]=v1[1]-v2[1]; \
	dest[2]=v1[2]-v2[2]

#define SMUL(dest,v1,s) \
	dest[0]=s*v1[0]; \
	dest[1]=s*v1[1]; \
	dest[2]=s*v1[2]


@implementation Raytrace

-(NSBitmapImageRep*)bitmap {return bitmap;}

- (id)init {
	[super init];
	
	/* default: dark gray background */
	backgroundColor=[[NSColor darkGrayColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	
	return self;
}

- (void)setWidth:(int)w setHeight:(int)h setOversampling:(int)o {
	width=w;
	height=h;
	oversampling=o;
}

- (void)setWidth:(int)w setHeight:(int)h {
	[self setWidth:w setHeight:h setOversampling:1];
}

- (void)setScene:(NSMutableArray*)scn setLights:(NSMutableArray*)lgts setCamera:(id)cam {
	scene=scn;
	lights=lgts;
	camera=cam;
}

- (void)setBackgroundColor:(NSColor*)bgcolor {
	backgroundColor=[bgcolor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
}

- (NSBitmapImageRep *)raytrace {
	/* ray */
	Ray *ray=[[Ray alloc] init];
	float origin[3]={0.0,0.0,0.0};
	float direction[3];
	[ray setOrigin:origin];
	
	bitmap=[[NSBitmapImageRep alloc]
			initWithBitmapDataPlanes:NULL
			pixelsWide:width pixelsHigh:height
			bitsPerSample:8 samplesPerPixel:3 hasAlpha:NO
			isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace
			bytesPerRow:0 bitsPerPixel:0];
#if 0
	/* antialiasing with box filter */
	float delta_pixel=(1.0/(float)oversampling);
	float offs_pixel=-0.5*((float)(oversampling-1.0)/(float)oversampling);
	float xx,yy;
	float scale=1.0/((float)oversampling*(float)oversampling);
	
	for(int y=0;y<height;y++) {
		for(int x=0;x<width;x++) {
			float color[3]={0.0,0.0,0.0};
			for(int i=0;i<oversampling;i++) {
				yy=y+i*delta_pixel+offs_pixel;
				for(int j=0;j<oversampling;j++) {
					xx=x+j*delta_pixel+offs_pixel;
					
					direction[0]=((float)xx/(float)(height))-0.5*(float)width/(float)height;
					direction[1]=((float)yy/(float)(height))-0.5;
					direction[2]=1.0;
					[ray setDirection:direction];
					
					/* intersection test of all bodies */
					Body *body,*nearest_body=NULL;
					float t=MAXFLOAT;
					
					/* get body with nearest intersection */
					for(int i=0;i<[scene count];i++) {
						body=[scene objectAtIndex:i];
						if([body intersect:ray] && [body t]<t) { // use intersect first!
							t=[body t];
							nearest_body=body;
						}
					}
					/* use color of nearest interception point */
					if(nearest_body) {
						color[0]+=scale*[[nearest_body color] redComponent];
						color[1]+=scale*[[nearest_body color] greenComponent];
						color[2]+=scale*[[nearest_body color] blueComponent];
					} else {
						color[0]+=scale*[backgroundColor redComponent];
						color[1]+=scale*[backgroundColor greenComponent];
						color[2]+=scale*[backgroundColor blueComponent];
					}
				}
			}
			NSColor *color_pixel=[NSColor colorWithCalibratedRed:sRGBGamma(color[0])
														   green:sRGBGamma(color[1])
															blue:sRGBGamma(color[2])
														   alpha:1.0];
			[bitmap setColor:color_pixel atX:x y:(height-y-1)];
		}
	}
#else
	for(int y=0;y<height;y++) {
		for(int x=0;x<width;x++) {
			direction[0]=((float)x/(float)(height))-0.5*(float)width/(float)height;
			direction[1]=((float)y/(float)(height))-0.5;
			direction[2]=1.0;
			[ray setDirection:direction];
			
			NSColor *color=[self trace:ray];
			NSColor *sRGB_color=[color sRGBColor];
			[bitmap setColor:sRGB_color atX:x y:(height-y-1)];
		}
	}
#endif
	[ray release];
	[bitmap autorelease];
	return bitmap;
}

/* get color of the body with the nearest intersection */
- (NSColor*)trace:(Ray*)ray {
	/* intersection test of all bodies */
	Body *body,*nearest_body=NULL;
	float t=MAXFLOAT;
	
	for(int i=0;i<[scene count];i++) {
		body=[scene objectAtIndex:i];
		if([body intersect:ray] && [body t]<t) { // use intersect first!
			t=[body t];
			nearest_body=body;
		}
	}	
	/* use color of nearest interception point */
	if(nearest_body)
		return [self shade:ray body:nearest_body];
	else
		return backgroundColor;
}

- (NSColor*)shade:(Ray*)ray body:(Body*)b {
	NSColor *radiance=[[NSColor clearColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	
	/* for each light source */
	for(int i=0;i<[lights count];i++)
		radiance=[radiance addColor:[self phongIllumination:ray body:b light:[lights objectAtIndex:i]]];
	
	/* TODO for each reflected ray... */
	/* TODO for each refracted ray... */
	return radiance;
}

- (NSColor*)phongIllumination:(Ray*)ray body:(Body*)bdy light:(Light*)lgt {
	NSColor *body_color=[bdy color];
	float body_red_component=[body_color redComponent];
	float body_green_component=[body_color greenComponent];
	float body_blue_component=[body_color blueComponent];
	
	/* ambient shading */
	float ka=[bdy ka];
	float red=ka*body_red_component;
	float green=ka*body_green_component;
	float blue=ka*body_blue_component;

	/* diffuse shading */
	float *ray_origin=[ray origin];
	float *ray_direction=[ray direction];
	float t=[bdy t];
	float intersection[3];
	SMUL(intersection,ray_direction,t);
	ADD(intersection,intersection,ray_origin);

	float *light_location=[lgt location];
	float L[3];
	SUB(L,light_location,intersection);
	float scale=1.0/sqrtf(DOT(L,L));
	SMUL(L,L,scale); // light normal vector
	
	float kd=[bdy kd];
	float *N=[bdy normalVector];
	float kdiff=kd*fmaxf(0.0,DOT(L,N));
	NSColor *light_color=[lgt color];
	
	float light_red_component=[light_color redComponent];
	float light_green_component=[light_color greenComponent];
	float light_blue_component=[light_color blueComponent];
	
	red+=kdiff*body_red_component*light_red_component;
	green+=kdiff*body_green_component*light_green_component;
	blue+=kdiff*body_blue_component*light_blue_component;

	/* TODO specular shading... */
	NSColor *radiance=[NSColor colorWithCalibratedRed:red green:green blue:blue alpha:1.0];
	return radiance;
}
@end
