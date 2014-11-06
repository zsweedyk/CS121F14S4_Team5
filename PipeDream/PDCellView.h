//
//  PDCellView.h
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/13/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDCellPressedDelegate.h"
#import "PDCellModel.h"

@interface PDCellView : UIButton

@property (nonatomic, weak) id<PDCellPressedDelegate> delegate;
@property (nonatomic) int row;
@property (nonatomic) int col;

- (void)rotateClockwise;
- (void)setCell:(PDCellModel *)model;

@end
