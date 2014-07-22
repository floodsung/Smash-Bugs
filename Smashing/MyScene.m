//
//  MyScene.m
//  Smashing
//
//  Created by FloodSurge on 7/21/14.
//  Copyright (c) 2014 FloodSurge. All rights reserved.
//

#import "MyScene.h"
#import "Bug.h"
#import "AchievementsHelper.h"
#import "GameKitHelper.h"


@implementation MyScene
{
    int score;
    int ballCount;
    int continueSmashCount;
    float speed;
    int touchCount;
    BOOL isLose;
    SKLabelNode *scoreLabel;
    SKLabelNode *ballLabel;
    SKLabelNode *gameOverLabel;
    SKLabelNode *scoreBoardScoreLabel;
    SKLabelNode *scoreBoardHighestScoreLabel;
    
    
    SKAction *stabSound;
    SKAction *clangSound;
    SKAction *hitGroundSound;
    SKAction *gameOverSound;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        [self initConfiguration];
        [self addGround];
        [self addLabels];
        [self spawnBugs];
        
        //[self runAction:[SKAction repeatActionForever:[SKAction playSoundFileNamed:@"MCLIP07.WAV" waitForCompletion:YES]]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restart) name:@"restartNotification" object:nil];
       
    }
    return self;
}

- (void)restart
{
    NSLog(@"restart");
    gameOverLabel.hidden = YES;
    scoreBoardHighestScoreLabel.hidden = YES;
    scoreBoardScoreLabel.hidden = YES;
    
    [self enumerateChildNodesWithName:@"ball" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    isLose = NO;
    score = 0;
    ballCount = 10;
    continueSmashCount = 0;
    speed = 0.0;
    touchCount = 0;
}

- (void)initConfiguration
{
    score = 0;
    ballCount = 10;
    continueSmashCount = 0;
    speed = 0.0;
    touchCount = 0;
    isLose = NO;
    self.backgroundColor = [SKColor whiteColor];
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0, -5);
    
    stabSound = [SKAction playSoundFileNamed:@"DRIP.WAV" waitForCompletion:NO];
    clangSound = [SKAction playSoundFileNamed:@"snare02.wav" waitForCompletion:NO];
    hitGroundSound = [SKAction playSoundFileNamed:@"606chat.wav" waitForCompletion:NO];
    gameOverSound = [SKAction playSoundFileNamed:@"CRYSTAL5.WAV" waitForCompletion:NO];
    
    gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Thin"];
    gameOverLabel.text = @"Game Over";
    gameOverLabel.fontSize = 30;
    gameOverLabel.zPosition = 2;
    gameOverLabel.fontColor = [SKColor blackColor];
    gameOverLabel.position = CGPointMake(self.size.width / 2 , self.size.height / 2 + 90);
    
    [self addChild:gameOverLabel];
    gameOverLabel.hidden = YES;
    
    
    scoreBoardScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
    scoreBoardScoreLabel.text = [NSString stringWithFormat:@"Score: %d",score];
    scoreBoardScoreLabel.position = CGPointMake(self.size.width/2, self.size.height/2 + 30);
    scoreBoardScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    
    scoreBoardScoreLabel.fontSize = 20;
    scoreBoardScoreLabel.zPosition = 2;
    scoreBoardScoreLabel.fontColor = [SKColor blackColor];
    [self addChild:scoreBoardScoreLabel];
    scoreBoardScoreLabel.hidden = YES;
    
    scoreBoardHighestScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
    scoreBoardHighestScoreLabel.text = [NSString stringWithFormat:@"Highest Score: %d",score];
    scoreBoardHighestScoreLabel.position = CGPointMake(self.size.width/2, self.size.height/2 + 60);
    scoreBoardHighestScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    
    scoreBoardHighestScoreLabel.fontSize = 20;
    scoreBoardHighestScoreLabel.zPosition = 2;
    scoreBoardHighestScoreLabel.fontColor = [SKColor blackColor];
    [self addChild:scoreBoardHighestScoreLabel];
    scoreBoardHighestScoreLabel.hidden = YES;
}

