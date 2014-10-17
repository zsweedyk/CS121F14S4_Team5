//
//  PDGridModel.h
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/13/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PDOpenings;

@interface PDGridModel : NSObject

- (id) initWithLevelNumber:(NSInteger)number;
- (void) rotateClockwiseCellAtRow:(NSInteger)row col:(NSInteger)col;
- (BOOL) isConnectedFromRow:(NSInteger)rowFrom col:(NSInteger)colFrom
                      toRow:(NSInteger)rowTo col:(NSInteger)colTo;
- (PDOpenings *) openingsAtRow:(NSInteger)row col:(NSInteger)col;
- (BOOL) isStartAtRow:(NSInteger)row col:(NSInteger)col;
- (BOOL) isGoalAtRow:(NSInteger)row col:(NSInteger)col;

@end
