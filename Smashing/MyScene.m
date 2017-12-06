//
//  MyScene.m
//  Smashing
//
//  Created by FloodSurge on 7/21/14.
//  Copyright (c) 2014 FloodSurge. All rights reserved.
//

#import "MyScene.h"
#import "Bug.h"
#import "Ball.h"
#import "AchievementsHelper.h"
#import "GameKitHelper.h"
#import <AVFoundation/AVFoundation.h>



@implementation MyScene
{
    int score;
    int ballCount;
    float speed;
    int touchCount;
    BOOL isLose;
    int continueHitBugCount;

    SKLabelNode *scoreLabel;
    SKLabelNode *ballLabel;
    SKLabelNode *gameOverLabel;
    SKLabelNode *scoreBoardScoreLabel;
    SKLabelNode *scoreBoardHighestScoreLabel;
    
    
    SKAction *dropSound;
    SKAction *gameOverSound;
    
    SKAction *pno1Sound;
    SKAction *pno2Sound;
    SKAction *pno3Sound;
    SKAction *pno4Sound;
    SKAction *pno5Sound;
    SKAction *pno6Sound;
    SKAction *pno7Sound;
    SKAction *pno8Sound;


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
    continueHitBugCount = 0;
    ballCount = 10;
    speed = 0.0;
    touchCount = 0;
}

