//
//  YourSkillLevelCell.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 11/12/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonImports.h"

NS_ASSUME_NONNULL_BEGIN

@interface YourSkillLevelCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIView *vwBack;
@property (strong, nonatomic) IBOutlet UIView *vwSkillLevel;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblSkillLevel;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblWorkout;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblUpcomingLevel;
@property (strong, nonatomic) IBOutlet UIProgressView *progress1;
@property (strong, nonatomic) IBOutlet UIProgressView *progress2;
@property (strong, nonatomic) IBOutlet UIProgressView *progress3;
@property (strong, nonatomic) IBOutlet UIProgressView *progress4;
@property (strong, nonatomic) IBOutlet UIProgressView *progress5;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblTrainedHour;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblTrainedMin;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblTrainedSec;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblAverageMin;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblAverageSec;
@property (strong, nonatomic) IBOutlet UIView *vwShadow;
@property (strong, nonatomic) IBOutlet UIView *vwFilter;
@property (strong, nonatomic) IBOutlet UIButton *btnIntotal;
@property (strong, nonatomic) IBOutlet UIButton *btnYearly;
@property (strong, nonatomic) IBOutlet UIButton *btnMonthly;
@property (strong, nonatomic) IBOutlet UIButton *btnWeekly;

- (void)animateNumbers;

@end

NS_ASSUME_NONNULL_END
