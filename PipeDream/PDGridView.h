//
//  PDGridView.h
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/13/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDCellPressedDelegate.h"
#import "PDCellView.h"

@interface PDGridView : UIView

@property (nonatomic, weak) id<PDCellPressedDelegate> delegate;
- (void)drawGridFromDimension:(NSInteger)gridDimension;
- (void)rotateClockwiseCellAtRow:(NSInteger)row col:(NSInteger)col;
- (void)setCellAtRow:(NSInteger)row col:(NSInteger)col isOpenNorth:(BOOL)north east:(BOOL)east
               south:(BOOL)south west:(BOOL)west;
- (void)setStart:(BOOL)start atRow:(NSInteger)row col:(NSInteger)col;
- (void)setGoal:(BOOL)goal atRow:(NSInteger)row col:(NSInteger)col;
- (void)setCellVisibility:(BOOL)visible atRow:(NSInteger)row col:(NSInteger)col;
- (void)setCellInfected:(BOOL)infected atRow:(NSInteger)row col:(NSInteger)col;

@end
