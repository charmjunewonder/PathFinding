//
//  Grids.m
//  PathFinding
//
//  Created by charmjunewonder on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Grids.h"
#import "Grid.h"

@implementation Grids

@synthesize gridArray = _gridArray;
@synthesize rectArray = _rectArray;
@synthesize colorArray = _colorArray;

#define arraySize 400
#define rowSize 20
#define rectSize 20
#define lineWidth 2
- (NSMutableArray *)gridArray{
    if (!_gridArray) {
        _gridArray = [[NSMutableArray alloc] initWithCapacity:arraySize];
        for (int y = 0; y < rowSize; ++y) 
            for (int x = 0; x < rowSize; ++x) 
            {
                Grid *grid = [[Grid alloc]init];
                grid.rect = CGRectMake(x*22, y*22, rectSize, rectSize);
                grid.color = [NSColor whiteColor];
                grid.movementCost = 0;
                [_gridArray addObject:grid];
            }
    }
    return _gridArray;
}

- (NSMutableArray *)colorArray{
    if (!_colorArray) {
        _colorArray = [[NSMutableArray alloc] initWithCapacity:arraySize];
        for(Grid *g in self.gridArray){
            [_colorArray addObject:[NSColor whiteColor]];
        }
    }
    return _colorArray;
}

- (NSRect *)rectArray{
    if (!_rectArray) {
        _rectArray = malloc(sizeof(NSRect)*arraySize);
        int i = 0;
        for(Grid *g in self.gridArray){
            _rectArray[i] = g.rect;
        }
    }
    return _rectArray;
}

- (void)prepareGridArray{
    self.gridArray = [[NSMutableArray alloc] initWithCapacity:arraySize];
    for (int y = 0; y < rowSize; ++y) 
        for (int x = 0; x < rowSize; ++x) 
        {
            Grid *grid = [[Grid alloc]init];
            grid.rect = CGRectMake(x*22, y*22, rectSize, rectSize);
            [_gridArray addObject:grid];
        }

    NSRect *rectArray = malloc(sizeof(NSRect)*arraySize);
    int i = 0;
    for(Grid *g in self.gridArray){
        rectArray[i] = g.rect;
    }
    NSColor *colorArray[arraySize];
    colorArray[0] = [NSColor redColor];	
    
    for(Grid *g in self.gridArray){
        rectArray[i] = g.rect;
        colorArray[i] = [NSColor whiteColor];		
        ++i;
    }
}

- (NSRect)getGridRectWithX:(int)x withY:(int)y{
    if(x >= rowSize || y >= rowSize || x<0 || y<0) return CGRectNull;
    Grid *g= [self.gridArray objectAtIndex:(x+y*rowSize)];
    return g.rect;
}

- (Grid *)getGridWithX:(int)x withY:(int)y{
    if(x >= rowSize || y >= rowSize || x<0 || y<0) return nil;
    Grid *g= [self.gridArray objectAtIndex:(x+y*rowSize)];
    return g;
}

- (CGPoint)getGridPointWithX:(int)x withY:(int)y{
    return CGPointMake(x / (rectSize+lineWidth), y / (rectSize+lineWidth));
}

@end