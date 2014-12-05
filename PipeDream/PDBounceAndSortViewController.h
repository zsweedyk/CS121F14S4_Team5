//
//  PDBounceAndSortViewController.h
//  PipeDream
//
//  Created by Kate Aplin on 11/16/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface PDBounceAndSortViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIView *instructionsView;
@property (nonatomic, retain) IBOutlet SKView *skView;

- (IBAction)cancelButtonPressed;
- (IBAction)startGameButtonPressed;
- (void)startMiniGame;

@end
