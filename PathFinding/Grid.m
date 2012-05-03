//
//  Grid.m
//  PathFinding
//
//  Created by charmjunewonder on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Grid.h"

@implementation Grid

@synthesize gridType = _gridType;
@synthesize rect = _rect;
@synthesize color = _color;
@synthesize movementCost = _movementCost;
@synthesize gridState = _gridState;
@synthesize fromGrid = _fromGrid;
@synthesize movementCostWithHeuristic = _movementCostWithHeuristic;

@end
