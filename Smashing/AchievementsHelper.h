//
//  AchievementsHelper.h
//  Smashing
//
//  Created by FloodSurge on 7/22/14.
//  Copyright (c) 2014 FloodSurge. All rights reserved.
//

@import GameKit;

@interface AchievementsHelper : NSObject

+ (GKAchievement *)reach10Achievement:(NSUInteger)numberOfReach;
+ (GKAchievement *)reach30Achievement:(NSUInteger)numberOfReach;
+ (GKAchievement *)reach50Achievement:(NSUInteger)numberOfReach;
+ (GKAchievement *)reach100Achievement:(NSUInteger)numberOfReach;
+ (GKAchievement *)reach500Achievement:(NSUInteger)numberOfReach;

@end
