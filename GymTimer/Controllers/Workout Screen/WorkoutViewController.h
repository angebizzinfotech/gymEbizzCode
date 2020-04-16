//
//  WorkoutViewController.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 17/04/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonImports.h"
#import <MBCircularProgressBar/MBCircularProgressBarView.h>
#import <MBCircularProgressBar/MBCircularProgressBarLayer.h>
#import <MBCircularProgressBar/MBCircularProgressBar-umbrella.h>
#import <MBCircularProgressBarView.h>
#import <MBCircularProgressBarLayer.h>
#import <MBCircularProgressBar-umbrella.h>
#import <UICountingLabel/UICountingLabel.h>
#import <UICountingLabel-umbrella.h>

NS_ASSUME_NONNULL_BEGIN

@interface WorkoutViewController : UIViewController

@property (strong, nonatomic) NSTimer * _Nullable timerLastExerciseTime;
@property (strong, nonatomic) NSTimer * _Nullable timerTotalTime;
@property (strong, nonatomic) NSTimer * _Nullable timerRest;
@property (strong, nonatomic) NSString *isRestTimerRunning;
@property (strong, nonatomic) NSDate *restTimerStopDateInVC;
@property (strong, nonatomic) NSDate *restTimerStopDate;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) AVAudioPlayer *audioPlayerSecond;


- (int) convertRestTimeToSecondsFrom: (NSString *) restTime;
- (void) startRecordingTotalTime;
- (void) setupProgressBar;



//MARK:- Loader view
@property (weak, nonatomic) IBOutlet UIView *viewLoaderBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *imgLoaderBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *lblLoaderGymTimerLabel;
@property (weak, nonatomic) IBOutlet UIView *viewLoaderContentView;

@property (weak, nonatomic) IBOutlet UIImageView *imgAppBackgroundImage;


//MARK:- Start workout screen

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewWorkoutScreen;
@property (weak, nonatomic) IBOutlet UIView *contentViewWorkoutScreen;

@property (weak, nonatomic) IBOutlet UILabel *lblGymTimerTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *viewWorkoutContentView;
// Vsn - 25/02/2020
@property (weak, nonatomic) IBOutlet UIView *vwImgWelcomeBack;
@property (weak, nonatomic) IBOutlet UIView *vwWorkoutContentParent;
// Vsn - 19/02/2020
@property (weak, nonatomic) IBOutlet UIImageView *imgWelcomeBack;
@property (weak, nonatomic) IBOutlet UIView *viewWorkoutContentViewSubView;
@property (weak, nonatomic) IBOutlet UIView *vw_gymtimer_boost_your_workouts;

// End
@property (strong, nonatomic) IBOutlet UIImageView *imgHomeBottomGym;
@property (weak, nonatomic) IBOutlet UILabel *lblChooseDefaultTimeLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerWorkoutRestTimePickerView;
@property (weak, nonatomic) IBOutlet UIView *viewMinutesSecondsContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblMinuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblSecondsLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnStartWorkoutButton;

@property (weak, nonatomic) IBOutlet UIView *viewTabMain;
@property (weak, nonatomic) IBOutlet UIView *viewTabParent;
@property (weak, nonatomic) IBOutlet UIView *viewTabTop;
@property (weak, nonatomic) IBOutlet UIView *viewTabMovable;

@property (weak, nonatomic) IBOutlet UIImageView *characterEndurance;
@property (weak, nonatomic) IBOutlet UIImageView *characterMuscle;
@property (weak, nonatomic) IBOutlet UIImageView *characterPower;

@property (weak, nonatomic) IBOutlet UIButton *btnEndurance;
@property (weak, nonatomic) IBOutlet UIButton *btnMuscle;
@property (weak, nonatomic) IBOutlet UIButton *btnpower;
@property (weak, nonatomic) IBOutlet UIButton *imgDumbell;

@property (weak, nonatomic) IBOutlet UILabel *lblRecommend;
@property (weak, nonatomic) IBOutlet UICountingLabel *lblRange1;
@property (weak, nonatomic) IBOutlet UILabel *lblSets;
@property (weak, nonatomic) IBOutlet UICountingLabel *lblRange2;
@property (weak, nonatomic) IBOutlet UILabel *lblReps;
@property (weak, nonatomic) IBOutlet UILabel *lblScientific;

@property (weak, nonatomic) IBOutlet UILabel *lblSeparator1;
@property (weak, nonatomic) IBOutlet UILabel *lblSeparator2;

- (IBAction)btnEnduranceClick:(UIButton *)sender;
- (IBAction)btnMuscleClick:(UIButton *)sender;
- (IBAction)btnPowerClick:(UIButton *)sender;


- (IBAction)btnStartWorkoutButtonTapped:(UIButton *)sender;



//MARK:- Set and rest screen

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewSetAndRestScreen;
@property (weak, nonatomic) IBOutlet UIView *contentViewSetAndRestScreen;

