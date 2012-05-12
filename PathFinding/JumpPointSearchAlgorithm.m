//
//  JumpPointSearchAlgorithm.m
//  PathFinding
//
//  Created by charmjunewonder on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JumpPointSearchAlgorithm.h"
#import "Grid.h"
#import "Grids.h"
#import "MyView.h"
#import "Heap.h"

@implementation JumpPointSearchAlgorithm

- (id)initWithGrids:(Grids*)gs startGrid:(Grid*)sg endGrid:(Grid*)eg view:(MyView*)v{
    self = [super init];
    if (self) {
        self.grids = gs;
        self.startGrid = sg;
        self.endGrid = eg;
        self.gridView = v;
    }
    return self;
}

- (NSMutableArray*)getEightAdjacentGrid:(Grid*)currentGrid{
    CGPoint currentLocation = [self.grids getGridPointWithX:currentGrid.rect.origin.x withY:currentGrid.rect.origin.y];
    NSMutableArray *adjacentGrids = [NSMutableArray arrayWithCapacity:8];
    for (int x = -1; x < 2; ++x)
        for (int y = -1; y < 2; ++y) {
            if (x == 0 && y ==0) {
                continue;
            }
            Grid *g = [self.grids getGridWithGridX:currentLocation.x+x withGridY:currentLocation.y+y];
            if (g && g.gridType != UnaccessableGrid) {
                [adjacentGrids addObject:g];
            }
        }
    
    return adjacentGrids;
}

/*- (CGPoint)getDirectionPointWithCurrentGrid:(Grid*)currentGrid{
    Grid *parentGrid = currentGrid.fromGrid;
    int x,y;
     switch (direction) {
     case UpMove:
     x=0, y=1;
     break;
     case DownMove:
     x=0, y=-1;
     break;
     case LeftMove:
     x=-1, y=0;
     break;
     case RightMove:
     x=1, y=0;
     break;
     case LeftUpMove:
     x=-1, y=1;
     break;
     case LeftDownMove:
     x=-1, y=-1;
     break;
     case RightUpMove:
     x=1, y=1;
     break;
     case RightDownMove:
     x=1, y=-1;
     break;
     default:
     break;
     }
    //CGPoint c = currentGrid.pointOfGrid;
    //CGPoint p = parentGrid.pointOfGrid;
    int x = (currentGrid.pointOfGrid.x - parentGrid.pointOfGrid.x)/
    MAX(abs(currentGrid.pointOfGrid.x - parentGrid.pointOfGrid.x), 1);
    int y = (currentGrid.pointOfGrid.y - parentGrid.pointOfGrid.y)/
    MAX(abs(currentGrid.pointOfGrid.y - parentGrid.pointOfGrid.y), 1);
    return CGPointMake(x,y);
}*/

/*- (Grid*)getNextGridWithCurrentGrid:(Grid*)currentGrid{
    CGPoint directionPoint = [self getDirectionPointWithCurrentGrid:currentGrid];
    NSAssert(directionPoint.x != 0 || directionPoint.y != 0, nil, "jflsd");
    //printf("(%.0f, %.0f)->(%.0f, %.0f)\n", currentGrid.pointOfGrid.x, currentGrid.pointOfGrid.y, directionPoint.x, directionPoint.y);
    return [self.grids getGridWithGridX:currentGrid.pointOfGrid.x+ directionPoint.x
                              withGridY:currentGrid.pointOfGrid.y+ directionPoint.y];
}*/

