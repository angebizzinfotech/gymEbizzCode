//
//  WorkoutCalendarCell.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 11/12/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonImports.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkoutCalendarCell : UICollectionViewCell <FSCalendarDelegate, FSCalendarDataSource> {
    NSArray *arrSelectedDates, *arrShortMonthsName;
    CAShapeLayer *cellBlackBorder;
    BOOL isBackClicked;
}

@property (strong, nonatomic) IBOutlet UIView *vwWorkoutShadow;
@property (strong, nonatomic) IBOutlet UIView *vwWorkout;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet MBCircularProgressBarView *vwQuality;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblSingleDayHour;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblSingleDayMin;

@property (strong, nonatomic) IBOutlet UICountingLabel *lblSingleDaySec;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblExerciseDone;
@property (strong, nonatomic) IBOutlet UIView *vwCalendarShadow;
@property (strong, nonatomic) IBOutlet UIView *vwCalendar;
@property (strong, nonatomic) IBOutlet UIView *workoutCalendar;
@property (strong, nonatomic) IBOutlet UILabel *lblMonthName;
@property (strong, nonatomic) IBOutlet UIButton *lblPrevious;
@property (strong, nonatomic) IBOutlet UIButton *lblNext;

@property (strong, nonatomic) FSCalendar *workoutStatsCalender;
@property (strong, nonatomic) NSCalendar *gregorian;

- (void)reloadCalendar;

@end

NS_ASSUME_NONNULL_END
