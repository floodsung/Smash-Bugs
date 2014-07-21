//
//  MyScene.m
//  Smashing
//
//  Created by FloodSurge on 7/21/14.
//  Copyright (c) 2014 FloodSurge. All rights reserved.
//

#import "MyScene.h"
#import "Bug.h"


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
    SKAction *stabSound;
    SKAction *clangSound;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        [self initConfiguration];
        [self addGround];
        [self addLabels];
        [self spawnBugs];
        
        //[self runAction:[SKAction repeatActionForever:[SKAction playSoundFileNamed:@"bgMusic.mp3" waitForCompletion:YES]]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restart) name:@"restartNotification" object:nil];
       
    }
    return self;
}

- (void)restart
{
    NSLog(@"restart");
    gameOverLabel.hidden = YES;
    
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
    
    stabSound = [SKAction playSoundFileNamed:@"STAB1.WAV" waitForCompletion:NO];
    clangSound = [SKAction playSoundFileNamed:@"edown.mp3" waitForCompletion:NO];
    
    gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Thin"];
    gameOverLabel.text = @"GameOver";
    gameOverLabel.zPosition = 2;
    gameOverLabel.fontColor = [SKColor blackColor];
    gameOverLabel.position = CGPointMake(self.size.width / 2 , self.size.height / 2 + 20);
    
    [self addChild:gameOverLabel];
    gameOverLabel.hidden = YES;
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
            ball.physicsBody.restitution = 0.65;
            ball.physicsBody.friction = 0.1;
            ball.physicsBody.density = 2;
            ball.position = CGPointMake(location.x, self.size.height - 30);
            ball.physicsBody.categoryBitMask = CNPhysicsCategoryBall;
            ball.physicsBody.collisionBitMask = CNPhysicsCategoryGround | CNPhysicsCategoryBug | CNPhysicsCategoryBall;
            ball.physicsBody.contactTestBitMask = CNPhysicsCategoryBug | CNPhysicsCategoryGround;
            
            SKAction *wait = [SKAction waitForDuration:5];
            SKAction *fade = [SKAction fadeOutWithDuration:0.5];
            
            SKAction *remove = [SKAction removeFromParent];
            
            [ball runAction:[SKAction sequence:@[wait,fade,remove]]];
            
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
    gameOverLabel.hidden = NO;
    isLose = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gameOverNotification" object:nil];
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
    ground.position = CGPointMake(self.size.width/2, 15);
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
        
        
        
        SKAction *move = [SKAction moveByX:self.size.width+30 y:0 duration:ScalarRandomRange(2.5 - speed, 4.5 - speed)];
        /*
        SKAction *check = [SKAction runBlock:^{
            if (!bug.isDead && !isLose) {
                if (ballCount > 0) {
                    ballCount--;
                }else {
                    [self lose];
                }
                
            }
        }];
         */
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
            continueSmashCount++;
            ballCount += continueSmashCount;
            bug.isDead = YES;
            
        }
    } else if (collision == (CNPhysicsCategoryBall | CNPhysicsCategoryGround))
    {
        continueSmashCount = 0;
    }
}

@end
