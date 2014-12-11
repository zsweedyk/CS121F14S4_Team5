//
//  PDGridModelTests.m
//  PipeDream
//
//  Created by CS121 on 12/10/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PDCellModel.h"
#import "PDGridGenerator.h"
#import "PDOpenings.h"
#import "PDGridModel.h"

@interface PDGridModelTests : XCTestCase

@end

@implementation PDGridModelTests

NSString *TEST_GRID_ENCODING = @"4 4 3 0 0 3 1 NExx* NxSx xESx xxSW xxSW NESx xESW xExW NESW xExW NxxW xxSW xExx xESx xESW NExW";
NSString *TEST_GAME_COMPLETED = @"5 5 4 0 0 1 0 NxxW NESW NxxW NxxW NxxW NxxW NxSx NxxW NxxW NxxW NxxW NExx xExW xESW xxSW NxxW NxxW NxxW NxxW NxSx xExx NExW xExW xExW NxxW";
NSString *TEST_INFECTED = @"4 4 3 0 0 3 0 NExx* NxSx xESx xxSW xxSW NESx xESW xExW NESW* xExW NxxW xxSW xExx xESx xESW NExW";

/* Tests the access of openings via a GridModel, and directly from a CellModel. Also tests the
 * interface for querying a CellModel, rather than the openings directly.
 */
- (void)testOpenings {
    
    NSMutableArray *cells = [PDGridGenerator generateGridFromString:TEST_GRID_ENCODING];
    
    PDGridModel *model = [[PDGridModel alloc] initWithGrid:cells];
    
    PDOpenings *openings = [model openingsAtRow:0 col:0];
    
    XCTAssert([openings isOpenNorth] &&
              [openings isOpenEast] &&
              ![openings isOpenSouth] &&
              ![openings isOpenWest], @"Openings accessed correctly through GridModel");
    
    PDCellModel *cell = [[cells objectAtIndex:0] objectAtIndex:0];
    PDOpenings *cellOpenings = [cell openings];
    XCTAssert([cellOpenings isOpenNorth] &&
              [cellOpenings isOpenEast] &&
              ![cellOpenings isOpenSouth] &&
              ![cellOpenings isOpenWest], @"Openings accessed correctly through GridModel");
    
    XCTAssert([cell isOpenNorth] &&
              [cell isOpenEast] &&
              ![cell isOpenSouth] &&
              ![cell isOpenWest], @"Openings accessed correctly through GridModel");
    
}

/* Tests that a gridModel is correctly initialized, with the cells correctly set and processed for
 * grid size, and for testing if cells are the start or goal. Implicitly tests initWithGrid for
 * GridModel.
 */
- (void)testGridModelInitialization {
    
    NSMutableArray *cells = [PDGridGenerator generateGridFromString:TEST_GRID_ENCODING];
    
    PDGridModel *model = [[PDGridModel alloc] initWithGrid:cells];
    XCTAssert([model numRows] == 4, @"Number of rows properly assigned.");
    XCTAssert([model numCols], @"Number of columns properly assigned.");
    
    XCTAssert([model isStartAtRow:3 col:0], @"Start cell properly assigned.");
    XCTAssert([model isGoalAtRow:0 col:3], @"Goal cell properly assigned.");
}

/* Tests connections of an intial grid.
 */
- (void)testConnectionPath {
    
    NSMutableArray *cells = [PDGridGenerator generateGridFromString:TEST_GRID_ENCODING];
    
    PDGridModel *model = [[PDGridModel alloc] initWithGrid:cells];
    
    XCTAssert([model isConnectedFromRow:1 col:0 toRow:0 col:1], @"Simple connection is correctly \
              detected.");
    XCTAssert([model isConnectedFromRow:1 col:2 toRow:2 col:0], @"Connection requiring path finding\
              is correctly detected.");
    
    XCTAssert(![model isConnectedFromRow:3 col:0 toRow:0 col:3], @"Correctly fails to find path \
              between unconnected cells.");
}

/*
 * Tests rotation of openings as accessed from model.
 */
- (void)testGridModelRotateClockwise {
    
    NSMutableArray *cells = [PDGridGenerator generateGridFromString:TEST_GRID_ENCODING];
    
    PDGridModel *model = [[PDGridModel alloc] initWithGrid:cells];
    
    PDOpenings *openings = [model openingsAtRow:0 col:0];
    
    XCTAssert([openings isOpenNorth] &&
              [openings isOpenEast] &&
              ![openings isOpenSouth] &&
              ![openings isOpenWest], @"Original openings accessed correctly through GridModel");
    
    [model rotateClockwiseCellAtRow:0 col:0];
    
    PDOpenings *rotatedOpenings = [model openingsAtRow:0 col:0];
    XCTAssert(![rotatedOpenings isOpenNorth] &&
              [rotatedOpenings isOpenEast] &&
              [rotatedOpenings isOpenSouth] &&
              ![rotatedOpenings isOpenWest], @"Rotated openings accessed correctly through \
              GridModel");
}

