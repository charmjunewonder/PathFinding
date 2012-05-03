//
//  MyController.m
//  PathFinding
//
//  Created by charmjunewonder on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyController.h"
#import "MyView.h"
#import "Grids.h"
#import "Grid.h"
#import "Algorithms.h"

@implementation MyController
@synthesize gridView = _gridView;
@synthesize gridTypeRadioGroup = _gridTypeRadioGroup;
@synthesize grids = _grids;
@synthesize algo = algo;

- (void)awakeFromNib{
    self.grids = [[Grids alloc]init];
    [self.gridView setGrids:self.grids];
    [self.gridView setGridType:UnaccessableGrid];
    [self.gridView setDisplayMode:DisplayWithColor];
    self.algo = [[Algorithms alloc]init];
    [self.algo setGrids:self.grids];
    [self.algo setGridView:self.gridView];
    
    self.gridView.startGrid = [self.grids getGridWithX:19 withY:19];
    [self.gridView.startGrid setColor:[NSColor redColor]];
    [self.gridView.startGrid setGridType:StartGrid];
    
    self.gridView.endGrid = [self.grids getGridWithX:0 withY:0];
    [self.gridView.endGrid setColor:[NSColor purpleColor]];
    [self.gridView.endGrid setGridType:EndGrid];

}

- (IBAction)gridTypeSelected:(id)sender {
    NSInteger row = (int)[sender selectedRow];
    switch (row) {
        case 0:
            self.gridView.gridType = UnaccessableGrid;
            break;
        case 1:
            self.gridView.gridType = StartGrid;
            break;
        case 2:
            self.gridView.gridType = EndGrid;
            break;
        default:
            break;
    }
}

- (IBAction)displayMode:(id)sender {
    NSInteger row = (int)[sender selectedRow];
    switch (row) {
        case 0:
            self.gridView.displayMode = DisplayWithColor;
            break;
        case 1:
            self.gridView.displayMode = DisplayWithNumber;
            break;
        default:
            break;
    }
}

- (IBAction)startPathFinding:(id)sender {
    [self.algo runAlgorithmWithStartGrid:self.gridView.startGrid withEndGrid:self.gridView.endGrid];
    [self.gridView setNeedsDisplay:YES];
}

- (IBAction)clear:(id)sender {
    for(Grid *grid in self.grids.gridArray){
        grid.color = [NSColor whiteColor];
        grid.movementCost = 0;
        grid.gridType = NormalGrid;
    }
    [self.gridView setNeedsDisplay:YES];
}

- (IBAction)setAlgorithm:(id)sender {
    int num = (int)[sender indexOfSelectedItem];
    switch (num) {
        case 0:
            self.algo.algorithmType = DijkstraAlgorithm;
            break;
        case 1:
            self.algo.algorithmType = AStarAlgorithm;
        default:
            break;
    }
}

@end
