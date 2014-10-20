//
//  PDGridView.m
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/13/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDGridView.h"

static int GRID_DIMENSION = 5;
static float BORDER_RATIO = 0.25;
static int NUM_BORDERS_PER_DIMENSION = 6;


@interface PDGridView () {
    NSMutableArray *_cellViews;
}

@property (nonatomic, strong) NSMutableArray *cellViews;

@end

@implementation PDGridView

#pragma mark Public methods


-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self drawGrid];
    }
    return self;
}



- (void) drawGrid {
    self.backgroundColor = [UIColor blackColor];
    _cellViews = [[NSMutableArray alloc] initWithCapacity:GRID_DIMENSION];
    CGFloat frameDimensions = CGRectGetWidth(self.frame);
    
    // Treat cellSize as an unit to fill screen with cells and borders.
    // effectiveNumCells is the number of these units.
    CGFloat effectiveNumCells = GRID_DIMENSION + (BORDER_RATIO * NUM_BORDERS_PER_DIMENSION);
    CGFloat cellSize = frameDimensions / effectiveNumCells;
    
    for (int row = 0; row < GRID_DIMENSION; row++) {
        NSMutableArray *currentRow = [[NSMutableArray alloc] initWithCapacity:GRID_DIMENSION];
        for (int col = 0; col < GRID_DIMENSION; col++) {

            int horizontalOffset = [PDGridView offsetFromAxis:col forButtonSize:cellSize];
            int verticalOffset = [PDGridView offsetFromAxis:row forButtonSize:
                cellSize];
            
            CGRect cellViewFrame = CGRectMake(horizontalOffset, verticalOffset, cellSize, cellSize);
            PDCellView *cellView = [[PDCellView alloc] initWithFrame:cellViewFrame];
            
            [currentRow addObject:cellView];
            [self addSubview:cellView];
        }
        [_cellViews addObject:currentRow];
    }
    
}


- (void) rotateClockwiseCellAtRow:(NSInteger)row col:(NSInteger)col {
    PDCellView *currentCell = [[_cellViews objectAtIndex:row] objectAtIndex:col];
    [currentCell rotateClockwise];
}

- (void) setCellAtRow:(NSInteger)row col:(NSInteger)col
          isOpenNorth:(BOOL)north east:(BOOL)east south:(BOOL)south west:(BOOL)west {
    PDCellView *currentCell = [[_cellViews objectAtIndex:row] objectAtIndex:col];
    [currentCell setCellIsOpenNorth:north south:south east:east west:west];
}

- (void) setStart:(BOOL)start atRow:(NSInteger)row col:(NSInteger)col {
    PDCellView *currentCell = [[_cellViews objectAtIndex:row] objectAtIndex:col];
    [currentCell setStart:start];
}

- (void) setGoal:(BOOL)goal atRow:(NSInteger)row col:(NSInteger)col {
    PDCellView *currentCell = [[_cellViews objectAtIndex:row] objectAtIndex:col];
    [currentCell setGoal:goal];
}

#pragma mark Private methods

- (void) cellPressedAtRow:(NSInteger)row col:(NSInteger)col {
    [self.delegate cellPressedAtRow:row col:col];
}

+ (int) offsetFromAxis:(int) axis forButtonSize:(CGFloat) buttonSize {
    int offsetsFromPreviousButtons = axis * buttonSize;
    int numPreviousBorders = axis + 1;
    int borderOffsets = buttonSize * BORDER_RATIO * numPreviousBorders;
    return offsetsFromPreviousButtons + borderOffsets;
}

@end
