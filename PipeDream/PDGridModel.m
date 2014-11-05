//
//  PDGridModel.m
//  PipeDream
//
//  Created by Jean Sung, Kathryn Aplin, Paula Yuan and Vincent Fiorentini.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDGridModel.h"
#import "PDOpenings.h"
#import "PDCellModel.h"
#import "PDQueue.h"
#import "PDGridGenerator.h"

@interface PDGridModel ()

@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, strong) PDCellModel *startCell;
@property (nonatomic, strong) PDCellModel *goalCell;


@end

@implementation PDGridModel

#pragma mark Public methods
/* Input: A level number.
 * Output: Initialized GridModel.
 * Creates the array of cells corresponding to the level.
 */
- (id)initWithLevelNumber:(NSInteger)number {
    NSMutableArray *generatedCells = [PDGridGenerator generateGridForLevelNumber:number];
    return [[PDGridModel alloc] initWithGrid:generatedCells];
}

- (id)initWithGrid:(NSMutableArray *)grid {
    self = [super init];
    if (self) {
        [self setGrid:grid];
        [self spreadVisiblityFromStart];
        [self spreadInitialInfection];
    }
    return self;
}

- (NSInteger)numRows {
    if (_cells == nil) {
        return 0;
    }
    
    return [_cells count];
}

- (NSInteger)numCols {
    if (_cells == nil) {
        return 0;
    }
    
    if ([_cells count] == 0) {
        return 0;
    }
    
    return [[_cells objectAtIndex:0] count];
}

- (void)rotateClockwiseCellAtRow:(NSInteger)row col:(NSInteger)col {
    PDCellModel *cell = [self getCellAtRow:row col:col];
    
    if (cell == nil) {
        return;
    }
    
    [cell rotateClockwise];
    [self spreadVisiblityFromStart];
    [self checkRotationInfectionSpreadFromCellAtRow:row col:col];
}

- (BOOL)isStartConnectedToGoal {
    return [self isConnectedFromRow:[_startCell row] col:[_startCell col] toRow:[_goalCell row]
        col:[_goalCell col]];
}

- (void) clearInfectionFromRow:(NSInteger)row col:(NSInteger)col {
    [self setInfectedFromCellAtRow:row col:col infected:NO];
}

- (BOOL) isInfectedAtRow:(NSInteger)row col:(NSInteger)col {
    PDCellModel *cell = [self getCellAtRow:row col:col];
    return cell.isInfected;
}

- (BOOL) isVisibleAtRow:(NSInteger)row col:(NSInteger)col {
    PDCellModel *cell = [self getCellAtRow:row col:col];
    return cell.isVisible;
}

/* Output: YES if there exists a path of connections from the cell at the first 
 * given coordinates to the cell at the second given coordinates, where a 
 * connection is when adjacent cells have complementary openings.
 */
- (BOOL)isConnectedFromRow:(NSInteger)rowFrom col:(NSInteger)colFrom
                      toRow:(NSInteger)rowTo col:(NSInteger)colTo {
    NSMutableArray *searched = [self getConnectedCellsFromCellAtRow:rowFrom col:colFrom];
    for (int i = 0; i < [searched count]; i++) {
        PDCellModel *cell = [searched objectAtIndex:i];
        if ([cell row] == rowTo && [cell col] == colTo) {
            return YES;
        }
    }
    return NO;
}

- (PDOpenings *)openingsAtRow:(NSInteger)row col:(NSInteger)col {
    PDCellModel *cell = [self getCellAtRow:row col:col];
    
    if (cell == nil) {
        return nil;
    }
    
    return [cell openings];
}

- (BOOL)isStartAtRow:(NSInteger)row col:(NSInteger)col {
    PDCellModel *cell = [self getCellAtRow:row col:col];
    
    if (cell == nil) {
        return NO;
    }

    return [cell isStart];
}

- (BOOL)isGoalAtRow:(NSInteger)row col:(NSInteger)col {
    PDCellModel *cell = [self getCellAtRow:row col:col];
    
    if (cell == nil) {
        return NO;
    }
    
    return [cell isGoal];
}