@property (weak, nonatomic) IBOutlet UILabel *lblGymTimerSetScreenLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblBoostYourWorkoutsSetScreenLabel;

@property (weak, nonatomic) IBOutlet UIView *viewSetAndRestBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *viewDoSetNumberContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblDoSetNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblDoSetNumberCountLabel;
@property (weak, nonatomic) IBOutlet UIView *viewRestTimeContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblRestTimerMinutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblRestTimerColonLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblRestTimerSecondsLabel;


@property (weak, nonatomic) IBOutlet UIView *viewSetAndRestScreenProgressBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *viewLastExerciseTimeContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblSinceLastExerciseLabel;
@property (weak, nonatomic) IBOutlet UIView *viewLastExerciseMinuteFormat;
@property (weak, nonatomic) IBOutlet UILabel *lblLastExerciseSecondMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblLastExerciseSecondColonLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblLastExerciseSecondSecLabel;
@property (weak, nonatomic) IBOutlet UIView *viewLastExerciseHoursFormat;
@property (weak, nonatomic) IBOutlet UILabel *lblLastExerciseFirstHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblLastExerciseHourFirstColonLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblLastExerciseFirstMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblLastExerciseHourSecondColonLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblLastExerciseFirstSecLabel;
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *progressBarSetScreenView;
@property (weak, nonatomic) IBOutlet UIImageView *imgSetScreenDumbellsImage;
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *progressBarRestBackgroungView;
@property (strong, nonatomic) IBOutlet UIView *vwRestScreenDumbellsBackgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *imgRestScreenDumbellsBackgroundImage;
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *progressBarRestScreenView;
@property (weak, nonatomic) IBOutlet UIImageView *imgRestScreenDumbellsImage;
@property (weak, nonatomic) IBOutlet UIView *viewClickAnywhereContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblClickAnywhereToRestLabel;
@property (weak, nonatomic) IBOutlet UIView *viewNextSetContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblNextSetLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblNextSetCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnStartRestButton;

@property (strong, nonatomic) IBOutlet UIView *vwDateTime;
@property (weak, nonatomic) IBOutlet UIView *viewExerciseAndTotalTimeBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *viewExerciseContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblExerciseCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblExerciseLabel;
@property (weak, nonatomic) IBOutlet UIView *viewTotalTimeContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *viewHoursTimeContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblHoursFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblColonFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblMinFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblColonSecondLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblSecondsFirstLabel;
@property (weak, nonatomic) IBOutlet UIView *viewMinTimeContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblMinSecondLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblColonThirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblSecondsSecondLabel;

@property (weak, nonatomic) IBOutlet UIButton *btnSwipeButton;

@property (weak, nonatomic) IBOutlet UIView *viewBottomButtonsBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *viewUpperButtonsBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *viewNextExerciseButtonContentView;
@property (weak, nonatomic) IBOutlet UIImageView *imgNextExerciseImage;
@property (weak, nonatomic) IBOutlet UILabel *lblNextExerciseLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnNextExerciseButton;
@property (weak, nonatomic) IBOutlet UIView *viewChangeRestButtonContentView;
@property (weak, nonatomic) IBOutlet UIView *viewChangeRestView;
@property (weak, nonatomic) IBOutlet UILabel *lblChangeRestCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblChangeRestLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnChangeRestButton;

@property (weak, nonatomic) IBOutlet UIView *viewLowerButtonsBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *viewSoundButtonContentView;
@property (weak, nonatomic) IBOutlet UIImageView *imgSoundImage;
@property (weak, nonatomic) IBOutlet UILabel *lblSoundLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnSoundButton;
@property (weak, nonatomic) IBOutlet UIView *viewEndWorkoutButtonContentView;
@property (weak, nonatomic) IBOutlet UIImageView *imgEndWorkoutImage;
@property (weak, nonatomic) IBOutlet UILabel *lblEndWorkoutLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnEndWorkoutButton;


- (IBAction)btnSwipeButtonTapped:(UIButton *)sender;
- (IBAction)btnNextExerciseButtonTapped:(UIButton *)sender;
- (IBAction)btnChangeRestButtonTapped:(UIButton *)sender;
- (IBAction)btnSoundButtonTapped:(UIButton *)sender;
- (IBAction)btnEndWorkoutButtonTapped:(UIButton *)sender;
- (IBAction)btnStartRestButtonTapped:(UIButton *)sender;



//MARK:- Workout Complete Screen

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewWorkoutCompleteScreen;
@property (weak, nonatomic) IBOutlet UIView *contentViewWorkoutCompleteScreen;
@property (weak, nonatomic) IBOutlet UILabel *lblGymTimerWorkoutScreenTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *viewWorkoutStatsBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *viewPowerPopup;
@property (weak, nonatomic) IBOutlet UIView *viewPowerPopupInfomation;
@property (weak, nonatomic) IBOutlet UIImageView *imgPowerPopupInfomationBg;
@property (weak, nonatomic) IBOutlet UILabel *lblCongratulationsText;

