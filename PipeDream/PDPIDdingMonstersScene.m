//
//  PDPIDdingMonstersScene.m
//  PipeDream
//
//  Created by Paula Yuan on 11/30/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDPIDdingMonstersScene.h"

@interface PDPIDdingMonstersScene()

@property (nonatomic) int lives;
@property (nonatomic) int numMonsters;
@property (nonatomic) CFTimeInterval lastMonsterRelease;
@property (nonatomic) BOOL hasGameStartBeenRecorded;
@property (nonatomic) CFTimeInterval gameStartTime;
@property (nonatomic, strong) UILabel* timerLabel;
@property (nonatomic, strong) UILabel* livesLabel;

@end

@implementation PDPIDdingMonstersScene

// Game parameters
static const int MAX_NUM_MONSTERS = 4;
static const CFTimeInterval MIN_TIME_BETWEEN_MONSTER_RELEASES = 2.0;
static const CFTimeInterval TOTAL_GAME_LENGTH = 20;

// Sprite image names - most of these are to be changed
static NSString *TURRET_IMAGE_NAME = @"NxSx";
static NSString *MONSTER_IMAGE_NAMES[] = {@"NESW", @"NESWi"};
static const int NUM_MONSTER_IMAGE_NAMES = 2;
static NSString *BULLET_IMAGE_NAME = @"goal";
static NSString *PID_IMAGE_NAME = @"bar";

// Collision categories
static const uint32_t GOOD_MONSTER_CATEGORY = 0x1 << 0;
static const uint32_t BAD_MONSTER_CATEGORY = 0x1 << 1;

// Layout parameters
// Turrets
static const int NUM_TURRETS;
static const CGFloat TURRET_X_POSITION_FACTORS[] = {1/8, 3/8, 5/8, 7/8}; // change this to be flexible with the number of turrets
static const CGFloat TURRET_Y_POSITION_FACTOR = 1.0 / 8.0;

// Personal identifier
static const CGFloat PID_WIDTH_FACTOR = 7.0 / 8.0;
static const CGFloat PID_HEIGHT_FACTOR = 1.0 / 8.0;


// Personal
// Background
static const float RED_BACKGROUND = 0.5;
static const float GREEN_BACKGROUND = 0.5;
static const float BLUE_BACKGROUND = 0.5;
static const float ALPHA_BACKGROUND = 1.0;

#pragma public methods

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:RED_BACKGROUND green:GREEN_BACKGROUND
                                                blue:BLUE_BACKGROUND alpha:ALPHA_BACKGROUND];
        [self createTurrets];
        [self createPID];
        [self startGame];
        self.physicsWorld.contactDelegate = self;
    }
    return self;
}

#pragma private methods

- (void)createTurrets {
    NSMutableArray *turrets = [NSMutableArray init];
    for (int i = 0; i < NUM_TURRETS; i++) {
        SKSpriteNode *turret = [SKSpriteNode spriteNodeWithImageNamed:TURRET_IMAGE_NAME];
        turret.position = CGPointMake(turret.frame.size.width * TURRET_X_POSITION_FACTORS[i],
                                      turret.frame.size.height * TURRET_Y_POSITION_FACTOR);
        
        [turrets addObject:turret];
        
        [self addChild:turret];
    }
}

- (void)createPID {
    SKSpriteNode *pid = [SKSpriteNode spriteNodeWithImageNamed:PID_IMAGE_NAME];
    pid.position = CGPointMake(pid.frame.size.width * (2*PID_WIDTH_FACTOR - 1), 0);
    pid.xScale = PID_WIDTH_FACTOR * pid.frame.size.width / pid.size.width;
    pid.yScale = PID_HEIGHT_FACTOR * pid.frame.size.height / pid.size.height;
    [self addChild:pid];
}

- (void)addMonster {
    
    // Create sprite
    int monsterID = arc4random() % NUM_MONSTER_IMAGE_NAMES;
    SKSpriteNode *monster = [SKSpriteNode spriteNodeWithImageNamed:MONSTER_IMAGE_NAMES[monsterID]];
    
    // Determine where to spawn the monster along the X axis
    int minX = monster.size.height / 2;
    int maxX = self.frame.size.height - monster.size.height / 2;
    int rangeX = maxX - minX;
    int actualX = (arc4random() % rangeX) + minX;
    
    // Create the monster slightly off-screen along the top edge and at calculated x position
    monster.position = CGPointMake(actualX, self.frame.size.height + monster.size.height / 2);
    [self addChild:monster];
    
    // Determine speed of the monster
    int minDuration = 3.0;
    int maxDuration = 5.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    SKAction *actionMove = [SKAction moveTo: CGPointMake(actualX, 0) duration: actualDuration];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    [monster runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
}

- (void)startGame {
    self.lives = 3;
    self.numMonsters = 0;
    self.lastMonsterRelease = 0;
    self.hasGameStartBeenRecorded = NO;
}

@end
