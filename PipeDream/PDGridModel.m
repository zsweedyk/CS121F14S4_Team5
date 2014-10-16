//
//  PDGridModel.m
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/13/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDGridModel.h"

@interface PDGridModel ()

@property (nonatomic, strong) NSMutableArray *cells;

@end

@implementation PDGridModel

#pragma mark Public methods

- (id) initWithLevelNumber:(NSInteger)number {
    // TODO: Implement this method.
    return nil;
}

- (void) rotateClockwiseCellAtRow:(NSInteger)row col:(NSInteger)col {
    // TODO: Implement this method.
}

- (BOOL) isConnectedFromRow:(NSInteger)rowFrom col:(NSInteger)colFrom
                      toRow:(NSInteger)rowTo col:(NSInteger)colTo {
    // TODO: Implement this method.
    return NO;
}

- (BOOL) isOpenNorthAtRow:(NSInteger)row col:(NSInteger)col {
    // TODO: Implement this method.
    return NO;
}

- (BOOL) isOpenEastAtRow:(NSInteger)row col:(NSInteger)col {
    // TODO: Implement this method.
    return NO;
}

- (BOOL) isOpenSouthAtRow:(NSInteger)row col:(NSInteger)col {
    // TODO: Implement this method.
    return NO;
}

- (BOOL) isOpenWestAtRow:(NSInteger)row col:(NSInteger)col {
    // TODO: Implement this method.
    return NO;
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
