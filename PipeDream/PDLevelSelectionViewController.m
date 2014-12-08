//
//  PDLevelSelectionViewController.m
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/22/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDLevelSelectionViewController.h"
#import "PDLevelViewController.h"
#import "PDAudioManager.h"

NSString *UNLOCKED_LEVEL_KEY = @"levelUnlocked";
NSInteger NUM_LEVEL_BUTTONS = 32; // the number of levels buttons to display
NSInteger NUM_BUTTONS_PER_ROW = 4;
CGFloat BUTTON_DISABLED_ALPHA = 0.5; // the alpha for buttons that are toggled off

@interface PDLevelSelectionViewController ()

@property (nonatomic) NSInteger levelToPlay;
@property (nonatomic, strong) NSArray *levelSelectButtons;

@end

@implementation PDLevelSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    [self createLevelSelectButtons];
    [self updateLevelSelectButtonsEnabled];
}

#pragma mark Public methods

/* Sets the appearance of the level select buttons to match whether they should be unlocked.
 */
- (void)updateLevelSelectButtonsEnabled {
    NSString *enabledButtonBackgroundImageName = @"levelButtonUnlocked";
    NSString *disabledButtonBackgroundImageName = @"levelButtonLocked";
    
    NSInteger unlockedLevelNumber = [PDLevelSelectionViewController unlockedLevelNumber];
    for (UIButton *button in self.levelSelectButtons) {
        NSInteger buttonLevelNumber = button.tag;
        if (buttonLevelNumber <= unlockedLevelNumber) {
            [button setEnabled:YES];
            [button setBackgroundImage:[UIImage imageNamed:enabledButtonBackgroundImageName]
                              forState:UIControlStateNormal];
        } else {
            [button setEnabled:NO];
            [button setBackgroundImage:[UIImage imageNamed:disabledButtonBackgroundImageName]
                              forState:UIControlStateNormal];
        }
    }
}

/* Updates NSUserDefaults to set the unlocked level number to the given levelNumber if it's greater
 * than the existing unlocked level number.
 */
+ (void)unlockLevelNumber:(NSInteger)levelNumber {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger previousUnlockedLevelNumber = [PDLevelSelectionViewController unlockedLevelNumber];
    [defaults setInteger:MAX(previousUnlockedLevelNumber, levelNumber) forKey:UNLOCKED_LEVEL_KEY];
    [defaults synchronize];
}

// Back to Main Menu
- (void)returnToMainMenuButtonPressed:(id)sender {
    [[PDAudioManager sharedInstance] playMenuButtonPressed];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Private methods

/* Creates and stores levelSelectButtons
 */
- (void)createLevelSelectButtons {
    const NSInteger buttonWidth = 75;
    const NSInteger buttonHeight = 75;
    const NSInteger buttonXPadding = 30;
    const NSInteger buttonYPadding = 30;
    const NSInteger numRows = NUM_LEVEL_BUTTONS / NUM_BUTTONS_PER_ROW;
    UIColor *buttonTitleColor = [UIColor blackColor];
    UIColor *buttonBackgroundColor = [UIColor clearColor];
    NSString *buttonBackgroundImageName = @"levelButtonUnlocked";
    
    float frameCenter = CGRectGetWidth(self.view.frame) / 2;
    float buttonRowWidth = NUM_BUTTONS_PER_ROW * buttonWidth + (NUM_BUTTONS_PER_ROW - 1) * buttonXPadding;
    float leftmostButtonXPos = frameCenter - (buttonRowWidth / 2.0);
    float topmostButtonYPos = (buttonHeight * 1.75);
    
    
    NSMutableArray *newLevelSelectButtons = [[NSMutableArray alloc] init];
    NSInteger levelNumber = 1;
    for (int row = 0; row < numRows; row++) {
        float buttonRowYPos = topmostButtonYPos + (buttonHeight + buttonYPadding) * row;
        for (int col = 0; col < NUM_BUTTONS_PER_ROW; col++) {
            
            float buttonRowXPos = leftmostButtonXPos + (buttonWidth + buttonXPadding) * col;
            CGRect buttonFrame = CGRectMake(buttonRowXPos, buttonRowYPos, buttonWidth, buttonHeight);
            UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
            button.tag = levelNumber;
            NSString *buttonTitle = [NSString stringWithFormat:@"%li", (long)levelNumber];
            [button setBackgroundColor:buttonBackgroundColor];
            [button setBackgroundImage:[UIImage imageNamed:buttonBackgroundImageName]
                              forState:UIControlStateNormal];
            [button setAdjustsImageWhenDisabled:NO];
            [button setTitleColor:buttonTitleColor forState:UIControlStateNormal];
            [button setTitle:buttonTitle forState:UIControlStateNormal];
            
            [button addTarget:self action:@selector(levelButtonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
            [newLevelSelectButtons addObject:button];
            levelNumber++;
        }
    }

    
    self.levelSelectButtons = newLevelSelectButtons;
}

/* Returns the unlocked level number from NSUserDefaults (or 1 if none is set).
 */
+ (NSInteger) unlockedLevelNumber {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger unlockedLevelNumber = [defaults integerForKey:UNLOCKED_LEVEL_KEY];
    // If UNLOCKED_LEVEL_KEY has not been set, default to having level 1 unlocked.
    return MAX(unlockedLevelNumber, 1);
}

- (IBAction)levelButtonPressed:(id)sender {
    // The level button's tag is the human-readable level (indexing from 1).
    self.levelToPlay = [sender tag];
    [self performSegueWithIdentifier:@"LevelSelectionToLevel" sender:self];
    [[PDAudioManager sharedInstance] playMenuButtonPressed];
}

-(void)toggleMusicButtonPressed:(id)sender {
    [[PDAudioManager sharedInstance] playMenuButtonPressed];
    [[PDAudioManager sharedInstance] toggleMusic];
    
    if (self.musicButton.alpha == 1.0) {
        [self.musicButton setAlpha:BUTTON_DISABLED_ALPHA];
    } else {
        [self.musicButton setAlpha:1.0];
    }
}

-(void)toggleSoundEffectsButtonPressed:(id)sender {
    [[PDAudioManager sharedInstance] toggleSoundEffects];
    // We play the sound after toggling to avoid playing when the user wants to disable sounds.
    [[PDAudioManager sharedInstance] playMenuButtonPressed];
    
    if (self.soundEffectsButton.alpha == 1.0) {
        [self.soundEffectsButton setAlpha:BUTTON_DISABLED_ALPHA];
    } else {
        [self.soundEffectsButton setAlpha:1.0];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PDLevelViewController *levelViewController = [segue destinationViewController];
    levelViewController.levelNumber = self.levelToPlay;
}

@end
