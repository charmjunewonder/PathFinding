//
//  MyView.m
//  PathFinding
//
//  Created by charmjunewonder on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyView.h"
#import "Grids.h"
#import "Grid.h"

@implementation MyView

@synthesize grids = _grids;
@synthesize gridType = _gridType;
@synthesize displayMode = _displayMode;

@synthesize clickedGrid = _clickedGrid;
@synthesize startGrid = _startGrid;
@synthesize endGrid = _endGrid;
@synthesize rectArray = _rectArray;
@synthesize colorArray = _colorArray;
@synthesize arraySize = _arraySize;
@synthesize pathLine = _pathLine;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

- (void)drawRect:(NSRect)rect
{
    // setup basics
    [[NSColor blackColor] set];
    NSRectFill ( [self bounds] );
    
    int arraySize = (int)self.grids.gridArray.count;
    
    if (self.displayMode == DisplayWithColor) {
        NSRect rectArray[arraySize];
        NSColor *colorArray[arraySize];
        int i = 0;
        for (Grid *grid in self.grids.gridArray){
            rectArray[i] = grid.rect;
            int num = grid.movementCost;
            if (num != 0 && grid.gridType != StartGrid && grid.gridType != EndGrid &&
                grid.gridType != UnaccessableGrid && grid.color != [NSColor yellowColor]) {
                colorArray[i] = [NSColor colorWithCalibratedHue: (num*0.02)
                                                     saturation: 1
                                                     brightness: 0.8
                                                          alpha: 1];
            }else if(grid.gridType == UnaccessableGrid){
                colorArray[i] = [NSColor blackColor];
            }else{
                colorArray[i] = grid.color;
            }
            ++i;
        }
         
        // use rect and color arrays to fill
        NSRectFillListWithColors(rectArray, colorArray, arraySize);

    }
    else if(self.displayMode == DisplayWithNumber){
        NSRect rectArray[arraySize];
        NSColor *colorArray[arraySize];
        int i = 0;
        for (Grid *grid in self.grids.gridArray){
            rectArray[i] = grid.rect;
            colorArray[i] = grid.color;
            ++i;
        }
        
        // use rect and color arrays to fill
        NSRectFillListWithColors(rectArray, colorArray, arraySize);
        
        i = 0;
        for (Grid *grid in self.grids.gridArray){
            int num = grid.movementCost;
            if (num != 0) {
                NSString *string = [NSString stringWithFormat:@"%d", grid.movementCost];
                [string drawInRect:grid.rect withAttributes:nil];
            }
            ++i;
        }
 
    }
    
    [[NSColor yellowColor] set]; 
    [self.pathLine stroke];    

    
    //NSString *string = [NSString stringWithFormat:@"%d", 10];
    //[string drawAtPoint:CGPointMake(0, 0) withAttributes:nil];
    //[string drawInRect:rectArray[3] withAttributes:nil];
	// draw a border around each rect
	/*[[NSColor whiteColor] set];
     for ( i = 0; i < count; i++) {
     NSFrameRectWithWidth ( rectArray[i], 1 );
     }*/

}

- (void)redrawPathLine{
    self.pathLine = [NSBezierPath bezierPath];
    NSBezierPath *path = self.pathLine;
    [path setLineWidth: 2];
    
    NSPoint startPoint = {self.endGrid.pointOfGrid.x*22+11, self.endGrid.pointOfGrid.y*22+11};
    [path  moveToPoint: startPoint];    
    
    
    Grid *fromNode = self.endGrid;
    NSAssert(self.startGrid.fromGrid == nil, @"(%.0f, .0f)\n", self.startGrid.fromGrid.pointOfGrid.x, self.startGrid.fromGrid.pointOfGrid.y);
    while (fromNode.fromGrid && fromNode != self.startGrid) {
        fromNode = fromNode.fromGrid;
        NSPoint endPoint   = {fromNode.pointOfGrid.x*22+11, fromNode.pointOfGrid.y*22+11};
        [path lineToPoint:endPoint];
    }

}

- (void)mouseDown:(NSEvent *)event
{
    NSPoint eventLocation = [event locationInWindow];
    CGPoint point = [self.grids getGridPointWithX:eventLocation.x withY:eventLocation.y];
    Grid *grid = [self.grids getGridWithGridX:point.x withGridY:point.y];
    switch (self.gridType) {
        case StartGrid:
            if (self.startGrid.gridType == StartGrid) {
                [self.startGrid setColor:[NSColor whiteColor]];
                [self.startGrid setGridType:NormalGrid];
            }
            self.startGrid = grid;
            [self.startGrid setColor:[NSColor redColor]];
            [self.startGrid setGridType:StartGrid];
            break;
        case UnaccessableGrid:
            if (grid.gridType == NormalGrid) {
                [grid setColor:[NSColor blackColor]];
                [grid setGridType:UnaccessableGrid];
            }
            else if (grid.gridType == UnaccessableGrid){
                [grid setColor:[NSColor whiteColor]];
                [grid setGridType:NormalGrid];
            }
            break;
        case EndGrid:
            if (self.endGrid.gridType == EndGrid) {
                [self.endGrid setColor:[NSColor whiteColor]];
                [self.endGrid setGridType:NormalGrid];
            }
            self.endGrid = grid;
            [self.endGrid setColor:[NSColor purpleColor]];
            [self.endGrid setGridType:EndGrid];
            break;
        default:
            break;
    }

    [self setNeedsDisplay:YES];
}

@end
