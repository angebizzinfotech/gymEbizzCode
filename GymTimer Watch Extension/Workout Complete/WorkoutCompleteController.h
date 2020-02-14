//
//  WorkoutCompleteController.h
//  GymTimer Watch Extension
//
//  Created by EbitNHP-i1 on 17/01/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WorkoutCompleteController : WKInterfaceController

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblWorkoutComplete;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblTotalTimeTitle;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblTotalTime;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblExercisesTitle;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblQualityTitle;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblExercises;
@property (strong, nonatomic) IBOutlet WKInterfaceImage *imgQuality;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblQuality;
@property (strong, nonatomic) IBOutlet WKInterfaceGroup *groupActivity;
@property (strong, nonatomic) IBOutlet WKInterfaceImage *imgActivity;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *btnExit;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *lblClickToExit;

@end

NS_ASSUME_NONNULL_END
