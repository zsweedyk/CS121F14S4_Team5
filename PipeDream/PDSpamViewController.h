//
//  PDSpamViewController.h
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/31/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDSpamViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, retain) IBOutlet UITextView *spamTextView;

- (void)startMiniGame;
- (IBAction)spamButtonPressed;
- (IBAction)notSpamButtonPressed;
- (IBAction)cancelButtonPressed;

#pragma mark Private methods (only exposed for unit testing)

+ (NSArray *)spamTextArrayFromString:(NSString *)readString;
+ (NSArray *)spamBoolArrayFromString:(NSString *)readString;

@end