-(void)touchesBegan:(NSSet *)touches
          withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        touchCount++;
        if (touchCount%5 == 0) {
            speed += 0.1;
        }
        
        if (ballCount > 0) {
            ballCount--;
            
            SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
            ball.name = @"ball";
            ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:15];
            ball.physicsBody.restitution = 0.8;
            ball.physicsBody.friction = 0.1;
            ball.physicsBody.density = 2;
            ball.position = CGPointMake(location.x, self.size.height - 30);
            ball.physicsBody.categoryBitMask = CNPhysicsCategoryBall;
            ball.physicsBody.collisionBitMask = CNPhysicsCategoryGround | CNPhysicsCategoryBug | CNPhysicsCategoryBall;
            ball.physicsBody.contactTestBitMask = CNPhysicsCategoryBug | CNPhysicsCategoryGround;
            
            SKAction *wait = [SKAction waitForDuration:3.5];
            SKAction *fade = [SKAction fadeOutWithDuration:0.5];
            SKAction *check = [SKAction runBlock:^{
                if (ballCount == 0) {
                    [self lose];
                }
            }];
            SKAction *remove = [SKAction removeFromParent];
            
            if (ballCount == 0) {
                [ball runAction:[SKAction sequence:@[wait,fade,check,remove]]];
            } else {
                [ball runAction:[SKAction sequence:@[wait,fade,remove]]];
            }
            
            
            
            [self runAction:stabSound];
            
            [self addChild:ball];

        }
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    ballLabel.text = [NSString stringWithFormat:@"%d",ballCount];
    scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    
}

- (void)lose
{
    NSLog(@"You lose!");
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *highestScore = [defaults objectForKey:@"HighestScore"];
    
    if (score > highestScore.intValue) {
        NSLog(@"New High Score!");
        [self runAction:gameOverSound];
        [defaults setObject:[NSNumber numberWithInt:score] forKey:@"HighestScore"];
        
        SKLabelNode *newHighScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Thin"];
        newHighScoreLabel.position = CGPointMake(self.size.width/2, self.size.height - 100);
        newHighScoreLabel.fontSize = 20;
        newHighScoreLabel.fontColor = [SKColor blackColor];
        newHighScoreLabel.text = [NSString stringWithFormat:@"New High Score:%d",score];
        newHighScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        
        [newHighScoreLabel runAction:[SKAction sequence:@[
                                                          [SKAction scaleTo:1.5 duration:0.5],[SKAction fadeOutWithDuration:0.5],[SKAction removeFromParent]]]
         completion:^{
             gameOverLabel.hidden = NO;
             isLose = YES;
             scoreBoardHighestScoreLabel.text = [NSString stringWithFormat:@"Highest Score: %d",score];
             scoreBoardScoreLabel.text = [NSString stringWithFormat:@"Score: %d",score];
             scoreBoardScoreLabel.hidden = NO;
             scoreBoardHighestScoreLabel.hidden = NO;
             [self reportScoreToGameCenter];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"gameOverNotification" object:nil];
         }];
        [self addChild:newHighScoreLabel];
    } else {
        gameOverLabel.hidden = NO;
        isLose = YES;
        [self reportScoreToGameCenter];
        scoreBoardHighestScoreLabel.text = [NSString stringWithFormat:@"Highest Score: %d",highestScore.intValue];
        scoreBoardScoreLabel.text = [NSString stringWithFormat:@"Score: %d",score];
        scoreBoardScoreLabel.hidden = NO;
        scoreBoardHighestScoreLabel.hidden = NO;

        [self runAction:gameOverSound completion:^{
             [[NSNotificationCenter defaultCenter] postNotificationName:@"gameOverNotification" object:nil];
        }];
       
    }
    
    
}

