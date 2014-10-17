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

@interface PDLevelViewController ()

@property (nonatomic, strong) PDGridModel *gridModel;

@end

@implementation PDLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

#pragma mark Public methods

- (void) startLevelNumber:(NSInteger)levelNumber {
    // TODO: Implement this method.
}

- (void) initializeGridView {
    // TODO: Implement this method.
}

- (void) initializeGridModel {
    // TODO: Implement this method.
}

- (void) rotateClockwisePipeAtRow:(NSInteger)row col:(NSInteger)col {
    // TODO: Implement this method.
}

#pragma mark Private methods

- (void) cellPressedAtRow:(NSInteger)row col:(NSInteger)col {
    // this method will be called when the gridView tells us, since we will be its delegate
    // TODO: Implement this method.
}

@end
