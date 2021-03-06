//
//  PDPIDdingMonstersScene.m
//  PipeDream
//
//  Created by Paula Yuan on 11/30/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDPIDdingMonstersScene.h"
#import "PDPIDScenario.h"
#import "PDAudioManager.h"

@interface PDPIDdingMonstersScene()

@property (nonatomic) int lives;
@property (nonatomic) int numMonsters;
@property (nonatomic) CFTimeInterval lastMonsterRelease;
@property (nonatomic) BOOL hasGameStartBeenRecorded;
@property (nonatomic) CFTimeInterval gameStartTime;
@property (nonatomic, strong) SKLabelNode* timerLabel;
@property (nonatomic, strong) SKLabelNode* livesLabel;
@property (nonatomic, strong) SKLabelNode* pidLabel;
@property (nonatomic) NSMutableArray *turrets;
@property (nonatomic) PDPIDScenario *scenario;
@property (nonatomic) BOOL hasGameStarted;


@end

@implementation PDPIDdingMonstersScene

// Game parameters
static const int MAX_NUM_LIVES = 3;
static const int MAX_NUM_MONSTERS = 3;
static const CFTimeInterval MIN_TIME_BETWEEN_MONSTER_RELEASES = 2.0;
static const CFTimeInterval TOTAL_GAME_LENGTH = 20;

// Sprite image names - most of these are to be changed
static NSString *TURRET_IMAGE_NAME = @"NxSx";
static const int NUM_MONSTER_IMAGE_NAMES = 7;
static NSString *BULLET_IMAGE_NAME = @"laser";
static NSString *PID_IMAGE_NAME = @"PIDblock";
// Monsters
static NSString *ONLINE_FRIEND_NAME = @"online_friend";
static NSString *POP_UP_AD_NAME = @"pop_up_ad";
static NSString *REAL_FRIEND_NAME = @"real_friend";
static NSString *SOCIAL_MEDIA_NAME = @"social_media";
static NSString *SPOUSE_NAME = @"spouse";
static NSString *STRANGER_ONLINE_NAME = @"stranger_online";
static NSString *TEACHER_NAME = @"teacher";
static NSString *MONSTER_IMAGE_NAMES[] = {@"online_friend", @"pop_up_ad", @"real_friend",
    @"social_media", @"spouse", @"stranger_online", @"teacher"};
static NSString *MONSTER_LABEL_NAMES[] = {@"Online Friend", @"Pop Up Ad", @"Real Friend",
    @"Social Media", @"Spouse", @"Stranger Online", @"Teacher"};

// Collision categories
static const uint32_t GOOD_MONSTER_CATEGORY = 0x1 << 0;
static const uint32_t BAD_MONSTER_CATEGORY = 0x1 << 1;
static const uint32_t BULLET_CATEGORY = 0x1 << 2;
static const uint32_t PID_CATEGORY = 0x1 << 3;
static const uint32_t TURRET_CATEGORY = 0x1 << 4;

// Layout parameters
// Turrets
static const int NUM_TURRETS = 4;
static const CGFloat TURRET_Y_POSITION_FACTOR = 0.1;
// Bullets
static const CGFloat BULLET_SIZE_FACTOR = 0.125;
// Monsters
static const CGFloat MONSTER_SIZE_FACTOR = 0.3;
// Personal identifier
static const CGFloat PID_WIDTH_FACTOR = 0.9;
static const CGFloat PID_HEIGHT_FACTOR = 0.1;

// General label
static NSString *LABEL_FONT_NAME = @"Heiti SC";
static const int LABEL_FONT_SIZE = 30;
// Score label
static const float LIVES_LABEL_X_POSITION_FACTOR = 0.8;
static const float LIVES_LABEL_Y_POSITION_FACTOR = 0.9;
static NSString *LIVES_LABEL_FORMAT_STRING = @"Lives: %d";
// Timer label
static const float TIMER_LABEL_X_POSITION_FACTOR = 0.2;
static const float TIMER_LABEL_Y_POSITION_FACTOR = 0.9;
static NSString *TIMER_LABEL_FORMAT_STRING = @"Time: %d";
// PID label
static const float PID_LABEL_X_POSITION_FACTOR = 0.5;
static const float PID_LABEL_Y_POSITION_FACTOR = 0.08;

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

        [self chooseScenario];
        [self createTurrets];
        [self createPID];
        [self createLabels];

        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
    }
    return self;
}