- (void)addLabels
{
    SKLabelNode *scoreLabelName = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
    scoreLabelName.position = CGPointMake(50, self.size.height - 40);
    scoreLabelName.zPosition = 10;
    scoreLabelName.fontSize = 20;
    scoreLabelName.fontColor = [UIColor blackColor];
    scoreLabelName.text = @"Score";
    [self addChild:scoreLabelName];
    
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
    
    scoreLabel.position = CGPointMake(50, self.size.height - 65);
    scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    scoreLabel.fontSize = 20;
    scoreLabel.zPosition = 10;
    scoreLabel.fontColor = [UIColor blackColor];
    [self addChild:scoreLabel];
    
    SKLabelNode *ballLabelName = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
    ballLabelName.position = CGPointMake(self.size.width - 50, self.size.height - 40);
    ballLabelName.zPosition = 10;
    ballLabelName.fontSize = 20;
    ballLabelName.fontColor = [UIColor blackColor];
    ballLabelName.text = @"Balls";
    [self addChild:ballLabelName];
    
    ballLabel = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
    
    ballLabel.position = CGPointMake(self.size.width - 50, self.size.height - 65);
    ballLabel.text = [NSString stringWithFormat:@"%d",ballCount];
    ballLabel.fontSize = 20;
    ballLabel.zPosition = 10;
    ballLabel.fontColor = [UIColor blackColor];
    [self addChild:ballLabel];
    
}

- (void)addGround
{
    SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
    ground.position = CGPointMake(self.size.width/2, 25);
    ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.size];
    ground.physicsBody.dynamic = false;
    ground.physicsBody.categoryBitMask = CNPhysicsCategoryGround;
    ground.physicsBody.collisionBitMask = CNPhysicsCategoryBall | CNPhysicsCategoryBug;
    ground.physicsBody.contactTestBitMask = CNPhysicsCategoryBall;
    [self addChild:ground];
}

- (void)spawnBugs
{
    SKAction *spawnABug = [SKAction runBlock:^{
        
        Bug *bug = [[Bug alloc] initWithImageNamed:@"bug"];
        bug.position = CGPointMake(-20,ScalarRandomRange(self.size.height/6, self.size.height/4*3) );
        bug.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:15];
        bug.physicsBody.dynamic = false;
        bug.physicsBody.categoryBitMask = CNPhysicsCategoryBug;
        bug.physicsBody.contactTestBitMask = CNPhysicsCategoryBall;
        bug.physicsBody.collisionBitMask = CNPhysicsCategoryBall | CNPhysicsCategoryGround;
        
        
        
        SKAction *move = [SKAction moveByX:self.size.width+30 y:0 duration:ScalarRandomRange(2.5 - speed, 4.5 - speed)];

        SKAction *remove = [SKAction removeFromParent];
        
        [bug runAction:[SKAction sequence:@[move,remove]]];
         
        
        [self addChild:bug];
        
    }];
    
    SKAction *wait = [SKAction waitForDuration:ScalarRandomRange(1, 2)];
    
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[spawnABug,wait]]]];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    uint32_t collision = (contact.bodyA.categoryBitMask |
                          contact.bodyB.categoryBitMask);
    
    if (collision == (CNPhysicsCategoryBall | CNPhysicsCategoryBug)) {
        [self runAction:clangSound];
        Bug *bug;
        if (contact.bodyA.categoryBitMask == CNPhysicsCategoryBug){
            bug = (Bug *)contact.bodyA.node;
        } else {
            bug = (Bug *)contact.bodyB.node;
        }
        
        bug.physicsBody.dynamic = YES;
        if (!bug.isDead) {
            score++;
            [self reportAchievements];
            continueSmashCount++;
            ballCount += (int)continueSmashCount/2 ;
            bug.isDead = YES;
            
        }
    } else if (collision == (CNPhysicsCategoryBall | CNPhysicsCategoryGround))
    {
        [self runAction:hitGroundSound];
        continueSmashCount = 0;
    }
}

#pragma mark - Game kit

- (void)reportAchievements
{
    NSMutableArray *achievements = [NSMutableArray arrayWithObjects:[AchievementsHelper reach10Achievement:score],[AchievementsHelper reach30Achievement:score],[AchievementsHelper reach50Achievement:score],[AchievementsHelper reach100Achievement:score],[AchievementsHelper reach500Achievement:score], nil];
    
    [[GameKitHelper sharedGameKitHelper] reportAchievements:achievements];
}

- (void)reportScoreToGameCenter
{
    [[GameKitHelper sharedGameKitHelper] reportScore:score forLeaderboardID:@"HighestScore"];
    
}

@end
