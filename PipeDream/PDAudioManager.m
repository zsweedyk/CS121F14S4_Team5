//
//  PDAudioManager.m
//  PipeDream
//
//  Created by cs121F14 on 11/16/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDAudioManager.h"
#import <AVFoundation/AVFoundation.h>
#include <AudioToolbox/AudioToolbox.h>

@interface PDAudioManager ()
@property AVAudioPlayer *menuButtonPressedPlayer;
@property AVAudioPlayer *cellPressedPlayer;
@property AVAudioPlayer *infectedCellPressedPlayer;
@property AVAudioPlayer *cellMadeVisiblePlayer;
@property AVAudioPlayer *infectionSpreadPlayer;
@property AVAudioPlayer *infectionClearedPlayer;
@property AVAudioPlayer *levelCompletePlayer;
@property AVAudioPlayer *backgroundMusicPlayer;
@property (nonatomic) BOOL soundEffectsEnabled;
@end

@implementation PDAudioManager
static PDAudioManager *sharedAudioManager = nil;
/*
 
 Music (one looping song)
 http://www.newgrounds.com/audio/listen/583897
 */

#pragma mark Public methods

+ (PDAudioManager *)sharedInstance
{
    if (sharedAudioManager == nil) {
        sharedAudioManager = [[PDAudioManager alloc] init];
        sharedAudioManager.soundEffectsEnabled = YES;
    }
    return sharedAudioManager;
}

- (void)playMenuButtonPressed
{
    if (self.menuButtonPressedPlayer && self.soundEffectsEnabled) {
        [self.menuButtonPressedPlayer play];
    }
}

- (void)playCellPressed
{
    if (self.cellPressedPlayer && self.soundEffectsEnabled) {
        [self.cellPressedPlayer play];
    }
}

- (void)playInfectedCellPressed
{
    if (self.infectedCellPressedPlayer && self.soundEffectsEnabled) {
        [self.infectedCellPressedPlayer play];
    }
}

- (void)playCellMadeVisible
{
    if (self.cellMadeVisiblePlayer && self.soundEffectsEnabled) {
        [self.cellMadeVisiblePlayer play];
    }
}

- (void)playInfectionSpread
{
    if (self.infectionSpreadPlayer && self.soundEffectsEnabled) {
        [self.infectionSpreadPlayer play];
    }
}

- (void)playInfectionCleared
{
    if (self.infectionClearedPlayer && self.soundEffectsEnabled) {
        [self.infectionClearedPlayer play];
    }
}

- (void)playLevelComplete
{
    if (self.levelCompletePlayer && self.soundEffectsEnabled) {
        [self.levelCompletePlayer play];
    }
}

- (void)startBackgroundMusic
{
    if (self.backgroundMusicPlayer) {
        [self.backgroundMusicPlayer play];
    }
}

- (void)stopBackgroundMusic
{
    if (self.backgroundMusicPlayer) {
        [self.backgroundMusicPlayer stop];
    }
}

#pragma mark Private methods
- (id)init
{
    self = [super init];
    if (self) {
        [self initializeMenuButtonPressedPlayer];
        [self initializeCellPressedPlayer];
        [self initializeInfectedCellPressedPlayer];
        [self initializeCellMadeVisiblePlayer];
        [self initializeInfectionSpreadPlayer];
        [self initializeInfectionClearedPlayer];
        [self initializeLevelCompletePlayer];
        [self initializeBackgroundMusicPlayer];
    }
    return self;
}

/*
 * Audio source:
 * https://www.freesound.org/people/annabloom/sounds/219068/
 * This audio is liscenced under (CC BY-NC 3.0)
 */
- (void)initializeMenuButtonPressedPlayer
{
    NSString *fileName = @"219068__annabloom__click2";
    NSString *fileExtension = @"wav";
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    self.menuButtonPressedPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.menuButtonPressedPlayer.numberOfLoops = 0;
}

/*
 * Audio source:
 * https://www.freesound.org/people/f4ngy/sounds/240777/
 * This audio is liscenced under (CC BY 3.0)
 * Modified by Flapjack Stack Hack (shortened)
 */
- (void)initializeCellPressedPlayer
{
    NSString *fileName = @"240777__f4ngy__dealing-card-shortened";
    NSString *fileExtension = @"wav";
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    self.cellPressedPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.cellPressedPlayer.numberOfLoops = 0;
}

/*
 * Audio source:
 * https://www.freesound.org/people/annabloom/sounds/219068/
 * This audio is liscenced under (CC BY-NC 3.0)
 */
- (void)initializeInfectedCellPressedPlayer
{
    NSString *fileName = @"219068__annabloom__click2";
    NSString *fileExtension = @"wav";
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    self.infectedCellPressedPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.infectedCellPressedPlayer.numberOfLoops = 0;
}

/*
 * Audio source:
 * https://www.freesound.org/people/Splashdust/sounds/84322/
 * This audio is liscenced under (CC0 1.0)
 */
- (void)initializeCellMadeVisiblePlayer
{
    NSString *fileName = @"84322__splashdust__flipcard";
    NSString *fileExtension = @"wav";
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    self.cellMadeVisiblePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.cellMadeVisiblePlayer.numberOfLoops = 0;
}

/*
 * Audio source:
 * https://www.freesound.org/people/qubodup/sounds/157609/
 * This audio is liscenced under (CC0 1.0)
 */
- (void)initializeInfectionSpreadPlayer
{
    NSString *fileName = @"157609__qubodup__hollow-bang";
    NSString *fileExtension = @"wav";
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    self.infectionSpreadPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.infectionSpreadPlayer.numberOfLoops = 0;
}

/*
 * Audio source:
 * https://www.freesound.org/people/SoundCollectah/sounds/157790/
 * This audio is liscenced under (CC BY-NC 3.0)
 * Modified by Flapjack Stack Hack (shortened)
 */
- (void)initializeInfectionClearedPlayer
{
    NSString *fileName = @"157790__soundcollectah__airpipe-swoosh-01-shortened";
    NSString *fileExtension = @"wav";
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    self.infectionClearedPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.infectionClearedPlayer.numberOfLoops = 0;
}

/*
 * Audio source:
 * https://www.freesound.org/people/blackstalian/sounds/140511/
 * This audio is liscenced under (CC0 1.0)
 */
- (void)initializeLevelCompletePlayer
{
    NSString *fileName = @"140511__blackstalian__click-sfx7";
    NSString *fileExtension = @"wav";
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    self.levelCompletePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.levelCompletePlayer.numberOfLoops = 0;
}

/*
 * Audio source:
 * http://www.newgrounds.com/audio/listen/583897
 * This audio is liscenced under (CC BY-NC-SA 3.0)
 */
- (void)initializeBackgroundMusicPlayer
{
    NSString *fileName = @"583897_JBroadway---Over-Th";
    NSString *fileExtension = @"mp3";
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
}

// This method toggles whether or not the background music is playing.
- (void)toggleMusic
{
    if (self.backgroundMusicPlayer.isPlaying) {
        [self stopBackgroundMusic];
    } else {
        [self startBackgroundMusic];
    }
}

// This method toggles whether or not sound effects will actually be played.
- (void)toggleSoundEffects
{
    self.soundEffectsEnabled = !self.soundEffectsEnabled;
}

@end
