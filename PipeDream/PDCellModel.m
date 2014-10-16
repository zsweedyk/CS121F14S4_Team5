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
    BOOL tempIsOpenWest = _isOpenWest;
    _isOpenWest = _isOpenSouth;
    _isOpenSouth = _isOpenEast;
    _isOpenEast = _isOpenNorth;
    _isOpenNorth = tempIsOpenWest;
}

#pragma mark Private methods

@end
