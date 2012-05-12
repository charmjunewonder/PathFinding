//
//  Heap.m
//  PathFinding
//
//  Created by charmjunewonder on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Heap.h"
#import "Grid.h"

@implementation Heap

-(id)init{
    self = [super init];
    if (self) {
        _heapArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)pushArray:(NSArray *)array{
    for (Grid *grid in array){
        if (grid.gridState == InOpenList) {
            continue;
        }
        [self push:grid];
    }
}

- (void)push:(Grid*)grid{
    if (grid.gridState == InOpenList) {
        return;
    }
    if (_heapArray.count == 0) {
        [_heapArray addObject:grid];
    }
    else{
        int i = 0;
        int insertNum = (int)_heapArray.count;
        for (Grid *g in _heapArray){
            if (g.movementCostWithHeuristic > grid.movementCostWithHeuristic) {
                insertNum = i;
                break;
            }
            i++;
        }
        [_heapArray insertObject:grid atIndex:insertNum];
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

- (void)updateGrid:(Grid*)grid{
    _heapArray = [[_heapArray sortedArrayUsingComparator:^(id a, id b){
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

-(Grid*)pop{
    Grid *grid = [_heapArray objectAtIndex:0];
    [_heapArray removeObject:grid];
    return grid;
}

- (BOOL)isEmpty{
    return _heapArray.count == 0;
}
@end
