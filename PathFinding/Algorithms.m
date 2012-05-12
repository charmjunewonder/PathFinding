//
//  Algorithms.m
//  PathFinding
//
//  Created by charmjunewonder on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Algorithms.h"
#import "Grid.h"
#import "Grids.h"
#import "MyView.h"
#import "Heap.h"
#import "JumpPointSearchAlgorithm.h"

@implementation Algorithms

@synthesize grids = _grids;
@synthesize algorithmType = _algorithmType;
@synthesize gridView = _gridView;
@synthesize startGrid = _startGrid;
@synthesize endGrid = _endGrid;

// prefer straight line
- (int)ManhattanHeuristic:(Grid*)currentGrid{
    CGPoint curPoint = currentGrid.pointOfGrid;
    CGPoint endPoint = self.endGrid.pointOfGrid;

    //return (abs(currentGrid.rect.origin.x-endGrid.rect.origin.x) +
      //      abs(currentGrid.rect.origin.y-endGrid.rect.origin.y))*0.01;
    return (abs(curPoint.x-endPoint.x) + abs(curPoint.y-endPoint.y));
}

// prefer more curly path
- (int)ManhattanHeuristicOfFudge:(Grid*)currentGrid{
    Grid *startGrid = self.startGrid;
    Grid *endGrid = self.endGrid;
    
    CGPoint curPoint = [self.grids getGridPointWithX:currentGrid.rect.origin.x withY:currentGrid.rect.origin.y];
    CGPoint endPoint = [self.grids getGridPointWithX:endGrid.rect.origin.x withY:endGrid.rect.origin.y];
    CGPoint startPoint = [self.grids getGridPointWithX:startGrid.rect.origin.x withY:startGrid.rect.origin.y];
    
    int dx1 = curPoint.x - endPoint.x;
    int dy1 = curPoint.y - endPoint.y;
    int dx2 = startPoint.x - endPoint.x;
    int dy2 = startPoint.y - endPoint.y;
    int cross = abs(dx1*dy2 - dx2*dy1);
    //printf("%d ", (abs(dx1) + abs(dy1)) + cross/50);
    
    return (abs(dx1) + abs(dy1)) + cross/10;
}

- (NSArray*)getFourAdjacentGrid:(Grid*)currentGrid{
    CGPoint currentLocation = [self.grids getGridPointWithX:currentGrid.rect.origin.x withY:currentGrid.rect.origin.y];
    NSMutableArray *adjacentGrids = [NSMutableArray arrayWithCapacity:4];
    for (int x = -1; x < 2; ++x)
        for (int y = -1; y < 2; ++y) {
            if (abs(x+y)==1) {
                Grid *g = [self.grids getGridWithGridX:currentLocation.x+x withGridY:currentLocation.y+y];
                if (g && g.gridType != UnaccessableGrid) {
                    [adjacentGrids addObject:g];
                }
            }
        }
    
    return adjacentGrids;
}

- (void)runAlgorithmWithStartGrid:(Grid*)startGrid withEndGrid:(Grid*)endGrid{
    if (!startGrid || !endGrid) {
        return;
    }
    
    self.startGrid = startGrid;
    self.endGrid = endGrid;
    self.gridView.pathLine = [NSBezierPath bezierPath];
 
    switch (self.algorithmType) {
        case DijkstraAlgorithm:
            [self Dijkstra];
            break;
        case AStarAlgorithm:
            [self AStar];
            break;
        case FudgeAlgorithm:
            [self Fudge];
            break;
        case JumpPointSearchAlgorithmType:
            [[[JumpPointSearchAlgorithm alloc] initWithGrids:self.grids startGrid:self.startGrid endGrid:self.endGrid view:self.gridView] jumpPointSearch];
            break;
        default:
            break;
    }
    [self.gridView redrawPathLine];
}

- (void)Dijkstra{
    NSMutableArray *fakeQueue = [NSMutableArray arrayWithCapacity:50];
    Grid *startGrid = self.startGrid;
    Grid *endGrid = self.endGrid;
    
    [fakeQueue addObject:startGrid];
    
    for(Grid *grid in self.grids.gridArray){
        grid.movementCost = 0;
        grid.gridState = NotProcessed;
        grid.fromGrid = nil;
        if (grid.color == [NSColor yellowColor]) {
            grid.color = [NSColor whiteColor];
        }
    }
    
    int totalQueueObjectNum = 0;
    startGrid.gridState = InCloseList;
    
    Grid *queueObject = startGrid;
    totalQueueObjectNum++;
    NSMutableArray *storeArray = [NSMutableArray arrayWithCapacity:50];
    while (queueObject != endGrid && fakeQueue.count > 0) {
        queueObject = [fakeQueue objectAtIndex:0];
        NSArray *adjacentGrids = [self getFourAdjacentGrid:queueObject];
        for (Grid *adjacentPoint in adjacentGrids){
            if(!adjacentPoint) continue;
            if (adjacentPoint.gridState != InCloseList) {
                [storeArray addObject:adjacentPoint];
                totalQueueObjectNum++;
                adjacentPoint.fromGrid = queueObject;
                adjacentPoint.gridState = InCloseList;
                adjacentPoint.movementCost = queueObject.movementCost + 1;
            }
        }
        [fakeQueue removeObject:queueObject];

        if (fakeQueue.count == 0) {
            fakeQueue = [NSMutableArray arrayWithArray:storeArray];
            [storeArray removeAllObjects];
            
            [self.gridView setNeedsDisplay:YES];
            [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate: [NSDate date]];
            [NSThread sleepForTimeInterval:0.1];
        }
    }
    
    Grid *fromNode = endGrid;
    while (fromNode.fromGrid && fromNode.fromGrid != startGrid) {
        fromNode = fromNode.fromGrid;
        fromNode.color = [NSColor yellowColor];
        [self.gridView setNeedsDisplay:YES];
        [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate: [NSDate date]];
        [NSThread sleepForTimeInterval:0.02];
    }
}