// all the neighbour is accessable
- (NSMutableArray*)findNeighboursAfterPruning:(Grid *)currentGrid{
    NSMutableArray *neighbours = [[NSMutableArray alloc]initWithCapacity:5];
    Grid *parentGrid = currentGrid.fromGrid;
    NSAssert(parentGrid != currentGrid, nil, "parent is equal to son.");
    
    if (parentGrid) {

        int cx = currentGrid.pointOfGrid.x;
        int cy = currentGrid.pointOfGrid.y;
        int dx = (currentGrid.pointOfGrid.x - parentGrid.pointOfGrid.x)/
            MAX(abs(currentGrid.pointOfGrid.x - parentGrid.pointOfGrid.x), 1);
        int dy = (currentGrid.pointOfGrid.y - parentGrid.pointOfGrid.y)/
            MAX(abs(currentGrid.pointOfGrid.y - parentGrid.pointOfGrid.y), 1);
        NSAssert(dx != 0 || dy != 0, nil);
        
        // search vertically
        if (dx == 0) {
            // grid along the path
            // if the grid along the direction is unaccessable, then all neighbours
            // can be pruned.
            if ([self.grids isAccessableAtGridX:cx gridY:cy+dy]) {                
                [neighbours addObject:[self.grids getGridWithGridX:cx withGridY:cy+dy]];
                
                // maybe two force grid
                if (![self.grids isAccessableAtGridX:cx+1 gridY:cy] &&
                    [self.grids isAccessableAtGridX:cx+1 gridY:cy+dy]) {
                    [neighbours addObject:[self.grids getGridWithGridX:cx+1 withGridY:cy+dy]];
                }
                if (![self.grids isAccessableAtGridX:cx-1 gridY:cy] &&
                    [self.grids isAccessableAtGridX:cx-1 gridY:cy+dy]) {
                    [neighbours addObject:[self.grids getGridWithGridX:cx-1 withGridY:cy+dy]];
                }
                
            }
        }
        // search horizontally 
        else if(dy == 0){
            // grid along the path
            if ([self.grids isAccessableAtGridX:cx+dx gridY:cy]) {
                [neighbours addObject:[self.grids getGridWithGridX:cx+dx withGridY:cy]];
                
                // maybe two force grid
                if (![self.grids isAccessableAtGridX:cx gridY:cy+1] &&
                    [self.grids isAccessableAtGridX:cx+dx gridY:cy+1]) {
                    [neighbours addObject:[self.grids getGridWithGridX:cx+dx withGridY:cy+1]];
                }
                if (![self.grids isAccessableAtGridX:cx gridY:cy-1]&&
                    [self.grids isAccessableAtGridX:cx+dx gridY:cy-1]) {
                    [neighbours addObject:[self.grids getGridWithGridX:cx+dx withGridY:cy-1]];
                }
            }
        }
        // search diagonally
        else{ 
            /**
             * 3 natural neighbour
             *  for example:
             *  +---+---+---+ <> means if this is unaccessable, 
             *  | 4 | 1 | 3 | there will be a force grid.
             *  +---+---+---+ dx == 1 and dy == 1
             *  |<6>| x | 2 |
             *  +---+---+---+
             *  |px |<7>| 5 |
             *  +---+---+---+  px == parent of x
             */
            
            // if the horizontal and vertical neighbour are both unaccessable, then
            // all the neighbour can be pruned.
            
            if ([self.grids isAccessableAtGridX:cx gridY:cy+dy]/*1*/ || 
                [self.grids isAccessableAtGridX:cx+dx gridY:cy]/*2*/) {
                if ([self.grids isAccessableAtGridX:cx gridY:cy+dy]/*1*/) {
                    [neighbours addObject:[self.grids getGridWithGridX:cx withGridY:cy+dy]/*1*/];
                    
                    // only if grid1 is accessable, then the force grid 4
                    // is accessable through grid x.
                    if (![self.grids isAccessableAtGridX:cx-dx gridY:cy]/*6*/ &&
                        [self.grids isAccessableAtGridX:cx-dx gridY:cy+dy]/*4*/) {
                        [neighbours addObject:[self.grids getGridWithGridX:cx-dx withGridY:cy+dy]/*4*/];

                    }
                    
                }
                if ([self.grids isAccessableAtGridX:cx+dx gridY:cy]/*2*/) {
                    [neighbours addObject:[self.grids getGridWithGridX:cx+dx withGridY:cy]/*2*/];
                    if (![self.grids isAccessableAtGridX:cx gridY:cy-dy]/*7*/ &&
                        [self.grids isAccessableAtGridX:cx+dx gridY:cy-dy]/*5*/) {
                        [neighbours addObject:[self.grids getGridWithGridX:cx+dx withGridY:cy-dy]];
                    }
                }
                if ([self.grids isAccessableAtGridX:cx+dx gridY:cy+dy]/*3*/) {
                    [neighbours addObject:[self.grids getGridWithGridX:cx+dx withGridY:cy+dy]/*3*/];
                }
            }
            
        }
        
    }
    else{ // startgrid
        neighbours = [self getEightAdjacentGrid:currentGrid];
    }
    return neighbours;
}

