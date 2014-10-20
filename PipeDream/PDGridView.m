//
//  PDGridView.m
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/13/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDGridView.h"

static float BORDER_RATIO = 0.25;


@interface PDGridView ()

@property (nonatomic, strong) NSMutableArray *cellViews;

@end

@implementation PDGridView

#pragma mark Public methods

- (void) drawGridFromDimension: (int) gridDimension {
    int numBordersInGrid = gridDimension + 1;
    self.backgroundColor = [UIColor blackColor];
    _cellViews = [[NSMutableArray alloc] initWithCapacity:gridDimension];
    CGFloat frameDimensions = CGRectGetWidth(self.frame);
    
    // Treat cellSize as an unit to fill screen with cells and borders.
    // effectiveNumCells is the number of these units.
    CGFloat effectiveNumCells = gridDimension + (BORDER_RATIO * numBordersInGrid);
    CGFloat cellSize = frameDimensions / effectiveNumCells;
    
    for (int row = 0; row < gridDimension; row++) {
        NSMutableArray *currentRow = [[NSMutableArray alloc] initWithCapacity:gridDimension];
        for (int col = 0; col < gridDimension; col++) {

            int horizontalOffset = [PDGridView offsetFromAxis:col forButtonSize:cellSize];
            int verticalOffset = [PDGridView offsetFromAxis:row forButtonSize:
                cellSize];
            
            CGRect cellViewFrame = CGRectMake(horizontalOffset, verticalOffset, cellSize, cellSize);
            PDCellView *cellView = [[PDCellView alloc] initWithFrame:cellViewFrame];
            [cellView setBackgroundColor:[UIColor whiteColor]];
            
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
     NSLog(@"called cell view method");
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
