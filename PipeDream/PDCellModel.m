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


- (void) rotateClockwise
{
    BOOL tempIsOpenWest = [_openings isOpenWest];
    [_openings setIsOpenWest: [_openings isOpenSouth]];
    [_openings setIsOpenSouth: [_openings isOpenEast]];
    [_openings setIsOpenEast: [_openings isOpenNorth]];
    [_openings setIsOpenEast: tempIsOpenWest];
}

#pragma mark Private methods

@end
