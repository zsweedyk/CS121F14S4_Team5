//
//  PDPIDdingMonstersViewController.m
//  PipeDream
//
//  Created by Paula Yuan on 11/30/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDPIDdingMonstersViewController.h"
#import "PDMiniGameProtocol.h"
#import "PDLevelViewController.h"
#import "PDPIDdingMonstersScene.h"
#import "PDMiniGameSceneEndDelegate.h"
#import "PDAudioManager.h"

@interface PDPIDdingMonstersViewController () <PDMiniGameProtocol, PDMiniGameSceneEndDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) UIViewController *presentingController;
@property (nonatomic) BOOL completedSuccessfully;
@end

@implementation PDPIDdingMonstersViewController

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
    PDPIDdingMonstersScene *scene = [PDPIDdingMonstersScene sceneWithSize:self.skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.endDelegate = self;
    // Present the scene.
    [self.skView presentScene:scene];
}

-(void)cancelButtonPressed {
    [[PDAudioManager sharedInstance] playMenuButtonPressed];
    [self dismissViewControllerWithSuccess:NO];
}

- (void)startMiniGame {
    // Not used.
}

- (void)miniGameEndWithSuccess:(BOOL)success
{
    // Make a UIAlertview thing
    self.completedSuccessfully = success;
    [self.skView presentScene:nil];
    NSString *correctTitle = @"You survived! Good job.";
    NSString *incorrectTitle = @"You lost all three lives. Too bad.";
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
