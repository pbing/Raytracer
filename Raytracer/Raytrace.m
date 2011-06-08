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
			float4 color={0.0,0.0,0.0,0.0};
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
                    
                    float4 sampleColor=[self trace:ray depth:MAX_RAYTRACE_RECURSION_DEPTH];
                    color+=scale*sampleColor;
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
- (float4)trace:(Ray*)ray depth:(int)depth {
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
        return (float4){0.0,0.0,0.0,0.0};
	else {
        float4 bgColor;
        bgColor[0]=[backgroundColor redComponent];
        bgColor[1]=[backgroundColor greenComponent];
        bgColor[2]=[backgroundColor blueComponent];
        return bgColor;
    }
}

- (float4)shade:(Ray*)ray body:(Body*)body distanceToIntersection:(float)distance {
    /* material properties */
	float kd=[body kDiff];
	float ks=[body kSpec];
	float alpha=[body alpha];
    float beta=[body beta];
    
	float ka=1.0f-kd-ks;
    float normalizeFactor=(alpha+8.0)/(8.0*M_PI); // Phong:(n+2)/2π, Blinn-Phong:(n+8)/8π
    
	NSColor *nsBodyColor=[body color];
    float4 bodyColor;
	bodyColor[0]=[nsBodyColor redComponent];
	bodyColor[1]=[nsBodyColor greenComponent];
	bodyColor[2]=[nsBodyColor blueComponent];
	
	/* ambient shading */
    float4 radianceColor=ka*bodyColor;
    
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
            NSColor *nsLightColor=[light color];
            float4 lightColor;
            lightColor[0]=[nsLightColor redComponent];
            lightColor[1]=[nsLightColor greenComponent];
            lightColor[2]=[nsLightColor blueComponent];
             
            /* diffuse shading */            
            float LdotN=dot(L,N);
            float kdiff=kd*fmaxf(0.0f,LdotN);
            radianceColor+=kdiff*bodyColor*lightColor;
            
            /* specular shading (Blinn-Phong) */
            float4 H=normalize(L+V);
            float kspec=normalizeFactor*ks*powf(fmaxf(0.0f,dot(N,H)),alpha);
            radianceColor+=kspec*(1.0f+beta*(bodyColor-1.0f))*lightColor;            
        }
        [lightRay release];
        
        if(recursionDepth>1) {
            /* for each reflected ray */
            float cRefl=[body cRefl];
            float4 R=2*dot(V,N)*N-V;
            Ray *reflRay=[[Ray alloc] initWithOrigin:intersection direction:R]; 
            float4 reflColor=[self trace:reflRay depth:recursionDepth-1];
            
            radianceColor=(1.0f-cRefl)*radianceColor+cRefl*reflColor;
            [reflRay release];
            
            /* TODO for each refracted ray... */
        }

    }
    return radianceColor;
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
