//
//  Grids.h
//  PathFinding
//
//  Created by charmjunewonder on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Grid;

@interface Grids : NSObject

@property (nonatomic, retain)NSMutableArray *gridArray;
@property (nonatomic)NSRect *rectArray;
@property (nonatomic, retain)NSMutableArray *colorArray;
@property (nonatomic)int width;
@property (nonatomic)int height;
@property (nonatomic)int rowLength;
@property (nonatomic)int columnLength;

//- (NSRect *)getRectArray;
- (NSRect)getGridRectWithGridX:(int)x withGridY:(int)y;
- (Grid *)getGridWithGridX:(int)x withGridY:(int)y;
- (CGPoint)getGridPointWithX:(int)x withY:(int)y;
- (BOOL)isAccessableAtGridX:(int)x gridY:(int)y;
//- (void)prepareGrids;
- (BOOL)isInsideGridsAtGridX:(int)x gridY:(int)y;
@end