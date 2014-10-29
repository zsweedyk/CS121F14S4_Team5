//
//  PDLevelSelectionViewController.h
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/22/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDLevelSelectionViewController : UIViewController

- (void)updateLevelSelectButtonsEnabled;
+ (void)unlockLevelNumber:(NSInteger)levelNumber;
- (IBAction)levelButtonPressed:(id)sender;

@end