- (BOOL)hasForceNeighbourWithCurrentGrid:(Grid*)currentGrid
                              directionX:(int)dx directionY:(int)dy{
    int cx = currentGrid.pointOfGrid.x;
    int cy = currentGrid.pointOfGrid.y;
    NSAssert(dx != 0 || dy != 0, nil, "jflsd");
    
    // search vertically
    if (dx == 0) {
        // if the grid along the direction is unaccessable, then all neighbours
        // can be pruned.
        if ([self.grids isAccessableAtGridX:cx gridY:cy+dy]) {                
            // maybe two force grid
            if ((![self.grids isAccessableAtGridX:cx+1 gridY:cy] &&
                 [self.grids isAccessableAtGridX:cx+1 gridY:cy+dy])
                ||
                (![self.grids isAccessableAtGridX:cx-1 gridY:cy] &&
                 [self.grids isAccessableAtGridX:cx-1 gridY:cy+dy])){
                    return YES;
                }
        }
    }
    // search horizontally 
    else if(dy == 0){
        // grid along the path
        if ([self.grids isAccessableAtGridX:cx+dx gridY:cy]) {
            // maybe two force grid
            if ((![self.grids isAccessableAtGridX:cx gridY:cy+1] &&
                 [self.grids isAccessableAtGridX:cx+dx gridY:cy+1])
                || 
                (![self.grids isAccessableAtGridX:cx gridY:cy-1]&&
                 [self.grids isAccessableAtGridX:cx+dx gridY:cy-1])) {
                    return YES;
                }
        }
    }
    // search diagonally
    else{ 
        /**
         * 3 natural neighbour
         *  for example:
         *  +---+---+---+ <> means if this is unaccessable, 
         *  | 4 | 1 | 3 | there will be a force grid.
         *  +---+---+---+ dx == 1 and dy == 1
         *  |<6>| x | 2 |
         *  +---+---+---+
         *  |px |<7>| 5 |
         *  +---+---+---+  
         */
        
        // only if grid1 is accessable, then the force grid 4
        // is accessable through grid x.
        if ([self.grids isAccessableAtGridX:cx gridY:cy+dy]/*1*/ &&
            ![self.grids isAccessableAtGridX:cx-dx gridY:cy]/*6*/ && 
            [self.grids isAccessableAtGridX:cx-dx gridY:cy+dy]/*4*/) {
            return YES;
        }
        
        if ([self.grids isAccessableAtGridX:cx+dx gridY:cy]/*2*/ &&
            ![self.grids isAccessableAtGridX:cx gridY:cy-dy]/*7*/ &&
            [self.grids isAccessableAtGridX:cx+dx gridY:cy-dy]/*5*/) {
            return YES;
        }       
    }
    return NO;
}

