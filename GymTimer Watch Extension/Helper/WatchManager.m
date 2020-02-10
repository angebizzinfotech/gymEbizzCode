//
//  WatchManager.m
//  GymTimer Watch Extension
//
//  Created by EbitNHP-i1 on 22/01/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

#import "WatchManager.h"
#import "Common.h"

@implementation WatchManager {
    NSTimer *exerciseTimer;
    NSTimer *restTimer;
    
    int exerciseTime;
    int restTime;
    
    BOOL isRestTimerRunning;
}

+ (id)sharedInstance {
    static WatchManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
  if (self = [super init]) {
  }
  return self;
}

// MARK:- Exercise Timer

- (void)startExerciseTimer {
    [self stopExerciseTimer];
    exerciseTime = 0;
    exerciseTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(exerciseTimerSelector) userInfo:nil repeats:YES];
}

- (void)stopExerciseTimer {
    [exerciseTimer invalidate];
    exerciseTimer = nil;
}

- (void)exerciseTimerSelector {
    exerciseTime = exerciseTime + 1;
    
    if ([self.exerciseDelegate respondsToSelector:@selector(totalExerciseTime:)]) {
        [self.exerciseDelegate totalExerciseTime:exerciseTime];
    }
}

// MARK:- Rest Timer

- (void)startRestTimer {
    [self stopRestTimer];
    isRestTimerRunning = YES;
    restTime = [WatchUtils secondsForTimeString:[WatchUtils getWorkoutSelectedTime]];
    restTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(restTimeSelector) userInfo:nil repeats:YES];
}

- (void)stopRestTimer {
    [restTimer invalidate];
    restTimer = nil;
    isRestTimerRunning = NO;
    
    // Notification for change color
    [[NSNotificationCenter defaultCenter] postNotificationName:nCHANGE_COLOR object:nil];
}

- (void)restTimeSelector {
    if (restTime <= 0) {
        [self stopRestTimer];
    }
    
    restTime = restTime - 1;
        
    if ([self.restDelegate respondsToSelector:@selector(totalRestTime:)]) {
        [self.restDelegate totalRestTime:restTime];
    }
}

- (BOOL)isRestTimerRunning {
    return isRestTimerRunning;
}

@end
