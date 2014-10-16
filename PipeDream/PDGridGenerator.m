//
//  PDGridGenerator.m
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/13/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDGridGenerator.h"

@implementation PDGridGenerator

#pragma mark Public methods

+ (NSMutableArray *) generateGridForLevelNumber:(NSInteger)levelNumber {
    // TODO: Implement this method.
    NSString *readString = [PDGridGenerator readFromFile];
    NSString *line = [PDGridGenerator getLineFromString: readString
                     forLevel: levelNumber];
    return [PDGridGenerator parseLine:line];
}

#pragma mark Private methods

+ (NSString *) readFromFile {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"grids"
                     ofType:@"txt"];
    NSError *error;
    NSString *readString = [[NSString alloc] initWithContentsOfFile:path
                           encoding:NSUTF8StringEncoding error:&error];
    return readString;
}

+ (NSString *) getLineFromString:(NSString *)allGrids forLevel:(NSInteger)levelNumber {
    NSArray *allLines = [allGrids componentsSeparatedByString:@"\n"];
    return [allLines objectAtIndex: levelNumber];
}

+ (NSMutableArray *) parseLine:(NSString *)gridLine {
    NSArray *parsedLine = [gridLine componentsSeparatedByString:@" "];
    int width = [[parsedLine objectAtIndex: 0] integerValue];
    int height = [[parsedLine objectAtIndex: 1] integerValue];
    NSMutableArray *grid = [[NSMutableArray alloc] initWithCapacity: height];
    for (int r = 0; r < height; r++) {
        NSMutableArray *row = [[NSMutableArray alloc] initWithCapacity: width];
        for (int c = 0; c < width; c++) {
            int index = r * width + height;
            [row addObject: [parsedLine objectAtIndex: 2+index]];
        }
        [grid addObject: row];
    }
    return [NSMutableArray arrayWithArray:parsedLine];
}

@end
