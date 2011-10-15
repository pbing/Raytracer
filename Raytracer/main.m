#import <AppKit/AppKit.h>
#import "Raytrace.h"
#import "Scenes.h"
//#import "Grid3D.h"

int main (int argc, const char * argv[]) {
	if (argc<2) {
		fprintf(stderr,"Missing file name.\n");
		return 1;
	}
    
    @autoreleasepool {
        /* scene, lights */
        NSMutableArray *scene=[NSMutableArray arrayWithCapacity:100];
        NSMutableArray *lights=[NSMutableArray arrayWithCapacity:100];
        id camera=nil;
        
        //	Demo1(scene,lights);
        SphereCube(scene,lights,3);
        
        Raytrace *raytrace=[[Raytrace alloc] init];
        [raytrace setBackgroundColor:[NSColor clearColor]];
        
        [raytrace setWidth:512 setHeight:512 setOversampling:1];
        //[raytrace setWidth:1280 setHeight:720 setOversampling:4];
        
        [raytrace setScene:scene setLights:lights setCamera:camera];
        
        NSBitmapImageRep *bitmap=[raytrace raytrace];
        
        NSData *tiff_data=[bitmap TIFFRepresentationUsingCompression:NSTIFFCompressionLZW factor:1];
        [tiff_data writeToFile:[NSString stringWithUTF8String:argv[1]] atomically:NO];
        
        return 0;        
    }
}
