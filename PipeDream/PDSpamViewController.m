//
//  PDSpamViewController.m
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/31/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDSpamViewController.h"
#import "PDMiniGameProtocol.h"
#import "PDLevelViewController.h"

@interface PDSpamViewController () <PDMiniGameProtocol>

@end

@implementation PDSpamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark Public methods

-(void)startMiniGame {
    // TODO: implement this (start playing a minigame; might be similar to viewDidLoad).
}

- (IBAction)correctButtonPressed {
    // TODO: Remove this method once the minigame is actually implemented.
    [self completeMiniGameWithSuccess:YES];
}

- (IBAction)cancelButtonPressed {
    // TODO: Remove this method once the minigame is actually implemented.
    [self completeMiniGameWithSuccess:NO];
}

#pragma mark Private methods

- (void)completeMiniGameWithSuccess:(BOOL)success {
    PDLevelViewController *levelViewController =
        (PDLevelViewController *) self.presentingViewController;
    [levelViewController completeMiniGameWithSuccess:success];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
