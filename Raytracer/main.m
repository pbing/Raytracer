#import <AppKit/AppKit.h>
#import "Sphere.h"
#import "Triangle.h"
#import "Raytrace.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	
	if (argc<2) {
		fprintf(stderr,"Missing file name.\n");
		return 1;
	}
	
	/*
	 //NSColorSpace *sRGB=[NSColorSpace sRGBColorSpace];
	 int pixelsWide=32,pixelsHigh=32;
	 NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc]
	 initWithBitmapDataPlanes:NULL
	 pixelsWide:pixelsWide pixelsHigh:pixelsHigh
	 bitsPerSample:8 samplesPerPixel:3 hasAlpha:NO
	 isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace
	 bytesPerRow:0 bitsPerPixel:0];
	 
	 NSColor *red=[NSColor colorWithCalibratedRed:0.5 green:0.0 blue:0.0 alpha:1.0];
	 for(int i=0;i<32;i++)
	 [bitmap setColor:red atX:i y:i];
	 
	 NSData *tiff_data=[bitmap TIFFRepresentation];
	 [tiff_data writeToFile:@"demo.tiff" atomically:NO];
	 
	 NSDictionary *png_properties=[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:2.2] forKey:NSImageGamma];
	 NSData *png_data=[bitmap representationUsingType:NSPNGFileType properties:png_properties];
	 [png_data writeToFile:@"demo.png" atomically:NO];
	 
	 [bitmap release];
	 */	
	
	/* scene */
    NSMutableArray *scene=[NSMutableArray arrayWithCapacity:100];
	NSMutableArray *lights=[NSMutableArray arrayWithCapacity:100];
	id camera=nil;
	
	Light *light1=[[Light alloc] init];
	[light1 setLocation:(float[3]){-10.0,10.0,0.0}];
	[lights addObject:light1];

	Light *light2=[[Light alloc] init];
	[light2 setLocation:(float[3]){10.0,10.0,0.0}];
	[light2 setColor:[NSColor colorWithCalibratedRed:0.3 green:0.3 blue:0.3 alpha:1.0]]; 
//	[lights addObject:light2];
	
	Sphere *sphere1=[[Sphere alloc] init];
	[sphere1 setCenter:(float[3]){0.0,-2.0,7.0}];
	[sphere1 setRadius:1.0];
	[sphere1 setColor:[NSColor greenColor]];
	[sphere1 setKa:0.0];
	[sphere1 setKd:0.8];	
	[sphere1 setKs:0.2];	
	[sphere1 setAlpha:50];	
	[scene addObject:sphere1];
	
	Sphere *sphere2=[[Sphere alloc] init];
	[sphere2 setCenter:(float[3]){-1.0,0.0,5.0}];
	[sphere2 setRadius:1.0];	
	[sphere2 setColor:[NSColor yellowColor]];
	[sphere2 setKa:0.0];
	[sphere2 setKd:0.8];
	[sphere2 setKs:0.2];
	[sphere2 setAlpha:50];	
	[scene addObject:sphere2];
	
	Triangle *triangle1=[[Triangle alloc] init];
	[triangle1 setV0:(float[3]){0.5,-0.5,6.0}];
	[triangle1 setV1:(float[3]){1.5,0.5,5.0}];
	[triangle1 setV2:(float[3]){2.5,-0.5,4.0}];
	[triangle1 setColor:[NSColor blueColor]];
	[triangle1 setKa:0.0];
	[triangle1 setKd:0.8];
	[triangle1 setKs:0.2];
	[triangle1 setAlpha:50];	
	[scene addObject:triangle1];
	
	Triangle *triangle2=[[Triangle alloc] init];
	[triangle2 setV0:(float[3]){0.0,1.0,3.0}];
	[triangle2 setV1:(float[3]){1.0,1.5,3.0}];
	[triangle2 setV2:(float[3]){1.5,-1.0,3.0}];
	[triangle2 setColor:[NSColor redColor]];
	[triangle2 setKa:0.0];
	[triangle2 setKd:0.8];
	[triangle2 setKs:0.2];
	[triangle2 setAlpha:50];	
	[scene addObject:triangle2];
	
	Raytrace *raytrace=[[Raytrace alloc] init];
	[raytrace setWidth:512 setHeight:512 setOversampling:1];
	//[raytrace setWidth:1280 setHeight:720];
	[raytrace setScene:scene setLights:lights setCamera:camera];
	
	NSBitmapImageRep *bitmap=[raytrace raytrace];

	NSData *tiff_data=[bitmap TIFFRepresentationUsingCompression:NSTIFFCompressionLZW factor:1];
	[tiff_data writeToFile:[NSString stringWithUTF8String:argv[1]] atomically:NO];
	
	[light1 release];
	[light2 release];
	//[camera release];
	[sphere1 release];
	[sphere2 release];
	[triangle1 release];
	[triangle2 release];
	[raytrace release];
    [pool drain];
    return 0;
}
