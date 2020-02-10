//
//  WorkoutAdviceViewController.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 18/04/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonImports.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkoutAdviceViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *viewWorkoutAdviceScrollView;
@property (weak, nonatomic) IBOutlet UIView *viewWorkoutAdviceContentView;

@property (weak, nonatomic) IBOutlet UILabel *lblAdviceTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnBackButton;
@property (weak, nonatomic) IBOutlet UILabel *lblAdviceSubTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *viewRecommendedRestTimeContentView;
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *progressBarRecommendedRestView;
@property (weak, nonatomic) IBOutlet UILabel *lblRecommendedRestTimeLabel;

@property (weak, nonatomic) IBOutlet UIView *viewEnduranceContentView;
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *progressBarEnduranceView;
@property (weak, nonatomic) IBOutlet UILabel *lblEnduranceProgressCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblEnduranceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblEnduranceSubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblEnduranceDoSetsLabel;

@property (weak, nonatomic) IBOutlet UIView *viewMuscleContentView;
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *progressBarMuscleView;
@property (weak, nonatomic) IBOutlet UILabel *lblMuscleProgressBarCount;
@property (weak, nonatomic) IBOutlet UILabel *lblMuscleTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblMuscleSubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblMuscleDoSetsLabel;

@property (weak, nonatomic) IBOutlet UIView *viewStrengthContentView;
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *progressBarStrengthView;
@property (weak, nonatomic) IBOutlet UILabel *lblStrengthProgressBarCount;
@property (weak, nonatomic) IBOutlet UILabel *lblStrengthTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblStrengthSubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblStrengthDoSetsLabel;

- (IBAction)btnBackButtonTapped:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
