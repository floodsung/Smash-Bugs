//
//  GameKitHelper.m
//  Smashing
//
//  Created by FloodSurge on 7/22/14.
//  Copyright (c) 2014 FloodSurge. All rights reserved.
//

#import "GameKitHelper.h"

NSString *const PresentAuthenticationViewController = @"present_authentication_view_controlller";

@interface GameKitHelper()<GKGameCenterControllerDelegate>

@end

@implementation GameKitHelper
{
    BOOL _enableGameCenter;
}

+ (instancetype)sharedGameKitHelper
{
    static GameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper = [[GameKitHelper alloc] init];
    });
    return sharedGameKitHelper;
}

- (id)init
{
    self = [super init];
    if (self) {
        _enableGameCenter = YES;
    }
    return self;
}

- (void)authenticateLocalPlayer
{
    // 1
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    //2
    localPlayer.authenticateHandler = ^(UIViewController *viewController,NSError *error) {
        //3
        [self setLastError:error];
        
        if (viewController != nil) {
            [self setAuthenticationViewController:viewController];
        } else if ([GKLocalPlayer localPlayer].isAuthenticated) {
            _enableGameCenter = YES;
        } else {
            _enableGameCenter = NO;
        }
    };
}

- (void)setAuthenticationViewController:(UIViewController *)authenticationViewController
{
    if (authenticationViewController != nil) {
        _authenticationViewController = authenticationViewController;
        [[NSNotificationCenter defaultCenter] postNotificationName:PresentAuthenticationViewController object:self];
    }
}

- (void)setLastError:(NSError *)error
{
    _lastError = [error copy];
    if (_lastError) {
        NSLog(@"GameKitHelper ERROR:%@",[[_lastError userInfo] description]);
    }
}

- (void)reportAchievements:(NSArray *)achievements
{
    if (!_enableGameCenter) {
        NSLog(@"Local play is not authenticated");
    }
    
    [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
        [self setLastError:error];
    }];
}

- (void)showGKGameCenterViewController:(UIViewController *)viewController
{
    if (!_enableGameCenter) {
        NSLog(@"Local Play is not authenticated");
    }
    
    GKGameCenterViewController *gameCenterViewController = [[GKGameCenterViewController alloc] init];
    
    gameCenterViewController.gameCenterDelegate = self;
    
    gameCenterViewController.viewState = GKGameCenterViewControllerStateAchievements;
    
    [viewController presentViewController:gameCenterViewController animated:YES completion:nil];
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)reportScore:(int64_t)score forLeaderboardID:(NSString *)leaderboardID
{
    if (!_enableGameCenter) {
        NSLog(@"Local Play is not authenticated");
    }
    
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier:leaderboardID];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    NSArray *scores = @[scoreReporter];
    
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        [self setLastError:error];
    }];
}

@end
