//
//  PDBounceAndSortScene.m
//  PipeDream
//
//  Created by cs121F14 on 11/16/14.
//  Copyright (c) 2014 Flapjack Stack Hack. All rights reserved.
//

#import "PDBounceAndSortScene.h"

@interface PDBounceAndSortScene()

@property (nonatomic) int score;
@property (nonatomic) int misses;
@property (nonatomic) int numBalls;
@property (nonatomic) CFTimeInterval lastBallRelease;
@property (nonatomic) BOOL hasGameStartBeenRecorded;
@property (nonatomic) CFTimeInterval gameStartTime;
@property (nonatomic, strong) UILabel* timerLabel;
@property (nonatomic, strong) UILabel* scoreLabel;

@end

@implementation PDBounceAndSortScene

// Game parameters.
static const int MAX_NUM_BALLS = 3;
static const CFTimeInterval MIN_TIME_BETWEEN_BALL_RELEASES = 2.0;
static const CFTimeInterval TOTAL_GAME_LENGTH = 45.0;
static const int MIN_SUCCESSFUL_SCORE = 1;

// Sprite image names.
static NSString* GOOD_BALL_SPRITE_IMAGE_NAMES[] = {@"NESW"};
static const int NUM_GOOD_BALL_SPRITE_IMAGE_NAMES = 1;
static NSString* BAD_BALL_SPRITE_IMAGE_NAMES[] = {@"NESWi"};
static const int NUM_BAD_BALL_SPRITE_IMAGE_NAMES = 1;
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
static const float BALL_RESTITUTION = 0.9f;
static const float BAR_RESTITUTION = 0.1f;
static const float BLOCK_FRICTION = 0.0f;
static const float BALL_FRICTION = 0.0f;
static const float BAR_FRICTION = 0.4f;
static const float EDGE_FRICTION = 0.0f;
static const float BALL_LINEAR_DAMPING = 0.5f;
static const float BALL_ANGULAR_DAMPING = 0.0f;

// Layout parameters.
static const float BAD_BUCKET_ROTATE = M_PI / 4.0;
static const float GOOD_BUCKET_ROTATE = -1.0 * M_PI / 4.0;
static const float GOOD_BUCKET_X_SCALE = 0.75;
static const float GOOD_BUCKET_Y_SCALE = 0.75;
static const float BAD_BUCKET_X_SCALE = 0.75;
static const float BAD_BUCKET_Y_SCALE = 0.75;
static const float BAR_X_SCALE = 0.8;
static const float BAR_Y_SCLAE = 0.4;
static const float BALL_X_SCALE = 0.25;
static const float BALL_Y_SCALE = 0.25;
static const float MAX_BAR_ROTATE = M_PI / 2.0;

static NSString *BAR_CATEGORY_NAME = @"bar";

#pragma public methods

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
        [self createBuckets];
        [self createBar];
        [self createEdges];
        [self startGame];
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
    UISlider *slider = [[UISlider alloc] initWithFrame:
        CGRectMake(CGRectGetMidX(self.frame) - self.frame.size.width/ 4.0 ,
        self.frame.size.height * 0.9f, self.frame.size.width / 2.0, self.frame.size.height / 10.0)];
    slider.minimumValue = MIN_SLIDER_VALUE;
    slider.maximumValue = MAX_SLIDER_VALUE;
    slider.value = DEFAULT_SLIDER_VALUE;
    [slider addTarget:self action:@selector(sliderMoved:)
     forControlEvents:UIControlEventTouchDragInside];
    [slider addTarget:self action:@selector(sliderMoved:)
     forControlEvents:UIControlEventTouchDragOutside];
    [view addSubview:slider];
    
    self.timerLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(0, 0, self.frame.size.width / 2, self.frame.size.width / 10.0)];
    self.timerLabel.font = [UIFont fontWithName:@"Arial" size:40];
    [view addSubview:self.timerLabel];
    self.scoreLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(self.frame.size.width / 2, 0, self.frame.size.width / 2,
        self.frame.size.width / 10)];
    self.scoreLabel.font = [UIFont fontWithName:@"Arial" size:40];
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
                self.score += 1;
            } else {
                self.misses += 1;
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
    
    self.timerLabel.text = [NSString stringWithFormat:@"Time Left: %d",(int) (TOTAL_GAME_LENGTH - (currentTime - self.gameStartTime))];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.score];
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
    gblock.position = CGPointMake(- 1 * gblock.frame.size.width / 8, self.frame.size.height * 0);
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
    bblock.position = CGPointMake(self.frame.size.width + bblock.frame.size.width / 8,
                                  self.frame.size.height * 0);
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
    bar.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height * 0.2);
    bar.physicsBody = [self createBarBody:bar.frame.size];
    bar.name = BAR_CATEGORY_NAME;
    bar.xScale = BAR_X_SCALE;
    bar.yScale = BAR_Y_SCLAE;
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
- (void)startGame
{
    self.score = 0;
    self.misses = 0;
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

