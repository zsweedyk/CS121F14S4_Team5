//
//  PDGridModel.m
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/13/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDGridModel.h"
#import "PDOpenings.h"

@interface PDGridModel ()

@property (nonatomic, strong) NSMutableArray *cells;

@end

@implementation PDGridModel

#pragma mark Public methods

- (id) initWithLevelNumber:(NSInteger)number {
    // TODO: Implement this method.
    return nil;
}

- (NSInteger) numRows {
    // TODO: Implement this method.
    return 0;
}

- (NSInteger) numCols {
    // TODO: Implement this method.
    return 0;
}

- (void) rotateClockwiseCellAtRow:(NSInteger)row col:(NSInteger)col {
    // TODO: Implement this method.
}

- (BOOL) isConnectedFromRow:(NSInteger)rowFrom col:(NSInteger)colFrom
                      toRow:(NSInteger)rowTo col:(NSInteger)colTo {
    // TODO: Implement this method.
    return NO;
}

- (PDOpenings *) openingsAtRow:(NSInteger)row col:(NSInteger)col {
    // TODO: Implement this method.
    return nil;
}

- (BOOL) isStartAtRow:(NSInteger)row col:(NSInteger)col {
    // TODO: Implement this method.
    return NO;
}

- (BOOL) isGoalAtRow:(NSInteger)row col:(NSInteger)col {
    // TODO: Implement this method.
    return NO;
}

#pragma mark Private methods

@end
