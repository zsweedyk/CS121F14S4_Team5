//
//  PDNarrativeViewController.m
//  PipeDream
//
//  Created by CS121 on 12/7/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDNarrativeViewController.h"

@interface PDNarrativeViewController ()

@property (nonatomic) NSInteger currentImageIndex;
@property (nonatomic, strong) NSArray *imageDictionary;

@end

@implementation PDNarrativeViewController

#pragma mark Public methods

- (void)nextButtonPressed {
    if (self.currentImageIndex >= [self.imageDictionary count] - 1) {
        [self dismissViewController];
    } else {
        self.currentImageIndex++;
        [self updateNarrativeImage];
    }
}

- (void)cancelButtonPressed {
    [self dismissViewController];
}

+ (NSArray*)narrativeLevelNumbers {
    return [[PDNarrativeViewController narrativeLevelImages] allKeys];
}

#pragma mark Private methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageDictionary = [[PDNarrativeViewController narrativeLevelImages]
                            objectForKey:[NSNumber numberWithInteger:self.levelNumber]];
    [self updateNarrativeImage];
}

// updateNarrativeImage sets the narrative image and the text of the next button
- (void)updateNarrativeImage {
    NSString *nextImageTitle = @"Next";
    NSString *playGameTitle = @"Go!";
    
    NSString *narrativeImageName = [self.imageDictionary objectAtIndex:self.currentImageIndex];
    [self.narrativeImageView setImage:[UIImage imageNamed:narrativeImageName]];
    
    if (self.currentImageIndex < [self.imageDictionary count] - 1) {
        [self.nextButton setTitle:nextImageTitle forState:UIControlStateNormal];
    } else {
        [self.nextButton setTitle:playGameTitle forState:UIControlStateNormal];
    }
}

- (void)dismissViewController {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

+ (NSDictionary*)narrativeLevelImages {
    // narativeLevelImages is a dictionary, where each key is a level number and each value is an
    // array of strings representing the image names to show for that level's narrative.
    NSDictionary *levelsWithImageSets = @{
                                          @1 : @[@"narrative-1-1", @"narrative-1-2",
                                                 @"narrative-1-3"],
                                          @5 : @[@"narrative-2-1", @"narrative-2-2"],
                                          @9 : @[@"narrative-3-1", @"narrative-3-2",
                                                 @"narrative-3-3"]
                                        };
    return levelsWithImageSets;
}

@end
