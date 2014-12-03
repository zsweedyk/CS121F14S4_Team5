//
//  PDBounceAndSortScene.m
//  PipeDream
//
//  Created by Kate Aplin on 11/16/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDBounceAndSortScene.h"
#import "PDAudioManager.h"

@interface PDBounceAndSortScene()

@property (nonatomic) int score;
@property (nonatomic) int numBalls;
@property (nonatomic) CFTimeInterval lastBallRelease;
@property (nonatomic) BOOL hasGameStartBeenRecorded;
@property (nonatomic) CFTimeInterval gameStartTime;
@property (nonatomic, strong) UILabel* timerLabel;
@property (nonatomic, strong) UILabel* scoreLabel;
@property (nonatomic) BOOL hasGameStarted;

@end

@implementation PDBounceAndSortScene

// Game parameters.
static const int MAX_NUM_BALLS = 3;
static const CFTimeInterval MIN_TIME_BETWEEN_BALL_RELEASES = 2.0;
static const CFTimeInterval TOTAL_GAME_LENGTH = 20;
static const int MIN_SUCCESSFUL_SCORE = 5;
static const int SUCCESSFUL_BUCKET_SCORE_INCREASE = 1;
static const int UNSUCCESSFUL_BUCKET_SCORE_DECREASE = -2;

// Sprite image names.
static NSString* GOOD_BALL_SPRITE_IMAGE_NAMES[] = {@"bounceLock", @"bounceSSL",
                                                   @"bounceFirewall", @"bounceClose",
                                                   @"bounceHTTPS"};
static const int NUM_GOOD_BALL_SPRITE_IMAGE_NAMES = 5;
static NSString* BAD_BALL_SPRITE_IMAGE_NAMES[] = {@"bounceClickHere", @"bounceDownloadNow",
                                                  @"bounceFreeSmileys", @"bounceWorm",
                                                  @"bounceTrojan"};
static const int NUM_BAD_BALL_SPRITE_IMAGE_NAMES = 5;
static NSString* GOOD_BLOCK_SPRITE_IMAGE_NAME = @"goodBucket";
static NSString* BAD_BLOCK_SPRITE_IMAGE_NAME = @"badBucket";
static NSString* BAR_SPRITE_IMAGE_NAME = @"bar";

// Collision categories.
static const uint32_t GOOD_BALL_CATEGORY  = 0x1 << 0;
static const uint32_t BAD_BALL_CATEGORY = 0x1 << 1;
static const uint32_t GOOD_BLOCK_CATEGORY = 0x1 << 2;
static const uint32_t BAD_BLOCK_CATEGORY = 0x1 << 3;

// Slider parameters.
static const int MIN_SLIDER_VALUE = 0;
static const int MAX_SLIDER_VALUE = 100;
static const int DEFAULT_SLIDER_VALUE = (MAX_SLIDER_VALUE - MIN_SLIDER_VALUE) / 2;

// Physics parameters.
static const float Y_GRAVITY = -5.0f;
static const float X_GRAVITY = 0.0f;
static const float BALL_RESTITUTION = 0.7f;
static const float BAR_RESTITUTION = 0.1f;
static const float BLOCK_FRICTION = 0.0f;
static const float BALL_FRICTION = 0.0f;
static const float BAR_FRICTION = 0.3f;
static const float EDGE_FRICTION = 0.0f;
static const float BALL_LINEAR_DAMPING = 0.5f;
static const float BALL_ANGULAR_DAMPING = 0.0f;

