//
//  Raytrace.m
//  Raytracer
//
//  Created by Bernd Beuster on 28.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Raytrace.h"

@implementation Raytrace

-(NSBitmapImageRep*)bitmap {return bitmap;}

- (id)init {
	[super init];
	
	/* default: dark gray background */
	backgroundColor=[[NSColor darkGrayColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	
	return self;
}

- (void)setWidth:(int)aWidth setHeight:(int)aHeight setOversampling:(int)aOversampling {
	width=aWidth;
	height=aHeight;
	oversampling=aOversampling;
}

- (void)setWidth:(int)aWidth setHeight:(int)aHeight {
	[self setWidth:aWidth setHeight:aHeight setOversampling:1];
}

- (void)setScene:(NSMutableArray*)aScene setLights:(NSMutableArray*)theLights setCamera:(id)aCamera {
	scene=aScene;
	lights=theLights;
	camera=aCamera;
}

- (void)setBackgroundColor:(NSColor*)bgColor {
	backgroundColor=[bgColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
}

- (NSBitmapImageRep *)raytrace {
	/* ray */
	Ray *ray=[[Ray alloc] init];
	float4 origin={0.0,0.0,0.0,0.0};
	float4 direction;
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
			direction.x=((float)x/(float)(height))-0.5*(float)width/(float)height;
			direction.y=((float)y/(float)(height))-0.5;
			direction.z=1.0;
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
	Body *nearest_body=nil;
	float nearest_t=MAXFLOAT;
	
    for(Body *body in scene) {
        float t=[body intersect:ray];
        if(t>0.0f && t<nearest_t) {
            nearest_t=t;
            nearest_body=body;
        }
    }	
    /* use color of nearest interception point */
    if(nearest_body!=nil)
        return [self shade:ray body:nearest_body distanceToIntersection:nearest_t];
    else
        return backgroundColor;
}

- (NSColor*)shade:(Ray*)ray body:(Body*)body distanceToIntersection:(float)distance {
    /* material properties */
	float kd=[body kDiff];
	float ks=[body kSpec];
	float alpha=[body alpha];
	//float ka=1.0-kd-ks;
    float ka=0.0;
    
	NSColor *bodyColor=[body color];
	float bodyRedComponent=[bodyColor redComponent];
	float bodyGreenComponent=[bodyColor greenComponent];
	float bodyBlueComponent=[bodyColor blueComponent];
	
	/* ambient shading */
	float red=ka*bodyRedComponent;
	float green=ka*bodyGreenComponent;
	float blue=ka*bodyBlueComponent;
    
	/* for each light source */
 	float4 intersection=[ray pointOnRay:distance];
    float4 N=[body normalVector:intersection];
    float4 V=-[ray direction];
    
    for(Light *light in lights) {
        float4 lightLocation=[light location];
        float4 lightVector=lightLocation-intersection;
        float4 L=normalize(lightVector);
        Ray *lightRay=[[Ray alloc] initWithOrigin:intersection direction:L];
        
        if(![self occluded:lightRay distanceToLight:norm(lightVector)]) {
            NSColor *lightColor=[light color];
            float lightRedComponent=[lightColor redComponent];
            float lightGreenComponent=[lightColor greenComponent];
            float lightBlueComponent=[lightColor blueComponent];
            
            /* diffuse reflection */            
            float LdotN=dot(L,N);
            float kdiff=kd*fmaxf(0.0,LdotN);
            //printf("L=(%f,%f,%f) N=(%f,%f,%f) L.N=%f\n",L.x,L.y,L.z,N.x,N.y,N.z,LdotN);
            if(LdotN>0.0) {
                red=1.0;
                green=1.0;
                blue=1.0;
            } else {
            red+=kdiff*bodyRedComponent*lightRedComponent;
            green+=kdiff*bodyGreenComponent*lightGreenComponent;
            blue+=kdiff*bodyBlueComponent*lightBlueComponent;
            }
        }
        
        
        /* TODO for each reflected ray... */
        /* TODO for each refracted ray... */
    }
    NSColor *radiance=[NSColor colorWithCalibratedRed:red green:green blue:blue alpha:1.0];
    return radiance;
}

- (BOOL)occluded:(Ray*)ray distanceToLight:(float)distance {
    /*for(Body *body in scene) {
        float t=[body intersect:ray];
        if(t>0.001f*distance && t<distance)
            return TRUE;
    } */  
    return FALSE;
}
@end
