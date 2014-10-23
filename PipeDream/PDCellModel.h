//
//  PDCellModel.h
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/13/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDOpenings.h"

@interface PDCellModel : NSObject

@property (nonatomic, strong) PDOpenings *openings;
@property (nonatomic) BOOL isStart;
@property (nonatomic) BOOL isGoal;
@property (nonatomic) int row;
@property (nonatomic) int col;

- (void) rotateClockwise;
- (BOOL) isOpenNorth;
- (BOOL) isOpenEast;
- (BOOL) isOpenSouth;
- (BOOL) isOpenWest;

@end
