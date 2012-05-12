//
//  MyView.h
//  PathFinding
//
//  Created by charmjunewonder on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum{
    DisplayWithNumber,
    DisplayWithColor
}DisplayMode;

@class Grids, Grid;

@interface MyView : NSView

@property (nonatomic, strong)Grids *grids;
@property (nonatomic)int gridType;
@property (nonatomic)int displayMode;

@property (nonatomic, weak)Grid *clickedGrid;
@property (nonatomic, weak)Grid *startGrid;
@property (nonatomic, weak)Grid *endGrid;
@property (nonatomic)NSRect *rectArray;
@property (nonatomic, retain)NSMutableArray *colorArray;
@property (nonatomic)int arraySize;
@property (nonatomic, retain) NSBezierPath *pathLine;

- (void)redrawPathLine;
@end
