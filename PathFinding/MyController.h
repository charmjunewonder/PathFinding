//
//  MyController.h
//  PathFinding
//
//  Created by charmjunewonder on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Grid, Grids, MyView, Algorithms;

@interface MyController : NSObject
@property (weak) IBOutlet MyView *gridView;
@property (weak) IBOutlet NSMatrix *gridTypeRadioGroup;
@property (nonatomic, strong)Grids *grids;
@property (nonatomic, retain)Algorithms *algo;

- (IBAction)gridTypeSelected:(id)sender;
- (IBAction)displayMode:(id)sender;
- (IBAction)startPathFinding:(id)sender;
- (IBAction)clear:(id)sender;
- (IBAction)setAlgorithm:(id)sender;

@end