- (void)update:(NSTimeInterval)currentTime {
    
    if (!self.hasGameStarted) {
        return;
    }
    
    // Release monsters
    if (self.numMonsters < MAX_NUM_MONSTERS && (currentTime - self.lastMonsterRelease) >=
        MIN_TIME_BETWEEN_MONSTER_RELEASES) {
        [self createMonster];
        self.lastMonsterRelease = currentTime;
    }
    
    // Start game
    if (!self.hasGameStartBeenRecorded) {
        self.hasGameStartBeenRecorded = YES;
        self.gameStartTime = currentTime;
    }
    
    // End game if time is up or lives are lost
    if (currentTime - self.gameStartTime > TOTAL_GAME_LENGTH || self.lives == 0) {
        [self endGame];
    }
    
    // Update timer and lives labels
    self.timerLabel.text = [NSString stringWithFormat:TIMER_LABEL_FORMAT_STRING,
                            (int) ceil(TOTAL_GAME_LENGTH - (currentTime - self.gameStartTime))];
    self.livesLabel.text = [NSString stringWithFormat:LIVES_LABEL_FORMAT_STRING, self.lives];
}

#pragma private methods

- (void)createLabels {
    
    // Timer label
    self.timerLabel = [SKLabelNode labelNodeWithFontNamed:LABEL_FONT_NAME];
    self.timerLabel.fontSize = LABEL_FONT_SIZE;
    self.timerLabel.position = CGPointMake(self.frame.size.width * TIMER_LABEL_X_POSITION_FACTOR,
                                         self.frame.size.height * TIMER_LABEL_Y_POSITION_FACTOR);
    [self addChild:self.timerLabel];
    
    // Lives label
    self.livesLabel = [SKLabelNode labelNodeWithFontNamed:LABEL_FONT_NAME];
    self.livesLabel.fontSize = LABEL_FONT_SIZE;
    self.livesLabel.position = CGPointMake(self.frame.size.width * LIVES_LABEL_X_POSITION_FACTOR,
                                         self.frame.size.height * LIVES_LABEL_Y_POSITION_FACTOR);
    [self addChild:self.livesLabel];
    
    // PID label
    self.pidLabel = [SKLabelNode labelNodeWithFontNamed:LABEL_FONT_NAME];
    self.pidLabel.fontSize = LABEL_FONT_SIZE;
    self.pidLabel.fontColor = [SKColor whiteColor];
    self.pidLabel.text = self.scenario.personalIdentifier;
    self.pidLabel.position = CGPointMake(self.frame.size.width * PID_LABEL_X_POSITION_FACTOR,
                                         self.frame.size.height * PID_LABEL_Y_POSITION_FACTOR);
    [self addChild:self.pidLabel];

}

