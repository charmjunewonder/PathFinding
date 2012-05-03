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

//- (NSRect *)getRectArray;
- (NSRect)getGridRectWithX:(int)x withY:(int)y;
- (Grid *)getGridWithX:(int)x withY:(int)y;
- (CGPoint)getGridPointWithX:(int)x withY:(int)y;
//- (void)prepareGrids;
@end