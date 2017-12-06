//
//  MyScene.h
//  Smashing
//

//  Copyright (c) 2014 FloodSurge. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define ARC4RANDOM_MAX      0x100000000
static inline CGFloat ScalarRandomRange(CGFloat min,
                                        CGFloat max)
{
    return ((double)arc4random() / ARC4RANDOM_MAX) *
                  (max - min) + min;
}

typedef NS_OPTIONS(uint32_t, CNPhysicsCategory)
{
    CNPhysicsCategoryBall    = 1 << 0,  // 0001 = 1
    CNPhysicsCategoryBug  = 1 << 1,  // 0010 = 2
    CNPhysicsCategoryGround = 1 << 2,
};

@interface MyScene : SKScene<SKPhysicsContactDelegate>

@end