// Layout parameters.
// Bad bucket.
static const float BAD_BUCKET_ROTATE = M_PI / 4.0;
static const float BAD_BUCKET_X_SCALE = 0.65;
static const float BAD_BUCKET_Y_SCALE = 0.65;
static const float BAD_BUCKET_X_POSITION_FACTOR = 0;
static const float BAD_BUCKET_Y_POSITION_FACTOR = 0;
// Good bucket.
static const float GOOD_BUCKET_ROTATE = -1.0 * M_PI / 4.0;
static const float GOOD_BUCKET_X_SCALE = 0.65;
static const float GOOD_BUCKET_Y_SCALE = 0.65;
static const float GOOD_BUCKET_X_POSITION_FACTOR = 0;
static const float GOOD_BUCKET_Y_POSITION_FACTOR = 0;
// Bar.
static const float BAR_X_SCALE = 0.6;
static const float BAR_Y_SCALE = 0.3;
static const float MAX_BAR_ROTATE = M_PI / 2.0;
static const float BAR_Y_POSITION_FACTOR = 1.0 / 5.0;
// Ball.
static const float BALL_X_SCALE = 0.25;
static const float BALL_Y_SCALE = 0.25;
// Slider.
static const float SLIDER_WIDTH_FACTOR = 0.4;
static const float SLIDER_Y_POSITION_FACTOR = 0.85;
static const float SLIDER_HEIGHT_FACTOR = 0.1;
// General label.
static NSString *LABEL_FONT_NAME = @"Heiti SC";
static const int LABEL_FONT_SIZE = 40;
// Score label.
static const float SCORE_LABEL_X_POSITION_FACTOR = 0.55;
static const float SCORE_LABEL_Y_POSITION_FACTOR = 0.05;
static const float SCORE_LABEL_WIDTH_FACTOR = 0.5;
static const float SCORE_LABEL_HEIGHT_FACTOR = 0.1;
static NSString *SCORE_LABEL_FORMAT_STRING = @"Score: %d";
// Timer label.
static const float TIMER_LABEL_X_POSITION_FACTOR = 0.1;
static const float TIMER_LABEL_Y_POSITION_FACTOR = 0.05;
static const float TIMER_LABEL_WIDTH_FACTOR = 0.5;
static const float TIMER_LABEL_HEIGHT_FACTOR = 0.1;
static NSString *TIMER_LABEL_FORMAT_STRING = @"Time: %d";
// Background.
static const float RED_BACKGROUND = 0.5;
static const float GREEN_BACKGROUND = 0.5;
static const float BLUE_BACKGROUND = 0.5;
static const float ALPHA_BACKGROUND = 1.0;

static NSString *BAR_CATEGORY_NAME = @"bar";

#pragma public methods

- (void)startGame {
    self.hasGameStarted = YES;
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:RED_BACKGROUND green:GREEN_BACKGROUND blue:BLUE_BACKGROUND alpha:ALPHA_BACKGROUND];
        [self createBuckets];
        [self createBar];
        [self createEdges];
        [self initializeGame];
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(X_GRAVITY, Y_GRAVITY);
    }
    return self;
}

/*
 * Called automatically while initializing the scene. Until this is called, no views exist.
 */
- (void) didMoveToView:(SKView *)view
{
    UIColor *LABEL_COLOR = [UIColor whiteColor];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:
        CGRectMake(CGRectGetMidX(self.frame) - self.frame.size.width * SLIDER_WIDTH_FACTOR / 2,
        self.frame.size.height * SLIDER_Y_POSITION_FACTOR,
        self.frame.size.width * SLIDER_WIDTH_FACTOR,
        self.frame.size.height * SLIDER_HEIGHT_FACTOR)];
    slider.minimumValue = MIN_SLIDER_VALUE;
    slider.maximumValue = MAX_SLIDER_VALUE;
    slider.value = DEFAULT_SLIDER_VALUE;
    [slider addTarget:self action:@selector(sliderMoved:)
     forControlEvents:UIControlEventTouchDragInside];
    [slider addTarget:self action:@selector(sliderMoved:)
     forControlEvents:UIControlEventTouchDragOutside];
    [view addSubview:slider];
    
    self.timerLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(self.frame.size.width * TIMER_LABEL_X_POSITION_FACTOR,
        self.frame.size.height * TIMER_LABEL_Y_POSITION_FACTOR,
        self.frame.size.width * TIMER_LABEL_WIDTH_FACTOR,
        self.frame.size.height * TIMER_LABEL_HEIGHT_FACTOR)];
    self.timerLabel.font = [UIFont fontWithName:LABEL_FONT_NAME size:LABEL_FONT_SIZE];
    self.timerLabel.textColor = LABEL_COLOR;
    [view addSubview:self.timerLabel];
    
    self.scoreLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(self.frame.size.width * SCORE_LABEL_X_POSITION_FACTOR,
        self.frame.size.height * SCORE_LABEL_Y_POSITION_FACTOR,
        self.frame.size.width * SCORE_LABEL_WIDTH_FACTOR,
        self.frame.size.height * SCORE_LABEL_HEIGHT_FACTOR)];
    self.scoreLabel.font = [UIFont fontWithName:LABEL_FONT_NAME size:LABEL_FONT_SIZE];
    self.scoreLabel.textColor = LABEL_COLOR;
    [view addSubview:self.scoreLabel];
    
}

/*
 * Called automatically when two physics bodies within the scene collide.
 */
