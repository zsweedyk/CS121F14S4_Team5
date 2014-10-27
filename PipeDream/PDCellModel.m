//
//  PDCellModel.m
//  PipeDream
//
//  Created by Jean Sung, Kathryn Aplin, Paula Yuan and Vincent Fiorentini.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDCellModel.h"

@implementation PDCellModel

#pragma mark Public methods

- (void)rotateClockwise {
    BOOL tempIsOpenWest = [_openings isOpenWest];
    [_openings setIsOpenWest: [_openings isOpenSouth]];
    [_openings setIsOpenSouth: [_openings isOpenEast]];
    [_openings setIsOpenEast: [_openings isOpenNorth]];
    [_openings setIsOpenNorth: tempIsOpenWest];
}


- (BOOL)isOpenNorth {
    return [_openings isOpenNorth];
}

- (BOOL)isOpenEast {
    return [_openings isOpenEast];
}

- (BOOL)isOpenSouth {
    return [_openings isOpenSouth];
}

- (BOOL)isOpenWest {
    return [_openings isOpenWest];
}

#pragma mark Private methods

@end
