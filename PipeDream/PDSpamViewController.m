//
//  PDSpamViewController.m
//  PipeDream
//
//  Created by Vincent Fiorentini on 10/31/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDSpamViewController.h"
#import "PDMiniGameProtocol.h"
#import "PDLevelViewController.h"

@interface PDSpamViewController () <PDMiniGameProtocol>

@property (nonatomic) BOOL isSpamTextSpam;
@property (nonatomic) NSString *spamText;
@property (nonatomic) BOOL correctAnswerSelected;

@end

@implementation PDSpamViewController

NSString *SPAM_TEXT_HEADER = @"[spam]";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.spamTextView setText:self.spamText];
}

#pragma mark Public methods

- (void)startMiniGame {
    [self setTextAndAnswer];
    // We can't necessarily update the text view here, since viewDidLoad may not have been called.
}

- (IBAction)spamButtonPressed {
    self.correctAnswerSelected = self.isSpamTextSpam;
    [self completeMiniGame];
}

- (IBAction)notSpamButtonPressed {
    self.correctAnswerSelected = !self.isSpamTextSpam;
    [self completeMiniGame];
}

-(void)cancelButtonPressed {
    [self dismissViewControllerWithSuccess:NO];
}

#pragma mark Private methods

/* Sets the properties for spam text and answer */
- (void)setTextAndAnswer {
    NSString *readString = [PDSpamViewController readFromFile];
    NSArray *spamTextArray = [PDSpamViewController spamTextArrayFromString:readString];
    NSArray *spamBoolArray = [PDSpamViewController spamBoolArrayFromString:readString];
    NSAssert(spamTextArray.count == spamBoolArray.count,
             @"Text and bool arrays are of different lengths (%d and %d)", (int) spamTextArray.count,
             (int) spamBoolArray.count);
    int randomIndex = arc4random() % [spamTextArray count];
    self.spamText = spamTextArray[randomIndex];
    self.isSpamTextSpam = spamBoolArray[randomIndex];
}

/* Returns an array of each spam text from the given string */
+ (NSArray *)spamTextArrayFromString:(NSString *)readString {
    // Expects a file in this format: "[spam]0\nHello, etc.\nNewlines allowed\n[spam]1\nHi...".
    NSArray *spamTextArrayWithHeader = [readString componentsSeparatedByString:SPAM_TEXT_HEADER];
    // The first object in the array is blank, so we get rid of it.
    spamTextArrayWithHeader = [spamTextArrayWithHeader subarrayWithRange:
                               NSMakeRange(1, spamTextArrayWithHeader.count - 1)];
    // Now we make an array that strips away the first line (which contained the spamTextHeader).
    NSMutableArray *spamTextArray = [[NSMutableArray alloc] init];
    for (NSString *spamTextWithHeader in spamTextArrayWithHeader) {
        // Remove the first line (the spam text's header) and add the remainder to the return array.
        NSRange newlineRange = [spamTextWithHeader rangeOfString:@"\n"];
        NSRange firstLineRange = NSMakeRange(0, newlineRange.location + newlineRange.length);
        NSString *spamText = [spamTextWithHeader stringByReplacingCharactersInRange:firstLineRange
            withString:@""];
        [spamTextArray addObject:spamText];
    }
    return spamTextArray;
}

/* Returns an array of whether each spam text is spam or not from the given string */
+ (NSArray *)spamBoolArrayFromString:(NSString *)readString {
    // Expects a file in this format: "[spam]0\nHello, etc.\nNewlines allowed\n[spam]1\nHi...".
    NSString *spamBoolStringTrue = @"1";
    NSString *spamBoolStringFalse = @"0";
    NSArray *spamTextArrayWithHeader = [readString componentsSeparatedByString:SPAM_TEXT_HEADER];
    // The first object in the array is blank, so we get rid of it.
    spamTextArrayWithHeader = [spamTextArrayWithHeader subarrayWithRange:
                               NSMakeRange(1, spamTextArrayWithHeader.count - 1)];
    NSMutableArray *spamBoolArray = [[NSMutableArray alloc] init];
    for (NSString *spamTextWithHeader in spamTextArrayWithHeader) {
        NSRange spamBoolStringRange = NSMakeRange(0, 1);
        NSString *spamBoolString = [spamTextWithHeader substringWithRange:spamBoolStringRange];
        if ([spamBoolString isEqualToString:spamBoolStringTrue]) {
            [spamBoolArray addObject:[NSNumber numberWithBool:YES]];
        } else if ([spamBoolString isEqualToString:spamBoolStringFalse]) {
            [spamBoolArray addObject:[NSNumber numberWithBool:NO]];
        }
    }
    return spamBoolArray;
}

/* Returns the string of text from the spams file */
+ (NSString *)readFromFile {
    NSString *spamFileName = @"spams";
    NSString *path = [[NSBundle mainBundle] pathForResource:spamFileName ofType:@"txt"];
    NSError *error;
    NSString *readString = [[NSString alloc] initWithContentsOfFile:path
        encoding:NSUTF8StringEncoding error:&error];
    return readString;
}

/* Creates an alert view informing the user whether or not their choice was correct */
- (void)completeMiniGame {
    NSString *correctTitle = @"Correct!";
    NSString *incorrectTitle = @"Incorrect";
    NSString *cancelButtonTitle = @"Okay";
    NSString *alertTitle;
    if (self.correctAnswerSelected) {
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
    [self dismissViewControllerWithSuccess:self.correctAnswerSelected];
}

- (void)dismissViewControllerWithSuccess:(BOOL)success {
    PDLevelViewController *levelViewController = (PDLevelViewController *)
    self.presentingViewController;
    [levelViewController completeMiniGameWithSuccess:success];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
