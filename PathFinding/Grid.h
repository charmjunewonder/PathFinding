//
//  Grid.h
//  PathFinding
//
//  Created by charmjunewonder on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    NormalGrid,
    UnaccessableGrid,
    StartGrid,
    EndGrid
}GridType;

typedef enum{
    NotProcessed,
    InCloseList,
    InOpenList
}GridState;

@interface Grid : NSObject

@property (nonatomic)CGRect rect;
@property (nonatomic)CGPoint pointOfGrid;
@property (nonatomic, retain)NSColor *color;
@property (nonatomic)GridType gridType;
@property (nonatomic)int movementCost;
@property (nonatomic)int movementCostWithHeuristic;
@property (nonatomic)GridState gridState;
@property (nonatomic, retain)Grid* fromGrid;
@end
