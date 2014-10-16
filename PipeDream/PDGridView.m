//
//  PDGridView.m
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/13/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDGridView.h"

@interface PDGridView ()

@property (nonatomic, strong) NSMutableArray *cellViews;

@end

@implementation PDGridView

- (void) cellPressedAtRow:(NSInteger)row col:(NSInteger)col {
    // this method will be called when a CellView tells us, since we will be its delegate
}

@end