@property (weak, nonatomic) IBOutlet UIView *viewWorkoutCompleteContentVIew;
@property (weak, nonatomic) IBOutlet UILabel *lblWorkoutCompleteLabel;
@property (weak, nonatomic) IBOutlet UIView *viewWorkoutStatsContentView;
@property (weak, nonatomic) IBOutlet UIView *viewWorkoutStatsContentViewShadow;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalWorkoutTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalWorkoutExercisesLabel;

// Vsn - 09/04/2020
@property (weak, nonatomic) IBOutlet UIView *vwRandomWorkoutCompleteBackground;
@property (weak, nonatomic) IBOutlet UIView *vwRandomWorkoutCompleteBackgroundShadow;
@property (weak, nonatomic) IBOutlet UIView *vwRandomWorkoutCompleteTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblRandomWorkoutCompleteTitle;
@property (weak, nonatomic) IBOutlet UIView *vwRandomWorkoutCompleteSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblRandomWorkoutCompleteSubTitle;
@property (weak, nonatomic) IBOutlet UIView *vwRandomSeprater;
@property (weak, nonatomic) IBOutlet UIView *vwRandomWorkoutCompletePro;
@property (weak, nonatomic) IBOutlet UILabel *lblRandomWorkoutCompleteProText;
// End

@property (weak, nonatomic) IBOutlet UIView *viewHoursTimeFormatContentView;
@property (weak, nonatomic) IBOutlet UICountingLabel *lblFirstHoursCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblFirstHoursTitleLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *lblFirstMinCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblFirstMinTitleLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *lblFirstSecCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblFirstSecTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *viewMinTimeFormatContentView;
@property (weak, nonatomic) IBOutlet UICountingLabel *lblSecondMinCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblSecondMinTitleLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *lblSecondSecCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblSecondSecTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *viewTotalExerciseContentView;
@property (weak, nonatomic) IBOutlet UICountingLabel *lblTotalExerciseCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblExerciseTitleLabel;
@property (strong, nonatomic) IBOutlet UIView *vwCompetedBottom;
@property (strong, nonatomic) IBOutlet UIView *vwQuality;
@property (strong, nonatomic) IBOutlet UILabel *lblQuality;
@property (strong, nonatomic) IBOutlet MBCircularProgressBarView *vwQualityProgress;
@property (strong, nonatomic) IBOutlet UIView *vwTime;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalTimeTitle;
//@property (strong, nonatomic) IBOutlet UILabel *lblTotalTime;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalExercisetitle;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblTotalExercise;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblHours;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblMinutes;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblSeconds;

@property (weak, nonatomic) IBOutlet UIButton *btnShareStatsButton;
@property (weak, nonatomic) IBOutlet UIButton *btnDoneWorkoutButton;
@property (weak, nonatomic) IBOutlet UIButton *btnArrowScientifically;

@property (weak, nonatomic) IBOutlet UIImageView *imgEndurance;
@property (weak, nonatomic) IBOutlet UIImageView *imgMuscle;
@property (weak, nonatomic) IBOutlet UIImageView *imgPower;

@property (strong, nonatomic) IBOutlet UIView *viewHideShow;
@property (weak, nonatomic) IBOutlet UICountingLabel *lblRange11;
@property (weak, nonatomic) IBOutlet UILabel *lblMinus1;
@property (weak, nonatomic) IBOutlet UICountingLabel *lblRange22;
@property (weak, nonatomic) IBOutlet UILabel *lblMinus2;

- (IBAction)btnShareStatsButtonTapped:(UIButton *)sender;
- (IBAction)btnDoneWorkoutButtonTapped:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIView *vwCongrats;
@property (strong, nonatomic) IBOutlet UILabel *lblCongrats;
@property (strong, nonatomic) IBOutlet UILabel *lblYouReached;
@property (strong, nonatomic) IBOutlet UIImageView *imgBadge;
@property (strong, nonatomic) IBOutlet UILabel *lblLevel;
@property (strong, nonatomic) IBOutlet UILabel *lblShortWorkoutMsg;
@property (strong, nonatomic) IBOutlet UIView *vwWarmUp;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu;
@property (strong, nonatomic) IBOutlet UIView *vwLastExercise;
@property (strong, nonatomic) IBOutlet UILabel *lblTimeSinceTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTimeSince;
@property (strong, nonatomic) IBOutlet UIView *vwNextExercise;
@property (strong, nonatomic) IBOutlet MBCircularProgressBarView *vwNextExerciseRing;
@property (strong, nonatomic) IBOutlet UIImageView *imgNextExercise;

- (void) startRecord;
@end

NS_ASSUME_NONNULL_END
