//
//  GameKitHelper.h
//  Smashing
//
//  Created by FloodSurge on 7/22/14.
//  Copyright (c) 2014 FloodSurge. All rights reserved.
//

@import GameKit;

extern NSString *const PresentAuthenticationViewController;

@interface GameKitHelper : NSObject

@property (nonatomic,readonly) UIViewController *authenticationViewController;
@property (nonatomic,readonly) NSError *lastError;

+ (instancetype)sharedGameKitHelper;
- (void)authenticateLocalPlayer;
- (void)reportAchievements:(NSArray *)achievements;

- (void)showGKGameCenterViewController:(UIViewController *)viewController;
- (void)reportScore:(int64_t)score forLeaderboardID:(NSString *)leaderboardID;

@end
