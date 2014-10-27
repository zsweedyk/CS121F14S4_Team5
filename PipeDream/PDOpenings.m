//
//  PDOpenings.m
//  PipeDream
//
//  Created by CS121 on 10/16/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDOpenings.h"

@implementation PDOpenings

- (void)setIsOpenNorth:(BOOL)north east:(BOOL)east south:(BOOL)south west:(BOOL)west {
    self.isOpenNorth = north;
    self.isOpenEast = east;
    self.isOpenSouth = south;
    self.isOpenWest = west;
}

@end
