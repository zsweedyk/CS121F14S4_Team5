//
//  PDCellView.m
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/13/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDCellView.h"

@implementation PDCellView

NSString* OPEN_NORTH_ENCODING = @"N";
NSString* OPEN_EAST_ENCODING = @"E";
NSString* OPEN_SOUTH_ENCODING = @"S";
NSString* OPEN_WEST_ENCODING = @"W";
NSString* INFECTED_ENCODING = @"*";
NSString* CLOSE_DIRECTION_ENCODING = @"x";
NSString* START_IMAGE_NAME = @"computerHealthy";
NSString* GOAL_IMAGE_NAME = @"goal";

#pragma mark Public methods

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(cellPressed)
            forControlEvents:UIControlEventTouchUpInside];
    }
    CGFloat backgroundDarkness = 0.3;
    CGFloat backgroundOpacity = 1;
    self.backgroundColor = [UIColor colorWithRed:backgroundDarkness green:backgroundDarkness
                                            blue:backgroundDarkness alpha:backgroundOpacity];
    return self;
}

- (void)rotateClockwise {
    // Currently does not have any additional implementation.
    // setCellIsOpenNorth:south:east:west is called immediately after this, thus pulling a new image
    // instead of changing existing image.
}

/* 
 * Sets the openings by finding the correct corresponding image.
 * Files for cell images have the format NESW if all directions are open. Expect to see an x for a 
 * direction that is not open.
 */
- (void)setCellIsOpenNorth:(BOOL)north south:(BOOL)south east:(BOOL)east west:(BOOL)west {
    NSString *filename = @"";
    
    if (north) {
        filename  = [filename stringByAppendingString:OPEN_NORTH_ENCODING];
    } else {
        filename  = [filename stringByAppendingString:CLOSE_DIRECTION_ENCODING];
    }
    
    if (east) {
        filename  = [filename stringByAppendingString:OPEN_EAST_ENCODING];
    } else {
        filename  = [filename stringByAppendingString:CLOSE_DIRECTION_ENCODING];
    }
    
    if (south) {
        filename  = [filename stringByAppendingString:OPEN_SOUTH_ENCODING];
    } else {
        filename  = [filename stringByAppendingString:CLOSE_DIRECTION_ENCODING];
    }
    
    if (west) {
        filename  = [filename stringByAppendingString:OPEN_WEST_ENCODING];
    } else {
        filename  = [filename stringByAppendingString:CLOSE_DIRECTION_ENCODING];
    }
    
    [self setImage:[UIImage imageNamed:filename] forState:UIControlStateNormal];

}

/*
 * Sets the image for a start cell.
 */
- (void)setStart:(BOOL)start {
    if (start) {
        [self setImage:[UIImage imageNamed:START_IMAGE_NAME] forState:UIControlStateNormal];
    }
}

/*
 * Sets the image for a goal cell.
 */
- (void)setGoal:(BOOL)goal {
    if (goal) {
        [self setImage:[UIImage imageNamed:GOAL_IMAGE_NAME] forState:UIControlStateNormal];
    }
}

- (void)setVisiblity:(BOOL)isVisible {
    if (!isVisible) {
        [self setImage:[UIImage imageNamed:@"NESWi"] forState:UIControlStateNormal];
    }
}

#pragma mark Private methods

- (void)cellPressed {
    [self.delegate cellPressedAtRow:self.row col:self.col];
}

@end
