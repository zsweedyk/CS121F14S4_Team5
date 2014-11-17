//
//  PDMiniGameSceneEndDelegate.h
//  PipeDream
//
//  Created by Kate Aplin on 11/16/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//
// Allows communication between a SpriteKit mini-game and the view controller that presents it.

@protocol PDMiniGameSceneEndDelegate
@required
- (void) miniGameEndWithSuccess:(BOOL)success;
@end