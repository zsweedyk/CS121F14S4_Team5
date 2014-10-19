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

- (void) rotateClockwise {
    // TODO: Implement this method.
}

- (BOOL) isOpenNorth {
    return [_openings isOpenNorth];
}

- (BOOL) isOpenEast {
    return [_openings isOpenEast];
}

- (BOOL) isOpenSouth {
    return [_openings isOpenSouth];
}

- (BOOL) isOpenWest {
    return [_openings isOpenWest];
}

#pragma mark Private methods

@end