-(void)didBeginContact:(SKPhysicsContact*)contact
{
    // Create local variables for the two physics bodies in contact.
    SKPhysicsBody* firstBody;
    SKPhysicsBody* secondBody;
    // Assign the two physics bodies so that the one with the lower category is always stored in
    // firstBody.
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // Only handle collisions between a ball and a bucket.
    if ((firstBody.categoryBitMask == GOOD_BALL_CATEGORY ||
         firstBody.categoryBitMask == BAD_BALL_CATEGORY) &&
        (secondBody.categoryBitMask == GOOD_BLOCK_CATEGORY ||
         secondBody.categoryBitMask == BAD_BLOCK_CATEGORY)) {
            BOOL matchesBlock = NO;
            
            if (firstBody.categoryBitMask == GOOD_BALL_CATEGORY) {
                if (secondBody.categoryBitMask == GOOD_BLOCK_CATEGORY) {
                    matchesBlock = YES;
                }
            } else {
                if (secondBody.categoryBitMask == BAD_BLOCK_CATEGORY) {
                    matchesBlock = YES;
                }
            }
            
            if (matchesBlock) {
                [[PDAudioManager sharedInstance] playSortCorrect];
                self.score += SUCCESSFUL_BUCKET_SCORE_INCREASE;
            } else {
                [[PDAudioManager sharedInstance] playSortIncorrect];
                self.score += UNSUCCESSFUL_BUCKET_SCORE_DECREASE;
            }
            
            [firstBody.node removeFromParent];
            self.numBalls -= 1;
        }
}

/*
 * Called automatically before each frame is rendered.
 */
-(void)update:(CFTimeInterval)currentTime
{
    if (!self.hasGameStarted) {
        return;
    }
    
    if (self.numBalls < MAX_NUM_BALLS && (currentTime - self.lastBallRelease) >= MIN_TIME_BETWEEN_BALL_RELEASES) {
        [self createBall];
        self.lastBallRelease = currentTime;
    }
    
    if (!self.hasGameStartBeenRecorded) {
        self.hasGameStartBeenRecorded = YES;
        self.gameStartTime = currentTime;
    }
    
    if (currentTime - self.gameStartTime > TOTAL_GAME_LENGTH) {
        [self endGame];
    }
    
    self.timerLabel.text = [NSString stringWithFormat:TIMER_LABEL_FORMAT_STRING,
        (int) ceil(TOTAL_GAME_LENGTH - (currentTime - self.gameStartTime))];
    self.scoreLabel.text = [NSString stringWithFormat:SCORE_LABEL_FORMAT_STRING, self.score];
}

#pragma private methods

- (void)createBuckets
{
    [self createGoodBucket];
    [self createBadBucket];
}

- (void)createGoodBucket
{
    SKSpriteNode* gblock = [SKSpriteNode spriteNodeWithImageNamed:GOOD_BLOCK_SPRITE_IMAGE_NAME];
    gblock.position = CGPointMake(gblock.frame.size.width * GOOD_BUCKET_X_POSITION_FACTOR,
    self.frame.size.height * GOOD_BUCKET_Y_POSITION_FACTOR);
    gblock.zRotation = GOOD_BUCKET_ROTATE;
    
    gblock.physicsBody = [self createBlockBody:gblock.frame.size];
    gblock.physicsBody.categoryBitMask = GOOD_BLOCK_CATEGORY;
    
    gblock.xScale = GOOD_BUCKET_X_SCALE;
    gblock.yScale = GOOD_BUCKET_Y_SCALE;
    
    [self addChild:gblock];
}

- (void)createBadBucket
{
    SKSpriteNode* bblock = [SKSpriteNode spriteNodeWithImageNamed:BAD_BLOCK_SPRITE_IMAGE_NAME];
    bblock.position = CGPointMake(self.frame.size.width +
        bblock.frame.size.width * BAD_BUCKET_X_POSITION_FACTOR,
        self.frame.size.height * BAD_BUCKET_Y_POSITION_FACTOR);
    bblock.zRotation = BAD_BUCKET_ROTATE;
    
    bblock.physicsBody = [self createBlockBody:bblock.frame.size];
    bblock.physicsBody.categoryBitMask = BAD_BLOCK_CATEGORY;
    
    bblock.xScale = BAD_BUCKET_X_SCALE;
    bblock.yScale = BAD_BUCKET_Y_SCALE;
    
    [self addChild:bblock];
}