- (void)AStar{
    
    Grid *startGrid = self.startGrid;
    Grid *endGrid = self.endGrid;
    
    for(Grid *grid in self.grids.gridArray){
        grid.movementCost = 0;
        grid.movementCostWithHeuristic = 0;
        grid.gridState = NotProcessed;
        grid.fromGrid = nil;
        if (grid.color == [NSColor yellowColor]) {
            grid.color = [NSColor whiteColor];
        }
    }

    
    Heap *openList = [[Heap alloc] init];
    [openList push:startGrid];
    int refreshCount = 0;
    while (endGrid.gridState != InCloseList && ![openList isEmpty]) {
        Grid *currentGrid = [openList pop];
        currentGrid.gridState = InCloseList;

        NSArray *adjacentGrids = [self getFourAdjacentGrid:currentGrid];
        for (Grid *adjacentGrid in adjacentGrids){
            if (adjacentGrid.gridState == InCloseList) continue;
            if (adjacentGrid.gridState == NotProcessed){
                adjacentGrid.movementCost = currentGrid.movementCost + 1;
                adjacentGrid.movementCostWithHeuristic = [self ManhattanHeuristic:adjacentGrid] + adjacentGrid.movementCost;
                adjacentGrid.fromGrid = currentGrid;
                
                [openList push:adjacentGrid];
                adjacentGrid.gridState = InOpenList;
            }
            else if(adjacentGrid.gridState == InOpenList){
                //printf("%d > %d\n",1 + currentGrid.movementCost, adjacentGrid.movementCost);
                if ((1 + currentGrid.movementCost) < adjacentGrid.movementCost) {
                    adjacentGrid.fromGrid = currentGrid;
                    adjacentGrid.movementCost = currentGrid.movementCost + 1;
                    adjacentGrid.movementCostWithHeuristic = [self ManhattanHeuristic:adjacentGrid] + adjacentGrid.movementCost;

                    [openList updateGrid:adjacentGrid];
                }
            }
        }
        
        if (refreshCount == 10) {
            refreshCount = 0;
            [self.gridView setNeedsDisplay:YES];
            [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate: [NSDate date]];
            [NSThread sleepForTimeInterval:0.1];
        }
        refreshCount++;
    }
    
    Grid *fromNode = endGrid;
    while (fromNode.fromGrid && fromNode.fromGrid != startGrid) {
        fromNode = fromNode.fromGrid;
        fromNode.color = [NSColor yellowColor];
        [self.gridView setNeedsDisplay:YES];
        [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate: [NSDate date]];
        [NSThread sleepForTimeInterval:0.02];
    }
    
}

// DRY!!!!! I will fix this later.
- (void)Fudge{
    Grid *startGrid = self.startGrid;
    Grid *endGrid = self.endGrid;
    for(Grid *grid in self.grids.gridArray){
        grid.movementCost = 0;
        grid.movementCostWithHeuristic = 0;
        grid.gridState = NotProcessed;
        grid.fromGrid = nil;
        if (grid.color == [NSColor yellowColor]) {
            grid.color = [NSColor whiteColor];
        }
    }
    
    Heap *openList = [[Heap alloc] init];
    [openList push:startGrid];
    int refreshCount = 0;
    while (endGrid.gridState != InCloseList && ![openList isEmpty]) {
        Grid *currentGrid = [openList pop];
        currentGrid.gridState = InCloseList;
        
        NSArray *adjacentGrids = [self getFourAdjacentGrid:currentGrid];
        for (Grid *adjacentGrid in adjacentGrids){
            if (adjacentGrid.gridState == InCloseList) continue;
            if (adjacentGrid.gridState == NotProcessed){
                adjacentGrid.movementCost = currentGrid.movementCost + 1;
                adjacentGrid.movementCostWithHeuristic = [self ManhattanHeuristicOfFudge:adjacentGrid] + adjacentGrid.movementCost;
                adjacentGrid.fromGrid = currentGrid;
                
                [openList push:adjacentGrid];
                adjacentGrid.gridState = InOpenList;
            }
            else if(adjacentGrid.gridState == InOpenList){
                //printf("%d > %d\n",1 + currentGrid.movementCost, adjacentGrid.movementCost);
                if ((1 + currentGrid.movementCost) < adjacentGrid.movementCost) {
                    adjacentGrid.fromGrid = currentGrid;
                    adjacentGrid.movementCost = currentGrid.movementCost + 1;
                    adjacentGrid.movementCostWithHeuristic = [self ManhattanHeuristicOfFudge:adjacentGrid] + adjacentGrid.movementCost;
                    
                    [openList updateGrid:adjacentGrid];
                }
            }
        }
        
        if (refreshCount == 3) {
            refreshCount = 0;
            [self.gridView setNeedsDisplay:YES];
            [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate: [NSDate date]];
            [NSThread sleepForTimeInterval:0.1];
        }
        refreshCount++;
    }
    
    Grid *fromNode = endGrid;
    while (fromNode.fromGrid && fromNode.fromGrid != startGrid) {
        fromNode = fromNode.fromGrid;
        fromNode.color = [NSColor yellowColor];
        [self.gridView setNeedsDisplay:YES];
        [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate: [NSDate date]];
        [NSThread sleepForTimeInterval:0.02];
    }
}



@end