- (void)chooseScenario {
    
    int numScenarios = 8;
    int scenarioIndex = arc4random() % numScenarios;
    
    switch (scenarioIndex) {
        
        case 0: {
            NSString *pwStr = @"Password";
            NSArray *pwMonsters = [NSArray arrayWithObjects: nil];
            self.scenario = [[PDPIDScenario alloc] initWithPID:pwStr andOkMonsters:pwMonsters];
            break;
        }
        case 1: {
            NSString *addrStr = @"Home Address";
            NSArray *addrMonsters = [NSArray arrayWithObjects: REAL_FRIEND_NAME, TEACHER_NAME,
                                     SPOUSE_NAME, nil];
            self.scenario = [[PDPIDScenario alloc] initWithPID:addrStr andOkMonsters:addrMonsters];
            break;
        }
        case 2: {
            NSString *phoneStr = @"Phone Number";
            NSArray *phoneMonsters = [NSArray arrayWithObjects: REAL_FRIEND_NAME, TEACHER_NAME,
                                      SPOUSE_NAME, nil];
            self.scenario = [[PDPIDScenario alloc] initWithPID:phoneStr andOkMonsters:phoneMonsters];
            break;
        }
        case 3: {
            NSString *emailStr = @"E-mail Address";
            NSArray *emailMonsters = [NSArray arrayWithObjects: REAL_FRIEND_NAME, ONLINE_FRIEND_NAME,
                                      TEACHER_NAME, SPOUSE_NAME, SOCIAL_MEDIA_NAME, nil];
            self.scenario = [[PDPIDScenario alloc] initWithPID:emailStr andOkMonsters:emailMonsters];
            break;
        }
        case 4: {
            NSString *bdayStr = @"Birthday";
            NSArray *bdayMonsters = [NSArray arrayWithObjects: REAL_FRIEND_NAME, ONLINE_FRIEND_NAME,
                                     TEACHER_NAME, SPOUSE_NAME, SOCIAL_MEDIA_NAME, nil];
            self.scenario = [[PDPIDScenario alloc] initWithPID:bdayStr andOkMonsters:bdayMonsters];
            break;
        }
        case 5: {
            NSString *pinStr = @"Bank PIN";
            NSArray *pinMonsters = [NSArray arrayWithObjects: nil];
            self.scenario = [[PDPIDScenario alloc] initWithPID:pinStr andOkMonsters:pinMonsters];
            break;
        }
        case 6: {
            NSString *nameStr = @"Real Name";
            NSArray *nameMonsters = [NSArray arrayWithObjects: REAL_FRIEND_NAME, ONLINE_FRIEND_NAME,
                                     TEACHER_NAME, SPOUSE_NAME, SOCIAL_MEDIA_NAME, nil];
            self.scenario = [[PDPIDScenario alloc] initWithPID:nameStr andOkMonsters:nameMonsters];
            break;
        }
        case 7: {
            NSString *nnameStr = @"Nickname";
            NSArray *nnameMonsters = [NSArray arrayWithObjects: REAL_FRIEND_NAME, ONLINE_FRIEND_NAME,
                                      TEACHER_NAME, ONLINE_FRIEND_NAME, SPOUSE_NAME,
                                      SOCIAL_MEDIA_NAME, nil];
            self.scenario = [[PDPIDScenario alloc] initWithPID:nnameStr andOkMonsters:nnameMonsters];
            break;
        }
        default: {
            break;
        }
    }
}

- (void)createTurrets {

    self.turrets = [[NSMutableArray alloc] init];

    for (int i = 0; i < NUM_TURRETS; i++) {
        
        // Create, scale, and position turret
        SKSpriteNode *turret = [SKSpriteNode spriteNodeWithImageNamed:TURRET_IMAGE_NAME];
        turret.xScale = self.frame.size.width / turret.size.width / NUM_TURRETS;
        turret.yScale = self.frame.size.width / turret.size.height / NUM_TURRETS;
        CGFloat turretXPosition = self.frame.size.width / (NUM_TURRETS * 2)
                                  + i * self.frame.size.width / NUM_TURRETS;
        CGFloat turretYPosition = self.frame.size.height * TURRET_Y_POSITION_FACTOR
                                  + turret.size.height / 2;
        turret.position = CGPointMake(turretXPosition, turretYPosition);
        
        // Set up physics body of turret - only necessary to fix layer bug in iOS 7.1
        turret.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:turret.size];
        turret.physicsBody.dynamic = NO;
        turret.physicsBody.categoryBitMask = TURRET_CATEGORY;
        
        // Add turret
        [self.turrets addObject:turret];
        [self addChild:turret];
    }
}

- (void)createPID {
    
    // Create, scale, and position turret
    SKSpriteNode *pid = [SKSpriteNode spriteNodeWithImageNamed:PID_IMAGE_NAME];
    pid.xScale = PID_WIDTH_FACTOR * self.frame.size.width / pid.size.width;
    pid.yScale = PID_HEIGHT_FACTOR * self.frame.size.height / pid.size.height;
    pid.position = CGPointMake(self.frame.size.width/2, pid.size.height);
    
    // Set up physics body of PID
    pid.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pid.size];
    pid.physicsBody.dynamic = YES;
    pid.physicsBody.categoryBitMask = PID_CATEGORY;
    pid.physicsBody.contactTestBitMask = GOOD_MONSTER_CATEGORY | BAD_MONSTER_CATEGORY;
    pid.physicsBody.collisionBitMask = 0;
    
    // Add PID
    [self addChild:pid];
}

