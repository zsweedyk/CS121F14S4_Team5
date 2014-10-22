//
//  PDOpenings.m
//  PipeDream
//
//  Created by CS121 on 10/16/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDOpenings.h"

@implementation PDOpenings

- (void) setIsOpenNorth:(BOOL)north East:(BOOL)east South:(BOOL)south West:(BOOL)west {
    _isOpenNorth = north;
    _isOpenEast = east;
    _isOpenSouth = south;
    _isOpenWest = west;
}

@end
