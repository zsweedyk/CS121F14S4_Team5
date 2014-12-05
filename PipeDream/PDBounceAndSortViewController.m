//
//  PDBounceAndSortViewController.m
//  PipeDream
//
//  Created by Kate Aplin on 11/16/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDBounceAndSortViewController.h"
#import "PDMiniGameProtocol.h"
#import "PDLevelViewController.h"
#import "PDBounceAndSortScene.h"
#import "PDMiniGameSceneEndDelegate.h"
#import "PDAudioManager.h"

@interface PDBounceAndSortViewController () <PDMiniGameProtocol, PDMiniGameSceneEndDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) UIViewController *presentingController;
@property (nonatomic) BOOL completedSuccessfully;
@end

@implementation PDBounceAndSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Sprite Kit applies additional optimizations to improve rendering performance.
    self.skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    PDBounceAndSortScene *scene = [PDBounceAndSortScene sceneWithSize:self.skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.endDelegate = self;
    // Present the scene.
    [self.skView presentScene:scene];
}

-(void)cancelButtonPressed {
    [[PDAudioManager sharedInstance] playMenuButtonPressed];
    [self dismissViewControllerWithSuccess:NO];
}

- (void)startGameButtonPressed {
    self.instructionsView.hidden = YES;
    [((PDBounceAndSortScene *)self.skView.scene) startGame];
}

- (void)startMiniGame {
    // Not used.
}

- (void)miniGameEndWithSuccess:(BOOL)success
{
    // Make a UIAlertview thing
    self.completedSuccessfully = success;
    [self.skView presentScene:nil];
    NSString *correctTitle = @"You win!";
    NSString *incorrectTitle = @"Sorry, you didn't score enough points.";
    NSString *cancelButtonTitle = @"Okay";
    NSString *alertTitle;
    if (self.completedSuccessfully) {
        alertTitle = correctTitle;
    } else {
        alertTitle = incorrectTitle;
    }
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:alertTitle
                              message:nil
                              delegate:self
                              cancelButtonTitle:cancelButtonTitle
                              otherButtonTitles:nil];
    [alertView show];
}

/* This method assumes the only alert view created is the "mini game complete" alert. */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerWithSuccess:self.completedSuccessfully];
}

- (void)dismissViewControllerWithSuccess:(BOOL)success {
    PDLevelViewController *levelViewController = (PDLevelViewController *)
        self.presentingViewController;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [levelViewController completeMiniGameWithSuccess:success];
    }];
}

@end
