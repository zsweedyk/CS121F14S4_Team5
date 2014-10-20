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
    NSLog(@"cell view method called");
    
    if (north) {
        [filename stringByAppendingString:[PDCellView openNorthEncoding]];
    } else {
        [filename stringByAppendingString:[PDCellView closeDirectionEncoding]];
    }
    
    if (south) {
        [filename stringByAppendingString:[PDCellView openSouthEncoding]];
    } else {
        [filename stringByAppendingString:[PDCellView closeDirectionEncoding]];
    }
    
    if (east) {
        [filename stringByAppendingString:[PDCellView openEastEncoding]];
    } else {
        [filename stringByAppendingString:[PDCellView closeDirectionEncoding]];
    }
    
    if (west) {
        [filename stringByAppendingString:[PDCellView openWestEncoding]];
    } else {
        [filename stringByAppendingString:[PDCellView closeDirectionEncoding]];
    }
    
    [self setBackgroundColor:[self backgroundColorFromImageStringName:filename]];
    
    
}

- (void) setStart:(BOOL)start {
    if (start) {
        [self setBackgroundColor:[self backgroundColorFromImageStringName:[PDCellView startImageName]]];
    }
}

- (void) setGoal:(BOOL)goal {
    if (goal) {
        [self setBackgroundColor:[self backgroundColorFromImageStringName:[PDCellView goalImageName]]];
    }
}

#pragma mark Private methods

// Making a centered background color from an image
// Credit: http://stackoverflow.com/questions/8077740/how-to-fill-background-image-of-an-uiview
-(UIColor*) backgroundColorFromImageStringName: (NSString*) imageFilename {
    UIGraphicsBeginImageContext(self.frame.size);
    NSString* fullFileNamePath = [imageFilename stringByAppendingString:[PDCellView imageFileExtension]];
    [[UIImage imageNamed:fullFileNamePath] drawInRect:self.bounds];
    UIImage* processedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:processedImage];
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
