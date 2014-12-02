//
//  PDLevelSelectionViewController.h
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/22/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDLevelSelectionViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *musicButton;
@property (nonatomic, weak) IBOutlet UIButton *soundEffectsButton;

- (void)updateLevelSelectButtonsEnabled;
+ (void)unlockLevelNumber:(NSInteger)levelNumber;
- (IBAction)levelButtonPressed:(id)sender;
- (IBAction)toggleMusicButtonPressed:(id)sender;
- (IBAction)toggleSoundEffectsButtonPressed:(id)sender;

@end
