//
//  PDGridGenerator.m
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/13/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDGridGenerator.h"
#import "PDCellModel.h"
#import "PDOpenings.h"

@implementation PDGridGenerator

#pragma mark Public methods

/* Input: Level number
 * Output: An array of rows of CellModels corresponding to that level */
+ (NSMutableArray *) generateGridForLevelNumber:(NSInteger)levelNumber {
    // TODO: Implement this method.
    NSString *readString = [PDGridGenerator readFromFile];
    NSString *line = [PDGridGenerator getLineFromString: readString
                                               forLevel: levelNumber];
    return [PDGridGenerator parseLine:line];
}

#pragma mark Private methods

/* Returns the string of text from the grids file */
+ (NSString *) readFromFile {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"grids"
                                                     ofType:@"txt"];
    NSError *error;
    NSString *readString = [[NSString alloc] initWithContentsOfFile:path
                                                           encoding:NSUTF8StringEncoding error:&error];
    return readString;
}

/* Input: A string composed of multiple lines, level number
 * Output: A single line from the input */
+ (NSString *) getLineFromString:(NSString *)allGrids forLevel:(NSInteger)levelNumber {
    NSArray *allLines = [allGrids componentsSeparatedByString:@"\n"];
    return [allLines objectAtIndex: levelNumber];
}

/* Input: A string encoding of a level
 * Output: A 2D array of CellModels corresponding to the level */
+ (NSMutableArray *) parseLine:(NSString *)gridLine {
    
    // Turns the string into an array of strings
    NSArray *parsedLine = [gridLine componentsSeparatedByString:@" "];
    
    // Get the width and height of the grid
    int width = [[parsedLine objectAtIndex: 0] integerValue];
    int height = [[parsedLine objectAtIndex: 1] integerValue];
    
    // Get the position of the starting element
    int start[2];
    start[0] = [[parsedLine objectAtIndex: 2] integerValue];
    start[1] = [[parsedLine objectAtIndex: 3] integerValue];
    
    // Get the position of the goal
    int goal[2];
    goal[0] = [[parsedLine objectAtIndex: 4] integerValue];
    goal[1] = [[parsedLine objectAtIndex: 5] integerValue];
    
    // Parse the strings in the array into CellModels
    NSMutableArray *grid = [[NSMutableArray alloc] initWithCapacity: height];
    for (int r = 0; r < height; r++) {
        NSMutableArray *row = [[NSMutableArray alloc] initWithCapacity: width];
        for (int c = 0; c < width; c++) {
            int index = r * width + height;
            NSString *pipeEncoding = [parsedLine objectAtIndex: 6+index];
            PDCellModel *cell = [PDGridGenerator parsePipeEncoding: pipeEncoding];
            [row addObject: cell];
        }
        [grid addObject: row];
    }
    
    // Set start and goal cells
    [[[grid objectAtIndex: start[0]] objectAtIndex: start[1]] setIsStart: YES];
    [[[grid objectAtIndex: goal[0]] objectAtIndex: goal[1]] setIsGoal: YES];
    
    return [NSMutableArray arrayWithArray:parsedLine];
}

/* Input: A string encoding of a pipe
 * Output: A CellModel corresponding to the string encoding */
+ (PDCellModel *) parsePipeEncoding:(NSString *) pipeEncoding {
    
    // Initialize CellModel
    PDCellModel *cellModel = [[PDCellModel alloc] init];
    
    // Extract values for cardinal directions from encoding
    BOOL north = [[pipeEncoding substringWithRange:NSMakeRange(0, 1)] isEqual: @"N"];
    BOOL east = [[pipeEncoding substringWithRange:NSMakeRange(1, 2)] isEqual: @"E"];
    BOOL south = [[pipeEncoding substringWithRange:NSMakeRange(2, 3)] isEqual: @"S"];
    BOOL west = [[pipeEncoding substringWithRange:NSMakeRange(3, 4)] isEqual: @"W"];
    
    // Put openings information into an Openings object
    PDOpenings *openings = [[PDOpenings alloc] init];
    [openings setIsOpenNorth: north];
    [openings setIsOpenEast: east];
    [openings setIsOpenSouth: south];
    [openings setIsOpenWest: west];
    
    // Set cellModel's openings
    [cellModel setOpenings: openings];
    
    return cellModel;
}

@end
