//
//  WatchManager.h
//  GymTimer Watch Extension
//
//  Created by EbitNHP-i1 on 22/01/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ExerciseTimeDelegate <NSObject>

- (void)totalExerciseTime:(int)time;

@end

@protocol RestTimeDelegate <NSObject>

- (void)totalRestTime:(int)time;

@end

@interface WatchManager : NSObject

@property (nonatomic, weak) id<ExerciseTimeDelegate> exerciseDelegate;
@property (nonatomic, weak) id<RestTimeDelegate> restDelegate;

+ (id)sharedInstance;

- (void)startExerciseTimer;
- (void)stopExerciseTimer;
- (void)exerciseTimerSelector;

- (void)startRestTimer;
- (void)stopRestTimer;
- (void)restTimeSelector;
- (BOOL)isRestTimerRunning;

@end

NS_ASSUME_NONNULL_END
