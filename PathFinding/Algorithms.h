//
//  Algorithms.h
//  PathFinding
//
//  Created by charmjunewonder on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DijkstraAlgorithm,AStarAlgorithm, FudgeAlgorithm
}AlgorithmType;

@class Grid, Grids, MyView;

@interface Algorithms : NSObject

@property (nonatomic, retain)Grids *grids;
@property (nonatomic)int algorithmType;
@property (nonatomic, retain)MyView* gridView;

- (void)runAlgorithmWithStartGrid:(Grid*)startGrid withEndGrid:(Grid*)endGrid;
- (void)DijkstraWithStartGrid:(Grid*)startGrid withEndGrid:(Grid*)endGrid;
- (void)AStarWithStartGrid:(Grid*)startGrid withEndGrid:(Grid*)endGrid;
- (void)FudgeWithStartGrid:(Grid*)startGrid withEndGrid:(Grid*)endGrid;
- (int)ManhattanHeuristic:(Grid*)currentGrid withEndGrid:(Grid*)endGrid;
- (int)ManhattanHeuristicWithStartGrid:(Grid*)startGird currentGrid:(Grid*)currentGrid endGrid:(Grid*)endGrid;
- (NSMutableArray*)getFourAdjacentGrid:(Grid*)currentGrid;
@end