- (Grid*)jumpWithCurrentGrid:(Grid*)currentGrid diretionX:(int)dx directionY:(int)dy{
    NSAssert(dx>-2 && dx<2 && dy>-2 && dy<2, nil);
    NSAssert(dx != 0 || dy != 0, @"(%d, %d)\n", dx, dy);
    int x = currentGrid.pointOfGrid.x;
    int y = currentGrid.pointOfGrid.y;
    Grid *nextGrid = [self.grids getGridWithGridX:currentGrid.pointOfGrid.x+dx
                                        withGridY:currentGrid.pointOfGrid.y+dy]; 

    // if nextGrid is an obstacle or is outside the grid
    if (!nextGrid || nextGrid.gridType == UnaccessableGrid) {
        return nil;
    }
    if (nextGrid == self.endGrid) {
        return nextGrid;
    }
    // if ∃ n′ ∈ neighbours(n) s.t. n′ is forced then
    if ([self hasForceNeighbourWithCurrentGrid:nextGrid directionX:dx directionY:dy]) {
        return nextGrid;
    }
    
    // when moving diagonally, must check for vertical/horizontal jump points
    
    //CGPoint directionPoint = [self getDirectionPointWithCurrentGrid:nextGrid];
    if (dx != 0 && dy != 0) {
        Grid *hGrid = [self jumpWithCurrentGrid:nextGrid diretionX:dx directionY:0];
        Grid *vGrid = [self jumpWithCurrentGrid:nextGrid diretionX:0 directionY:dy];
        if (vGrid || hGrid) {
            return nextGrid;
        }
    }
    
    return [self jumpWithCurrentGrid:nextGrid diretionX:dx directionY:dy];
}

- (NSMutableArray*)identifySuccessors:(Grid *)currentGrid{
    NSMutableArray *successors = [[NSMutableArray alloc] init];
    NSMutableArray *neighbours = [self findNeighboursAfterPruning:currentGrid];
    
    for (Grid *g in neighbours){
        g.fromGrid = currentGrid;
    }
    
    for (Grid *grid in neighbours){
        int dx = grid.pointOfGrid.x - currentGrid.pointOfGrid.x;
        int dy = grid.pointOfGrid.y - currentGrid.pointOfGrid.y;
        Grid *g = [self jumpWithCurrentGrid:currentGrid diretionX:dx directionY:dy];
        if (g && g.gridState != InCloseList) {
            [successors addObject:g];
        }
    }
    return successors;
}

- (void)jumpPointSearch{
    for(Grid *grid in self.grids.gridArray){
        grid.movementCost = 0;
        grid.movementCostWithHeuristic = 0;
        grid.gridState = NotProcessed;
        grid.fromGrid = nil;
        if (grid.color == [NSColor yellowColor]) {
            grid.color = [NSColor whiteColor];
        }
    }
    
    Heap *openList = [[Heap alloc]init];
    [openList push:self.startGrid];
    while (![openList isEmpty]) {
        
        //Grid *jfsld = self.endGrid;
        Grid *currentGrid = [openList pop];
        currentGrid.gridState = InCloseList;
        
        if (currentGrid == self.endGrid) {
            [self.gridView setNeedsDisplay:YES];
            [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode
                                     beforeDate: [NSDate date]];
            [NSThread sleepForTimeInterval:0.1];
            break;
        }
        
        NSMutableArray *successors = [self identifySuccessors:currentGrid];
        for (Grid *g in successors){
            int distance = abs(g.pointOfGrid.x-currentGrid.pointOfGrid.x) +
                abs(g.pointOfGrid.y-currentGrid.pointOfGrid.y);
            int heuristic = [self ManhattanHeuristic:g];// distance between g and endGrid
            
            if (g.gridState == NotProcessed) {
                g.movementCost = currentGrid.movementCost + distance;
                g.movementCostWithHeuristic = heuristic + g.movementCost;
                g.fromGrid = currentGrid;
                
                [openList push:g];
                g.gridState = InOpenList;
            }
            
            else if(g.gridState == InOpenList){
                if ((distance + currentGrid.movementCost) < g.movementCost) {
                    g.fromGrid = currentGrid;
                    g.movementCost = currentGrid.movementCost + distance;
                    g.movementCostWithHeuristic = heuristic + g.movementCost;
                    
                    [openList updateGrid:g];
                }
            }
        }
        [self.gridView setNeedsDisplay:YES];
        [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode
                                 beforeDate: [NSDate date]];
        [NSThread sleepForTimeInterval:0.1];
    }
    
}
@end