- (void)initConfiguration
{
    score = 0;
    ballCount = 10;
    speed = 0.0;
    touchCount = 0;
    isLose = NO;
    continueHitBugCount = 0;
    
    self.backgroundColor = [SKColor whiteColor];
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0, -5);
    
    dropSound = [SKAction playSoundFileNamed:@"drop.WAV" waitForCompletion:NO];
    gameOverSound = [SKAction playSoundFileNamed:@"lose.WAV" waitForCompletion:NO];
    
    
    
     pno1Sound = [SKAction playSoundFileNamed:@"pno_1.mp3" waitForCompletion:NO];
     pno2Sound = [SKAction playSoundFileNamed:@"pno_2.mp3" waitForCompletion:NO];
     pno3Sound = [SKAction playSoundFileNamed:@"pno_3.mp3" waitForCompletion:NO];
     pno4Sound = [SKAction playSoundFileNamed:@"pno_4.mp3" waitForCompletion:NO];
     pno5Sound = [SKAction playSoundFileNamed:@"pno_5.mp3" waitForCompletion:NO];
     pno6Sound = [SKAction playSoundFileNamed:@"pno_6.mp3" waitForCompletion:NO];
     pno7Sound = [SKAction playSoundFileNamed:@"pno_7.mp3" waitForCompletion:NO];
     pno8Sound = [SKAction playSoundFileNamed:@"pno_8.mp3" waitForCompletion:NO];
     

    /*
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pno_1" ofType:@"mp3"];
    
    AVAudioPlayer *pno1player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:path] error:nil];
    
    path = [[NSBundle mainBundle] pathForResource:@"pno_2" ofType:@"mp3"];
    
    AVAudioPlayer *pno2player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:path] error:nil];
    
    path = [[NSBundle mainBundle] pathForResource:@"pno_3" ofType:@"mp3"];
    
    AVAudioPlayer *pno3player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:path] error:nil];
    
    path = [[NSBundle mainBundle] pathForResource:@"pno_4" ofType:@"mp3"];
    
    AVAudioPlayer *pno4player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:path] error:nil];
    
    path = [[NSBundle mainBundle] pathForResource:@"pno_5" ofType:@"mp3"];
    
    AVAudioPlayer *pno5player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:path] error:nil];
    
    path = [[NSBundle mainBundle] pathForResource:@"pno_6" ofType:@"mp3"];
    
    AVAudioPlayer *pno6player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:path] error:nil];
    
    path = [[NSBundle mainBundle] pathForResource:@"pno_7" ofType:@"mp3"];
    
    AVAudioPlayer *pno7player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:path] error:nil];
    
    path = [[NSBundle mainBundle] pathForResource:@"pno_8" ofType:@"mp3"];
    
    AVAudioPlayer *pno8player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:path] error:nil];

    
    
    pno1Sound = [SKAction runBlock:^{
        [pno1player play];
    }];
    
    pno2Sound = [SKAction runBlock:^{
        [pno2player play];
    }];
    
    pno3Sound = [SKAction runBlock:^{
        [pno3player play];
    }];
    
    pno4Sound = [SKAction runBlock:^{
        [pno4player play];
    }];
    
    pno5Sound = [SKAction runBlock:^{
        [pno5player play];
    }];
    
    pno6Sound = [SKAction runBlock:^{
        [pno6player play];
    }];
    
    pno7Sound = [SKAction runBlock:^{
        [pno7player play];
    }];
    
    pno8Sound = [SKAction runBlock:^{
        [pno8player play];
    }];
    
     */
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
        if (touchCount%10 == 0) {
            speed += 0.05;
        }
        
        if (ballCount > 0) {
            ballCount--;
            
            Ball *ball = [Ball spriteNodeWithImageNamed:@"ball"];
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
                NSLog(@"check");

                /*
                if (ball.hitBugCount == 0) {
                    NSLog(@"reset continue");
                    continueHitBugCount = 0;
                }
                 */
            }];
            SKAction *remove = [SKAction removeFromParent];
            
            if (ballCount == 0) {
                [ball runAction:[SKAction sequence:@[wait,fade,check,remove]]];
            } else {
                [ball runAction:[SKAction sequence:@[wait,fade,remove]] completion:^{
                    if (ball.hitBugCount == 0) {
                        continueHitBugCount = 0;
                    }
                }];
            }
            
            
            
            [self runAction:dropSound];
            
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
             ballCount = 0;
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
        ballCount = 0;
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
        bug.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(bug.size.width - 5, bug.size.height - 5)];
        bug.physicsBody.dynamic = false;
        bug.physicsBody.categoryBitMask = CNPhysicsCategoryBug;
        bug.physicsBody.contactTestBitMask = CNPhysicsCategoryBall;
        bug.physicsBody.collisionBitMask = CNPhysicsCategoryBall | CNPhysicsCategoryGround;
        
        float duration = 1.8 - score/500.0; //1.8  1.85
        
        //NSLog(@"duration:%f",duration);
        
        
        duration = ScalarRandomRange(duration - 0.5, duration + 0.5);
        if (duration < 0.8) {
            duration = 0.8;
        }
        
        NSLog(@"duration:%f,score:%d",duration,score);

        
        SKAction *move = [SKAction moveByX:self.size.width+30 y:0 duration:duration];

        SKAction *remove = [SKAction removeFromParent];
        
        [bug runAction:[SKAction sequence:@[move,remove]] completion:^{
            if (!bug.isDead) {
                [self showMinusBallLabelWithHeight:bug.position.y];
            }
        }];
         
        
        [self addChild:bug];
        
    }];
    
    SKAction *wait = [SKAction waitForDuration:1];
    
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[spawnABug,wait]]]];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    uint32_t collision = (contact.bodyA.categoryBitMask |
                          contact.bodyB.categoryBitMask);
    
    if (collision == (CNPhysicsCategoryBall | CNPhysicsCategoryBug)) {
        Bug *bug;
        Ball *ball;
        if (contact.bodyA.categoryBitMask == CNPhysicsCategoryBug){
            bug = (Bug *)contact.bodyA.node;
            ball = (Ball *)contact.bodyB.node;
        } else {
            bug = (Bug *)contact.bodyB.node;
            ball = (Ball *)contact.bodyA.node;

        }
        
        bug.physicsBody.dynamic = YES;
        if (!bug.isDead) {
            score++;
            if (score%10 == 0) {
                [self reportAchievements];
            }
            bug.isDead = YES;
            
            ball.hitBugCount++;
            
            continueHitBugCount++;
            
            [self showAddBallLabelAndSoundWithBall:ball];
            
        }
    } else if (collision == (CNPhysicsCategoryBall | CNPhysicsCategoryGround))
    {
        /*
        int dice = arc4random()%8;
        
        switch (dice) {
            case 0:
                [self runAction:pno1Sound];
                break;
            case 1:
                [self runAction:pno2Sound];
                break;
            case 2:
                [self runAction:pno3Sound];
                break;
            case 3:
                [self runAction:pno4Sound];
                break;
            case 4:
                [self runAction:pno5Sound];
                break;
            case 5:
                [self runAction:pno6Sound];
                break;
            case 6:
                [self runAction:pno7Sound];
                break;
            case 7:
                [self runAction:pno8Sound];
                break;
                
            default:
                break;
        }
         */
    }
}

