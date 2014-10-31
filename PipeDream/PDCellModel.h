//
//  PDCellModel.h
//  PipeDream
//
//  Created by Jean Sung, Kathryn Aplin, Paula Yuan and Vincent Fiorentini.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDOpenings.h"

@interface PDCellModel : NSObject

@property (nonatomic, strong) PDOpenings *openings;
@property (nonatomic) BOOL isInfected;
@property (nonatomic) BOOL isVisible;
@property (nonatomic) BOOL isStart;
@property (nonatomic) BOOL isGoal;
@property (nonatomic) int row;
@property (nonatomic) int col;

- (void)rotateClockwise;
- (BOOL)isOpenNorth;
- (BOOL)isOpenEast;
- (BOOL)isOpenSouth;
- (BOOL)isOpenWest;

@end
