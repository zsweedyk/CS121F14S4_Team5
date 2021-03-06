//
//  PDGridModel.h
//  PipeDream
//
//  Created by Jean Sung, Kathryn Aplin, Paula Yuan and Vincent Fiorentini.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDCellModel.h"

@class PDOpenings;

@interface PDGridModel : NSObject

- (id)initWithLevelNumber:(NSInteger)number;
- (id)initWithGrid:(NSMutableArray *)grid;
- (NSInteger)numRows;
- (NSInteger)numCols;
- (void)rotateClockwiseCellAtRow:(NSInteger)row col:(NSInteger)col;
- (BOOL)isStartConnectedToGoal;
- (void) clearInfectionFromRow:(NSInteger)row col:(NSInteger)col;
- (BOOL) isInfectedAtRow:(NSInteger)row col:(NSInteger)col;
- (BOOL) isVisibleAtRow:(NSInteger)row col:(NSInteger)col;
- (BOOL)isConnectedFromRow:(NSInteger)rowFrom col:(NSInteger)colFrom
    toRow:(NSInteger)rowTo col:(NSInteger)colTo;
- (PDOpenings *)openingsAtRow:(NSInteger)row col:(NSInteger)col;
- (BOOL)isStartAtRow:(NSInteger)row col:(NSInteger)col;
- (BOOL)isGoalAtRow:(NSInteger)row col:(NSInteger)col;
- (PDCellModel *)getCellAtRow:(NSInteger)row col:(NSInteger)col;

@end
