//
//  PDPIDdingMonstersViewController.h
//  PipeDream
//
//  Created by Paula Yuan on 11/30/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface PDPIDdingMonstersViewController : UIViewController

@property (nonatomic, retain) IBOutlet SKView *skView;

- (IBAction)cancelButtonPressed;
- (void)startMiniGame;

@end