/*
 * Tests connection of cells before and after rotations that lead to new connections.
 */
- (void)testRotateConnection {
    
    NSMutableArray *cells = [PDGridGenerator generateGridFromString:TEST_GRID_ENCODING];
    
    PDGridModel *model = [[PDGridModel alloc] initWithGrid:cells];
    
    XCTAssert(![model isConnectedFromRow:3 col:0 toRow:0 col:3], @"Correctly fails to find path \
              between unconnected cells.");
    
    XCTAssert(![model isStartConnectedToGoal], @"Correctly fails to find path between start and \
              goal.");
    
    [model rotateClockwiseCellAtRow:3 col:1];
    [model rotateClockwiseCellAtRow:3 col:1];
    [model rotateClockwiseCellAtRow:2 col:1];
    [model rotateClockwiseCellAtRow:1 col:2];
    
    XCTAssert([model isConnectedFromRow:3 col:0 toRow:0 col:3], @"Correctly finds path after \
              rotations.");
    XCTAssert([model isStartConnectedToGoal], @"Correctly finds path between start and goal.");
}

/*
 * Tests connection from start to goal given an initial grid with path already completed.
 */
- (void)testStartGoalConnection {
    
    NSMutableArray *cells = [PDGridGenerator generateGridFromString:TEST_GAME_COMPLETED];
    
    PDGridModel *model = [[PDGridModel alloc] initWithGrid:cells];
    
    XCTAssert([model isStartConnectedToGoal], @"Correctly finds path between start and goal.");
}

/*
 * Tests the spread of visibility for an initial grid and for after a rotation.
 */
- (void)testVisibilitySpread {
    NSMutableArray *cells = [PDGridGenerator generateGridFromString:TEST_GRID_ENCODING];
    PDGridModel *model = [[PDGridModel alloc] initWithGrid:cells];
    
    XCTAssert([model isVisibleAtRow:3 col:0], @"Start cell is correctly visible.");
    XCTAssertFalse([model isVisibleAtRow:2 col:1],
                   @"Cell not connected to start or path is not visible.");
    XCTAssert([model isVisibleAtRow:3 col:1], @"Cell connected to start or path is visible.");
    
    [model rotateClockwiseCellAtRow:3 col:1];
    XCTAssert([model isVisibleAtRow:2 col:1], @"Cell previously unconnected to start or path is \
              visible");
}

/*
 * Tests the initial infected and uninfected status of a grid, including cells that are infected
 * only by being connected to marked infected cells.
 */
- (void)testInfectionInitial {
    NSMutableArray *cells = [PDGridGenerator generateGridFromString:TEST_INFECTED];
    PDGridModel *model = [[PDGridModel alloc] initWithGrid:cells];
    
    XCTAssert([model isInfectedAtRow:0 col:0], @"Initial marked infected cell is infected.");
    XCTAssert([model isInfectedAtRow:2 col:1], @"Initial unmarked but connected infected cell is \
              connected");
    XCTAssertFalse([model isInfectedAtRow:0 col:2], @"Initial unmakred, uninfected cell is not \
                   infected.");
}

/*
 * Tests that infection spreads after rotation when cells become connected to infected cells.
 */
- (void)testInfectionSpreadFromRotate {
    NSMutableArray *cells = [PDGridGenerator generateGridFromString:TEST_GRID_ENCODING];
    PDGridModel *model = [[PDGridModel alloc] initWithGrid:cells];
    
    XCTAssert([model isInfectedAtRow:0 col:0], @"Initially infected cell is infected.");
    XCTAssertFalse([model isInfectedAtRow:0 col:1], @"Initially uninfected cell is uninfected.");
    XCTAssertFalse([model isConnectedFromRow:0 col:0 toRow:0 col:1], @"Infected cell is not \
                   connected to adjacent uninfected cell.");
    [model rotateClockwiseCellAtRow:0 col:1];
    XCTAssert([model isConnectedFromRow:0 col:0 toRow:0 col:1], @"After rotate, cells are \
              connected.");
    XCTAssert([model isInfectedAtRow:0 col:1], @"After rotate, cell is infected.");
}

/*
 * Tests that an infection clears throughout the infection.
 */
- (void)testInfectionClear {
    NSMutableArray *cells = [PDGridGenerator generateGridFromString:TEST_INFECTED];
    PDGridModel *model = [[PDGridModel alloc] initWithGrid:cells];
    
    XCTAssert([model isInfectedAtRow:0 col:1],@"Initially infected cell is infected.");
    XCTAssert([model isInfectedAtRow:1 col:1], @"Additional infected cell of initial infection is \
              infected.");
    [model clearInfectionFromRow:0 col:1];
    XCTAssertFalse([model isInfectedAtRow:0 col:1], @"Cleared cell is not infected.");
    XCTAssertFalse([model isInfectedAtRow:1 col:1], @"Previously infected cell in initial \
                   infection is also cleared.");
}

