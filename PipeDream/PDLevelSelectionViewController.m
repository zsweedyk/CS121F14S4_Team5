//
//  PDLevelSelectionViewController.m
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/22/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDLevelSelectionViewController.h"
#import "PDLevelViewController.h"

@interface PDLevelSelectionViewController ()

@property (nonatomic) NSInteger levelToPlay;

@end

@implementation PDLevelSelectionViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction) levelButtonPressed:(id)sender {
    // The level button's tag is the human-readable level (indexing from 1).
    self.levelToPlay = [sender tag] - 1;
    [self performSegueWithIdentifier:@"LevelSelectionToLevel" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PDLevelViewController *levelViewController = [segue destinationViewController];
    levelViewController.levelToPlay = self.levelToPlay;
}

@end
