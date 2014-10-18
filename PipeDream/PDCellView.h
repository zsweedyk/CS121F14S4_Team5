//
//  PDCellView.h
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/13/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDCellPressedDelegate.h"

@interface PDCellView : UIView

@property (nonatomic, weak) id<PDCellPressedDelegate> delegate;

- (void) rotateClockwise;
- (void) setCellIsOpenNorth:(BOOL)north south:(BOOL)south east:(BOOL)east west:(BOOL)west;
- (void) setStart:(BOOL)start;
- (void) setGoal:(BOOL)goal;

@end
