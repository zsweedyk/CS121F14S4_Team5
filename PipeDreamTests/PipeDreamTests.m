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

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void) testRotateClockwise {
    
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


// 4 4 3 0 0 3
// NExx NxSx xESx xxSW
// xxSW NESx xESW xExW
// NESW xExW NxxW xxSW
// xExx xESx xESW NExW
- (void) testGridGenerator {
    
    NSMutableArray *gridArray = [PDGridGenerator generateGridForLevelNumber: 0];
    
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

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    //[self measureBlock:^{
        // Put the code you want to measure the time of here.
    //}];
}

@end
