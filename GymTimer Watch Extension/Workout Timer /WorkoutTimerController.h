//
//  WorkoutTimerController.h
//  GymTimer Watch Extension
//
//  Created by EbitNHP-i1 on 18/01/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WorkoutTimerController : WKInterfaceController

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblExercise;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblExerciseTitle;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblTotalTime;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblTotalTimeTitle;
@property (strong, nonatomic) IBOutlet WKInterfaceGroup *exerciseGroup;
@property (strong, nonatomic) IBOutlet WKInterfaceGroup *totalTimeGroup;

@end

NS_ASSUME_NONNULL_END
