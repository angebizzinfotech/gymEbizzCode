//
//  AppDelegate.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 16/04/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonImports.h"
#import "WorkoutViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) NSTimer *timerSaveOfflineWorkouts;

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) WorkoutViewController *workoutVC;

@property (strong, nonatomic) NSDate *lastExerciseTimerStopDate;

@property (strong, nonatomic) NSDate *totalTimerStopDate;

@property (strong, nonatomic) NSDate *restTimerStopDate;

@property (nonatomic) UIBackgroundTaskIdentifier bgTask;

@end

