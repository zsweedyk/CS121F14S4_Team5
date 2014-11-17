//
//  PDLevelSelectionViewController.m
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/22/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDLevelSelectionViewController.h"
#import "PDLevelViewController.h"

NSString *UNLOCKED_LEVEL_KEY = @"levelUnlocked";
NSInteger NUM_LEVEL_BUTTONS = 5; // the number of levels buttons to display

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
    UIColor *enabledBackgroundColor = [UIColor whiteColor];
    UIColor *disabledBackgroundColor = [UIColor grayColor];
    
    NSInteger unlockedLevelNumber = [PDLevelSelectionViewController unlockedLevelNumber];
    for (UIButton *button in self.levelSelectButtons) {
        NSInteger buttonLevelNumber = button.tag;
        if (buttonLevelNumber <= unlockedLevelNumber) {
            [button setEnabled:YES];
            [button setBackgroundColor:enabledBackgroundColor];
        } else {
            [button setEnabled:NO];
            [button setBackgroundColor:disabledBackgroundColor];
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

#pragma mark Private methods

/* Creates and stores levelSelectButtons
 */
- (void)createLevelSelectButtons {
    const NSInteger buttonWidth = 100;
    const NSInteger buttonHeight = 100;
    const NSInteger buttonXPadding = 30;
    const NSInteger buttonRowYPos = 525; // the vertical position of the row of buttons
    UIColor *buttonTitleColor = [UIColor blackColor];
    UIColor *buttonBackgroundColor = [UIColor whiteColor];
    
    float frameCenter = CGRectGetWidth(self.view.frame) / 2;
    float buttonRowWidth = NUM_LEVEL_BUTTONS * buttonWidth + (NUM_LEVEL_BUTTONS - 1) * buttonXPadding;
    float leftmostButtonXPos = frameCenter - (buttonRowWidth / 2.0);
    
    NSMutableArray *newLevelSelectButtons = [[NSMutableArray alloc] init];
    for (int i = 0; i < NUM_LEVEL_BUTTONS; i++) {
        NSInteger levelNumber = i + 1;
        
        float buttonRowXPos = leftmostButtonXPos + (buttonWidth + buttonXPadding) * i;
        CGRect buttonFrame = CGRectMake(buttonRowXPos, buttonRowYPos, buttonWidth, buttonHeight);
        UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
        button.tag = levelNumber;
        NSString *buttonTitle = [NSString stringWithFormat:@"%li", levelNumber];
        [button setBackgroundColor:buttonBackgroundColor];
        [button setTitleColor:buttonTitleColor forState:UIControlStateNormal];
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(levelButtonPressed:)
            forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [newLevelSelectButtons addObject:button];
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
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PDLevelViewController *levelViewController = [segue destinationViewController];
    levelViewController.levelNumber = self.levelToPlay;
}

@end
