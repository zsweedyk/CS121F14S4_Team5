//
//  PDEndOfLevelViewController.m
//  PipeDream
//
//  Created by CS121 on 11/16/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDEndOfLevelViewController.h"
#import "PDLevelViewController.h"
#import "PDGridGenerator.h"

@interface PDEndOfLevelViewController ()

@end

@implementation PDEndOfLevelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.levelCompletedLabel setText:[NSString stringWithFormat:@"You completed level %ld!",
                                       (long)self.levelNumberCompleted]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Dismisses the level completion box and does nothing else. */
- (void)cancelButtonPressed {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

/* Dismisses the level completion box and segues to the next level. */
- (void)nextLevelButtonPressed {
    
    // Segue to next level if there are more levels
    PDLevelViewController *levelViewController =
        (PDLevelViewController *) self.presentingViewController;
    
    if (levelViewController.levelNumber < [PDGridGenerator numberOfLevels]) {
        [levelViewController startNextLevel];
        // Dismiss level completion dialog
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        
        NSString *cancelButtonTitle = @"Okay";
        NSString *alertTitle = @"Congratulations!";
        NSString *messageTitle = @"You have completed all the levels!";
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:alertTitle
                                  message:messageTitle
                                  delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:cancelButtonTitle, nil];
        [alertView show];
    }
    
}

/* This method assumes the only alert view created is the "mini game complete" alert. */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    PDLevelViewController *levelViewController =
        (PDLevelViewController *) self.presentingViewController;
    levelViewController.shouldDismissSelf = YES;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
