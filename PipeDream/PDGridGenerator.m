//
//  PDGridGenerator.m
//  PipeDream
//
//  Created by Jean Sung, Kathryn Aplin, Paula Yuan and Vincent Fiorentini.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDGridGenerator.h"

@implementation PDGridGenerator

#pragma mark Public methods

/* Input: Level number
 * Output: An array of rows of CellModels corresponding to that level */
+ (NSMutableArray *)generateGridForLevelNumber:(NSInteger)levelNumber {
    NSString *readString = [PDGridGenerator readFromFile];
    NSString *line = [PDGridGenerator getLineFromString:readString forLevel:levelNumber];
    return [PDGridGenerator parseLine:line];
}

/* Input: Level string
 * Output: An array of rows of CellModels corresponding to that level */
+ (NSMutableArray *) generateGridFromString:(NSString *)string {
    return [PDGridGenerator parseLine:string];
}

#pragma mark Private methods

/* Returns the string of text from the grids file */
+ (NSString *)readFromFile {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"grids" ofType:@"txt"];
    NSError *error;
    NSString *readString = [[NSString alloc] initWithContentsOfFile:path
        encoding:NSUTF8StringEncoding error:&error];
    return readString;
}

/* Input: A string composed of multiple lines, level number
 * Output: A single line from the input */
+ (NSString *)getLineFromString:(NSString *)allGrids forLevel:(NSInteger)levelNumber {
    NSArray *allLines = [allGrids componentsSeparatedByString:@"\n"];
    return [allLines objectAtIndex:levelNumber];
}

/* Input: A string encoding of a level
 * Output: A 2D array of CellModels corresponding to the level */
+ (NSMutableArray *)parseLine:(NSString *)gridLine {
    
    // Define constant for start of pipe encodings in text file
    NSInteger PIPE_ENCODING_START = 7;
    
    // Turns the string into an array of strings
    NSArray *parsedLine = [gridLine componentsSeparatedByString:@" "];
    
    // Get the width and height of the grid
    NSInteger width = [[parsedLine objectAtIndex:0] integerValue];
    NSInteger height = [[parsedLine objectAtIndex:1] integerValue];
    
    // Get the position of the starting element
    NSInteger start[2];
    start[0] = [[parsedLine objectAtIndex:2] integerValue];
    start[1] = [[parsedLine objectAtIndex:3] integerValue];
    
    // Get the position of the goal
    NSInteger goal[2];
    goal[0] = [[parsedLine objectAtIndex:4] integerValue];
    goal[1] = [[parsedLine objectAtIndex:5] integerValue];
    
    // Get whether fog of war is enabled or disabled
    BOOL fogOfWarEnabled = [[parsedLine objectAtIndex:6] integerValue];
    
    // Parse the strings in the array into CellModels
    NSMutableArray *grid = [[NSMutableArray alloc] initWithCapacity:height];
    for (int row = 0; row < height; row++) {
        NSMutableArray *currentRow = [[NSMutableArray alloc] initWithCapacity:width];
        NSInteger rowStartIndex = row * width;
        for (int col = 0; col < width; col++) {
            NSUInteger index = rowStartIndex + col + PIPE_ENCODING_START;
            NSString *pipeEncoding = [parsedLine objectAtIndex:index];
            PDCellModel *cell = [PDGridGenerator parsePipeEncoding:pipeEncoding];
            [cell setRow:row];
            [cell setCol:col];
            [cell setIsVisible:!fogOfWarEnabled];
            [currentRow addObject:cell];
        }
        [grid addObject:currentRow];
    }
    
    // Set start and goal cells
    [[[grid objectAtIndex:start[0]] objectAtIndex:start[1]] setIsStart:YES];
    [[[grid objectAtIndex:goal[0]] objectAtIndex:goal[1]] setIsGoal:YES];
    
    return grid;
}

/* Input: A string encoding of a pipe
 * Output: A CellModel corresponding to the string encoding */
+ (PDCellModel *)parsePipeEncoding:(NSString *) pipeEncoding {
    
    // Define constants
    NSString* OPEN_NORTH_ENCODING = @"N";
    NSString* OPEN_EAST_ENCODING = @"E";
    NSString* OPEN_SOUTH_ENCODING = @"S";
    NSString* OPEN_WEST_ENCODING = @"W";
    NSString* INFECTED_ENCODING = @"*";
    
    // Initialize CellModel
    PDCellModel *cellModel = [[PDCellModel alloc] init];
    
    // Extract values for cardinal directions and infection status from encoding
    BOOL north = [[pipeEncoding substringWithRange:NSMakeRange(0, 1)] isEqual:OPEN_NORTH_ENCODING];
    BOOL east = [[pipeEncoding substringWithRange:NSMakeRange(1, 1)] isEqual:OPEN_EAST_ENCODING];
    BOOL south = [[pipeEncoding substringWithRange:NSMakeRange(2, 1)] isEqual:OPEN_SOUTH_ENCODING];
    BOOL west = [[pipeEncoding substringWithRange:NSMakeRange(3, 1)] isEqual:OPEN_WEST_ENCODING];
    BOOL isInfected = NO;
    if ([pipeEncoding length] == 5) {
        isInfected = [[pipeEncoding substringWithRange:NSMakeRange(4, 1)]
                      isEqual:INFECTED_ENCODING];
    }
    
    // Set cellModel's openings and infection status
    PDOpenings *openings = [[PDOpenings alloc] init];
    [openings setIsOpenNorth:north east:east south:south west:west];
    [cellModel setOpenings:openings];
    [cellModel setIsInfected:isInfected];
    
    return cellModel;
}

@end
