//
//  PDGridView.m
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/13/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDGridView.h"

@interface PDGridView ()

@property (nonatomic, strong) NSMutableArray *cellViews;

@end

@implementation PDGridView

#pragma mark Public methods

- (void) rotateClockwiseCellAtRow:(NSInteger)row col:(NSInteger)col {
    // TODO: Implement this method.
}

- (void) setCellAtRow:(NSInteger)row col:(NSInteger)col
          isOpenNorth:(BOOL)north east:(BOOL)east south:(BOOL)south west:(BOOL)west {
    // TODO: Implement this method.
}

- (void) setStart:(BOOL)start atRow:(NSInteger)row col:(NSInteger)col {
    // TODO: Implement this method.
}

- (void) setGoal:(BOOL)goal atRow:(NSInteger)row col:(NSInteger)col {
    // TODO: Implement this method.
}

#pragma mark Private methods

- (void) cellPressedAtRow:(NSInteger)row col:(NSInteger)col {
    [self.delegate cellPressedAtRow:row col:col];
}

@end