- (void)showAddBallLabelAndSoundWithBall:(Ball *)ball
{
    // add ball count
    int addBall = continueHitBugCount > 8 ? 8:continueHitBugCount;
    ballCount += addBall;
    
    // show label
    
    SKLabelNode *addBallLabel = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
    addBallLabel.text = [NSString stringWithFormat:@"+%d",addBall];
    
    UIColor *color;
    switch (continueHitBugCount) {
        case 1:
            color = [SKColor blackColor];
            [self runAction:pno1Sound];
            break;
        case 2:
            color = [SKColor brownColor];
            [self runAction:pno2Sound];

            break;
        case 3:
            color = [SKColor blueColor];
            [self runAction:pno3Sound];

            break;
        case 4:
            color = [SKColor greenColor];
            [self runAction:pno4Sound];

            break;
        case 5:
            color = [SKColor purpleColor];
            [self runAction:pno5Sound];

            break;
        case 6:
            color = [SKColor yellowColor];
            [self runAction:pno6Sound];

            break;
        case 7:
            color = [SKColor orangeColor];
            [self runAction:pno7Sound];
            
            break;
            
        default:
            color = [SKColor redColor];
            [self runAction:pno8Sound];

            break;
    }
    
    addBallLabel.fontColor = color;
    
    addBallLabel.fontSize = 20;
    addBallLabel.zPosition = 2;
    
    addBallLabel.position = CGPointMake(ball.position.x, ball.position.y + 10);
    
    SKAction *scale = [SKAction scaleTo:1.5 duration:0.3];
    SKAction *fade = [SKAction fadeOutWithDuration:0.3];
    SKAction *remove = [SKAction removeFromParent];
    
    [addBallLabel runAction:[SKAction sequence:@[scale,fade,remove]]];
    
    [self addChild:addBallLabel];
    
}

- (void)showMinusBallLabelWithHeight:(float)height
{
    if (ballCount == 0) {
        [self lose];
        return;
    }
    ballCount--;
    continueHitBugCount = 0;
    
    SKLabelNode *minusBallLabel = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
    minusBallLabel.text = @"-1";
    
    minusBallLabel.fontColor = [SKColor redColor];
    minusBallLabel.fontSize = 20;
    minusBallLabel.zPosition = 2;
    
    minusBallLabel.position = CGPointMake(self.size.width - 20, height);
    
    SKAction *scale = [SKAction scaleTo:1.5 duration:0.3];
    SKAction *fade = [SKAction fadeOutWithDuration:0.3];
    SKAction *remove = [SKAction removeFromParent];
    
    [minusBallLabel runAction:[SKAction sequence:@[scale,fade,remove]]];
    
    [self addChild:minusBallLabel];
}

#pragma mark - Game kit

- (void)reportAchievements
{
    NSLog(@"report achievements");
    NSMutableArray *achievements = [NSMutableArray arrayWithObjects:[AchievementsHelper reach10Achievement:score],[AchievementsHelper reach30Achievement:score],[AchievementsHelper reach50Achievement:score],[AchievementsHelper reach100Achievement:score],[AchievementsHelper reach500Achievement:score], nil];
    
    [[GameKitHelper sharedGameKitHelper] reportAchievements:achievements];
}

- (void)reportScoreToGameCenter
{
    NSLog(@"report score");
    [[GameKitHelper sharedGameKitHelper] reportScore:score forLeaderboardID:@"HighestScore"];
    
}

@end
