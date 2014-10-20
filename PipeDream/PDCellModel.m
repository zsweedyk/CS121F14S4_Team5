//
//  PDCellModel.m
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/13/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDCellModel.h"

@implementation PDCellModel

#pragma mark Public methods

/*
 * Rotates the openings of this CellModel clockwise.
 */
- (void) rotateClockwise {
    BOOL tempIsOpenWest = [_openings isOpenWest];
    [_openings setIsOpenWest: [_openings isOpenSouth]];
    [_openings setIsOpenSouth: [_openings isOpenEast]];
    [_openings setIsOpenEast: [_openings isOpenNorth]];
    [_openings setIsOpenNorth: tempIsOpenWest];
}

/*
 * YES if this CellModel's opening is open to the north.
 */
- (BOOL) isOpenNorth {
    return [_openings isOpenNorth];
}

/*
 * YES if this CellModel's opening is open to the east.
 */
- (BOOL) isOpenEast {
    return [_openings isOpenEast];
}

/*
 * YES if this CellModel's opening is open to the south.
 */
- (BOOL) isOpenSouth {
    return [_openings isOpenSouth];
}

/*
 * YES if this CellModel's opening is open to the west.
 */
- (BOOL) isOpenWest {
    return [_openings isOpenWest];
}

#pragma mark Private methods

@end
