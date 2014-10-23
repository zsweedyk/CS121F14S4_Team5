//
//  PDLevelViewController.m
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/13/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDLevelViewController.h"
#import "PDGridView.h"
#import "PDGridModel.h"
#import "PDCellPressedDelegate.h"
#import "PDOpenings.h"

@interface PDLevelViewController () <PDCellPressedDelegate>

@property (nonatomic, strong) PDGridModel *gridModel;

@end

@implementation PDLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gridView.delegate = self;
    
    const NSInteger firstLevelNumber = 0;
    [self startLevelNumber:firstLevelNumber];
}

#pragma mark Public methods

- (void) startLevelNumber:(NSInteger)levelNumber {
    self.gridModel = [[PDGridModel alloc] initWithLevelNumber:levelNumber];
    [self setGridViewToMatchModel];
}

- (void) cellPressedAtRow:(NSInteger)row col:(NSInteger)col {
    if (![self.gridModel isGoalAtRow:row col:col] && ![self.gridModel isStartAtRow:row col:col]) {
        [self.gridModel rotateClockwiseCellAtRow:row col:col];
    }
    [self setGridViewToMatchModel];
    
    if ([self.gridModel isStartConnectedToGoal]) {
        NSString *levelCompletedTitle = @"Level completed!";
        NSString *cancelButtonTitle = @"Ok!";
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:levelCompletedTitle
                                  message:nil
                                  delegate:nil
                                  cancelButtonTitle:cancelButtonTitle
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark Private methods

// setGridViewToMatchModel sets every cell in the gridView to match the gridModel.
- (void) setGridViewToMatchModel {
    
    NSInteger numRows = [self.gridModel numRows];
    NSInteger numCols = [self.gridModel numCols];
    [self.gridView drawGridFromDimension:numRows];
    for (int row = 0; row < numRows; row++) {
        for (int col = 0; col < numCols; col++) {
            PDOpenings *openings = [self.gridModel openingsAtRow:row col:col];
            BOOL isStart = [self.gridModel isStartAtRow:row col:col];
            BOOL isGoal = [self.gridModel isGoalAtRow:row col:col];

            [self.gridView setCellAtRow:row col:col isOpenNorth:[openings isOpenNorth] east:[openings isOpenEast]
                                  south:[openings isOpenSouth] west:[openings isOpenWest]];
            [self.gridView setStart:isStart atRow:row col:col];
            [self.gridView setGoal:isGoal atRow:row col:col];
        }
    }
}

@end