/*
 * Tests that methods in Grid Model that call row/col throw an exception if a negative row/col is
 * used.
 */
-(void)testValidInputGridModel {
    NSMutableArray *cells = [PDGridGenerator generateGridFromString:TEST_GRID_ENCODING];
    PDGridModel *model = [[PDGridModel alloc] initWithGrid:cells];
    
    XCTAssertThrowsSpecificNamed([model initWithLevelNumber:-1],
                                 NSException, @"NegativeLevelNumberException");
    XCTAssertThrowsSpecificNamed([model initWithGrid:nil],
                                 NSException, @"InvalidGridException");
    
    XCTAssertThrowsSpecificNamed([model rotateClockwiseCellAtRow:-1 col:0],
                                 NSException, @"NegativeCellLocation");
    XCTAssertThrowsSpecificNamed([model rotateClockwiseCellAtRow:0 col:-1],
                                 NSException, @"NegativeCellLocation");
    XCTAssertThrowsSpecificNamed([model rotateClockwiseCellAtRow:-1 col:-1],
                                 NSException, @"NegativeCellLocation");
    
    XCTAssertThrowsSpecificNamed([model clearInfectionFromRow:-1 col:0],
                                 NSException, @"NegativeCellLocation");
    XCTAssertThrowsSpecificNamed([model clearInfectionFromRow:0 col:-1],
                                 NSException, @"NegativeCellLocation");
    XCTAssertThrowsSpecificNamed([model clearInfectionFromRow:-1 col:-1],
                                 NSException, @"NegativeCellLocation");
    
    XCTAssertThrowsSpecificNamed([model isInfectedAtRow:-1 col:0],
                                 NSException, @"NegativeCellLocation");
    XCTAssertThrowsSpecificNamed([model isInfectedAtRow:0 col:-1],
                                 NSException, @"NegativeCellLocation");
    XCTAssertThrowsSpecificNamed([model isInfectedAtRow:-1 col:-1],
                                 NSException, @"NegativeCellLocation");
    
    XCTAssertThrowsSpecificNamed([model isVisibleAtRow:-1 col:-1],
                                 NSException, @"NegativeCellLocation");
    XCTAssertThrowsSpecificNamed([model isVisibleAtRow:0 col:-1 ],
                                 NSException, @"NegativeCellLocation");
    XCTAssertThrowsSpecificNamed([model isVisibleAtRow:-1 col:0],
                                 NSException, @"NegativeCellLocation");
    
    XCTAssertThrowsSpecificNamed([model isConnectedFromRow:-1 col:0 toRow:0 col:0],
                                 NSException, @"NegativeCellLocation");
    XCTAssertThrowsSpecificNamed([model isConnectedFromRow:0 col:0 toRow:-1 col:0],
                                 NSException, @"NegativeCellLocation");
    
    
    XCTAssertThrowsSpecificNamed([model openingsAtRow:0 col:-1],
                                 NSException, @"NegativeCellLocation");
    XCTAssertThrowsSpecificNamed([model openingsAtRow:-1 col:0],
                                 NSException, @"NegativeCellLocation");
    XCTAssertThrowsSpecificNamed([model openingsAtRow:-1 col:-1],
                                 NSException, @"NegativeCellLocation");
    
    XCTAssertThrowsSpecificNamed([model isStartAtRow:0 col:-1],
                                 NSException, @"NegativeCellLocation");
    XCTAssertThrowsSpecificNamed([model isStartAtRow:-1 col:0],
                                 NSException, @"NegativeCellLocation");
    XCTAssertThrowsSpecificNamed([model isStartAtRow:-1 col:-1],
                                 NSException, @"NegativeCellLocation");
    
    XCTAssertThrowsSpecificNamed([model isGoalAtRow:0 col:-1],
                                 NSException, @"NegativeCellLocation");
    XCTAssertThrowsSpecificNamed([model isGoalAtRow:-1 col:0],
                                 NSException, @"NegativeCellLocation");
    XCTAssertThrowsSpecificNamed([model isGoalAtRow:-1 col:-1],
                                 NSException, @"NegativeCellLocation");
    
    XCTAssertThrowsSpecificNamed([model getCellAtRow:0 col:-1],
                                 NSException, @"InvalidColException");
    XCTAssertThrowsSpecificNamed([model getCellAtRow:-1 col:0],
                                 NSException, @"InvalidRowException");
    XCTAssertThrowsSpecificNamed([model getCellAtRow:-1 col:-1],
                                 NSException, @"InvalidRowException");
    
}

@end

