//
//  Heap.h
//  PathFinding
//
//  Created by charmjunewonder on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Grid;

@interface Heap : NSObject{
    NSMutableArray *_heapArray;
}

- (Grid*)pop;
- (void)push:(Grid *)grid;
- (void)pushArray:(NSArray*)array;
- (void)updateGrid:(Grid *)grid;
- (BOOL)isEmpty;

@end
