//
//  PDCreditsViewController.m
//  PipeDream
//
//  Created by Jean Sung on 11/29/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDCreditsViewController.h"

@interface PDCreditsViewController ()

@end

@implementation PDCreditsViewController

#pragma mark Public methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
}

- (void)creditsToMenuButonPressed:(id)sender {
    [[PDAudioManager sharedInstance] playMenuButtonPressed];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Private methods

@end
