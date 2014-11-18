//
//  PDEndOfLevelViewController.h
//  PipeDream
//
//  Created by CS121 on 11/16/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDEndOfLevelViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *levelCompletedLabel;
@property (nonatomic) NSInteger levelNumberCompleted;

- (IBAction)nextLevelButtonPressed;
- (IBAction)cancelButtonPressed;

@end
