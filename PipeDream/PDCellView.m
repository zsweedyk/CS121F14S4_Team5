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


-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self addTarget:self action:@selector(cellPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    CGFloat backgroundDarkness = 0.3;
    CGFloat backgroundOpacity = 1;
    self.backgroundColor = [UIColor colorWithRed:backgroundDarkness green:backgroundDarkness
                                            blue:backgroundDarkness alpha:backgroundOpacity];
    return self;
}

- (void) rotateClockwise {
    // Leaving empty for alpha because setCellIsOpenNorth:south:east:west is called immediately after this. Pulling a new image instead of changing existing image.
}

// Files for cell images have the format NESW if all directions are open
// Expect to see an x for a direction that is not open.
- (void) setCellIsOpenNorth:(BOOL)north south:(BOOL)south east:(BOOL)east west:(BOOL)west {
    NSString *filename = @"";
    
    if (north) {
        filename  = [filename stringByAppendingString:[PDCellView openNorthEncoding]];
    } else {
        filename  = [filename stringByAppendingString:[PDCellView closeDirectionEncoding]];
    }
    
    if (east) {
        filename  = [filename stringByAppendingString:[PDCellView openEastEncoding]];
    } else {
        filename  = [filename stringByAppendingString:[PDCellView closeDirectionEncoding]];
    }
    
    if (south) {
        filename  = [filename stringByAppendingString:[PDCellView openSouthEncoding]];
    } else {
        filename  = [filename stringByAppendingString:[PDCellView closeDirectionEncoding]];
    }
    
    if (west) {
        filename  = [filename stringByAppendingString:[PDCellView openWestEncoding]];
    } else {
        filename  = [filename stringByAppendingString:[PDCellView closeDirectionEncoding]];
    }
    
    [self setImage:[UIImage imageNamed:filename] forState:UIControlStateNormal];

}

- (void) setStart:(BOOL)start {
    if (start) {
        [self setImage:[UIImage imageNamed:[PDCellView startImageName]] forState:UIControlStateNormal];
    }
}

- (void) setGoal:(BOOL)goal {
    if (goal) {
        [self setImage:[UIImage imageNamed:[PDCellView goalImageName]] forState:UIControlStateNormal];
    }
}

#pragma mark Private methods

-(void) cellPressed {
    [self.delegate cellPressedAtRow:_row col:_col];
}

+(NSString*) startImageName {
    return @"computerHealthy";
}

+(NSString*) goalImageName {
    return @"goal";
}

+(NSString*) imageFileExtension {
    return @"png";
}

+(NSString*) openNorthEncoding {
    return @"N";
}

+(NSString*) openSouthEncoding {
    return @"S";
}

+(NSString*) openEastEncoding {
    return @"E";
}

+(NSString*) openWestEncoding {
    return @"W";
}

+(NSString*) closeDirectionEncoding {
    return @"x";
}




@end
