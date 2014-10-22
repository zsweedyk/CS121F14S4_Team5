//
//  PDCellPressedDelegate.h
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/17/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//
//  This file exists solely to store the PDCellPressedDelegate protocol.

@protocol PDCellPressedDelegate
@required
- (void) cellPressedAtRow:(NSInteger)row col:(NSInteger)col;
@end
