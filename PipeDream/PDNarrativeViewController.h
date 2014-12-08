//
//  PDNarrativeViewController.h
//  PipeDream
//
//  Created by CS121 on 12/7/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDNarrativeViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *narrativeImageView;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic) NSInteger levelNumber;

- (IBAction)nextButtonPressed;
- (IBAction)cancelButtonPressed;
+ (NSArray *)narrativeLevelNumbers;

@end
