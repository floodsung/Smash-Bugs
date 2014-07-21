//
//  Bug.m
//  Smashing
//
//  Created by FloodSurge on 7/21/14.
//  Copyright (c) 2014 FloodSurge. All rights reserved.
//

#import "Bug.h"
#import "MyScene.h"
@implementation Bug

- (id)init
{
    self = [super init];
    if (self) {
        self.isDead = NO;
    }
    return self;
}

@end
