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

@interface PDBounceAndSortViewController () <PDMiniGameProtocol, PDMiniGameSceneEndDelegate>
@property (nonatomic, strong) UIViewController *presentingController;
@end

@implementation PDBounceAndSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.presentingController = self.presentingViewController;
    // Do any additional setup after loading the view.
    
    // Configure the view.
    // Should have skView at this point
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    self.skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    PDBounceAndSortScene *scene = [PDBounceAndSortScene sceneWithSize:self.skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.endDelegate = self;
    // Present the scene.
    [self.skView presentScene:scene];
}

-(void)cancelButtonPressed {
    [self dismissViewControllerWithSuccess:NO];
}

- (void)startMiniGame {
    // Not used.
}

- (void)miniGameEndWithSuccess:(BOOL)success
{
    [self dismissViewControllerWithSuccess:success];
}

- (void)dismissViewControllerWithSuccess:(BOOL)success {
    [self.skView presentScene:nil];
    PDLevelViewController *levelViewController = (PDLevelViewController *)
    self.presentingViewController;
    [levelViewController completeMiniGameWithSuccess:success];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
