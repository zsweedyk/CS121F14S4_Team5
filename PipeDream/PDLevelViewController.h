//
//  PDLevelViewController.h
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/13/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDGridView;

@interface PDLevelViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet PDGridView *gridView;
@property (nonatomic) NSInteger levelNumber;

- (void) cellPressedAtRow:(NSInteger)row col:(NSInteger)col;
- (void) completeMiniGameWithSuccess:(BOOL)success;

@end
