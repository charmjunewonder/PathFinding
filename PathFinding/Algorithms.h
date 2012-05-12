//
//  Algorithms.h
//  PathFinding
//
//  Created by charmjunewonder on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DijkstraAlgorithm,AStarAlgorithm, FudgeAlgorithm,
    JumpPointSearchAlgorithmType
}AlgorithmType;

typedef enum{
    UpMove, DownMove, LeftMove, RightMove,
    LeftUpMove, LeftDownMove, RightUpMove, RightDownMove 
}MoveDirection;



@class Grid, Grids, MyView;

@interface Algorithms : NSObject

@property (nonatomic, retain)Grids *grids;
@property (nonatomic)AlgorithmType algorithmType;
@property (nonatomic, retain)MyView* gridView;
@property (nonatomic, retain)Grid *startGrid;
@property (nonatomic, retain)Grid *endGrid;

- (void)runAlgorithmWithStartGrid:(Grid*)startGrid withEndGrid:(Grid*)endGrid;
- (void)Dijkstra;
- (void)AStar;
- (void)Fudge;
- (int)ManhattanHeuristic:(Grid*)currentGrid;
- (int)ManhattanHeuristicOfFudge:(Grid*)currentGrid;
- (NSMutableArray*)getFourAdjacentGrid:(Grid*)currentGrid;

@end