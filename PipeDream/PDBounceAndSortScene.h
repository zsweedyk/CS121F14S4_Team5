//
//  PDBounceAndSortScene.h
//  PipeDream
//
//  Created by Kate Aplin on 11/16/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PDMiniGameSceneEndDelegate.h"

@interface PDBounceAndSortScene : SKScene<SKPhysicsContactDelegate>

@property (nonatomic, weak) id<PDMiniGameSceneEndDelegate> endDelegate;

@end
