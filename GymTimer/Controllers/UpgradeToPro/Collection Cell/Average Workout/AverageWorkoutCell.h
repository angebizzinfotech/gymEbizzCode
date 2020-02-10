//
//  AverageWorkoutCell.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 11/12/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonImports.h"

NS_ASSUME_NONNULL_BEGIN

@interface AverageWorkoutCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIView *vwShadow;
@property (strong, nonatomic) IBOutlet UIView *vwAverageWorkout;
@property (strong, nonatomic) IBOutlet MBCircularProgressBarView *vwQuality;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblDurationHours;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblDurationMin;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblDurationSec;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblExercise;
@property (strong, nonatomic) IBOutlet UIView *vwFilter;
@property (strong, nonatomic) IBOutlet UIButton *btnIntotal;
@property (strong, nonatomic) IBOutlet UIButton *btnYearly;
@property (strong, nonatomic) IBOutlet UIButton *btnMonthly;
@property (strong, nonatomic) IBOutlet UIButton *btnWeekly;

- (void)animateNumbers;

@end

NS_ASSUME_NONNULL_END