- (void)createMonster {
    
    // Create sprite
    int monsterID = arc4random() % NUM_MONSTER_IMAGE_NAMES;
    NSString *monsterType = MONSTER_IMAGE_NAMES[monsterID];
    SKSpriteNode *monster = [SKSpriteNode spriteNodeWithImageNamed:monsterType];
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
    int minDuration = 5.0;
    int maxDuration = 6.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Set up physics body of monster
    monster.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:monster.size];
    monster.physicsBody.dynamic = YES;
    // Placeholder logic for good or bad monster category
    if ([self.scenario monsterIsOk:monsterType])
        monster.physicsBody.categoryBitMask = GOOD_MONSTER_CATEGORY;
    else
        monster.physicsBody.categoryBitMask = BAD_MONSTER_CATEGORY;
    monster.physicsBody.contactTestBitMask = BULLET_CATEGORY;
    monster.physicsBody.collisionBitMask = 0;
    
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
    CGFloat bulletX = turretTouched.position.x;
    CGFloat bulletY = turretTouched.position.y + ((SKSpriteNode *) self.turrets[0]).size.height / 2
        + bullet.size.height / 2;
    bullet.position = CGPointMake(bulletX, bulletY);
    
    // Bail out if you did not touch a turret
    if (location.y > turretTouched.position.y + turretTouched.size.height) return;
    
    // Add bullet to screen once location is verified
    [self addChild:bullet];
    
    // Give bullet a destination
    CGPoint destination = CGPointMake(turretTouched.position.x,
                                      self.frame.size.height + bullet.size.height / 2);
    
    // Set up physics body of bullet
    bullet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bullet.size];
    bullet.physicsBody.dynamic = YES;
    bullet.physicsBody.categoryBitMask = BULLET_CATEGORY;
    bullet.physicsBody.contactTestBitMask = GOOD_MONSTER_CATEGORY | BAD_MONSTER_CATEGORY;
    bullet.physicsBody.collisionBitMask = 0;
    bullet.physicsBody.usesPreciseCollisionDetection = YES;
    
    // Create the actions
    float duration = 1.0;
    SKAction *actionMove = [SKAction moveTo:destination duration:duration];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    [bullet runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
    // Play a sound
    [[PDAudioManager sharedInstance] playLaserShoot];
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    
    SKPhysicsBody *firstBody, *secondBody;
    
    // Make firstBody and secondBody be deterministic
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // Bullet-monster interaction
    if ((secondBody.categoryBitMask & BULLET_CATEGORY) != 0) {
        if ((firstBody.categoryBitMask & GOOD_MONSTER_CATEGORY) != 0) {
            self.lives--;
            [[PDAudioManager sharedInstance] playSortIncorrect];
        } else {
            [[PDAudioManager sharedInstance] playSortCorrect];
        }
        [firstBody.node removeFromParent];
        [secondBody.node removeFromParent];
    }
    // PID-monster interaction
    if ((secondBody.categoryBitMask & PID_CATEGORY) != 0) {
        if ((firstBody.categoryBitMask & BAD_MONSTER_CATEGORY) != 0) {
            self.lives--;
            [[PDAudioManager sharedInstance] playSortIncorrect];
        } else {
            [[PDAudioManager sharedInstance] playSortCorrect];
        }
        [firstBody.node removeFromParent];
    }
    
}

- (void)startGame {
    self.lives = MAX_NUM_LIVES;
    self.numMonsters = 0;
    self.lastMonsterRelease = 0;
    self.hasGameStartBeenRecorded = NO;
    self.hasGameStarted = YES;
}

- (void)endGame {
    BOOL isSuccess = NO;
    if (self.lives > 0) {
        isSuccess = YES;
    }
    [self.endDelegate miniGameEndWithSuccess:isSuccess];
}

@end
