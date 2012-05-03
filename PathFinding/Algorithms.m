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

@implementation Algorithms

@synthesize grids = _grids;
@synthesize algorithmType = _algorithmType;
@synthesize gridView = _gridView;

- (int)ManhattanHeuristic:(Grid*)currentGrid withEndGrid:(Grid*)endGrid{
    return (abs(currentGrid.rect.origin.x-endGrid.rect.origin.x) +
            abs(currentGrid.rect.origin.y-endGrid.rect.origin.y))*0.05;
}

- (NSArray*)getFourAdjacentGrid:(Grid*)currentGrid{
    CGPoint currentLocation = [self.grids getGridPointWithX:currentGrid.rect.origin.x withY:currentGrid.rect.origin.y];
    NSMutableArray *adjacentGrids = [NSMutableArray arrayWithCapacity:4];
    for (int x = -1; x < 2; ++x)
        for (int y = -1; y < 2; ++y) {
            if (abs(x+y)==1) {
                Grid *g = [self.grids getGridWithX:currentLocation.x+x withY:currentLocation.y+y];
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
    switch (self.algorithmType) {
        case DijkstraAlgorithm:
            [self DijkstraWithStartGrid:startGrid withEndGrid:endGrid];
            break;
        case AStarAlgorithm:
            [self AStarWithStartGrid:startGrid withEndGrid:endGrid];
            break;
        default:
            break;
    }
}

- (void)DijkstraWithStartGrid:(Grid*)startGrid withEndGrid:(Grid*)endGrid{
    NSMutableArray *fakeQueue = [NSMutableArray arrayWithCapacity:50];
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
        [NSThread sleepForTimeInterval:0.05];
    }
}

- (void)AStarWithStartGrid:(Grid*)startGrid withEndGrid:(Grid*)endGrid{
    
    for(Grid *grid in self.grids.gridArray){
        grid.movementCost = 0;
        grid.movementCostWithHeuristic = 0;
        grid.gridState = NotProcessed;
        grid.fromGrid = nil;
        if (grid.color == [NSColor yellowColor]) {
            grid.color = [NSColor whiteColor];
        }
    }

    
    NSMutableArray *openList = [NSMutableArray arrayWithCapacity:200];
    [openList addObject:startGrid];
    int refreshCount = 0;
    while (endGrid.gridState != InCloseList && openList.count > 0) {
        Grid *currentGrid = [openList objectAtIndex:0];
        currentGrid.gridState = InCloseList;
        [openList removeObject:currentGrid];

        NSArray *adjacentGrids = [self getFourAdjacentGrid:currentGrid];
        for (Grid *adjacentGrid in adjacentGrids){
            if (adjacentGrid.gridState == InCloseList) continue;
            if (adjacentGrid.gridState == NotProcessed){
                adjacentGrid.movementCost = currentGrid.movementCost + 1;
                adjacentGrid.movementCostWithHeuristic = [self ManhattanHeuristic:adjacentGrid withEndGrid:endGrid] + adjacentGrid.movementCost;
                adjacentGrid.gridState = InOpenList;
                adjacentGrid.fromGrid = currentGrid;
                
                int i = 0;
                if (openList.count == 0) {
                    [openList addObject:adjacentGrid];
                }
                else{
                    int insertNum = (int)openList.count;
                    for (Grid *g in openList){
                        if (g.movementCostWithHeuristic > adjacentGrid.movementCostWithHeuristic) {
                            insertNum = i;
                            break;
                        }
                        i++;
                    }
                    [openList insertObject:adjacentGrid atIndex:insertNum];

                    /*int num=0;
                    for(Grid *grid in openList){
                        printf("%d: %d\n", num, grid.movementCostWithHeuristic);
                        num++;
                    }
                    printf("%d\n", adjacentGrid.movementCostWithHeuristic);
                    
                    
                    num=0;
                    for(Grid *grid in openList){
                        printf("%d: %d\n", num, grid.movementCostWithHeuristic);
                        num++;
                    }
                    printf("\n");*/

                }
            }
            else if(adjacentGrid.gridState == InOpenList){
                //printf("%d > %d\n",1 + currentGrid.movementCost, adjacentGrid.movementCost);
                if ((1 + currentGrid.movementCost) < adjacentGrid.movementCost) {
                    adjacentGrid.fromGrid = currentGrid;
                    adjacentGrid.movementCost = currentGrid.movementCost + 1;
                    adjacentGrid.movementCostWithHeuristic = [self ManhattanHeuristic:adjacentGrid withEndGrid:endGrid] + adjacentGrid.movementCost;

                    openList = [[openList sortedArrayUsingComparator:^(id a, id b){
                        int first = [a movementCostWithHeuristic];
                        int second = [(Grid*)b movementCostWithHeuristic];
                        if (first < second)
                            return (NSComparisonResult)NSOrderedAscending;
                        else if (first > second)
                            return (NSComparisonResult)NSOrderedDescending;
                        else 
                            return (NSComparisonResult)NSOrderedSame;
                    }] mutableCopy];
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
        [NSThread sleepForTimeInterval:0.05];
    }
    
}

@end
