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
    [self readFromMap];
    [self.gridView setGrids:self.grids];
    [self.gridView setGridType:UnaccessableGrid];
    [self.gridView setDisplayMode:DisplayWithColor];
    self.algo = [[Algorithms alloc]init];
    [self.algo setGrids:self.grids];
    [self.algo setGridView:self.gridView];
    
    self.gridView.startGrid = [self.grids getGridWithGridX:19 withGridY:19];
    [self.gridView.startGrid setColor:[NSColor redColor]];
    [self.gridView.startGrid setGridType:StartGrid];
    
    self.gridView.endGrid = [self.grids getGridWithGridX:0 withGridY:0];
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
        grid.movementCost = 0;
        if (grid.gridType != StartGrid && grid.gridType != EndGrid) {
            grid.color = [NSColor whiteColor];
            grid.gridType = NormalGrid;
        }
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
            break;
        case 2:
            self.algo.algorithmType = FudgeAlgorithm;
            break;
        case 3:
            self.algo.algorithmType = JumpPointSearchAlgorithmType;
            break;
        default:
            //NSAssert(false, <#desc#>, <#...#>)
            break;
    }
}

- (void)readFromMap{
    NSError *error;
    NSString *file = [NSString stringWithContentsOfFile:@"map.map" encoding:NSASCIIStringEncoding error:&error];
    if (file == nil) {
        NSLog(@"Error reading file: %@", error);
        exit(1);
    }
   
    //scan the integers from the file
    NSScanner *scanner = [[NSScanner alloc] initWithString:file];
    int height = 0;
    int width = 0;
    if ([scanner scanString:@"height" intoString:NULL]) {
        [scanner scanInt:&height];
        NSLog(@"height: %d", height);
    }
    else{
        NSLog(@"File format error: height");
        exit(1);
    }
    if ([scanner scanString:@"width" intoString:NULL]) {
        [scanner scanInt:&width];
        NSLog(@"width: %d", width);
    }
    else{
        NSLog(@"File format error: width");
        exit(1);
    }

    NSArray *lines = [file componentsSeparatedByString:@"\n"];
    for (int x = height-1; x >1; --x) {
        NSString *line = [lines objectAtIndex:x];
        NSLog(@"%d: %@", x, line);
        for (int y = 0; y < width; ++y) {
            unichar a = [line characterAtIndex:y];
            Grid *g = [self.grids getGridWithGridX:y withGridY:height-x+1];
            if (a == '@') {
                [g setGridType:UnaccessableGrid];
                [g setColor:[NSColor blackColor]];
            }
            else if (a == '.'){
                [g setGridType:NormalGrid];
                [g setColor:[NSColor whiteColor]];
            }
        }
    }
}

@end
