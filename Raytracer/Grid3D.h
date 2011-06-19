//
//  Grid3D.h
//  Raytracer
//
//  Created by Bernd Beuster on 11.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Grid3D : NSObject {
    NSUInteger numCellsX,numCellsY,numCellsZ;
    NSMutableArray *grid;
}

- (id)initWithCellsAtX:(NSUInteger)cellsX Y:(NSUInteger)cellsY Z:(NSUInteger)cellsZ;
- (void)insertObject:(id)anObject atX:(NSUInteger)x y:(NSUInteger)y z:(NSUInteger)z;
- (id)objectAtX:(NSUInteger)x y:(NSUInteger)y z:(NSUInteger)z;

@end
