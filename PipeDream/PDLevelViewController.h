//
//  PDLevelViewController.h
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/13/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDLevelViewController : UIViewController

- (void) startLevelNumber:(NSInteger)levelNumber;
- (void) initializeGridView;
- (void) initializeGridModel;
- (void) rotateClockwisePipeAtRow:(NSInteger)row col:(NSInteger)col;

@end