- (SKPhysicsBody *)createBlockBody:(CGSize)size
{
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:size];
    body.allowsRotation = NO;
    body.friction = BLOCK_FRICTION;
    body.dynamic = NO;
    return body;
}

- (void)createBar
{
    SKSpriteNode* bar = [[SKSpriteNode alloc] initWithImageNamed:BAR_SPRITE_IMAGE_NAME];
    bar.position = CGPointMake(CGRectGetMidX(self.frame),
        self.frame.size.height * BAR_Y_POSITION_FACTOR);
    bar.physicsBody = [self createBarBody:bar.frame.size];
    bar.name = BAR_CATEGORY_NAME;
    bar.xScale = BAR_X_SCALE;
    bar.yScale = BAR_Y_SCALE;
    [self addChild:bar];
}

- (SKPhysicsBody *)createBarBody:(CGSize)size
{
    SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    physicsBody.restitution = BAR_RESTITUTION;
    physicsBody.friction = BAR_FRICTION;
    physicsBody.dynamic = NO;
    return physicsBody;
}

- (void)createBall
{
    // Determine whether the ball is good or bad randomly.
    int goodOrBad = arc4random() % 2;
    SKNode *ball = [self createGoodBall];
    uint32_t categoryBitMask = GOOD_BALL_CATEGORY;
    
    if (goodOrBad == 1) {
        ball = [self createBadBall];
        categoryBitMask = BAD_BALL_CATEGORY;
    }
    
    [ball setPosition:CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height)];
    ball.physicsBody = [self createBallBody:ball.frame.size.width / 2];
    ball.physicsBody.categoryBitMask = categoryBitMask;
    
    ball.xScale = BALL_X_SCALE;
    ball.yScale = BALL_Y_SCALE;
    
    [self addChild:ball];
    self.numBalls += 1;
}

/*
 * INPUT: The radius of a ball.
 * Creates a physics body for a ball, given a radius. Sets properties that are common to all balls.
 */
- (SKPhysicsBody *)createBallBody:(CGFloat)radius
{
    SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:radius];
    physicsBody.dynamic = YES;
    physicsBody.allowsRotation = YES;
    physicsBody.restitution = BALL_RESTITUTION;
    physicsBody.friction = BALL_FRICTION;
    physicsBody.angularDamping = BALL_ANGULAR_DAMPING;
    physicsBody.linearDamping = BALL_LINEAR_DAMPING;
    physicsBody.contactTestBitMask = GOOD_BLOCK_CATEGORY | BAD_BLOCK_CATEGORY;
    return physicsBody;
}

- (SKNode *)createGoodBall
{
    // Choose a random good sprite.
    int index = arc4random() % NUM_GOOD_BALL_SPRITE_IMAGE_NAMES;
    NSString *spriteName = GOOD_BALL_SPRITE_IMAGE_NAMES[index];
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:spriteName];
    ball.physicsBody.categoryBitMask = GOOD_BALL_CATEGORY;
    return ball;
}

- (SKNode *)createBadBall
{
    // Choose a random bad sprite.
    int index = arc4random() % NUM_BAD_BALL_SPRITE_IMAGE_NAMES;
    NSString *spriteName = BAD_BALL_SPRITE_IMAGE_NAMES[index];
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:spriteName];
    ball.physicsBody.categoryBitMask = BAD_BALL_CATEGORY;
    return ball;
}

/*
 * Creates a physics body to border the scene, so that balls remain contained within the screen.
 */
- (void)createEdges
{
    SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody = borderBody;
    self.physicsBody.friction = EDGE_FRICTION;
}

/*
 * Called whenever the slider has moved. Calculates the rotation of the bar.
 */
- (void)sliderMoved:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    float value = slider.value;
    
    SKSpriteNode *bar = (SKSpriteNode*)[self childNodeWithName: BAR_CATEGORY_NAME];
    
    bar.zRotation = -1.0 * (value - DEFAULT_SLIDER_VALUE) * MAX_BAR_ROTATE
    / 100.0;
}

/*
 * Initializes in-game variables.
 */
- (void)initializeGame
{
    self.score = 0;
    self.numBalls = 0;
    self.lastBallRelease = 0;
    self.hasGameStartBeenRecorded = NO;
}

- (void)endGame
{
    BOOL isSuccess = NO;
    if (self.score >= MIN_SUCCESSFUL_SCORE) {
        isSuccess = YES;
    }
    [self.endDelegate miniGameEndWithSuccess:isSuccess];
}

@end

