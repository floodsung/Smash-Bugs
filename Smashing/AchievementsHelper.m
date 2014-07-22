//
//  AchievementsHelper.m
//  Smashing
//
//  Created by FloodSurge on 7/22/14.
//  Copyright (c) 2014 FloodSurge. All rights reserved.
//

#import "AchievementsHelper.h"

static NSString *const kSmashBugReach10AchievementId = @"com.manmanlai.Smashing.Reach10";
static NSString *const kSmashBugReach30AchievementId = @"Reach30";
static NSString *const kSmashBugReach50AchievementId = @"Reach10";
static NSString *const kSmashBugReach100AchievementId = @"Reach100";
static NSString *const kSmashBugReach500AchievementId = @"Reach500";



@implementation AchievementsHelper

+ (GKAchievement *)reach10Achievement:(NSUInteger)numberOfReach
{
    CGFloat percent = numberOfReach/10 * 100.0;
    
    GKAchievement *reachAchievement = [[GKAchievement alloc] initWithIdentifier:kSmashBugReach10AchievementId];
    reachAchievement.percentComplete = percent;
    reachAchievement.showsCompletionBanner = YES;
    return reachAchievement;
    
}

+ (GKAchievement *)reach30Achievement:(NSUInteger)numberOfReach
{
    CGFloat percent = numberOfReach/30 * 100.0;
    
    GKAchievement *reachAchievement = [[GKAchievement alloc] initWithIdentifier:kSmashBugReach30AchievementId];
    reachAchievement.percentComplete = percent;
    reachAchievement.showsCompletionBanner = YES;
    return reachAchievement;
    
}

+ (GKAchievement *)reach50Achievement:(NSUInteger)numberOfReach
{
    CGFloat percent = numberOfReach/50 * 100.0;
    
    GKAchievement *reachAchievement = [[GKAchievement alloc] initWithIdentifier:kSmashBugReach50AchievementId];
    reachAchievement.percentComplete = percent;
    reachAchievement.showsCompletionBanner = YES;
    return reachAchievement;
    
}

+ (GKAchievement *)reach100Achievement:(NSUInteger)numberOfReach
{
    CGFloat percent = numberOfReach/100 * 100.0;
    
    GKAchievement *reachAchievement = [[GKAchievement alloc] initWithIdentifier:kSmashBugReach100AchievementId];
    reachAchievement.percentComplete = percent;
    reachAchievement.showsCompletionBanner = YES;
    return reachAchievement;
    
}

+ (GKAchievement *)reach500Achievement:(NSUInteger)numberOfReach
{
    CGFloat percent = numberOfReach/500 * 100.0;
    
    GKAchievement *reachAchievement = [[GKAchievement alloc] initWithIdentifier:kSmashBugReach500AchievementId];
    reachAchievement.percentComplete = percent;
    reachAchievement.showsCompletionBanner = YES;
    return reachAchievement;
    
}

@end
