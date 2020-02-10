//
//  StatsVC.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 09/12/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonImports.h"
#import "Charts-Swift.h"

@import QuartzCore;
@import StoreKit;
@import pop;

NS_ASSUME_NONNULL_BEGIN

@interface StatsVC : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIView *vwYourSkill;
@property (strong, nonatomic) IBOutlet UIView *vwCalendar;
@property (strong, nonatomic) IBOutlet UIView *vwAverageWorkout;
@property (strong, nonatomic) IBOutlet UIView *vwTimes;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblLevel;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblWorkout;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblTrainedHour;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblTrainedMin;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblTrainedSec;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblAverageMin;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblAverageSec;
@property (strong, nonatomic) IBOutlet UIView *workoutCalendar;
@property (strong, nonatomic) IBOutlet UILabel *lblMonth;
@property (strong, nonatomic) IBOutlet UIButton *btnPrevious;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) IBOutlet MBCircularProgressBarView *vwQuality;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblWorkoutHours;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblWorkoutMin;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblWorkoutSec;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblExerciseDone;
@property (strong, nonatomic) IBOutlet UIView *vwSingleDayWorkout;
@property (strong, nonatomic) IBOutlet UIButton *btnBackToCalendar;
@property (strong, nonatomic) IBOutlet UILabel *lblSelectedDate;
@property (strong, nonatomic) IBOutlet MBCircularProgressBarView *vwSingleDayQuality;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblSingleDayHours;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblSingleDayMin;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblSingleDaySec;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblSingleDayExercise;
@property (strong, nonatomic) IBOutlet UITableView *tblTimesOfDay;
@property (strong, nonatomic) IBOutlet UICollectionView *clvDaysOfWeek;
@property (strong, nonatomic) IBOutlet UIView *vwDays;
@property (strong, nonatomic) IBOutlet UIScrollView *scrView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *workoutCalendarLeading;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *workoutCalendarTrailing;
@property (strong, nonatomic) IBOutlet UILabel *lblHourTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblMinTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblSecTitle;
@property (strong, nonatomic) IBOutlet UIView *vwParent;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblUpcomingLevel;
@property (strong, nonatomic) IBOutlet UIView *vwFilter;
@property (strong, nonatomic) IBOutlet UIButton *btnInTotal;
@property (strong, nonatomic) IBOutlet UIButton *btnYearly;
@property (strong, nonatomic) IBOutlet UIButton *btnMonthly;
@property (strong, nonatomic) IBOutlet UIButton *btnWeekly;
@property (strong, nonatomic) IBOutlet UIView *vwAvgFilter;

@property (strong, nonatomic) IBOutlet UIButton *btnAvgInTotal;
@property (strong, nonatomic) IBOutlet UIButton *btnAvgYearly;
@property (strong, nonatomic) IBOutlet UIButton *btnAvgMonthly;
@property (strong, nonatomic) IBOutlet UIButton *btnAvgWeekly;
@property (strong, nonatomic) IBOutlet UIView *vwSkillSlide;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constVwSkillSlideX;
@property (strong, nonatomic) IBOutlet UIView *vwAvgSlide;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constVwAvgSlideX;
@property (strong, nonatomic) IBOutlet UIView *vwProgress1;
@property (strong, nonatomic) IBOutlet UIView *vwProgress2;
@property (strong, nonatomic) IBOutlet UIView *vwProgress3;
@property (strong, nonatomic) IBOutlet UIView *vwProgress4;
@property (strong, nonatomic) IBOutlet UIView *vwProgress5;
@property (strong, nonatomic) IBOutlet UIView *vwShowHide;
@property (strong, nonatomic) IBOutlet UIView *vwShowHide1;

@property (strong, nonatomic) FSCalendar *workoutStatsCalender;
@property (strong, nonatomic) NSCalendar *gregorian;

@end

NS_ASSUME_NONNULL_END
