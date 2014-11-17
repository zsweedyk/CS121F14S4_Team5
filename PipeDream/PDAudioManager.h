//
//  PDAudioManager.h
//  PipeDream
//
//  Created by cs121F14 on 11/16/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDAudioManager : NSObject

+ (PDAudioManager *)sharedInstance;

- (void)playMenuButtonPressed;
- (void)playCellPressed;
- (void)playCellMadeVisible;
- (void)playInfectionSpread;
- (void)playInfectionCleared;
- (void)playLevelComplete;
- (void)startBackgroundMusic;

@end
