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

@property (nonatomic) NSInteger startRow;
@property (nonatomic) NSInteger startCol;
@property (nonatomic) NSInteger goalRow;
@property (nonatomic) NSInteger goalCol;

@end

@implementation PDLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gridView.delegate = self;
    
    const NSInteger firstLevelNumber = 1;
    [self startLevelNumber:firstLevelNumber];
}

#pragma mark Public methods

- (void) startLevelNumber:(NSInteger)levelNumber {
    self.gridModel = [[PDGridModel alloc] initWithLevelNumber:levelNumber];
    [self setGridViewToMatchModel];
}

- (void) cellPressedAtRow:(NSInteger)row col:(NSInteger)col {
    [self.gridModel rotateClockwiseCellAtRow:row col:col];
    [self setGridViewToMatchModel];
    
    if ([self.gridModel isConnectedFromRow:self.startRow col:self.startCol
                                     toRow:self.goalRow col:self.goalCol]) {
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
    for (int row = 0; row < numRows; row++) {
        for (int col = 0; col < numCols; col++) {
            PDOpenings *openings = [self.gridModel openingsAtRow:row col:col];
            BOOL isStart = [self.gridModel isStartAtRow:row col:col];
            BOOL isGoal = [self.gridModel isGoalAtRow:row col:col];
            
            if (isStart) {
                self.startRow = row;
                self.startCol = col;
            }
            if (isGoal) {
                self.goalRow = row;
                self.goalCol = col;
            }
            
            [self.gridView setCellAtRow:row col:col isOpenNorth:[openings isOpenNorth] east:[openings isOpenEast]
                                  south:[openings isOpenSouth] west:[openings isOpenWest]];
            [self.gridView setStart:isStart atRow:row col:col];
            [self.gridView setGoal:isGoal atRow:row col:col];
        }
    }
}

@end
