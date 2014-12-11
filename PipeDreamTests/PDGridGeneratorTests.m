//
//  PDGridGeneratorTests.m
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

@interface PDGridGeneratorTests : XCTestCase

@end

@implementation PDGridGeneratorTests

NSString *TEST_GRID_GENERATOR_ENCODING = @"4 4 3 0 0 3 1 NExx* NxSx xESx xxSW xxSW NESx xESW xExW NESW xExW NxxW xxSW xExx xESx xESW NExW";
NSString *TEST_NO_FOG = @"4 4 3 0 0 3 0 NExx* NxSx xESx xxSW xxSW NESx xESW xExW NESW xExW NxxW xxSW xExx xESx xESW NExW";

/* Tests the generation of a grid of cells, and the correct setting of the start and goal. Also tests
 * that a pipe is correctly read, thus implicitly testing the openings methods.
 */
- (void)testGridGenerator {
    
    NSMutableArray *gridArray = [PDGridGenerator generateGridFromString:TEST_GRID_GENERATOR_ENCODING];
    
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

/* Tests that the GridGenerator properly sets infection and fog
 */
- (void)testGridGeneratorFogInfection {
    
    NSMutableArray *fogGridArray = [PDGridGenerator generateGridFromString:TEST_GRID_GENERATOR_ENCODING];
    NSMutableArray *noFogGridArray = [PDGridGenerator generateGridFromString:TEST_NO_FOG];
    
    // Check that visibility is properly set.
    PDCellModel *foggyCell = [[fogGridArray objectAtIndex: 1] objectAtIndex: 1];
    XCTAssertFalse([foggyCell isVisible], @"Visibility is properly set for fog");
    PDCellModel *visibleCell = [[noFogGridArray objectAtIndex: 1] objectAtIndex: 1];
    XCTAssert([visibleCell isVisible], @"Visibility is properly set for no fog");
    
    // Check that infection is properly set
    PDCellModel *infectedCell = [[noFogGridArray objectAtIndex: 0] objectAtIndex: 0];
    XCTAssert([infectedCell isInfected], @"Infection is properly set");
    PDCellModel *healthyCell = [[noFogGridArray objectAtIndex: 1] objectAtIndex: 0];
    XCTAssertFalse([healthyCell isInfected], @"Infection is properly set");
}

/*
 * Tests that methods in Grid Generator that check for valid input and will throw an exception if
 * they are nil.
 */
-(void)testValidInputGridGenerator {
    XCTAssertThrowsSpecificNamed([PDGridGenerator generateGridForLevelNumber:-1],
                                 NSException, @"InvalidLevelNumberException");
    XCTAssertThrowsSpecificNamed([PDGridGenerator generateGridFromString: nil],
                                 NSException, @"InvalidLevelStringException");
    XCTAssertThrowsSpecificNamed([PDGridGenerator getLineFromString:nil forLevel:0],
                                 NSException, @"InvalidAllGridsException");
    XCTAssertThrowsSpecificNamed([PDGridGenerator parseLine:nil],
                                 NSException, @"InvalidGridLineException");
}

@end

