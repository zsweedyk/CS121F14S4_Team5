//
//  PipeDreamTests.m
//  PipeDreamTests
//
//  Created by Vincent Fiorentini on 10/13/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PDCellModel.h"
#import "PDGridGenerator.h"
#import "PDOpenings.h"
#import "PDGridModel.h"

@interface PipeDreamTests : XCTestCase

@end

@implementation PipeDreamTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/* Test the creation of cells, and their clockwise rotation.
 */
- (void) testCellRotateClockwise {
    
    // Rotate a horizontal pipe, expect a vertical pipe
    PDCellModel *straightPipe = [[PDCellModel alloc] init];
    PDOpenings *straightPipeOpenings = [[PDOpenings alloc] init];
    [straightPipeOpenings setIsOpenNorth: NO East: YES South: NO West: YES];
    [straightPipe setOpenings: straightPipeOpenings];
    [straightPipe rotateClockwise];
    XCTAssert([[straightPipe openings] isOpenNorth] &&
              ![[straightPipe openings] isOpenEast] &&
              [[straightPipe openings] isOpenSouth] &&
              ![[straightPipe openings] isOpenWest], @"Straight pipe rotated correctly");
    
    // Rotate a pipe with all openings but north, expect a pipe with all openings but east
    PDCellModel *threeWayPipe = [[PDCellModel alloc] init];
    PDOpenings *threeWayPipeOpenings = [[PDOpenings alloc] init];
    [threeWayPipeOpenings setIsOpenNorth: NO East: YES South: YES West: YES];
    [threeWayPipe setOpenings: threeWayPipeOpenings];
    [threeWayPipe rotateClockwise];
    XCTAssert([[threeWayPipe openings] isOpenNorth] &&
              ![[threeWayPipe openings] isOpenEast] &&
              [[threeWayPipe openings] isOpenSouth] &&
              [[threeWayPipe openings] isOpenWest], @"Three-way pipe rotated correctly");
}

/* Tests the generation of a grid of cells, and the correct setting of the start and goal. Also tests
 * that a pipe is correctly read, thus implicitly testing the openings methods.
 */
- (void) testGridGenerator {
    // 4 4 3 0 0 3
    // NExx NxSx xESx xxSW
    // xxSW NESx xESW xExW
    // NESW xExW NxxW xxSW
    // xExx xESx xESW NExW
    NSString *testString = @"4 4 3 0 0 3 NExx NxSx xESx xxSW xxSW NESx xESW xExW NESW xExW NxxW xxSW xExx xESx xESW NExW";
    NSMutableArray *gridArray = [PDGridGenerator generateGridFromString:testString];
    
    // Check that start cell and goal cell are properly assigned
    PDCellModel *startCell = [[gridArray objectAtIndex: 3] objectAtIndex: 0];
    XCTAssert([startCell isStart], @"Start cell properly assigned");
    PDCellModel *goalCell = [[gridArray objectAtIndex: 0] objectAtIndex: 3];
    XCTAssert([goalCell isGoal], @"Goal cell properly assigned");
    
    // Check that pipes are properly decoded
    PDCellModel *topLeftCell = [[gridArray objectAtIndex: 0] objectAtIndex: 0];
    XCTAssert([[topLeftCell openings] isOpenNorth] &&
              [[topLeftCell openings] isOpenEast] &&
              ![[topLeftCell openings] isOpenSouth] &&
              ![[topLeftCell openings] isOpenWest], @"Top left cell properly decoded");
}

/* Tests that a gridModel is correctly initialized, with the cells correctly set and processed for
 * grid size, and for testing if cells are the start or goal. Implicitly tests initWithGrid for
 * GridModel.
 */
- (void) testGridModelInitialization {
    NSString *testString = @"4 4 3 0 0 3 NExx NxSx xESx xxSW xxSW NESx xESW xExW NESW xExW NxxW xxSW xExx xESx xESW NExW";
    
    NSMutableArray *cells = [PDGridGenerator generateGridFromString:testString];
    
    PDGridModel *model = [[PDGridModel alloc] initWithGrid:cells];
    XCTAssert([model numRows] == 4, @"Number of rows properly assigned.");
    XCTAssert([model numCols], @"Number of columns properly assigned.");
    
    XCTAssert([model isStartAtRow:3 col:0], @"Start cell properly assigned.");
    XCTAssert([model isGoalAtRow:0 col:3], @"Goal cell properly assigned.");
}

/* Tests the access of openings via a GridModel, and directly from a CellModel. Also tests the
 * interface for querying a CellModel, rather than the openings directly.
 */
- (void) testOpenings {
    NSString *testString = @"4 4 3 0 0 3 NExx NxSx xESx xxSW xxSW NESx xESW xExW NESW xExW NxxW xxSW xExx xESx xESW NExW";
    
    NSMutableArray *cells = [PDGridGenerator generateGridFromString:testString];
    
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

/* Tests connections of an intial grid.
 */
- (void) testConnectionPath {
    NSString *testString = @"4 4 3 0 0 3 NExx NxSx xESx xxSW xxSW NESx xESW xExW NESW xExW NxxW xxSW xExx xESx xESW NExW";
    
    NSMutableArray *cells = [PDGridGenerator generateGridFromString:testString];
    
    PDGridModel *model = [[PDGridModel alloc] initWithGrid:cells];
    
    XCTAssert([model isConnectedFromRow:1 col:0 toRow:0 col:1], @"Simple connection is correctly detected.");
    XCTAssert([model isConnectedFromRow:1 col:2 toRow:2 col:0], @"Connection requiring path finding is correctly detected.");
    
    XCTAssert(![model isConnectedFromRow:3 col:0 toRow:0 col:3], @"Correctly fails to find path between unconnected cells.");
}

- (void) testGridModelRotateClockwise {
    NSString *testString = @"4 4 3 0 0 3 NExx NxSx xESx xxSW xxSW NESx xESW xExW NESW xExW NxxW xxSW xExx xESx xESW NExW";
    
    NSMutableArray *cells = [PDGridGenerator generateGridFromString:testString];
    
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
              ![rotatedOpenings isOpenWest], @"Rotated openings accessed correctly through GridModel");
}

// NExx NxSx xESx xxSW
// xxSW NESx xESW xExW
// NESW xExW NxxW xxSW
// xExx xESx xESW NExW
- (void) testRotateConnection {
    NSString *testString = @"4 4 3 0 0 3 NExx NxSx xESx xxSW xxSW NESx xESW xExW NESW xExW NxxW xxSW xExx xESx xESW NExW";
    
    NSMutableArray *cells = [PDGridGenerator generateGridFromString:testString];
    
    PDGridModel *model = [[PDGridModel alloc] initWithGrid:cells];
    
    XCTAssert(![model isConnectedFromRow:3 col:0 toRow:0 col:3], @"Correctly fails to find path between unconnected cells.");
    
    XCTAssert(![model isStartConnectedToGoal], @"Correctly fails to find path between start and goal.");
    
    [model rotateClockwiseCellAtRow:3 col:1];
    [model rotateClockwiseCellAtRow:3 col:1];
    [model rotateClockwiseCellAtRow:2 col:1];
    [model rotateClockwiseCellAtRow:1 col:2];
    
    XCTAssert([model isConnectedFromRow:3 col:0 toRow:0 col:3], @"Correctly finds path after rotations.");
    XCTAssert([model isStartConnectedToGoal], @"Correctly finds path between start and goal.");
}
@end
