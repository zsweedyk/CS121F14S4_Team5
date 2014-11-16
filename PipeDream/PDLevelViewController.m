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

// We identify the various alert views with these tags.
NSInteger LEVEL_COMPLETE_TAG = 0;
NSInteger RETURN_TO_SELECT_TAG = 1;
NSInteger RESTART_LEVEL_TAG = 2;

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
        alertView.tag = LEVEL_COMPLETE_TAG;
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

// Return to the level select view controller without unlocking any levels.
- (void)returnToLevelSelectButtonPressed:(id)sender {
    NSString *returnToLevelSelectTitle = @"Return to level select? Your progress on this level will not be saved.";
    NSString *cancelButtonTitle = @"Cancel";
    NSString *continueButtonTitle = @"Ok";
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:returnToLevelSelectTitle
                              message:nil
                              delegate:self
                              cancelButtonTitle:cancelButtonTitle
                              otherButtonTitles:continueButtonTitle, nil];
    alertView.tag = RETURN_TO_SELECT_TAG;
    [alertView show];
}

// Restart the level
- (void)restartLevelButtonPressed:(id)sender {
    NSString *returnToLevelSelectTitle = @"Are you sure you want to restart the current level?";
    NSString *cancelButtonTitle = @"Cancel";
    NSString *continueButtonTitle = @"Ok";
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:returnToLevelSelectTitle
                              message:nil
                              delegate:self
                              cancelButtonTitle:cancelButtonTitle
                              otherButtonTitles:continueButtonTitle, nil];
    alertView.tag = RESTART_LEVEL_TAG;
    [alertView show];
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
    NSArray *allSeguesToMiniGames = [NSArray arrayWithObjects:@"LevelToSpam", nil];
    int randomIndex = arc4random() % [allSeguesToMiniGames count];
    [self performSegueWithIdentifier:allSeguesToMiniGames[randomIndex] sender:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == LEVEL_COMPLETE_TAG) {
        // When the "level complete" alert is clicked, return to level select and unlock the next level.
        [PDLevelSelectionViewController unlockLevelNumber:self.levelNumber + 1];
        PDLevelSelectionViewController *levelSelectionViewController =
            (PDLevelSelectionViewController *) self.presentingViewController;
        [levelSelectionViewController updateLevelSelectButtonsEnabled];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else if (alertView.tag == RETURN_TO_SELECT_TAG) {
        // When the "return to level select" alert is clicked, return to level select.
        NSInteger continueButtonIndex = 1;
        // buttonIndex 0 is the cancel button, buttonIndex 1 is the continue button.
        if (buttonIndex == continueButtonIndex) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    } else if (alertView.tag == RESTART_LEVEL_TAG) {
        // When the "restart level" alert is clicked, start the current level (again).
        NSInteger continueButtonIndex = 1;
        // buttonIndex 0 is the cancel button, buttonIndex 1 is the continue button.
        if (buttonIndex == continueButtonIndex) {
            [self startLevelNumber:self.levelNumber];
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController conformsToProtocol:@protocol(PDMiniGameProtocol)]) {
        [segue.destinationViewController startMiniGame];
    }
}

@end
