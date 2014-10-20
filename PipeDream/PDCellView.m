//
//  PDCellView.m
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/13/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDCellView.h"

@implementation PDCellView

#pragma mark Public methods

- (void) rotateClockwise {
    // TODO: Implement this method.
}

// Files for cell images have the format NESW if all directions are open
// Expect to see an x for a direction that is not open.
- (void) setCellIsOpenNorth:(BOOL)north south:(BOOL)south east:(BOOL)east west:(BOOL)west {
    NSString *filename = @"";
    
    if (north) {
        [filename stringByAppendingString:@"N"];
    } else {
        [filename stringByAppendingString:@"x"];
    }
    
    if (south) {
        [filename stringByAppendingString:@"S"];
    } else {
        [filename stringByAppendingString:@"x"];
    }
    
    if (east) {
        [filename stringByAppendingString:@"E"];
    } else {
        [filename stringByAppendingString:@"x"];
    }
    
    if (west) {
        [filename stringByAppendingString:@"W"];
    } else {
        [filename stringByAppendingString:@"x"];
    }
    
    
    // TODO: Implement this method.
}

- (void) setStart:(BOOL)start {
    // TODO: Implement this method.
}

- (void) setGoal:(BOOL)goal {
    // TODO: Implement this method.
}

#pragma mark Private methods

@end
