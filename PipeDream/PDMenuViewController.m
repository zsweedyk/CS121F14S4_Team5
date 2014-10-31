//
//  PDMenuViewController.m
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/31/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDMenuViewController.h"

@interface PDMenuViewController ()

@end

@implementation PDMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark Public methods

- (IBAction)levelSelectButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"MenuToLevelSelect" sender:self];
}

#pragma mark Private methods

@end
