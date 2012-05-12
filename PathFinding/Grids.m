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
@synthesize width = _width;
@synthesize height = _height;
@synthesize rowLength = _rowLength;
@synthesize columnLength = _columnLength;

#define arraySize 400
#define rowSize 20

#define rectSize 20
#define lineWidth 2
#define gridWidth 22

- (id)init{
    self = [super init];
    if (self) {
        self.rowLength = rowSize;
        self.columnLength = rowSize;
        self.height = self.columnLength * gridWidth;
        self.width = self.rowLength * gridWidth;
    }
    return self;
}

- (NSMutableArray *)gridArray{
    if (!_gridArray) {
        _gridArray = [[NSMutableArray alloc] initWithCapacity:arraySize];
        for (int y = 0; y < rowSize; ++y) 
            for (int x = 0; x < rowSize; ++x) 
            {
                Grid *grid = [[Grid alloc]init];
                grid.rect = CGRectMake(x*gridWidth, y*gridWidth, rectSize, rectSize);
                grid.pointOfGrid = CGPointMake(x, y);
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
            grid.pointOfGrid = CGPointMake(x, y);

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

- (NSRect)getGridRectWithGridX:(int)x withGridY:(int)y{
    if(![self isInsideGridsAtGridX:x gridY:y]) return CGRectNull;
    Grid *g= [self.gridArray objectAtIndex:(x+y*rowSize)];
    return g.rect;
}

// Notice: this is the x or y coordinate of grid 
- (Grid *)getGridWithGridX:(int)x withGridY:(int)y{
    if(![self isInsideGridsAtGridX:x gridY:y]) return nil;
    Grid *g= [self.gridArray objectAtIndex:(x+y*rowSize)];
    return g;
}

// Notice: 
- (CGPoint)getGridPointWithX:(int)x withY:(int)y{
    return CGPointMake(x / (rectSize+lineWidth), y / (rectSize+lineWidth));
}

- (BOOL)isAccessableAtGridX:(int)x gridY:(int)y{
    return [self isInsideGridsAtGridX:x gridY:y] && [self getGridWithGridX:x withGridY:y].gridType != UnaccessableGrid;
}

- (BOOL)isInsideGridsAtGridX:(int)x gridY:(int)y{
    return (x >= 0 && x < self.rowLength) && (y >= 0 && y < self.columnLength);
}

@end