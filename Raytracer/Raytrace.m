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
	/* FIXME ray */
	Ray *ray=[[Ray alloc] init];
	float4 origin={0.0,0.0,0.0,0.0};
	float4 direction;
	[ray setOrigin:origin];
	
	bitmap=[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                   pixelsWide:width
                                                   pixelsHigh:height
                                                bitsPerSample:8
                                              samplesPerPixel:3
                                                     hasAlpha:NO
                                                     isPlanar:NO
                                               colorSpaceName:NSCalibratedRGBColorSpace
                                                  bytesPerRow:0
                                                 bitsPerPixel:0];
    
	/* antialiasing with box filter */
	float deltaPixel=(1.0/(float)oversampling);
	float offsPixel=-0.5*((float)(oversampling-1.0)/(float)oversampling);
	float xx,yy;
	float scale=1.0/((float)oversampling*(float)oversampling);
	
	for(int y=0;y<height;y++) {
		for(int x=0;x<width;x++) {
			float color[3]={0.0,0.0,0.0};
			for(int i=0;i<oversampling;i++) {
				yy=y+i*deltaPixel+offsPixel;
				for(int j=0;j<oversampling;j++) {
					xx=x+j*deltaPixel+offsPixel;
					
                    /* pin hole camera with distorsion of objects in the corners */
//					direction.x=((float)xx/(float)(height))-0.5*(float)width/(float)height;
//					direction.y=((float)yy/(float)(height))-0.5;
//					direction.z=1.0;
//					[ray setDirection:normalize(direction)];
					
                    /* perspective projection with barrel distorsions for large p.o.v. */
					float xt=((float)xx/(float)(height))-0.5*(float)width/(float)height;
					float yt=((float)yy/(float)(height))-0.5;
                    float zt=1.0f;
					float s=norm((float4){xt,yt,zt,0.0});
                    direction.x=xt*s;
                    direction.y=yt*s;
                    direction.z=zt;
					[ray setDirection:normalize(direction)];
					
//					/* orthographic projection */
//					origin.x=((float)xx/(float)(height))-0.5*(float)width/(float)height;
//					origin.y=((float)yy/(float)(height))-0.5;
//                  origin.z=0.0;
//                  [ray setOrigin:5.0f*origin];
//                  [ray setDirection:(float4){0.0,0.0,1.0,0.0}];
                    
                    NSColor *sampleColor=[self trace:ray depth:MAX_RAYTRACE_RECURSION_DEPTH];
                    
                    color[0]+=scale*[sampleColor redComponent];
                    color[1]+=scale*[sampleColor greenComponent];
                    color[2]+=scale*[sampleColor blueComponent];
				}
			}
            
			NSColor *sRGBColor=[[NSColor colorWithCalibratedRed:color[0] green:color[1] blue:color[2] alpha:1.0] sRGBColor];
			[bitmap setColor:sRGBColor atX:x y:(height-y-1)];
		}
	}
	[ray release];
	[bitmap autorelease];
	return bitmap;
}

/* get color of the body with the nearest intersection */
- (NSColor*)trace:(Ray*)ray depth:(int)depth {
    recursionDepth=depth;

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
    /* FIXME: also valid for refraction?
     * Use color of nearest interception point.
     * Background color is not an ambient color but only virtuell,
     * be sure not to return it during recursion.
     */
	if(nearest_body!=nil)
		return [self shade:ray body:nearest_body distanceToIntersection:nearest_t];
    else if(recursionDepth<MAX_RAYTRACE_RECURSION_DEPTH)
        return [[NSColor clearColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	else 
        return backgroundColor;
}

- (NSColor*)shade:(Ray*)ray body:(Body*)body distanceToIntersection:(float)distance {
    /* material properties */
	float kd=[body kDiff];
	float ks=[body kSpec];
	float alpha=[body alpha];
	float ka=1.0-kd-ks;
    
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
            
            /* diffuse shading */            
            float LdotN=dot(L,N);
            float kdiff=kd*fmaxf(0.0f,LdotN);
            red+=kdiff*bodyRedComponent*lightRedComponent;
            green+=kdiff*bodyGreenComponent*lightGreenComponent;
            blue+=kdiff*bodyBlueComponent*lightBlueComponent;
            
            /* specular shading (Blinn-Phong) */
            float4 H=normalize(L+V);
            float kspec=ks*powf(fmaxf(0.0f,dot(N,H)),alpha);
            red+=kspec*lightRedComponent;
            green+=kspec*lightGreenComponent;
            blue+=kspec*lightBlueComponent;
            
        }
        
        if(recursionDepth>1) {
            /* for each reflected ray */
            float cr=[body cRefl];
            float4 R=2*dot(V,N)*N-V;
            Ray *reflRay=[[Ray alloc] initWithOrigin:intersection direction:R]; 
            NSColor *reflColor=[self trace:reflRay depth:recursionDepth-1];
            red=(1.0-cr)*red+cr*[reflColor redComponent];
            green=(1.0-cr)*green+cr*[reflColor greenComponent];
            blue=(1.0-cr)*blue+cr*[reflColor blueComponent];
            
            /* TODO for each refracted ray... */
        }
    }
    NSColor *radiance=[NSColor colorWithCalibratedRed:red green:green blue:blue alpha:1.0];
    return radiance;
}

- (BOOL)occluded:(Ray*)ray distanceToLight:(float)distance {
    for(Body *body in scene) {
        float t=[body intersect:ray];
        if(t>0.001f*distance && t<distance)
            return TRUE;
    }  
    return FALSE;
}
@end
