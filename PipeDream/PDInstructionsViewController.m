//
//  PDInstructionsViewController.m
//  PipeDream
//
//  Created by Jean Sung on 12/7/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDInstructionsViewController.h"

@interface PDInstructionsViewController ()

@end

@implementation PDInstructionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
}

- (IBAction)instructionsToMenuButtonPressed:(id)sender {
    [[PDAudioManager sharedInstance] playMenuButtonPressed];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