- (PDCellModel *)getCellAtRow:(NSInteger)row col:(NSInteger)col {
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

#pragma mark Private methods
/* Executes a breadth-first-search from a cell, returning the cell and anything that is connected to
 * it in the order visited.
 */
- (NSMutableArray *)getConnectedCellsFromCellAtRow:(NSInteger)row col:(NSInteger)col {
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
    
    // Create a queue to hold everything that has been visited.
    NSMutableArray *vistedArray = [[NSMutableArray alloc] init];
    
    // Enqueue the starting cell.
    PDCellModel *startCell = [self getCellAtRow:row col:col];
    [queue enqueue:startCell];
    [[visited objectAtIndex:row] replaceObjectAtIndex:col withObject:
     [NSNumber numberWithBool:YES]];
    
    while (![queue isEmpty]) {
        PDCellModel *cell = [queue dequeue];
        [vistedArray addObject:cell];
        
        // Enqueue all non-visited connected neighboring cells.
        NSMutableArray *neighbors = [self getConnectedNeighborsOfCellAtRow:[cell row]
                                                                       col:[cell col]];
        NSUInteger numNeighbors =[neighbors count];
        for (int i = 0; i < numNeighbors; i++) {
            PDCellModel *connectedCell = [neighbors objectAtIndex:i];
            if (![[[visited objectAtIndex:[connectedCell row]] objectAtIndex:
                  [connectedCell col]] boolValue]) {
                [queue enqueue:connectedCell];
                [[visited objectAtIndex:[connectedCell row]]
                 replaceObjectAtIndex:[connectedCell col]
                 withObject:[NSNumber numberWithBool:YES]];
            }
        }
    }
    
    return vistedArray;
}

- (NSMutableArray *)getConnectedNeighborsOfCellAtRow:(NSInteger)row col:(NSInteger)col {
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

/*
 * Spreads visibility from a given cell by making visible all cells connected to it, or adjacent to
 * cells connected to it.
 */
- (void)spreadVisibilityFromCellAtRow:(NSInteger)row col:(NSInteger)col {
    NSMutableArray *connectedCells = [self getConnectedCellsFromCellAtRow:row col:col];
    for (int i = 0; i < [connectedCells count]; i++) {
        PDCellModel *currentCell = [connectedCells objectAtIndex:i];
        currentCell.isVisible = YES;
        NSMutableArray* neighbors = [self getNeighborsOfCellAtRow:[currentCell row]
            col:[currentCell col]];
        for (int j = 0; j < [neighbors count]; j++) {
            PDCellModel *neighCell = [neighbors objectAtIndex:j];
            neighCell.isVisible = YES;
        }
    }
}

- (void)spreadVisiblityFromStart {
    [self spreadVisibilityFromCellAtRow:[self.startCell row] col:[self.startCell col]];
}

/* Returns all neighbors of a cell regardless of connectivity, given coordinates of a cell.
 */
- (NSMutableArray *)getNeighborsOfCellAtRow:(NSInteger)row col:(NSInteger)col {
    NSMutableArray *neighbors = [[NSMutableArray alloc] init];
    if (row > 0) {
        PDCellModel *northNeighbor = [self getCellAtRow:row - 1 col:col];
        [neighbors addObject:northNeighbor];
    }
    
    if (col < [self numCols] - 1) {
        PDCellModel *eastNeighbor = [self getCellAtRow:row col:col + 1];
        [neighbors addObject:eastNeighbor];
    }
    
    if (row < [self numRows] - 1) {
        PDCellModel *southNeighbor = [self getCellAtRow:row + 1 col:col];
        [neighbors addObject:southNeighbor];
    }
    
    if (col > 0) {
        PDCellModel *westNeighbor = [self getCellAtRow:row col:col - 1];
        [neighbors addObject:westNeighbor];
    }
    return neighbors;
}

- (void)setGrid:(NSMutableArray *)grid {
    _cells = grid;
    NSUInteger numRows = [_cells count];
    for (int row = 0; row < numRows; row++) {
        NSUInteger numCols = [[_cells objectAtIndex:row] count];
        for (int col = 0; col < numCols; col++) {
            PDCellModel *current = [[_cells objectAtIndex:row] objectAtIndex:col];
            if ([current isStart]) {
                _startCell = current;
            }
            
            if ([current isGoal]) {
                _goalCell = current;
            }
        }
    }
}

/*
 * From a given cell's coordinates, sets all cells connected to it to either all be infected, or all
 * be not infected.
 */
- (void)setInfectedFromCellAtRow:(NSInteger)row col:(NSInteger)col infected:(BOOL)isInfected {
    NSMutableArray *cells = [self getConnectedCellsFromCellAtRow:row col:col];
    for (int i = 0; i < [cells count]; i++) {
        PDCellModel *cell = [cells objectAtIndex:i];
        cell.isInfected = isInfected;
    }
}

/*
 * For an initial grid, searches for infected cells and spreads infection from them.
 */
- (void)spreadInitialInfection {
    NSMutableArray *infectedCells = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self numRows]; i++) {
        for (int j = 0; j < [self numCols]; j++) {
            PDCellModel *cell = [self getCellAtRow:i col:j];
            if (cell.isInfected) {
                [infectedCells addObject:cell];
            }
        }
    }
    
    for (int i = 0; i < [infectedCells count]; i++) {
        PDCellModel *cell = [infectedCells objectAtIndex:i];
        [self setInfectedFromCellAtRow:[cell row] col:[cell col] infected:YES];
    }
}

/*
 */
- (void)checkRotationInfectionSpreadFromCellAtRow:(NSInteger)row col:(NSInteger)col {
    NSMutableArray *connectedNeighbors = [self getConnectedNeighborsOfCellAtRow:row col:col];
    for (int i = 0; i < [connectedNeighbors count]; i++) {
        PDCellModel *cell = [connectedNeighbors objectAtIndex:i];
        if (cell.isInfected) {
            [self setInfectedFromCellAtRow:[cell row] col:[cell col] infected:YES];
        }
    }
}

@end
