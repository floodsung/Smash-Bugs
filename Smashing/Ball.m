//
//  Ball.m
//  Smashing
//
//  Created by FloodSurge on 7/22/14.
//  Copyright (c) 2014 FloodSurge. All rights reserved.
//

#import "Ball.h"

@implementation Ball

- (id)init
{
    self = [super init];
    if (self) {
        self.hitBugCount = 0;
    }
    return self;
}

@end
