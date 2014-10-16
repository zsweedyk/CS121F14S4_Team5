//
//  PDCellModel.h
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/13/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDCellModel : NSObject

@property (nonatomic) BOOL isOpenNorth;
@property (nonatomic) BOOL isOpenEast;
@property (nonatomic) BOOL isOpenSouth;
@property (nonatomic) BOOL isOpenWest;
@property (nonatomic) BOOL isStart;
@property (nonatomic) BOOL isGoal;

- (void) rotateClockwise;

@end
