//
//  PDMenuViewController.m
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/31/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDMenuViewController.h"
#import "PDAudioManager.h"

@interface PDMenuViewController ()

@end

@implementation PDMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    [[PDAudioManager sharedInstance] startBackgroundMusic];
}

#pragma mark Public methods

- (IBAction)levelSelectButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"MenuToLevelSelect" sender:self];
    [[PDAudioManager sharedInstance] playMenuButtonPressed];
}

- (IBAction)instructionsButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"MenuToInstructions" sender:self];
    [[PDAudioManager sharedInstance] playMenuButtonPressed];
}

- (IBAction)creditSelectButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"MenuToCredits" sender:self];
    [[PDAudioManager sharedInstance] playMenuButtonPressed];
}

#pragma mark Private methods

@end
