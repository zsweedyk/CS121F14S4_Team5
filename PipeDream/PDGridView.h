//
//  PDGridView.h
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/13/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDGridView : UIView

@property (nonatomic, weak) id delegate;

- (void) rotateClockwiseCellAtRow:(NSInteger)row col:(NSInteger)col;
- (void) setCellAtRow:(NSInteger)row col:(NSInteger)col
          isOpenNorth:(BOOL)north east:(BOOL)east south:(BOOL)south west:(BOOL)west;
- (void) setStart:(BOOL)start atRow:(NSInteger)row col:(NSInteger)col;
- (void) setGoal:(BOOL)goal atRow:(NSInteger)row col:(NSInteger)col;

@end
