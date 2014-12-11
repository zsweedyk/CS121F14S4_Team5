//
//  PDCellModelTests.m
//  PipeDream
//
//  Created by CS121 on 12/10/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PDCellModel.h"
#import "PDOpenings.h"

@interface PDCellModelTests : XCTestCase

@end

@implementation PDCellModelTests

/* Test the creation of cells, and their clockwise rotation. */
- (void)testCellRotateClockwise {
    
    // Rotate a horizontal pipe, expect a vertical pipe
    PDCellModel *straightPipe = [[PDCellModel alloc] init];
    PDOpenings *straightPipeOpenings = [[PDOpenings alloc] init];
    [straightPipeOpenings setIsOpenNorth: NO east: YES south: NO west: YES];
    [straightPipe setOpenings: straightPipeOpenings];
    [straightPipe rotateClockwise];
    XCTAssert([[straightPipe openings] isOpenNorth] &&
              ![[straightPipe openings] isOpenEast] &&
              [[straightPipe openings] isOpenSouth] &&
              ![[straightPipe openings] isOpenWest], @"Straight pipe rotated correctly");
    
    // Rotate a pipe with all openings but north, expect a pipe with all openings but east
    PDCellModel *threeWayPipe = [[PDCellModel alloc] init];
    PDOpenings *threeWayPipeOpenings = [[PDOpenings alloc] init];
    [threeWayPipeOpenings setIsOpenNorth: NO east: YES south: YES west: YES];
    [threeWayPipe setOpenings: threeWayPipeOpenings];
    [threeWayPipe rotateClockwise];
    XCTAssert([[threeWayPipe openings] isOpenNorth] &&
              ![[threeWayPipe openings] isOpenEast] &&
              [[threeWayPipe openings] isOpenSouth] &&
              [[threeWayPipe openings] isOpenWest], @"Three-way pipe rotated correctly");
}

@end
