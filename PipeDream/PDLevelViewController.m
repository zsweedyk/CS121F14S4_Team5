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
        [self completeLevel];
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
    NSArray *allSeguesToMiniGames = [NSArray arrayWithObjects:@"LevelToSpam", nil];
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

- (void)completeLevel {
    
    // Set up dialog box frame
    CGRect frame = self.view.frame;
    CGFloat x = CGRectGetWidth(frame) * 0.2;
    CGFloat y = CGRectGetHeight(frame) * 0.3;
    CGFloat size = CGRectGetWidth(frame) * 0.6;
    CGRect dialogFrame = CGRectMake(x, y, size, size);
    
    // Set up transparent background
    UIView *backgroundView = [[UIView alloc] initWithFrame:frame];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.5;
    
    // Set up dialog view
    UIView *dialogView = [[UITextView alloc] initWithFrame:dialogFrame];
    dialogView.backgroundColor = [UIColor whiteColor];
    //[dialogView setText:[NSString stringWithFormat:@"Congratulations! You have completed level %d",
    //                     self.levelNumber]];

    // Add views to main view
    [self.view addSubview: backgroundView];
    [self.view addSubview: dialogView];
    
    // Add congrats label to dialog view
    CGFloat dialogSize = CGRectGetWidth(dialogFrame);
    CGRect congratsFrame = CGRectMake(45, 50, dialogSize-90, 100);
    UILabel *congratsLabel = [[UILabel alloc] initWithFrame:congratsFrame];
    [congratsLabel setFont:[UIFont fontWithName:@"Arial" size:50.0f]];
    [congratsLabel setText:@"Congratulations!"];
    [dialogView addSubview:congratsLabel];
    
    // Add level completed label to dialog view
    CGRect levelCompletedFrame = CGRectMake(80, 120, dialogSize-160, 100);
    UILabel *levelCompletedLabel = [[UILabel alloc] initWithFrame:levelCompletedFrame];
    [levelCompletedLabel setFont:[UIFont fontWithName:@"Arial" size:30.0f]];
    [levelCompletedLabel setText:[NSString stringWithFormat:@"You completed level %d!",
                                  self.levelNumber]];
    [dialogView addSubview:levelCompletedLabel];
    
    // Add close button
    CGRect closeFrame = CGRectMake(dialogSize*.3, dialogSize*.6, dialogSize*.4, 50);
    UIButton *closeButton = [[UIButton alloc] initWithFrame:closeFrame];
    [closeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [closeButton.titleLabel setFont:[UIFont systemFontOfSize:24.0f]];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonPressed:)
          forControlEvents:UIControlEventTouchUpInside];
    [dialogView addSubview:closeButton];
    
    // Add next level button
    CGRect nextLevelFrame = CGRectMake(dialogSize*.3, dialogSize*.7, dialogSize*.4, 50);
    UIButton *nextLevelButton = [[UIButton alloc] initWithFrame:nextLevelFrame];
    [nextLevelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [nextLevelButton.titleLabel setFont:[UIFont systemFontOfSize:24.0f]];
    [nextLevelButton setTitle:@"Next Level" forState:UIControlStateNormal];
    [dialogView addSubview:nextLevelButton];
    
}

- (IBAction)closeButtonPressed:(id)sender {
    
}

- (IBAction)nextLevelButtonPressed:(id)sender {
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController conformsToProtocol:@protocol(PDMiniGameProtocol)]) {
        [segue.destinationViewController startMiniGame];
    }
}

@end
