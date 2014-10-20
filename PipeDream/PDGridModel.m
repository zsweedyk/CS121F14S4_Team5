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
#import "PDQueue.h"
#import "PDGridGenerator.h"

@interface PDGridModel ()

@property (nonatomic, strong) NSMutableArray *cells;

@end

@implementation PDGridModel

#pragma mark Public methods
/* Input: A level number.
 * Output: Initialized GridModel.
 * Creates the array of cells corresponding to the level.
 */
- (id) initWithLevelNumber:(NSInteger)number {
    self = [super init];
    _cells = [PDGridGenerator generateGridForLevelNumber:number];
    return self;
}

- (id) initWithGrid:(NSMutableArray*)grid {
    self = [super init];
    _cells = grid;
    return self;
}

/* Output: The number of rows of cells.
 */
- (NSInteger) numRows {
    if (_cells == nil) {
        return 0;
    }
    
    return [_cells count];
}

/* Output: The number of columns of cells.
 */
- (NSInteger) numCols {
    if (_cells == nil) {
        return 0;
    }
    
    if ([_cells count] == 0) {
        return 0;
    }
    
    return [[_cells objectAtIndex:0] count];
}

/* Rotates the cell at the given coordinates clockwise.
 */
- (void) rotateClockwiseCellAtRow:(NSInteger)row col:(NSInteger)col {
    PDCellModel *cell = [self getCellAtRow:row col:col];
    
    if (cell == nil) {
        return;
    }
    
    [cell rotateClockwise];
}

/* Output: YES if there exists a path of connections from the cell at the first 
 * given coordinates to the cell at the second given coordinates, where a 
 * connection is when adjacent cells have complementary openings.
 */
- (BOOL) isConnectedFromRow:(NSInteger)rowFrom col:(NSInteger)colFrom
                      toRow:(NSInteger)rowTo col:(NSInteger)colTo {
    // Create an array to track which cells have been searched.
    NSMutableArray *visited = [[NSMutableArray alloc] initWithCapacity:[self numRows]];
    for (int row = 0; row < [self numRows]; row++) {
        NSMutableArray *visitedRow = [[NSMutableArray alloc] initWithCapacity:[self numCols]];
        for (int col = 0; col < [self numCols]; col++) {
            [visitedRow addObject:[NSNumber numberWithBool:NO]];
        }
        [visited addObject:visitedRow];
    }
    
    // Create a queue to handle BFS.
    PDQueue *queue = [[PDQueue alloc] init];

    // Enqueue the starting cell.
    PDCellModel *startCell = [self getCellAtRow:rowFrom col:colFrom];
    [queue enqueue:startCell];
    [[visited objectAtIndex:rowFrom] replaceObjectAtIndex:colFrom withObject:[NSNumber numberWithBool:YES]];
    
    while (![queue isEmpty]) {
        PDCellModel *cell = [queue dequeue];
        // If destination is reached, then cells are connected.
        if ([cell row] == rowTo && [cell col] == rowFrom) {
            return YES;
        }
        
        // Enqueue all non-visited connected neighboring cells.
        NSMutableArray *neighbors = [self getConnectedNeighborsOfCellAtRow:[cell row] col:[cell col]];
        for (int i = 0; i < [neighbors count]; i++) {
            PDCellModel *connectedCell = [neighbors objectAtIndex:i];
            if ([[[visited objectAtIndex:[connectedCell row]] objectAtIndex:[connectedCell col]] boolValue] == NO) {
                [queue enqueue:connectedCell];
                [[visited objectAtIndex:[connectedCell row]] replaceObjectAtIndex:[connectedCell col] withObject:[NSNumber numberWithBool:YES]];
            }
        }
    }
    return NO;
}

/* Output: The openings of the cell at the given coordinates.
 */
- (PDOpenings *) openingsAtRow:(NSInteger)row col:(NSInteger)col {
    PDCellModel *cell = [self getCellAtRow:row col:col];
    
    if (cell == nil) {
        return nil;
    }
    
    return [cell openings];
}

/* Output: YES if the cell at the given coordinates is a starting cell.
 */
- (BOOL) isStartAtRow:(NSInteger)row col:(NSInteger)col {
    PDCellModel *cell = [self getCellAtRow:row col:col];
    
    if (cell == nil) {
        return nil;
    }

    return [cell isStart];
}

/* Output: YES if the cell at the given coordinates is a goal cell.
 */
- (BOOL) isGoalAtRow:(NSInteger)row col:(NSInteger)col {
    PDCellModel *cell = [self getCellAtRow:row col:col];
    
    if (cell == nil) {
        return nil;
    }
    
    return [cell isGoal];
}

#pragma mark Private methods
- (PDCellModel*) getCellAtRow:(NSInteger)row col:(NSInteger)col {
    if (_cells == nil) {
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

- (NSMutableArray*) getConnectedNeighborsOfCellAtRow:(NSInteger)row col:(NSInteger) col {
    PDCellModel *cell = [self getCellAtRow:row col:col];

    // Nil marks the cell as unconnected.
    PDCellModel *northNeighbor = nil;
    PDCellModel *eastNeighbor =nil;
    PDCellModel *southNeighbor = nil;
    PDCellModel *westNeighbor = nil;
    
    int numConnected = 0;
    
    // For each cardinal neighbor, check that the neighbor will be in bounds,
    // and then check whether it is connected.
    
    // North neighbor.
    if (row > 0) {
        PDCellModel *northCell = [self getCellAtRow:row - 1 col:col];
        if ([northCell isOpenSouth] && [cell isOpenNorth]) {
            northNeighbor = northCell;
            numConnected++;
        }
    }
    
    // South neighbor.
    if (row < [self numRows] - 1) {
        PDCellModel *southCell = [self getCellAtRow:row + 1 col:col];
        if ([southCell isOpenNorth] && [cell isOpenSouth]) {
            southNeighbor = southCell;
            numConnected++;
        }
    }
    
    // West neighbor.
    if (col > 0) {
        PDCellModel *westCell = [self getCellAtRow:row col:col - 1];
        if ([westCell isOpenEast] && [cell isOpenWest]) {
            westNeighbor = westCell;
            numConnected++;
        }
    }
    
    // East neighbor.
    if (col < [self numCols] - 1) {
        PDCellModel *eastCell = [self getCellAtRow:row col:col + 1];
        if ([eastCell isOpenWest] && [cell isOpenEast]) {
            eastNeighbor = eastCell;
            numConnected++;
        }
    }
    
    // Return only the connected neighbors.
    NSMutableArray *neighbors = [[NSMutableArray alloc] initWithCapacity:numConnected];
    if (northNeighbor != nil) {
        [neighbors addObject:northNeighbor];
    }
    
    if (eastNeighbor != nil) {
        [neighbors addObject:eastNeighbor];
    }
    
    if (southNeighbor != nil) {
        [neighbors addObject:southNeighbor];
    }
    
    if (westNeighbor != nil) {
        [neighbors addObject:westNeighbor];
    }
    
    return neighbors;
}

@end
