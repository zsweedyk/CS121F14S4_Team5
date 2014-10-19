//
//  PDGridModel.m
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/13/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDGridModel.h"
#import "PDOpenings.h"
#import "PDCellModel.h"

@interface PDGridModel ()

@property (nonatomic, strong) NSMutableArray *cells;

@end

@implementation PDGridModel

#pragma mark Public methods

- (id) initWithLevelNumber:(NSInteger)number {
    // TODO: Implement this method.
    return nil;
}

- (NSInteger) numRows {
    if (_cells == nil) {
        return 0;
    }
    
    return [_cells count];
}

- (NSInteger) numCols {
    if (_cells == nil) {
        return 0;
    }
    
    if ([_cells count] == 0) {
        return 0;
    }
    
    return [[_cells objectAtIndex:0] count];
}

- (void) rotateClockwiseCellAtRow:(NSInteger)row col:(NSInteger)col {
    PDCellModel *cell = [self getCellAtRow:row col:col];
    
    if (cell == nil) {
        return;
    }
    
    [cell rotateClockwise];
}

- (BOOL) isConnectedFromRow:(NSInteger)rowFrom col:(NSInteger)colFrom
                      toRow:(NSInteger)rowTo col:(NSInteger)colTo {
    // TODO: Implement this method.
    return NO;
}

- (PDOpenings *) openingsAtRow:(NSInteger)row col:(NSInteger)col {
    PDCellModel *cell = [self getCellAtRow:row col:col];
    
    if (cell == nil) {
        return nil;
    }
    
    return [cell openings];
}

- (BOOL) isStartAtRow:(NSInteger)row col:(NSInteger)col {
    PDCellModel *cell = [self getCellAtRow:row col:col];
    
    if (cell == nil) {
        return nil;
    }
    
    return [cell isStart];
}

- (BOOL) isGoalAtRow:(NSInteger)row col:(NSInteger)col {
    PDCellModel *cell = [self getCellAtRow:row col:col];
    
    if (cell == nil) {
        return nil;
    }
    
    return [cell isGoal];
}

- (PDCellModel*) getCellAtRow:(NSInteger)row col:(NSInteger)col {
    if (_cells != nil) {
        return nil;
    }
    
    if ([_cells count] <= row) {
        return nil;
    }
    
    if ([[_cells objectAtIndex:row] count] <= col) {
        return nil;
    }
    
    PDCellModel *cell = [[_cells objectAtIndex:row] objectAtIndex:col];
    return cell;
}

#pragma mark Private methods

@end
