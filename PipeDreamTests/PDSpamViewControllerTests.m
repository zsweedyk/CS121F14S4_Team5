//
//  PDSpamViewControllerTests.m
//  PipeDream
//
//  Created by CS121 on 12/10/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PDSpamViewController.h"

@interface PDSpamViewControllerTests : XCTestCase

@end

@implementation PDSpamViewControllerTests

/* Tests the SpamViewController's spamTextArrayFromString: method */
- (void) testSpamTextFromString {
    NSArray *spamTextArraySource = [NSArray arrayWithObjects:@"Abc\nDef\n", @"Ghi\n\n", @"Jkl", nil];
    NSString *spamSourceText = [NSString stringWithFormat:@"[spam]0\n%@[spam]1\n%@[spam]0\n%@",
                                spamTextArraySource[0], spamTextArraySource[1], spamTextArraySource[2]];
    NSArray *spamTextArray = [PDSpamViewController spamTextArrayFromString:spamSourceText];
    XCTAssert(spamTextArray.count == spamTextArraySource.count,
              @"Spam text array has correct count.");
    for (int i = 0; i < spamTextArray.count; i++) {
        NSString *spamText = spamTextArray[i];
        NSString *spamTextSource = spamTextArraySource[i];
        XCTAssert([spamText isEqualToString:spamTextSource], @"Spam text is correct.");
    }
}

/* Tests the SpamViewController's spamBoolArrayFromString: method */
- (void) testSpamBoolFromString {
    NSArray *spamTextArraySource = [NSArray arrayWithObjects:@"Abc\nDef\n", @"Ghi\n\n", @"Jkl", nil];
    NSArray *spamBoolArrayNumbers = [NSArray arrayWithObjects:[NSNumber numberWithBool:NO],
                                     [NSNumber numberWithBool:YES],
                                     [NSNumber numberWithBool:NO],
                                     nil];
    NSArray *spamBoolArraySource = [NSArray arrayWithObjects:@"0", @"1", @"0", nil];
    NSString *spamSourceText = [NSString stringWithFormat:@"[spam]%@\n%@[spam]%@\n%@[spam]%@\n%@",
                                spamBoolArraySource[0], spamTextArraySource[0],
                                spamBoolArraySource[1], spamTextArraySource[1],
                                spamBoolArraySource[2], spamTextArraySource[2]];
    NSArray *spamBoolArray = [PDSpamViewController spamBoolArrayFromString:spamSourceText];
    XCTAssert(spamBoolArray.count == spamTextArraySource.count,
              @"Spam bool array has correct count.");
    for (int i = 0; i < spamBoolArray.count; i++) {
        NSNumber *spamBool = spamBoolArray[i];
        NSNumber *spamBoolSource = spamBoolArrayNumbers[i];
        XCTAssert([spamBool boolValue] == [spamBoolSource boolValue], @"Spam bool is correct.");
    }
}


@end