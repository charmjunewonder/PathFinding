//
//  JumpPointSearchAlgorithm.h
//  PathFinding
//
//  Created by charmjunewonder on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Algorithms.h"

@interface JumpPointSearchAlgorithm : Algorithms

- (id)initWithGrids:(Grids*)gs startGrid:(Grid*)sg endGrid:(Grid*)eg view:(MyView*)v;

- (void)jumpPointSearch;
- (NSMutableArray*)getEightAdjacentGrid:(Grid*)currentGrid;
- (NSMutableArray*)findNeighboursAfterPruning:(Grid *)currentGrid;
- (NSMutableArray*)identifySuccessors:(Grid*)currentGrid;
- (BOOL)hasForceNeighbourWithCurrentGrid:(Grid*)currentGrid directionX:(int)dx directionY:(int)dy;
- (Grid*)jumpWithCurrentGrid:(Grid*)currentGrid diretionX:(int)dx directionY:(int)dy;
@end
