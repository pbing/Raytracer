//
//  Grid3D.m
//  Raytracer
//
//  Created by Bernd Beuster on 11.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Grid3D.h"


@implementation Grid3D

- (id)initWithCellsAtX:(NSUInteger)cellsX Y:(NSUInteger)cellsY Z:(NSUInteger)cellsZ {
    self=[super init];
    
    numCellsX=cellsX;
    numCellsY=cellsY;
    numCellsZ=cellsZ;
    
    grid=[NSMutableArray arrayWithCapacity:cellsX*cellsY*cellsZ];
    return self;
}

- (void)insertObject:(id)anObject atX:(NSUInteger)x y:(NSUInteger)y z:(NSUInteger)z {
    NSUInteger index=(numCellsX*(numCellsY*z+y)+x);
    [grid insertObject:anObject atIndex:index];
}

- (id)objectAtX:(NSUInteger)x y:(NSUInteger)y z:(NSUInteger)z {
    NSUInteger index=(numCellsX*(numCellsY*z+y)+x);
    return [grid objectAtIndex:index];
}


@end
