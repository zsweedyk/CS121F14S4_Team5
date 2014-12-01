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
@property (nonatomic) NSMutableArray *turrets;

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
static NSString *PID_IMAGE_NAME = @"levelButtonUnlocked";

// Collision categories
static const uint32_t GOOD_MONSTER_CATEGORY = 0x1 << 0;
static const uint32_t BAD_MONSTER_CATEGORY = 0x1 << 1;

// Layout parameters
// Turrets
static const int NUM_TURRETS = 4;
static const CGFloat TURRET_Y_POSITION_FACTOR = 0.1;

// Bullets
static const CGFloat BULLET_SIZE_FACTOR = 0.125;

// Monsters
static const CGFloat MONSTER_SIZE_FACTOR = 0.25;

// Personal identifier
static const CGFloat PID_WIDTH_FACTOR = 0.9;
static const CGFloat PID_HEIGHT_FACTOR = 0.1;


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

- (void)update:(NSTimeInterval)currentTime {
    if (self.numMonsters < MAX_NUM_MONSTERS && (currentTime - self.lastMonsterRelease) >=
        MIN_TIME_BETWEEN_MONSTER_RELEASES) {
        [self createMonster];
        self.lastMonsterRelease = currentTime;
    }
    
    if (!self.hasGameStartBeenRecorded) {
        self.hasGameStartBeenRecorded = YES;
        self.gameStartTime = currentTime;
    }
    
    if (currentTime - self.gameStartTime > TOTAL_GAME_LENGTH) {
        [self endGame];
    }
    
    /*self.timerLabel.text = [NSString stringWithFormat:TIMER_LABEL_FORMAT_STRING,
                            (int) (TOTAL_GAME_LENGTH - (currentTime - self.gameStartTime))];
    self.livesLabel.text = [NSString stringWithFormat:SCORE_LABEL_FORMAT_STRING, self.score];*/
}

#pragma private methods

- (void)createTurrets {

    self.turrets = [[NSMutableArray alloc] init];

    for (int i = 0; i < NUM_TURRETS; i++) {
        SKSpriteNode *turret = [SKSpriteNode spriteNodeWithImageNamed:TURRET_IMAGE_NAME];
        turret.xScale = self.frame.size.width / turret.size.width / NUM_TURRETS;
        turret.yScale = self.frame.size.width / turret.size.height / NUM_TURRETS;
        CGFloat turretXPosition = self.frame.size.width / (NUM_TURRETS * 2)
                                  + i * self.frame.size.width / NUM_TURRETS;
        CGFloat turretYPosition = self.frame.size.height * TURRET_Y_POSITION_FACTOR
                                  + turret.size.height / 2;
        turret.position = CGPointMake(turretXPosition, turretYPosition);
        
        [self.turrets addObject:turret];
        [self addChild:turret];
    }
}

- (void)createPID {
    SKSpriteNode *pid = [SKSpriteNode spriteNodeWithImageNamed:PID_IMAGE_NAME];
    pid.xScale = PID_WIDTH_FACTOR * self.frame.size.width / pid.size.width;
    pid.yScale = PID_HEIGHT_FACTOR * self.frame.size.height / pid.size.height;
    pid.position = CGPointMake(self.frame.size.width/2, pid.size.height);
    
    [self addChild:pid];
}

- (void)createMonster {
    
    // Create sprite
    int monsterID = arc4random() % NUM_MONSTER_IMAGE_NAMES;
    SKSpriteNode *monster = [SKSpriteNode spriteNodeWithImageNamed:MONSTER_IMAGE_NAMES[monsterID]];
    monster.xScale = MONSTER_SIZE_FACTOR;
    monster.yScale = MONSTER_SIZE_FACTOR;
    
    // Determine where to spawn the monster along the X axis
    int minX = monster.size.width / 2;
    int maxX = self.frame.size.width - monster.size.width / 2;
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // Choose a touch to work with
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    // Create sprite
    SKSpriteNode *bullet = [SKSpriteNode spriteNodeWithImageNamed:BULLET_IMAGE_NAME];
    bullet.xScale = BULLET_SIZE_FACTOR;
    bullet.yScale = BULLET_SIZE_FACTOR;
    
    // Set up initial location of bullet
    int turretTouchedIndex = location.x / (self.frame.size.width / NUM_TURRETS);
    SKSpriteNode *turretTouched = self.turrets[turretTouchedIndex];
    bullet.position = turretTouched.position;
    
    // Bail out if you did not touch a turret
    if (location.y > turretTouched.position.y + turretTouched.size.height) return;
    
    // Add bullet to screen once location is verified
    [self addChild:bullet];
    
    // Give bullet a destination
    CGPoint destination = CGPointMake(turretTouched.position.x,
                                      self.frame.size.height + bullet.size.height / 2);
    
    // Create the actions
    float duration = 1.0;
    SKAction *actionMove = [SKAction moveTo:destination duration:duration];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    [bullet runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
}

/* Initialize in-game variables
 */
- (void)startGame {
    self.lives = 3;
    self.numMonsters = 0;
    self.lastMonsterRelease = 0;
    self.hasGameStartBeenRecorded = NO;
}

- (void)endGame {
    BOOL isSuccess = NO;
    if (self.lives > 0) {
        isSuccess = YES;
    }
    [self.endDelegate miniGameEndWithSuccess:isSuccess];
}

@end
