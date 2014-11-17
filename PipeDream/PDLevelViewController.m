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
#import "PDLevelSelectionViewController.h"
#import "PDMiniGameProtocol.h"

@interface PDLevelViewController () <PDCellPressedDelegate>

@property (nonatomic, strong) PDGridModel *gridModel;
@property (nonatomic) NSInteger selectedInfectedRow;
@property (nonatomic) NSInteger selectedInfectedCol;

@end

@implementation PDLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gridView.delegate = self;
    // To show a minigame view controller on top of this one, we set self.modalPresentationStyle.
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self startLevelNumber:self.levelNumber];
}

#pragma mark Public methods

- (void) cellPressedAtRow:(NSInteger)row col:(NSInteger)col {
    if (![self.gridModel isVisibleAtRow:row col:col]) {
        return;
    }
    
    if ([self.gridModel isInfectedAtRow:row col:col]) {
        self.selectedInfectedRow = row;
        self.selectedInfectedCol = col;
        [self startMiniGame];
        return;
    }
    
    if (![self.gridModel isGoalAtRow:row col:col] && ![self.gridModel isStartAtRow:row col:col] &&
        [self.gridModel isVisibleAtRow:row col:col]) {
        [self.gridModel rotateClockwiseCellAtRow:row col:col];
    }
    
    [self setGridViewToMatchModel];
    
    if ([self.gridModel isStartConnectedToGoal]) {
        NSString *levelCompletedTitle = @"Level completed!";
        NSString *cancelButtonTitle = @"Ok!";
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:levelCompletedTitle
                                  message:nil
                                  delegate:self
                                  cancelButtonTitle:cancelButtonTitle
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

// completeMiniGameWithSuccess clears the selected infection if success is YES.
- (void) completeMiniGameWithSuccess:(BOOL)success {
    if (!success) {
        return;
    }
    [self.gridModel clearInfectionFromRow:self.selectedInfectedRow col:self.selectedInfectedCol];
    [self setGridViewToMatchModel];
}

#pragma mark Private methods

- (void) startLevelNumber:(NSInteger)levelNumber {
    NSInteger zeroIndexedLevelNumber = levelNumber - 1;
    self.gridModel = [[PDGridModel alloc] initWithLevelNumber:zeroIndexedLevelNumber];
    [self setGridViewToMatchModel];
}

// setGridViewToMatchModel sets every cell in the gridView to match the gridModel.
- (void) setGridViewToMatchModel {
    
    NSInteger numRows = [self.gridModel numRows];
    NSInteger numCols = [self.gridModel numCols];
    [self.gridView drawGridFromDimension:numRows];
    for (int row = 0; row < numRows; row++) {
        for (int col = 0; col < numCols; col++) {
            PDCellModel *model = [self.gridModel getCellAtRow:row col:col];
            [self.gridView setCellAtRow:row col:col cell:model];
        }
    }
}

// startMiniGame starts a randomly selected mini game.
- (void)startMiniGame {
    NSArray *allSeguesToMiniGames = [NSArray arrayWithObjects:@"LevelToBounceAndSort", nil];
    int randomIndex = arc4random() % [allSeguesToMiniGames count];
    [self performSegueWithIdentifier:allSeguesToMiniGames[randomIndex] sender:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // When the "level complete" alert is clicked, return to level select and unlock the next level.
    [PDLevelSelectionViewController unlockLevelNumber:self.levelNumber + 1];
    PDLevelSelectionViewController *levelSelectionViewController =
        (PDLevelSelectionViewController *) self.presentingViewController;
    [levelSelectionViewController updateLevelSelectButtonsEnabled];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController conformsToProtocol:@protocol(PDMiniGameProtocol)]) {
        [segue.destinationViewController startMiniGame];
    }
}

@end
