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
#import "PDCellModel.h"

@interface PDGridView : UIView

@property (nonatomic, weak) id<PDCellPressedDelegate> delegate;
- (void)drawGridFromDimension:(NSInteger)gridDimension;
- (void)rotateClockwiseCellAtRow:(NSInteger)row col:(NSInteger)col;
- (void)setCellAtRow:(NSInteger)row col:(NSInteger)col cell:(PDCellModel *)model;

@end
