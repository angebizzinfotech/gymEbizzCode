//
//  WorkoutViewController.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 17/04/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "WorkoutViewController.h"
#import "CommonImports.h"
#import <UICountingLabel/UICountingLabel.h>
#import <UICountingLabel-umbrella.h>
@import pop;
@import FirebaseAnalytics;
@import WatchConnectivity;

@interface WorkoutViewController () <UITabBarControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate, AVAudioPlayerDelegate, ServiceManagerDelegate, WCSessionDelegate> {
    
    ServiceManager *serviceManager;
    Utils *utils;
    UIActivityIndicatorView *spinner;
    NSMutableDictionary *dicUserDetails;
    NSArray *arrMinutes, *arrSeconds, *arrShortMonthsName;
    NSString *isSetScreen, *isBottomButtonsViewOpen, *isScrollingByButtons, *isEndWorkoutButtonTapped, *isStartWorkoutButtonTapped, *currentWorkoutTotalTime;
    BOOL isFirstpage, isSecondpage, flagFirstPage, flagSecondPage, isEndDraggingMethodCalled;
    int totalCurrentHour, totalCurrentMin, totalCurrentSec, totalTimeHour, totalTimeMin, totalTimeSec, lastExerciseHour, lastExerciseMin, lastExerciseSec;
    int timeMin, timeSec, currentRestTimeMinutes, currentRestTimeSeconds, currentPage;
    NSDictionary *dicStartButtonAttributes, *dicSkillAvarage;
    NSURL *urlBeepAudio;
    SystemSoundID soundID;
    AVAudioSession *audioSession;
    UICountingLabel *lblCounting;
    MZTimerLabel *timerForRest;
    CAShapeLayer *cellBlackBorder;
    
    CGFloat width;
    CGFloat nextExerciseOpacity;
    
    CGRect enduranceFrame;
    CGRect muscleFrame;
    CGRect powerFrame;
    
    CGRect charEnduranceFrame;
    CGRect charMuscleFrame;
    CGRect charPowerFrame;
    
    UIColor *colorTabSelect;
    UIColor *colorTabUnSelect;
    
    NSInteger slideDown;
    NSInteger selectedSlideUpImage;
    Boolean allUp;
    WarmUpView *warmUpView;
    BOOL isFromNextExercise, isNextExerciseStart;
    UIColor *colorClickAnywhere;
    
    BOOL isWarmUpFlag;
}

@end

@implementation WorkoutViewController

//MARK:- View's lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
        
    nextExerciseOpacity = 0.5;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            colorClickAnywhere = self.lblClickAnywhereToRestLabel.textColor;
    });
    
    isNextExerciseStart = NO;
    warmUpView = [[WarmUpView alloc] init];
    
    slideDown = 1;
    selectedSlideUpImage = 0;
    allUp = true;
    
    
    //DINAL-11-02-2020
    [self.imgMuscle setHidden:YES];
    [self.imgEndurance setHidden:YES];
    [self.imgPower setHidden:YES];
    
        
    [self.lblRange1 setFormat:@"%d"];
    [self.lblRange11 setFormat:@"%d"];
    [self.lblRange2 setFormat:@"%d"];
    [self.lblRange22 setFormat:@"%d"];
    
    colorTabSelect = [UIColor whiteColor];
    colorTabUnSelect = [_btnpower.titleLabel textColor];//UIColorFromRGB(0xBFBFBF);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->width = self->_viewTabTop.frame.size.width/3;
        self->enduranceFrame = self->_btnEndurance.frame;
        self->muscleFrame = self->_btnMuscle.frame;
        self->powerFrame = self->_btnpower.frame;
        
        [self setUpTab];
        [self charaterStartingAnimation];
    });
    
    cellBlackBorder = [CAShapeLayer layer];
    
    serviceManager = [[ServiceManager alloc] init];
    [serviceManager setDelegate: self];
    
    utils = [[Utils alloc] init];
    
    dicUserDetails = [[NSMutableDictionary alloc] initWithDictionary: [Utils getUserDetails]];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(startLastExerciseTimeTimer) name: nSET_LAST_EXERCISE_TIME object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(startTotalTimeTimer) name: nSET_TOTAL_TIME object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(startRestTimeTimer) name: nREST_TOTAL_TIME object: nil];
    
    arrShortMonthsName = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"];
    
    flagFirstPage = FALSE;
    flagSecondPage = FALSE;
    currentPage = 1;
    isEndDraggingMethodCalled = FALSE;
    [self tabBarSetup];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NewNotificationAPI:) name:HasNewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateTabBadge:) name:UpdateTabBarBadge object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HasNewNotification object:nil];
    
    // Adjust ScrollView Inset
    if (@available(iOS 11.0, *)) {
        [self.scrollViewWorkoutCompleteScreen setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self callGetTotalWorkout];
    
    // Temp
//    [self tempButton];
    
    if ([WCSession isSupported]) {
        
        WCSession *session = [WCSession defaultSession];
        
        session.delegate = self;
        
        [session activateSession];
        
    }
    if (@available(iOS 11.0, *)) {
         [self setNeedsUpdateOfHomeIndicatorAutoHidden];
    }
    isWarmUpFlag = false;
    
    // Vsn - 19/02/2020
    if(((AppDelegate *)[[UIApplication sharedApplication] delegate]).isLoadScreen)
    {
        [self->_vw_gymtimer_boost_your_workouts setHidden: true];
        [self->_viewWorkoutContentViewSubView setHidden: true];
        [self->_imgWelcomeBack setHidden: false];
        [self.tabBarController.tabBar setHidden: true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
//            self.viewWorkoutContentView.clipsToBounds = true;
            // Slide left - Welcome back and home contents
            CGPoint viewWorkoutContentViewSubViewCenterPoint = self->_viewWorkoutContentViewSubView.center;
            [self->_viewWorkoutContentViewSubView setHidden: false];
            [self->_viewWorkoutContentViewSubView setCenter:CGPointMake(self->_viewWorkoutContentViewSubView.center.x + UIScreen.mainScreen.bounds.size.width, self->_viewWorkoutContentViewSubView.center.y)];
            [UIView animateWithDuration:0.5 animations:^{
                [self->_imgWelcomeBack setCenter: CGPointMake(self->_imgWelcomeBack.center.x - UIScreen.mainScreen.bounds.size.width, self->_imgWelcomeBack.center.y)];
                [self->_viewWorkoutContentViewSubView setCenter:viewWorkoutContentViewSubViewCenterPoint];
            }];
            
            // Slide down - GymTimer Boost your workouts
            [self->_vw_gymtimer_boost_your_workouts setHidden: false];
            [self->_vw_gymtimer_boost_your_workouts setCenter:CGPointMake(self->_vw_gymtimer_boost_your_workouts.center.x, self->_vw_gymtimer_boost_your_workouts.center.y - self->_vw_gymtimer_boost_your_workouts.frame.size.height - 50)];
            [UIView animateWithDuration:0.5 animations:^{
                [self->_vw_gymtimer_boost_your_workouts setCenter:CGPointMake(self->_vw_gymtimer_boost_your_workouts.center.x, self->_vw_gymtimer_boost_your_workouts.center.y + self->_vw_gymtimer_boost_your_workouts.frame.size.height + 50)];
            }];
            
            // Slide up -
            CGPoint tabBarControllerCenterPoint = self.tabBarController.tabBar.center;
            [self.tabBarController.tabBar setHidden:false];
            [self.tabBarController.tabBar setCenter:CGPointMake(self.tabBarController.tabBar.center.x, self.tabBarController.tabBar.center.y + self.tabBarController.tabBar.frame.size.height)];
            [UIView animateWithDuration:0.5 animations:^{
                [self.tabBarController.tabBar setCenter:tabBarControllerCenterPoint];
            }];
            ((AppDelegate *)[[UIApplication sharedApplication] delegate]).isLoadScreen = false;
//            self.viewWorkoutContentView.clipsToBounds = true;
        });
    }
}
-(BOOL)prefersHomeIndicatorAutoHidden{
    return true;
}

- (void)tempButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 200, 30)];
    [button setTitle:@"Transfer Data" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor grayColor]];
    [button addTarget:self action:@selector(tempAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)tempAction {
    if ([WCSession isSupported]) {
        
        WCSession *session = [WCSession defaultSession];
        
        if ([session isPaired]) { // isPaired returns YES if the Watch is paired with iPhone (does not support the other way, so cannot be used in watch extension)
            
            NSDictionary *applicationDict = [Utils getUserDetails];
            
            NSError *error = nil;
            
            [session updateApplicationContext:applicationDict error:&error];
            
            if (error) {
                NSLog(@"Unable to send Dictionary to Watch with error: %@",error.localizedDescription);
            }
        } else {
            NSLog(@"iPhone is not paired with Watch");
        }
    } else {
        NSLog(@"WCSession is not supported with this OS version.");
    }
}

- (void)charaterStartingAnimation {
    
    [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.45 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [[self imgEndurance] setFrame: CGRectMake(self.imgEndurance.frame.origin.x, 10.0, self.imgEndurance.frame.size.width, self.imgEndurance.frame.size.height)];
        [[self view] layoutIfNeeded];
    } completion:^(BOOL finished) {
        self->selectedSlideUpImage = 0;
    }];
        
    [UIView animateWithDuration:0.7 delay:0.25 usingSpringWithDamping:0.45 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [[self imgMuscle] setFrame: CGRectMake(self.imgMuscle.frame.origin.x, 10.0, self.imgMuscle.frame.size.width, self.imgMuscle.frame.size.height)];
        [[self view] layoutIfNeeded];
    } completion:^(BOOL finished) {
        self->selectedSlideUpImage = 0;
    }];
    
    [UIView animateWithDuration:0.7 delay:0.5 usingSpringWithDamping:0.45 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [[self imgPower] setFrame: CGRectMake(self.imgPower.frame.origin.x, 10.0, self.imgPower.frame.size.width, self.imgPower.frame.size.height)];
        [[self view] layoutIfNeeded];
    } completion:^(BOOL finished) {
        self->selectedSlideUpImage = 0;
    }];
}

- (void)UpdateTabBadge:(NSNotification *)notification{
    [self showHideTabBarBadge];
}

- (void)NewNotificationAPI:(NSNotification *)notification{
    
    NSMutableDictionary *dicUserDetails = [[NSMutableDictionary alloc] initWithDictionary: [Utils getUserDetails]];
    
    NSArray *FriendCountParams = @[
        @{ @"user_id" : [dicUserDetails valueForKey: @"id"]}
    ];
    
    if ([Utils isConnectedToInternet]) {
        NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uFRIEND_COUNT];
        [serviceManager callWebServiceWithPOST: webpath withTag: tFRIEND_COUNT params: FriendCountParams];
    }
    
}


- (void)showHideTabBarBadge{
    
    UITabBarItem *tabBarItem1 = [self.tabBarController.tabBar.items objectAtIndex:1];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:HasNewNotification]) {
        tabBarItem1.badgeValue = @" ";
    }else{
        tabBarItem1.badgeValue = @"-";
    }
    
    for (int i = 0; i<self.tabBarController.tabBar.subviews.count; i++) {
        for (UIView *badgeView in self.tabBarController.tabBar.subviews[i].subviews) {
            if([NSStringFromClass(badgeView.classForCoder) isEqualToString:@"_UIBadgeView"] ){
                
                BOOL HasNotify = NO;
                if(badgeView.subviews.count > 0){
                    for (int k=0; k<badgeView.subviews.count; k++) {
                        if([NSStringFromClass(badgeView.subviews[k].class) isEqual: @"UILabel"]){
                            if ([[(UILabel *)badgeView.subviews[k] text] isEqualToString:@" "]) {
                                HasNotify = YES;
                            }else{
                                HasNotify = NO;
                            }
                        }
                    }
                    
                }else{
                    HasNotify = NO;
                }
                
                [badgeView setClipsToBounds:YES];
                badgeView.layer.transform = CATransform3DIdentity;
                
                if (IS_IPHONEXR || IS_IPHONEX) {
                    badgeView.layer.transform = CATransform3DMakeTranslation(8.0, 44.0, 1.0);
                } else if (IS_IPHONE8PLUS) {
                    badgeView.layer.transform = CATransform3DMakeTranslation(12.0, 25.0, 1.0);
                } else if (IS_IPHONE8) {
                    badgeView.layer.transform = CATransform3DMakeTranslation(10.0, 38.0, 1.0);
                } else {
                    badgeView.layer.transform = CATransform3DMakeTranslation(10.0, 26.0, 1.0);
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    self->cellBlackBorder.strokeColor = [UIColor whiteColor].CGColor;
                    self->cellBlackBorder.fillColor = [UIColor redColor].CGColor;
                    
                    self->cellBlackBorder.lineWidth = 2.2;
                    [self->cellBlackBorder setFillMode: kCAMediaTimingFunctionEaseIn];
                    CGRect frame = badgeView.bounds;
                    frame.size.height = 12;
                    frame.size.width = 12;
                    
                    self->cellBlackBorder.path = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:badgeView.frame.size.width / 2].CGPath;
                    [self->cellBlackBorder removeFromSuperlayer];
                    
                    if(HasNotify){
                        [badgeView.layer addSublayer:self->cellBlackBorder];
                    }
                });
                
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    for (UIView *obj in [self.tabBarController.view subviews]) {
        if (obj.tag == 101) {
            [obj removeFromSuperview];
        }
    }
    
    isFirstpage = true;
    isSecondpage = false;
    
    isStartWorkoutButtonTapped = @"NO";
    isSetScreen = @"YES";
    isBottomButtonsViewOpen = @"NO";
    isScrollingByButtons = @"NO";
    isEndWorkoutButtonTapped = @"NO";
    
    [self setupStartWorkoutLayout];
    [self initializeData];
    
    if ([[Utils getIsPaidUser] isEqualToString: @"YES"]) {
        [self callMakeProUserAPI];
    }
    
    if (![isEndWorkoutButtonTapped isEqualToString: @"YES"]) {
        if (IS_IPHONE8) {
            [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - 80.0), DEVICE_WIDTH, 80.0)];
            [self.view layoutSubviews];
        }
    }
}

- (void)viewWillLayoutSubviews {
    
    if (![isEndWorkoutButtonTapped isEqualToString: @"YES"]) {
        if (IS_IPHONEXR || IS_IPHONEX) {
            [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - 88.0), DEVICE_WIDTH, 88.0)];
        } else if (IS_IPHONE8) {
            if (@available(iOS 11.0, *)) {
                [self.scrollViewSetAndRestScreen setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
            } else {
                [self setAutomaticallyAdjustsScrollViewInsets:NO];
            }
            
            [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - 80.0), DEVICE_WIDTH, 80.0)];
        }
        // Vsn - 13/03/2020
        else if (IS_IPHONE8PLUS)
        {
            [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - 75.0), DEVICE_WIDTH, 75.0)];
        }
    }
}

- (void)tabBarSetup {
    UITabBarItem *tabBarItem0 = [self.tabBarController.tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem1 = [self.tabBarController.tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem2 = [self.tabBarController.tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem3 = [self.tabBarController.tabBar.items objectAtIndex:3];
    
    if (@available(iOS 13.0, *)) {
        if (IS_IPHONEXR || IS_IPHONEX) {
            
            [tabBarItem0 setTitlePositionAdjustment: UIOffsetMake(15.0, 12.0)];
            [tabBarItem1 setTitlePositionAdjustment: UIOffsetMake(3.0, 12.0)];
            [tabBarItem2 setTitlePositionAdjustment: UIOffsetMake(-3.0, 12.0)];
            [tabBarItem3 setTitlePositionAdjustment: UIOffsetMake(-15.0, 12.0)];
            
        } else if (IS_IPHONE8PLUS) {
            // Vsn - 13/03/2020
//            [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - 68.0), DEVICE_WIDTH, 68.0)];
            [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - 75.0), DEVICE_WIDTH, 75.0)];
            [tabBarItem0 setTitlePositionAdjustment: UIOffsetMake(0.0, -6.0)];
            [tabBarItem0 setImageInsets: UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
            [tabBarItem1 setTitlePositionAdjustment: UIOffsetMake(0.0, -6.0)];
            [tabBarItem1 setImageInsets: UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
            [tabBarItem2 setTitlePositionAdjustment: UIOffsetMake(0.0, -6.0)];
            [tabBarItem2 setImageInsets: UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
            [tabBarItem3 setTitlePositionAdjustment: UIOffsetMake(0.0, -6.0)];
            [tabBarItem3 setImageInsets: UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        } else if (IS_IPHONE8) {
            [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - 80.0), DEVICE_WIDTH, 80.0)];
            
            [tabBarItem0 setTitlePositionAdjustment: UIOffsetMake(10.0, -20.0)];
            [tabBarItem0 setImageInsets: UIEdgeInsetsMake(-8.0, 2.0, 2.0 ,2.0)];
            [tabBarItem1 setTitlePositionAdjustment: UIOffsetMake(3.0, -20.0)];
            [tabBarItem1 setImageInsets: UIEdgeInsetsMake(-8.0, 2.0, 2.0 ,2.0)];
            [tabBarItem2 setTitlePositionAdjustment: UIOffsetMake(-3.0, -20.0)];
            [tabBarItem2 setImageInsets: UIEdgeInsetsMake(-8.0, 2.0, 2.0 ,2.0)];
            [tabBarItem3 setTitlePositionAdjustment: UIOffsetMake(-10.0, -20.0)];
            [tabBarItem3 setImageInsets: UIEdgeInsetsMake(-8.0, 2.0, 2.0 ,2.0)];
            
        } else {
            
            [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - 56.0), DEVICE_WIDTH, 56.0)];
            
            [tabBarItem0 setTitlePositionAdjustment: UIOffsetMake(0.0, -2.0)];
            [tabBarItem0 setImageInsets: UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)];
            [tabBarItem1 setTitlePositionAdjustment: UIOffsetMake(0.0, -2.0)];
            [tabBarItem1 setImageInsets: UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)];
            [tabBarItem2 setTitlePositionAdjustment: UIOffsetMake(0.0, -2.0)];
            [tabBarItem2 setImageInsets: UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)];
            [tabBarItem3 setTitlePositionAdjustment: UIOffsetMake(0.0, -2.0)];
            [tabBarItem3 setImageInsets: UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)];
        }
    } else {
        if (IS_IPHONEXR || IS_IPHONEX) {
            
            [tabBarItem0 setTitlePositionAdjustment: UIOffsetMake(15.0, 12.0)];
            [tabBarItem1 setTitlePositionAdjustment: UIOffsetMake(3.0, 12.0)];
            [tabBarItem2 setTitlePositionAdjustment: UIOffsetMake(-3.0, 12.0)];
            [tabBarItem3 setTitlePositionAdjustment: UIOffsetMake(-15.0, 12.0)];
            
        } else if (IS_IPHONE8PLUS) {
            // Vsn - 13/03/2020
//            [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - 68.0), DEVICE_WIDTH, 68.0)];
            [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - 75.0), DEVICE_WIDTH, 75.0)];

            [tabBarItem0 setImage:[[UIImage imageNamed:@"gray_workout_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [tabBarItem0 setSelectedImage:[[UIImage imageNamed:@"green_workout_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [tabBarItem1 setImage:[[UIImage imageNamed:@"gray_rank_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [tabBarItem1 setSelectedImage:[[UIImage imageNamed:@"green_rank_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [tabBarItem2 setImage:[[UIImage imageNamed:@"gray_stats_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [tabBarItem2 setSelectedImage:[[UIImage imageNamed:@"green_stats_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [tabBarItem3 setImage:[[UIImage imageNamed:@"gray_setting_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [tabBarItem3 setSelectedImage:[[UIImage imageNamed:@"green_setting_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            
            [tabBarItem0 setTitlePositionAdjustment: UIOffsetMake(0.0, -2.0)];
            [tabBarItem0 setImageInsets: UIEdgeInsetsMake(-2.0, 0.0, 0.0, 0.0)];
            [tabBarItem1 setTitlePositionAdjustment: UIOffsetMake(0.0, -2.0)];
            [tabBarItem1 setImageInsets: UIEdgeInsetsMake(-2.0, 0.0, 0.0, 0.0)];
            [tabBarItem2 setTitlePositionAdjustment: UIOffsetMake(0.0, -2.0)];
            [tabBarItem2 setImageInsets: UIEdgeInsetsMake(-2.0, 0.0, 0.0, 0.0)];
            [tabBarItem3 setTitlePositionAdjustment: UIOffsetMake(0.0, -2.0)];
            [tabBarItem3 setImageInsets: UIEdgeInsetsMake(-2.0, 0.0, 0.0, 0.0)];
        } else if (IS_IPHONE8) {
            [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - 80.0), DEVICE_WIDTH, 80.0)];
            
            [tabBarItem0 setImage:[[UIImage imageNamed:@"gray_workout"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [tabBarItem0 setSelectedImage:[[UIImage imageNamed:@"green_workout"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [tabBarItem1 setImage:[[UIImage imageNamed:@"gray_rank"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [tabBarItem1 setSelectedImage:[[UIImage imageNamed:@"green_rank"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [tabBarItem2 setImage:[[UIImage imageNamed:@"gray_stats"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [tabBarItem2 setSelectedImage:[[UIImage imageNamed:@"green_stats"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [tabBarItem3 setImage:[[UIImage imageNamed:@"gray_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [tabBarItem3 setSelectedImage:[[UIImage imageNamed:@"green_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            
            [tabBarItem0 setTitlePositionAdjustment: UIOffsetMake(10.0, -20.0)];
            [tabBarItem0 setImageInsets: UIEdgeInsetsMake(-20.0, 0.0, 0.0, 0.0)];
            [tabBarItem1 setTitlePositionAdjustment: UIOffsetMake(3.0, -20.0)];
            [tabBarItem1 setImageInsets: UIEdgeInsetsMake(-20.0, 0.0, 0.0, 0.0)];
            [tabBarItem2 setTitlePositionAdjustment: UIOffsetMake(-3.0, -20.0)];
            [tabBarItem2 setImageInsets: UIEdgeInsetsMake(-20.0, 0.0, 0.0, 0.0)];
            [tabBarItem3 setTitlePositionAdjustment: UIOffsetMake(-10.0, -20.0)];
            [tabBarItem3 setImageInsets: UIEdgeInsetsMake(-20.0, 0.0, 0.0, 0.0)];
            
        } else {
            
            [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - 56.0), DEVICE_WIDTH, 56.0)];
            
            [tabBarItem0 setImage:[[UIImage imageNamed:@"gray_workout_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [tabBarItem0 setSelectedImage:[[UIImage imageNamed:@"green_workout_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [tabBarItem1 setImage:[[UIImage imageNamed:@"gray_rank_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [tabBarItem1 setSelectedImage:[[UIImage imageNamed:@"green_rank_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [tabBarItem2 setImage:[[UIImage imageNamed:@"gray_stats_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [tabBarItem2 setSelectedImage:[[UIImage imageNamed:@"green_stats_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [tabBarItem3 setImage:[[UIImage imageNamed:@"gray_setting_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [tabBarItem3 setSelectedImage:[[UIImage imageNamed:@"green_setting_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            
            [tabBarItem0 setTitlePositionAdjustment: UIOffsetMake(0.0, -2.0)];
            [tabBarItem0 setImageInsets: UIEdgeInsetsMake(-2.0, 0.0, 0.0, 0.0)];
            [tabBarItem1 setTitlePositionAdjustment: UIOffsetMake(0.0, -2.0)];
            [tabBarItem1 setImageInsets: UIEdgeInsetsMake(-2.0, 0.0, 0.0, 0.0)];
            [tabBarItem2 setTitlePositionAdjustment: UIOffsetMake(0.0, -2.0)];
            [tabBarItem2 setImageInsets: UIEdgeInsetsMake(-2.0, 0.0, 0.0, 0.0)];
            [tabBarItem3 setTitlePositionAdjustment: UIOffsetMake(0.0, -2.0)];
            [tabBarItem3 setImageInsets: UIEdgeInsetsMake(-2.0, 0.0, 0.0, 0.0)];
        }
    }
    
    [[[self.tabBarController tabBar] layer] setBorderWidth:1.0];
    [[[self.tabBarController tabBar] layer] setBorderColor: [[UIColor lightGrayColor] CGColor]];
    //    [[[self.tabBarController tabBar] layer] setBorderWidth:2.0];
}

//MARK:- UIScrollView methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"Did end Decelerating...");
    
    if (![isEndWorkoutButtonTapped isEqualToString: @"YES"]) {
        
        if (scrollView == _scrollViewSetAndRestScreen) {
            
            if (isEndDraggingMethodCalled) {
                
                if ([scrollView contentOffset].y < -44.0) {
                    NSLog(@"Less than -44.0");
                    
                    [UIView animateWithDuration: 0.5 delay: 0.0 options: UIViewAnimationOptionCurveLinear animations:^{
                        if (IS_IPHONEXR) {
                            [scrollView setContentOffset: CGPointMake(0.0, 0.0) animated: NO];
                        } else if (IS_IPHONEX) {
                            [scrollView setContentOffset: CGPointMake(0.0, -44.0) animated: NO];
                        } else if (IS_IPHONE8PLUS) {
                            [scrollView setContentOffset: CGPointMake(0.0, -44.0) animated: NO];
                        } else if (IS_IPHONE8) {
                            [scrollView setContentOffset: CGPointMake(0.0, 0.0) animated: NO];
                        } else {
                            [scrollView setContentOffset: CGPointMake(0.0, -44.0) animated: NO];
                        }
                    } completion:^(BOOL finished) {}];
                    
                    //        [scrollView setContentOffset: CGPointMake(0.0, -44.0) animated:YES];
                    
                } else {
                    
                    NSNumber* currentIndex = [NSNumber numberWithInt: (scrollView.contentOffset.y / 152.0)];
                    if ([currentIndex boolValue]) {
                        
                        NSLog(@"current index true");
                        [UIView animateWithDuration: 0.5 delay: 0.0 options: UIViewAnimationOptionCurveLinear animations:^{
                            if (IS_IPHONEXR) {
                                [scrollView setContentOffset: CGPointMake(0.0, 290.0) animated: NO];
                            } else if (IS_IPHONEX) {
                                [scrollView setContentOffset: CGPointMake(0.0, 304.0) animated: NO];
                            } else if (IS_IPHONE8PLUS) {
                                [scrollView setContentOffset: CGPointMake(0.0, 364.0) animated: NO];
                            } else if (IS_IPHONE8) {
                                //                                [scrollView setContentOffset: CGPointMake(0.0, 300.0) animated: NO];
                            } else {
                                [scrollView setContentOffset: CGPointMake(0.0, 420.0) animated: NO];
                            }
                        } completion:^(BOOL finished) {}];
                        //            [scrollView setContentOffset: CGPointMake(0.0, 304.0) animated:YES];
                    } else {
                        
                        NSLog(@"current index false");
                        [UIView animateWithDuration: 0.3 delay: 0.0 options: UIViewAnimationOptionCurveLinear animations:^{
                            if (IS_IPHONEXR) {
                                [scrollView setContentOffset: CGPointMake(0.0, -44.0) animated: NO];
                            } else if (IS_IPHONEX) {
                                [scrollView setContentOffset: CGPointMake(0.0, -44.0) animated: NO];
                            } else if (IS_IPHONE8PLUS) {
                                [scrollView setContentOffset: CGPointMake(0.0, -44.0) animated: NO];
                            } else if (IS_IPHONE8) {
                                [scrollView setContentOffset: CGPointMake(0.0, 0.0) animated: NO];
                            } else {
                                [scrollView setContentOffset: CGPointMake(0.0, -44.0) animated: NO];
                            }
                        } completion:^(BOOL finished) {}];
                        //            [scrollView setContentOffset: CGPointMake(0.0, -44.0) animated:YES];
                    }
                }
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    isEndDraggingMethodCalled = TRUE;
    
    if (![isEndWorkoutButtonTapped isEqualToString: @"YES"]) {
        
        if (scrollView == _scrollViewSetAndRestScreen) {
            
            if ([scrollView contentOffset].y < -44.0) {
                NSLog(@"Less than -44.0 here");
            } else {
                
                NSNumber* currentIndex = [NSNumber numberWithInt: (scrollView.contentOffset.y / 152.0)];
                if ([currentIndex boolValue]) {
                    
                    NSLog(@"current index true");
                } else {
                    NSLog(@"current index false");
                }
            }
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    if (![isEndWorkoutButtonTapped isEqualToString: @"YES"]) {
        
        if (scrollView == _scrollViewSetAndRestScreen) {
            
            if ([isScrollingByButtons isEqualToString: @"NO"]) {
                if ([scrollView contentOffset].y < 152.0) {
                    
                    isBottomButtonsViewOpen = @"NO";
                    
                    [UIView animateWithDuration: 0.8 delay: 0.0 options: UIViewAnimationOptionCurveLinear animations:^{
                        if (IS_IPHONEXR) {
                            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: YES];
                        } else if (IS_IPHONEX) {
                            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: YES];
                        } else if (IS_IPHONE8PLUS) {
                            //[self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: YES];
                        } else if (IS_IPHONE8) {
                            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, 0.0) animated: NO];
                        } else {
                            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: YES];
                        }
                    } completion:^(BOOL finished) {}];
                    
                } else {
                    
                    isBottomButtonsViewOpen = @"YES";
                    
                    [UIView animateWithDuration: 0.8 delay: 0.0 options: UIViewAnimationOptionCurveLinear animations:^{
                        if (IS_IPHONEXR) {
                            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, 250.0) animated: YES];
                        } else if (IS_IPHONEX) {
                            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, 304.0) animated: YES];
                        } else if (IS_IPHONE8PLUS) {
                            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, 364.0) animated: YES];
                        } else if (IS_IPHONE8) {
                            //                            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, 300.0) animated: YES];
                        } else {
                            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, 420.0) animated: YES];
                        }
                    } completion:^(BOOL finished) {}];
                }
            }
        }
    }
    isScrollingByButtons = @"NO";
}


//MARK:- Button's action methods

-(void)setUpTab{
    
    //    CGFloat width = _viewTabTop.frame.size.width/3;
    //
    //    CGRect enduranceFrame = _btnEndurance.frame;
    //    CGRect muscleFrame = _btnMuscle.frame;
    //    CGRect powerFrame = _btnpower.frame;
    
    enduranceFrame.size.width = width;
    enduranceFrame.origin.x = 0;
    
    muscleFrame.size.width = width;
    muscleFrame.origin.x = width;
    
    powerFrame.size.width = width;
    powerFrame.origin.x = width*2;
    
    [_btnEndurance setFrame:enduranceFrame];
    [_btnMuscle setFrame:muscleFrame];
    [_btnpower setFrame:powerFrame];
    
    [_viewTabMovable setFrame:enduranceFrame];
    
    [[_viewTabMovable layer] setCornerRadius:_viewTabMovable.frame.size.height/2];
    [[_viewTabTop layer] setCornerRadius:_viewTabTop.frame.size.height/2];
    [[_viewTabParent layer] setCornerRadius:_viewTabTop.frame.size.height/2];
    [[_viewHideShow layer] setCornerRadius:_viewTabTop.frame.size.height/2];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIBezierPath *enduranceShadow = [UIBezierPath bezierPathWithRoundedRect:[self->_viewTabParent bounds] cornerRadius:self->_viewTabTop.frame.size.height/2];
        
        
        CGRect endu = self->_imgEndurance.frame;
        endu.origin.x = self->_viewTabParent.frame.origin.x; //+ (self->width / 3.0);
        endu.size.width = self->width;
        [self->_imgEndurance setFrame:endu];
        
        CGRect mus = self->_imgMuscle.frame;
        mus.origin.x = endu.size.width + endu.origin.x;
        mus.size.width = self->width;
        [self->_imgMuscle setFrame:mus];
        
        CGRect pow = self->_imgPower.frame;
        pow.origin.x = mus.origin.x + mus.size.width;
        pow.size.width = self->width;
        [self->_imgPower setFrame:pow];
        
        self->_viewTabParent.layer.cornerRadius = self->_viewTabTop.frame.size.height/2;
        [self->_viewTabParent setClipsToBounds:YES];
        [[self->_viewTabParent layer] setMasksToBounds: NO];
        [[self->_viewTabParent layer] setShadowColor: [[UIColor blackColor] CGColor]];
        [[self->_viewTabParent layer] setShadowOffset: CGSizeMake(0.0, 2.0)];
        [[self->_viewTabParent layer] setShadowRadius: 5.0];
        [[self->_viewTabParent layer] setShadowOpacity: 0.1];
        [[self->_viewTabParent layer] setShadowPath: [enduranceShadow CGPath]];
    });
    
}

- (IBAction)btnEnduranceClick:(UIButton *)sender{
    
    [UIView animateWithDuration:0.2 animations:^{
        [self->_viewTabMovable setFrame:self->enduranceFrame];
        [self.view layoutIfNeeded];
    }];
    
    //    [_lblRange1 setText:@"1-3"];
    //    [_lblRange2 setText:@"6-12"];
    
    [self.lblRange1 countFrom:[_lblRange1.text integerValue] to:1 withDuration:0.4];
    self.lblRange1.text = @"1";
    
    [self.lblRange11 countFrom:[_lblRange11.text integerValue] to:3 withDuration:0.4];
    self.lblRange11.text = @"3";
    
    [self.lblRange2 countFrom:[_lblRange2.text integerValue] to:10 withDuration:0.4];
    self.lblRange2.text = @"10";
    
    [self.lblRange22 countFrom:[_lblRange22.text integerValue] to:20 withDuration:0.4];
    self.lblRange22.text = @"20";
    
    
    [_btnEndurance setTitleColor:colorTabSelect forState:UIControlStateNormal];
    [_btnMuscle setTitleColor:colorTabUnSelect forState:UIControlStateNormal];
    [_btnpower setTitleColor:colorTabUnSelect forState:UIControlStateNormal];
}

- (IBAction)btnMuscleClick:(UIButton *)sender{
    
    [UIView animateWithDuration:0.2 animations:^{
        [self->_viewTabMovable setFrame:self->muscleFrame];
        [self.view layoutIfNeeded];
    }];
    
    //    [_lblRange1 setText:@"3-6"];
    //    [_lblRange2 setText:@"4-6"];
    
    [self.lblRange1 countFrom:[_lblRange1.text integerValue] to:3 withDuration:0.4];
    self.lblRange1.text = @"3";
    
    [self.lblRange11 countFrom:[_lblRange11.text integerValue] to:6 withDuration:0.4];
    self.lblRange11.text = @"6";
    
    [self.lblRange2 countFrom:[_lblRange2.text integerValue] to:6 withDuration:0.4];
    self.lblRange2.text = @"6";
    
    [self.lblRange22 countFrom:[_lblRange22.text integerValue] to:10 withDuration:0.4];
    self.lblRange22.text = @"10";
    
    [_btnEndurance setTitleColor:colorTabUnSelect forState:UIControlStateNormal];
    [_btnMuscle setTitleColor:colorTabSelect forState:UIControlStateNormal];
    [_btnpower setTitleColor:colorTabUnSelect forState:UIControlStateNormal];
    
}

- (IBAction)btnPowerClick:(UIButton *)sender{
    
    [UIView animateWithDuration:0.2 animations:^{
        [self->_viewTabMovable setFrame:self->powerFrame];
        [self.view layoutIfNeeded];
    }];
    
    //    [_lblRange1 setText:@"6-10"];
    //    [_lblRange2 setText:@"1-4"];
    
    [self.lblRange1 countFrom:[_lblRange1.text integerValue] to:6 withDuration:0.4];
    self.lblRange1.text = @"6";
    
    [self.lblRange11 countFrom:[_lblRange11.text integerValue] to:9 withDuration:0.4];
    self.lblRange11.text = @"9";
    
    [self.lblRange2 countFrom:[_lblRange2.text integerValue] to:1 withDuration:0.4];
    self.lblRange2.text = @"1";
    
    [self.lblRange22 countFrom:[_lblRange22.text integerValue] to:6 withDuration:0.4];
    self.lblRange22.text = @"6";
    
    [_btnEndurance setTitleColor:colorTabUnSelect forState:UIControlStateNormal];
    [_btnMuscle setTitleColor:colorTabUnSelect forState:UIControlStateNormal];
    [_btnpower setTitleColor:colorTabSelect forState:UIControlStateNormal];
    
}

- (IBAction)btnStartWorkoutButtonTapped:(UIButton *)sender {
    isFromNextExercise = NO;
        
    AudioServicesPlaySystemSoundWithCompletion(1520, nil);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSString *strCurrentDateTime = [dateFormatter stringFromDate: [NSDate date]];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    if([sender.titleLabel.text isEqualToString:@"Start Workout"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:[dateFormatter stringFromDate:[NSDate date]] forKey:kWORKOUT_TIME];
        [[NSUserDefaults standardUserDefaults] setValue: strCurrentDateTime forKey: kWORKOUT_START_TIME];
    }
    
    isStartWorkoutButtonTapped = @"YES";
    isSetScreen = @"YES";
    isBottomButtonsViewOpen = @"NO";
    isEndWorkoutButtonTapped = @"YES";
    [_btnStartRestButton setUserInteractionEnabled: YES];
    [self toogleSetAndRestScreens];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey: @"isEndWOButtonClicked"] isEqualToString: @"YES"] ||
        [[NSUserDefaults standardUserDefaults] valueForKey: @"isEndWOButtonClicked"] == nil) {
        self.vwQualityProgress.value = 0.0;
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:kQUALITY_SET_COUNT];
        [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: @"isEndWOButtonClicked"];
        [[NSUserDefaults standardUserDefaults] setValue: @"00:00:00" forKey: kTOTAL_TIME];
        NSString *strCurrentExerciseTime = [[NSUserDefaults standardUserDefaults] valueForKey: kTOTAL_TIME];
        [self convertTotalTimeToSecondsFrom: strCurrentExerciseTime];
        [self startRecordingTotalTime];
        
        //[[NSUserDefaults standardUserDefaults] setValue: @"00:00" forKey: kTOTAL_TIME];
        [[NSUserDefaults standardUserDefaults] setValue: @"0" forKey: kTOTAL_EXERCISE_COUNT];
        [[NSUserDefaults standardUserDefaults] setValue: @"1" forKey: kSET_COUNT];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject: [NSDate date] forKey: kSTART_TIME];
    
    [self initializeSetScreenData];
    
    [UIView animateWithDuration: 0.7 delay: 0.0 options: UIViewAnimationOptionTransitionNone animations:^{
        
        [self hideTabBar];
        
        if (IS_IPHONEXR) {
            
            [self->_scrollViewWorkoutScreen setFrame: CGRectMake(-DEVICE_WIDTH, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
            [self->_scrollViewSetAndRestScreen setFrame: CGRectMake(0.0, -44.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: YES];
            
        } else if (IS_IPHONEX) {
            
            [self->_scrollViewWorkoutScreen setFrame: CGRectMake(-DEVICE_WIDTH, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
            [self->_scrollViewSetAndRestScreen setFrame: CGRectMake(0.0, -44.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: YES];
            
        } else if (IS_IPHONE8PLUS) {
            
            [self->_scrollViewWorkoutScreen setFrame: CGRectMake(-DEVICE_WIDTH, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
            [self->_scrollViewSetAndRestScreen setFrame: CGRectMake(0.0, -44.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: YES];
            
        } else if (IS_IPHONE8) {
            
            [self->_scrollViewWorkoutScreen setFrame: CGRectMake(-DEVICE_WIDTH, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
            [self->_scrollViewSetAndRestScreen setFrame: CGRectMake(0.0, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, 0.0) animated: YES];
            
        } else {
            
            [self->_scrollViewWorkoutScreen setFrame: CGRectMake(-DEVICE_WIDTH, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
            [self->_scrollViewSetAndRestScreen setFrame: CGRectMake(0.0, -44.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: YES];
        }
    } completion:^(BOOL finished) {
        //        [self hideTabBar];
    }];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:kTOTAL_TIME] isEqual:@"00:00:00"]) {
        [_viewLastExerciseMinuteFormat setHidden:YES];
        [_viewLastExerciseHoursFormat setHidden:YES];
        [_lblSinceLastExerciseLabel setHidden:YES];
    }
    
    [UIView transitionWithView: _imgAppBackgroundImage duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
        int totoalExerciseCount = [[[NSUserDefaults standardUserDefaults] valueForKey: kTOTAL_EXERCISE_COUNT] intValue];
        if (totoalExerciseCount == 0) {
            [self->_imgAppBackgroundImage setImage: iWARMUP_SCREEN];
            [self->warmUpView.contentView setHidden:NO];
            [self->warmUpView.vwWarmUp setHidden:NO];
            //[_viewSetAndRestScreenProgressBackgroundView setHidden:YES];
            [self->_vwWarmUp setHidden:NO];
        } else {
            [self->_imgAppBackgroundImage setImage: iWELCOME_SCREEN];
        }
        
    } completion:^(BOOL finished) {}];
    //[[NSUserDefaults standardUserDefaults] setValue: @"00:00:00" forKey: kTOTAL_TIME];
    
    // Vsn - 12/02/2020
    if(isWarmUpFlag)
    {
        [self btnNextExerciseButtonTapped: [[UIButton alloc] init]];
    }
}

- (IBAction)btnSwipeButtonTapped:(UIButton *)sender {
    
    isScrollingByButtons = @"YES";
    isBottomButtonsViewOpen = ([isBottomButtonsViewOpen isEqualToString: @"YES"]) ? @"NO" : @"YES";
    
    if ([isBottomButtonsViewOpen isEqualToString: @"NO"]) {
        
        if (IS_IPHONEXR) {
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: YES];
        } else if (IS_IPHONEX) {
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: YES];
        } else if (IS_IPHONE8PLUS) {
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: YES];
        } else if (IS_IPHONE8) {
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, 0.0) animated: YES];
        } else {
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: YES];
        }
        
    } else if ([isBottomButtonsViewOpen isEqualToString: @"YES"]) {
        
        if (IS_IPHONEXR) {
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, 290.0) animated: YES];
        } else if (IS_IPHONEX) {
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, 304.0) animated: YES];
        } else if (IS_IPHONE8PLUS) {
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, 364.0) animated: YES];
        } else if (IS_IPHONE8) {
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, 350.0) animated: YES];
        } else {
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: YES];
        }
        
    } else {}
    
}

- (IBAction)btnNextExerciseButtonTapped:(UIButton *)sender {
    //[_viewSetAndRestScreenProgressBackgroundView setHidden:NO];
    self.lblClickAnywhereToRestLabel.text = @"(click anywhere to start your next exercise)";
    [self.lblClickAnywhereToRestLabel setTextColor:GreenTextColor];
    
    //DINAL-11-02-2020
    // Vsn - 14/02/2020
    if(!self->isWarmUpFlag)
    {
        lastExerciseSec = 0;
        lastExerciseMin = 0;
        lastExerciseHour = 0;
        self.lblTimeSince.text = @"00:00";
        isNextExerciseStart = YES;
    }
    
    AudioServicesPlaySystemSoundWithCompletion(1520, nil);
        
    isScrollingByButtons = @"YES";
    isBottomButtonsViewOpen = @"NO";
    
    [_btnStartRestButton setUserInteractionEnabled: YES];
    
    [timerForRest reset];
    [_timerRest invalidate];
    _timerRest = nil;
    _isRestTimerRunning = @"NO";
    
    [self setupProgressBar];
    
    // Set workout quality
    if ([NSUserDefaults.standardUserDefaults.dictionaryRepresentation.allKeys containsObject:kQUALITY_SET_COUNT]) {
        int setCount = [[[NSUserDefaults standardUserDefaults] valueForKey:kQUALITY_SET_COUNT] intValue];
        setCount = setCount + 1;
        
        // Store in UserDefault
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d", setCount] forKey:kQUALITY_SET_COUNT];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: kPLAY_SOUND];
    [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: kREST_TIMER_STATUS];
    [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: @"isEndWOButtonClicked"];
    
    isSetScreen = @"YES";
    [self toogleSetAndRestScreens];
    
    [UIView animateWithDuration: 0.7 delay: 0.0 options: UIViewAnimationOptionTransitionNone animations:^{
        
        if (IS_IPHONEXR) {
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: NO];
        } else if (IS_IPHONEX) {
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: NO];
        } else if (IS_IPHONE8PLUS) {
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: NO];
        } else if (IS_IPHONE8) {
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, 0.0) animated: NO];
        } else {
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: NO];
        }
        
    } completion:^(BOOL finished) {
        
        [[NSUserDefaults standardUserDefaults] setValue: @"1" forKey: kSET_COUNT];
        [self adjustFontOfDoSetCountLabel];
        [self->_lblDoSetNumberCountLabel setText: [[NSUserDefaults standardUserDefaults] valueForKey: kSET_COUNT]];
        
        int strTotalExerciseCount = [[[NSUserDefaults standardUserDefaults] valueForKey: kTOTAL_EXERCISE_COUNT] intValue];
        [[NSUserDefaults standardUserDefaults] setValue: [NSString stringWithFormat: @"%d", (strTotalExerciseCount + 1)] forKey: kTOTAL_EXERCISE_COUNT];
        [self->_lblExerciseCountLabel setText: [NSString stringWithFormat: @"%@.", [[NSUserDefaults standardUserDefaults] valueForKey: kTOTAL_EXERCISE_COUNT]]];
        
        if(!self->isWarmUpFlag)
        {
            [self->_lblLastExerciseSecondMinLabel setText: [NSString stringWithFormat: @"00"]];
            [self->_lblLastExerciseSecondSecLabel setText: [NSString stringWithFormat: @"00"]];
            [[NSUserDefaults standardUserDefaults] setValue: @"00:00:00" forKey: kLAST_EXERCISE_TIME];
            [self startLastExerciseTimeTimer];
        }
    }];
    
    [UIView transitionWithView: _imgAppBackgroundImage duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self->_imgAppBackgroundImage setImage: iWARMUP_SCREEN];
    } completion:^(BOOL finished) {}];

    [_viewSetAndRestBackgroundView setBackgroundColor: [UIColor blackColor]];
    [_viewExerciseContentView setBackgroundColor: cWARMUP_BLACK];
    [_viewTotalTimeContentView setBackgroundColor: cWARMUP_BLACK];

    if([[_viewTotalTimeContentView backgroundColor] isEqual: cWARMUP_BLACK])
    {
        [_imgNextExerciseImage setImage:[UIImage imageNamed:@"imgGrayNext"]];
        [_lblNextExerciseLabel setTextColor: [UIColor colorWithRed:97.0/255.0 green:97.0/255.0 blue:97.0/255.0 alpha:1.0]];
//        [_viewNextExerciseButtonContentView setAlpha: nextExerciseOpacity];
        [_btnNextExerciseButton setEnabled: false];
    }
    else
    {
        [_imgNextExerciseImage setImage:[UIImage imageNamed:@"imgGreenNext"]];
        [_lblNextExerciseLabel setTextColor: [UIColor whiteColor]];
        [_btnNextExerciseButton setEnabled: true];
    }
    
    [_lblExerciseLabel setTextColor: cEXERCISE_BLACK];
    [_lblTotalTimeLabel setTextColor: cEXERCISE_BLACK];

    [self.vwNextExercise setHidden:NO];
    [self.vwLastExercise setHidden:NO];
    [warmUpView.contentView setHidden:YES];
    [warmUpView.vwWarmUp setHidden:YES];
    [self.vwWarmUp setHidden:YES];
    
    isFromNextExercise = YES;
}

- (IBAction)btnChangeRestButtonTapped:(UIButton *)sender {
    
    if([[_viewTotalTimeContentView backgroundColor] isEqual: cWARMUP_BLACK])
    {
        isWarmUpFlag = true;
    }
    else
    {
        isWarmUpFlag = false;
    }
    
    AudioServicesPlaySystemSoundWithCompletion( 1520, nil);
    
    isSetScreen = @"YES";
    
    [timerForRest reset];
    [_timerRest invalidate];
    _timerRest = nil;
    _isRestTimerRunning = @"NO";
    
    [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: kPLAY_SOUND];
    [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: kREST_TIMER_STATUS];
    [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: @"isEndWOButtonClicked"];
    
    [self toogleSetAndRestScreens];
    
    [self->_scrollViewWorkoutScreen setFrame: CGRectMake(-DEVICE_WIDTH, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
    
    [UIView animateWithDuration: 0.7 delay: 0.0 options: UIViewAnimationOptionTransitionNone animations:^{
        
        //        [self showTabBar];
        
        if (IS_IPHONEXR) {
            [self->_scrollViewWorkoutScreen setFrame: CGRectMake(0.0, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
            [self->_scrollViewSetAndRestScreen setFrame: CGRectMake(DEVICE_WIDTH, -44.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
        } else if (IS_IPHONEX) {
            [self->_scrollViewWorkoutScreen setFrame: CGRectMake(0.0, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
            [self->_scrollViewSetAndRestScreen setFrame: CGRectMake(DEVICE_WIDTH, -44.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
            
        } else if (IS_IPHONE8PLUS) {
            [self->_scrollViewWorkoutScreen setFrame: CGRectMake(0.0, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
            [self->_scrollViewSetAndRestScreen setFrame: CGRectMake(DEVICE_WIDTH, -44.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
        } else if (IS_IPHONE8) {
            [self->_scrollViewWorkoutScreen setFrame: CGRectMake(0.0, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
            [self->_scrollViewSetAndRestScreen setFrame: CGRectMake(DEVICE_WIDTH, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
            
        } else {
            [self->_scrollViewWorkoutScreen setFrame: CGRectMake(0.0, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
            [self->_scrollViewSetAndRestScreen setFrame: CGRectMake(DEVICE_WIDTH, -44.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
        }
        
    } completion:^(BOOL finished) {
        
        [self initializeStartWorkoutScreenData];
        [self->_scrollViewSetAndRestScreen setFrame: CGRectMake(DEVICE_WIDTH, -44.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
        
        if (IS_IPHONEXR) {
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: YES];
        } else if (IS_IPHONEX) {
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: YES];
        } else if (IS_IPHONE8PLUS) {
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: YES];
        } else if (IS_IPHONE8) {
            [self->_scrollViewSetAndRestScreen setFrame: CGRectMake(DEVICE_WIDTH, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, 0.0) animated: YES];
        } else {
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: YES];
        }
        
    }];
    
    [UIView transitionWithView: _imgAppBackgroundImage duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self->_imgAppBackgroundImage setImage: iWELCOME_SCREEN];
    } completion:^(BOOL finished) {}];
    
}

- (IBAction)btnSoundButtonTapped:(UIButton *)sender {
    
    AudioServicesPlaySystemSoundWithCompletion(1520, nil);
    
    NSString *isSoundOn = [[NSUserDefaults standardUserDefaults] valueForKey: kIS_SOUND_ON];
    isSoundOn = ([isSoundOn isEqualToString: @"YES"]) ? @"NO" : @"YES";
    [[NSUserDefaults standardUserDefaults] setValue: isSoundOn forKey: kIS_SOUND_ON];
    
    if ([isSoundOn isEqualToString: @"YES"]) {
        UIImage *imgSoundOn = ([isSetScreen isEqualToString: @"YES"]) ? iGREEN_SOUND : iRED_SOUND;
        [_imgSoundImage setImage: imgSoundOn];
        [_lblSoundLabel setText: @"Sound: on"];
    } else if ([isSoundOn isEqualToString: @"NO"]) {
        UIImage *imgSoundOff = ([isSetScreen isEqualToString: @"YES"]) ? iGREEN_SOUND_OFF : iRED_SOUND_OFF;
        [_imgSoundImage setImage: imgSoundOff];
        [_lblSoundLabel setText: @"Sound: off"];
    } else {}
    
}

- (IBAction)btnEndWorkoutButtonTapped:(UIButton *)sender {
    
    AudioServicesPlaySystemSoundWithCompletion( 1520, nil);
    
    NSString *strTotalTime = [[NSUserDefaults standardUserDefaults] valueForKey: kTOTAL_TIME];
    NSArray *arrTimeComponents = [strTotalTime componentsSeparatedByString: @":"];
    int hours = [arrTimeComponents[0] intValue];
    int minutes = [arrTimeComponents[1] intValue];
    int seconds = [arrTimeComponents[2] intValue];
    currentWorkoutTotalTime = [NSString stringWithFormat: @"%02d:%02d:%02d", hours, minutes, seconds];
    
    // Hide short workout message if workout time greater than 5 min else not
    NSString *fiveMinute = @"00:05:00";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    NSDate *date1 = [formatter dateFromString:currentWorkoutTotalTime];
    NSDate *date2 = [formatter dateFromString:fiveMinute];
    
    NSComparisonResult result = [date1 compare:date2];
    int workout = [[Utils getTotalWorkout] intValue];
    
    if (result == NSOrderedDescending || result == NSOrderedSame) {
        [self.lblShortWorkoutMsg setHidden:YES];
        
        if (workout > 0) {
            int currentWorkout = workout + 1;
            int module = currentWorkout % 5;
            
            if (module == 0) {
                int level = (currentWorkout / 5) + 1;
                
                if (level > 99) {
                    self.lblLevel.font = [UIFont fontWithName:fFUTURA_CONDENSED_EXTRA_BOLD size:40];
                } else {
                    self.lblLevel.font = [UIFont fontWithName:fFUTURA_CONDENSED_EXTRA_BOLD size:70];
                }
                
                self.lblLevel.text = [NSString stringWithFormat:@"%d",level];
//                [self displayCongrats];
            }
        }
        NSLog(@"Workout Timer Grater Than Or Equal To 5 Min");
    } else if (result == NSOrderedAscending) {
        NSLog(@"Workout Timer Less Than 5 Min");
        // Vsn - 09/04/2020
//        [self.lblShortWorkoutMsg setHidden:NO];
        [self.lblShortWorkoutMsg setHidden:YES];
        // End
    } else {
        [self.lblShortWorkoutMsg setHidden:YES];
    }
    
    isSetScreen = @"YES";
    isEndWorkoutButtonTapped = @"YES";
    
    [timerForRest reset];
    [_timerRest invalidate];
    [_timerLastExerciseTime invalidate];
    _timerLastExerciseTime = nil;
    _timerRest = nil;
    _isRestTimerRunning = @"NO";
    
    [_timerTotalTime invalidate];
    _timerTotalTime = nil;
    
    [self initializeWorkoutCompleteScreen];
    
    [self->_scrollViewWorkoutCompleteScreen setFrame: CGRectMake(0.0, DEVICE_HEIGHT, DEVICE_WIDTH, (DEVICE_HEIGHT))];
    
    [UIView animateWithDuration: 0.7 delay: 0.0 options: UIViewAnimationOptionTransitionNone animations:^{
        
        if (IS_IPHONEXR) {
            [self->_scrollViewSetAndRestScreen setFrame: CGRectMake(0.0, -(DEVICE_HEIGHT + 44.0), DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
            [self->_scrollViewWorkoutCompleteScreen setFrame: CGRectMake(0.0, 0.0, DEVICE_WIDTH, (DEVICE_HEIGHT))];
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, 304.0) animated: YES];
        } else if (IS_IPHONEX) {
            
            [self->_scrollViewSetAndRestScreen setFrame: CGRectMake(0.0, -(DEVICE_HEIGHT + 44.0), DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
            [self->_scrollViewWorkoutCompleteScreen setFrame: CGRectMake(0.0, 0.0, DEVICE_WIDTH, (DEVICE_HEIGHT))];
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, 304.0) animated: YES];
        } else if (IS_IPHONE8PLUS) {
            [self->_scrollViewSetAndRestScreen setFrame: CGRectMake(0.0, -(DEVICE_HEIGHT + 44.0), DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
            [self->_scrollViewWorkoutCompleteScreen setFrame: CGRectMake(0.0, 0.0, DEVICE_WIDTH, (DEVICE_HEIGHT))];
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, 364.0) animated: YES];
        } else if (IS_IPHONE8) {
            [self->_scrollViewSetAndRestScreen setFrame: CGRectMake(0.0, -(DEVICE_HEIGHT + 44.0), DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
            [self->_scrollViewWorkoutCompleteScreen setFrame: CGRectMake(0.0, 0, DEVICE_WIDTH, (DEVICE_HEIGHT + 100))];
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, 350.0) animated: YES];
        } else {
            [self->_scrollViewSetAndRestScreen setFrame: CGRectMake(0.0, -(DEVICE_HEIGHT + 44.0), DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
            [self->_scrollViewWorkoutCompleteScreen setFrame: CGRectMake(0.0, 0.0, DEVICE_WIDTH, (DEVICE_HEIGHT + 100))];
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, 304.0) animated: YES];
        }
        
    } completion:^(BOOL finished) {
        
        self->isEndWorkoutButtonTapped = @"NO";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            if (IS_IPHONEXR) {
                [self->_scrollViewSetAndRestScreen setFrame: CGRectMake(DEVICE_WIDTH, -44.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
                [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: YES];
            } else if (IS_IPHONEX) {
                [self->_scrollViewSetAndRestScreen setFrame: CGRectMake(DEVICE_WIDTH, -44.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
                [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: YES];
            } else if (IS_IPHONE8PLUS) {
                [self->_scrollViewSetAndRestScreen setFrame: CGRectMake(DEVICE_WIDTH, -44.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
                [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: YES];
            } else if (IS_IPHONE8) {
                [self->_scrollViewSetAndRestScreen setFrame: CGRectMake(DEVICE_WIDTH, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
                [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, 0.0) animated: YES];
            } else {
                [self->_scrollViewSetAndRestScreen setFrame: CGRectMake(DEVICE_WIDTH, -44.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
                [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: YES];
            }
            
        });
    }];
    
    [UIView transitionWithView: _imgAppBackgroundImage duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self->_imgAppBackgroundImage setImage: iWELCOME_SCREEN];
    } completion:^(BOOL finished) {}];
    
    [_lblRandomWorkoutCompleteSubTitle setAttributedText: [self getWorkoutCompleteLastPopupText]];
    [Utils setLastRandomWorkoutComplete];
}

- (IBAction)btnStartRestButtonTapped:(UIButton *)sender {
    //[_viewSetAndRestScreenProgressBackgroundView setHidden:NO];
    
    self.lblClickAnywhereToRestLabel.text = @"(click anywhere to rest)";
    [self.lblClickAnywhereToRestLabel setTextColor:colorClickAnywhere];
    
    AudioServicesPlaySystemSoundWithCompletion(1520, nil);
    int totoalExerciseCount = [[[NSUserDefaults standardUserDefaults] valueForKey: kTOTAL_EXERCISE_COUNT] intValue];
    if (totoalExerciseCount == 0) {
        [UIView transitionWithView: _imgAppBackgroundImage duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_imgAppBackgroundImage setImage: iWELCOME_SCREEN];
        } completion:^(BOOL finished) {}];

        [_viewSetAndRestBackgroundView setBackgroundColor: cDARK_GREEN_BACKGROUND];
        [_viewExerciseContentView setBackgroundColor: cDARK_GREEN_2];
        [_viewTotalTimeContentView setBackgroundColor: cDARK_GREEN_2];

        if([[_viewTotalTimeContentView backgroundColor] isEqual: cWARMUP_BLACK])
        {
            [_imgNextExerciseImage setImage:[UIImage imageNamed:@"imgGrayNext"]];
//            [_viewNextExerciseButtonContentView setAlpha: nextExerciseOpacity];
            [_lblNextExerciseLabel setTextColor: [UIColor colorWithRed:97.0/255.0 green:97.0/255.0 blue:97.0/255.0 alpha:1.0]];
            [_btnNextExerciseButton setEnabled: false];
        }
        else
        {
            [_imgNextExerciseImage setImage:[UIImage imageNamed:@"imgGreenNext"]];
            [_lblNextExerciseLabel setTextColor: [UIColor whiteColor]];
            [_btnNextExerciseButton setEnabled: true];
        }
        
        [_lblExerciseLabel setTextColor: cLIGHT_GREEN_2];
        [_lblTotalTimeLabel setTextColor: cLIGHT_GREEN_2];

        [warmUpView.contentView setHidden:YES];
        [warmUpView.vwWarmUp setHidden:YES];
        [self.vwWarmUp setHidden:YES];
        [self.vwNextExercise setHidden:YES];
        
        int strTotalExerciseCount = [[[NSUserDefaults standardUserDefaults] valueForKey: kTOTAL_EXERCISE_COUNT] intValue];
        [[NSUserDefaults standardUserDefaults] setValue: [NSString stringWithFormat: @"%d", (strTotalExerciseCount + 1)] forKey: kTOTAL_EXERCISE_COUNT];
        
        //Set total exercise count
        [_lblExerciseCountLabel setText: [NSString stringWithFormat: @"%@.", [[NSUserDefaults standardUserDefaults] valueForKey: kTOTAL_EXERCISE_COUNT]]];
        
    } else if (isFromNextExercise) {
        [UIView transitionWithView: _imgAppBackgroundImage duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_imgAppBackgroundImage setImage: iWELCOME_SCREEN];
        } completion:^(BOOL finished) {}];

        [_viewSetAndRestBackgroundView setBackgroundColor: cDARK_GREEN_BACKGROUND];
        [_viewExerciseContentView setBackgroundColor: cDARK_GREEN_2];
        [_viewTotalTimeContentView setBackgroundColor: cDARK_GREEN_2];
        
        if([[_viewTotalTimeContentView backgroundColor] isEqual: cWARMUP_BLACK])
        {
            [_imgNextExerciseImage setImage:[UIImage imageNamed:@"imgGrayNext"]];
            [_lblNextExerciseLabel setTextColor: [UIColor colorWithRed:97.0/255.0 green:97.0/255.0 blue:97.0/255.0 alpha:1.0]];
//            [_viewNextExerciseButtonContentView setAlpha: nextExerciseOpacity];
            [_btnNextExerciseButton setEnabled: false];
        }
        else
        {
            [_imgNextExerciseImage setImage:[UIImage imageNamed:@"imgGreenNext"]];
            [_lblNextExerciseLabel setTextColor: [UIColor whiteColor]];
            [_btnNextExerciseButton setEnabled: true];
        }

        [_lblExerciseLabel setTextColor: cLIGHT_GREEN_2];
        [_lblTotalTimeLabel setTextColor: cLIGHT_GREEN_2];

        [warmUpView.contentView setHidden:YES];
        [warmUpView.vwWarmUp setHidden:YES];
        [self.vwWarmUp setHidden:YES];
        [self.vwNextExercise setHidden:YES];
        [self.vwLastExercise setHidden:YES];
        
        isFromNextExercise = NO;
    } else {
        isSetScreen = @"NO";
        [self initializeRestScreenData];
    }
    
    if([[_viewTotalTimeContentView backgroundColor] isEqual: cWARMUP_BLACK])
    {
        isWarmUpFlag = true;
    }
    else
    {
        isWarmUpFlag = false;
    }
}

- (IBAction)btnShareStatsButtonTapped:(UIButton *)sender {
    
    AudioServicesPlaySystemSoundWithCompletion(1520, nil);
    
    NSString *strShareText = @"I just completed a workout with the GymTimer app, check it out !";
    NSURL *shareURL = [NSURL URLWithString: uGYMTIMER_APPSTORE_URL];
    
    NSArray *objectsToShare = @[strShareText, shareURL];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems: objectsToShare applicationActivities: nil];
    [self presentViewController: activityVC animated: YES completion: nil];
    
}

- (IBAction)btnDoneWorkoutButtonTapped:(UIButton *)sender {
    allUp = true;
    [self slideUpAnimation:0];
    [[self viewHideShow] setHidden:NO];
    AudioServicesPlaySystemSoundWithCompletion(1520, nil);
    
    isSetScreen = @"YES";
    
    [timerForRest reset];
    [_timerRest invalidate];
    _timerRest = nil;
    [_timerTotalTime invalidate];
    _timerTotalTime = nil;
    _isRestTimerRunning = @"NO";
    
    //Check Workout Time If More Than 5 Min Then Save In Backend else NOT
    NSString *fiveMinute = @"00:05:00";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    NSDate *date1 = [formatter dateFromString:currentWorkoutTotalTime];
    NSDate *date2 = [formatter dateFromString:fiveMinute];
    
    NSComparisonResult result = [date1 compare:date2];
    
    if (result == NSOrderedDescending || result == NSOrderedSame) {
        NSLog(@"Workout Timer Grater Than Or Equal To 5 Min");
        [self callSaveExerciseAPI];
        
    } else if (result == NSOrderedAscending) {
        NSLog(@"Workout Timer Less Than 5 Min");
        [self goBackToWelcomeScreen];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue: @"00:00:00" forKey: kLAST_EXERCISE_TIME];
}

//MARK:- Tab bar controller delegate methods

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    NSMutableArray *arrTabbarVC = [[[self tabBarController] viewControllers] mutableCopy];
    NSString *strTabItemName = [[[tabBarController tabBar] selectedItem] title];
    
    if ([strTabItemName isEqualToString: @"Workout"]) {
        [arrTabbarVC setObject: GETCONTROLLER(@"WorkoutViewController") atIndexedSubscript: 0];
        [[self tabBarController] setViewControllers: arrTabbarVC animated: NO];
        
    }else if ([strTabItemName isEqualToString: @"Ranking"]) {
        [arrTabbarVC setObject: GETCONTROLLER(@"RankingViewController") atIndexedSubscript: 1];
        [[self tabBarController] setViewControllers: arrTabbarVC animated: NO];
        
    } else if ([strTabItemName isEqualToString: @"Stats"]) {
        [arrTabbarVC setObject: GETCONTROLLER(@"StatsVC") atIndexedSubscript: 2];
        [[self tabBarController] setViewControllers: arrTabbarVC animated: NO];
        
    } else if ([strTabItemName isEqualToString: @"Settings"]) {
        [arrTabbarVC setObject: GETCONTROLLER(@"SettingsViewController") atIndexedSubscript: 3];
        [[self tabBarController] setViewControllers: arrTabbarVC animated: NO];
        
    } else {}
    
    // Vsn - 13/03/2020
    if(IS_IPHONE8PLUS)
    {
//        [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - 75.0), DEVICE_WIDTH, 75.0)];
    }
}


//MARK:- Picker View's Delegate and Datasource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        return arrMinutes.count;
    } else {
        return arrSeconds.count;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    [[[pickerView subviews] objectAtIndex: 1] setHidden: YES];
    [[[pickerView subviews] objectAtIndex: 2] setHidden: YES];
    
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        
        if (IS_IPHONEXR) {
            [pickerLabel setFont: [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 45.0]];
        } else if (IS_IPHONEX) {
            [pickerLabel setFont: [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 45.0]];
        } else if (IS_IPHONE8PLUS) {
            [pickerLabel setFont: [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0]];
        } else if (IS_IPHONE8) {
            [pickerLabel setFont: [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0]];
        } else {
            [pickerLabel setFont: [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 25.0]];
        }
        
        pickerLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    if (component == 0) {
        [pickerLabel setText: arrMinutes[row]];
    } else if (component == 1) {
        [pickerLabel setText: arrSeconds[row]];
    } else {}
    
    return pickerLabel;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        return arrMinutes[row];
    } else {
        return arrSeconds[row];
    }
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 100.0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSString *strCurrentRestTime = [NSString stringWithFormat: @"%@:%@", arrMinutes[[pickerView selectedRowInComponent: 0]], arrSeconds[[pickerView selectedRowInComponent: 1]]];
    [[NSUserDefaults standardUserDefaults] setValue: strCurrentRestTime forKey: kREST_TIME];
    
    //    Endurance = 1-3 sets , 6-12 reps
    //    Muscle = 3-6 sets , 4-6 reps
    //    Power = 6-10 sets , 1-4 reps
    
    //    00:00-01:59 = endurance info
    //    02:00-03:59 = muscle info
    //    04:00-09:59 = power info
    
    NSInteger first = [arrMinutes[[pickerView selectedRowInComponent: 0]] integerValue];
    NSInteger second = [arrSeconds[[pickerView selectedRowInComponent: 1]] integerValue];
    
    if(first == 0 && second == 0){
        allUp = true;
        [self slideUpAnimation:0];
        
        [self.lblRange1 countFrom:[_lblRange1.text integerValue] to:0 withDuration:0.4];
        self.lblRange1.text = @"0";
        
        [self.lblRange11 countFrom:[_lblRange11.text integerValue] to:0 withDuration:0.4];
        self.lblRange11.text = @"0";
        
        [self.lblRange2 countFrom:[_lblRange2.text integerValue] to:0 withDuration:0.4];
        self.lblRange2.text = @"0";
        
        [self.lblRange22 countFrom:[_lblRange22.text integerValue] to:0 withDuration:0.4];
        self.lblRange22.text = @"0";
        
    }
    else if(first<=1 && second < 59){
        [self btnEnduranceClick:_btnEndurance];
        if (selectedSlideUpImage != 1){
            [self slideUpAnimation:1];
        }
    }else if(first<=3 && second < 59){
        [self btnMuscleClick:_btnMuscle];
        if (selectedSlideUpImage != 2){
            [self slideUpAnimation:2];
        }
    }else if(first<=9 && second < 59){
        [self btnPowerClick:_btnpower];
        if (selectedSlideUpImage != 3){
            [self slideUpAnimation:3];
        }
    }
    
    //Set rest time
    [_lblChangeRestCountLabel setText: [[NSUserDefaults standardUserDefaults] valueForKey: kREST_TIME]];
}

- (void)slideUpAnimation:(NSInteger )index {
    
    CGFloat animationDuration = 0.15;
    
    if(index == 0){
        
        [UIView animateWithDuration: animationDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [[self viewHideShow] setHidden:NO];
            [[self lblScientific] setHidden:YES];
            [[self btnArrowScientifically] setHidden:YES];
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.45 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [[self imgEndurance] setFrame: CGRectMake(self.imgEndurance.frame.origin.x, 10.0, self.imgEndurance.frame.size.width, self.imgEndurance.frame.size.height)];
            [[self view] layoutIfNeeded];
        } completion:^(BOOL finished) {
            self->selectedSlideUpImage = 0;
        }];
        
        
        [UIView animateWithDuration:0.7 delay:0.25 usingSpringWithDamping:0.45 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [[self imgMuscle] setFrame: CGRectMake(self.imgMuscle.frame.origin.x, 10.0, self.imgMuscle.frame.size.width, self.imgMuscle.frame.size.height)];
            [[self view] layoutIfNeeded];
        } completion:^(BOOL finished) {
            self->selectedSlideUpImage = 0;
        }];
        
        
        [UIView animateWithDuration:0.7 delay:0.5 usingSpringWithDamping:0.45 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [[self imgPower] setFrame: CGRectMake(self.imgPower.frame.origin.x, 10.0, self.imgPower.frame.size.width, self.imgPower.frame.size.height)];
            [[self view] layoutIfNeeded];
        } completion:^(BOOL finished) {
            self->selectedSlideUpImage = 0;
        }];
    }
    else if(index == 1){
        
        [UIView animateWithDuration: animationDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [[self viewHideShow] setHidden:YES];
            [[self lblScientific] setHidden:NO];
            [[self btnArrowScientifically] setHidden:NO];
            [self.imgDumbell setImage:[UIImage imageNamed:@"dumbell_endurance"] forState:UIControlStateNormal];
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.45 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [[self imgEndurance] setFrame: CGRectMake(self.imgEndurance.frame.origin.x, 10.0, self.imgEndurance.frame.size.width, self.imgEndurance.frame.size.height)];
            [[self view] layoutIfNeeded];
        } completion:^(BOOL finished) {
            self->selectedSlideUpImage = 1;
        }];
            
        if(allUp == true){
            allUp = false;
            [UIView animateWithDuration: animationDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [[self imgMuscle] setFrame: CGRectMake(self.imgMuscle.frame.origin.x, self.imgMuscle.frame.size.height + 1, self.imgMuscle.frame.size.width, self.imgMuscle.frame.size.height)];
            } completion:^(BOOL finished) {
                self->slideDown = 1;
            }];
            
            [UIView animateWithDuration: animationDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [[self imgPower] setFrame: CGRectMake(self.imgPower.frame.origin.x, self.imgPower.frame.size.height + 1, self.imgPower.frame.size.width, self.imgPower.frame.size.height)];
            } completion:^(BOOL finished) {
                self->slideDown = 1;
            }];
        }
        else if(slideDown == 2){
            [UIView animateWithDuration: animationDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [[self imgMuscle] setFrame: CGRectMake(self.imgMuscle.frame.origin.x, self.imgMuscle.frame.size.height + 1, self.imgMuscle.frame.size.width, self.imgMuscle.frame.size.height)];
            } completion:^(BOOL finished) {
                self->slideDown = 1;
            }];
        }
        else if(slideDown == 3){
            [UIView animateWithDuration: animationDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [[self imgPower] setFrame: CGRectMake(self.imgPower.frame.origin.x, self.imgPower.frame.size.height + 1, self.imgPower.frame.size.width, self.imgPower.frame.size.height)];
            } completion:^(BOOL finished) {
                self->slideDown = 1;
            }];
        }
    }
    else if(index == 2){
        
        [UIView animateWithDuration: animationDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [[self viewHideShow] setHidden:YES];
            [[self lblScientific] setHidden:NO];
            [[self btnArrowScientifically] setHidden:NO];
            [self.imgDumbell setImage:[UIImage imageNamed:@"dumbell_muscle"] forState:UIControlStateNormal];
        } completion:^(BOOL finished) {
            
        }];
        
        
        [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.45 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [[self imgMuscle] setFrame: CGRectMake(self.imgMuscle.frame.origin.x, 10.0, self.imgMuscle.frame.size.width, self.imgMuscle.frame.size.height)];
            [[self view] layoutIfNeeded];
        } completion:^(BOOL finished) {
            self->selectedSlideUpImage = 2;
        }];
        
        if(allUp == true){
            allUp = false;
            [UIView animateWithDuration: animationDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [[self imgEndurance] setFrame: CGRectMake(self.imgEndurance.frame.origin.x, self.imgEndurance.frame.size.height + 1, self.imgEndurance.frame.size.width, self.imgEndurance.frame.size.height)];
            } completion:^(BOOL finished) {
                self->slideDown = 2;
            }];
            
            [UIView animateWithDuration: animationDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [[self imgPower] setFrame: CGRectMake(self.imgPower.frame.origin.x, self.imgPower.frame.size.height + 1, self.imgPower.frame.size.width, self.imgPower.frame.size.height)];
            } completion:^(BOOL finished) {
                self->slideDown = 2;
            }];
        }
        else if(slideDown == 1){
            [UIView animateWithDuration: animationDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [[self imgEndurance] setFrame: CGRectMake(self.imgEndurance.frame.origin.x, self.imgEndurance.frame.size.height + 1, self.imgEndurance.frame.size.width, self.imgEndurance.frame.size.height)];
            } completion:^(BOOL finished) {
                self->slideDown = 2;
            }];
        }
        else if(slideDown == 3){
            [UIView animateWithDuration: animationDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [[self imgPower] setFrame: CGRectMake(self.imgPower.frame.origin.x, self.imgPower.frame.size.height + 1, self.imgPower.frame.size.width, self.imgPower.frame.size.height)];
            } completion:^(BOOL finished) {
                self->slideDown = 2;
            }];
        }
        
    }
    else if(index == 3){
        
        [UIView animateWithDuration: animationDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [[self viewHideShow] setHidden:YES];
            [[self lblScientific] setHidden:NO];
            [[self btnArrowScientifically] setHidden:NO];
            [self.imgDumbell setImage:[UIImage imageNamed:@"dumbell_power"] forState:UIControlStateNormal];
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.45 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [[self imgPower] setFrame: CGRectMake(self.imgPower.frame.origin.x, 10.0, self.imgPower.frame.size.width, self.imgPower.frame.size.height)];
            [[self view] layoutIfNeeded];
        } completion:^(BOOL finished) {
            self->selectedSlideUpImage = 3;
        }];
        
        if(allUp == true){
            allUp = false;
            [UIView animateWithDuration: animationDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [[self imgEndurance] setFrame: CGRectMake(self.imgEndurance.frame.origin.x, self.imgEndurance.frame.size.height + 1, self.imgEndurance.frame.size.width, self.imgEndurance.frame.size.height)];
            } completion:^(BOOL finished) {
                self->slideDown = 3;
            }];
            
            [UIView animateWithDuration: animationDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [[self imgMuscle] setFrame: CGRectMake(self.imgMuscle.frame.origin.x, self.imgMuscle.frame.size.height + 1, self.imgMuscle.frame.size.width, self.imgMuscle.frame.size.height)];
            } completion:^(BOOL finished) {
                self->slideDown = 3;
            }];
        }
        else if(slideDown == 1){
            [UIView animateWithDuration: animationDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [[self imgEndurance] setFrame: CGRectMake(self.imgEndurance.frame.origin.x, self.imgEndurance.frame.size.height + 1, self.imgEndurance.frame.size.width, self.imgEndurance.frame.size.height)];
            } completion:^(BOOL finished) {
                self->slideDown = 3;
            }];
        }
        else if(slideDown == 2){
            [UIView animateWithDuration: animationDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [[self imgMuscle] setFrame: CGRectMake(self.imgMuscle.frame.origin.x, self.imgMuscle.frame.size.height + 1, self.imgMuscle.frame.size.width, self.imgMuscle.frame.size.height)];
            } completion:^(BOOL finished) {
                self->slideDown = 3;
            }];
        }
    }
}


//MARK:- User-defined methods

- (void) setupStartWorkoutLayout {
    
    //Tabbar initialization
    [[self tabBarController] setDelegate: self];
    //[[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - 53.0), DEVICE_WIDTH, 53.0)];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 0] setTitle: @"Workout"];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 1] setTitle: @"Ranking"];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 2] setTitle: @"Stats"];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 3] setTitle: @"Settings"];
    
    //Add shadow to upper part of tabbar
    if (IS_IPHONEXR) {
        
    } else if (IS_IPHONEX) {
        
    } else if (IS_IPHONE8PLUS) {
        [[[[self tabBarController] tabBar] layer] setShadowOffset: CGSizeMake(0.0, 0.0)];
        [[[[self tabBarController] tabBar] layer] setShadowRadius: 4.0];
        [[[[self tabBarController] tabBar] layer] setShadowColor: [cGYM_TIMER_LABEL CGColor]];
        [[[[self tabBarController] tabBar] layer] setShadowOpacity: 0.3];
    } else if (IS_IPHONE8) {
        [[[[self tabBarController] tabBar] layer] setShadowOffset: CGSizeMake(0.0, 0.0)];
        [[[[self tabBarController] tabBar] layer] setShadowRadius: 4.0];
        [[[[self tabBarController] tabBar] layer] setShadowColor: [cGYM_TIMER_LABEL CGColor]];
        [[[[self tabBarController] tabBar] layer] setShadowOpacity: 0.3];
    } else {
        [[[[self tabBarController] tabBar] layer] setShadowOffset: CGSizeMake(0.0, 0.0)];
        [[[[self tabBarController] tabBar] layer] setShadowRadius: 4.0];
        [[[[self tabBarController] tabBar] layer] setShadowColor: [cGYM_TIMER_LABEL CGColor]];
        [[[[self tabBarController] tabBar] layer] setShadowOpacity: 0.3];
    }
    
    //Loader view
    [_lblLoaderGymTimerLabel setTextColor: cGYM_TIMER_LABEL];
    [_lblLoaderGymTimerLabel setAlpha: 1.0];
    [_viewLoaderContentView setClipsToBounds: YES];
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: [_viewLoaderContentView bounds] byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){30.0, 30.}].CGPath;
    [[_viewLoaderContentView layer] setMask: maskLayer];
    [self hideLoaderView];
    
    //Start Workout Screen
    [_scrollViewWorkoutScreen setDelegate: self];
    
    [_lblGymTimerTitleLabel setTextColor: cGYM_TIMER_LABEL];
//    NSMutableAttributedString *lblBoostYourWorkoutText = [[NSMutableAttributedString alloc] initWithString:@"Boost your workouts"];
    [_lblBoostYourWorkoutsSetScreenLabel setTextColor: cGYM_TIMER_LABEL];
    
    [_viewWorkoutContentView setClipsToBounds: YES];
    [[_viewWorkoutContentView layer] setCornerRadius: 36.0];
    
    [self.vwLastExercise.layer setCornerRadius:30.0];
    
    [_btnStartWorkoutButton setClipsToBounds: YES];
    
    /*--------------------------------------------------------------------------------*/
    
    //Set and Rest Screen
    [_scrollViewSetAndRestScreen setDelegate: self];
    
    [_lblGymTimerSetScreenLabel setTextColor: UIColor.whiteColor];
    
    [_viewSetAndRestBackgroundView setClipsToBounds: YES];
    [_viewSetAndRestBackgroundView setBackgroundColor: [UIColor blackColor]];
    
    [_viewSetAndRestScreenProgressBackgroundView setClipsToBounds: YES];
    [_viewSetAndRestScreenProgressBackgroundView setBackgroundColor: UIColor.whiteColor];
    
    [_viewDoSetNumberContentView setBackgroundColor: UIColor.clearColor];
    [_lblDoSetNumberLabel setTextColor: cLIGHT_GREEN];
    [_lblDoSetNumberCountLabel setTextColor: UIColor.whiteColor];
    
    [_viewRestTimeContentView setBackgroundColor: UIColor.clearColor];
    [_lblRestTimerMinutesLabel setTextColor: UIColor.whiteColor];
    [_lblRestTimerColonLabel setTextColor: UIColor.whiteColor];
    [_lblRestTimerSecondsLabel setTextColor: UIColor.whiteColor];
    
    [_viewClickAnywhereContentView setBackgroundColor: UIColor.clearColor];
    [_lblClickAnywhereToRestLabel setTextColor: UIColor.grayColor];
    
    [_viewNextSetContentView setBackgroundColor: UIColor.clearColor];
    // Vsn - 05/02/2020
//    [_lblNextSetLabel setTextColor: UIColor.blackColor];
//    [_lblNextSetCountLabel setTextColor: UIColor.whiteColor];
//    [_lblNextSetCountLabel setBackgroundColor: cSTRENGTH_VIEW];
    [_lblNextSetLabel setTextColor: UIColor.lightGrayColor];
    [_lblNextSetCountLabel setTextColor: cSTRENGTH_VIEW];
    [_lblNextSetCountLabel setBackgroundColor: UIColor.clearColor];
    [_lblNextSetCountLabel setClipsToBounds: YES];
    
    [_viewExerciseAndTotalTimeBackgroundView setBackgroundColor: UIColor.clearColor];
    [_viewExerciseContentView setClipsToBounds: YES];
    [_viewTotalTimeContentView setClipsToBounds: YES];
    [_lblExerciseCountLabel setTextColor: UIColor.whiteColor];
    [_lblHoursFirstLabel setTextColor: UIColor.whiteColor];
    [_lblColonFirstLabel setTextColor: UIColor.whiteColor];
    [_lblMinFirstLabel setTextColor: UIColor.whiteColor];
    [_lblColonSecondLabel setTextColor: UIColor.whiteColor];
    [_lblSecondsFirstLabel setTextColor: UIColor.whiteColor];
    [_lblMinSecondLabel setTextColor: UIColor.whiteColor];
    [_lblColonThirdLabel setTextColor: UIColor.whiteColor];
    [_lblSecondsSecondLabel setTextColor: UIColor.whiteColor];
    
    [_viewExerciseContentView setBackgroundColor: cWARMUP_BLACK];
    [_viewTotalTimeContentView setBackgroundColor: cWARMUP_BLACK];
    
    if([[_viewTotalTimeContentView backgroundColor] isEqual: cWARMUP_BLACK])
    {
        [_imgNextExerciseImage setImage:[UIImage imageNamed:@"imgGrayNext"]];
//        [_viewNextExerciseButtonContentView setAlpha: nextExerciseOpacity];
        [_lblNextExerciseLabel setTextColor: [UIColor colorWithRed:97.0/255.0 green:97.0/255.0 blue:97.0/255.0 alpha:1.0]];
        [_btnNextExerciseButton setEnabled: false];
    }
    else
    {
        [_imgNextExerciseImage setImage:[UIImage imageNamed:@"imgGreenNext"]];
        [_lblNextExerciseLabel setTextColor: [UIColor whiteColor]];
        [_btnNextExerciseButton setEnabled: true];
    }
    
    [_lblExerciseLabel setTextColor: cLIGHT_GREEN_2];
    [_lblTotalTimeLabel setTextColor: cLIGHT_GREEN_2];
    /*--------------------------------------------------------------------------------*/
    
    //Workout complete screen
    [_scrollViewWorkoutCompleteScreen setDelegate: self];
    
    [_lblGymTimerWorkoutScreenTitleLabel setTextColor: UIColor.whiteColor];
    
    
    // Vsn - 09/04/2020
//    [_viewWorkoutStatsBackgroundView setClipsToBounds: YES];
//    [_viewWorkoutStatsBackgroundView setBackgroundColor: cDARK_GREEN_BACKGROUND];
    // End
    
    [_viewWorkoutStatsContentView setClipsToBounds: YES];
    [_viewWorkoutStatsContentView setBackgroundColor: UIColor.whiteColor];
    
    [_viewWorkoutCompleteContentVIew setBackgroundColor: UIColor.clearColor];
    [_lblWorkoutCompleteLabel setTextColor: cLIGHT_GREEN];
    _lblWorkoutCompleteLabel.textAlignment = NSTextAlignmentLeft;
    
    [[self.vwWarmUp layer] setCornerRadius: 30.0];
    
    if (IS_IPHONEXR) {
        //Loader view
        [_viewLoaderBackgroundView setFrame: CGRectMake(0.0, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        [_lblLoaderGymTimerLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLoaderLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblLoaderGymTimerLabel setFont: fontGymTimerLoaderLabel];
        [_viewLoaderContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        //Scroll and Content view
        [_scrollViewWorkoutScreen setFrame: CGRectMake(0.0, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
        [_contentViewWorkoutScreen setFrame: CGRectMake(0.0, 0.0, (_scrollViewWorkoutScreen.frame.size.width), (_scrollViewWorkoutScreen.frame.size.height))];
        CGFloat contentViewWidth = _contentViewWorkoutScreen.frame.size.width;
        CGFloat contentViewHeight = _contentViewWorkoutScreen.frame.size.height;
        
        //GymTimer label
        [_lblGymTimerTitleLabel setFrame: CGRectMake(0.0, -4.0, (_contentViewWorkoutScreen.frame.size.width), 95.0)];
        UIFont *fontGymTimer = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 64.7];
        [_lblGymTimerTitleLabel setFont: fontGymTimer];
        
        // Vsn - 11/02/2020
        [_lblBoostYourWorkoutsSetScreenLabel setFrame: CGRectMake((_contentViewWorkoutScreen.frame.size.width / 2.0) - 174.0, 39.0, (_contentViewWorkoutScreen.frame.size.width), 80.0)];
//        [_lblBoostYourWorkoutsSetScreenLabel setFrame: CGRectMake((_contentViewWorkoutScreen.frame.size.width / 2.0) - 146.0, 40.0, (_contentViewWorkoutScreen.frame.size.width), 80.0)];
//        [lblBoostYourWorkoutText addAttribute:NSKernAttributeName value:@3 range:NSMakeRange(0, lblBoostYourWorkoutText.length)];
//        [_lblBoostYourWorkoutsSetScreenLabel setAttributedText: lblBoostYourWorkoutText];
        UIFont *fontGymTimer1 = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 22.0];
        [_lblBoostYourWorkoutsSetScreenLabel setFont: fontGymTimer1];
        
        
        //Start Workout content view
        CGFloat gymtimerY = _lblGymTimerTitleLabel.frame.origin.y;
        CGFloat gymtimerHeight = _lblGymTimerTitleLabel.frame.size.height;
        CGFloat tabbarHeight = 53.0;
        //        CGFloat tabbarHeight = [[[self tabBarController] tabBar] frame].size.height;
        [_viewWorkoutContentView setFrame: CGRectMake(18.0, (_lblGymTimerTitleLabel.frame.origin.y + _lblGymTimerTitleLabel.frame.size.height + 24.0), (contentViewWidth - 36.0), (contentViewHeight - (gymtimerY + gymtimerHeight + tabbarHeight + 90.0)))];
        // Vsn - 19/02/2020
        [_viewWorkoutContentViewSubView setFrame: CGRectMake(0.0, 0.0, _viewWorkoutContentView.frame.size.width, _viewWorkoutContentView.frame.size.height)];
        // Vsn - 25/02/2020
        [_vwImgWelcomeBack setFrame: CGRectMake(0.0, 0.0, _viewWorkoutContentView.frame.size.width, _viewWorkoutContentView.frame.size.height)];
        [_vwWorkoutContentParent setFrame:CGRectMake(0.0, 0.0, _viewWorkoutContentView.frame.size.width, _viewWorkoutContentView.frame.size.height)];
        [_imgHomeBottomGym setFrame: CGRectMake(-21.0, -19.0, _viewWorkoutContentView.frame.size.width + 42.0, _viewWorkoutContentView.frame.size.height + 45.0)];
        
        //Choose default rest time label
        CGFloat workoutContentViewWidth = _viewWorkoutContentView.frame.size.width;
        UIFont *fontMinSec = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [_lblChooseDefaultTimeLabel setFrame: CGRectMake(0.0, 52.0, (workoutContentViewWidth), 42.0)];
        [_lblChooseDefaultTimeLabel setFont: fontMinSec];
        [_lblChooseDefaultTimeLabel setAlpha: 0.5];
        
        //Rest time picker view
        [_pickerWorkoutRestTimePickerView setFrame: CGRectMake(32.0, (_lblChooseDefaultTimeLabel.frame.origin.y + _lblChooseDefaultTimeLabel.frame.size.height + 40.0), (workoutContentViewWidth - 64.0), 288.0)];
//        [_pickerWorkoutRestTimePickerView setFrame: CGRectMake(32.0, (_lblChooseDefaultTimeLabel.frame.origin.y + _lblChooseDefaultTimeLabel.frame.size.height + 40.0), (workoutContentViewWidth - 64.0), 338.0)];

        
        //Minute and seconds view
        [_viewMinutesSecondsContentView setFrame: CGRectMake(20.0, (_lblChooseDefaultTimeLabel.frame.origin.y + _lblChooseDefaultTimeLabel.frame.size.height + 35.0 + _pickerWorkoutRestTimePickerView.frame.size.height/2), workoutContentViewWidth, 22.0)];
        [_lblMinuteLabel setFrame: CGRectMake(143.0, 0.0, 30.0, 21.0)];
        [_lblSecondsLabel setFrame: CGRectMake(246.0, 0.0, 15.0, 21.0)];
        [_lblMinuteLabel setFont: fontMinSec];
        [_lblSecondsLabel setFont: fontMinSec];
        
        {//Dinal1-done
            
            UIFont *newBtnFont = [UIFont fontWithName: fFUTURA_BOLD size: 13.0];
            [_btnEndurance.titleLabel setFont:newBtnFont];
            [_btnMuscle.titleLabel setFont:newBtnFont];
            [_btnpower.titleLabel setFont:newBtnFont];
            //            [_lblRecommend setFont:newBtnFont];
            
            UIFont *newGreenFont = [UIFont fontWithName: fFUTURA_MEDIUM size: 13.0];
            [_lblRange1 setFont:newGreenFont];
            [_lblRange2 setFont:newGreenFont];
            [_lblRange11 setFont:newGreenFont];
            [_lblRange22 setFont:newGreenFont];
            
            UIFont *newSetRepsFont = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
            [_lblSets setFont:newSetRepsFont];
            [_lblReps setFont:newSetRepsFont];
            [_lblRecommend setFont:newSetRepsFont];
            
            UIFont *newScientificFont = [UIFont fontWithName: fFUTURA_MEDIUM size: 12.5];
            [_lblScientific setFont:newScientificFont];
            
            CGFloat widthParent = _viewTabParent.frame.size.width;
            
            CGRect frameRecommend = _lblRecommend.frame;
            frameRecommend.size.width = widthParent * 0.4210;
            frameRecommend.origin.x += 8.0;
            [_lblRecommend setFrame:frameRecommend];
            
            CGRect frameRange1 = _lblRange1.frame;
            //            frameRange1.size.width = widthParent * 0.0964;
            frameRange1.origin.x = frameRecommend.origin.x + frameRecommend.size.width - 23.0;
            [_lblRange1 setFrame:frameRange1];
            
            CGRect minus1 = _lblMinus1.frame;
            //            minus1.size.width = widthParent * 0.0964;
            minus1.origin.x = _lblRange1.frame.origin.x + _lblRange1.frame.size.width - 2.0;
            [_lblMinus1 setFrame:minus1];
            
            CGRect frameRange11 = _lblRange11.frame;
            frameRange11.size.width += 3.0;
            frameRange11.origin.x = _lblMinus1.frame.origin.x + _lblMinus1.frame.size.width - 4.0;
            [_lblRange11 setFrame:frameRange11];
            
            CGRect frameSets = _lblSets.frame;
            frameSets.size.width = widthParent * 0.1096;
            frameSets.origin.x = frameRange11.origin.x + frameRange11.size.width + 2.0;
            [_lblSets setFrame:frameSets];
            
            CGRect frameSeprator1 = _lblSeparator1.frame;
            frameSeprator1.size.width = 1.0;
            frameSeprator1.origin.x = frameSets.origin.x + frameSets.size.width - 4.0;
            [_lblSeparator1 setFrame:frameSeprator1];
            
            CGRect frameRange2 = _lblRange2.frame;
            //            frameRange2.size.width = widthParent * 0.0964;
            frameRange2.origin.x = frameSeprator1.origin.x + frameSeprator1.size.width + 7.0;
            // Vsn - 09/04/2020
            frameRange2.size.width = frameRange2.size.width + 7.0;
            // End
            [_lblRange2 setFrame:frameRange2];
            
            CGRect minus2 = _lblMinus2.frame;
            //minus2.size.width = widthParent * 0.0964;
            minus2.origin.x = _lblRange2.frame.origin.x + _lblRange2.frame.size.width - 2.0;
            [_lblMinus2 setFrame:minus2];
            
            CGRect frameRange22 = _lblRange22.frame;
            frameRange22.size.width += 3.0;
            frameRange22.origin.x = _lblMinus2.frame.origin.x + _lblMinus2.frame.size.width - 4.0;
            [_lblRange22 setFrame:frameRange22];
            
            CGRect frameReps = _lblReps.frame;
            frameReps.size.width = widthParent * 0.1228;
            frameReps.origin.x = frameRange22.origin.x + frameRange22.size.width + 4.0;
            [_lblReps setFrame:frameReps];
            
            CGRect frameSeprator2 = _lblSeparator2.frame;
            frameSeprator2.size.width = 1.0;
            frameSeprator2.origin.x = frameReps.origin.x + frameReps.size.width - 5.0;
            [_lblSeparator2 setFrame:frameSeprator2];
            
            CGRect frameDumbell = _imgDumbell.frame;
            frameDumbell.size.width = widthParent * 0.1140;
            frameDumbell.size.height = widthParent * 0.1140;
            frameDumbell.origin.x = frameSeprator2.origin.x + frameSeprator2.size.width + 7.0;
            frameDumbell.origin.y -= 4.0;
            [_imgDumbell setFrame:frameDumbell];
            
            CGRect frameSci = _lblScientific.frame;
            frameSci.origin.x += 5.5;
            [_lblScientific setFrame:frameSci];
            
            CGRect frameArrow = _btnArrowScientifically.frame;
            frameArrow.origin.x = frameSci.origin.x + _lblScientific.frame.size.width + 5.0;
            [_btnArrowScientifically setFrame:frameArrow];
            
            //Text- 009938
            //BG- 14CC64
            //UIColorFromRGB(0x14CC64)
            //        [_btnStartWorkoutButton setFrame: CGRectMake(30.0, (_viewWorkoutContentView.frame.size.height - 30.0 - 70.0), (workoutContentViewWidth - 60.0), 70.0)];
            
        }
        
        // Vsn - 10/02/2020
        //Start workout button
        [_btnStartWorkoutButton setFrame: CGRectMake(60.0, (_pickerWorkoutRestTimePickerView.frame.size.height + _pickerWorkoutRestTimePickerView.frame.origin.y) + 5, (workoutContentViewWidth - 100.0) - 20, 60.0)];
//        [_btnStartWorkoutButton setFrame: CGRectMake(50.0, (_viewWorkoutContentView.frame.size.height - 160.0), (workoutContentViewWidth - 100.0), 60.0)];
        [_btnStartWorkoutButton setBackgroundColor: UIColorFromRGB(0x14CC64)];
        UIFont *fontStartButton = [UIFont fontWithName: fFUTURA_BOLD size: 25.0];
        dicStartButtonAttributes = [[NSDictionary alloc] init];
        dicStartButtonAttributes = @{ NSForegroundColorAttributeName : UIColorFromRGB(0x009938),
                                      NSFontAttributeName : fontStartButton
        };
        NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"Start Workout" attributes: dicStartButtonAttributes];
        [_btnStartWorkoutButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
        [[_btnStartWorkoutButton layer] setCornerRadius: _btnStartWorkoutButton.frame.size.height / 3.5]; //17.0
        
        
        /*--------------------------------------------------------------------------------*/
        
        //Scroll and content view
        [_scrollViewSetAndRestScreen setFrame: CGRectMake(DEVICE_WIDTH, -44.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
        //        [_scrollViewSetAndRestScreen setFrame: CGRectMake(DEVICE_WIDTH, 44.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
        [_scrollViewSetAndRestScreen setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + 221.0 + 34.0)];
        [_contentViewSetAndRestScreen setFrame: CGRectMake(0.0, 0.0, (_scrollViewSetAndRestScreen.frame.size.width), (_scrollViewSetAndRestScreen.contentSize.height + 104.0))];
        
        //Gym Timer label
        [_lblGymTimerSetScreenLabel setFrame: CGRectMake(0.0, 46.0, (_contentViewSetAndRestScreen.frame.size.width), 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblGymTimerSetScreenLabel setFont: fontGymTimerLabel];
        
        //Set and rest background view
        CGFloat setAndRestBgViewY = (_lblGymTimerSetScreenLabel.frame.origin.y + _lblGymTimerSetScreenLabel.frame.size.height + 32.0);
        [_viewSetAndRestBackgroundView setFrame: CGRectMake(18.0, setAndRestBgViewY + 16.0, (_contentViewSetAndRestScreen.frame.size.width - 36.0), 502.0)];
        [[_viewSetAndRestBackgroundView layer] setCornerRadius: 30.0];
        
        //Progress bar background view
        CGFloat setAndRestProgressBarBgViewY = (_viewSetAndRestBackgroundView.frame.size.height - _viewSetAndRestBackgroundView.frame.size.width + 9.0);
        CGFloat setAndRestBgWidth = _viewSetAndRestBackgroundView.frame.size.width;
        [_viewSetAndRestScreenProgressBackgroundView setFrame: CGRectMake(0.0, setAndRestProgressBarBgViewY + 30.0, setAndRestBgWidth, setAndRestBgWidth - 9.0)];
        [[_viewSetAndRestScreenProgressBackgroundView layer] setCornerRadius: 30.0];
        
        // Warm up view
        [self.vwWarmUp setFrame: CGRectMake(0.0, setAndRestProgressBarBgViewY + 30.0, setAndRestBgWidth, setAndRestBgWidth - 9.0)];
        
        //Do set number view and Rest time view
        [_viewDoSetNumberContentView setHidden: YES];
        [_viewRestTimeContentView setHidden: NO];
        CGFloat doSetNumberViewHeight = (_viewSetAndRestBackgroundView.frame.size.height - _viewSetAndRestScreenProgressBackgroundView.frame.size.height);
        [_viewDoSetNumberContentView setFrame: CGRectMake(0.0, 0.0, setAndRestBgWidth, doSetNumberViewHeight + 30.0)];
        
        [_lblDoSetNumberCountLabel setFrame: CGRectMake((setAndRestBgWidth - 121.0), 16.0, 121.0, (doSetNumberViewHeight - 6.0))];
        UIFont *fontDoSetCount = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 142.0];
        [_lblDoSetNumberCountLabel setFont: fontDoSetCount];
        [self adjustFontOfDoSetCountLabel];
        
        [_lblDoSetNumberLabel setFrame: CGRectMake(-10.0, (doSetNumberViewHeight - 93.0), (setAndRestBgWidth - _lblDoSetNumberCountLabel.frame.size.width - 10.5), 123.0)];
        UIFont *fontDoSetLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0];
        [_lblDoSetNumberLabel setFont: fontDoSetLabel];
        
        [_viewRestTimeContentView setFrame: CGRectMake(0.0, 0.0, setAndRestBgWidth, doSetNumberViewHeight)];
        CGFloat restTimerColonWidth = 40.0;
        CGFloat restTimerMinSecWidth = (setAndRestBgWidth - restTimerColonWidth) / 2.0;
        [_lblRestTimerMinutesLabel setFrame: CGRectMake(0.0, 20.0, restTimerMinSecWidth, doSetNumberViewHeight)];
        [_lblRestTimerColonLabel setFrame: CGRectMake((_lblRestTimerMinutesLabel.frame.size.width), 20.0, restTimerColonWidth, doSetNumberViewHeight)];
        [_lblRestTimerSecondsLabel setFrame: CGRectMake((_lblRestTimerColonLabel.frame.origin.x + _lblRestTimerColonLabel.frame.size.width), 20.0, restTimerMinSecWidth, doSetNumberViewHeight)];
               
        [self.vwLastExercise setFrame:CGRectMake(0.0, 0.0, setAndRestBgWidth, doSetNumberViewHeight)];
        [self.lblTimeSinceTitle setFrame:CGRectMake(20.0, 20.0, self.vwLastExercise.frame.size.width - 40.0, 29.0)];
        [self.lblTimeSince setFrame:CGRectMake(20.0, (self.lblTimeSinceTitle.frame.origin.y + self.lblTimeSinceTitle.frame.size.height) - 8 , self.vwLastExercise.frame.size.width - 40.0, 116.0)];
        
        //[_lblRestTimeLabel setFrame: CGRectMake(0.0, 15.0, setAndRestBgWidth, (doSetNumberViewHeight - 15.0))];
        UIFont *fontRestTimeLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 120.0];
        [_lblRestTimerMinutesLabel setFont: fontRestTimeLabel];
        [_lblRestTimerColonLabel setFont: fontRestTimeLabel];
        [_lblRestTimerSecondsLabel setFont: fontRestTimeLabel];
        
        //View last exercise
        CGFloat viewProgressBarHeight = _viewSetAndRestScreenProgressBackgroundView.frame.size.height;
        CGFloat viewProgressBarWidth = _viewSetAndRestScreenProgressBackgroundView.frame.size.width;
        
        [_viewLastExerciseTimeContentView setFrame: CGRectMake(22.0, 12.0, viewProgressBarWidth, 80.0)];
        [_lblSinceLastExerciseLabel setFrame: CGRectMake(0.0, 0.0, (_viewLastExerciseTimeContentView.frame.size.width), 30.0)];
        UIFont *fontSinceLastExerciseLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
        [_lblSinceLastExerciseLabel setFont: fontSinceLastExerciseLabel];
        
        CGFloat lastExerciseColonWidth = 12.0;
        CGFloat hoursFormatCountWidth = 40.0;
        
        //Hours format
        [_viewLastExerciseHoursFormat setFrame: CGRectMake(-16.0, 14.0, (_viewLastExerciseTimeContentView.frame.size.width), (_viewLastExerciseTimeContentView.frame.size.height - (_lblSinceLastExerciseLabel.frame.origin.y + _lblSinceLastExerciseLabel.frame.size.height)))];
        
        UIFont *fontLastExerciseHourFormat = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 20.0];
        [_lblLastExerciseFirstHourLabel setFrame: CGRectMake(0.0, 0.0, hoursFormatCountWidth, (_viewLastExerciseHoursFormat.frame.size.height))];
        [_lblLastExerciseHourFirstColonLabel setFrame: CGRectMake((_lblLastExerciseFirstHourLabel.frame.origin.x + _lblLastExerciseFirstHourLabel.frame.size.width), 0.0, (lastExerciseColonWidth - 4.0), (_viewLastExerciseHoursFormat.frame.size.height))];
        [_lblLastExerciseFirstMinLabel setFrame: CGRectMake((_lblLastExerciseHourFirstColonLabel.frame.origin.x + _lblLastExerciseHourFirstColonLabel.frame.size.width) - 5.0, 0.0, hoursFormatCountWidth, (_viewLastExerciseHoursFormat.frame.size.height))];
        [_lblLastExerciseHourSecondColonLabel setFrame: CGRectMake((_lblLastExerciseFirstMinLabel.frame.origin.x + _lblLastExerciseFirstMinLabel.frame.size.width) - 5.0, 0.0, (lastExerciseColonWidth - 4.0), (_viewLastExerciseHoursFormat.frame.size.height))];
        [_lblLastExerciseFirstSecLabel setFrame: CGRectMake((_lblLastExerciseHourSecondColonLabel.frame.origin.x + _lblLastExerciseHourSecondColonLabel.frame.size.width), 0.0, hoursFormatCountWidth, (_viewLastExerciseHoursFormat.frame.size.height))];
        [_lblLastExerciseFirstHourLabel setFont: fontLastExerciseHourFormat];
        [_lblLastExerciseHourFirstColonLabel setFont: fontLastExerciseHourFormat];
        [_lblLastExerciseFirstMinLabel setFont: fontLastExerciseHourFormat];
        [_lblLastExerciseHourSecondColonLabel setFont: fontLastExerciseHourFormat];
        [_lblLastExerciseFirstSecLabel setFont: fontLastExerciseHourFormat];
        
        //Minutes format
        CGFloat minuteFormatCountWidth = 40.0;
        UIFont *fontLastExerciseMinuteFormat = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 24.5];
        
        [_viewLastExerciseMinuteFormat setFrame: CGRectMake(-10.0, 18.0, (_viewLastExerciseTimeContentView.frame.size.width), (_viewLastExerciseTimeContentView.frame.size.height - (_lblSinceLastExerciseLabel.frame.origin.y + _lblSinceLastExerciseLabel.frame.size.height)))];
        
        [_lblLastExerciseSecondMinLabel setFrame: CGRectMake(0.0, 0.0, minuteFormatCountWidth, (_viewLastExerciseMinuteFormat.frame.size.height))];
        [_lblLastExerciseSecondColonLabel setFrame: CGRectMake((_lblLastExerciseSecondMinLabel.frame.origin.x + _lblLastExerciseSecondMinLabel.frame.size.width), 0.0, lastExerciseColonWidth, (_viewLastExerciseMinuteFormat.frame.size.height))];
        [_lblLastExerciseSecondSecLabel setFrame: CGRectMake((_lblLastExerciseSecondColonLabel.frame.origin.x + _lblLastExerciseSecondColonLabel.frame.size.width), 0.0, minuteFormatCountWidth, (_viewLastExerciseMinuteFormat.frame.size.height))];
        [_lblLastExerciseSecondMinLabel setFont: fontLastExerciseMinuteFormat];
        [_lblLastExerciseSecondColonLabel setFont: fontLastExerciseMinuteFormat];
        [_lblLastExerciseSecondSecLabel setFont: fontLastExerciseMinuteFormat];
        
        //Progress bar view and dumbells image
        [self setupProgressBar];
        [_progressBarSetScreenView setFrame: CGRectMake(47.5, 47.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
        [_progressBarRestScreenView setFrame: CGRectMake(47.5, 47.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
        [_progressBarRestBackgroungView setFrame: CGRectMake(47.5, 47.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
        [_vwRestScreenDumbellsBackgroundImage setFrame: CGRectMake(47.5, 47.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
        
        CGFloat progressBarHeight = _progressBarSetScreenView.frame.size.height;
        CGFloat progressBarWidth = _progressBarSetScreenView.frame.size.width;
        
        // Vsn - 05/02/2020
        CGFloat greenDumbellsImageWidth = 114.95; // 104.5*1.1
        CGFloat greenDumbellsImageHeight = 176.66; // 160.6*1.1
        CGFloat redDumbellsImageWidth = 210.0;
        CGFloat redDumbellsImageHeight = 202.0;

        [self.imgRestScreenDumbellsImage setFrame: CGRectMake(((progressBarWidth - redDumbellsImageWidth) / 2.0) + 0.5, ((progressBarHeight - redDumbellsImageHeight) / 2.0) + 25.0, redDumbellsImageWidth, redDumbellsImageHeight)];
        [self.imgRestScreenDumbellsBackgroundImage setFrame: self.imgRestScreenDumbellsImage.frame];
        
//        CGFloat greenDumbellsImageWidth = 78.0;
//        CGFloat greenDumbellsImageHeight = 106.0;
//        CGFloat redDumbellsImageWidth = 60.0;
//        CGFloat redDumbellsImageHeight = 128.0;
//
//        [_imgRestScreenDumbellsImage setFrame: CGRectMake(((progressBarWidth - redDumbellsImageWidth) / 2.0) + 4.0, ((progressBarHeight - redDumbellsImageHeight) / 2.0) + 10.0, redDumbellsImageWidth, redDumbellsImageHeight)];
        [_imgRestScreenDumbellsImage setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
        
        // Set Character
        [self.imgSetScreenDumbellsImage setFrame:CGRectMake(47.5, 20, greenDumbellsImageWidth, greenDumbellsImageHeight)];

        // Vsn - 05/02/2020
        self.imgSetScreenDumbellsImage.center = CGPointMake(self.viewSetAndRestScreenProgressBackgroundView.bounds.size.width  / 2, greenDumbellsImageHeight - 17.0);
//        self.imgSetScreenDumbellsImage.center = CGPointMake(self.viewSetAndRestScreenProgressBackgroundView.bounds.size.width  / 2, 140.0);

        // Next Exercise Progress Ring
        [self.vwNextExercise setFrame: CGRectMake(47.5, 47.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
        [self.vwNextExerciseRing setFrame:CGRectMake(0, 0, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
        [self.imgNextExercise setFrame:CGRectMake(0.0, 0.0, 90, 140)];
        self.imgNextExercise.center = CGPointMake(self.vwNextExercise.frame.size.width  / 2, self.vwNextExercise.frame.size.height / 2);
        
        //Click anywhere and Next set view
        [_viewClickAnywhereContentView setFrame: CGRectMake(0.0, (viewProgressBarHeight - 59.0), viewProgressBarWidth, 59.0)];
        [_lblClickAnywhereToRestLabel setFrame: CGRectMake(1.0, 0.0, (_viewClickAnywhereContentView.frame.size.width - 1.0), (_viewClickAnywhereContentView.frame.size.height))];
        UIFont *fontClickAnywhereLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [_lblClickAnywhereToRestLabel setFont: fontClickAnywhereLabel];
        
        // Vsn - 05/02/2020
        [_viewNextSetContentView setFrame: CGRectMake(0.0, 0.0, viewProgressBarWidth, 120.0)];
        [_lblNextSetCountLabel setFrame: CGRectMake((_viewNextSetContentView.frame.size.width - 82.0), 25.0, 70.0, 90.0)];
        UIFont *fontNextSetCountLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 78.0];
        [_lblNextSetCountLabel setFont: fontNextSetCountLabel];
        [[_lblNextSetCountLabel layer] setCornerRadius: 30.0];
        [_lblNextSetLabel setFrame: CGRectMake(0.0, 0.0, (_viewNextSetContentView.frame.size.width - 25.0), 40.0)];
        
//        [_viewNextSetContentView setFrame: CGRectMake(0.0, (viewProgressBarHeight - 60.0), viewProgressBarWidth, 60.0)];
//        [_lblNextSetCountLabel setFrame: CGRectMake((_viewNextSetContentView.frame.size.width - 60.0), 0.0, 60.0, 60.0)];
//        UIFont *fontNextSetCountLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0];
        
//        [_lblNextSetLabel setFrame: CGRectMake(0.0, (_viewNextSetContentView.frame.size.height - 40.0), (_viewNextSetContentView.frame.size.width - _lblNextSetCountLabel.frame.size.width - 9.0), 40.0)];
        UIFont *fontNextSetLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
        [_lblNextSetLabel setFont: fontNextSetLabel];
        
        [_viewExerciseAndTotalTimeBackgroundView setFrame: CGRectMake(0.0, (_viewSetAndRestBackgroundView.frame.origin.y + _viewSetAndRestBackgroundView.frame.size.height + 65.0), (_contentViewSetAndRestScreen.frame.size.width), 100.0)];
        [_viewExerciseContentView setFrame: CGRectMake(18.0, 0.0, (_viewExerciseAndTotalTimeBackgroundView.frame.size.width - 54.0) / 2.0, 100.0)];
        [_lblExerciseCountLabel setFrame: CGRectMake(0.0, 15.0, (_viewExerciseContentView.frame.size.width), 50.0)];
        UIFont *fontExerciseCount = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0];
        [_lblExerciseCountLabel setFont: fontExerciseCount];
        [_lblExerciseLabel setFrame: CGRectMake(0.0, (_lblExerciseCountLabel.frame.origin.y + _lblExerciseCountLabel.frame.size.height - 7.0), (_viewExerciseContentView.frame.size.width), 30.0)];
        UIFont *fontExerciseLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.1];
        [_lblExerciseLabel setFont: fontExerciseLabel];
        [_viewTotalTimeContentView setFrame: CGRectMake((_viewExerciseContentView.frame.origin.x + _viewExerciseContentView.frame.size.width + 18.0), 0.0, (_viewExerciseAndTotalTimeBackgroundView.frame.size.width - 54.0) / 2.0, 100.0)];
        [[_viewExerciseContentView layer] setCornerRadius: 30.0];
        [[_viewTotalTimeContentView layer] setCornerRadius: 30.0];
        
        [_viewHoursTimeContentView setFrame: CGRectMake(0.0, 0.0, (_viewTotalTimeContentView.frame.size.width), 65.0)];
        CGFloat colonWidth = 12.0;
        CGFloat timeHoursWidth = ((_viewHoursTimeContentView.frame.size.width - (2 * colonWidth)) / 3.0) - 4.0;
        [_lblHoursFirstLabel setFrame: CGRectMake(6.0, 15.0, timeHoursWidth, 50.0)];
        [_lblColonFirstLabel setFrame: CGRectMake((_lblHoursFirstLabel.frame.origin.x + _lblHoursFirstLabel.frame.size.width), 15.0, colonWidth, 50.0)];
        [_lblMinFirstLabel setFrame: CGRectMake((_lblColonFirstLabel.frame.origin.x + _lblColonFirstLabel.frame.size.width), 15.0, timeHoursWidth, 50.0)];
        [_lblColonSecondLabel setFrame: CGRectMake((_lblMinFirstLabel.frame.origin.x + _lblMinFirstLabel.frame.size.width), 15.0, colonWidth, 50.0)];
        [_lblSecondsFirstLabel setFrame: CGRectMake((_lblColonSecondLabel.frame.origin.x + _lblColonSecondLabel.frame.size.width), 15.0, timeHoursWidth, 50.0)];
        UIFont *fontHoursTimeCount = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 28.0];
        
        [_viewMinTimeContentView setFrame: CGRectMake(0.0, 0.0, (_viewTotalTimeContentView.frame.size.width), 65.0)];
        CGFloat timeMinutesWidth = (_viewHoursTimeContentView.frame.size.width - colonWidth) / 2.0;
        [_lblMinSecondLabel setFrame: CGRectMake(0.0, 15.0, timeMinutesWidth, 50.0)];
        [_lblColonThirdLabel setFrame: CGRectMake((_lblMinSecondLabel.frame.origin.x + _lblMinSecondLabel.frame.size.width), 15.0, colonWidth, 50.0)];
        [_lblSecondsSecondLabel setFrame: CGRectMake((_lblColonThirdLabel.frame.origin.x + _lblColonThirdLabel.frame.size.width), 15.0, timeMinutesWidth, 50.0)];
        
        [_lblHoursFirstLabel setFont: fontHoursTimeCount];
        [_lblColonFirstLabel setFont: fontHoursTimeCount];
        [_lblMinFirstLabel setFont: fontHoursTimeCount];
        [_lblColonSecondLabel setFont: fontHoursTimeCount];
        [_lblSecondsFirstLabel setFont: fontHoursTimeCount];
        [_lblMinSecondLabel setFont: fontExerciseCount];
        [_lblColonThirdLabel setFont: fontExerciseCount];
        [_lblSecondsSecondLabel setFont: fontExerciseCount];
        
        [_lblTotalTimeLabel setFrame: CGRectMake(0.0, (_viewHoursTimeContentView.frame.origin.y + _viewHoursTimeContentView.frame.size.height - 7.0), (_viewTotalTimeContentView.frame.size.width), 30.0)];
        [_lblTotalTimeLabel setFont: fontExerciseLabel];
        
        [_viewHoursTimeContentView setHidden: YES];
        [_viewMinTimeContentView setHidden: NO];
        
        [_btnStartRestButton setFrame: CGRectMake(0.0, 0.0, (_scrollViewSetAndRestScreen.frame.size.width), (_viewExerciseAndTotalTimeBackgroundView.frame.origin.y + _viewExerciseAndTotalTimeBackgroundView.frame.size.height))];
        
        [_btnSwipeButton setFrame: CGRectMake((_contentViewSetAndRestScreen.frame.size.width - 52.0) / 2.0, (_viewExerciseAndTotalTimeBackgroundView.frame.origin.y + _viewExerciseAndTotalTimeBackgroundView.frame.size.height + 34.0), 52.0, 20.0)];
        [self.btnMenu setFrame:CGRectMake((_contentViewSetAndRestScreen.frame.size.width - 52.0) / 2.0, (_btnSwipeButton.frame.origin.y + _btnSwipeButton.frame.size.height + 1.0), 52.0, 17.0)];
        
        //Bottom buttons view
        [_viewBottomButtonsBackgroundView setFrame: CGRectMake(0.0, (_btnSwipeButton.frame.origin.y + _btnSwipeButton.frame.size.height + 58.0),(_contentViewSetAndRestScreen.frame.size.width), 270.0)];
        
        [_viewUpperButtonsBackgroundView setFrame: CGRectMake(0.0, 0.0, (_viewBottomButtonsBackgroundView.frame.size.width), ((_viewBottomButtonsBackgroundView.frame.size.height - 32.0) / 2.0))];
        [_viewNextExerciseButtonContentView setFrame: CGRectMake(0.0, 0.0, (_viewUpperButtonsBackgroundView.frame.size.width / 2.0), _viewUpperButtonsBackgroundView.frame.size.height)];
        [_imgNextExerciseImage setFrame: CGRectMake(67.0, 0.0, 80.0, 80.0)];
        [_lblNextExerciseLabel setFrame: CGRectMake(57.0, (_imgNextExerciseImage.frame.origin.y + _imgNextExerciseImage.frame.size.height + 13.0), (_viewNextExerciseButtonContentView.frame.size.width - 57.0), 20.0)];
        UIFont *fontButtonsTitle = [UIFont fontWithName: fFUTURA_MEDIUM size: 16.0];
        [_lblNextExerciseLabel setFont: fontButtonsTitle];
        
        [_viewChangeRestButtonContentView setFrame: CGRectMake(_viewNextExerciseButtonContentView.frame.size.width, 0.0, (_viewUpperButtonsBackgroundView.frame.size.width / 2.0), _viewUpperButtonsBackgroundView.frame.size.height)];
        [_viewChangeRestView setFrame: CGRectMake((_viewChangeRestButtonContentView.frame.size.width - 80.0 - 66.0), 0.0, 80.0, 80.0)];
        [_lblChangeRestCountLabel setFrame: CGRectMake(0.0, (_viewChangeRestView.frame.size.height - 30.0) / 2.0, (_viewChangeRestView.frame.size.width), 30.0)];
        UIFont *fontChangeRestCount = [UIFont fontWithName: fFUTURA_MEDIUM size: 20.0];
        [_lblChangeRestCountLabel setFont: fontChangeRestCount];
        [_lblChangeRestLabel setFrame: CGRectMake(58.0, (_viewChangeRestView.frame.origin.y + _viewChangeRestView.frame.size.height + 13.0), (_viewChangeRestButtonContentView.frame.size.width - 38.0), 20.0)];
        [_lblChangeRestLabel setFont: fontButtonsTitle];
        
        [_viewLowerButtonsBackgroundView setFrame: CGRectMake(0.0, (_viewUpperButtonsBackgroundView.frame.size.height + 40.0), (_viewBottomButtonsBackgroundView.frame.size.width), ((_viewBottomButtonsBackgroundView.frame.size.height - 32.0) / 2.0))];
        [_viewSoundButtonContentView setFrame: CGRectMake(0.0, 0.0, (_viewLowerButtonsBackgroundView.frame.size.width / 2.0), _viewLowerButtonsBackgroundView.frame.size.height)];
        [_imgSoundImage setFrame: CGRectMake(67.0, 0.0, 80.0, 80.0)];
        [_lblSoundLabel setFrame: CGRectMake(70.0, (_imgSoundImage.frame.origin.y + _imgSoundImage.frame.size.height + 13.0), (_viewSoundButtonContentView.frame.size.width - 70.0), 20.0)];
        [_lblSoundLabel setFont: fontButtonsTitle];
        
        [_viewEndWorkoutButtonContentView setFrame: CGRectMake(_viewSoundButtonContentView.frame.size.width, 0.0, (_viewLowerButtonsBackgroundView.frame.size.width / 2.0), _viewLowerButtonsBackgroundView.frame.size.height)];
        [_imgEndWorkoutImage setFrame: CGRectMake((_viewEndWorkoutButtonContentView.frame.size.width - 80.0 - 66.0), 0.0, 80.0, 80.0)];
        [_lblEndWorkoutLabel setFrame: CGRectMake(56.0, (_imgEndWorkoutImage.frame.origin.y + _imgEndWorkoutImage.frame.size.height + 13.0), (_viewEndWorkoutButtonContentView.frame.size.width - 36.0), 20.0)];
        [_lblEndWorkoutLabel setFont: fontButtonsTitle];
        
        
        /*--------------------------------------------------------------------------------*/
        
        //Scroll and content view
        [_scrollViewWorkoutCompleteScreen setFrame: CGRectMake(DEVICE_WIDTH, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        [_scrollViewWorkoutCompleteScreen setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT)];
        [_contentViewWorkoutCompleteScreen setFrame: CGRectMake(0.0, 0.0, (_scrollViewWorkoutCompleteScreen.contentSize.width), (_scrollViewWorkoutCompleteScreen.contentSize.height))];
        
        //Gym Timer label
        [_lblGymTimerWorkoutScreenTitleLabel setFrame: CGRectMake(0.0, 36.0, (_contentViewSetAndRestScreen.frame.size.width), 40.0)];
        UIFont *fontGymTimerWorkoutScreenLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblGymTimerWorkoutScreenTitleLabel setFont: fontGymTimerWorkoutScreenLabel];
        // [_lblGymTimerWorkoutScreenTitleLabel setHidden: YES];
        
        //Workout Stats background view
        // Vsn - 09/04/2020
        [_viewPowerPopup setFrame: CGRectMake(23.0, 120, (_contentViewWorkoutCompleteScreen.frame.size.width - 49.0), 70.0)];

        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
        UIFont *font = [UIFont fontWithName:fFUTURA_MEDIUM_ITALIC size:13.0];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, [UIColor colorWithRed:0.0/255.0 green:220.0/255.0 blue:93.0/255.0 alpha:1], NSForegroundColorAttributeName, nil];
        [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@"Congratulations" attributes:attrsDictionary]];
        NSDictionary *attrsDict1 = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
        [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@" for working out today !" attributes:attrsDict1]];
        _lblCongratulationsText.attributedText = attrString;
        [_lblCongratulationsText updateConstraints];
        
        [_viewPowerPopupInfomation setFrame: CGRectMake(40.0, 0.0, (_lblCongratulationsText.frame.size.width + 24.0), (_lblCongratulationsText.frame.size.height + 14.0))];
        _viewPowerPopupInfomation.layer.cornerRadius = _viewPowerPopupInfomation.frame.size.height / 2;
        [_lblCongratulationsText setFrame: CGRectMake(12.0, 7.0, _lblCongratulationsText.frame.size.width, _lblCongratulationsText.frame.size.height)];
        // Vsn - 10/04/2020
            [_imgPowerPopupInfomationBg setFrame: CGRectMake(-16.0, -11.0, _viewPowerPopupInfomation.frame.size.width + 32.0, _viewPowerPopupInfomation.frame.size.height + 26.0)];
//        [_viewWorkoutStatsBackgroundView setFrame: CGRectMake(18.0, 175, (_contentViewWorkoutCompleteScreen.frame.size.width - 36.0), 414.0)];
        [_viewWorkoutStatsBackgroundView setFrame: CGRectMake(18.0, 155, (_contentViewWorkoutCompleteScreen.frame.size.width - 36.0), 414.0)];
        [_viewPowerPopup setFrame: CGRectMake(23.0, _viewWorkoutStatsBackgroundView.frame.origin.y + 15 - 70, (_contentViewWorkoutCompleteScreen.frame.size.width - 49.0), 70.0)];
        // End

        [[_viewWorkoutStatsBackgroundView layer] setCornerRadius: 30.0];
        
        
        //Stats content view
        CGFloat statsContentViewY = (_viewWorkoutStatsBackgroundView.frame.size.height - _viewWorkoutStatsBackgroundView.frame.size.width + 9.0);
        CGFloat statsContentWidth = _viewWorkoutStatsBackgroundView.frame.size.width;
        [_viewWorkoutStatsContentView setFrame: CGRectMake(0.0, statsContentViewY, setAndRestBgWidth, statsContentWidth - 9.0)];
        // Vsn - 09/04/2020
//        [_viewWorkoutStatsContentView setFrame: CGRectMake(0.0, 130, setAndRestBgWidth, 284)];
        [_viewWorkoutStatsContentView setFrame: CGRectMake(0.0, 0.0, setAndRestBgWidth, 284)];
        [_vwRandomWorkoutCompleteBackground setFrame: CGRectMake(0.0, _viewWorkoutStatsContentView.frame.size.height + 20.0, setAndRestBgWidth, 234)];
        [[_vwRandomWorkoutCompleteBackground layer] setCornerRadius: 30.0];
        // End
        [[_viewWorkoutStatsContentView layer] setCornerRadius: 30.0];
        
        //Do set number view and Rest time view
        CGFloat workoutCompleteViewHeight = (_viewWorkoutStatsBackgroundView.frame.size.height - _viewWorkoutStatsContentView.frame.size.height);
        [_viewWorkoutCompleteContentVIew setFrame: CGRectMake(0.0, 0.0, statsContentWidth, workoutCompleteViewHeight + 30.0)];
        [_lblWorkoutCompleteLabel setFrame: CGRectMake(31.0, (workoutCompleteViewHeight - 120.0), (statsContentWidth - 100.0), 120.0)];
        UIFont *fontWorkoutCompleteLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 45.0];
        [_lblWorkoutCompleteLabel setFont: fontWorkoutCompleteLabel];
        
        UIFont *currentDateLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 21.0];
        [_lblCurrentDateLabel setFrame: CGRectMake(0.0, 0.0, (_viewWorkoutStatsContentView.frame.size.width), 70.0)];
        [_lblCurrentDateLabel setFont: currentDateLabel];
        // Vsn - 10/04/2020
        [_lblRandomWorkoutCompleteTitle setFrame: _lblCurrentDateLabel.frame];
        [_lblRandomWorkoutCompleteTitle setFont:currentDateLabel];
        // End
        
        // New Design
        [self.vwDateTime setFrame:CGRectMake(0, 0, setAndRestBgWidth, 70)];
        [self.vwCompetedBottom setFrame:CGRectMake(0, 70, setAndRestBgWidth, 214)];
        // Vsn - 09/04/2020
        [_vwRandomWorkoutCompleteTitle setFrame:CGRectMake(0, 0, setAndRestBgWidth, 70)];
        [_vwRandomWorkoutCompleteSubTitle setFrame:CGRectMake(0, 70, setAndRestBgWidth, _vwRandomWorkoutCompleteBackground.frame.size.height - 70)];
        // End
        // Vsn - 10/04/2020
        [_lblRandomWorkoutCompleteSubTitle setFrame:CGRectMake(20.0, 20.0, setAndRestBgWidth - 40, _vwRandomWorkoutCompleteSubTitle.frame.size.height - 40)];
        
        if ([[Utils getIsPaidUser] isEqualToString: @"YES"]) {
            [_vwRandomWorkoutCompletePro setHidden: true];
            [self callGetExerciseHistoryAPI];
        } else {
            [_lblRandomWorkoutCompleteSubTitle setAttributedText: [self getWorkoutCompleteLastPopupText]];

            [_vwRandomWorkoutCompletePro setHidden: false];
            
            [_vwRandomWorkoutCompletePro setFrame: CGRectMake(_vwRandomWorkoutCompleteSubTitle.frame.origin.x + 25.0, _vwRandomWorkoutCompleteSubTitle.frame.origin.y - 15.0, _vwRandomWorkoutCompleteSubTitle.frame.size.width - 50.0, 30.0)];
            [[_vwRandomWorkoutCompletePro layer] setCornerRadius: 10.0];
            [[_vwRandomWorkoutCompletePro layer] setMasksToBounds: NO];
            [[_vwRandomWorkoutCompletePro layer] setShadowColor: [[UIColor blackColor] CGColor]];
            [[_vwRandomWorkoutCompletePro layer] setShadowOffset: CGSizeMake(1.0, 1.0)];
            [[_vwRandomWorkoutCompletePro layer] setShadowRadius: 10.0];
            [[_vwRandomWorkoutCompletePro layer] setShadowOpacity: 0.5];
            UIBezierPath *workoutViewShadowPathPro = [UIBezierPath bezierPathWithRect: [_vwRandomWorkoutCompletePro bounds]];
            [[_vwRandomWorkoutCompletePro layer] setShadowPath: [workoutViewShadowPathPro CGPath]];
            
            [_lblRandomWorkoutCompleteProText setFrame: CGRectMake(0.0, (_vwRandomWorkoutCompletePro.frame.size.height / 2) - 12.5, _vwRandomWorkoutCompletePro.frame.size.width, 25.0)];
            
            NSTextAttachment *attachment1 = [[NSTextAttachment alloc] init];
            attachment1.image = [UIImage imageNamed:@"lockgreen"];
            NSMutableAttributedString *attrString = [NSAttributedString attributedStringWithAttachment:attachment1].mutableCopy;
            UIFont *font = [UIFont fontWithName:fFUTURA_MEDIUM size:12.0];
            
            NSDictionary *attrsGreen = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, [UIColor colorWithRed:0.0/255.0 green:220.0/255.0 blue:93.0/255.0 alpha:1], NSForegroundColorAttributeName, nil];
            NSDictionary *attrsBackground = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:fFUTURA_BOLD size:14.0], NSFontAttributeName, [UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:56.0/255.0 alpha:1], NSForegroundColorAttributeName, [UIColor greenColor], NSBackgroundColorAttributeName, nil];

            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@"  These are exclusive for the " attributes:attrsGreen]];
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@"PRO" attributes:attrsBackground]];
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@" community" attributes:attrsGreen]];
            
            [_lblRandomWorkoutCompleteProText setAttributedText: attrString];
        }
        // End
        [self.vwQuality setFrame:CGRectMake(0, 0, setAndRestBgWidth / 2, 214)];
        [self.vwTime setFrame:CGRectMake(setAndRestBgWidth / 2, 0, setAndRestBgWidth / 2, 214)];
        
        [self.lblTotalTimeTitle setFrame:CGRectMake(16, 30, self.vwTime.frame.size.width - 16, 20)];
        
        [self.lblTotalExercisetitle setFrame:CGRectMake(16, 107, self.vwTime.frame.size.width - 16, 20)];
        [self.lblTotalExercise setFrame:CGRectMake(16, 134, self.vwTime.frame.size.width - 16, 41)];
        
        [self.lblQuality setFrame:CGRectMake(48, 30, 50, 20)];
        [self.vwQualityProgress setFrame:CGRectMake(38, 65, 118, 118)];
        
        self.vwQualityProgress.valueFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
        self.vwQualityProgress.valueFontSize = 32;
        self.vwQualityProgress.fontColor = cNEW_GREEN;
        self.vwQualityProgress.unitFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
        self.vwQualityProgress.unitFontSize = 18;
        
        
        //Total workout time views
        [_lblTotalWorkoutTimeLabel setHidden: YES];
        [_lblTotalWorkoutExercisesLabel setHidden: YES];
        
        [_viewHoursTimeFormatContentView setFrame: CGRectMake(37.0, (_lblCurrentDateLabel.frame.origin.y + _lblCurrentDateLabel.frame.size.height + 24.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
        [[_viewHoursTimeFormatContentView layer] setCornerRadius: 15.0];
        
        CGFloat timeCountLabelWidth = ([_viewHoursTimeFormatContentView frame].size.width / 6.0);
        CGFloat timeTitlelabelWidth = ([_viewHoursTimeFormatContentView frame].size.width / 6.0);
        
        [self.lblHours setFrame:CGRectMake(8, 54, 50, 41)];
        [self.lblMinutes setFrame:CGRectMake(self.lblHours.frame.origin.x + self.lblHours.frame.size.width, 54, 50, 41)];
        [self.lblSeconds setFrame:CGRectMake(self.lblMinutes.frame.origin.x + self.lblMinutes.frame.size.width, 54, 45, 41)];
        
        //Hours min sec format
        [_lblFirstHoursCountLabel setFrame: CGRectMake(19.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
        [_lblFirstHoursTitleLabel setFrame: CGRectMake((_lblFirstHoursCountLabel.frame.origin.x + _lblFirstHoursCountLabel.frame.size.width) - 0.0, 8.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
        [_lblFirstMinCountLabel setFrame: CGRectMake((_lblFirstHoursTitleLabel.frame.origin.x + _lblFirstHoursTitleLabel.frame.size.width) - 26.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
        [_lblFirstMinTitleLabel setFrame: CGRectMake((_lblFirstMinCountLabel.frame.origin.x + _lblFirstMinCountLabel.frame.size.width) - 0.5, 8.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
        [_lblFirstSecCountLabel setFrame: CGRectMake((_lblFirstMinTitleLabel.frame.origin.x + _lblFirstMinTitleLabel.frame.size.width) - 6.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
        [_lblFirstSecTitleLabel setFrame: CGRectMake((_lblFirstSecCountLabel.frame.origin.x + _lblFirstSecCountLabel.frame.size.width) - 0.0, 8.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
        
        //Min sec format
        [_viewMinTimeFormatContentView setFrame: CGRectMake(37.0, (_lblCurrentDateLabel.frame.origin.y + _lblCurrentDateLabel.frame.size.height + 24.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
        [[_viewMinTimeFormatContentView layer] setCornerRadius: 15.0];
        [_lblSecondMinCountLabel setFrame: CGRectMake(44.0, 0.0, (timeCountLabelWidth + 8.0), (_viewMinTimeFormatContentView.frame.size.height))];
        [_lblSecondMinTitleLabel setFrame: CGRectMake((_lblSecondMinCountLabel.frame.origin.x + _lblSecondMinCountLabel.frame.size.width) - 0.0, 12.0, timeTitlelabelWidth, (_viewMinTimeFormatContentView.frame.size.height - 12.0))];
        [_lblSecondSecCountLabel setFrame: CGRectMake((_lblSecondMinTitleLabel.frame.origin.x + _lblSecondMinTitleLabel.frame.size.width) - 4.0, 0.0, (timeCountLabelWidth + 8.0), (_viewMinTimeFormatContentView.frame.size.height))];
        [_lblSecondSecTitleLabel setFrame: CGRectMake((_lblSecondSecCountLabel.frame.origin.x + _lblSecondSecCountLabel.frame.size.width) - 0.0, 12.0, timeTitlelabelWidth, (_viewMinTimeFormatContentView.frame.size.height - 12.0))];
        
        //Total exercise view
        [_viewTotalExerciseContentView setFrame: CGRectMake(37.0, (_viewHoursTimeFormatContentView.frame.origin.y + _viewHoursTimeFormatContentView.frame.size.height + 18.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
        [[_viewTotalExerciseContentView layer] setCornerRadius: 15.0];
        [_lblTotalExerciseCountLabel setFrame: CGRectMake(45.0, 0.0, (timeCountLabelWidth + 8.0), (_viewTotalExerciseContentView.frame.size.height - 1.0))];
        [_lblExerciseTitleLabel setFrame: CGRectMake((_lblTotalExerciseCountLabel.frame.origin.x + _lblTotalExerciseCountLabel.frame.size.width), 11.0, (_viewTotalExerciseContentView.frame.size.width - (_lblTotalExerciseCountLabel.frame.origin.x + _lblTotalExerciseCountLabel.frame.size.width)), (_viewTotalExerciseContentView.frame.size.height - 11.0))];
        
        lblCounting = [[UICountingLabel alloc] initWithFrame: CGRectMake(60.0, (_viewTotalExerciseContentView.frame.origin.y + _viewTotalExerciseContentView.frame.size.height + 12.0), 100.0, 40.0)];
        [_viewWorkoutStatsContentView addSubview: lblCounting];
        
        [self.lblShortWorkoutMsg setFrame:CGRectMake(20, self.viewWorkoutStatsBackgroundView.frame.origin.y + self.viewWorkoutStatsBackgroundView.frame.size.height + 8, self.viewWorkoutStatsBackgroundView.frame.size.width, 32)];
        // Vsn - 09/04/2020
//        [self.btnDoneWorkoutButton setFrame:CGRectMake(self.view.frame.size.width / 2 + 40, self.viewWorkoutStatsBackgroundView.frame.origin.y + self.viewWorkoutStatsBackgroundView.frame.size.height + 70, 80, 80)];
//        [self.btnShareStatsButton setFrame:CGRectMake(self.view.frame.size.width / 2 - 120, self.viewWorkoutStatsBackgroundView.frame.origin.y + self.viewWorkoutStatsBackgroundView.frame.size.height + 70, 80, 80)];
        [self.btnDoneWorkoutButton setFrame:CGRectMake(self.view.frame.size.width / 2 + 40, self.viewWorkoutStatsBackgroundView.frame.origin.y + self.vwRandomWorkoutCompleteBackground.frame.origin.y + self.vwRandomWorkoutCompleteBackground.frame.size.height + 40, 80, 80)];
        [self.btnShareStatsButton setFrame:CGRectMake(self.view.frame.size.width / 2 - 120, self.viewWorkoutStatsBackgroundView.frame.origin.y + self.vwRandomWorkoutCompleteBackground.frame.origin.y + self.vwRandomWorkoutCompleteBackground.frame.size.height + 40, 80, 80)];
        // End
                
    } else if (IS_IPHONEX) {
        
        //Loader view
        [_viewLoaderBackgroundView setFrame: CGRectMake(0.0, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        [_lblLoaderGymTimerLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLoaderLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblLoaderGymTimerLabel setFont: fontGymTimerLoaderLabel];
        [_viewLoaderContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        //Scroll and Content view
        [_scrollViewWorkoutScreen setFrame: CGRectMake(0.0, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
        [_contentViewWorkoutScreen setFrame: CGRectMake(0.0, 0.0, (_scrollViewWorkoutScreen.frame.size.width), (_scrollViewWorkoutScreen.frame.size.height))];
        CGFloat contentViewWidth = _contentViewWorkoutScreen.frame.size.width;
        CGFloat contentViewHeight = _contentViewWorkoutScreen.frame.size.height;
        
        //GymTimer label
        [_lblGymTimerTitleLabel setFrame: CGRectMake(0.0, -11.0, (_contentViewWorkoutScreen.frame.size.width), 102.0)];
        UIFont *fontGymTimer = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 64.7];
        [_lblGymTimerTitleLabel setFont: fontGymTimer];
        
        // Vsn - 11/02/2020
        [_lblBoostYourWorkoutsSetScreenLabel setFrame: CGRectMake((_contentViewWorkoutScreen.frame.size.width / 2.0) - 154.0, 36.0, (_contentViewWorkoutScreen.frame.size.width), 80.0)];
//        [_lblBoostYourWorkoutsSetScreenLabel setFrame: CGRectMake((_contentViewWorkoutScreen.frame.size.width / 2.0) - 121.0, 40.0, (_contentViewWorkoutScreen.frame.size.width), 80.0)];
//        [lblBoostYourWorkoutText addAttribute:NSKernAttributeName value:@3.4 range:NSMakeRange(0, lblBoostYourWorkoutText.length)];
//        [_lblBoostYourWorkoutsSetScreenLabel setAttributedText: lblBoostYourWorkoutText];
        UIFont *fontGymTimer1 = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 22.0];
        [_lblBoostYourWorkoutsSetScreenLabel setFont: fontGymTimer1];
        
        //Start Workout content view
        CGFloat gymtimerY = _lblGymTimerTitleLabel.frame.origin.y;
        CGFloat gymtimerHeight = _lblGymTimerTitleLabel.frame.size.height;
        CGFloat tabbarHeight = 53.0;
        //        CGFloat tabbarHeight = [[[self tabBarController] tabBar] frame].size.height;
        [_viewWorkoutContentView setFrame: CGRectMake(18.0, (_lblGymTimerTitleLabel.frame.origin.y + _lblGymTimerTitleLabel.frame.size.height + 24.0), (contentViewWidth - 36.0), (contentViewHeight - (gymtimerY + gymtimerHeight + tabbarHeight + 90.0)))];
        // Vsn - 19/02/2020
        [_viewWorkoutContentViewSubView setFrame: CGRectMake(0.0, 0.0, _viewWorkoutContentView.frame.size.width, _viewWorkoutContentView.frame.size.height)];
        // Vsn - 25/02/2020
        [_vwImgWelcomeBack setFrame: CGRectMake(0.0, 0.0, _viewWorkoutContentView.frame.size.width, _viewWorkoutContentView.frame.size.height)];
        [_vwWorkoutContentParent setFrame:CGRectMake(0.0, 0.0, _viewWorkoutContentView.frame.size.width, _viewWorkoutContentView.frame.size.height)];
        // Vsn - 05/02/2020
        [_imgHomeBottomGym setFrame: CGRectMake(-21.0, -19.0, _viewWorkoutContentView.frame.size.width + 42.0, _viewWorkoutContentView.frame.size.height + 45.0)];
        
        //Choose default rest time label
        CGFloat workoutContentViewWidth = _viewWorkoutContentView.frame.size.width;
        UIFont *fontMinSec = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [_lblChooseDefaultTimeLabel setFrame: CGRectMake(0.0, 52.0, (workoutContentViewWidth), 42.0)];
        
        [_lblChooseDefaultTimeLabel setFont: fontMinSec];
        [_lblChooseDefaultTimeLabel setAlpha: 0.5];
        
        // Vsn - 10/02/2020
        //Rest time picker view
        [_pickerWorkoutRestTimePickerView setFrame: CGRectMake(32.0, (_lblChooseDefaultTimeLabel.frame.origin.y + _lblChooseDefaultTimeLabel.frame.size.height + 10.0), (workoutContentViewWidth - 64.0), 270.0)];
//        [_pickerWorkoutRestTimePickerView setFrame: CGRectMake(32.0, (_lblChooseDefaultTimeLabel.frame.origin.y + _lblChooseDefaultTimeLabel.frame.size.height + 30.0), (workoutContentViewWidth - 64.0), 308.0)];
        
        //Minute and seconds view
        [_viewMinutesSecondsContentView setFrame: CGRectMake(0.0, (_lblChooseDefaultTimeLabel.frame.origin.y + _lblChooseDefaultTimeLabel.frame.size.height + 130.0), workoutContentViewWidth, 22.0)];
        [_lblMinuteLabel setFrame: CGRectMake(143.0, 0.0, 30.0, 21.0)];
        [_lblSecondsLabel setFrame: CGRectMake(246.0, 0.0, 15.0, 21.0)];
        [_lblMinuteLabel setFont: fontMinSec];
        [_lblSecondsLabel setFont: fontMinSec];
        
        {//Dinal2-done
            
            UIFont *newBtnFont = [UIFont fontWithName: fFUTURA_BOLD size: 13.0];
            [_btnEndurance.titleLabel setFont:newBtnFont];
            [_btnMuscle.titleLabel setFont:newBtnFont];
            [_btnpower.titleLabel setFont:newBtnFont];
            //            [_lblRecommend setFont:newBtnFont];
            
            UIFont *newGreenFont = [UIFont fontWithName: fFUTURA_MEDIUM size: 12.0];
            [_lblRange1 setFont:newGreenFont];
            [_lblRange2 setFont:newGreenFont];
            [_lblRange11 setFont:newGreenFont];
            [_lblRange22 setFont:newGreenFont];
            
            UIFont *newSetRepsFont = [UIFont fontWithName: fFUTURA_MEDIUM size: 12.0];
            [_lblSets setFont:newSetRepsFont];
            [_lblReps setFont:newSetRepsFont];
            [_lblRecommend setFont:newSetRepsFont];
            
            UIFont *newScientificFont = [UIFont fontWithName: fFUTURA_MEDIUM size: 12.5];
            [_lblScientific setFont:newScientificFont];
            
            CGFloat widthParent = _viewTabParent.frame.size.width;
            
            CGRect frameRecommend = _lblRecommend.frame;
            frameRecommend.size.width = widthParent * 0.4210;
            frameRecommend.origin.x += 3.0;
            [_lblRecommend setFrame:frameRecommend];
            
            CGRect frameRange1 = _lblRange1.frame;
            //            frameRange1.size.width = widthParent * 0.0964;
            frameRange1.origin.x = frameRecommend.origin.x + frameRecommend.size.width - 17.0;
            [_lblRange1 setFrame:frameRange1];
            
            CGRect minus1 = _lblMinus1.frame;
            //            minus1.size.width = widthParent * 0.0964;
            minus1.origin.x = _lblRange1.frame.origin.x + _lblRange1.frame.size.width - 2.0;
            [_lblMinus1 setFrame:minus1];
            
            CGRect frameRange11 = _lblRange11.frame;
            frameRange11.size.width += 3.0;
            frameRange11.origin.x = _lblMinus1.frame.origin.x + _lblMinus1.frame.size.width - 4.0;
            [_lblRange11 setFrame:frameRange11];
            
            CGRect frameSets = _lblSets.frame;
            frameSets.size.width = widthParent * 0.1096;
            frameSets.origin.x = frameRange11.origin.x + frameRange11.size.width;
            [_lblSets setFrame:frameSets];
            
            CGRect frameSeprator1 = _lblSeparator1.frame;
            frameSeprator1.size.width = 1.0;
            frameSeprator1.origin.x = frameSets.origin.x + frameSets.size.width - 1.0;
            [_lblSeparator1 setFrame:frameSeprator1];
            
            CGRect frameRange2 = _lblRange2.frame;
            //            frameRange2.size.width = widthParent * 0.0964;
            frameRange2.origin.x = frameSeprator1.origin.x + frameSeprator1.size.width + 5.0;
            // Vsn - 09/04/2020
            frameRange2.size.width = frameRange2.size.width + 7.0;
            // End
            [_lblRange2 setFrame:frameRange2];
            
            CGRect minus2 = _lblMinus2.frame;
            //minus2.size.width = widthParent * 0.0964;
            minus2.origin.x = _lblRange2.frame.origin.x + _lblRange2.frame.size.width - 2.0;
            [_lblMinus2 setFrame:minus2];
            
            CGRect frameRange22 = _lblRange22.frame;
            frameRange22.size.width += 3.0;
            frameRange22.origin.x = _lblMinus2.frame.origin.x + _lblMinus2.frame.size.width - 4.0;
            [_lblRange22 setFrame:frameRange22];
            
            CGRect frameReps = _lblReps.frame;
            frameReps.size.width = widthParent * 0.1228;
            frameReps.origin.x = frameRange22.origin.x + frameRange22.size.width;
            [_lblReps setFrame:frameReps];
            
            CGRect frameSeprator2 = _lblSeparator2.frame;
            frameSeprator2.size.width = 1.0;
            frameSeprator2.origin.x = frameReps.origin.x + frameReps.size.width;
            [_lblSeparator2 setFrame:frameSeprator2];
            
            CGRect frameDumbell = _imgDumbell.frame;
            frameDumbell.size.width = widthParent * 0.1140;
            frameDumbell.origin.x = frameSeprator2.origin.x + frameSeprator2.size.width + 3.0;
            [_imgDumbell setFrame:frameDumbell];
            
            CGRect frameSci = _lblScientific.frame;
            frameSci.origin.x -= 1.5;
            [_lblScientific setFrame:frameSci];
            
            CGRect frameArrow = _btnArrowScientifically.frame;
            frameArrow.origin.x = frameSci.origin.x + _lblScientific.frame.size.width + 5.0;
            [_btnArrowScientifically setFrame:frameArrow];
        }
        
        //Start workout button
        // Vsn - 05/02/2020
        // Vsn - 10/02/2020
        [_btnStartWorkoutButton setFrame: CGRectMake(60.0, (_viewWorkoutContentView.frame.size.height - 150.0)-10+5, (workoutContentViewWidth - 100.0) - 20.0, 60.0 - 10)];
        [_btnStartWorkoutButton setBackgroundColor: UIColorFromRGB(0x14CC64)];
        UIFont *fontStartButton = [UIFont fontWithName: fFUTURA_BOLD size: 22.0];
        dicStartButtonAttributes = [[NSDictionary alloc] init];
        dicStartButtonAttributes = @{ NSForegroundColorAttributeName :  UIColorFromRGB(0x009938),
                                      NSFontAttributeName : fontStartButton
        };
        NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"Start Workout" attributes: dicStartButtonAttributes];
        [_btnStartWorkoutButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
        [[_btnStartWorkoutButton layer] setCornerRadius: _btnStartWorkoutButton.frame.size.height / 3.5]; //17.0
        
        /*--------------------------------------------------------------------------------*/
        
        //Scroll and content view
        [_scrollViewSetAndRestScreen setFrame: CGRectMake(DEVICE_WIDTH, -44.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
        //        [_scrollViewSetAndRestScreen setFrame: CGRectMake(DEVICE_WIDTH, 44.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
        [_scrollViewSetAndRestScreen setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + 221.0 + 44.0)];
        [_contentViewSetAndRestScreen setFrame: CGRectMake(0.0, 0.0, (_scrollViewSetAndRestScreen.frame.size.width), (_scrollViewSetAndRestScreen.contentSize.height + 104.0))];
        
        //Gym Timer label
        [_lblGymTimerSetScreenLabel setFrame: CGRectMake(0.0, 36.0, (_contentViewSetAndRestScreen.frame.size.width), 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblGymTimerSetScreenLabel setFont: fontGymTimerLabel];
        
        //Set and rest background view
        CGFloat setAndRestBgViewY = (_lblGymTimerSetScreenLabel.frame.origin.y + _lblGymTimerSetScreenLabel.frame.size.height + 32.0);
        [_viewSetAndRestBackgroundView setFrame: CGRectMake(18.0, setAndRestBgViewY, (_contentViewSetAndRestScreen.frame.size.width - 36.0), 502.0)];
        [[_viewSetAndRestBackgroundView layer] setCornerRadius: 30.0];
        
        //Progress bar background view
        CGFloat setAndRestProgressBarBgViewY = (_viewSetAndRestBackgroundView.frame.size.height - _viewSetAndRestBackgroundView.frame.size.width + 9.0);
        CGFloat setAndRestBgWidth = _viewSetAndRestBackgroundView.frame.size.width;
        [_viewSetAndRestScreenProgressBackgroundView setFrame: CGRectMake(0.0, setAndRestProgressBarBgViewY, setAndRestBgWidth, setAndRestBgWidth - 9.0)];
        [[_viewSetAndRestScreenProgressBackgroundView layer] setCornerRadius: 30.0];
        
        // Warm up view
        [self.vwWarmUp setFrame: CGRectMake(0.0, setAndRestProgressBarBgViewY, setAndRestBgWidth, setAndRestBgWidth - 9.0)];
        
        //Do set number view and Rest time view
        [_viewDoSetNumberContentView setHidden: YES];
        [_viewRestTimeContentView setHidden: NO];
        CGFloat doSetNumberViewHeight = (_viewSetAndRestBackgroundView.frame.size.height - _viewSetAndRestScreenProgressBackgroundView.frame.size.height);
        [_viewDoSetNumberContentView setFrame: CGRectMake(0.0, 0.0, setAndRestBgWidth, doSetNumberViewHeight)];
        
        [_lblDoSetNumberCountLabel setFrame: CGRectMake((setAndRestBgWidth - 121.0), 6.0, 121.0, (doSetNumberViewHeight - 6.0))];
        UIFont *fontDoSetCount = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 142.0];
        [_lblDoSetNumberCountLabel setFont: fontDoSetCount];
        [self adjustFontOfDoSetCountLabel];
        
        [_lblDoSetNumberLabel setFrame: CGRectMake(0.0, (doSetNumberViewHeight - 123.0), (setAndRestBgWidth - _lblDoSetNumberCountLabel.frame.size.width - 10.5), 123.0)];
        UIFont *fontDoSetLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0];
        [_lblDoSetNumberLabel setFont: fontDoSetLabel];
        
        [_viewRestTimeContentView setFrame: CGRectMake(0.0, 0.0, setAndRestBgWidth, doSetNumberViewHeight)];
        CGFloat restTimerColonWidth = 40.0;
        CGFloat restTimerMinSecWidth = (setAndRestBgWidth - restTimerColonWidth) / 2.0;
        [_lblRestTimerMinutesLabel setFrame: CGRectMake(0.0, 0.0, restTimerMinSecWidth, doSetNumberViewHeight)];
        [_lblRestTimerColonLabel setFrame: CGRectMake((_lblRestTimerMinutesLabel.frame.size.width), 0.0, restTimerColonWidth, doSetNumberViewHeight)];
        [_lblRestTimerSecondsLabel setFrame: CGRectMake((_lblRestTimerColonLabel.frame.origin.x + _lblRestTimerColonLabel.frame.size.width), 0.0, restTimerMinSecWidth, doSetNumberViewHeight)];
        
        [self.vwLastExercise setFrame:CGRectMake(0.0, 0.0, setAndRestBgWidth, doSetNumberViewHeight)];
        [self.lblTimeSinceTitle setFrame:CGRectMake(20.0, 20.0, self.vwLastExercise.frame.size.width - 40.0, 29.0)];
        [self.lblTimeSince setFrame:CGRectMake(20.0, (self.lblTimeSinceTitle.frame.origin.y + self.lblTimeSinceTitle.frame.size.height) - 8 , self.vwLastExercise.frame.size.width - 40.0, 116.0)];
        
        UIFont *fontRestTimeLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 110.0];
        [_lblRestTimerMinutesLabel setFont: fontRestTimeLabel];
        [_lblRestTimerColonLabel setFont: fontRestTimeLabel];
        [_lblRestTimerSecondsLabel setFont: fontRestTimeLabel];
        
        //View last exercise
        CGFloat viewProgressBarHeight = _viewSetAndRestScreenProgressBackgroundView.frame.size.height;
        CGFloat viewProgressBarWidth = _viewSetAndRestScreenProgressBackgroundView.frame.size.width;
        
        [_viewLastExerciseTimeContentView setFrame: CGRectMake(22.0, 12.0, viewProgressBarWidth, 80.0)];
        [_lblSinceLastExerciseLabel setFrame: CGRectMake(0.0, 0.0, (_viewLastExerciseTimeContentView.frame.size.width), 30.0)];
        UIFont *fontSinceLastExerciseLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
        [_lblSinceLastExerciseLabel setFont: fontSinceLastExerciseLabel];
        
        CGFloat lastExerciseColonWidth = 12.0;
        CGFloat hoursFormatCountWidth = 40.0;
        
        //Hours format
        [_viewLastExerciseHoursFormat setFrame: CGRectMake(-16.0, 14.0, (_viewLastExerciseTimeContentView.frame.size.width), (_viewLastExerciseTimeContentView.frame.size.height - (_lblSinceLastExerciseLabel.frame.origin.y + _lblSinceLastExerciseLabel.frame.size.height)))];
        
        UIFont *fontLastExerciseHourFormat = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 20.0];
        [_lblLastExerciseFirstHourLabel setFrame: CGRectMake(0.0, 0.0, hoursFormatCountWidth, (_viewLastExerciseHoursFormat.frame.size.height))];
        [_lblLastExerciseHourFirstColonLabel setFrame: CGRectMake((_lblLastExerciseFirstHourLabel.frame.origin.x + _lblLastExerciseFirstHourLabel.frame.size.width), 0.0, (lastExerciseColonWidth - 4.0), (_viewLastExerciseHoursFormat.frame.size.height))];
        [_lblLastExerciseFirstMinLabel setFrame: CGRectMake((_lblLastExerciseHourFirstColonLabel.frame.origin.x + _lblLastExerciseHourFirstColonLabel.frame.size.width) - 5.0, 0.0, hoursFormatCountWidth, (_viewLastExerciseHoursFormat.frame.size.height))];
        [_lblLastExerciseHourSecondColonLabel setFrame: CGRectMake((_lblLastExerciseFirstMinLabel.frame.origin.x + _lblLastExerciseFirstMinLabel.frame.size.width) - 5.0, 0.0, (lastExerciseColonWidth - 4.0), (_viewLastExerciseHoursFormat.frame.size.height))];
        [_lblLastExerciseFirstSecLabel setFrame: CGRectMake((_lblLastExerciseHourSecondColonLabel.frame.origin.x + _lblLastExerciseHourSecondColonLabel.frame.size.width), 0.0, hoursFormatCountWidth, (_viewLastExerciseHoursFormat.frame.size.height))];
        [_lblLastExerciseFirstHourLabel setFont: fontLastExerciseHourFormat];
        [_lblLastExerciseHourFirstColonLabel setFont: fontLastExerciseHourFormat];
        [_lblLastExerciseFirstMinLabel setFont: fontLastExerciseHourFormat];
        [_lblLastExerciseHourSecondColonLabel setFont: fontLastExerciseHourFormat];
        [_lblLastExerciseFirstSecLabel setFont: fontLastExerciseHourFormat];
        
        //Minutes format
        CGFloat minuteFormatCountWidth = 40.0;
        UIFont *fontLastExerciseMinuteFormat = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 24.5];
        
        [_viewLastExerciseMinuteFormat setFrame: CGRectMake(-10.0, 18.0, (_viewLastExerciseTimeContentView.frame.size.width), (_viewLastExerciseTimeContentView.frame.size.height - (_lblSinceLastExerciseLabel.frame.origin.y + _lblSinceLastExerciseLabel.frame.size.height)))];
        
        [_lblLastExerciseSecondMinLabel setFrame: CGRectMake(0.0, 0.0, minuteFormatCountWidth, (_viewLastExerciseMinuteFormat.frame.size.height))];
        [_lblLastExerciseSecondColonLabel setFrame: CGRectMake((_lblLastExerciseSecondMinLabel.frame.origin.x + _lblLastExerciseSecondMinLabel.frame.size.width), 0.0, lastExerciseColonWidth, (_viewLastExerciseMinuteFormat.frame.size.height))];
        [_lblLastExerciseSecondSecLabel setFrame: CGRectMake((_lblLastExerciseSecondColonLabel.frame.origin.x + _lblLastExerciseSecondColonLabel.frame.size.width), 0.0, minuteFormatCountWidth, (_viewLastExerciseMinuteFormat.frame.size.height))];
        [_lblLastExerciseSecondMinLabel setFont: fontLastExerciseMinuteFormat];
        [_lblLastExerciseSecondColonLabel setFont: fontLastExerciseMinuteFormat];
        [_lblLastExerciseSecondSecLabel setFont: fontLastExerciseMinuteFormat];
        
        //Progress bar view and dumbells image
        [self setupProgressBar];
        [self.progressBarSetScreenView setFrame: CGRectMake(47.5, 47.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
        [_progressBarRestScreenView setFrame: CGRectMake(47.5, 47.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
        [_progressBarRestBackgroungView setFrame: CGRectMake(47.5, 47.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
        [_vwRestScreenDumbellsBackgroundImage setFrame: CGRectMake(47.5, 47.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];

        // Vsn - 05/02/2020
        CGFloat progressBarHeight = _progressBarSetScreenView.frame.size.height;
        CGFloat progressBarWidth = _progressBarSetScreenView.frame.size.width;
        CGFloat greenDumbellsImageWidth = 95.0;
        CGFloat greenDumbellsImageHeight = 146.0;
        CGFloat redDumbellsImageWidth = 190.0;
        CGFloat redDumbellsImageHeight = 182.0;

        [self.imgRestScreenDumbellsImage setFrame: CGRectMake(((progressBarWidth - redDumbellsImageWidth) / 2.0) + 0.5, ((progressBarHeight - redDumbellsImageHeight) / 2.0) + 12.0, redDumbellsImageWidth, redDumbellsImageHeight)];
        [self.imgRestScreenDumbellsBackgroundImage setFrame: self.imgRestScreenDumbellsImage.frame];

//        CGFloat progressBarHeight = _progressBarSetScreenView.frame.size.height;
//        CGFloat progressBarWidth = _progressBarSetScreenView.frame.size.width;
//        CGFloat redDumbellsImageWidth = 60.0;
//        CGFloat redDumbellsImageHeight = 128.0;
//        [self.imgRestScreenDumbellsImage setFrame: CGRectMake(((progressBarWidth - redDumbellsImageWidth) / 2.0) + 4.0, ((progressBarHeight - redDumbellsImageHeight) / 2.0) + 10.0, redDumbellsImageWidth, redDumbellsImageHeight)];
        
        [self.imgRestScreenDumbellsImage setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
        
        // Set Character
        [self.imgSetScreenDumbellsImage setFrame:CGRectMake(47.5, 20, greenDumbellsImageWidth, greenDumbellsImageHeight)];
        self.imgSetScreenDumbellsImage.center = CGPointMake(self.viewSetAndRestScreenProgressBackgroundView.bounds.size.width  / 2, 140.0);

        // Next Exercise Progress Ring
        [self.vwNextExercise setFrame: CGRectMake(47.5, 47.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
        [self.vwNextExerciseRing setFrame:CGRectMake(0, 0, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
        [self.imgNextExercise setFrame:CGRectMake(0.0, 0.0, 90, 140)];
        self.imgNextExercise.center = CGPointMake(self.vwNextExercise.frame.size.width  / 2, self.vwNextExercise.frame.size.height / 2);
        
        //Click anywhere and Next set view
        [_viewClickAnywhereContentView setFrame: CGRectMake(0.0, (viewProgressBarHeight - 59.0), viewProgressBarWidth, 59.0)];
        [_lblClickAnywhereToRestLabel setFrame: CGRectMake(1.0, 0.0, (_viewClickAnywhereContentView.frame.size.width - 1.0), (_viewClickAnywhereContentView.frame.size.height))];
        UIFont *fontClickAnywhereLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [_lblClickAnywhereToRestLabel setFont: fontClickAnywhereLabel];
        
        // Vsn - 05/02/2020
        [_viewNextSetContentView setFrame: CGRectMake(0.0, 0.0, viewProgressBarWidth, 120.0)];
        [_lblNextSetCountLabel setFrame: CGRectMake((_viewNextSetContentView.frame.size.width - 82.0), 25.0, 75.0, 90.0)];
        UIFont *fontNextSetCountLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 73.0];
        [_lblNextSetCountLabel setFont: fontNextSetCountLabel];
        [[_lblNextSetCountLabel layer] setCornerRadius: 30.0];
        [_lblNextSetLabel setFrame: CGRectMake(0.0, 0.0, (_viewNextSetContentView.frame.size.width - 25.0), 40.0)];
        
//        [_viewNextSetContentView setFrame: CGRectMake(0.0, (viewProgressBarHeight - 60.0), viewProgressBarWidth, 60.0)];
//        [_viewNextSetContentView setFrame: CGRectMake(0.0, 0.0, viewProgressBarWidth, 60.0)];
//        [_lblNextSetCountLabel setFrame: CGRectMake((_viewNextSetContentView.frame.size.width - 60.0), 0.0, 60.0, 60.0)];
//        UIFont *fontNextSetCountLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0];
//        [_lblNextSetLabel setFrame: CGRectMake(0.0, (_viewNextSetContentView.frame.size.height - 40.0), (_viewNextSetContentView.frame.size.width - _lblNextSetCountLabel.frame.size.width - 9.0), 40.0)];
        UIFont *fontNextSetLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
        [_lblNextSetLabel setFont: fontNextSetLabel];
        
        [_viewExerciseAndTotalTimeBackgroundView setFrame: CGRectMake(0.0, (_viewSetAndRestBackgroundView.frame.origin.y + _viewSetAndRestBackgroundView.frame.size.height + 25.0), (_contentViewSetAndRestScreen.frame.size.width), 100.0)];
        [_viewExerciseContentView setFrame: CGRectMake(18.0, 0.0, (_viewExerciseAndTotalTimeBackgroundView.frame.size.width - 54.0) / 2.0, 100.0)];
        [_lblExerciseCountLabel setFrame: CGRectMake(0.0, 15.0, (_viewExerciseContentView.frame.size.width), 50.0)];
        UIFont *fontExerciseCount = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0];
        [_lblExerciseCountLabel setFont: fontExerciseCount];
        [_lblExerciseLabel setFrame: CGRectMake(0.0, (_lblExerciseCountLabel.frame.origin.y + _lblExerciseCountLabel.frame.size.height - 7.0), (_viewExerciseContentView.frame.size.width), 30.0)];
        UIFont *fontExerciseLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.1];
        [_lblExerciseLabel setFont: fontExerciseLabel];
        [_viewTotalTimeContentView setFrame: CGRectMake((_viewExerciseContentView.frame.origin.x + _viewExerciseContentView.frame.size.width + 18.0), 0.0, (_viewExerciseAndTotalTimeBackgroundView.frame.size.width - 54.0) / 2.0, 100.0)];
        [[_viewExerciseContentView layer] setCornerRadius: 30.0];
        [[_viewTotalTimeContentView layer] setCornerRadius: 30.0];
        
        [_viewHoursTimeContentView setFrame: CGRectMake(0.0, 0.0, (_viewTotalTimeContentView.frame.size.width), 65.0)];
        CGFloat colonWidth = 12.0;
        CGFloat timeHoursWidth = ((_viewHoursTimeContentView.frame.size.width - (2 * colonWidth)) / 3.0) - 4.0;
        [_lblHoursFirstLabel setFrame: CGRectMake(6.0, 15.0, timeHoursWidth, 50.0)];
        [_lblColonFirstLabel setFrame: CGRectMake((_lblHoursFirstLabel.frame.origin.x + _lblHoursFirstLabel.frame.size.width), 15.0, colonWidth, 50.0)];
        [_lblMinFirstLabel setFrame: CGRectMake((_lblColonFirstLabel.frame.origin.x + _lblColonFirstLabel.frame.size.width), 15.0, timeHoursWidth, 50.0)];
        [_lblColonSecondLabel setFrame: CGRectMake((_lblMinFirstLabel.frame.origin.x + _lblMinFirstLabel.frame.size.width), 15.0, colonWidth, 50.0)];
        [_lblSecondsFirstLabel setFrame: CGRectMake((_lblColonSecondLabel.frame.origin.x + _lblColonSecondLabel.frame.size.width), 15.0, timeHoursWidth, 50.0)];
        UIFont *fontHoursTimeCount = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 28.0];
        
        [_viewMinTimeContentView setFrame: CGRectMake(0.0, 0.0, (_viewTotalTimeContentView.frame.size.width), 65.0)];
        CGFloat timeMinutesWidth = (_viewHoursTimeContentView.frame.size.width - colonWidth) / 2.0;
        [_lblMinSecondLabel setFrame: CGRectMake(0.0, 15.0, timeMinutesWidth, 50.0)];
        [_lblColonThirdLabel setFrame: CGRectMake((_lblMinSecondLabel.frame.origin.x + _lblMinSecondLabel.frame.size.width), 15.0, colonWidth, 50.0)];
        [_lblSecondsSecondLabel setFrame: CGRectMake((_lblColonThirdLabel.frame.origin.x + _lblColonThirdLabel.frame.size.width), 15.0, timeMinutesWidth, 50.0)];
        
        [_lblHoursFirstLabel setFont: fontHoursTimeCount];
        [_lblColonFirstLabel setFont: fontHoursTimeCount];
        [_lblMinFirstLabel setFont: fontHoursTimeCount];
        [_lblColonSecondLabel setFont: fontHoursTimeCount];
        [_lblSecondsFirstLabel setFont: fontHoursTimeCount];
        [_lblMinSecondLabel setFont: fontExerciseCount];
        [_lblColonThirdLabel setFont: fontExerciseCount];
        [_lblSecondsSecondLabel setFont: fontExerciseCount];
        
        [_lblTotalTimeLabel setFrame: CGRectMake(0.0, (_viewHoursTimeContentView.frame.origin.y + _viewHoursTimeContentView.frame.size.height - 7.0), (_viewTotalTimeContentView.frame.size.width), 30.0)];
        [_lblTotalTimeLabel setFont: fontExerciseLabel];
        
        [_viewHoursTimeContentView setHidden: YES];
        [_viewMinTimeContentView setHidden: NO];
        
        [_btnStartRestButton setFrame: CGRectMake(0.0, 0.0, (_scrollViewSetAndRestScreen.frame.size.width), (_viewExerciseAndTotalTimeBackgroundView.frame.origin.y + _viewExerciseAndTotalTimeBackgroundView.frame.size.height))];
        
        [_btnSwipeButton setFrame: CGRectMake((_contentViewSetAndRestScreen.frame.size.width - 52.0) / 2.0, (_viewExerciseAndTotalTimeBackgroundView.frame.origin.y + _viewExerciseAndTotalTimeBackgroundView.frame.size.height + 20.0), 52.0, 20.0)];
        [self.btnMenu setFrame:CGRectMake((_contentViewSetAndRestScreen.frame.size.width - 52.0) / 2.0, (_btnSwipeButton.frame.origin.y + _btnSwipeButton.frame.size.height + 1.0), 52.0, 17.0)];
        
        //Bottom buttons view
        [_viewBottomButtonsBackgroundView setFrame: CGRectMake(0.0, (_btnSwipeButton.frame.origin.y + _btnSwipeButton.frame.size.height + 58.0),(_contentViewSetAndRestScreen.frame.size.width), 270.0)];
        
        [_viewUpperButtonsBackgroundView setFrame: CGRectMake(0.0, 0.0, (_viewBottomButtonsBackgroundView.frame.size.width), ((_viewBottomButtonsBackgroundView.frame.size.height - 32.0) / 2.0))];
        [_viewNextExerciseButtonContentView setFrame: CGRectMake(0.0, 0.0, (_viewUpperButtonsBackgroundView.frame.size.width / 2.0), _viewUpperButtonsBackgroundView.frame.size.height)];
        [_imgNextExerciseImage setFrame: CGRectMake(67.0, 0.0, 80.0, 80.0)];
        [_lblNextExerciseLabel setFrame: CGRectMake(57.0, (_imgNextExerciseImage.frame.origin.y + _imgNextExerciseImage.frame.size.height + 13.0), (_viewNextExerciseButtonContentView.frame.size.width - 57.0), 20.0)];
        UIFont *fontButtonsTitle = [UIFont fontWithName: fFUTURA_MEDIUM size: 16.0];
        [_lblNextExerciseLabel setFont: fontButtonsTitle];
        
        [_viewChangeRestButtonContentView setFrame: CGRectMake(_viewNextExerciseButtonContentView.frame.size.width, 0.0, (_viewUpperButtonsBackgroundView.frame.size.width / 2.0), _viewUpperButtonsBackgroundView.frame.size.height)];
        [_viewChangeRestView setFrame: CGRectMake((_viewChangeRestButtonContentView.frame.size.width - 80.0 - 66.0), 0.0, 80.0, 80.0)];
        [_lblChangeRestCountLabel setFrame: CGRectMake(0.0, (_viewChangeRestView.frame.size.height - 30.0) / 2.0, (_viewChangeRestView.frame.size.width), 30.0)];
        UIFont *fontChangeRestCount = [UIFont fontWithName: fFUTURA_MEDIUM size: 20.0];
        [_lblChangeRestCountLabel setFont: fontChangeRestCount];
        [_lblChangeRestLabel setFrame: CGRectMake(38.0, (_viewChangeRestView.frame.origin.y + _viewChangeRestView.frame.size.height + 13.0), (_viewChangeRestButtonContentView.frame.size.width - 38.0), 20.0)];
        [_lblChangeRestLabel setFont: fontButtonsTitle];
        
        [_viewLowerButtonsBackgroundView setFrame: CGRectMake(0.0, (_viewUpperButtonsBackgroundView.frame.size.height + 40.0), (_viewBottomButtonsBackgroundView.frame.size.width), ((_viewBottomButtonsBackgroundView.frame.size.height - 32.0) / 2.0))];
        [_viewSoundButtonContentView setFrame: CGRectMake(0.0, 0.0, (_viewLowerButtonsBackgroundView.frame.size.width / 2.0), _viewLowerButtonsBackgroundView.frame.size.height)];
        [_imgSoundImage setFrame: CGRectMake(67.0, 0.0, 80.0, 80.0)];
        [_lblSoundLabel setFrame: CGRectMake(70.0, (_imgSoundImage.frame.origin.y + _imgSoundImage.frame.size.height + 13.0), (_viewSoundButtonContentView.frame.size.width - 70.0), 20.0)];
        [_lblSoundLabel setFont: fontButtonsTitle];
        
        [_viewEndWorkoutButtonContentView setFrame: CGRectMake(_viewSoundButtonContentView.frame.size.width, 0.0, (_viewLowerButtonsBackgroundView.frame.size.width / 2.0), _viewLowerButtonsBackgroundView.frame.size.height)];
        [_imgEndWorkoutImage setFrame: CGRectMake((_viewEndWorkoutButtonContentView.frame.size.width - 80.0 - 66.0), 0.0, 80.0, 80.0)];
        [_lblEndWorkoutLabel setFrame: CGRectMake(36.0, (_imgEndWorkoutImage.frame.origin.y + _imgEndWorkoutImage.frame.size.height + 13.0), (_viewEndWorkoutButtonContentView.frame.size.width - 36.0), 20.0)];
        [_lblEndWorkoutLabel setFont: fontButtonsTitle];
        
        
        /*--------------------------------------------------------------------------------*/
        
        //Scroll and content view
        [_scrollViewWorkoutCompleteScreen setFrame: CGRectMake(DEVICE_WIDTH, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        [_scrollViewWorkoutCompleteScreen setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT)];
        [_contentViewWorkoutCompleteScreen setFrame: CGRectMake(0.0, 0.0, (_scrollViewWorkoutCompleteScreen.contentSize.width), (_scrollViewWorkoutCompleteScreen.contentSize.height))];
        
        //Gym Timer label
        [_lblGymTimerWorkoutScreenTitleLabel setFrame: CGRectMake(0.0, 36.0, (_contentViewSetAndRestScreen.frame.size.width), 40.0)];
        UIFont *fontGymTimerWorkoutScreenLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblGymTimerWorkoutScreenTitleLabel setFont: fontGymTimerWorkoutScreenLabel];
        // [_lblGymTimerWorkoutScreenTitleLabel setHidden: YES];
        
        //Workout Stats background view
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
        UIFont *font = [UIFont fontWithName:fFUTURA_MEDIUM_ITALIC size:13.0];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, [UIColor colorWithRed:0.0/255.0 green:220.0/255.0 blue:93.0/255.0 alpha:1], NSForegroundColorAttributeName, nil];
        [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@"Congratulations" attributes:attrsDictionary]];
        NSDictionary *attrsDict1 = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
        [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@" for working out today !" attributes:attrsDict1]];
        _lblCongratulationsText.attributedText = attrString;
        [_lblCongratulationsText updateConstraints];
        
        [_viewPowerPopupInfomation setFrame: CGRectMake(40.0, 0.0, (_lblCongratulationsText.frame.size.width + 24.0), (_lblCongratulationsText.frame.size.height + 14.0))];
        _viewPowerPopupInfomation.layer.cornerRadius = _viewPowerPopupInfomation.frame.size.height / 2;
        [_lblCongratulationsText setFrame: CGRectMake(12.0, 7.0, _lblCongratulationsText.frame.size.width, _lblCongratulationsText.frame.size.height)];
        [_imgPowerPopupInfomationBg setFrame: CGRectMake(-16.0, -11.0, _viewPowerPopupInfomation.frame.size.width + 32.0, _viewPowerPopupInfomation.frame.size.height + 26.0)];
        // End

        // Vsn - 10/04/2020
//        [_viewWorkoutStatsBackgroundView setFrame: CGRectMake(18.0, 175, (_contentViewWorkoutCompleteScreen.frame.size.width - 36.0), 414.0)];
        [_viewWorkoutStatsBackgroundView setFrame: CGRectMake(18.0, 155, (_contentViewWorkoutCompleteScreen.frame.size.width - 36.0), 414.0)];
        [_viewPowerPopup setFrame: CGRectMake(23.0, _viewWorkoutStatsBackgroundView.frame.origin.y + 15 - 70, (_contentViewWorkoutCompleteScreen.frame.size.width - 49.0), 70.0)];
        // End
        [[_viewWorkoutStatsBackgroundView layer] setCornerRadius: 30.0];
        
        //Stats content view
        CGFloat statsContentViewY = (_viewWorkoutStatsBackgroundView.frame.size.height - _viewWorkoutStatsBackgroundView.frame.size.width + 9.0);
        CGFloat statsContentWidth = _viewWorkoutStatsBackgroundView.frame.size.width;
        [_viewWorkoutStatsContentView setFrame: CGRectMake(0.0, statsContentViewY, setAndRestBgWidth, statsContentWidth - 9.0)];
        // Vsn - 09/04/2020
//        [_viewWorkoutStatsContentView setFrame: CGRectMake(0.0, 130, setAndRestBgWidth, 284)];
        [_viewWorkoutStatsContentView setFrame: CGRectMake(0.0, 0.0, setAndRestBgWidth, 284)];
        [_vwRandomWorkoutCompleteBackground setFrame: CGRectMake(0.0, _viewWorkoutStatsContentView.frame.size.height + 20.0, setAndRestBgWidth, 234)];
        [[_vwRandomWorkoutCompleteBackground layer] setCornerRadius: 30.0];
        // End
        [[_viewWorkoutStatsContentView layer] setCornerRadius: 30.0];
        
        //Do set number view and Rest time view
        CGFloat workoutCompleteViewHeight = 130;
        [_viewWorkoutCompleteContentVIew setFrame: CGRectMake(0.0, 0.0, statsContentWidth, workoutCompleteViewHeight)];
        [_lblWorkoutCompleteLabel setFrame: CGRectMake(31.0, (workoutCompleteViewHeight - 120.0), (statsContentWidth - 100.0), 120.0)];
        UIFont *fontWorkoutCompleteLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 45.0];
        [_lblWorkoutCompleteLabel setFont: fontWorkoutCompleteLabel];
        
        [_lblCurrentDateLabel setFrame: CGRectMake(0.0, 0.0, (_viewWorkoutStatsContentView.frame.size.width), 70.0)];
        UIFont *currentDateLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 21.0];
        [_lblCurrentDateLabel setFont: currentDateLabel];
        // Vsn - 10/04/2020
        [_lblRandomWorkoutCompleteTitle setFrame: _lblCurrentDateLabel.frame];
        [_lblRandomWorkoutCompleteTitle setFont:currentDateLabel];
        // End
        
        // New Design
        [self.vwDateTime setFrame:CGRectMake(0, 0, setAndRestBgWidth, 70)];
        [self.vwCompetedBottom setFrame:CGRectMake(0, 70, setAndRestBgWidth, 214)];
        // Vsn - 10/04/2020
        [_vwRandomWorkoutCompleteTitle setFrame:CGRectMake(0, 0, setAndRestBgWidth, 70)];
        [_vwRandomWorkoutCompleteSubTitle setFrame:CGRectMake(0, 70, setAndRestBgWidth, _vwRandomWorkoutCompleteBackground.frame.size.height - 70)];
        [_lblRandomWorkoutCompleteSubTitle setFrame:CGRectMake(20.0, 20.0, setAndRestBgWidth - 40, _vwRandomWorkoutCompleteSubTitle.frame.size.height - 40)];
        
        if ([[Utils getIsPaidUser] isEqualToString: @"YES"]) {
            [_vwRandomWorkoutCompletePro setHidden: true];
            [self callGetExerciseHistoryAPI];
        } else {
            [_lblRandomWorkoutCompleteSubTitle setAttributedText: [self getWorkoutCompleteLastPopupText]];

            [_vwRandomWorkoutCompletePro setHidden: false];
            
            [_vwRandomWorkoutCompletePro setFrame: CGRectMake(_vwRandomWorkoutCompleteSubTitle.frame.origin.x + 25.0, _vwRandomWorkoutCompleteSubTitle.frame.origin.y - 15.0, _vwRandomWorkoutCompleteSubTitle.frame.size.width - 50.0, 30.0)];
            [[_vwRandomWorkoutCompletePro layer] setCornerRadius: 10.0];
            [[_vwRandomWorkoutCompletePro layer] setMasksToBounds: NO];
            [[_vwRandomWorkoutCompletePro layer] setShadowColor: [[UIColor blackColor] CGColor]];
            [[_vwRandomWorkoutCompletePro layer] setShadowOffset: CGSizeMake(1.0, 1.0)];
            [[_vwRandomWorkoutCompletePro layer] setShadowRadius: 10.0];
            [[_vwRandomWorkoutCompletePro layer] setShadowOpacity: 0.5];
            UIBezierPath *workoutViewShadowPathPro = [UIBezierPath bezierPathWithRect: [_vwRandomWorkoutCompletePro bounds]];
            [[_vwRandomWorkoutCompletePro layer] setShadowPath: [workoutViewShadowPathPro CGPath]];
            
            [_lblRandomWorkoutCompleteProText setFrame: CGRectMake(0.0, (_vwRandomWorkoutCompletePro.frame.size.height / 2) - 12.5, _vwRandomWorkoutCompletePro.frame.size.width, 25.0)];
            
            NSTextAttachment *attachment1 = [[NSTextAttachment alloc] init];
            attachment1.image = [UIImage imageNamed:@"lockgreen"];
            NSMutableAttributedString *attrString = [NSAttributedString attributedStringWithAttachment:attachment1].mutableCopy;
            UIFont *font = [UIFont fontWithName:fFUTURA_MEDIUM size:12.0];
            
            NSDictionary *attrsGreen = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, [UIColor colorWithRed:0.0/255.0 green:220.0/255.0 blue:93.0/255.0 alpha:1], NSForegroundColorAttributeName, nil];
            NSDictionary *attrsBackground = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:fFUTURA_BOLD size:14.0], NSFontAttributeName, [UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:56.0/255.0 alpha:1], NSForegroundColorAttributeName, [UIColor greenColor], NSBackgroundColorAttributeName, nil];

            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@"  These are exclusive for the " attributes:attrsGreen]];
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@"PRO" attributes:attrsBackground]];
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@" community" attributes:attrsGreen]];
            
            [_lblRandomWorkoutCompleteProText setAttributedText: attrString];
        }
        // End
        [self.vwQuality setFrame:CGRectMake(0, 0, setAndRestBgWidth / 2, 214)];
        [self.vwTime setFrame:CGRectMake(setAndRestBgWidth / 2, 0, setAndRestBgWidth / 2, 214)];
        
        [self.lblTotalTimeTitle setFrame:CGRectMake(16, 30, self.vwTime.frame.size.width - 16, 20)];
        
        [self.lblTotalExercisetitle setFrame:CGRectMake(16, 107, self.vwTime.frame.size.width - 16, 20)];
        [self.lblTotalExercise setFrame:CGRectMake(16, 134, self.vwTime.frame.size.width - 16, 41)];
        
        [self.lblQuality setFrame:CGRectMake(48, 30, 50, 20)];
        [self.vwQualityProgress setFrame:CGRectMake(38, 65, 118, 118)];
        
        self.vwQualityProgress.valueFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
        self.vwQualityProgress.valueFontSize = 32;
        self.vwQualityProgress.fontColor = cNEW_GREEN;
        self.vwQualityProgress.unitFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
        self.vwQualityProgress.unitFontSize = 18;
        
        //        [_lblTotalWorkoutTimeLabel setFrame: CGRectMake(37.0, (_lblCurrentDateLabel.frame.origin.y + _lblCurrentDateLabel.frame.size.height + 24.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
        //        [[_lblTotalWorkoutTimeLabel layer] setCornerRadius: 15.0];
        //
        //        [_lblTotalWorkoutExercisesLabel setFrame: CGRectMake(37.0, (_lblTotalWorkoutTimeLabel.frame.origin.y + _lblTotalWorkoutTimeLabel.frame.size.height + 18.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
        //        [[_lblTotalWorkoutExercisesLabel layer] setCornerRadius: 15.0];
        
        //Total workout time views
        [_lblTotalWorkoutTimeLabel setHidden: YES];
        [_lblTotalWorkoutExercisesLabel setHidden: YES];
        
        [_viewHoursTimeFormatContentView setFrame: CGRectMake(37.0, (_lblCurrentDateLabel.frame.origin.y + _lblCurrentDateLabel.frame.size.height + 24.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
        [[_viewHoursTimeFormatContentView layer] setCornerRadius: 15.0];
        
        CGFloat timeCountLabelWidth = ([_viewHoursTimeFormatContentView frame].size.width / 6.0);
        CGFloat timeTitlelabelWidth = ([_viewHoursTimeFormatContentView frame].size.width / 6.0);
        
        //Hours min sec format
        [_lblFirstHoursCountLabel setFrame: CGRectMake(19.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
        [_lblFirstHoursTitleLabel setFrame: CGRectMake((_lblFirstHoursCountLabel.frame.origin.x + _lblFirstHoursCountLabel.frame.size.width) - 0.0, 8.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
        [_lblFirstMinCountLabel setFrame: CGRectMake((_lblFirstHoursTitleLabel.frame.origin.x + _lblFirstHoursTitleLabel.frame.size.width) - 26.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
        [_lblFirstMinTitleLabel setFrame: CGRectMake((_lblFirstMinCountLabel.frame.origin.x + _lblFirstMinCountLabel.frame.size.width) - 0.5, 8.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
        [_lblFirstSecCountLabel setFrame: CGRectMake((_lblFirstMinTitleLabel.frame.origin.x + _lblFirstMinTitleLabel.frame.size.width) - 6.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
        [_lblFirstSecTitleLabel setFrame: CGRectMake((_lblFirstSecCountLabel.frame.origin.x + _lblFirstSecCountLabel.frame.size.width) - 0.0, 8.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
        
        //Min sec format
        [_viewMinTimeFormatContentView setFrame: CGRectMake(37.0, (_lblCurrentDateLabel.frame.origin.y + _lblCurrentDateLabel.frame.size.height + 24.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
        [[_viewMinTimeFormatContentView layer] setCornerRadius: 15.0];
        [_lblSecondMinCountLabel setFrame: CGRectMake(44.0, 0.0, (timeCountLabelWidth + 8.0), (_viewMinTimeFormatContentView.frame.size.height))];
        [_lblSecondMinTitleLabel setFrame: CGRectMake((_lblSecondMinCountLabel.frame.origin.x + _lblSecondMinCountLabel.frame.size.width) - 0.0, 12.0, timeTitlelabelWidth, (_viewMinTimeFormatContentView.frame.size.height - 12.0))];
        [_lblSecondSecCountLabel setFrame: CGRectMake((_lblSecondMinTitleLabel.frame.origin.x + _lblSecondMinTitleLabel.frame.size.width) - 4.0, 0.0, (timeCountLabelWidth + 8.0), (_viewMinTimeFormatContentView.frame.size.height))];
        [_lblSecondSecTitleLabel setFrame: CGRectMake((_lblSecondSecCountLabel.frame.origin.x + _lblSecondSecCountLabel.frame.size.width) - 0.0, 12.0, timeTitlelabelWidth, (_viewMinTimeFormatContentView.frame.size.height - 12.0))];
        
        //Total exercise view
        [_viewTotalExerciseContentView setFrame: CGRectMake(37.0, (_viewHoursTimeFormatContentView.frame.origin.y + _viewHoursTimeFormatContentView.frame.size.height + 18.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
        [[_viewTotalExerciseContentView layer] setCornerRadius: 15.0];
        [_lblTotalExerciseCountLabel setFrame: CGRectMake(45.0, 0.0, (timeCountLabelWidth + 8.0), (_viewTotalExerciseContentView.frame.size.height - 1.0))];
        [_lblExerciseTitleLabel setFrame: CGRectMake((_lblTotalExerciseCountLabel.frame.origin.x + _lblTotalExerciseCountLabel.frame.size.width), 11.0, (_viewTotalExerciseContentView.frame.size.width - (_lblTotalExerciseCountLabel.frame.origin.x + _lblTotalExerciseCountLabel.frame.size.width)), (_viewTotalExerciseContentView.frame.size.height - 11.0))];
        
        lblCounting = [[UICountingLabel alloc] initWithFrame: CGRectMake(60.0, (_viewTotalExerciseContentView.frame.origin.y + _viewTotalExerciseContentView.frame.size.height + 12.0), 100.0, 40.0)];
        [_viewWorkoutStatsContentView addSubview: lblCounting];
        
        [self.lblShortWorkoutMsg setFrame:CGRectMake(20, self.viewWorkoutStatsBackgroundView.frame.origin.y + self.viewWorkoutStatsBackgroundView.frame.size.height + 8, self.viewWorkoutStatsBackgroundView.frame.size.width, 32)];
        // Vsn - 10/04/2020
//        [_btnShareStatsButton setFrame:CGRectMake(85, self.viewWorkoutStatsBackgroundView.frame.origin.y + self.viewWorkoutStatsBackgroundView.frame.size.height + 58, 80, 80)];
//        [_btnDoneWorkoutButton setFrame:CGRectMake(self.btnShareStatsButton.frame.origin.x + self.btnShareStatsButton.frame.size.width + 45, self.viewWorkoutStatsBackgroundView.frame.origin.y + self.viewWorkoutStatsBackgroundView.frame.size.height + 58, 80, 80)];
        [self.btnDoneWorkoutButton setFrame:CGRectMake(self.view.frame.size.width / 2 + 40, self.viewWorkoutStatsBackgroundView.frame.origin.y + self.vwRandomWorkoutCompleteBackground.frame.origin.y + self.vwRandomWorkoutCompleteBackground.frame.size.height + 20, 80, 80)];
        [self.btnShareStatsButton setFrame:CGRectMake(self.view.frame.size.width / 2 - 120, self.viewWorkoutStatsBackgroundView.frame.origin.y + self.vwRandomWorkoutCompleteBackground.frame.origin.y + self.vwRandomWorkoutCompleteBackground.frame.size.height + 20, 80, 80)];
        // End
        
    } else if (IS_IPHONE8PLUS) {
        {
            
            //Loader view
            [_viewLoaderBackgroundView setFrame: CGRectMake(0.0, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
            [_lblLoaderGymTimerLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
            UIFont *fontGymTimerLoaderLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
            [_lblLoaderGymTimerLabel setFont: fontGymTimerLoaderLabel];
            [_viewLoaderContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
            
            //Scroll and Content view
            [_scrollViewWorkoutScreen setFrame: CGRectMake(0.0, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
            [_contentViewWorkoutScreen setFrame: CGRectMake(0.0, 0.0, (_scrollViewWorkoutScreen.frame.size.width), (_scrollViewWorkoutScreen.frame.size.height))];
            CGFloat contentViewWidth = _contentViewWorkoutScreen.frame.size.width;
            CGFloat contentViewHeight = _contentViewWorkoutScreen.frame.size.height;
            
            //GymTimer label
            [_lblGymTimerTitleLabel setFrame: CGRectMake(0.0, -24.0, (_contentViewWorkoutScreen.frame.size.width), 115.0)];
            UIFont *fontGymTimer = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 64.7];
            [_lblGymTimerTitleLabel setFont: fontGymTimer];

            // Vsn - 11/02/2020
            [_lblBoostYourWorkoutsSetScreenLabel setFrame: CGRectMake((_contentViewWorkoutScreen.frame.size.width / 2.0) - 173.0, 28.0, (_contentViewWorkoutScreen.frame.size.width), 80.0)];
//            [_lblBoostYourWorkoutsSetScreenLabel setFrame: CGRectMake((_contentViewWorkoutScreen.frame.size.width / 2.0) - 140.1, 40.0, (_contentViewWorkoutScreen.frame.size.width), 80.0)];
//            [lblBoostYourWorkoutText addAttribute:NSKernAttributeName value:@3.45 range:NSMakeRange(0, lblBoostYourWorkoutText.length)];
//            [_lblBoostYourWorkoutsSetScreenLabel setAttributedText: lblBoostYourWorkoutText];
            UIFont *fontGymTimer1 = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 22.0];
            [_lblBoostYourWorkoutsSetScreenLabel setFont: fontGymTimer1];
            
            
            //Start Workout content view
            CGFloat gymtimerY = _lblGymTimerTitleLabel.frame.origin.y;
            CGFloat gymtimerHeight = _lblGymTimerTitleLabel.frame.size.height;
//            CGFloat tabbarHeight = 53.0;
            CGFloat tabbarHeight = [[[self tabBarController] tabBar] frame].size.height;
            [_viewWorkoutContentView setFrame: CGRectMake(35.0, (_lblGymTimerTitleLabel.frame.origin.y + _lblGymTimerTitleLabel.frame.size.height + 24.0), (contentViewWidth - 70.0), (contentViewHeight - (gymtimerY + gymtimerHeight + tabbarHeight + 50.0)))];
            // Vsn - 19/02/2020
            [_viewWorkoutContentViewSubView setFrame: CGRectMake(0.0, 0.0, _viewWorkoutContentView.frame.size.width, _viewWorkoutContentView.frame.size.height)];
            // Vsn - 25/02/2020
            [_vwImgWelcomeBack setFrame: CGRectMake(0.0, 0.0, _viewWorkoutContentView.frame.size.width, _viewWorkoutContentView.frame.size.height)];
            [_vwWorkoutContentParent setFrame:CGRectMake(0.0, 0.0, _viewWorkoutContentView.frame.size.width, _viewWorkoutContentView.frame.size.height)];
            [_imgHomeBottomGym setFrame: CGRectMake(-21.0, -19.0, _viewWorkoutContentView.frame.size.width + 42.0, _viewWorkoutContentView.frame.size.height + 45.0)];
            
            //Choose default rest time label
            CGFloat workoutContentViewWidth = _viewWorkoutContentView.frame.size.width;
            UIFont *fontMinSec = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
            [_lblChooseDefaultTimeLabel setFrame: CGRectMake(0.0, 52.0, (workoutContentViewWidth), 42.0)];
            [_lblChooseDefaultTimeLabel setFont: fontMinSec];
            [_lblChooseDefaultTimeLabel setAlpha: 0.5];
            
            // Vsn - 10/02/2020
            //Rest time picker view
            [_pickerWorkoutRestTimePickerView setFrame: CGRectMake(32.0, (_lblChooseDefaultTimeLabel.frame.origin.y + _lblChooseDefaultTimeLabel.frame.size.height + 20.0), (workoutContentViewWidth - 64.0), 220.0)];
//            [_pickerWorkoutRestTimePickerView setFrame: CGRectMake(32.0, (_lblChooseDefaultTimeLabel.frame.origin.y + _lblChooseDefaultTimeLabel.frame.size.height + 0.0), (workoutContentViewWidth - 64.0), 280.0)];
            
            //Minute and seconds view
            [_viewMinutesSecondsContentView setFrame: CGRectMake(-12.0, (_lblChooseDefaultTimeLabel.frame.origin.y + _lblChooseDefaultTimeLabel.frame.size.height + 130.0 - 6.0), workoutContentViewWidth, 22.0)];
            [_lblMinuteLabel setFrame: CGRectMake(153.0, 0.0, 30.0, 21.0)];
            [_lblSecondsLabel setFrame: CGRectMake(256.0, 0.0, 15.0, 21.0)];
            [_lblMinuteLabel setFont: fontMinSec];
            [_lblSecondsLabel setFont: fontMinSec];
            
            {//Dinal3-done
                
                UIFont *newBtnFont = [UIFont fontWithName: fFUTURA_BOLD size: 13.0];
                [_btnEndurance.titleLabel setFont:newBtnFont];
                [_btnMuscle.titleLabel setFont:newBtnFont];
                [_btnpower.titleLabel setFont:newBtnFont];
                //            [_lblRecommend setFont:newBtnFont];
                
                UIFont *newGreenFont = [UIFont fontWithName: fFUTURA_MEDIUM size: 13.0];
                [_lblRange1 setFont:newGreenFont];
                [_lblRange2 setFont:newGreenFont];
                [_lblRange11 setFont:newGreenFont];
                [_lblRange22 setFont:newGreenFont];
                
                UIFont *newSetRepsFont = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
                [_lblSets setFont:newSetRepsFont];
                [_lblReps setFont:newSetRepsFont];
                [_lblRecommend setFont:newSetRepsFont];
                
                UIFont *newScientificFont = [UIFont fontWithName: fFUTURA_MEDIUM size: 12.5];
                [_lblScientific setFont:newScientificFont];
                
                CGFloat widthParent = _viewTabParent.frame.size.width;
                
                CGRect frameRecommend = _lblRecommend.frame;
                frameRecommend.size.width = widthParent * 0.4210;
                frameRecommend.origin.x += 8.0;
                [_lblRecommend setFrame:frameRecommend];
                
                CGRect frameRange1 = _lblRange1.frame;
                //            frameRange1.size.width = widthParent * 0.0964;
                frameRange1.origin.x = frameRecommend.size.width - 3.0;
                [_lblRange1 setFrame:frameRange1];
                
                CGRect minus1 = _lblMinus1.frame;
                //            minus1.size.width = widthParent * 0.0964;
                minus1.origin.x = _lblRange1.frame.origin.x + _lblRange1.frame.size.width - 2.0;
                [_lblMinus1 setFrame:minus1];
                
                CGRect frameRange11 = _lblRange11.frame;
                frameRange11.size.width += 3.0;
                frameRange11.origin.x = _lblMinus1.frame.origin.x + _lblMinus1.frame.size.width - 4.0;
                [_lblRange11 setFrame:frameRange11];
                
                CGRect frameSets = _lblSets.frame;
                frameSets.size.width = widthParent * 0.1096;
                frameSets.origin.x = frameRange11.origin.x + frameRange11.size.width - 4.0;
                [_lblSets setFrame:frameSets];
                
                CGRect frameSeprator1 = _lblSeparator1.frame;
                frameSeprator1.size.width = 1.0;
                frameSeprator1.origin.x = frameSets.origin.x + frameSets.size.width - 4.0;
                [_lblSeparator1 setFrame:frameSeprator1];
                
                CGRect frameRange2 = _lblRange2.frame;
                //            frameRange2.size.width = widthParent * 0.0964;
                frameRange2.origin.x = frameSeprator1.origin.x + frameSeprator1.size.width + 4.0;
                // Vsn - 09/04/2020
                frameRange2.size.width = frameRange2.size.width + 7.0;
                // End
                [_lblRange2 setFrame:frameRange2];
                
                CGRect minus2 = _lblMinus2.frame;
                //minus2.size.width = widthParent * 0.0964;
                minus2.origin.x = _lblRange2.frame.origin.x + _lblRange2.frame.size.width - 1.0;
                [_lblMinus2 setFrame:minus2];
                
                CGRect frameRange22 = _lblRange22.frame;
                frameRange22.size.width += 3.0;
                frameRange22.origin.x = _lblMinus2.frame.origin.x + _lblMinus2.frame.size.width - 4.0;
                [_lblRange22 setFrame:frameRange22];
                
                CGRect frameReps = _lblReps.frame;
                frameReps.size.width = widthParent * 0.1228;
                frameReps.origin.x = frameRange22.origin.x + frameRange22.size.width + 2.0;
                [_lblReps setFrame:frameReps];
                
                CGRect frameSeprator2 = _lblSeparator2.frame;
                frameSeprator2.size.width = 1.0;
                frameSeprator2.origin.x = frameReps.origin.x + frameReps.size.width - 3.0;
                [_lblSeparator2 setFrame:frameSeprator2];
                
                CGRect frameDumbell = _imgDumbell.frame;
                frameDumbell.size.width = widthParent * 0.1140;
                frameDumbell.size.height = widthParent * 0.1140;
                frameDumbell.origin.x = frameSeprator2.origin.x + frameSeprator2.size.width + 6.0;
                frameDumbell.origin.y -= 4.0;
                [_imgDumbell setFrame:frameDumbell];
                
                CGRect frameSci = _lblScientific.frame;
                frameSci.origin.x += 5.5;
                [_lblScientific setFrame:frameSci];
                
                CGRect frameArrow = _btnArrowScientifically.frame;
                frameArrow.origin.x = frameSci.origin.x + _lblScientific.frame.size.width + 5.0;
                [_btnArrowScientifically setFrame:frameArrow];
            }
            
            // Vsn - 10/02/2020
            //Start workout button
            [_btnStartWorkoutButton setFrame: CGRectMake(50.0, (_pickerWorkoutRestTimePickerView.frame.size.height + _pickerWorkoutRestTimePickerView.frame.origin.y) + 15.0 + 5, (workoutContentViewWidth - 80.0)-20, 65.0-10)];
//            [_btnStartWorkoutButton setFrame: CGRectMake(40.0, (_viewWorkoutContentView.frame.size.height - 140.0), (workoutContentViewWidth - 80.0), 60.0)];
            [_btnStartWorkoutButton setBackgroundColor: UIColorFromRGB(0x14CC64)];
            UIFont *fontStartButton = [UIFont fontWithName: fFUTURA_BOLD size: 25.0];
            dicStartButtonAttributes = [[NSDictionary alloc] init];
            dicStartButtonAttributes = @{ NSForegroundColorAttributeName : UIColorFromRGB(0x009938),
                                          NSFontAttributeName : fontStartButton
                                          };
            NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"Start Workout" attributes: dicStartButtonAttributes];
            [_btnStartWorkoutButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
            [[_btnStartWorkoutButton layer] setCornerRadius: _btnStartWorkoutButton.frame.size.height / 3.5]; //17.0
            
            
            /*--------------------------------------------------------------------------------*/
            
            //Scroll and content view
            [_scrollViewSetAndRestScreen setFrame: CGRectMake(DEVICE_WIDTH, -44.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
            //        [_scrollViewSetAndRestScreen setFrame: CGRectMake(DEVICE_WIDTH, 44.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
            [_scrollViewSetAndRestScreen setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + 364.0)];
            [_contentViewSetAndRestScreen setFrame: CGRectMake(0.0, 0.0, (_scrollViewSetAndRestScreen.frame.size.width), (_scrollViewSetAndRestScreen.contentSize.height + 104.0))];
            
            //Gym Timer label
            [_lblGymTimerSetScreenLabel setFrame: CGRectMake(0.0, 36.0, (_contentViewSetAndRestScreen.frame.size.width), 40.0)];
            UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
            [_lblGymTimerSetScreenLabel setFont: fontGymTimerLabel];
            
            //Set and rest background view
            CGFloat setAndRestBgViewY = (_lblGymTimerSetScreenLabel.frame.origin.y + _lblGymTimerSetScreenLabel.frame.size.height + 16.0);
            // Vsn - 12/03/2020
//            [_viewSetAndRestBackgroundView setFrame: CGRectMake(18.0, setAndRestBgViewY, (_contentViewSetAndRestScreen.frame.size.width - 36.0), 502.0)];
            [_viewSetAndRestBackgroundView setFrame: CGRectMake(24.0, setAndRestBgViewY, (_contentViewSetAndRestScreen.frame.size.width - 48.0), 478.0)];
            [[_viewSetAndRestBackgroundView layer] setCornerRadius: 30.0];
            
            //Progress bar background view
            CGFloat setAndRestProgressBarBgViewY = (_viewSetAndRestBackgroundView.frame.size.height - _viewSetAndRestBackgroundView.frame.size.width + 9.0);
            CGFloat setAndRestBgWidth = _viewSetAndRestBackgroundView.frame.size.width;
            // Vsn - 12/03/2020
//            [_viewSetAndRestScreenProgressBackgroundView setFrame: CGRectMake(0.0, setAndRestProgressBarBgViewY, setAndRestBgWidth, setAndRestBgWidth - 9.0)];
            [_viewSetAndRestScreenProgressBackgroundView setFrame: CGRectMake(0.0, setAndRestProgressBarBgViewY + 18.0, setAndRestBgWidth, setAndRestBgWidth - 27.0)];
            [[_viewSetAndRestScreenProgressBackgroundView layer] setCornerRadius: 30.0];
            
            // Warm up view
            [self.vwWarmUp setFrame: CGRectMake(0.0, setAndRestProgressBarBgViewY, setAndRestBgWidth, setAndRestBgWidth - 9.0)];
            
            //Do set number view and Rest time view
            [_viewDoSetNumberContentView setHidden: YES];
            [_viewRestTimeContentView setHidden: NO];
            CGFloat doSetNumberViewHeight = (_viewSetAndRestBackgroundView.frame.size.height - _viewSetAndRestScreenProgressBackgroundView.frame.size.height);
            [_viewDoSetNumberContentView setFrame: CGRectMake(0.0, 0.0, setAndRestBgWidth, doSetNumberViewHeight)];
            
            [_lblDoSetNumberCountLabel setFrame: CGRectMake((setAndRestBgWidth - 121.0), 6.0, 121.0, (doSetNumberViewHeight - 6.0))];
            UIFont *fontDoSetCount = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 142.0];
            [_lblDoSetNumberCountLabel setFont: fontDoSetCount];
            [self adjustFontOfDoSetCountLabel];
            
            [_lblDoSetNumberLabel setFrame: CGRectMake(-10.0, (doSetNumberViewHeight - 123.0), (setAndRestBgWidth - _lblDoSetNumberCountLabel.frame.size.width - 10.5), 123.0)];
            UIFont *fontDoSetLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0];
            [_lblDoSetNumberLabel setFont: fontDoSetLabel];
            
            [_viewRestTimeContentView setFrame: CGRectMake(0.0, 0.0, setAndRestBgWidth, doSetNumberViewHeight)];
            CGFloat restTimerColonWidth = 40.0;
            CGFloat restTimerMinSecWidth = (setAndRestBgWidth - restTimerColonWidth) / 2.0;
            [_lblRestTimerMinutesLabel setFrame: CGRectMake(0.0, 0.0, restTimerMinSecWidth, doSetNumberViewHeight)];
            [_lblRestTimerColonLabel setFrame: CGRectMake((_lblRestTimerMinutesLabel.frame.size.width), 0.0, restTimerColonWidth, doSetNumberViewHeight)];
            [_lblRestTimerSecondsLabel setFrame: CGRectMake((_lblRestTimerColonLabel.frame.origin.x + _lblRestTimerColonLabel.frame.size.width), 0.0, restTimerMinSecWidth, doSetNumberViewHeight)];
            
            [self.vwLastExercise setFrame:CGRectMake(0.0, 0.0, setAndRestBgWidth, doSetNumberViewHeight)];
            [self.lblTimeSinceTitle setFrame:CGRectMake(20.0, 15.0, self.vwLastExercise.frame.size.width - 40.0, 29.0)];
            [self.lblTimeSince setFrame:CGRectMake(20.0, (self.lblTimeSinceTitle.frame.origin.y + self.lblTimeSinceTitle.frame.size.height) - 16 , self.vwLastExercise.frame.size.width - 40.0, 116.0)];
            UIFont *fontTimeSinceLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 80.0];
            [self.lblTimeSince setFont: fontTimeSinceLabel];

            //[_lblRestTimeLabel setFrame: CGRectMake(0.0, 15.0, setAndRestBgWidth, (doSetNumberViewHeight - 15.0))];
            UIFont *fontRestTimeLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 110.0];
            [_lblRestTimerMinutesLabel setFont: fontRestTimeLabel];
            [_lblRestTimerColonLabel setFont: fontRestTimeLabel];
            [_lblRestTimerSecondsLabel setFont: fontRestTimeLabel];
            
            //View last exercise
            CGFloat viewProgressBarHeight = _viewSetAndRestScreenProgressBackgroundView.frame.size.height;
            CGFloat viewProgressBarWidth = _viewSetAndRestScreenProgressBackgroundView.frame.size.width;
            
            [_viewLastExerciseTimeContentView setFrame: CGRectMake(22.0, 12.0, viewProgressBarWidth, 80.0)];
            [_lblSinceLastExerciseLabel setFrame: CGRectMake(0.0, 0.0, (_viewLastExerciseTimeContentView.frame.size.width), 30.0)];
            UIFont *fontSinceLastExerciseLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
            [_lblSinceLastExerciseLabel setFont: fontSinceLastExerciseLabel];
            
            CGFloat lastExerciseColonWidth = 12.0;
            CGFloat hoursFormatCountWidth = 40.0;
            
            //Hours format
            [_viewLastExerciseHoursFormat setFrame: CGRectMake(-16.0, 14.0, (_viewLastExerciseTimeContentView.frame.size.width), (_viewLastExerciseTimeContentView.frame.size.height - (_lblSinceLastExerciseLabel.frame.origin.y + _lblSinceLastExerciseLabel.frame.size.height)))];
            
            UIFont *fontLastExerciseHourFormat = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 20.0];
            [_lblLastExerciseFirstHourLabel setFrame: CGRectMake(0.0, 0.0, hoursFormatCountWidth, (_viewLastExerciseHoursFormat.frame.size.height))];
            [_lblLastExerciseHourFirstColonLabel setFrame: CGRectMake((_lblLastExerciseFirstHourLabel.frame.origin.x + _lblLastExerciseFirstHourLabel.frame.size.width), 0.0, (lastExerciseColonWidth - 4.0), (_viewLastExerciseHoursFormat.frame.size.height))];
            [_lblLastExerciseFirstMinLabel setFrame: CGRectMake((_lblLastExerciseHourFirstColonLabel.frame.origin.x + _lblLastExerciseHourFirstColonLabel.frame.size.width) - 5.0, 0.0, hoursFormatCountWidth, (_viewLastExerciseHoursFormat.frame.size.height))];
            [_lblLastExerciseHourSecondColonLabel setFrame: CGRectMake((_lblLastExerciseFirstMinLabel.frame.origin.x + _lblLastExerciseFirstMinLabel.frame.size.width) - 5.0, 0.0, (lastExerciseColonWidth - 4.0), (_viewLastExerciseHoursFormat.frame.size.height))];
            [_lblLastExerciseFirstSecLabel setFrame: CGRectMake((_lblLastExerciseHourSecondColonLabel.frame.origin.x + _lblLastExerciseHourSecondColonLabel.frame.size.width), 0.0, hoursFormatCountWidth, (_viewLastExerciseHoursFormat.frame.size.height))];
            [_lblLastExerciseFirstHourLabel setFont: fontLastExerciseHourFormat];
            [_lblLastExerciseHourFirstColonLabel setFont: fontLastExerciseHourFormat];
            [_lblLastExerciseFirstMinLabel setFont: fontLastExerciseHourFormat];
            [_lblLastExerciseHourSecondColonLabel setFont: fontLastExerciseHourFormat];
            [_lblLastExerciseFirstSecLabel setFont: fontLastExerciseHourFormat];
            
            //Minutes format
            CGFloat minuteFormatCountWidth = 40.0;
            // Vsn - 11/03/2020
            UIFont *fontLastExerciseMinuteFormat = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 23.0]; //24.5
            
            [_viewLastExerciseMinuteFormat setFrame: CGRectMake(-10.0, 18.0, (_viewLastExerciseTimeContentView.frame.size.width), (_viewLastExerciseTimeContentView.frame.size.height - (_lblSinceLastExerciseLabel.frame.origin.y + _lblSinceLastExerciseLabel.frame.size.height)))];
            
            [_lblLastExerciseSecondMinLabel setFrame: CGRectMake(0.0, 1.0, minuteFormatCountWidth, (_viewLastExerciseMinuteFormat.frame.size.height))];
            [_lblLastExerciseSecondColonLabel setFrame: CGRectMake((_lblLastExerciseSecondMinLabel.frame.origin.x + _lblLastExerciseSecondMinLabel.frame.size.width), 0.0, lastExerciseColonWidth, (_viewLastExerciseMinuteFormat.frame.size.height))];
            [_lblLastExerciseSecondSecLabel setFrame: CGRectMake((_lblLastExerciseSecondColonLabel.frame.origin.x + _lblLastExerciseSecondColonLabel.frame.size.width), 0.0, minuteFormatCountWidth, (_viewLastExerciseMinuteFormat.frame.size.height))];
            [_lblLastExerciseSecondMinLabel setFont: fontLastExerciseMinuteFormat];
            [_lblLastExerciseSecondColonLabel setFont: fontLastExerciseMinuteFormat];
            [_lblLastExerciseSecondSecLabel setFont: fontLastExerciseMinuteFormat];
            
            
            //Progress bar view and dumbells image
            [self setupProgressBar];
            // Vsn - 12/03/2020
//            [_progressBarSetScreenView setFrame: CGRectMake(47.5, 47.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
//            [_progressBarRestScreenView setFrame: CGRectMake(47.5, 47.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
//            [_progressBarRestBackgroungView setFrame: CGRectMake(47.5, 47.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
//            [_vwRestScreenDumbellsBackgroundImage setFrame: CGRectMake(47.5, 47.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
            
            [_progressBarSetScreenView setFrame: CGRectMake(47.5, 42.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
            [_progressBarRestScreenView setFrame: CGRectMake(47.5, 42.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
            [_progressBarRestBackgroungView setFrame: CGRectMake(47.5, 42.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
            [_vwRestScreenDumbellsBackgroundImage setFrame: CGRectMake(47.5, 42.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
            
            CGFloat progressBarHeight = _progressBarSetScreenView.frame.size.height;
            CGFloat progressBarWidth = _progressBarSetScreenView.frame.size.width;
            
            // Vsn - 05/02/2020
            CGFloat greenDumbellsImageWidth = 109.25; // *1.15
            CGFloat greenDumbellsImageHeight = 167.9; // *1.15
            CGFloat redDumbellsImageWidth = 205.0;
            CGFloat redDumbellsImageHeight = 202.0;

            [self.imgRestScreenDumbellsImage setFrame: CGRectMake(((progressBarWidth - redDumbellsImageWidth) / 2.0), ((progressBarHeight - redDumbellsImageHeight) / 2.0) + 5.0, redDumbellsImageWidth, redDumbellsImageHeight)];
            [self.imgRestScreenDumbellsBackgroundImage setFrame: self.imgRestScreenDumbellsImage.frame];
            
//            CGFloat greenDumbellsImageWidth = 78.0;
//            CGFloat greenDumbellsImageHeight = 106.0;
//            CGFloat redDumbellsImageWidth = 60.0;
//            CGFloat redDumbellsImageHeight = 128.0;
//
//            [_imgRestScreenDumbellsImage setFrame: CGRectMake(((progressBarWidth - redDumbellsImageWidth) / 2.0) + 4.0, ((progressBarHeight - redDumbellsImageHeight) / 2.0) + 10.0, redDumbellsImageWidth, redDumbellsImageHeight)];
            [_imgRestScreenDumbellsImage setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
            
            // Set Character
            [self.imgSetScreenDumbellsImage setFrame:CGRectMake(47.5, 20, greenDumbellsImageWidth, greenDumbellsImageHeight)];
            
            // Vsn - 05/02/2020
            self.imgSetScreenDumbellsImage.center = CGPointMake(self.viewSetAndRestScreenProgressBackgroundView.bounds.size.width  / 2, greenDumbellsImageHeight - 26.0);
//            self.imgSetScreenDumbellsImage.center = CGPointMake(self.viewSetAndRestScreenProgressBackgroundView.bounds.size.width  / 2, 140.0);

            // Next Exercise Progress Ring
            [self.vwNextExercise setFrame: CGRectMake(47.5, 47.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
            [self.vwNextExerciseRing setFrame:CGRectMake(0, 0, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
            [self.imgNextExercise setFrame:CGRectMake(0.0, 0.0, 90, 140)];
            self.imgNextExercise.center = CGPointMake(self.vwNextExercise.frame.size.width  / 2, self.vwNextExercise.frame.size.height / 2);
            
            //Click anywhere and Next set view
            [_viewClickAnywhereContentView setFrame: CGRectMake(0.0, (viewProgressBarHeight - 59.0), viewProgressBarWidth, 59.0)];
            [_lblClickAnywhereToRestLabel setFrame: CGRectMake(1.0, 0.0, (_viewClickAnywhereContentView.frame.size.width - 1.0), (_viewClickAnywhereContentView.frame.size.height))];
            UIFont *fontClickAnywhereLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
            [_lblClickAnywhereToRestLabel setFont: fontClickAnywhereLabel];
            
            // Vsn - 05/02/2020
            [_viewNextSetContentView setFrame: CGRectMake(0.0, 0.0, viewProgressBarWidth, 120.0)];
            [_lblNextSetCountLabel setFrame: CGRectMake((_viewNextSetContentView.frame.size.width - 82.0), 25.0, 75.0, 90.0)];
            UIFont *fontNextSetCountLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 78.0];
            [_lblNextSetCountLabel setFont: fontNextSetCountLabel];
            [[_lblNextSetCountLabel layer] setCornerRadius: 30.0];
            [_lblNextSetLabel setFrame: CGRectMake(0.0, 0.0, (_viewNextSetContentView.frame.size.width - 25.0), 40.0)];
//            [_viewNextSetContentView setFrame: CGRectMake(0.0, (viewProgressBarHeight - 60.0), viewProgressBarWidth, 60.0)];
//            [_lblNextSetCountLabel setFrame: CGRectMake((_viewNextSetContentView.frame.size.width - 60.0), 0.0, 60.0, 60.0)];
//            UIFont *fontNextSetCountLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0];
//            [_lblNextSetLabel setFrame: CGRectMake(0.0, (_viewNextSetContentView.frame.size.height - 40.0), (_viewNextSetContentView.frame.size.width - _lblNextSetCountLabel.frame.size.width - 9.0), 40.0)];
            UIFont *fontNextSetLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
            [_lblNextSetLabel setFont: fontNextSetLabel];
            
            // Vsn - 12/03/2020
            [_viewExerciseAndTotalTimeBackgroundView setFrame: CGRectMake(0.0, (_viewSetAndRestBackgroundView.frame.origin.y + _viewSetAndRestBackgroundView.frame.size.height + 15.0), (_contentViewSetAndRestScreen.frame.size.width), 90.0)];
            [_viewExerciseContentView setFrame: CGRectMake(18.0, 0.0, (_viewExerciseAndTotalTimeBackgroundView.frame.size.width - 54.0) / 2.0, 90.0)];
            [_viewTotalTimeContentView setFrame: CGRectMake((_viewExerciseContentView.frame.origin.x + _viewExerciseContentView.frame.size.width + 18.0), 0.0, (_viewExerciseAndTotalTimeBackgroundView.frame.size.width - 54.0) / 2.0, 90.0)];
//            [_viewExerciseAndTotalTimeBackgroundView setFrame: CGRectMake(0.0, (_viewSetAndRestBackgroundView.frame.origin.y + _viewSetAndRestBackgroundView.frame.size.height + 25.0), (_contentViewSetAndRestScreen.frame.size.width), 100.0)];
//            [_viewExerciseContentView setFrame: CGRectMake(18.0, 0.0, (_viewExerciseAndTotalTimeBackgroundView.frame.size.width - 54.0) / 2.0, 100.0)];
//            [_viewTotalTimeContentView setFrame: CGRectMake((_viewExerciseContentView.frame.origin.x + _viewExerciseContentView.frame.size.width + 18.0), 0.0, (_viewExerciseAndTotalTimeBackgroundView.frame.size.width - 54.0) / 2.0, 100.0)];
            
            [_lblExerciseCountLabel setFrame: CGRectMake(0.0, 15.0, (_viewExerciseContentView.frame.size.width), 50.0)];
            [_lblExerciseCountLabel setCenter: CGPointMake(_lblExerciseCountLabel.center.x, _viewTotalTimeContentView.frame.size.height / 2 - 10.0)];

            UIFont *fontExerciseCount = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0];
            [_lblExerciseCountLabel setFont: fontExerciseCount];
            [_lblExerciseLabel setFrame: CGRectMake(0.0, (_lblExerciseCountLabel.frame.origin.y + _lblExerciseCountLabel.frame.size.height - 7.0), (_viewExerciseContentView.frame.size.width), 30.0)];
            [_lblExerciseLabel setCenter: CGPointMake(_lblExerciseLabel.center.x, _viewTotalTimeContentView.frame.size.height / 2 + 22.0)];

            UIFont *fontExerciseLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.1];
            [_lblExerciseLabel setFont: fontExerciseLabel];
            [[_viewExerciseContentView layer] setCornerRadius: 30.0];
            [[_viewTotalTimeContentView layer] setCornerRadius: 30.0];
            
            [_viewHoursTimeContentView setFrame: CGRectMake(0.0, 0.0, (_viewTotalTimeContentView.frame.size.width), 65.0)];
            CGFloat colonWidth = 12.0;
            CGFloat timeHoursWidth = ((_viewHoursTimeContentView.frame.size.width - (2 * colonWidth)) / 3.0) - 4.0;
            [_lblHoursFirstLabel setFrame: CGRectMake(6.0, 15.0, timeHoursWidth, 50.0)];
            [_lblColonFirstLabel setFrame: CGRectMake((_lblHoursFirstLabel.frame.origin.x + _lblHoursFirstLabel.frame.size.width), 15.0, colonWidth, 50.0)];
            [_lblMinFirstLabel setFrame: CGRectMake((_lblColonFirstLabel.frame.origin.x + _lblColonFirstLabel.frame.size.width), 15.0, timeHoursWidth, 50.0)];
            [_lblColonSecondLabel setFrame: CGRectMake((_lblMinFirstLabel.frame.origin.x + _lblMinFirstLabel.frame.size.width), 15.0, colonWidth, 50.0)];
            [_lblSecondsFirstLabel setFrame: CGRectMake((_lblColonSecondLabel.frame.origin.x + _lblColonSecondLabel.frame.size.width), 15.0, timeHoursWidth, 50.0)];
            
            // Vsn - 12/03/2020
            [_lblHoursFirstLabel setCenter: CGPointMake(_lblHoursFirstLabel.center.x, _viewTotalTimeContentView.frame.size.height / 2 - 10.0)];
            [_lblColonFirstLabel setCenter:CGPointMake(_lblColonFirstLabel.center.x, _viewTotalTimeContentView.frame.size.height / 2 - 10.0)];
            [_lblMinFirstLabel setCenter:CGPointMake(_lblMinFirstLabel.center.x, _viewTotalTimeContentView.frame.size.height / 2 - 10.0)];
            [_lblColonSecondLabel setCenter:CGPointMake(_lblColonSecondLabel.center.x, _viewTotalTimeContentView.frame.size.height / 2 - 10.0)];
            [_lblSecondsFirstLabel setCenter:CGPointMake(_lblSecondsFirstLabel.center.x, _viewTotalTimeContentView.frame.size.height / 2 - 10.0)];
            
            UIFont *fontHoursTimeCount = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 28.0];
            
            [_viewMinTimeContentView setFrame: CGRectMake(0.0, 0.0, (_viewTotalTimeContentView.frame.size.width), 65.0)];
            CGFloat timeMinutesWidth = (_viewHoursTimeContentView.frame.size.width - colonWidth) / 2.0;
            [_lblMinSecondLabel setFrame: CGRectMake(0.0, 15.0, timeMinutesWidth, 50.0)];
            [_lblColonThirdLabel setFrame: CGRectMake((_lblMinSecondLabel.frame.origin.x + _lblMinSecondLabel.frame.size.width), 15.0, colonWidth, 50.0)];
            [_lblSecondsSecondLabel setFrame: CGRectMake((_lblColonThirdLabel.frame.origin.x + _lblColonThirdLabel.frame.size.width), 15.0, timeMinutesWidth, 50.0)];
            
            // Vsn - 12/02/2020
            [_lblMinSecondLabel setCenter: CGPointMake(_lblMinSecondLabel.center.x, _viewTotalTimeContentView.frame.size.height / 2 - 10.0)];
            [_lblColonThirdLabel setCenter: CGPointMake(_lblColonThirdLabel.center.x, _viewTotalTimeContentView.frame.size.height / 2 - 10.0)];
            [_lblSecondsSecondLabel setCenter: CGPointMake(_lblSecondsSecondLabel.center.x, _viewTotalTimeContentView.frame.size.height / 2 - 10.0)];

            [_lblHoursFirstLabel setFont: fontHoursTimeCount];
            [_lblColonFirstLabel setFont: fontHoursTimeCount];
            [_lblMinFirstLabel setFont: fontHoursTimeCount];
            [_lblColonSecondLabel setFont: fontHoursTimeCount];
            [_lblSecondsFirstLabel setFont: fontHoursTimeCount];
            [_lblMinSecondLabel setFont: fontExerciseCount];
            [_lblColonThirdLabel setFont: fontExerciseCount];
            [_lblSecondsSecondLabel setFont: fontExerciseCount];
            
            [_lblTotalTimeLabel setFrame: CGRectMake(0.0, (_viewHoursTimeContentView.frame.origin.y + _viewHoursTimeContentView.frame.size.height - 7.0), (_viewTotalTimeContentView.frame.size.width), 30.0)];
            [_lblTotalTimeLabel setCenter: CGPointMake(_lblTotalTimeLabel.center.x, _viewTotalTimeContentView.frame.size.height / 2 + 22.0)];
            [_lblTotalTimeLabel setFont: fontExerciseLabel];
            
            [_viewHoursTimeContentView setHidden: YES];
            [_viewMinTimeContentView setHidden: NO];
            
            [_btnStartRestButton setFrame: CGRectMake(0.0, 0.0, (_scrollViewSetAndRestScreen.frame.size.width), (_viewExerciseAndTotalTimeBackgroundView.frame.origin.y + _viewExerciseAndTotalTimeBackgroundView.frame.size.height))];
            
            [_btnSwipeButton setFrame: CGRectMake((_contentViewSetAndRestScreen.frame.size.width - 52.0) / 2.0, (_viewExerciseAndTotalTimeBackgroundView.frame.origin.y + _viewExerciseAndTotalTimeBackgroundView.frame.size.height + 13.0), 52.0, 20.0)];
            [self.btnMenu setFrame:CGRectMake((_contentViewSetAndRestScreen.frame.size.width - 52.0) / 2.0, (_btnSwipeButton.frame.origin.y + _btnSwipeButton.frame.size.height + 1.0), 52.0, 17.0)];
            
            //Bottom buttons view
            [_viewBottomButtonsBackgroundView setFrame: CGRectMake(0.0, (_btnSwipeButton.frame.origin.y + _btnSwipeButton.frame.size.height + 58.0),(_contentViewSetAndRestScreen.frame.size.width), 270.0)];
            
            [_viewUpperButtonsBackgroundView setFrame: CGRectMake(0.0, 0.0, (_viewBottomButtonsBackgroundView.frame.size.width), ((_viewBottomButtonsBackgroundView.frame.size.height - 32.0) / 2.0))];
            [_viewNextExerciseButtonContentView setFrame: CGRectMake(0.0, 0.0, (_viewUpperButtonsBackgroundView.frame.size.width / 2.0), _viewUpperButtonsBackgroundView.frame.size.height)];
            [_imgNextExerciseImage setFrame: CGRectMake(67.0, 0.0, 80.0, 80.0)];
            [_lblNextExerciseLabel setFrame: CGRectMake(57.0, (_imgNextExerciseImage.frame.origin.y + _imgNextExerciseImage.frame.size.height + 13.0), (_viewNextExerciseButtonContentView.frame.size.width - 57.0), 20.0)];
            UIFont *fontButtonsTitle = [UIFont fontWithName: fFUTURA_MEDIUM size: 16.0];
            [_lblNextExerciseLabel setFont: fontButtonsTitle];
            
            [_viewChangeRestButtonContentView setFrame: CGRectMake(_viewNextExerciseButtonContentView.frame.size.width, 0.0, (_viewUpperButtonsBackgroundView.frame.size.width / 2.0), _viewUpperButtonsBackgroundView.frame.size.height)];
            [_viewChangeRestView setFrame: CGRectMake((_viewChangeRestButtonContentView.frame.size.width - 80.0 - 66.0), 0.0, 80.0, 80.0)];
            [_lblChangeRestCountLabel setFrame: CGRectMake(0.0, (_viewChangeRestView.frame.size.height - 30.0) / 2.0, (_viewChangeRestView.frame.size.width), 30.0)];
            UIFont *fontChangeRestCount = [UIFont fontWithName: fFUTURA_MEDIUM size: 20.0];
            [_lblChangeRestCountLabel setFont: fontChangeRestCount];
            [_lblChangeRestLabel setFrame: CGRectMake(58.0, (_viewChangeRestView.frame.origin.y + _viewChangeRestView.frame.size.height + 13.0), (_viewChangeRestButtonContentView.frame.size.width - 38.0), 20.0)];
            [_lblChangeRestLabel setFont: fontButtonsTitle];
            
            [_viewLowerButtonsBackgroundView setFrame: CGRectMake(0.0, (_viewUpperButtonsBackgroundView.frame.size.height + 40.0), (_viewBottomButtonsBackgroundView.frame.size.width), ((_viewBottomButtonsBackgroundView.frame.size.height - 32.0) / 2.0))];
            [_viewSoundButtonContentView setFrame: CGRectMake(0.0, 0.0, (_viewLowerButtonsBackgroundView.frame.size.width / 2.0), _viewLowerButtonsBackgroundView.frame.size.height)];
            [_imgSoundImage setFrame: CGRectMake(67.0, 0.0, 80.0, 80.0)];
            [_lblSoundLabel setFrame: CGRectMake(70.0, (_imgSoundImage.frame.origin.y + _imgSoundImage.frame.size.height + 13.0), (_viewSoundButtonContentView.frame.size.width - 70.0), 20.0)];
            [_lblSoundLabel setFont: fontButtonsTitle];
            
            [_viewEndWorkoutButtonContentView setFrame: CGRectMake(_viewSoundButtonContentView.frame.size.width, 0.0, (_viewLowerButtonsBackgroundView.frame.size.width / 2.0), _viewLowerButtonsBackgroundView.frame.size.height)];
            [_imgEndWorkoutImage setFrame: CGRectMake((_viewEndWorkoutButtonContentView.frame.size.width - 80.0 - 66.0), 0.0, 80.0, 80.0)];
            [_lblEndWorkoutLabel setFrame: CGRectMake(52.0, (_imgEndWorkoutImage.frame.origin.y + _imgEndWorkoutImage.frame.size.height + 13.0), (_viewEndWorkoutButtonContentView.frame.size.width - 36.0), 20.0)];
            [_lblEndWorkoutLabel setFont: fontButtonsTitle];
            
            
            /*--------------------------------------------------------------------------------*/
            
            //Scroll and content view
            [_scrollViewWorkoutCompleteScreen setFrame: CGRectMake(DEVICE_WIDTH, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
            [_scrollViewWorkoutCompleteScreen setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT)];
            [_contentViewWorkoutCompleteScreen setFrame: CGRectMake(0.0, 0.0, (_scrollViewWorkoutCompleteScreen.contentSize.width), (_scrollViewWorkoutCompleteScreen.contentSize.height))];
            
            //Gym Timer label
            [_lblGymTimerWorkoutScreenTitleLabel setFrame: CGRectMake(0.0, 36.0, (_contentViewSetAndRestScreen.frame.size.width), 40.0)];
            UIFont *fontGymTimerWorkoutScreenLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
            [_lblGymTimerWorkoutScreenTitleLabel setFont: fontGymTimerWorkoutScreenLabel];
            // [_lblGymTimerWorkoutScreenTitleLabel setHidden: YES];
            
            //Workout Stats background view
            // Vsn - 10/04/2020
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
            UIFont *font = [UIFont fontWithName:fFUTURA_MEDIUM_ITALIC size:13.0];
            NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, [UIColor colorWithRed:0.0/255.0 green:220.0/255.0 blue:93.0/255.0 alpha:1], NSForegroundColorAttributeName, nil];
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@"Congratulations" attributes:attrsDictionary]];
            NSDictionary *attrsDict1 = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@" for working out today !" attributes:attrsDict1]];
            _lblCongratulationsText.attributedText = attrString;
            [_lblCongratulationsText updateConstraints];
            
            [_viewPowerPopupInfomation setFrame: CGRectMake(40.0, 0.0, (_lblCongratulationsText.frame.size.width + 24.0), (_lblCongratulationsText.frame.size.height + 14.0))];
            _viewPowerPopupInfomation.layer.cornerRadius = _viewPowerPopupInfomation.frame.size.height / 2;
            [_lblCongratulationsText setFrame: CGRectMake(12.0, 7.0, _lblCongratulationsText.frame.size.width, _lblCongratulationsText.frame.size.height)];
            [_imgPowerPopupInfomationBg setFrame: CGRectMake(-16.0, -11.0, _viewPowerPopupInfomation.frame.size.width + 32.0, _viewPowerPopupInfomation.frame.size.height + 26.0)];
            // End
            CGFloat workoutStatsBgViewY = (_lblGymTimerWorkoutScreenTitleLabel.frame.origin.y + _lblGymTimerWorkoutScreenTitleLabel.frame.size.height );
            [_viewWorkoutStatsBackgroundView setFrame: CGRectMake(18.0, workoutStatsBgViewY, (_contentViewWorkoutCompleteScreen.frame.size.width - 36.0), 414.0)];
            // Vsn - 10/04/2020
            [_viewPowerPopup setFrame: CGRectMake(23.0, _viewWorkoutStatsBackgroundView.frame.origin.y + 15 - 70 + 60, (_contentViewWorkoutCompleteScreen.frame.size.width - 49.0), 70.0)];
            // End
            [[_viewWorkoutStatsBackgroundView layer] setCornerRadius: 30.0];
            
            //Stats content view
            CGFloat statsContentViewY = (_viewWorkoutStatsBackgroundView.frame.size.height - _viewWorkoutStatsBackgroundView.frame.size.width + 9.0);
            CGFloat statsContentWidth = _viewWorkoutStatsBackgroundView.frame.size.width;
            // Vsn - 10/04/2020
//            [_viewWorkoutStatsContentView setFrame: CGRectMake(0.0, statsContentViewY, setAndRestBgWidth, statsContentWidth - 9.0)];
            [_viewWorkoutStatsContentView setFrame: CGRectMake(0.0, 60.0, setAndRestBgWidth, 244)];
            [_vwRandomWorkoutCompleteBackground setFrame: CGRectMake(0.0, _viewWorkoutStatsContentView.frame.size.height + _viewWorkoutStatsContentView.frame.origin.y + 20.0, setAndRestBgWidth, 234)];
            [[_vwRandomWorkoutCompleteBackground layer] setCornerRadius: 30.0];
            // End
            [[_viewWorkoutStatsContentView layer] setCornerRadius: 30.0];
            
            //Do set number view and Rest time view
            CGFloat workoutCompleteViewHeight = (_viewWorkoutStatsBackgroundView.frame.size.height - _viewWorkoutStatsContentView.frame.size.height);
            [_viewWorkoutCompleteContentVIew setFrame: CGRectMake(0.0, 0.0, statsContentWidth, workoutCompleteViewHeight )];
            [_lblWorkoutCompleteLabel setFrame: CGRectMake(31.0, (workoutCompleteViewHeight - 120.0), (statsContentWidth - 100.0), 120.0)];
            UIFont *fontWorkoutCompleteLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 45.0];
            [_lblWorkoutCompleteLabel setFont: fontWorkoutCompleteLabel];
            [_lblWorkoutCompleteLabel setHidden: true];
            
            [_lblCurrentDateLabel setFrame: CGRectMake(0.0, 5.0, (_viewWorkoutStatsContentView.frame.size.width), 70.0)];
            UIFont *currentDateLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 26.0];
            [_lblCurrentDateLabel setFont: currentDateLabel];
            // Vsn - 10/04/2020
            [_lblRandomWorkoutCompleteTitle setFrame: _lblCurrentDateLabel.frame];
            [_lblRandomWorkoutCompleteTitle setFont:currentDateLabel];
            // End
            
            // Vsn - 12/03/2020
            // New Design            
            [self.vwDateTime setFrame:CGRectMake(0, 0, setAndRestBgWidth + 12, 70)];
            [self.vwCompetedBottom setFrame:CGRectMake(0, 50, setAndRestBgWidth + 12, 184)];
            // Vsn - 10/04/2020
            [_vwRandomWorkoutCompleteTitle setFrame:CGRectMake(0, 0, setAndRestBgWidth, 70)];
            [_vwRandomWorkoutCompleteSubTitle setFrame:CGRectMake(0, 70, setAndRestBgWidth, _vwRandomWorkoutCompleteBackground.frame.size.height - 70)];
            [_lblRandomWorkoutCompleteSubTitle setFrame:CGRectMake(20.0, 20.0, setAndRestBgWidth - 40, _vwRandomWorkoutCompleteSubTitle.frame.size.height - 40)];
            
            if ([[Utils getIsPaidUser] isEqualToString: @"YES"]) {
                [_vwRandomWorkoutCompletePro setHidden: true];
                [self callGetExerciseHistoryAPI];
            } else {
                [_lblRandomWorkoutCompleteSubTitle setAttributedText: [self getWorkoutCompleteLastPopupText]];
                
                [_vwRandomWorkoutCompletePro setHidden: false];
                
                [_vwRandomWorkoutCompletePro setFrame: CGRectMake(_vwRandomWorkoutCompleteSubTitle.frame.origin.x + 25.0, _vwRandomWorkoutCompleteSubTitle.frame.origin.y - 15.0, _vwRandomWorkoutCompleteSubTitle.frame.size.width - 50.0, 30.0)];
                [[_vwRandomWorkoutCompletePro layer] setCornerRadius: 10.0];
                [[_vwRandomWorkoutCompletePro layer] setMasksToBounds: NO];
                [[_vwRandomWorkoutCompletePro layer] setShadowColor: [[UIColor blackColor] CGColor]];
                [[_vwRandomWorkoutCompletePro layer] setShadowOffset: CGSizeMake(1.0, 1.0)];
                [[_vwRandomWorkoutCompletePro layer] setShadowRadius: 10.0];
                [[_vwRandomWorkoutCompletePro layer] setShadowOpacity: 0.5];
                UIBezierPath *workoutViewShadowPathPro = [UIBezierPath bezierPathWithRect: [_vwRandomWorkoutCompletePro bounds]];
                [[_vwRandomWorkoutCompletePro layer] setShadowPath: [workoutViewShadowPathPro CGPath]];
                
                [_lblRandomWorkoutCompleteProText setFrame: CGRectMake(0.0, (_vwRandomWorkoutCompletePro.frame.size.height / 2) - 12.5, _vwRandomWorkoutCompletePro.frame.size.width, 25.0)];
                
                NSTextAttachment *attachment1 = [[NSTextAttachment alloc] init];
                attachment1.image = [UIImage imageNamed:@"lockgreen"];
                NSMutableAttributedString *attrString = [NSAttributedString attributedStringWithAttachment:attachment1].mutableCopy;
                UIFont *font = [UIFont fontWithName:fFUTURA_MEDIUM size:12.0];
                
                NSDictionary *attrsGreen = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, [UIColor colorWithRed:0.0/255.0 green:220.0/255.0 blue:93.0/255.0 alpha:1], NSForegroundColorAttributeName, nil];
                NSDictionary *attrsBackground = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:fFUTURA_BOLD size:14.0], NSFontAttributeName, [UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:56.0/255.0 alpha:1], NSForegroundColorAttributeName, [UIColor greenColor], NSBackgroundColorAttributeName, nil];

                [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@"  These are exclusive for the " attributes:attrsGreen]];
                [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@"PRO" attributes:attrsBackground]];
                [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@" community" attributes:attrsGreen]];
                
                [_lblRandomWorkoutCompleteProText setAttributedText: attrString];
            }
            // End
            [self.vwQuality setFrame:CGRectMake(0, 0, (setAndRestBgWidth + 12) / 2, 214)];
            [self.vwTime setFrame:CGRectMake((setAndRestBgWidth + 12) / 2, 0, (setAndRestBgWidth + 12) / 2, 214)];
            
            [self.lblTotalTimeTitle setFrame:CGRectMake(16, 30, self.vwTime.frame.size.width - 16, 20)];
            
            [self.lblTotalExercisetitle setFrame:CGRectMake(16, 107, self.vwTime.frame.size.width - 16, 20)];
            [self.lblTotalExercise setFrame:CGRectMake(16, 134, self.vwTime.frame.size.width - 16, 41)];
            
            [self.lblQuality setFrame:CGRectMake(48, 30, 50, 20)];
            [self.vwQualityProgress setFrame:CGRectMake(38, 65, 118, 118)];
            
            self.vwQualityProgress.valueFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
            self.vwQualityProgress.valueFontSize = 32;
            self.vwQualityProgress.fontColor = cNEW_GREEN;
            self.vwQualityProgress.unitFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
            self.vwQualityProgress.unitFontSize = 18;
            
            //Total workout time views
            [_lblTotalWorkoutTimeLabel setHidden: YES];
            [_lblTotalWorkoutExercisesLabel setHidden: YES];
            
            [_viewHoursTimeFormatContentView setFrame: CGRectMake(37.0, (_lblCurrentDateLabel.frame.origin.y + _lblCurrentDateLabel.frame.size.height + 24.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
            [[_viewHoursTimeFormatContentView layer] setCornerRadius: 15.0];
            
            CGFloat timeCountLabelWidth = ([_viewHoursTimeFormatContentView frame].size.width / 6.0);
            CGFloat timeTitlelabelWidth = ([_viewHoursTimeFormatContentView frame].size.width / 6.0);
            
            //Hours min sec format
            [_lblFirstHoursCountLabel setFrame: CGRectMake(19.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
            [_lblFirstHoursTitleLabel setFrame: CGRectMake((_lblFirstHoursCountLabel.frame.origin.x + _lblFirstHoursCountLabel.frame.size.width) - 0.0, 8.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
            [_lblFirstMinCountLabel setFrame: CGRectMake((_lblFirstHoursTitleLabel.frame.origin.x + _lblFirstHoursTitleLabel.frame.size.width) - 26.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
            [_lblFirstMinTitleLabel setFrame: CGRectMake((_lblFirstMinCountLabel.frame.origin.x + _lblFirstMinCountLabel.frame.size.width) - 0.5, 8.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
            [_lblFirstSecCountLabel setFrame: CGRectMake((_lblFirstMinTitleLabel.frame.origin.x + _lblFirstMinTitleLabel.frame.size.width) - 6.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
            [_lblFirstSecTitleLabel setFrame: CGRectMake((_lblFirstSecCountLabel.frame.origin.x + _lblFirstSecCountLabel.frame.size.width) - 0.0, 8.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
            
            //Min sec format
            [_viewMinTimeFormatContentView setFrame: CGRectMake(37.0, (_lblCurrentDateLabel.frame.origin.y + _lblCurrentDateLabel.frame.size.height + 24.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
            [[_viewMinTimeFormatContentView layer] setCornerRadius: 15.0];
            [_lblSecondMinCountLabel setFrame: CGRectMake(44.0, 0.0, (timeCountLabelWidth + 8.0), (_viewMinTimeFormatContentView.frame.size.height))];
            [_lblSecondMinTitleLabel setFrame: CGRectMake((_lblSecondMinCountLabel.frame.origin.x + _lblSecondMinCountLabel.frame.size.width) - 0.0, 12.0, timeTitlelabelWidth, (_viewMinTimeFormatContentView.frame.size.height - 12.0))];
            [_lblSecondSecCountLabel setFrame: CGRectMake((_lblSecondMinTitleLabel.frame.origin.x + _lblSecondMinTitleLabel.frame.size.width) - 4.0, 0.0, (timeCountLabelWidth + 8.0), (_viewMinTimeFormatContentView.frame.size.height))];
            [_lblSecondSecTitleLabel setFrame: CGRectMake((_lblSecondSecCountLabel.frame.origin.x + _lblSecondSecCountLabel.frame.size.width) - 0.0, 12.0, timeTitlelabelWidth, (_viewMinTimeFormatContentView.frame.size.height - 12.0))];
            
            //Total exercise view
            [_viewTotalExerciseContentView setFrame: CGRectMake(37.0, (_viewHoursTimeFormatContentView.frame.origin.y + _viewHoursTimeFormatContentView.frame.size.height + 18.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
            [[_viewTotalExerciseContentView layer] setCornerRadius: 15.0];
            [_lblTotalExerciseCountLabel setFrame: CGRectMake(45.0, 0.0, (timeCountLabelWidth + 8.0), (_viewTotalExerciseContentView.frame.size.height - 1.0))];
            [_lblExerciseTitleLabel setFrame: CGRectMake((_lblTotalExerciseCountLabel.frame.origin.x + _lblTotalExerciseCountLabel.frame.size.width), 11.0, (_viewTotalExerciseContentView.frame.size.width - (_lblTotalExerciseCountLabel.frame.origin.x + _lblTotalExerciseCountLabel.frame.size.width)), (_viewTotalExerciseContentView.frame.size.height - 11.0))];
            
            lblCounting = [[UICountingLabel alloc] initWithFrame: CGRectMake(60.0, (_viewTotalExerciseContentView.frame.origin.y + _viewTotalExerciseContentView.frame.size.height + 12.0), 100.0, 40.0)];
            [_viewWorkoutStatsContentView addSubview: lblCounting];
            
            [self.lblShortWorkoutMsg setFrame:CGRectMake(20, self.viewWorkoutStatsBackgroundView.frame.origin.y + self.viewWorkoutStatsBackgroundView.frame.size.height + 8, self.viewWorkoutStatsBackgroundView.frame.size.width, 32)];
            // Vsn - 10/04/2020
//            [self.btnDoneWorkoutButton setFrame:CGRectMake(self.view.frame.size.width / 2 + 40, self.viewWorkoutStatsBackgroundView.frame.origin.y + self.viewWorkoutStatsBackgroundView.frame.size.height + 58, 80, 80)];
//            [self.btnShareStatsButton setFrame:CGRectMake(self.view.frame.size.width / 2 - 120, self.viewWorkoutStatsBackgroundView.frame.origin.y + self.viewWorkoutStatsBackgroundView.frame.size.height + 58, 80, 80)];
            [self.btnDoneWorkoutButton setFrame:CGRectMake(self.view.frame.size.width / 2 + 40, self.viewWorkoutStatsBackgroundView.frame.origin.y + self.vwRandomWorkoutCompleteBackground.frame.origin.y + self.vwRandomWorkoutCompleteBackground.frame.size.height + 10, 80, 80)];
            [self.btnShareStatsButton setFrame:CGRectMake(self.view.frame.size.width / 2 - 120, self.viewWorkoutStatsBackgroundView.frame.origin.y + self.vwRandomWorkoutCompleteBackground.frame.origin.y + self.vwRandomWorkoutCompleteBackground.frame.size.height + 10, 80, 80)];
            // End

        }
    } else if (IS_IPHONE8) {
        {
            //Loader view
            [_viewLoaderBackgroundView setFrame: CGRectMake(0.0, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
            [_lblLoaderGymTimerLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
            UIFont *fontGymTimerLoaderLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
            [_lblLoaderGymTimerLabel setFont: fontGymTimerLoaderLabel];
            [_viewLoaderContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
            
            //Scroll and Content view
            // Vsn - 14/02/2020
            [_scrollViewWorkoutScreen setFrame: CGRectMake(0.0, 30.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
            [_contentViewWorkoutScreen setFrame: CGRectMake(0.0, 0.0, (_scrollViewWorkoutScreen.frame.size.width), (_scrollViewWorkoutScreen.frame.size.height))];
            CGFloat contentViewWidth = _contentViewWorkoutScreen.frame.size.width;
            CGFloat contentViewHeight = _contentViewWorkoutScreen.frame.size.height;
            
            //GymTimer label
            [_lblGymTimerTitleLabel setFrame: CGRectMake(0.0, -23.0, (_contentViewWorkoutScreen.frame.size.width), 113.0)];
            UIFont *fontGymTimer = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 60.7];
            [_lblGymTimerTitleLabel setFont: fontGymTimer];
            
            // Vsn - 11/02/2020
            [_lblBoostYourWorkoutsSetScreenLabel setFrame: CGRectMake((_contentViewWorkoutScreen.frame.size.width / 2.0) - 157.0, 26.5, (_contentViewWorkoutScreen.frame.size.width), 80.0)];
//            [_lblBoostYourWorkoutsSetScreenLabel setFrame: CGRectMake((_contentViewWorkoutScreen.frame.size.width / 2.0) - 130.0, 30.0, (_contentViewWorkoutScreen.frame.size.width), 80.0)];
//            [lblBoostYourWorkoutText addAttribute:NSKernAttributeName value:@2.9 range:NSMakeRange(0, lblBoostYourWorkoutText.length)];
//            [_lblBoostYourWorkoutsSetScreenLabel setAttributedText: lblBoostYourWorkoutText];
            UIFont *fontGymTimer1 = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 20.5];
            [_lblBoostYourWorkoutsSetScreenLabel setFont: fontGymTimer1];
            
            
            //Start Workout content view
            CGFloat gymtimerY = _lblGymTimerTitleLabel.frame.origin.y;
            CGFloat gymtimerHeight = _lblGymTimerTitleLabel.frame.size.height;
            CGFloat tabbarHeight = 53.0;
            //        CGFloat tabbarHeight = [[[self tabBarController] tabBar] frame].size.height;
            [_viewWorkoutContentView setFrame: CGRectMake(30.0, (_lblGymTimerTitleLabel.frame.origin.y + _lblGymTimerTitleLabel.frame.size.height + 10.0), (contentViewWidth - 66.0), (contentViewHeight - (gymtimerY + gymtimerHeight + tabbarHeight + 50.0)))];
            // Vsn - 19/02/2020
            [_viewWorkoutContentViewSubView setFrame: CGRectMake(0.0, 0.0, _viewWorkoutContentView.frame.size.width, _viewWorkoutContentView.frame.size.height)];
            // Vsn - 25/02/2020
            [_vwImgWelcomeBack setFrame: CGRectMake(0.0, 0.0, _viewWorkoutContentView.frame.size.width, _viewWorkoutContentView.frame.size.height)];
            [_vwWorkoutContentParent setFrame:CGRectMake(0.0, 0.0, _viewWorkoutContentView.frame.size.width, _viewWorkoutContentView.frame.size.height)];
            [_imgHomeBottomGym setFrame: CGRectMake(-21.0, -19.0, _viewWorkoutContentView.frame.size.width + 42.0, _viewWorkoutContentView.frame.size.height + 45.0)];
            
            //Choose default rest time label
            CGFloat workoutContentViewWidth = _viewWorkoutContentView.frame.size.width;
            UIFont *fontMinSec = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
            [_lblChooseDefaultTimeLabel setFrame: CGRectMake(0.0, 32.0, (workoutContentViewWidth), 42.0)];
            [_lblChooseDefaultTimeLabel setFont: fontMinSec];
            [_lblChooseDefaultTimeLabel setAlpha: 0.5];
            
            // Vsn - 10/02/2020
            //Rest time picker view
            [_pickerWorkoutRestTimePickerView setFrame: CGRectMake(32.0, (_lblChooseDefaultTimeLabel.frame.origin.y + _lblChooseDefaultTimeLabel.frame.size.height + 30), (workoutContentViewWidth - 64.0), 210.0)];
//            [_pickerWorkoutRestTimePickerView setFrame: CGRectMake(32.0, (_lblChooseDefaultTimeLabel.frame.origin.y + _lblChooseDefaultTimeLabel.frame.size.height + 10), (workoutContentViewWidth - 64.0), 260.0)];

            //Minute and seconds view
            [_viewMinutesSecondsContentView setFrame: CGRectMake(0.0, (_lblChooseDefaultTimeLabel.frame.origin.y + _lblChooseDefaultTimeLabel.frame.size.height + 112.0), workoutContentViewWidth, 40.0)];
            [_lblMinuteLabel setFrame: CGRectMake(128.0, 10.0, 30.0, 21.0)];
            [_lblSecondsLabel setFrame: CGRectMake(231.0, 10.0, 15.0, 21.0)];
            [_lblMinuteLabel setFont: fontMinSec];
            [_lblSecondsLabel setFont: fontMinSec];
            
            {//Dinal4-done
                
                UIFont *newBtnFont = [UIFont fontWithName: fFUTURA_BOLD size: 11.0];
                [_btnEndurance.titleLabel setFont:newBtnFont];
                [_btnMuscle.titleLabel setFont:newBtnFont];
                [_btnpower.titleLabel setFont:newBtnFont];
                //            [_lblRecommend setFont:newBtnFont];
                
                UIFont *newGreenFont = [UIFont fontWithName: fFUTURA_MEDIUM size: 11.0];
                [_lblRange1 setFont:newGreenFont];
                [_lblRange2 setFont:newGreenFont];
                [_lblRange11 setFont:newGreenFont];
                [_lblRange22 setFont:newGreenFont];
                
                UIFont *newSetRepsFont = [UIFont fontWithName: fFUTURA_MEDIUM size: 12.0];
                [_lblSets setFont:newSetRepsFont];
                [_lblReps setFont:newSetRepsFont];
                [_lblRecommend setFont:newSetRepsFont];
                
                UIFont *newScientificFont = [UIFont fontWithName: fFUTURA_MEDIUM size: 10.5];
                [_lblScientific setFont:newScientificFont];
                
                CGFloat widthParent = _viewTabParent.frame.size.width;
                
                CGRect frameRecommend = _lblRecommend.frame;
                frameRecommend.size.width = widthParent * 0.4210;
                frameRecommend.origin.x += 3.0;
                [_lblRecommend setFrame:frameRecommend];
                
                CGRect frameRange1 = _lblRange1.frame;
                //            frameRange1.size.width = widthParent * 0.0964;
                frameRange1.origin.x = frameRecommend.origin.x + frameRecommend.size.width - 12.0;
                [_lblRange1 setFrame:frameRange1];
                
                CGRect minus1 = _lblMinus1.frame;
                //            minus1.size.width = widthParent * 0.0964;
                minus1.origin.x = _lblRange1.frame.origin.x + _lblRange1.frame.size.width - 3.0;
                [_lblMinus1 setFrame:minus1];
                
                CGRect frameRange11 = _lblRange11.frame;
                //            frameRange11.size.width = widthParent * 0.0964;
                frameRange11.origin.x = _lblMinus1.frame.origin.x + _lblMinus1.frame.size.width - 4.0;
                [_lblRange11 setFrame:frameRange11];
                
                CGRect frameSets = _lblSets.frame;
                frameSets.size.width = widthParent * 0.1096;
                frameSets.origin.x = frameRange11.origin.x + frameRange11.size.width;
                [_lblSets setFrame:frameSets];
                
                CGRect frameSeprator1 = _lblSeparator1.frame;
                frameSeprator1.size.width = 1.0;
                frameSeprator1.origin.x = frameSets.origin.x + frameSets.size.width - 2.0;
                [_lblSeparator1 setFrame:frameSeprator1];
                
                CGRect frameRange2 = _lblRange2.frame;
                //            frameRange2.size.width = widthParent * 0.0964;
                frameRange2.origin.x = frameSeprator1.origin.x + frameSeprator1.size.width + 4.0;
                // Vsn - 09/04/2020
                frameRange2.size.width = frameRange2.size.width + 7.0;
                // End
                [_lblRange2 setFrame:frameRange2];
                
                CGRect minus2 = _lblMinus2.frame;
                //minus2.size.width = widthParent * 0.0964;
                minus2.origin.x = _lblRange2.frame.origin.x + _lblRange2.frame.size.width - 3.0;
                [_lblMinus2 setFrame:minus2];
                
                CGRect frameRange22 = _lblRange22.frame;
                //            frameRange22.size.width = widthParent * 0.0964;
                frameRange22.origin.x = _lblMinus2.frame.origin.x + _lblMinus2.frame.size.width - 4.0;
                [_lblRange22 setFrame:frameRange22];
                
                CGRect frameReps = _lblReps.frame;
                frameReps.size.width = widthParent * 0.1228;
                frameReps.origin.x = _lblRange22.frame.origin.x + _lblRange22.frame.size.width;
                [_lblReps setFrame:frameReps];
                
                CGRect frameSeprator2 = _lblSeparator2.frame;
                frameSeprator2.size.width = 1.0;
                frameSeprator2.origin.x = frameReps.origin.x + frameReps.size.width - 2.0;
                [_lblSeparator2 setFrame:frameSeprator2];
                
                CGRect frameDumbell = _imgDumbell.frame;
                frameDumbell.size.width = widthParent * 0.1140;
                frameDumbell.origin.x = frameSeprator2.origin.x + frameSeprator2.size.width + 3.0;
                [_imgDumbell setFrame:frameDumbell];
                
                CGRect frameArrow = _btnArrowScientifically.frame;
                frameArrow.origin.x = _lblScientific.frame.size.width + 15.0;
                [_btnArrowScientifically setFrame:frameArrow];
            }
            
            // Vsn - 10/02/2020
            //Start workout button
            [_btnStartWorkoutButton setFrame: CGRectMake(50.0, (_pickerWorkoutRestTimePickerView.frame.size.height + _pickerWorkoutRestTimePickerView.frame.origin.y + 05.0)+5, (workoutContentViewWidth - 80.0)-20, 55.0-10)];
//            [_btnStartWorkoutButton setFrame: CGRectMake(40.0, (_viewWorkoutContentView.frame.size.height - 115.0), (workoutContentViewWidth - 80.0), 50.0)];
            [_btnStartWorkoutButton setBackgroundColor: UIColorFromRGB(0x14CC64)];
            UIFont *fontStartButton = [UIFont fontWithName: fFUTURA_BOLD size: 20.0];
            dicStartButtonAttributes = [[NSDictionary alloc] init];
            dicStartButtonAttributes = @{ NSForegroundColorAttributeName : UIColorFromRGB(0x009938),
                                          NSFontAttributeName : fontStartButton
            };
            NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"Start Workout" attributes: dicStartButtonAttributes];
            [_btnStartWorkoutButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
            [[_btnStartWorkoutButton layer] setCornerRadius: _btnStartWorkoutButton.frame.size.height / 3.5]; //17.0
            
            /*--------------------------------------------------------------------------------*/
            
            //Scroll and content view
            //        [_scrollViewSetAndRestScreen setFrame: CGRectMake(DEVICE_WIDTH, -44.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
            [_scrollViewSetAndRestScreen setFrame: CGRectMake(DEVICE_WIDTH, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
            //        [_scrollViewSetAndRestScreen setFrame: CGRectMake(DEVICE_WIDTH, 44.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
            [_scrollViewSetAndRestScreen setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + 221.0 + 173.0)];
            [_contentViewSetAndRestScreen setFrame: CGRectMake(0.0, 0.0, (_scrollViewSetAndRestScreen.frame.size.width), (_scrollViewSetAndRestScreen.contentSize.height + 104.0))];
            
            //Gym Timer label
            [_lblGymTimerSetScreenLabel setFrame: CGRectMake(0.0, 20.0, (_contentViewSetAndRestScreen.frame.size.width), 40.0)];
            UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 28.0];
            [_lblGymTimerSetScreenLabel setFont: fontGymTimerLabel];
            
            //Set and rest background view
            CGFloat setAndRestBgViewY = (_lblGymTimerSetScreenLabel.frame.origin.y + _lblGymTimerSetScreenLabel.frame.size.height + 12.0);
            [_viewSetAndRestBackgroundView setFrame: CGRectMake(18.0, setAndRestBgViewY, (_contentViewSetAndRestScreen.frame.size.width - 36.0), 420.0)];
            [[_viewSetAndRestBackgroundView layer] setCornerRadius: 30.0];
            
            //Progress bar background view
            CGFloat setAndRestProgressBarBgViewY = (_viewSetAndRestBackgroundView.frame.size.height - _viewSetAndRestBackgroundView.frame.size.width + 9.0);
            CGFloat setAndRestBgWidth = _viewSetAndRestBackgroundView.frame.size.width;
            [_viewSetAndRestScreenProgressBackgroundView setFrame: CGRectMake(0.0, setAndRestProgressBarBgViewY + 50.0, setAndRestBgWidth, setAndRestBgWidth - 39.0)];
            [[_viewSetAndRestScreenProgressBackgroundView layer] setCornerRadius: 30.0];
            
            // Warm up view
            [self.vwWarmUp setFrame: CGRectMake(0.0, setAndRestProgressBarBgViewY + 50.0, setAndRestBgWidth, setAndRestBgWidth - 39.0)];
            
            //Do set number view and Rest time view
            [_viewDoSetNumberContentView setHidden: YES];
            [_viewRestTimeContentView setHidden: NO];
            CGFloat doSetNumberViewHeight = (_viewSetAndRestBackgroundView.frame.size.height - _viewSetAndRestScreenProgressBackgroundView.frame.size.height);
            [_viewDoSetNumberContentView setFrame: CGRectMake(0.0, 0.0, setAndRestBgWidth, doSetNumberViewHeight)];
            
            [_lblDoSetNumberCountLabel setFrame: CGRectMake((setAndRestBgWidth - 95.0), 6.0, 121.0, (doSetNumberViewHeight - 16.0))];
            UIFont *fontDoSetCount = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 50.0];
            [_lblDoSetNumberCountLabel setFont: fontDoSetCount];
            [self adjustFontOfDoSetCountLabel];
            
            [_lblDoSetNumberLabel setFrame: CGRectMake(0.0, (doSetNumberViewHeight - 103.0), (setAndRestBgWidth - _lblDoSetNumberCountLabel.frame.size.width - 10.5), 123.0)];
            UIFont *fontDoSetLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0];
            [_lblDoSetNumberLabel setFont: fontDoSetLabel];
            
            [_viewRestTimeContentView setFrame: CGRectMake(0.0, 0.0, setAndRestBgWidth, doSetNumberViewHeight)];
            CGFloat restTimerColonWidth = 40.0;
            CGFloat restTimerMinSecWidth = (setAndRestBgWidth - restTimerColonWidth) / 2.0;
            [_lblRestTimerMinutesLabel setFrame: CGRectMake(0.0, 16.0, restTimerMinSecWidth, doSetNumberViewHeight)];
            [_lblRestTimerColonLabel setFrame: CGRectMake((_lblRestTimerMinutesLabel.frame.size.width), 16.0, restTimerColonWidth, doSetNumberViewHeight)];
            [_lblRestTimerSecondsLabel setFrame: CGRectMake((_lblRestTimerColonLabel.frame.origin.x + _lblRestTimerColonLabel.frame.size.width), 16.0, restTimerMinSecWidth, doSetNumberViewHeight)];
            
            [self.vwLastExercise setFrame:CGRectMake(0.0, 0.0, setAndRestBgWidth, doSetNumberViewHeight)];
            [self.lblTimeSinceTitle setFrame:CGRectMake(20.0, 15.0, self.vwLastExercise.frame.size.width - 40.0, 29.0)];
            [self.lblTimeSince setFrame:CGRectMake(20.0, (self.lblTimeSinceTitle.frame.origin.y + self.lblTimeSinceTitle.frame.size.height) - 16 , self.vwLastExercise.frame.size.width - 40.0, 116.0)];
            UIFont *fontTimeSinceLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 79.0];
            [self.lblTimeSince setFont: fontTimeSinceLabel];
            
            //[_lblRestTimeLabel setFrame: CGRectMake(0.0, 15.0, setAndRestBgWidth, (doSetNumberViewHeight - 15.0))];
            UIFont *fontRestTimeLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 110.0];
            [_lblRestTimerMinutesLabel setFont: fontRestTimeLabel];
            [_lblRestTimerColonLabel setFont: fontRestTimeLabel];
            [_lblRestTimerSecondsLabel setFont: fontRestTimeLabel];
            
            //View last exercise
            CGFloat viewProgressBarHeight = _viewSetAndRestScreenProgressBackgroundView.frame.size.height;
            CGFloat viewProgressBarWidth = _viewSetAndRestScreenProgressBackgroundView.frame.size.width;
            
            [_viewLastExerciseTimeContentView setFrame: CGRectMake(22.0, 12.0, viewProgressBarWidth, 80.0)];
            [_lblSinceLastExerciseLabel setFrame: CGRectMake(0.0, 0.0, (_viewLastExerciseTimeContentView.frame.size.width), 30.0)];
            UIFont *fontSinceLastExerciseLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
            [_lblSinceLastExerciseLabel setFont: fontSinceLastExerciseLabel];
            
            CGFloat lastExerciseColonWidth = 12.0;
            CGFloat hoursFormatCountWidth = 40.0;
            
            //Hours format
            [_viewLastExerciseHoursFormat setFrame: CGRectMake(-16.0, 14.0, (_viewLastExerciseTimeContentView.frame.size.width), (_viewLastExerciseTimeContentView.frame.size.height - (_lblSinceLastExerciseLabel.frame.origin.y + _lblSinceLastExerciseLabel.frame.size.height)))];
            
            UIFont *fontLastExerciseHourFormat = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 20.0];
            [_lblLastExerciseFirstHourLabel setFrame: CGRectMake(0.0, 0.0, hoursFormatCountWidth, (_viewLastExerciseHoursFormat.frame.size.height))];
            [_lblLastExerciseHourFirstColonLabel setFrame: CGRectMake((_lblLastExerciseFirstHourLabel.frame.origin.x + _lblLastExerciseFirstHourLabel.frame.size.width), 0.0, (lastExerciseColonWidth - 4.0), (_viewLastExerciseHoursFormat.frame.size.height))];
            [_lblLastExerciseFirstMinLabel setFrame: CGRectMake((_lblLastExerciseHourFirstColonLabel.frame.origin.x + _lblLastExerciseHourFirstColonLabel.frame.size.width) - 5.0, 0.0, hoursFormatCountWidth, (_viewLastExerciseHoursFormat.frame.size.height))];
            [_lblLastExerciseHourSecondColonLabel setFrame: CGRectMake((_lblLastExerciseFirstMinLabel.frame.origin.x + _lblLastExerciseFirstMinLabel.frame.size.width) - 5.0, 0.0, (lastExerciseColonWidth - 4.0), (_viewLastExerciseHoursFormat.frame.size.height))];
            [_lblLastExerciseFirstSecLabel setFrame: CGRectMake((_lblLastExerciseHourSecondColonLabel.frame.origin.x + _lblLastExerciseHourSecondColonLabel.frame.size.width), 0.0, hoursFormatCountWidth, (_viewLastExerciseHoursFormat.frame.size.height))];
            [_lblLastExerciseFirstHourLabel setFont: fontLastExerciseHourFormat];
            [_lblLastExerciseHourFirstColonLabel setFont: fontLastExerciseHourFormat];
            [_lblLastExerciseFirstMinLabel setFont: fontLastExerciseHourFormat];
            [_lblLastExerciseHourSecondColonLabel setFont: fontLastExerciseHourFormat];
            [_lblLastExerciseFirstSecLabel setFont: fontLastExerciseHourFormat];
            
            //Minutes format
            CGFloat minuteFormatCountWidth = 40.0;
            UIFont *fontLastExerciseMinuteFormat = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 24.5];
            
            [_viewLastExerciseMinuteFormat setFrame: CGRectMake(-10.0, 18.0, (_viewLastExerciseTimeContentView.frame.size.width), (_viewLastExerciseTimeContentView.frame.size.height - (_lblSinceLastExerciseLabel.frame.origin.y + _lblSinceLastExerciseLabel.frame.size.height)))];
            
            [_lblLastExerciseSecondMinLabel setFrame: CGRectMake(0.0, 0.0, minuteFormatCountWidth, (_viewLastExerciseMinuteFormat.frame.size.height))];
            [_lblLastExerciseSecondColonLabel setFrame: CGRectMake((_lblLastExerciseSecondMinLabel.frame.origin.x + _lblLastExerciseSecondMinLabel.frame.size.width), 0.0, lastExerciseColonWidth, (_viewLastExerciseMinuteFormat.frame.size.height))];
            [_lblLastExerciseSecondSecLabel setFrame: CGRectMake((_lblLastExerciseSecondColonLabel.frame.origin.x + _lblLastExerciseSecondColonLabel.frame.size.width), 0.0, minuteFormatCountWidth, (_viewLastExerciseMinuteFormat.frame.size.height))];
            [_lblLastExerciseSecondMinLabel setFont: fontLastExerciseMinuteFormat];
            [_lblLastExerciseSecondColonLabel setFont: fontLastExerciseMinuteFormat];
            [_lblLastExerciseSecondSecLabel setFont: fontLastExerciseMinuteFormat];
            
            
            //Progress bar view and dumbells image
            [self setupProgressBar];
            [_progressBarSetScreenView setFrame: CGRectMake(47.5, 47.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
            [_progressBarRestScreenView setFrame: CGRectMake(47.5, 47.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
            [_progressBarRestBackgroungView setFrame: CGRectMake(47.5, 47.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
            [_vwRestScreenDumbellsBackgroundImage setFrame: CGRectMake(47.5, 47.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
            CGFloat progressBarHeight = _progressBarSetScreenView.frame.size.height;
            CGFloat progressBarWidth = _progressBarSetScreenView.frame.size.width;
            
            // Vsn - 05/02/2020
            CGFloat greenDumbellsImageWidth = 93.0;
            CGFloat greenDumbellsImageHeight = 127.0;
            CGFloat redDumbellsImageWidth = 160.0;
            CGFloat redDumbellsImageHeight = 152.0;

            [self.imgRestScreenDumbellsImage setFrame: CGRectMake(((progressBarWidth - redDumbellsImageWidth) / 2.0) + 0.5, ((progressBarHeight - redDumbellsImageHeight) / 2.0) + 12.0, redDumbellsImageWidth, redDumbellsImageHeight)];
            [self.imgRestScreenDumbellsBackgroundImage setFrame: self.imgRestScreenDumbellsImage.frame];

//            CGFloat greenDumbellsImageWidth = 78.0;
//            CGFloat greenDumbellsImageHeight = 106.0;
//            CGFloat redDumbellsImageWidth = 60.0;
//            CGFloat redDumbellsImageHeight = 128.0;
//
//            [_imgRestScreenDumbellsImage setFrame: CGRectMake(((progressBarWidth - redDumbellsImageWidth) / 2.0) + 4.0, ((progressBarHeight - redDumbellsImageHeight) / 2.0) + 10.0, redDumbellsImageWidth, redDumbellsImageHeight)];
            [_imgRestScreenDumbellsImage setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
            
            // Set Character
            [self.imgSetScreenDumbellsImage setFrame:CGRectMake(47.5, 20, greenDumbellsImageWidth, greenDumbellsImageHeight)];
            // Vsn - 05/02/2020
            self.imgSetScreenDumbellsImage.center = CGPointMake(self.viewSetAndRestScreenProgressBackgroundView.bounds.size.width  / 2, 132.0);
//            self.imgSetScreenDumbellsImage.center = CGPointMake(self.viewSetAndRestScreenProgressBackgroundView.bounds.size.width  / 2, 140.0);

            // Next Exercise Progress Ring
            [self.vwNextExercise setFrame: CGRectMake(47.5, 47.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
            [self.vwNextExerciseRing setFrame:CGRectMake(0, 0, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
            [self.imgNextExercise setFrame:CGRectMake(0.0, 0.0, 90, 140)];
            self.imgNextExercise.center = CGPointMake(self.vwNextExercise.frame.size.width  / 2, self.vwNextExercise.frame.size.height / 2);
            
            //Click anywhere and Next set view
            [_viewClickAnywhereContentView setFrame: CGRectMake(0.0, (viewProgressBarHeight - 59.0), viewProgressBarWidth, 59.0)];
            [_lblClickAnywhereToRestLabel setFrame: CGRectMake(1.0, 0.0, (_viewClickAnywhereContentView.frame.size.width - 1.0), (_viewClickAnywhereContentView.frame.size.height))];
            UIFont *fontClickAnywhereLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
            [_lblClickAnywhereToRestLabel setFont: fontClickAnywhereLabel];
            
            // Vsn - 05/02/2020
            [_viewNextSetContentView setFrame: CGRectMake(0.0, 0.0, viewProgressBarWidth, 120.0)];
            [_lblNextSetCountLabel setFrame: CGRectMake((_viewNextSetContentView.frame.size.width - 82.0), 25.0, 75.0, 90.0)];
            UIFont *fontNextSetCountLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 73.0];
            [_lblNextSetCountLabel setFont: fontNextSetCountLabel];
            [[_lblNextSetCountLabel layer] setCornerRadius: 30.0];
            [_lblNextSetLabel setFrame: CGRectMake(0.0, 0.0, (_viewNextSetContentView.frame.size.width - 25.0), 40.0)];
//            [_viewNextSetContentView setFrame: CGRectMake(0.0, (viewProgressBarHeight - 60.0), viewProgressBarWidth, 60.0)];
//            [_lblNextSetCountLabel setFrame: CGRectMake((_viewNextSetContentView.frame.size.width - 60.0), 0.0, 60.0, 60.0)];
//            UIFont *fontNextSetCountLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0];
//            [_lblNextSetLabel setFrame: CGRectMake(0.0, (_viewNextSetContentView.frame.size.height - 40.0), (_viewNextSetContentView.frame.size.width - _lblNextSetCountLabel.frame.size.width - 9.0), 40.0)];
            UIFont *fontNextSetLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
            [_lblNextSetLabel setFont: fontNextSetLabel];
            
            [_viewExerciseAndTotalTimeBackgroundView setFrame: CGRectMake(0.0, (_viewSetAndRestBackgroundView.frame.origin.y + _viewSetAndRestBackgroundView.frame.size.height + 36.0), (_contentViewSetAndRestScreen.frame.size.width), 80.0)];
            [_viewExerciseContentView setFrame: CGRectMake(18.0, 0.0, (_viewExerciseAndTotalTimeBackgroundView.frame.size.width - 54.0) / 2.0, 80)];
            [_lblExerciseCountLabel setFrame: CGRectMake(0.0, 8.0, (_viewExerciseContentView.frame.size.width), 50.0)];
            UIFont *fontExerciseCount = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 30.0];
            [_lblExerciseCountLabel setFont: fontExerciseCount];
            [_lblExerciseLabel setFrame: CGRectMake(0.0, (_lblExerciseCountLabel.frame.origin.y + _lblExerciseCountLabel.frame.size.height - 12.0), (_viewExerciseContentView.frame.size.width), 30.0)];
            UIFont *fontExerciseLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.1];
            [_lblExerciseLabel setFont: fontExerciseLabel];
            [_viewTotalTimeContentView setFrame: CGRectMake((_viewExerciseContentView.frame.origin.x + _viewExerciseContentView.frame.size.width + 18.0), 0.0, (_viewExerciseAndTotalTimeBackgroundView.frame.size.width - 54.0) / 2.0, 80.0)];
            [[_viewExerciseContentView layer] setCornerRadius: 30.0];
            [[_viewTotalTimeContentView layer] setCornerRadius: 30.0];
            
            [_viewHoursTimeContentView setFrame: CGRectMake(0.0, 8.0, (_viewTotalTimeContentView.frame.size.width), 50.0)];
            CGFloat colonWidth = 12.0;
            CGFloat timeHoursWidth = ((_viewHoursTimeContentView.frame.size.width - (2 * colonWidth)) / 3.0) - 4.0;
            [_lblHoursFirstLabel setFrame: CGRectMake(6.0, 0.0, timeHoursWidth, 50.0)];
            [_lblColonFirstLabel setFrame: CGRectMake((_lblHoursFirstLabel.frame.origin.x + _lblHoursFirstLabel.frame.size.width), 0.0, colonWidth, 50.0)];
            [_lblMinFirstLabel setFrame: CGRectMake((_lblColonFirstLabel.frame.origin.x + _lblColonFirstLabel.frame.size.width), 0.0, timeHoursWidth, 50.0)];
            [_lblColonSecondLabel setFrame: CGRectMake((_lblMinFirstLabel.frame.origin.x + _lblMinFirstLabel.frame.size.width), 0.0, colonWidth, 50.0)];
            [_lblSecondsFirstLabel setFrame: CGRectMake((_lblColonSecondLabel.frame.origin.x + _lblColonSecondLabel.frame.size.width), 0.0, timeHoursWidth, 50.0)];
            UIFont *fontHoursTimeCount = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 28.0];
            
            [_viewMinTimeContentView setFrame: CGRectMake(0.0, 8.0, (_viewTotalTimeContentView.frame.size.width), 40.0)];
            CGFloat timeMinutesWidth = (_viewHoursTimeContentView.frame.size.width - colonWidth) / 2.0;
            [_lblMinSecondLabel setFrame: CGRectMake(0.0, 0.0, timeMinutesWidth, 50.0)];
            [_lblColonThirdLabel setFrame: CGRectMake((_lblMinSecondLabel.frame.origin.x + _lblMinSecondLabel.frame.size.width), 0.0, colonWidth, 50.0)];
            [_lblSecondsSecondLabel setFrame: CGRectMake((_lblColonThirdLabel.frame.origin.x + _lblColonThirdLabel.frame.size.width), 0.0, timeMinutesWidth, 50.0)];
            
            [_lblHoursFirstLabel setFont: fontHoursTimeCount];
            [_lblColonFirstLabel setFont: fontHoursTimeCount];
            [_lblMinFirstLabel setFont: fontHoursTimeCount];
            [_lblColonSecondLabel setFont: fontHoursTimeCount];
            [_lblSecondsFirstLabel setFont: fontHoursTimeCount];
            [_lblMinSecondLabel setFont: fontExerciseCount];
            [_lblColonThirdLabel setFont: fontExerciseCount];
            [_lblSecondsSecondLabel setFont: fontExerciseCount];
            
            [_lblTotalTimeLabel setFrame: CGRectMake(0.0, (_viewHoursTimeContentView.frame.origin.y + _viewHoursTimeContentView.frame.size.height - 12.0), (_viewTotalTimeContentView.frame.size.width), 30.0)];
            [_lblTotalTimeLabel setFont: fontExerciseLabel];
            
            [_viewHoursTimeContentView setHidden: YES];
            [_viewMinTimeContentView setHidden: NO];
            
            [_btnStartRestButton setFrame: CGRectMake(0.0, 0.0, (_scrollViewSetAndRestScreen.frame.size.width), (_viewExerciseAndTotalTimeBackgroundView.frame.origin.y + _viewExerciseAndTotalTimeBackgroundView.frame.size.height))];
            
            [_btnSwipeButton setFrame: CGRectMake((_contentViewSetAndRestScreen.frame.size.width - 52.0) / 2.0, (_viewExerciseAndTotalTimeBackgroundView.frame.origin.y + _viewExerciseAndTotalTimeBackgroundView.frame.size.height + 14.0), 52.0, 20.0)];
            [self.btnMenu setFrame:CGRectMake((_contentViewSetAndRestScreen.frame.size.width - 52.0) / 2.0, (_btnSwipeButton.frame.origin.y + _btnSwipeButton.frame.size.height + 1.0), 52.0, 17.0)];
            
            //Bottom buttons view
            [_viewBottomButtonsBackgroundView setFrame: CGRectMake(0.0, (_btnSwipeButton.frame.origin.y + _btnSwipeButton.frame.size.height + 58.0),(_contentViewSetAndRestScreen.frame.size.width), 270.0)];
            
            [_viewUpperButtonsBackgroundView setFrame: CGRectMake(0.0, 0.0, (_viewBottomButtonsBackgroundView.frame.size.width), ((_viewBottomButtonsBackgroundView.frame.size.height - 32.0) / 2.0))];
            [_viewNextExerciseButtonContentView setFrame: CGRectMake(0.0, 0.0, (_viewUpperButtonsBackgroundView.frame.size.width / 2.0), _viewUpperButtonsBackgroundView.frame.size.height)];
            [_imgNextExerciseImage setFrame: CGRectMake(67.0, 0.0, 80.0, 80.0)];
            [_lblNextExerciseLabel setFrame: CGRectMake(57.0, (_imgNextExerciseImage.frame.origin.y + _imgNextExerciseImage.frame.size.height + 13.0), (_viewNextExerciseButtonContentView.frame.size.width - 57.0), 20.0)];
            UIFont *fontButtonsTitle = [UIFont fontWithName: fFUTURA_MEDIUM size: 16.0];
            [_lblNextExerciseLabel setFont: fontButtonsTitle];
            
            [_viewChangeRestButtonContentView setFrame: CGRectMake(_viewNextExerciseButtonContentView.frame.size.width, 0.0, (_viewUpperButtonsBackgroundView.frame.size.width / 2.0), _viewUpperButtonsBackgroundView.frame.size.height)];
            [_viewChangeRestView setFrame: CGRectMake((_viewChangeRestButtonContentView.frame.size.width - 80.0 - 66.0), 0.0, 80.0, 80.0)];
            [_lblChangeRestCountLabel setFrame: CGRectMake(0.0, (_viewChangeRestView.frame.size.height - 30.0) / 2.0, (_viewChangeRestView.frame.size.width), 30.0)];
            UIFont *fontChangeRestCount = [UIFont fontWithName: fFUTURA_MEDIUM size: 20.0];
            [_lblChangeRestCountLabel setFont: fontChangeRestCount];
            [_lblChangeRestLabel setFrame: CGRectMake(38.0, (_viewChangeRestView.frame.origin.y + _viewChangeRestView.frame.size.height + 13.0), (_viewChangeRestButtonContentView.frame.size.width - 38.0), 20.0)];
            [_lblChangeRestLabel setFont: fontButtonsTitle];
            
            [_viewLowerButtonsBackgroundView setFrame: CGRectMake(0.0, (_viewUpperButtonsBackgroundView.frame.size.height + 40.0), (_viewBottomButtonsBackgroundView.frame.size.width), ((_viewBottomButtonsBackgroundView.frame.size.height - 32.0) / 2.0))];
            [_viewSoundButtonContentView setFrame: CGRectMake(0.0, 0.0, (_viewLowerButtonsBackgroundView.frame.size.width / 2.0), _viewLowerButtonsBackgroundView.frame.size.height)];
            [_imgSoundImage setFrame: CGRectMake(67.0, 0.0, 80.0, 80.0)];
            [_lblSoundLabel setFrame: CGRectMake(70.0, (_imgSoundImage.frame.origin.y + _imgSoundImage.frame.size.height + 13.0), (_viewSoundButtonContentView.frame.size.width - 70.0), 20.0)];
            [_lblSoundLabel setFont: fontButtonsTitle];
            
            [_viewEndWorkoutButtonContentView setFrame: CGRectMake(_viewSoundButtonContentView.frame.size.width, 0.0, (_viewLowerButtonsBackgroundView.frame.size.width / 2.0), _viewLowerButtonsBackgroundView.frame.size.height)];
            [_imgEndWorkoutImage setFrame: CGRectMake((_viewEndWorkoutButtonContentView.frame.size.width - 80.0 - 66.0), 0.0, 80.0, 80.0)];
            [_lblEndWorkoutLabel setFrame: CGRectMake(36.0, (_imgEndWorkoutImage.frame.origin.y + _imgEndWorkoutImage.frame.size.height + 13.0), (_viewEndWorkoutButtonContentView.frame.size.width - 36.0), 20.0)];
            [_lblEndWorkoutLabel setFont: fontButtonsTitle];
            
            
            /*--------------------------------------------------------------------------------*/
            
            //Scroll and content view
            [_scrollViewWorkoutCompleteScreen setFrame: CGRectMake(DEVICE_WIDTH, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
            [_scrollViewWorkoutCompleteScreen setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT)];
            [_contentViewWorkoutCompleteScreen setFrame: CGRectMake(0.0, 0.0, (_scrollViewWorkoutCompleteScreen.contentSize.width), (_scrollViewWorkoutCompleteScreen.contentSize.height))];
            
            //Gym Timer label
            [_lblGymTimerWorkoutScreenTitleLabel setFrame: CGRectMake(0.0, 36.0, (_contentViewSetAndRestScreen.frame.size.width), 40.0)];
            UIFont *fontGymTimerWorkoutScreenLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
            [_lblGymTimerWorkoutScreenTitleLabel setFont: fontGymTimerWorkoutScreenLabel];
            // [_lblGymTimerWorkoutScreenTitleLabel setHidden: YES];
            
            //Workout Stats background view
            // Vsn - 10/04/2020
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
            UIFont *font = [UIFont fontWithName:fFUTURA_MEDIUM_ITALIC size:13.0];
            NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, [UIColor colorWithRed:0.0/255.0 green:220.0/255.0 blue:93.0/255.0 alpha:1], NSForegroundColorAttributeName, nil];
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@"Congratulations" attributes:attrsDictionary]];
            NSDictionary *attrsDict1 = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@" for working out today !" attributes:attrsDict1]];
            _lblCongratulationsText.attributedText = attrString;
            [_lblCongratulationsText updateConstraints];
            
            [_viewPowerPopupInfomation setFrame: CGRectMake(40.0, 0.0, (_lblCongratulationsText.frame.size.width + 24.0), (_lblCongratulationsText.frame.size.height + 14.0))];
            _viewPowerPopupInfomation.layer.cornerRadius = _viewPowerPopupInfomation.frame.size.height / 2;
            [_lblCongratulationsText setFrame: CGRectMake(12.0, 7.0, _lblCongratulationsText.frame.size.width, _lblCongratulationsText.frame.size.height)];
            [_imgPowerPopupInfomationBg setFrame: CGRectMake(-16.0, -11.0, _viewPowerPopupInfomation.frame.size.width + 32.0, _viewPowerPopupInfomation.frame.size.height + 26.0)];
            // End

            
            // Vsn - 10/04/2020
            CGFloat workoutStatsBgViewY = (_lblGymTimerWorkoutScreenTitleLabel.frame.origin.y + _lblGymTimerWorkoutScreenTitleLabel.frame.size.height);
            [_viewWorkoutStatsBackgroundView setFrame: CGRectMake(18.0, workoutStatsBgViewY + 60.0, (_contentViewWorkoutCompleteScreen.frame.size.width - 36.0), 414.0)];
            [_viewPowerPopup setFrame: CGRectMake(23.0, _viewWorkoutStatsBackgroundView.frame.origin.y + 15 - 70 - 100, (_contentViewWorkoutCompleteScreen.frame.size.width - 49.0), 70.0)];
            // End
            [[_viewWorkoutStatsBackgroundView layer] setCornerRadius: 30.0];
            
            //Stats content view
            CGFloat statsContentViewY = (_viewWorkoutStatsBackgroundView.frame.size.height - _viewWorkoutStatsBackgroundView.frame.size.width + 9.0);
            CGFloat statsContentWidth = _viewWorkoutStatsBackgroundView.frame.size.width;
            [_viewWorkoutStatsContentView setFrame: CGRectMake(0.0, statsContentViewY, setAndRestBgWidth, statsContentWidth - 9.0)];
            // Vsn - 10/04/2020
            //        [_viewWorkoutStatsContentView setFrame: CGRectMake(0.0, 130, setAndRestBgWidth, 284)];
            [_viewWorkoutStatsContentView setFrame: CGRectMake(0.0, 0.0, setAndRestBgWidth, 230)];
            [_vwRandomWorkoutCompleteBackground setFrame: CGRectMake(0.0, _viewWorkoutStatsContentView.frame.size.height + _viewWorkoutStatsContentView.frame.origin.y + 20.0, setAndRestBgWidth, 190)];
            [[_vwRandomWorkoutCompleteBackground layer] setCornerRadius: 30.0];
            // End
            [[_viewWorkoutStatsContentView layer] setCornerRadius: 30.0];
            
            //Do set number view and Rest time view
            CGFloat workoutCompleteViewHeight = 130;
            [_viewWorkoutCompleteContentVIew setFrame: CGRectMake(0.0, 0.0, statsContentWidth, workoutCompleteViewHeight)];
            [_lblWorkoutCompleteLabel setFrame: CGRectMake(31.0, (workoutCompleteViewHeight - 120.0), (statsContentWidth - 100.0), 120.0)];
            UIFont *fontWorkoutCompleteLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 45.0];
            [_lblWorkoutCompleteLabel setFont: fontWorkoutCompleteLabel];
            
            [_lblCurrentDateLabel setFrame: CGRectMake(0.0, 5.0, (_viewWorkoutStatsContentView.frame.size.width), 70.0)];
            UIFont *currentDateLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 24.0];
            [_lblCurrentDateLabel setFont: currentDateLabel];
            // Vsn - 10/04/2020
            [_lblRandomWorkoutCompleteTitle setFrame: _lblCurrentDateLabel.frame];
            [_lblRandomWorkoutCompleteTitle setFont:currentDateLabel];
            // End
            
            // New Design
            [self.vwDateTime setFrame:CGRectMake(0, 0, setAndRestBgWidth, 65)];
            [self.vwCompetedBottom setFrame:CGRectMake(0, 45, setAndRestBgWidth, 164)];
            // Vsn - 10/04/2020
            [_vwRandomWorkoutCompleteTitle setFrame:CGRectMake(0, 0, setAndRestBgWidth, 65)];
            [_vwRandomWorkoutCompleteSubTitle setFrame:CGRectMake(0, 65, setAndRestBgWidth, _vwRandomWorkoutCompleteBackground.frame.size.height - 65)];
            [_lblRandomWorkoutCompleteSubTitle setFrame:CGRectMake(20.0, 20.0, setAndRestBgWidth - 40, _vwRandomWorkoutCompleteSubTitle.frame.size.height - 40)];
            
            if ([[Utils getIsPaidUser] isEqualToString: @"YES"]) {
                [_vwRandomWorkoutCompletePro setHidden: true];
                [self callGetExerciseHistoryAPI];
            } else {
                [_lblRandomWorkoutCompleteSubTitle setAttributedText: [self getWorkoutCompleteLastPopupText]];

                [_vwRandomWorkoutCompletePro setHidden: false];
                
                [_vwRandomWorkoutCompletePro setFrame: CGRectMake(_vwRandomWorkoutCompleteSubTitle.frame.origin.x + 25.0, _vwRandomWorkoutCompleteSubTitle.frame.origin.y - 15.0, _vwRandomWorkoutCompleteSubTitle.frame.size.width - 50.0, 30.0)];
                [[_vwRandomWorkoutCompletePro layer] setCornerRadius: 10.0];
                [[_vwRandomWorkoutCompletePro layer] setMasksToBounds: NO];
                [[_vwRandomWorkoutCompletePro layer] setShadowColor: [[UIColor blackColor] CGColor]];
                [[_vwRandomWorkoutCompletePro layer] setShadowOffset: CGSizeMake(1.0, 1.0)];
                [[_vwRandomWorkoutCompletePro layer] setShadowRadius: 10.0];
                [[_vwRandomWorkoutCompletePro layer] setShadowOpacity: 0.5];
                UIBezierPath *workoutViewShadowPathPro = [UIBezierPath bezierPathWithRect: [_vwRandomWorkoutCompletePro bounds]];
                [[_vwRandomWorkoutCompletePro layer] setShadowPath: [workoutViewShadowPathPro CGPath]];
                
                [_lblRandomWorkoutCompleteProText setFrame: CGRectMake(0.0, (_vwRandomWorkoutCompletePro.frame.size.height / 2) - 12.5, _vwRandomWorkoutCompletePro.frame.size.width, 25.0)];
                
                NSTextAttachment *attachment1 = [[NSTextAttachment alloc] init];
                attachment1.image = [UIImage imageNamed:@"lockgreen"];
                NSMutableAttributedString *attrString = [NSAttributedString attributedStringWithAttachment:attachment1].mutableCopy;
                UIFont *font = [UIFont fontWithName:fFUTURA_MEDIUM size:12.0];
                
                NSDictionary *attrsGreen = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, [UIColor colorWithRed:0.0/255.0 green:220.0/255.0 blue:93.0/255.0 alpha:1], NSForegroundColorAttributeName, nil];
                NSDictionary *attrsBackground = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:fFUTURA_BOLD size:14.0], NSFontAttributeName, [UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:56.0/255.0 alpha:1], NSForegroundColorAttributeName, [UIColor greenColor], NSBackgroundColorAttributeName, nil];

                [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@"  These are exclusive for the " attributes:attrsGreen]];
                [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@"PRO" attributes:attrsBackground]];
                [attrString appendAttributedString: [[NSAttributedString alloc] initWithString:@" community" attributes:attrsGreen]];
                
                [_lblRandomWorkoutCompleteProText setAttributedText: attrString];
            }
            // End
            [self.vwQuality setFrame:CGRectMake(0, 0, setAndRestBgWidth / 2, 214)];
            [self.vwTime setFrame:CGRectMake(setAndRestBgWidth / 2, 0, setAndRestBgWidth / 2, 214)];
            
            [self.lblTotalTimeTitle setFrame:CGRectMake(16, 30, self.vwTime.frame.size.width - 16, 20)];
            
            [self.lblTotalExercisetitle setFrame:CGRectMake(16, 107, self.vwTime.frame.size.width - 16, 20)];
            [self.lblTotalExercise setFrame:CGRectMake(16, 134, self.vwTime.frame.size.width - 16, 41)];
            
            [self.lblQuality setFrame:CGRectMake(48, 30, 50, 20)];
            [self.vwQualityProgress setFrame:CGRectMake(38, 65, 118, 118)];
            
            self.vwQualityProgress.valueFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
            self.vwQualityProgress.valueFontSize = 32;
            self.vwQualityProgress.fontColor = cNEW_GREEN;
            self.vwQualityProgress.unitFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
            self.vwQualityProgress.unitFontSize = 18;
            
            //Total workout time views
            [_lblTotalWorkoutTimeLabel setHidden: YES];
            [_lblTotalWorkoutExercisesLabel setHidden: YES];
            
            [_viewHoursTimeFormatContentView setFrame: CGRectMake(37.0, (_lblCurrentDateLabel.frame.origin.y + _lblCurrentDateLabel.frame.size.height + 24.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
            [[_viewHoursTimeFormatContentView layer] setCornerRadius: 15.0];
            
            CGFloat timeCountLabelWidth = ([_viewHoursTimeFormatContentView frame].size.width / 6.0);
            CGFloat timeTitlelabelWidth = ([_viewHoursTimeFormatContentView frame].size.width / 6.0);
            
            //Hours min sec format
            [_lblFirstHoursCountLabel setFrame: CGRectMake(19.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
            [_lblFirstHoursTitleLabel setFrame: CGRectMake((_lblFirstHoursCountLabel.frame.origin.x + _lblFirstHoursCountLabel.frame.size.width) - 0.0, 8.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
            [_lblFirstMinCountLabel setFrame: CGRectMake((_lblFirstHoursTitleLabel.frame.origin.x + _lblFirstHoursTitleLabel.frame.size.width) - 26.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
            [_lblFirstMinTitleLabel setFrame: CGRectMake((_lblFirstMinCountLabel.frame.origin.x + _lblFirstMinCountLabel.frame.size.width) - 0.5, 8.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
            [_lblFirstSecCountLabel setFrame: CGRectMake((_lblFirstMinTitleLabel.frame.origin.x + _lblFirstMinTitleLabel.frame.size.width) - 6.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
            [_lblFirstSecTitleLabel setFrame: CGRectMake((_lblFirstSecCountLabel.frame.origin.x + _lblFirstSecCountLabel.frame.size.width) - 0.0, 8.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
            
            //Min sec format
            [_viewMinTimeFormatContentView setFrame: CGRectMake(37.0, (_lblCurrentDateLabel.frame.origin.y + _lblCurrentDateLabel.frame.size.height + 24.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
            [[_viewMinTimeFormatContentView layer] setCornerRadius: 15.0];
            [_lblSecondMinCountLabel setFrame: CGRectMake(44.0, 0.0, (timeCountLabelWidth + 8.0), (_viewMinTimeFormatContentView.frame.size.height))];
            [_lblSecondMinTitleLabel setFrame: CGRectMake((_lblSecondMinCountLabel.frame.origin.x + _lblSecondMinCountLabel.frame.size.width) - 0.0, 12.0, timeTitlelabelWidth, (_viewMinTimeFormatContentView.frame.size.height - 12.0))];
            [_lblSecondSecCountLabel setFrame: CGRectMake((_lblSecondMinTitleLabel.frame.origin.x + _lblSecondMinTitleLabel.frame.size.width) - 4.0, 0.0, (timeCountLabelWidth + 8.0), (_viewMinTimeFormatContentView.frame.size.height))];
            [_lblSecondSecTitleLabel setFrame: CGRectMake((_lblSecondSecCountLabel.frame.origin.x + _lblSecondSecCountLabel.frame.size.width) - 0.0, 12.0, timeTitlelabelWidth, (_viewMinTimeFormatContentView.frame.size.height - 12.0))];
            
            //Total exercise view
            [_viewTotalExerciseContentView setFrame: CGRectMake(37.0, (_viewHoursTimeFormatContentView.frame.origin.y + _viewHoursTimeFormatContentView.frame.size.height + 18.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
            [[_viewTotalExerciseContentView layer] setCornerRadius: 15.0];
            [_lblTotalExerciseCountLabel setFrame: CGRectMake(45.0, 0.0, (timeCountLabelWidth + 8.0), (_viewTotalExerciseContentView.frame.size.height - 1.0))];
            [_lblExerciseTitleLabel setFrame: CGRectMake((_lblTotalExerciseCountLabel.frame.origin.x + _lblTotalExerciseCountLabel.frame.size.width), 11.0, (_viewTotalExerciseContentView.frame.size.width - (_lblTotalExerciseCountLabel.frame.origin.x + _lblTotalExerciseCountLabel.frame.size.width)), (_viewTotalExerciseContentView.frame.size.height - 11.0))];
            
            lblCounting = [[UICountingLabel alloc] initWithFrame: CGRectMake(60.0, (_viewTotalExerciseContentView.frame.origin.y + _viewTotalExerciseContentView.frame.size.height + 12.0), 100.0, 40.0)];
            [_viewWorkoutStatsContentView addSubview: lblCounting];
            
            [self.lblShortWorkoutMsg setFrame:CGRectMake(20, self.viewWorkoutStatsBackgroundView.frame.origin.y + self.viewWorkoutStatsBackgroundView.frame.size.height + 8, self.viewWorkoutStatsBackgroundView.frame.size.width, 32)];
            
            // Vsn - 10/04/2020
//            [self.btnDoneWorkoutButton setFrame:CGRectMake(self.view.frame.size.width / 2 + 40, self.viewWorkoutStatsBackgroundView.frame.origin.y + self.viewWorkoutStatsBackgroundView.frame.size.height + 58, 80, 80)];
//            [self.btnShareStatsButton setFrame:CGRectMake(self.view.frame.size.width / 2 - 120, self.viewWorkoutStatsBackgroundView.frame.origin.y + self.viewWorkoutStatsBackgroundView.frame.size.height + 58, 80, 80)];
            [self.btnDoneWorkoutButton setFrame:CGRectMake(self.view.frame.size.width / 2 + 40, self.viewWorkoutStatsBackgroundView.frame.origin.y + self.vwRandomWorkoutCompleteBackground.frame.origin.y + self.vwRandomWorkoutCompleteBackground.frame.size.height + 10, 70, 70)];
            [self.btnShareStatsButton setFrame:CGRectMake(self.view.frame.size.width / 2 - 120, self.viewWorkoutStatsBackgroundView.frame.origin.y + self.vwRandomWorkoutCompleteBackground.frame.origin.y + self.vwRandomWorkoutCompleteBackground.frame.size.height + 10, 70, 70)];
            // End
        }
    } else {
        {
            //Loader view
            [_viewLoaderBackgroundView setFrame: CGRectMake(0.0, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
            [_lblLoaderGymTimerLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
            UIFont *fontGymTimerLoaderLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
            [_lblLoaderGymTimerLabel setFont: fontGymTimerLoaderLabel];
            [_viewLoaderContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
            
            //Scroll and Content view
            [_scrollViewWorkoutScreen setFrame: CGRectMake(0.0, 10.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
            [_contentViewWorkoutScreen setFrame: CGRectMake(0.0, 5.0, (_scrollViewWorkoutScreen.frame.size.width), (_scrollViewWorkoutScreen.frame.size.height + 80-10))];
            CGFloat contentViewWidth = _contentViewWorkoutScreen.frame.size.width;
            CGFloat contentViewHeight = _contentViewWorkoutScreen.frame.size.height;
            
            //GymTimer label
            [_lblGymTimerTitleLabel setFrame: CGRectMake(0.0, -17.0, (_contentViewWorkoutScreen.frame.size.width), 103.0)];
            UIFont *fontGymTimer = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 50.0];
            [_lblGymTimerTitleLabel setFont: fontGymTimer];
            
            // Vsn - 11/02/2020
            [_lblBoostYourWorkoutsSetScreenLabel setFrame: CGRectMake((_contentViewWorkoutScreen.frame.size.width / 2.0) - 134, 21.5, (_contentViewWorkoutScreen.frame.size.width), 80.0)];
//            [_lblBoostYourWorkoutsSetScreenLabel setFrame: CGRectMake((_contentViewWorkoutScreen.frame.size.width / 2.0) - 115.1, 32.0, (_contentViewWorkoutScreen.frame.size.width), 80.0)];
//            [lblBoostYourWorkoutText addAttribute:NSKernAttributeName value:@2 range:NSMakeRange(0, lblBoostYourWorkoutText.length)];
//            [_lblBoostYourWorkoutsSetScreenLabel setAttributedText: lblBoostYourWorkoutText];
            UIFont *fontGymTimer1 = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 17.0];
            [_lblBoostYourWorkoutsSetScreenLabel setFont: fontGymTimer1];
            
            
            //Start Workout content view
            CGFloat gymtimerY = _lblGymTimerTitleLabel.frame.origin.y;
            CGFloat gymtimerHeight = _lblGymTimerTitleLabel.frame.size.height;
            CGFloat tabbarHeight = 53.0;
            //        CGFloat tabbarHeight = [[[self tabBarController] tabBar] frame].size.height;
            [_viewWorkoutContentView setFrame: CGRectMake(18.0, (_lblGymTimerTitleLabel.frame.origin.y + _lblGymTimerTitleLabel.frame.size.height), (contentViewWidth - 36.0), (contentViewHeight - (gymtimerY + gymtimerHeight + tabbarHeight + 60.0)))];
            // Vsn - 19/02/2020
            [_viewWorkoutContentViewSubView setFrame: CGRectMake(0.0, 0.0, _viewWorkoutContentView.frame.size.width, _viewWorkoutContentView.frame.size.height)];
            // Vsn - 25/02/2020
            [_vwImgWelcomeBack setFrame: CGRectMake(0.0, 0.0, _viewWorkoutContentView.frame.size.width, _viewWorkoutContentView.frame.size.height)];
            [_vwWorkoutContentParent setFrame:CGRectMake(0.0, 0.0, _viewWorkoutContentView.frame.size.width, _viewWorkoutContentView.frame.size.height)];
            [_imgHomeBottomGym setFrame: CGRectMake(-21.0, -19.0, _viewWorkoutContentView.frame.size.width + 42.0, _viewWorkoutContentView.frame.size.height + 45.0)];
            
            //Choose default rest time label
            CGFloat workoutContentViewWidth = _viewWorkoutContentView.frame.size.width;
            UIFont *fontMinSec = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
            [_lblChooseDefaultTimeLabel setFrame: CGRectMake(0.0, 52.0, (workoutContentViewWidth), 42.0)];
            [_lblChooseDefaultTimeLabel setFont: fontMinSec];
            [_lblChooseDefaultTimeLabel setAlpha: 0.5];
            
            // Vsn - 10/02/2020
            //Rest time picker view
            [_pickerWorkoutRestTimePickerView setFrame: CGRectMake(32.0, (_lblChooseDefaultTimeLabel.frame.origin.y + _lblChooseDefaultTimeLabel.frame.size.height - 0.0), (workoutContentViewWidth - 64.0), 200.0)];
//            [_pickerWorkoutRestTimePickerView setFrame: CGRectMake(32.0, (_lblChooseDefaultTimeLabel.frame.origin.y + _lblChooseDefaultTimeLabel.frame.size.height - 0.0), (workoutContentViewWidth - 64.0), 210.0)];
            
            //Minute and seconds view
            [_viewMinutesSecondsContentView setFrame: CGRectMake(0.0, (_lblChooseDefaultTimeLabel.frame.origin.y + _lblChooseDefaultTimeLabel.frame.size.height + 90.0), workoutContentViewWidth, 22.0)];
            [_lblMinuteLabel setFrame: CGRectMake(106.0, 0.0, 30.0, 21.0)];
            [_lblSecondsLabel setFrame: CGRectMake(209.0, 0.0, 15.0, 21.0)];
            [_lblMinuteLabel setFont: fontMinSec];
            [_lblSecondsLabel setFont: fontMinSec];
            
            {//Dinal5-done
                
                UIFont *newBtnFont = [UIFont fontWithName: fFUTURA_BOLD size: 10.0];
                [_btnEndurance.titleLabel setFont:newBtnFont];
                [_btnMuscle.titleLabel setFont:newBtnFont];
                [_btnpower.titleLabel setFont:newBtnFont];
                
                UIFont *newGreenFont = [UIFont fontWithName: fFUTURA_MEDIUM size: 10.0];
                [_lblRange1 setFont:newGreenFont];
                [_lblRange2 setFont:newGreenFont];
                [_lblRange11 setFont:newGreenFont];
                [_lblRange22 setFont:newGreenFont];
                
                UIFont *newSetRepsFont = [UIFont fontWithName: fFUTURA_MEDIUM size: 11.0];
                [_lblSets setFont:newSetRepsFont];
                [_lblReps setFont:newSetRepsFont];
                [_lblRecommend setFont:newSetRepsFont];
                
                UIFont *newScientificFont = [UIFont fontWithName: fFUTURA_MEDIUM size: 9.5];
                [_lblScientific setFont:newScientificFont];
                
                CGFloat widthParent = _viewTabParent.frame.size.width;
                
                CGRect frameRecommend = _lblRecommend.frame;
                frameRecommend.size.width = widthParent * 0.4210;
                frameRecommend.origin.x += 6.0;
                [_lblRecommend setFrame:frameRecommend];
                
                CGRect frameRange1 = _lblRange1.frame;
                //            frameRange1.size.width = widthParent * 0.0964;
                frameRange1.origin.x = frameRecommend.origin.x + frameRecommend.size.width - 9.0;
                [_lblRange1 setFrame:frameRange1];
                
                CGRect minus1 = _lblMinus1.frame;
                //            minus1.size.width = widthParent * 0.0964;
                minus1.origin.x = _lblRange1.frame.origin.x + _lblRange1.frame.size.width - 3.0;
                [_lblMinus1 setFrame:minus1];
                
                CGRect frameRange11 = _lblRange11.frame;
                //            frameRange11.size.width = widthParent * 0.0964;
                frameRange11.origin.x = _lblMinus1.frame.origin.x + _lblMinus1.frame.size.width - 4.0;
                [_lblRange11 setFrame:frameRange11];
                
                CGRect frameSets = _lblSets.frame;
                frameSets.size.width = widthParent * 0.1096;
                frameSets.origin.x = frameRange11.origin.x + frameRange11.size.width;
                [_lblSets setFrame:frameSets];
                
                CGRect frameSeprator1 = _lblSeparator1.frame;
                frameSeprator1.size.width = 1.0;
                frameSeprator1.origin.x = frameSets.origin.x + frameSets.size.width - 1.0;
                [_lblSeparator1 setFrame:frameSeprator1];
                
                CGRect frameRange2 = _lblRange2.frame;
                //            frameRange2.size.width = widthParent * 0.0964;
                frameRange2.origin.x = frameSeprator1.origin.x + frameSeprator1.size.width + 4.0;
                // Vsn - 09/04/2020
                frameRange2.size.width = frameRange2.size.width + 7.0;
                // End
                [_lblRange2 setFrame:frameRange2];
                
                CGRect minus2 = _lblMinus2.frame;
                //minus2.size.width = widthParent * 0.0964;
                minus2.origin.x = _lblRange2.frame.origin.x + _lblRange2.frame.size.width - 3.0;
                [_lblMinus2 setFrame:minus2];
                
                CGRect frameRange22 = _lblRange22.frame;
                //            frameRange22.size.width = widthParent * 0.0964;
                frameRange22.origin.x = _lblMinus2.frame.origin.x + _lblMinus2.frame.size.width - 4.0;
                [_lblRange22 setFrame:frameRange22];
                
                CGRect frameReps = _lblReps.frame;
                frameReps.size.width = widthParent * 0.1228;
                frameReps.origin.x = frameRange22.origin.x + frameRange22.size.width + 2.0;
                [_lblReps setFrame:frameReps];
                
                CGRect frameSeprator2 = _lblSeparator2.frame;
                frameSeprator2.size.width = 1.0;
                frameSeprator2.origin.x = frameReps.origin.x + frameReps.size.width - 1.0;
                [_lblSeparator2 setFrame:frameSeprator2];
                
                CGRect frameDumbell = _imgDumbell.frame;
                frameDumbell.size.width = widthParent * 0.1140;
                frameDumbell.size.height = widthParent * 0.1140;
                frameDumbell.origin.x = frameSeprator2.origin.x + frameSeprator2.size.width + 7.0;
                frameDumbell.origin.y += 1.5;
                [_imgDumbell setFrame:frameDumbell];
                
                
                CGRect frameParent = _viewTabParent.frame;
                frameParent.origin.x = 10.0;
                frameParent.size.width = _viewTabMain.frame.size.width - 20.0;
                [_viewTabParent setFrame:frameParent];
                
                CGRect frameSci = _lblScientific.frame;
                frameSci.origin.x -= 8.0;
                [_lblScientific setFrame:frameSci];
                
                CGRect frameArrow = _btnArrowScientifically.frame;
                frameArrow.origin.x = _lblScientific.frame.size.width - 5.0;
                [_btnArrowScientifically setFrame:frameArrow];
            }
            
            // Vsn - 10/02/2020
            //Start workout button
            [_btnStartWorkoutButton setFrame: CGRectMake(45.0, (_pickerWorkoutRestTimePickerView.frame.size.height + _pickerWorkoutRestTimePickerView.frame.origin.y - 5.0)+5, (workoutContentViewWidth - 70.0)-20, 50.0-5)];
//            [_btnStartWorkoutButton setFrame: CGRectMake(35.0, (_viewWorkoutContentView.frame.size.height - 105.0), (workoutContentViewWidth - 70.0), 50.0)];
            
            [_btnStartWorkoutButton setBackgroundColor: UIColorFromRGB(0x14CC64)];
            UIFont *fontStartButton = [UIFont fontWithName: fFUTURA_BOLD size: 20.0];
            dicStartButtonAttributes = [[NSDictionary alloc] init];
            dicStartButtonAttributes = @{ NSForegroundColorAttributeName : UIColorFromRGB(0x009938),
                                          NSFontAttributeName : fontStartButton
            };
            NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"Start Workout" attributes: dicStartButtonAttributes];
            [_btnStartWorkoutButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
            [[_btnStartWorkoutButton layer] setCornerRadius: _btnStartWorkoutButton.frame.size.height / 3.5]; //17.0
            
            /*--------------------------------------------------------------------------------*/
            
            //Scroll and content view
            [_scrollViewSetAndRestScreen setFrame: CGRectMake(DEVICE_WIDTH, -44.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
            //        [_scrollViewSetAndRestScreen setFrame: CGRectMake(DEVICE_WIDTH, 44.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
            [_scrollViewSetAndRestScreen setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + 420.0)];
            [_contentViewSetAndRestScreen setFrame: CGRectMake(0.0, 0.0, (_scrollViewSetAndRestScreen.frame.size.width), (_scrollViewSetAndRestScreen.contentSize.height + 104.0))];
            
            //Gym Timer label
            [_lblGymTimerSetScreenLabel setFrame: CGRectMake(0.0, 36.0, (_contentViewSetAndRestScreen.frame.size.width), 40.0)];
            UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
            [_lblGymTimerSetScreenLabel setFont: fontGymTimerLabel];
            
            //Set and rest background view
            CGFloat setAndRestBgViewY = (_lblGymTimerSetScreenLabel.frame.origin.y + _lblGymTimerSetScreenLabel.frame.size.height + 32.0);
            [_viewSetAndRestBackgroundView setFrame: CGRectMake(18.0, setAndRestBgViewY, (_contentViewSetAndRestScreen.frame.size.width - 36.0), 402.0)];
            [[_viewSetAndRestBackgroundView layer] setCornerRadius: 30.0];
            
            //Progress bar background view
            CGFloat setAndRestProgressBarBgViewY = (_viewSetAndRestBackgroundView.frame.size.height - _viewSetAndRestBackgroundView.frame.size.width + 10.0);
            CGFloat setAndRestBgWidth = _viewSetAndRestBackgroundView.frame.size.width;
            [_viewSetAndRestScreenProgressBackgroundView setFrame: CGRectMake(0.0, setAndRestProgressBarBgViewY, setAndRestBgWidth, setAndRestBgWidth - 9.0)];
            [[_viewSetAndRestScreenProgressBackgroundView layer] setCornerRadius: 30.0];
            
            // Warm up view
            [self.vwWarmUp setFrame: CGRectMake(0.0, setAndRestProgressBarBgViewY, setAndRestBgWidth, setAndRestBgWidth - 9.0)];
            
            //Do set number view and Rest time view
            [_viewDoSetNumberContentView setHidden: YES];
            [_viewRestTimeContentView setHidden: NO];
            CGFloat doSetNumberViewHeight = (_viewSetAndRestBackgroundView.frame.size.height - _viewSetAndRestScreenProgressBackgroundView.frame.size.height);
            [_viewDoSetNumberContentView setFrame: CGRectMake(0.0, 0.0, setAndRestBgWidth, doSetNumberViewHeight)];
            
            [_lblDoSetNumberCountLabel setFrame: CGRectMake((setAndRestBgWidth - 121.0), 56.0, 121.0, (doSetNumberViewHeight - 6.0))];
            UIFont *fontDoSetCount = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 50.0];
            [_lblDoSetNumberCountLabel setFont: fontDoSetCount];
            [self adjustFontOfDoSetCountLabel];
            
            NSString *strCurrentSetCount = [[NSUserDefaults standardUserDefaults] valueForKey: kSET_COUNT];
            if (strCurrentSetCount.length == 1) {
                [_lblDoSetNumberLabel setFrame: CGRectMake(30.0, 25, (setAndRestBgWidth - _lblDoSetNumberCountLabel.frame.size.width - 15.0), 123.0)];
                UIFont *fontDoSetLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0];
                [_lblDoSetNumberLabel setFont: fontDoSetLabel];
            } else {
                [_lblDoSetNumberLabel setFrame: CGRectMake(0.0, 30, (setAndRestBgWidth - _lblDoSetNumberCountLabel.frame.size.width - 15.0), 123.0)];
                UIFont *fontDoSetLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0];
                [_lblDoSetNumberLabel setFont: fontDoSetLabel];
            }
            
            [_viewRestTimeContentView setFrame: CGRectMake(0.0, 0.0, setAndRestBgWidth, doSetNumberViewHeight)];
            CGFloat restTimerColonWidth = 40.0;
            CGFloat restTimerMinSecWidth = (setAndRestBgWidth - restTimerColonWidth) / 2.0;
            [_lblRestTimerMinutesLabel setFrame: CGRectMake(0.0, 0.0, restTimerMinSecWidth, doSetNumberViewHeight)];
            [_lblRestTimerColonLabel setFrame: CGRectMake((_lblRestTimerMinutesLabel.frame.size.width), 0.0, restTimerColonWidth, doSetNumberViewHeight)];
            [_lblRestTimerSecondsLabel setFrame: CGRectMake((_lblRestTimerColonLabel.frame.origin.x + _lblRestTimerColonLabel.frame.size.width), 0.0, restTimerMinSecWidth, doSetNumberViewHeight)];
            
            [self.vwLastExercise setFrame:CGRectMake(0.0, 0.0, setAndRestBgWidth, doSetNumberViewHeight)];
            [self.lblTimeSinceTitle setFrame:CGRectMake(20.0, 20.0, self.vwLastExercise.frame.size.width - 40.0, 29.0)];
            [self.lblTimeSince setFrame:CGRectMake(20.0, (self.lblTimeSinceTitle.frame.origin.y + self.lblTimeSinceTitle.frame.size.height) - 8 , self.vwLastExercise.frame.size.width - 40.0, 116.0)];
            
            //[_lblRestTimeLabel setFrame: CGRectMake(0.0, 15.0, setAndRestBgWidth, (doSetNumberViewHeight - 15.0))];
            UIFont *fontRestTimeLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 90.0];
            [_lblRestTimerMinutesLabel setFont: fontRestTimeLabel];
            [_lblRestTimerColonLabel setFont: fontRestTimeLabel];
            [_lblRestTimerSecondsLabel setFont: fontRestTimeLabel];
            
            //View last exercise
            CGFloat viewProgressBarHeight = _viewSetAndRestScreenProgressBackgroundView.frame.size.height;
            CGFloat viewProgressBarWidth = _viewSetAndRestScreenProgressBackgroundView.frame.size.width;
            
            [_viewLastExerciseTimeContentView setFrame: CGRectMake(22.0, 12.0, viewProgressBarWidth, 80.0)];
            [_lblSinceLastExerciseLabel setFrame: CGRectMake(0.0, 0.0, (_viewLastExerciseTimeContentView.frame.size.width), 30.0)];
            UIFont *fontSinceLastExerciseLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
            [_lblSinceLastExerciseLabel setFont: fontSinceLastExerciseLabel];
            
            CGFloat lastExerciseColonWidth = 12.0;
            CGFloat hoursFormatCountWidth = 40.0;
            
            //Hours format
            [_viewLastExerciseHoursFormat setFrame: CGRectMake(-16.0, 14.0, (_viewLastExerciseTimeContentView.frame.size.width), (_viewLastExerciseTimeContentView.frame.size.height - (_lblSinceLastExerciseLabel.frame.origin.y + _lblSinceLastExerciseLabel.frame.size.height)))];
            
            UIFont *fontLastExerciseHourFormat = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 20.0];
            [_lblLastExerciseFirstHourLabel setFrame: CGRectMake(0.0, 0.0, hoursFormatCountWidth, (_viewLastExerciseHoursFormat.frame.size.height))];
            [_lblLastExerciseHourFirstColonLabel setFrame: CGRectMake((_lblLastExerciseFirstHourLabel.frame.origin.x + _lblLastExerciseFirstHourLabel.frame.size.width), 0.0, (lastExerciseColonWidth - 4.0), (_viewLastExerciseHoursFormat.frame.size.height))];
            [_lblLastExerciseFirstMinLabel setFrame: CGRectMake((_lblLastExerciseHourFirstColonLabel.frame.origin.x + _lblLastExerciseHourFirstColonLabel.frame.size.width) - 5.0, 0.0, hoursFormatCountWidth, (_viewLastExerciseHoursFormat.frame.size.height))];
            [_lblLastExerciseHourSecondColonLabel setFrame: CGRectMake((_lblLastExerciseFirstMinLabel.frame.origin.x + _lblLastExerciseFirstMinLabel.frame.size.width) - 5.0, 0.0, (lastExerciseColonWidth - 4.0), (_viewLastExerciseHoursFormat.frame.size.height))];
            [_lblLastExerciseFirstSecLabel setFrame: CGRectMake((_lblLastExerciseHourSecondColonLabel.frame.origin.x + _lblLastExerciseHourSecondColonLabel.frame.size.width), 0.0, hoursFormatCountWidth, (_viewLastExerciseHoursFormat.frame.size.height))];
            [_lblLastExerciseFirstHourLabel setFont: fontLastExerciseHourFormat];
            [_lblLastExerciseHourFirstColonLabel setFont: fontLastExerciseHourFormat];
            [_lblLastExerciseFirstMinLabel setFont: fontLastExerciseHourFormat];
            [_lblLastExerciseHourSecondColonLabel setFont: fontLastExerciseHourFormat];
            [_lblLastExerciseFirstSecLabel setFont: fontLastExerciseHourFormat];
            
            //Minutes format
            CGFloat minuteFormatCountWidth = 40.0;
            UIFont *fontLastExerciseMinuteFormat = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 24.5];
            
            [_viewLastExerciseMinuteFormat setFrame: CGRectMake(-10.0, 18.0, (_viewLastExerciseTimeContentView.frame.size.width), (_viewLastExerciseTimeContentView.frame.size.height - (_lblSinceLastExerciseLabel.frame.origin.y + _lblSinceLastExerciseLabel.frame.size.height)))];
            
            [_lblLastExerciseSecondMinLabel setFrame: CGRectMake(0.0, 0.0, minuteFormatCountWidth, (_viewLastExerciseMinuteFormat.frame.size.height))];
            [_lblLastExerciseSecondColonLabel setFrame: CGRectMake((_lblLastExerciseSecondMinLabel.frame.origin.x + _lblLastExerciseSecondMinLabel.frame.size.width), 0.0, lastExerciseColonWidth, (_viewLastExerciseMinuteFormat.frame.size.height))];
            [_lblLastExerciseSecondSecLabel setFrame: CGRectMake((_lblLastExerciseSecondColonLabel.frame.origin.x + _lblLastExerciseSecondColonLabel.frame.size.width), 0.0, minuteFormatCountWidth, (_viewLastExerciseMinuteFormat.frame.size.height))];
            [_lblLastExerciseSecondMinLabel setFont: fontLastExerciseMinuteFormat];
            [_lblLastExerciseSecondColonLabel setFont: fontLastExerciseMinuteFormat];
            [_lblLastExerciseSecondSecLabel setFont: fontLastExerciseMinuteFormat];
            
            
            //Progress bar view and dumbells image
            [self setupProgressBar];
            [_progressBarSetScreenView setFrame: CGRectMake(47.5, 47.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
            [_progressBarRestScreenView setFrame: CGRectMake(47.5, 47.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
            [_progressBarRestBackgroungView setFrame: CGRectMake(47.5, 47.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
            [_vwRestScreenDumbellsBackgroundImage setFrame: CGRectMake(47.5, 47.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
            CGFloat progressBarHeight = _progressBarSetScreenView.frame.size.height;
            CGFloat progressBarWidth = _progressBarSetScreenView.frame.size.width;
            
            // Vsn - 05/02/2020
            CGFloat greenDumbellsImageWidth = 82.0;
            CGFloat greenDumbellsImageHeight = 110.0;
            CGFloat redDumbellsImageWidth = 130.0;
            CGFloat redDumbellsImageHeight = 122.0;

            [self.imgRestScreenDumbellsImage setFrame: CGRectMake(((progressBarWidth - redDumbellsImageWidth) / 2.0) + 0.5, ((progressBarHeight - redDumbellsImageHeight) / 2.0) + 15.0, redDumbellsImageWidth, redDumbellsImageHeight)];
            [self.imgRestScreenDumbellsBackgroundImage setFrame: self.imgRestScreenDumbellsImage.frame];
            
//            CGFloat greenDumbellsImageWidth = 62.0;
//            CGFloat greenDumbellsImageHeight = 90.0;
//            CGFloat redDumbellsImageWidth = 42.0;
//            CGFloat redDumbellsImageHeight = 110.0;
//
//            [_imgRestScreenDumbellsImage setFrame: CGRectMake(((progressBarWidth - redDumbellsImageWidth) / 2.0) + 4.0, ((progressBarHeight - redDumbellsImageHeight) / 2.0) + 10.0, redDumbellsImageWidth, redDumbellsImageHeight)];
            [_imgRestScreenDumbellsImage setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
            
            // Set Character
            [self.imgSetScreenDumbellsImage setFrame:CGRectMake(47.5, 20, greenDumbellsImageWidth, greenDumbellsImageHeight)];
            
            // Vsn - 05/02/2020
            self.imgSetScreenDumbellsImage.center = CGPointMake(self.viewSetAndRestScreenProgressBackgroundView.bounds.size.width  / 2, 123.0);
            
//            self.imgSetScreenDumbellsImage.center = CGPointMake(self.viewSetAndRestScreenProgressBackgroundView.bounds.size.width  / 2, 140.0);

            // Next Exercise Progress Ring
            [self.vwNextExercise setFrame: CGRectMake(47.5, 47.5, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
            [self.vwNextExerciseRing setFrame:CGRectMake(0, 0, (viewProgressBarWidth - 95.0), (viewProgressBarHeight - 95.0))];
            [self.imgNextExercise setFrame:CGRectMake(0.0, 0.0, 90, 140)];
            self.imgNextExercise.center = CGPointMake(self.vwNextExercise.frame.size.width  / 2, self.vwNextExercise.frame.size.height / 2);
            
            //Click anywhere and Next set view
            [_viewClickAnywhereContentView setFrame: CGRectMake(0.0, (viewProgressBarHeight - 59.0), viewProgressBarWidth, 59.0)];
            [_lblClickAnywhereToRestLabel setFrame: CGRectMake(1.0, 0.0, (_viewClickAnywhereContentView.frame.size.width - 1.0), (_viewClickAnywhereContentView.frame.size.height))];
            UIFont *fontClickAnywhereLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
            [_lblClickAnywhereToRestLabel setFont: fontClickAnywhereLabel];
            
            // Vsn - 05/02/2020
            [_viewNextSetContentView setFrame: CGRectMake(0.0, 0.0, viewProgressBarWidth, 120.0)];
//            [_viewNextSetContentView setFrame: CGRectMake(0.0, (viewProgressBarHeight - 60.0), viewProgressBarWidth, 60.0)];
            [_lblNextSetCountLabel setFrame: CGRectMake((_viewNextSetContentView.frame.size.width - 82.0), 15.0, 83.0, 90.0)];
//            [_lblNextSetCountLabel setFrame: CGRectMake((_viewNextSetContentView.frame.size.width - 60.0), 0.0, 60.0, 60.0)];
            UIFont *fontNextSetCountLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 58.0];
//            UIFont *fontNextSetCountLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0];
            [_lblNextSetCountLabel setFont: fontNextSetCountLabel];
            [[_lblNextSetCountLabel layer] setCornerRadius: 30.0];
            [_lblNextSetLabel setFrame: CGRectMake(0.0, 0.0, (_viewNextSetContentView.frame.size.width - 25.0), 40.0)];
//            [_lblNextSetLabel setFrame: CGRectMake(0.0, (_viewNextSetContentView.frame.size.height - 40.0), (_viewNextSetContentView.frame.size.width - _lblNextSetCountLabel.frame.size.width - 9.0), 40.0)];
            UIFont *fontNextSetLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
            [_lblNextSetLabel setFont: fontNextSetLabel];
            
            [_viewExerciseAndTotalTimeBackgroundView setFrame: CGRectMake(0.0, (_viewSetAndRestBackgroundView.frame.origin.y + _viewSetAndRestBackgroundView.frame.size.height + 25.0), (_contentViewSetAndRestScreen.frame.size.width), 100.0)];
            [_viewExerciseContentView setFrame: CGRectMake(18.0, 0.0, (_viewExerciseAndTotalTimeBackgroundView.frame.size.width - 54.0) / 2.0, 100.0)];
            [_lblExerciseCountLabel setFrame: CGRectMake(0.0, 15.0, (_viewExerciseContentView.frame.size.width), 50.0)];
            UIFont *fontExerciseCount = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0];
            [_lblExerciseCountLabel setFont: fontExerciseCount];
            [_lblExerciseLabel setFrame: CGRectMake(0.0, (_lblExerciseCountLabel.frame.origin.y + _lblExerciseCountLabel.frame.size.height - 7.0), (_viewExerciseContentView.frame.size.width), 30.0)];
            UIFont *fontExerciseLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.1];
            [_lblExerciseLabel setFont: fontExerciseLabel];
            [_viewTotalTimeContentView setFrame: CGRectMake((_viewExerciseContentView.frame.origin.x + _viewExerciseContentView.frame.size.width + 18.0), 0.0, (_viewExerciseAndTotalTimeBackgroundView.frame.size.width - 54.0) / 2.0, 100.0)];
            [[_viewExerciseContentView layer] setCornerRadius: 30.0];
            [[_viewTotalTimeContentView layer] setCornerRadius: 30.0];
            
            [_viewHoursTimeContentView setFrame: CGRectMake(0.0, 0.0, (_viewTotalTimeContentView.frame.size.width), 65.0)];
            CGFloat colonWidth = 12.0;
            CGFloat timeHoursWidth = ((_viewHoursTimeContentView.frame.size.width - (2 * colonWidth)) / 3.0) - 4.0;
            [_lblHoursFirstLabel setFrame: CGRectMake(6.0, 15.0, timeHoursWidth, 50.0)];
            [_lblColonFirstLabel setFrame: CGRectMake((_lblHoursFirstLabel.frame.origin.x + _lblHoursFirstLabel.frame.size.width), 15.0, colonWidth, 50.0)];
            [_lblMinFirstLabel setFrame: CGRectMake((_lblColonFirstLabel.frame.origin.x + _lblColonFirstLabel.frame.size.width), 15.0, timeHoursWidth, 50.0)];
            [_lblColonSecondLabel setFrame: CGRectMake((_lblMinFirstLabel.frame.origin.x + _lblMinFirstLabel.frame.size.width), 15.0, colonWidth, 50.0)];
            [_lblSecondsFirstLabel setFrame: CGRectMake((_lblColonSecondLabel.frame.origin.x + _lblColonSecondLabel.frame.size.width), 15.0, timeHoursWidth, 50.0)];
            UIFont *fontHoursTimeCount = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 28.0];
            
            [_viewMinTimeContentView setFrame: CGRectMake(0.0, 0.0, (_viewTotalTimeContentView.frame.size.width), 65.0)];
            CGFloat timeMinutesWidth = (_viewHoursTimeContentView.frame.size.width - colonWidth) / 2.0;
            [_lblMinSecondLabel setFrame: CGRectMake(0.0, 15.0, timeMinutesWidth, 50.0)];
            [_lblColonThirdLabel setFrame: CGRectMake((_lblMinSecondLabel.frame.origin.x + _lblMinSecondLabel.frame.size.width), 15.0, colonWidth, 50.0)];
            [_lblSecondsSecondLabel setFrame: CGRectMake((_lblColonThirdLabel.frame.origin.x + _lblColonThirdLabel.frame.size.width), 15.0, timeMinutesWidth, 50.0)];
            
            [_lblHoursFirstLabel setFont: fontHoursTimeCount];
            [_lblColonFirstLabel setFont: fontHoursTimeCount];
            [_lblMinFirstLabel setFont: fontHoursTimeCount];
            [_lblColonSecondLabel setFont: fontHoursTimeCount];
            [_lblSecondsFirstLabel setFont: fontHoursTimeCount];
            [_lblMinSecondLabel setFont: fontExerciseCount];
            [_lblColonThirdLabel setFont: fontExerciseCount];
            [_lblSecondsSecondLabel setFont: fontExerciseCount];
            
            [_lblTotalTimeLabel setFrame: CGRectMake(0.0, (_viewHoursTimeContentView.frame.origin.y + _viewHoursTimeContentView.frame.size.height - 7.0), (_viewTotalTimeContentView.frame.size.width), 30.0)];
            [_lblTotalTimeLabel setFont: fontExerciseLabel];
            
            [_viewHoursTimeContentView setHidden: YES];
            [_viewMinTimeContentView setHidden: NO];
            
            [_btnStartRestButton setFrame: CGRectMake(0.0, 0.0, (_scrollViewSetAndRestScreen.frame.size.width), (_viewExerciseAndTotalTimeBackgroundView.frame.origin.y + _viewExerciseAndTotalTimeBackgroundView.frame.size.height))];
            
            [_btnSwipeButton setFrame: CGRectMake((_contentViewSetAndRestScreen.frame.size.width - 52.0) / 2.0, (_viewExerciseAndTotalTimeBackgroundView.frame.origin.y + _viewExerciseAndTotalTimeBackgroundView.frame.size.height + 24.0), 52.0, 20.0)];
            [self.btnMenu setFrame:CGRectMake((_contentViewSetAndRestScreen.frame.size.width - 52.0) / 2.0, (_btnSwipeButton.frame.origin.y + _btnSwipeButton.frame.size.height + 1.0), 52.0, 17.0)];
            
            //Bottom buttons view
            [_viewBottomButtonsBackgroundView setFrame: CGRectMake(0.0, (_btnSwipeButton.frame.origin.y + _btnSwipeButton.frame.size.height + 58.0),(_contentViewSetAndRestScreen.frame.size.width), 270.0)];
            
            [_viewUpperButtonsBackgroundView setFrame: CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, ((_viewBottomButtonsBackgroundView.frame.size.height - 32.0) / 2.0))];
            [_viewNextExerciseButtonContentView setFrame: CGRectMake(0.0, 0.0, (_viewUpperButtonsBackgroundView.frame.size.width / 2.0), _viewUpperButtonsBackgroundView.frame.size.height)];
            [_imgNextExerciseImage setFrame: CGRectMake(43, 0.0, 80.0, 80.0)];
            [_lblNextExerciseLabel setFrame: CGRectMake(0, (_imgNextExerciseImage.frame.origin.y + _imgNextExerciseImage.frame.size.height + 13.0), (_viewNextExerciseButtonContentView.frame.size.width), 20.0)];
            UIFont *fontButtonsTitle = [UIFont fontWithName: fFUTURA_MEDIUM size: 16.0];
            _lblNextExerciseLabel.textAlignment = NSTextAlignmentCenter;
            [_lblNextExerciseLabel setFont: fontButtonsTitle];
            
            [_viewChangeRestButtonContentView setFrame: CGRectMake(_viewNextExerciseButtonContentView.frame.size.width, 0.0, (_viewUpperButtonsBackgroundView.frame.size.width / 2.0), _viewUpperButtonsBackgroundView.frame.size.height)];
            [_viewChangeRestView setFrame: CGRectMake(43, 0.0, 80.0, 80.0)];
            [_lblChangeRestCountLabel setFrame: CGRectMake(0.0, (_viewChangeRestView.frame.size.height - 30.0) / 2.0, (_viewChangeRestView.frame.size.width), 30.0)];
            UIFont *fontChangeRestCount = [UIFont fontWithName: fFUTURA_MEDIUM size: 20.0];
            [_lblChangeRestCountLabel setFont: fontChangeRestCount];
            [_lblChangeRestLabel setFrame: CGRectMake(38.0, (_viewChangeRestView.frame.origin.y + _viewChangeRestView.frame.size.height + 13.0), (_viewChangeRestButtonContentView.frame.size.width - 38.0), 20.0)];
            [_lblChangeRestLabel setFont: fontButtonsTitle];
            
            [_viewLowerButtonsBackgroundView setFrame: CGRectMake(0.0, (_viewUpperButtonsBackgroundView.frame.size.height + 40.0), (_viewBottomButtonsBackgroundView.frame.size.width), ((_viewBottomButtonsBackgroundView.frame.size.height - 32.0) / 2.0))];
            [_viewSoundButtonContentView setFrame: CGRectMake(0.0, 0.0, (_viewLowerButtonsBackgroundView.frame.size.width / 2.0), _viewLowerButtonsBackgroundView.frame.size.height)];
            [_imgSoundImage setFrame: CGRectMake(43.0, 0.0, 80.0, 80.0)];
            [_lblSoundLabel setFrame: CGRectMake(0.0, (_imgSoundImage.frame.origin.y + _imgSoundImage.frame.size.height + 13.0), _viewSoundButtonContentView.frame.size.width, 20.0)];
            [_lblSoundLabel setFont: fontButtonsTitle];
            _lblSoundLabel.textAlignment = NSTextAlignmentCenter;
            
            [_viewEndWorkoutButtonContentView setFrame: CGRectMake(_viewSoundButtonContentView.frame.size.width, 0.0, (_viewLowerButtonsBackgroundView.frame.size.width / 2.0), _viewLowerButtonsBackgroundView.frame.size.height)];
            [_imgEndWorkoutImage setFrame: CGRectMake(43, 0.0, 80.0, 80.0)];
            [_lblEndWorkoutLabel setFrame: CGRectMake(0, (_imgEndWorkoutImage.frame.origin.y + _imgEndWorkoutImage.frame.size.height + 13.0), _viewEndWorkoutButtonContentView.frame.size.width, 20.0)];
            [_lblEndWorkoutLabel setFont: fontButtonsTitle];
            _lblEndWorkoutLabel.textAlignment = NSTextAlignmentCenter;
            
            /*--------------------------------------------------------------------------------*/
            
            //Scroll and content view
            [_scrollViewWorkoutCompleteScreen setFrame: CGRectMake(DEVICE_WIDTH, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
            [_scrollViewWorkoutCompleteScreen setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT)];
            [_contentViewWorkoutCompleteScreen setFrame: CGRectMake(0.0, 0.0, (_scrollViewWorkoutCompleteScreen.contentSize.width), (_scrollViewWorkoutCompleteScreen.contentSize.height))];
            
            //Gym Timer label
            [_lblGymTimerWorkoutScreenTitleLabel setFrame: CGRectMake(0.0, 36.0, (_contentViewSetAndRestScreen.frame.size.width), 40.0)];
            UIFont *fontGymTimerWorkoutScreenLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
            [_lblGymTimerWorkoutScreenTitleLabel setFont: fontGymTimerWorkoutScreenLabel];
            // [_lblGymTimerWorkoutScreenTitleLabel setHidden: YES];
            
            //Workout Stats background view
            CGFloat workoutStatsBgViewY = (_lblGymTimerWorkoutScreenTitleLabel.frame.size.height + 4);
            [_viewWorkoutStatsBackgroundView setFrame: CGRectMake(18.0, workoutStatsBgViewY, (_contentViewWorkoutCompleteScreen.frame.size.width - 36.0), 377.0)];
            [[_viewWorkoutStatsBackgroundView layer] setCornerRadius: 30.0];
            
            //Stats content view
            CGFloat statsContentWidth = _viewWorkoutStatsBackgroundView.frame.size.width;
            [_viewWorkoutStatsContentView setFrame: CGRectMake(0.0, 110, setAndRestBgWidth, statsContentWidth - 9.0)];
            [[_viewWorkoutStatsContentView layer] setCornerRadius: 30.0];
            
            //Do set number view and Rest time view
            CGFloat workoutCompleteViewHeight = 130;
            [_viewWorkoutCompleteContentVIew setFrame: CGRectMake(0.0, 0.0, statsContentWidth, workoutCompleteViewHeight)];
            [_lblWorkoutCompleteLabel setFrame: CGRectMake(31.0, (workoutCompleteViewHeight - 120.0), (statsContentWidth - 100.0), 120.0)];
            UIFont *fontWorkoutCompleteLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 35.0];
            [_lblWorkoutCompleteLabel setFont: fontWorkoutCompleteLabel];
            
            [_lblCurrentDateLabel setFrame: CGRectMake(0.0, 0.0, (_viewWorkoutStatsContentView.frame.size.width), 70.0)];
            UIFont *currentDateLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 21.0];
            [_lblCurrentDateLabel setFont: currentDateLabel];
            // Vsn - 10/04/2020
        [_lblRandomWorkoutCompleteTitle setFrame: _lblCurrentDateLabel.frame];
        [_lblRandomWorkoutCompleteTitle setFont:currentDateLabel];
        // End
            
            // New Design
            [self.vwDateTime setFrame:CGRectMake(0, 0, setAndRestBgWidth, 70)];
            [self.vwCompetedBottom setFrame:CGRectMake(0, 70, setAndRestBgWidth, 214)];
            [self.vwQuality setFrame:CGRectMake(0, 0, setAndRestBgWidth / 2, 214)];
            [self.vwTime setFrame:CGRectMake(setAndRestBgWidth / 2, 0, setAndRestBgWidth / 2, 214)];
            
            [self.lblTotalTimeTitle setFrame:CGRectMake(16, 30, self.vwTime.frame.size.width - 16, 20)];
            
            [self.lblTotalExercisetitle setFrame:CGRectMake(16, 107, self.vwTime.frame.size.width - 16, 20)];
            [self.lblTotalExercise setFrame:CGRectMake(16, 134, self.vwTime.frame.size.width - 16, 41)];
            
            [self.lblQuality setFrame:CGRectMake(48, 30, 50, 20)];
            [self.vwQualityProgress setFrame:CGRectMake(18, 65, 118, 118)];
            
            self.vwQualityProgress.valueFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
            self.vwQualityProgress.valueFontSize = 32;
            self.vwQualityProgress.fontColor = cNEW_GREEN;
            self.vwQualityProgress.unitFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
            self.vwQualityProgress.unitFontSize = 18;
            
            //Total workout time views
            [_lblTotalWorkoutTimeLabel setHidden: YES];
            [_lblTotalWorkoutExercisesLabel setHidden: YES];
            
            [_viewHoursTimeFormatContentView setFrame: CGRectMake(17.0, (_lblCurrentDateLabel.frame.origin.y + _lblCurrentDateLabel.frame.size.height + 15.0), (_viewWorkoutStatsContentView.frame.size.width - 35.0), 70.0)];
            [[_viewHoursTimeFormatContentView layer] setCornerRadius: 15.0];
            
            CGFloat timeCountLabelWidth = ([_viewHoursTimeFormatContentView frame].size.width / 6.0);
            CGFloat timeTitlelabelWidth = ([_viewHoursTimeFormatContentView frame].size.width / 6.0);
            
            //Hours min sec format
            [_lblFirstHoursCountLabel setFrame: CGRectMake(19.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
            [_lblFirstHoursTitleLabel setFrame: CGRectMake((_lblFirstHoursCountLabel.frame.origin.x + _lblFirstHoursCountLabel.frame.size.width) - 0.0, 6.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
            [_lblFirstMinCountLabel setFrame: CGRectMake((_lblFirstHoursTitleLabel.frame.origin.x + _lblFirstHoursTitleLabel.frame.size.width) - 26.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
            [_lblFirstMinTitleLabel setFrame: CGRectMake((_lblFirstMinCountLabel.frame.origin.x + _lblFirstMinCountLabel.frame.size.width) - 0.5, 6.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
            [_lblFirstSecCountLabel setFrame: CGRectMake((_lblFirstMinTitleLabel.frame.origin.x + _lblFirstMinTitleLabel.frame.size.width) - 6.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
            [_lblFirstSecTitleLabel setFrame: CGRectMake((_lblFirstSecCountLabel.frame.origin.x + _lblFirstSecCountLabel.frame.size.width) - 0.0, 6.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
            
            //Min sec format
            [_viewMinTimeFormatContentView setFrame: CGRectMake(17.0, (_lblCurrentDateLabel.frame.origin.y + _lblCurrentDateLabel.frame.size.height + 15.0), (_viewWorkoutStatsContentView.frame.size.width - 35.0), 70.0)];
            [[_viewMinTimeFormatContentView layer] setCornerRadius: 15.0];
            [_lblSecondMinCountLabel setFrame: CGRectMake(44.0, 0.0, (timeCountLabelWidth + 8.0), (_viewMinTimeFormatContentView.frame.size.height))];
            [_lblSecondMinTitleLabel setFrame: CGRectMake((_lblSecondMinCountLabel.frame.origin.x + _lblSecondMinCountLabel.frame.size.width) - 0.0, 12.0, timeTitlelabelWidth, (_viewMinTimeFormatContentView.frame.size.height - 12.0))];
            [_lblSecondSecCountLabel setFrame: CGRectMake((_lblSecondMinTitleLabel.frame.origin.x + _lblSecondMinTitleLabel.frame.size.width) - 4.0, 0.0, (timeCountLabelWidth + 8.0), (_viewMinTimeFormatContentView.frame.size.height))];
            [_lblSecondSecTitleLabel setFrame: CGRectMake((_lblSecondSecCountLabel.frame.origin.x + _lblSecondSecCountLabel.frame.size.width) - 0.0, 12.0, timeTitlelabelWidth, (_viewMinTimeFormatContentView.frame.size.height - 12.0))];
            
            //Total exercise view
            [_viewTotalExerciseContentView setFrame: CGRectMake(17.0, (_viewHoursTimeFormatContentView.frame.origin.y + _viewHoursTimeFormatContentView.frame.size.height) + 15.0, (_viewWorkoutStatsContentView.frame.size.width - 35.0), 70.0)];
            [[_viewTotalExerciseContentView layer] setCornerRadius: 15.0];
            [_lblTotalExerciseCountLabel setFrame: CGRectMake(45.0, 0.0, (timeCountLabelWidth + 8.0), (_viewTotalExerciseContentView.frame.size.height - 1.0))];
            [_lblExerciseTitleLabel setFrame: CGRectMake((_lblTotalExerciseCountLabel.frame.origin.x + _lblTotalExerciseCountLabel.frame.size.width), 11.0, (_viewTotalExerciseContentView.frame.size.width - (_lblTotalExerciseCountLabel.frame.origin.x + _lblTotalExerciseCountLabel.frame.size.width)), (_viewTotalExerciseContentView.frame.size.height - 11.0))];
            
            lblCounting = [[UICountingLabel alloc] initWithFrame: CGRectMake(60.0, (_viewTotalExerciseContentView.frame.origin.y + _viewTotalExerciseContentView.frame.size.height + 12.0), 100.0, 40.0)];
            [_viewWorkoutStatsContentView addSubview: lblCounting];
            
            [self.lblShortWorkoutMsg setFrame:CGRectMake(20, self.viewWorkoutStatsBackgroundView.frame.origin.y + self.viewWorkoutStatsBackgroundView.frame.size.height + 12, self.viewWorkoutStatsBackgroundView.frame.size.width, 32)];
            [self.btnDoneWorkoutButton setFrame:CGRectMake(self.view.frame.size.width / 2 + 20, self.viewWorkoutStatsBackgroundView.frame.origin.y + self.viewWorkoutStatsBackgroundView.frame.size.height + 58, 60, 60)];
            [self.btnShareStatsButton setFrame:CGRectMake(self.view.frame.size.width / 2 - 80, self.viewWorkoutStatsBackgroundView.frame.origin.y + self.viewWorkoutStatsBackgroundView.frame.size.height + 58, 60, 60)];
            
            [self.viewPowerPopup setHidden: true];
            [self.vwRandomWorkoutCompleteBackground setHidden: true];
            [self.lblWorkoutCompleteLabel setHidden: true];
        }
    }
    self.btnShareStatsButton.layer.cornerRadius = self.btnShareStatsButton.frame.size.height / 2;
    self.btnShareStatsButton.clipsToBounds = YES;
    
    [self initializeStartWorkoutScreenData];
    
    [_viewChangeRestView setClipsToBounds: YES];
    [[_viewChangeRestView layer] setCornerRadius: _viewChangeRestView.frame.size.height / 2.0];
    
    UIBezierPath *workoutViewShadowPath = [UIBezierPath bezierPathWithRect: [_viewWorkoutContentView bounds]];
    [[_viewWorkoutContentView layer] setMasksToBounds: NO];
    [[_viewWorkoutContentView layer] setShadowColor: [cGYM_TIMER_LABEL CGColor]];
    [[_viewWorkoutContentView layer] setShadowOffset: CGSizeMake(10.0, 10.0)];
    [[_viewWorkoutContentView layer] setShadowRadius: 30.0];
    [[_viewWorkoutContentView layer] setShadowOpacity: 1.0];
    [[_viewWorkoutContentView layer] setShadowPath: [workoutViewShadowPath CGPath]];
    
    [_btnDoneWorkoutButton setClipsToBounds: YES];
    [[_btnDoneWorkoutButton layer] setCornerRadius: _btnDoneWorkoutButton.frame.size.height / 2.0];
    
    [self toogleSetAndRestScreens];
    
    [self.vwWarmUp addSubview:warmUpView.contentView];
    warmUpView.vwWarmUp.frame = self.viewDoSetNumberContentView.frame;
    [self.viewDoSetNumberContentView addSubview:warmUpView.vwWarmUp];
}

- (void)initializeData {
    
    arrMinutes = @[@"00", @"01", @"02", @"03", @"04", @"05"/*, @"06", @"07", @"08", @"09"*/];
    arrSeconds = @[@"00", @"05", @"10", @"15", @"20", @"25", @"30", @"35", @"40", @"45", @"50", @"55",];
    
    [_pickerWorkoutRestTimePickerView setDelegate: self];
    [_pickerWorkoutRestTimePickerView setDataSource: self];
    
    NSError *err;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    //    [session setCategory: AVAudioSessionCategoryPlayback error: nil];
    [session setCategory: AVAudioSessionCategoryPlayback mode: AVAudioSessionModeDefault options: AVAudioSessionCategoryOptionMixWithOthers error: &err];
    [session setActive: YES error: &err];
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], aBEEP_SOUND];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error: &err];
    //player.numberOfLoops = -1; //Infinite
    [_audioPlayer setDelegate: self];
    [_audioPlayer prepareToPlay];
    
    _audioPlayerSecond = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error: &err];
    [_audioPlayerSecond setDelegate: self];
    [_audioPlayerSecond prepareToPlay];
    
}

- (void) initializeStartWorkoutScreenData {
    
    [self changeButtonTitle];
    
}

- (void) initializeSetScreenData {
    
    [self setupProgressBar];
    
    [_btnStartRestButton setUserInteractionEnabled: YES];
    
    //Initialize set count
    [self adjustFontOfDoSetCountLabel];
    [_lblDoSetNumberCountLabel setText: [[NSUserDefaults standardUserDefaults] valueForKey: kSET_COUNT]];
    
    //Set total exercise count
    [_lblExerciseCountLabel setText: [NSString stringWithFormat: @"%@.", [[NSUserDefaults standardUserDefaults] valueForKey: kTOTAL_EXERCISE_COUNT]]];
    //Set rest time
    [_lblChangeRestCountLabel setText: [[NSUserDefaults standardUserDefaults] valueForKey: kREST_TIME]];
    
}

- (void)initializeRestScreenData {
    
    [self setupProgressBar];
    
    [_btnStartRestButton setUserInteractionEnabled: NO];
    
    [[self.progressBarRestScreenView layer] removeAllAnimations];
    [[_progressBarRestScreenView layer] layoutIfNeeded];
    [_progressBarRestScreenView setNeedsLayout];
    [_progressBarRestScreenView setValue: 0.0];
    
    int nextSetCount = [[[NSUserDefaults standardUserDefaults] valueForKey: kSET_COUNT] intValue];
    [_lblNextSetCountLabel setText: [NSString stringWithFormat: @"%d", (nextSetCount + 1)]];
    [[NSUserDefaults standardUserDefaults] setValue: [NSString stringWithFormat: @"%d", (nextSetCount + 1)] forKey: kSET_COUNT];
    
    NSString *strSelectedRestTime = [[NSUserDefaults standardUserDefaults] valueForKey: kREST_TIME];
    int selectedRestTime = [self convertRestTimeToSecondsFrom: strSelectedRestTime];
    
    if (selectedRestTime > 0) {
        [self toogleSetAndRestScreens];
        [self setupForRestScreenTimer];
    }
    
    // Set workout quality
    if ([NSUserDefaults.standardUserDefaults.dictionaryRepresentation.allKeys containsObject:kQUALITY_SET_COUNT]) {
        int setCount = [[[NSUserDefaults standardUserDefaults] valueForKey:kQUALITY_SET_COUNT] intValue];
        setCount = setCount + 1;
        
        // Store in UserDefault
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d", setCount] forKey:kQUALITY_SET_COUNT];
    }
}

- (void)initializeWorkoutCompleteScreen {
    /*
     So every click on “rest”, or “next exercise” means +1 set
     - set 1-5 : 7% each
     - set 6-10 : 6% each
     - set 11-15 : 4% each
     - set 16-20 : 2% each
     - set 21-26 : 1% each
     - after set 26 = 100% reached
     */
    
    // Set workout quality data
    int setCount = 0;
    int workoutQuality = 0;
    
    if ([NSUserDefaults.standardUserDefaults.dictionaryRepresentation.allKeys containsObject:kQUALITY_SET_COUNT]) {
        setCount = [[[NSUserDefaults standardUserDefaults] valueForKey:kQUALITY_SET_COUNT] intValue];
        NSLog(@"Set Count: %d",setCount);
    }
    
    // Workout quality calculation
    
    for (int i = 1; i <= setCount; i++) {
        if (i >= 1 && i <= 5) {
            workoutQuality = workoutQuality + 7;
            
        } else if (i >= 6 && i <= 10) {
            workoutQuality = workoutQuality + 6;
            
        } else if (i >= 11 && i <= 15) {
            workoutQuality = workoutQuality + 4;
            
        } else if (i >= 16 && i <= 20) {
            workoutQuality = workoutQuality + 2;
            
        } else if (i >= 21 && i <= 26) {
            workoutQuality = workoutQuality + 1;
            
        } else if (i >= 27) {
            workoutQuality = 100;
        }
        
        if (workoutQuality > 100) {
            workoutQuality = 100;
        }
    }
    NSLog(@"Workout Quality: %d",workoutQuality);
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate: [NSDate date]];
    
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSString *strDate = [NSString stringWithFormat: @"%ld. %@ %ld", (long)day, [arrShortMonthsName objectAtIndex: month - 1], (long)year];
    
    NSString *timeString = [[NSUserDefaults standardUserDefaults] valueForKey: kWORKOUT_TIME];
    
    // Vsn - 09/04/2020
//    [_lblCurrentDateLabel setText: [NSString stringWithFormat:@"%@, %@",strDate, timeString]];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"chart"];
    NSMutableAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment].mutableCopy;
    NSAttributedString *myString= [[NSAttributedString alloc] initWithString:@" Workout summary"];
    [attachmentString appendAttributedString: myString];
    [_lblCurrentDateLabel setAttributedText:attachmentString];
//    [_lblCurrentDateLabel setText: @"Workout summary"];
    
    NSTextAttachment *attachment1 = [[NSTextAttachment alloc] init];
    attachment1.image = [UIImage imageNamed:@"bulb"];
    NSMutableAttributedString *attachmentString1 = [NSAttributedString attributedStringWithAttachment:attachment1].mutableCopy;
    NSAttributedString *myString1= [[NSAttributedString alloc] initWithString:@" Post-workout insight"];
    [attachmentString1 appendAttributedString: myString1];
    [_lblRandomWorkoutCompleteTitle setAttributedText:attachmentString1];
    // End
    
    NSString *strTotalTime = [[NSUserDefaults standardUserDefaults] valueForKey: kTOTAL_TIME];
    NSArray *arrTimeComponents = [strTotalTime componentsSeparatedByString: @":"];
    int hours = [arrTimeComponents[0] intValue];
    int minutes = [arrTimeComponents[1] intValue];
    int seconds = [arrTimeComponents[2] intValue];
    currentWorkoutTotalTime = [NSString stringWithFormat: @"%02d:%02d:%02d", hours, minutes, seconds];
    
    // Manage Exercise Label
    [self.lblHours setMinimumScaleFactor:0.5];
    [self.lblMinutes setMinimumScaleFactor:0.5];
    [self.lblSeconds setMinimumScaleFactor:0.5];
    
    if (IS_IPHONEXR) {
        if (hours > 0) {
            [self.lblHours setHidden:NO];
            [self.lblHours setFrame:CGRectMake(16, 54, 50, 41)];
        } else {
            [self.lblHours setHidden:YES];
            [self.lblHours setFrame:CGRectMake(16, 54, 0, 41)];
        }
        
        [self.lblMinutes setFrame:CGRectMake(self.lblHours.frame.origin.x + self.lblHours.frame.size.width, 54, 50, 41)];
        [self.lblSeconds setFrame:CGRectMake(self.lblMinutes.frame.origin.x + self.lblMinutes.frame.size.width, 54, 45, 41)];
    } else if (IS_IPHONEX) {
        if (hours > 0) {
            [self.lblHours setHidden:NO];
            [self.lblHours setFrame:CGRectMake(16, 54, 50, 41)];
        } else {
            [self.lblHours setHidden:YES];
            [self.lblHours setFrame:CGRectMake(16, 54, 0, 41)];
        }
        
        [self.lblMinutes setFrame:CGRectMake(self.lblHours.frame.origin.x + self.lblHours.frame.size.width, 54, 50, 41)];
        [self.lblSeconds setFrame:CGRectMake(self.lblMinutes.frame.origin.x + self.lblMinutes.frame.size.width, 54, 45, 41)];
        
    } else if (IS_IPHONE8PLUS) {
        if (hours > 0) {
            [self.lblHours setHidden:NO];
            [self.lblHours setFrame:CGRectMake(16, 54, 40, 41)];
        } else {
            [self.lblHours setHidden:YES];
            [self.lblHours setFrame:CGRectMake(16, 54, 0, 41)];
        }
        
        [self.lblMinutes setFrame:CGRectMake(self.lblHours.frame.origin.x + self.lblHours.frame.size.width, 54, 50, 41)];
        [self.lblSeconds setFrame:CGRectMake(self.lblMinutes.frame.origin.x + self.lblMinutes.frame.size.width, 54, 45, 41)];
    } else if (IS_IPHONE8) {
        if (hours > 0) {
            [self.lblHours setHidden:NO];
            [self.lblHours setFrame:CGRectMake(16, 54, 40, 41)];
        } else {
            [self.lblHours setHidden:YES];
            [self.lblHours setFrame:CGRectMake(16, 54, 0, 41)];
        }
        
        [self.lblMinutes setFrame:CGRectMake(self.lblHours.frame.origin.x + self.lblHours.frame.size.width, 54, 50, 41)];
        [self.lblSeconds setFrame:CGRectMake(self.lblMinutes.frame.origin.x + self.lblMinutes.frame.size.width, 54, 45, 41)];
    } else {
        UIFont *font = [UIFont fontWithName:fFUTURA_CONDENSED_EXTRA_BOLD size:22];
        [self.lblHours setFont:font];
        [self.lblMinutes setFont:font];
        [self.lblSeconds setFont:font];
        
        if (hours > 0) {
            [self.lblHours setHidden:NO];
            [self.lblHours setFrame:CGRectMake(8, 54, 35, 41)];
        } else {
            [self.lblHours setHidden:YES];
            [self.lblHours setFrame:CGRectMake(8, 54, 0, 41)];
        }
        
        [self.lblMinutes setFrame:CGRectMake(self.lblHours.frame.origin.x + self.lblHours.frame.size.width, 54, 35, 41)];
        [self.lblSeconds setFrame:CGRectMake(self.lblMinutes.frame.origin.x + self.lblMinutes.frame.size.width, 54, 35, 41)];
    }
    
    NSString *strTotalExercise = [[NSUserDefaults standardUserDefaults] valueForKey: kTOTAL_EXERCISE_COUNT];
    int exerciseCount = [strTotalExercise intValue];
    
    if (hours > 0) {
        [_viewHoursTimeFormatContentView setHidden: NO];
        [_viewMinTimeFormatContentView setHidden: YES];
    } else {
        [_viewHoursTimeFormatContentView setHidden: YES];
        [_viewMinTimeFormatContentView setHidden: NO];
    }
    
    [_lblFirstHoursCountLabel setFormat: @"%d"];
    [_lblFirstMinCountLabel setFormat: @"%d"];
    [_lblFirstSecCountLabel setFormat: @"%d"];
    [_lblSecondMinCountLabel setFormat: @"%d"];
    [_lblSecondSecCountLabel setFormat: @"%d"];
    [_lblTotalExerciseCountLabel setFormat: @"%d"];
    
    [_lblTotalExercise setFormat:@"%d"];
    [self.lblHours setFormat:@"%d"];
    [self.lblMinutes setFormat:@"%d"];
    [self.lblSeconds setFormat:@"%d"];
    
    CGFloat animationDuationForHours = 1.0;
    CGFloat animationDuationForMinutes = 1.0;
    CGFloat animationDuationForSeconds = 1.0;
    CGFloat animationDuationForExercise = 1.0;
    
    [_lblFirstHoursCountLabel countFrom: 0 to: hours withDuration: animationDuationForHours];
    [_lblFirstMinCountLabel countFrom: 0 to: minutes withDuration: animationDuationForMinutes];
    [_lblFirstSecCountLabel countFrom: 0 to: seconds withDuration: animationDuationForSeconds];
    [_lblSecondMinCountLabel countFrom: 0 to: minutes withDuration: animationDuationForMinutes];
    [_lblSecondSecCountLabel countFrom: 0 to: seconds withDuration: animationDuationForSeconds];
    [_lblTotalExerciseCountLabel countFrom: 0 to: exerciseCount withDuration: animationDuationForExercise];
    
    //New Implementation
    [self.lblTotalExercise countFrom:0 to:exerciseCount withDuration:animationDuationForExercise];
    [self.lblHours countFrom:0 to:hours withDuration:animationDuationForHours];
    [self.lblMinutes countFrom:0 to:minutes withDuration:animationDuationForMinutes];
    [self.lblSeconds countFrom:0 to:seconds withDuration:animationDuationForSeconds];
    
    if (IS_IPHONEXR) {
        // Exercise Hours
        if (hours > 0) {
            [self.lblHours setHidden:NO];
            [self.lblHours setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
                NSString *strHours = [NSString stringWithFormat:@"%d",hours];
                if (strHours.length > 1) {
                    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d:",hours]];
                } else {
                    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"0%d:",hours]];
                }
            }];
        } else {
            [self.lblHours setHidden:YES];
        }
        
        // Exercise Minutes
        
        [self.lblMinutes setFormatBlock:^NSString *(CGFloat value) {
            NSString *strMinutes = [NSString stringWithFormat:@"%d",minutes];
            if (strMinutes.length > 1) {
                return [NSString stringWithFormat:@"%d:",minutes];
            } else {
                return [NSString stringWithFormat:@"0%d:",minutes];
            }
        }];
        
        // Exercise Seconds
        [self.lblSeconds setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            NSString *strSecond = [NSString stringWithFormat:@"%d",seconds];
            if (strSecond.length > 1) {
                return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",seconds]];
            } else {
                return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"0%d",seconds]];
            }
        }];
        
        
        UIFont *fontDigits = (hours > 0) ? [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0] : [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.2];
        
        //Hours Min Second view
        [_lblFirstHoursCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            
            NSString *strValue = ([[NSString stringWithFormat: @"%d", (int)(value / 1)] length] == 1) ? ([NSString stringWithFormat: @"0%d", (int)(value / 1)]) : ([NSString stringWithFormat: @"%d", (int)(value / 1)]);
            return [[NSAttributedString alloc] initWithString: strValue attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
        }];
        
        NSMutableAttributedString *attHours = [[NSMutableAttributedString alloc] init];
        NSAttributedString *strHour = [[NSAttributedString alloc] initWithString: @"h" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        //NSAttributedString *strSpaceHr = [[NSAttributedString alloc] initWithString: @" " attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 32.0], NSKernAttributeName: @1.0}];
        [attHours appendAttributedString: strHour];
        //[attHours appendAttributedString: strSpaceHr];
        [_lblFirstHoursTitleLabel setAttributedText: attHours];
        
        [_lblFirstMinCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            
            NSString *strValue = ([[NSString stringWithFormat: @"%d", (int)(value / 1)] length] == 1) ? ([NSString stringWithFormat: @"0%d", (int)(value / 1)]) : ([NSString stringWithFormat: @"%d", (int)(value / 1)]);
            return [[NSAttributedString alloc] initWithString: strValue attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
        }];
        
        NSMutableAttributedString *attMinutes = [[NSMutableAttributedString alloc] init];
        NSAttributedString *strMin = [[NSAttributedString alloc] initWithString: @"min" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        NSAttributedString *strSpace = [[NSAttributedString alloc] initWithString: @" " attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 20.0], NSKernAttributeName: @0.1}];
        [attMinutes appendAttributedString: strMin];
        [attMinutes appendAttributedString: strSpace];
        [_lblFirstMinTitleLabel setAttributedText: attMinutes];
        
        [_lblFirstSecCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            NSString *strValue = ([[NSString stringWithFormat: @"%d", (int)(value / 1)] length] == 1) ? ([NSString stringWithFormat: @"0%d", (int)(value / 1)]) : ([NSString stringWithFormat: @"%d", (int)(value / 1)]);
            return [[NSAttributedString alloc] initWithString: strValue attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
        }];
        
        NSAttributedString *strSeconds = [[NSAttributedString alloc] initWithString: @"sec" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        [_lblFirstSecTitleLabel setAttributedText: strSeconds];
        
        //Min second view
        [_lblSecondMinCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            NSString *strValue = ([[NSString stringWithFormat: @"%d", (int)(value / 1)] length] == 1) ? ([NSString stringWithFormat: @"0%d", (int)(value / 1)]) : ([NSString stringWithFormat: @"%d", (int)(value / 1)]);
            return [[NSAttributedString alloc] initWithString: strValue attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
        }];
        
        NSMutableAttributedString *attSecondMinutes = [[NSMutableAttributedString alloc] init];
        NSAttributedString *strSecondMin = [[NSAttributedString alloc] initWithString: @"min" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        NSAttributedString *strSecondSpace = [[NSAttributedString alloc] initWithString: @" " attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 20.0], NSKernAttributeName: @0.1}];
        [attSecondMinutes appendAttributedString: strSecondMin];
        [attSecondMinutes appendAttributedString: strSecondSpace];
        [_lblSecondMinTitleLabel setAttributedText: attSecondMinutes];
        
        [_lblSecondSecCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            NSString *strValue = ([[NSString stringWithFormat: @"%d", (int)(value / 1)] length] == 1) ? ([NSString stringWithFormat: @"0%d", (int)(value / 1)]) : ([NSString stringWithFormat: @"%d", (int)(value / 1)]);
            return [[NSAttributedString alloc] initWithString: strValue attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
        }];
        
        NSAttributedString *strSecondSeconds = [[NSAttributedString alloc] initWithString: @"sec" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        [_lblSecondSecTitleLabel setAttributedText: strSecondSeconds];
        
        //Total exercise
        [_lblTotalExerciseCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            return [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"%d", (int) (value / 1)] attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0]}];
        }];
        
        NSAttributedString *strExercise = [[NSAttributedString alloc] initWithString: @" exercises" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        [_lblExerciseTitleLabel setAttributedText: strExercise];
    } else if (IS_IPHONEX) {
        
        // Exercise Hours
        if (hours > 0) {
            [self.lblHours setHidden:NO];
            [self.lblHours setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
                NSString *strHours = [NSString stringWithFormat:@"%d",hours];
                if (strHours.length > 1) {
                    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d:",hours]];
                } else {
                    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"0%d:",hours]];
                }
            }];
        } else {
            [self.lblHours setHidden:YES];
        }
        
        // Exercise Minutes
        
        [self.lblMinutes setFormatBlock:^NSString *(CGFloat value) {
            NSString *strMinutes = [NSString stringWithFormat:@"%d",minutes];
            if (strMinutes.length > 1) {
                return [NSString stringWithFormat:@"%d:",minutes];
            } else {
                return [NSString stringWithFormat:@"0%d:",minutes];
            }
        }];
        
        // Exercise Seconds
        [self.lblSeconds setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            NSString *strSecond = [NSString stringWithFormat:@"%d",seconds];
            if (strSecond.length > 1) {
                return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",seconds]];
            } else {
                return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"0%d",seconds]];
            }
        }];
        
        UIFont *fontDigits = (hours > 0) ? [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0] : [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.2];
        
        //Hours Min Second view
        [_lblFirstHoursCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            
            NSString *strValue = ([[NSString stringWithFormat: @"%d", (int)(value / 1)] length] == 1) ? ([NSString stringWithFormat: @"0%d", (int)(value / 1)]) : ([NSString stringWithFormat: @"%d", (int)(value / 1)]);
            return [[NSAttributedString alloc] initWithString: strValue attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
        }];
        
        NSMutableAttributedString *attHours = [[NSMutableAttributedString alloc] init];
        NSAttributedString *strHour = [[NSAttributedString alloc] initWithString: @"h" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        //NSAttributedString *strSpaceHr = [[NSAttributedString alloc] initWithString: @" " attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 32.0], NSKernAttributeName: @1.0}];
        [attHours appendAttributedString: strHour];
        //[attHours appendAttributedString: strSpaceHr];
        [_lblFirstHoursTitleLabel setAttributedText: attHours];
        
        [_lblFirstMinCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            
            NSString *strValue = ([[NSString stringWithFormat: @"%d", (int)(value / 1)] length] == 1) ? ([NSString stringWithFormat: @"0%d", (int)(value / 1)]) : ([NSString stringWithFormat: @"%d", (int)(value / 1)]);
            return [[NSAttributedString alloc] initWithString: strValue attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
        }];
        
        NSMutableAttributedString *attMinutes = [[NSMutableAttributedString alloc] init];
        NSAttributedString *strMin = [[NSAttributedString alloc] initWithString: @"min" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        NSAttributedString *strSpace = [[NSAttributedString alloc] initWithString: @" " attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 20.0], NSKernAttributeName: @0.1}];
        [attMinutes appendAttributedString: strMin];
        [attMinutes appendAttributedString: strSpace];
        [_lblFirstMinTitleLabel setAttributedText: attMinutes];
        
        [_lblFirstSecCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            NSString *strValue = ([[NSString stringWithFormat: @"%d", (int)(value / 1)] length] == 1) ? ([NSString stringWithFormat: @"0%d", (int)(value / 1)]) : ([NSString stringWithFormat: @"%d", (int)(value / 1)]);
            return [[NSAttributedString alloc] initWithString: strValue attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
        }];
        
        NSAttributedString *strSeconds = [[NSAttributedString alloc] initWithString: @"sec" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        [_lblFirstSecTitleLabel setAttributedText: strSeconds];
        
        //Min second view
        [_lblSecondMinCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            NSString *strValue = ([[NSString stringWithFormat: @"%d", (int)(value / 1)] length] == 1) ? ([NSString stringWithFormat: @"0%d", (int)(value / 1)]) : ([NSString stringWithFormat: @"%d", (int)(value / 1)]);
            return [[NSAttributedString alloc] initWithString: strValue attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
        }];
        
        NSMutableAttributedString *attSecondMinutes = [[NSMutableAttributedString alloc] init];
        NSAttributedString *strSecondMin = [[NSAttributedString alloc] initWithString: @"min" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        NSAttributedString *strSecondSpace = [[NSAttributedString alloc] initWithString: @" " attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 20.0], NSKernAttributeName: @0.1}];
        [attSecondMinutes appendAttributedString: strSecondMin];
        [attSecondMinutes appendAttributedString: strSecondSpace];
        [_lblSecondMinTitleLabel setAttributedText: attSecondMinutes];
        
        [_lblSecondSecCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            NSString *strValue = ([[NSString stringWithFormat: @"%d", (int)(value / 1)] length] == 1) ? ([NSString stringWithFormat: @"0%d", (int)(value / 1)]) : ([NSString stringWithFormat: @"%d", (int)(value / 1)]);
            return [[NSAttributedString alloc] initWithString: strValue attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
        }];
        
        NSAttributedString *strSecondSeconds = [[NSAttributedString alloc] initWithString: @"sec" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        [_lblSecondSecTitleLabel setAttributedText: strSecondSeconds];
        
        //Total exercise
        [_lblTotalExerciseCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            return [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"%d", (int) (value / 1)] attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0]}];
        }];
        
        NSAttributedString *strExercise = [[NSAttributedString alloc] initWithString: @" exercises" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        [_lblExerciseTitleLabel setAttributedText: strExercise];
        
    } else if (IS_IPHONE8PLUS) {
        // Exercise Hours
        if (hours > 0) {
            [self.lblHours setHidden:NO];
            [self.lblHours setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
                NSString *strHours = [NSString stringWithFormat:@"%d",hours];
                if (strHours.length > 1) {
                    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d:",hours]];
                } else {
                    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"0%d:",hours]];
                }
            }];
        } else {
            [self.lblHours setHidden:YES];
        }
        
        // Exercise Minutes
        
        [self.lblMinutes setFormatBlock:^NSString *(CGFloat value) {
            NSString *strMinutes = [NSString stringWithFormat:@"%d",minutes];
            if (strMinutes.length > 1) {
                return [NSString stringWithFormat:@"%d:",minutes];
            } else {
                return [NSString stringWithFormat:@"0%d:",minutes];
            }
        }];
        
        // Exercise Seconds
        [self.lblSeconds setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            NSString *strSecond = [NSString stringWithFormat:@"%d",seconds];
            if (strSecond.length > 1) {
                return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",seconds]];
            } else {
                return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"0%d",seconds]];
            }
        }];
        
        UIFont *fontDigits = (hours > 0) ? [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0] : [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.2];
        
        //Hours Min Second view
        [_lblFirstHoursCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            
            NSString *strValue = ([[NSString stringWithFormat: @"%d", (int)(value / 1)] length] == 1) ? ([NSString stringWithFormat: @"0%d", (int)(value / 1)]) : ([NSString stringWithFormat: @"%d", (int)(value / 1)]);
            return [[NSAttributedString alloc] initWithString: strValue attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
        }];
        
        NSMutableAttributedString *attHours = [[NSMutableAttributedString alloc] init];
        NSAttributedString *strHour = [[NSAttributedString alloc] initWithString: @"h" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        //NSAttributedString *strSpaceHr = [[NSAttributedString alloc] initWithString: @" " attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 32.0], NSKernAttributeName: @1.0}];
        [attHours appendAttributedString: strHour];
        //[attHours appendAttributedString: strSpaceHr];
        [_lblFirstHoursTitleLabel setAttributedText: attHours];
        
        [_lblFirstMinCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            
            NSString *strValue = ([[NSString stringWithFormat: @"%d", (int)(value / 1)] length] == 1) ? ([NSString stringWithFormat: @"0%d", (int)(value / 1)]) : ([NSString stringWithFormat: @"%d", (int)(value / 1)]);
            return [[NSAttributedString alloc] initWithString: strValue attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
        }];
        
        NSMutableAttributedString *attMinutes = [[NSMutableAttributedString alloc] init];
        NSAttributedString *strMin = [[NSAttributedString alloc] initWithString: @"min" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        NSAttributedString *strSpace = [[NSAttributedString alloc] initWithString: @" " attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 20.0], NSKernAttributeName: @0.1}];
        [attMinutes appendAttributedString: strMin];
        [attMinutes appendAttributedString: strSpace];
        [_lblFirstMinTitleLabel setAttributedText: attMinutes];
        
        [_lblFirstSecCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            NSString *strValue = ([[NSString stringWithFormat: @"%d", (int)(value / 1)] length] == 1) ? ([NSString stringWithFormat: @"0%d", (int)(value / 1)]) : ([NSString stringWithFormat: @"%d", (int)(value / 1)]);
            return [[NSAttributedString alloc] initWithString: strValue attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
        }];
        
        NSAttributedString *strSeconds = [[NSAttributedString alloc] initWithString: @"sec" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        [_lblFirstSecTitleLabel setAttributedText: strSeconds];
        
        //Min second view
        [_lblSecondMinCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            NSString *strValue = ([[NSString stringWithFormat: @"%d", (int)(value / 1)] length] == 1) ? ([NSString stringWithFormat: @"0%d", (int)(value / 1)]) : ([NSString stringWithFormat: @"%d", (int)(value / 1)]);
            return [[NSAttributedString alloc] initWithString: strValue attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
        }];
        
        NSMutableAttributedString *attSecondMinutes = [[NSMutableAttributedString alloc] init];
        NSAttributedString *strSecondMin = [[NSAttributedString alloc] initWithString: @"min" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        NSAttributedString *strSecondSpace = [[NSAttributedString alloc] initWithString: @" " attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 20.0], NSKernAttributeName: @0.1}];
        [attSecondMinutes appendAttributedString: strSecondMin];
        [attSecondMinutes appendAttributedString: strSecondSpace];
        [_lblSecondMinTitleLabel setAttributedText: attSecondMinutes];
        
        [_lblSecondSecCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            NSString *strValue = ([[NSString stringWithFormat: @"%d", (int)(value / 1)] length] == 1) ? ([NSString stringWithFormat: @"0%d", (int)(value / 1)]) : ([NSString stringWithFormat: @"%d", (int)(value / 1)]);
            return [[NSAttributedString alloc] initWithString: strValue attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
        }];
        
        NSAttributedString *strSecondSeconds = [[NSAttributedString alloc] initWithString: @"sec" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        [_lblSecondSecTitleLabel setAttributedText: strSecondSeconds];
        
        //Total exercise
        [_lblTotalExerciseCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            return [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"%d", (int) (value / 1)] attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0]}];
        }];
        
        NSAttributedString *strExercise = [[NSAttributedString alloc] initWithString: @" exercises" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        [_lblExerciseTitleLabel setAttributedText: strExercise];
    } else if (IS_IPHONE8) {
        
        // Exercise Hours
        if (hours > 0) {
            [self.lblHours setHidden:NO];
            [self.lblHours setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
                NSString *strHours = [NSString stringWithFormat:@"%d",hours];
                if (strHours.length > 1) {
                    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d:",hours]];
                } else {
                    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"0%d:",hours]];
                }
            }];
        } else {
            [self.lblHours setHidden:YES];
        }
        
        // Exercise Minutes
        
        [self.lblMinutes setFormatBlock:^NSString *(CGFloat value) {
            NSString *strMinutes = [NSString stringWithFormat:@"%d",minutes];
            if (strMinutes.length > 1) {
                return [NSString stringWithFormat:@"%d:",minutes];
            } else {
                return [NSString stringWithFormat:@"0%d:",minutes];
            }
        }];
        
        // Exercise Seconds
        [self.lblSeconds setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            NSString *strSecond = [NSString stringWithFormat:@"%d",seconds];
            if (strSecond.length > 1) {
                return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",seconds]];
            } else {
                return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"0%d",seconds]];
            }
        }];
        
        UIFont *fontDigits = (hours > 0) ? [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0] : [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.2];
        
        //Hours Min Second view
        [_lblFirstHoursCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            
            NSString *strValue = ([[NSString stringWithFormat: @"%d", (int)(value / 1)] length] == 1) ? ([NSString stringWithFormat: @"0%d", (int)(value / 1)]) : ([NSString stringWithFormat: @"%d", (int)(value / 1)]);
            return [[NSAttributedString alloc] initWithString: strValue attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
        }];
        
        NSMutableAttributedString *attHours = [[NSMutableAttributedString alloc] init];
        NSAttributedString *strHour = [[NSAttributedString alloc] initWithString: @"h" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        //NSAttributedString *strSpaceHr = [[NSAttributedString alloc] initWithString: @" " attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 32.0], NSKernAttributeName: @1.0}];
        [attHours appendAttributedString: strHour];
        //[attHours appendAttributedString: strSpaceHr];
        [_lblFirstHoursTitleLabel setAttributedText: attHours];
        
        [_lblFirstMinCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            
            NSString *strValue = ([[NSString stringWithFormat: @"%d", (int)(value / 1)] length] == 1) ? ([NSString stringWithFormat: @"0%d", (int)(value / 1)]) : ([NSString stringWithFormat: @"%d", (int)(value / 1)]);
            return [[NSAttributedString alloc] initWithString: strValue attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
        }];
        
        NSMutableAttributedString *attMinutes = [[NSMutableAttributedString alloc] init];
        NSAttributedString *strMin = [[NSAttributedString alloc] initWithString: @"min" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        NSAttributedString *strSpace = [[NSAttributedString alloc] initWithString: @" " attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 20.0], NSKernAttributeName: @0.1}];
        [attMinutes appendAttributedString: strMin];
        [attMinutes appendAttributedString: strSpace];
        [_lblFirstMinTitleLabel setAttributedText: attMinutes];
        
        [_lblFirstSecCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            NSString *strValue = ([[NSString stringWithFormat: @"%d", (int)(value / 1)] length] == 1) ? ([NSString stringWithFormat: @"0%d", (int)(value / 1)]) : ([NSString stringWithFormat: @"%d", (int)(value / 1)]);
            return [[NSAttributedString alloc] initWithString: strValue attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
        }];
        
        NSAttributedString *strSeconds = [[NSAttributedString alloc] initWithString: @"sec" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        [_lblFirstSecTitleLabel setAttributedText: strSeconds];
        
        //Min second view
        [_lblSecondMinCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            NSString *strValue = ([[NSString stringWithFormat: @"%d", (int)(value / 1)] length] == 1) ? ([NSString stringWithFormat: @"0%d", (int)(value / 1)]) : ([NSString stringWithFormat: @"%d", (int)(value / 1)]);
            return [[NSAttributedString alloc] initWithString: strValue attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
        }];
        
        NSMutableAttributedString *attSecondMinutes = [[NSMutableAttributedString alloc] init];
        NSAttributedString *strSecondMin = [[NSAttributedString alloc] initWithString: @"min" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        NSAttributedString *strSecondSpace = [[NSAttributedString alloc] initWithString: @" " attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 20.0], NSKernAttributeName: @0.1}];
        [attSecondMinutes appendAttributedString: strSecondMin];
        [attSecondMinutes appendAttributedString: strSecondSpace];
        [_lblSecondMinTitleLabel setAttributedText: attSecondMinutes];
        
        [_lblSecondSecCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            NSString *strValue = ([[NSString stringWithFormat: @"%d", (int)(value / 1)] length] == 1) ? ([NSString stringWithFormat: @"0%d", (int)(value / 1)]) : ([NSString stringWithFormat: @"%d", (int)(value / 1)]);
            return [[NSAttributedString alloc] initWithString: strValue attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
        }];
        
        NSAttributedString *strSecondSeconds = [[NSAttributedString alloc] initWithString: @"sec" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        [_lblSecondSecTitleLabel setAttributedText: strSecondSeconds];
        
        //Total exercise
        [_lblTotalExerciseCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            return [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"%d", (int) (value / 1)] attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0]}];
        }];
        
        NSAttributedString *strExercise = [[NSAttributedString alloc] initWithString: @" exercises" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        [_lblExerciseTitleLabel setAttributedText: strExercise];
    } else {
        
        // Exercise Hours
        if (hours > 0) {
            [self.lblHours setHidden:NO];
            [self.lblHours setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
                NSString *strHours = [NSString stringWithFormat:@"%d",hours];
                if (strHours.length > 1) {
                    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d:",hours]];
                } else {
                    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"0%d:",hours]];
                }
            }];
        } else {
            [self.lblHours setHidden:YES];
        }
        
        // Exercise Minutes
        
        [self.lblMinutes setFormatBlock:^NSString *(CGFloat value) {
            NSString *strMinutes = [NSString stringWithFormat:@"%d",minutes];
            if (strMinutes.length > 1) {
                return [NSString stringWithFormat:@"%d:",minutes];
            } else {
                return [NSString stringWithFormat:@"0%d:",minutes];
            }
        }];
        
        // Exercise Seconds
        [self.lblSeconds setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            NSString *strSecond = [NSString stringWithFormat:@"%d",seconds];
            if (strSecond.length > 1) {
                return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",seconds]];
            } else {
                return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"0%d",seconds]];
            }
        }];
        
        UIFont *fontDigits = (hours > 0) ? [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 27.0] : [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 35.2];
        
        //Hours Min Second view
        [_lblFirstHoursCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            
            NSString *strValue = ([[NSString stringWithFormat: @"%d", (int)(value / 1)] length] == 1) ? ([NSString stringWithFormat: @"0%d", (int)(value / 1)]) : ([NSString stringWithFormat: @"%d", (int)(value / 1)]);
            return [[NSAttributedString alloc] initWithString: strValue attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
        }];
        
        NSMutableAttributedString *attHours = [[NSMutableAttributedString alloc] init];
        NSAttributedString *strHour = [[NSAttributedString alloc] initWithString: @"h" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        //NSAttributedString *strSpaceHr = [[NSAttributedString alloc] initWithString: @" " attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 32.0], NSKernAttributeName: @1.0}];
        [attHours appendAttributedString: strHour];
        //[attHours appendAttributedString: strSpaceHr];
        [_lblFirstHoursTitleLabel setAttributedText: attHours];
        
        [_lblFirstMinCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            
            NSString *strValue = ([[NSString stringWithFormat: @"%d", (int)(value / 1)] length] == 1) ? ([NSString stringWithFormat: @"0%d", (int)(value / 1)]) : ([NSString stringWithFormat: @"%d", (int)(value / 1)]);
            return [[NSAttributedString alloc] initWithString: strValue attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
        }];
        
        NSMutableAttributedString *attMinutes = [[NSMutableAttributedString alloc] init];
        NSAttributedString *strMin = [[NSAttributedString alloc] initWithString: @"min" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        NSAttributedString *strSpace = [[NSAttributedString alloc] initWithString: @" " attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 20.0], NSKernAttributeName: @0.1}];
        [attMinutes appendAttributedString: strMin];
        [attMinutes appendAttributedString: strSpace];
        [_lblFirstMinTitleLabel setAttributedText: attMinutes];
        
        [_lblFirstSecCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            NSString *strValue = ([[NSString stringWithFormat: @"%d", (int)(value / 1)] length] == 1) ? ([NSString stringWithFormat: @"0%d", (int)(value / 1)]) : ([NSString stringWithFormat: @"%d", (int)(value / 1)]);
            return [[NSAttributedString alloc] initWithString: strValue attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
        }];
        
        NSAttributedString *strSeconds = [[NSAttributedString alloc] initWithString: @"sec" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        [_lblFirstSecTitleLabel setAttributedText: strSeconds];
        
        //Min second view
        [_lblSecondMinCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            NSString *strValue = ([[NSString stringWithFormat: @"%d", (int)(value / 1)] length] == 1) ? ([NSString stringWithFormat: @"0%d", (int)(value / 1)]) : ([NSString stringWithFormat: @"%d", (int)(value / 1)]);
            return [[NSAttributedString alloc] initWithString: strValue attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
        }];
        
        NSMutableAttributedString *attSecondMinutes = [[NSMutableAttributedString alloc] init];
        NSAttributedString *strSecondMin = [[NSAttributedString alloc] initWithString: @"min" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        NSAttributedString *strSecondSpace = [[NSAttributedString alloc] initWithString: @" " attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 20.0], NSKernAttributeName: @0.1}];
        [attSecondMinutes appendAttributedString: strSecondMin];
        [attSecondMinutes appendAttributedString: strSecondSpace];
        [_lblSecondMinTitleLabel setAttributedText: attSecondMinutes];
        
        [_lblSecondSecCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            NSString *strValue = ([[NSString stringWithFormat: @"%d", (int)(value / 1)] length] == 1) ? ([NSString stringWithFormat: @"0%d", (int)(value / 1)]) : ([NSString stringWithFormat: @"%d", (int)(value / 1)]);
            return [[NSAttributedString alloc] initWithString: strValue attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
        }];
        
        NSAttributedString *strSecondSeconds = [[NSAttributedString alloc] initWithString: @"sec" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        [_lblSecondSecTitleLabel setAttributedText: strSecondSeconds];
        
        //Total exercise
        [_lblTotalExerciseCountLabel setAttributedFormatBlock:^NSAttributedString *(CGFloat value) {
            return [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"%d", (int) (value / 1)] attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0]}];
        }];
        
        NSAttributedString *strExercise = [[NSAttributedString alloc] initWithString: @" exercises" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
        [_lblExerciseTitleLabel setAttributedText: strExercise];
    }
    
    // Set Animation duration according to workout quality
    
    float totalAnimateDuration = 0.0;
    if (workoutQuality >= 1 && workoutQuality <= 14) {
        totalAnimateDuration = 0.4;
    } else if (workoutQuality >= 14 && workoutQuality <= 30) {
        totalAnimateDuration = 0.8;
    } else if (workoutQuality >= 30 && workoutQuality <= 60) {
        totalAnimateDuration = 1.4;
    } else if (workoutQuality >= 60 && workoutQuality <= 100 ) {
        totalAnimateDuration = 2.2;
    }
    
    // Divide animation duration into 3 separate duration
    float animateFirst = 25.0 * totalAnimateDuration / 100;
    float animateSecond = 30.0 * totalAnimateDuration / 100;
    float animateThird = 50.0 * totalAnimateDuration / 100;
    
    // Divide workout quality into 2 separate value
    float valueFirst = 50.0 * workoutQuality / 100.0;
    float valueSecond = 30.0 * workoutQuality / 100.0;
    
    // Animation for workout quality progress
    
    [UIView animateWithDuration:animateFirst delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.vwQualityProgress.value = valueFirst;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:animateSecond delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.vwQualityProgress.value = valueFirst + valueSecond;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:animateThird delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.vwQualityProgress.value = workoutQuality;
            } completion:^(BOOL finished) {
            }];
            float delayTime = animateThird - 0.4;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (workoutQuality == 100) {
                    // Vibration
                    AudioServicesPlaySystemSoundWithCompletion(1520, nil);
                }
            });
        }];
    }];
    
    // Spring animation effect if workout quality reach at 100
    
    if (workoutQuality == 100) {
        [self.vwQualityProgress setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
        
        [UIView animateWithDuration:0.27 delay:totalAnimateDuration + 0.7 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.vwQualityProgress setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:5.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                [self.vwQualityProgress setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
        }];
    }
    
}

- (void) setupProgressBar {
    
    [_progressBarSetScreenView setBackgroundColor: UIColor.clearColor];
    [_progressBarSetScreenView setProgressLineWidth: 11.0];
    [_progressBarSetScreenView setEmptyLineWidth: 11.0];
    [_progressBarSetScreenView setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
    [_progressBarSetScreenView setProgressColor: cPROGRESS_BAR_GREEN];
    [_progressBarSetScreenView setProgressStrokeColor: cPROGRESS_BAR_GREEN];
    [_progressBarSetScreenView setEmptyLineColor: cPROGRESS_BAR_GREEN];
    [_progressBarSetScreenView setEmptyLineStrokeColor: cPROGRESS_BAR_GREEN];
    [_progressBarSetScreenView setValue: 100.0];
    
    [self.vwNextExerciseRing setBackgroundColor: UIColor.clearColor];
    [self.vwNextExerciseRing setProgressLineWidth: 11.0];
    [self.vwNextExerciseRing setEmptyLineWidth: 11.0];
    [self.vwNextExerciseRing setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
    [self.vwNextExerciseRing setProgressColor: cBLACK_RING];
    [self.vwNextExerciseRing setProgressStrokeColor: cBLACK_RING];
    [self.vwNextExerciseRing setEmptyLineColor: cBLACK_RING];
    [self.vwNextExerciseRing setEmptyLineStrokeColor: cBLACK_RING];
    [self.vwNextExerciseRing setValue: 100.0];
    
    [[self.progressBarRestScreenView layer] removeAllAnimations];
    [[_progressBarRestScreenView layer] layoutIfNeeded];
    [_progressBarRestScreenView setNeedsLayout];
    [_progressBarRestScreenView setBackgroundColor: UIColor.clearColor];
    [_progressBarRestScreenView setProgressLineWidth: 11.0];
    [_progressBarRestScreenView setEmptyLineWidth: 11.0];
    [_progressBarRestScreenView setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
    [_progressBarRestScreenView setProgressColor: cPROGRESS_BAR];
    [_progressBarRestScreenView setProgressStrokeColor: cPROGRESS_BAR];
    [_progressBarRestScreenView setEmptyLineColor: cEMPTY_BAR];
    [_progressBarRestScreenView setEmptyLineStrokeColor: cEMPTY_BAR];
    [_progressBarRestScreenView setValue: 0.0];
    [_progressBarRestScreenView setMaxValue: 100.0];
    [_progressBarRestScreenView setProgressAngle: -100.0];
    [_progressBarRestScreenView setProgressRotationAngle: 50.0];
    
}

- (void) showLoaderView {
    [_viewLoaderBackgroundView setHidden: NO];
    //    [_scrollViewSettingsScreen setHidden: NO];
    //    [self showTabBar];
}

- (void) hideLoaderView {
    [_viewLoaderBackgroundView setHidden: YES];
    //    [_scrollViewSettingsScreen setHidden: YES];
    //    [self hideTabBar];
}

- (void) showTabBar {
    
    [UIView animateWithDuration: 0.5 delay: 0.0 options: UIViewAnimationOptionTransitionCurlUp animations:^{
        CGFloat tabbarHeight = [[[self tabBarController] tabBar] frame].size.height;
        CGFloat tabbarWidth = [[[self tabBarController] tabBar] frame].size.width;
        //        CGFloat tabbarY = [[[self tabBarController] tabBar] frame].origin.y;
        [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - tabbarHeight), tabbarWidth, tabbarHeight)];
        //        [[[self tabBarController] tabBar] setTranslucent: YES];
        //        [[[self tabBarController] tabBar] setHidden: NO];
    } completion:^(BOOL finished) {}];
    
}

- (void) hideTabBar {
    
    [UIView animateWithDuration: 0.5 delay: 0.0 options: UIViewAnimationOptionTransitionCurlDown animations:^{
        CGFloat tabbarHeight = [[[self tabBarController] tabBar] frame].size.height;
        CGFloat tabbarWidth = [[[self tabBarController] tabBar] frame].size.width;
        //        CGFloat tabbarY = [[[self tabBarController] tabBar] frame].origin.y;
        [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT), tabbarWidth, tabbarHeight)];
        //        [[[self tabBarController] tabBar] setTranslucent: YES];
        //        [[[self tabBarController] tabBar] setHidden: YES];
    } completion:^(BOOL finished) {}];
    
}

- (void) toogleSetAndRestScreens {
    
    if ([isSetScreen isEqualToString: @"YES"]) {
        
        [UIView transitionWithView: _imgAppBackgroundImage duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_imgAppBackgroundImage setImage: iWELCOME_SCREEN];
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _viewSetAndRestBackgroundView duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            UIBezierPath *setAndRestBackgroundViewShadowPath = [UIBezierPath bezierPathWithRect: [self->_viewSetAndRestBackgroundView bounds]];
            [[self->_viewSetAndRestBackgroundView layer] setMasksToBounds: NO];
            [[self->_viewSetAndRestBackgroundView layer] setShadowColor: [cGREEN_SHADOW CGColor]];
            [[self->_viewSetAndRestBackgroundView layer] setShadowOffset: CGSizeMake(2.0, 2.0)];
            [[self->_viewSetAndRestBackgroundView layer] setShadowRadius: 15.0];
            [[self->_viewSetAndRestBackgroundView layer] setShadowOpacity: 0.3];
            [[self->_viewSetAndRestBackgroundView layer] setShadowPath: [setAndRestBackgroundViewShadowPath CGPath]];
            
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _viewSetAndRestScreenProgressBackgroundView duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            int totoalExerciseCount = [[[NSUserDefaults standardUserDefaults] valueForKey: kTOTAL_EXERCISE_COUNT] intValue];
            if (totoalExerciseCount == 0) {
                [self->_viewSetAndRestBackgroundView setBackgroundColor: [UIColor blackColor]];
            } else {
                [self->_viewSetAndRestBackgroundView setBackgroundColor: cDARK_GREEN_BACKGROUND];
            }
            
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _viewDoSetNumberContentView duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_viewDoSetNumberContentView setHidden: NO];
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _viewRestTimeContentView duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_viewRestTimeContentView setHidden: YES];
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _viewLastExerciseTimeContentView duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            if (([[[NSUserDefaults standardUserDefaults] valueForKey: kSET_COUNT] isEqualToString: @"1"]) && (![self->isStartWorkoutButtonTapped isEqualToString: @"YES"])) {
                [self.vwLastExercise setHidden: NO];
            } else {
                [self.vwLastExercise setHidden: YES];
                self->isStartWorkoutButtonTapped = @"NO";
            }
            
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _progressBarSetScreenView duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_progressBarSetScreenView setHidden: NO];
            [self->_imgSetScreenDumbellsImage setHidden:NO];
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _progressBarRestScreenView duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_progressBarRestBackgroungView setHidden: YES];
            [self->_progressBarRestScreenView setHidden: YES];
            [self->_vwRestScreenDumbellsBackgroundImage setHidden: YES];
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _imgSetScreenDumbellsImage duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_imgSetScreenDumbellsImage setImage: iGREEN_DUMBELLS];
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _viewClickAnywhereContentView duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_viewClickAnywhereContentView setHidden: NO];
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _viewNextSetContentView duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_viewNextSetContentView setHidden: YES];
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _viewExerciseContentView duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            int totoalExerciseCount = [[[NSUserDefaults standardUserDefaults] valueForKey: kTOTAL_EXERCISE_COUNT] intValue];
            if (totoalExerciseCount == 0) {
                [self->_viewExerciseContentView setBackgroundColor: cWARMUP_BLACK];
            } else {
                [self->_viewExerciseContentView setBackgroundColor: cDARK_GREEN_2];
            }
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _viewTotalTimeContentView duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            int totoalExerciseCount = [[[NSUserDefaults standardUserDefaults] valueForKey: kTOTAL_EXERCISE_COUNT] intValue];
            if (totoalExerciseCount == 0) {
                [self->_viewTotalTimeContentView setBackgroundColor: cWARMUP_BLACK];
            } else {
                [self->_viewTotalTimeContentView setBackgroundColor: cDARK_GREEN_2];
            }
        } completion:^(BOOL finished) {
            if([[self->_viewTotalTimeContentView backgroundColor] isEqual: cWARMUP_BLACK])
            {
                [_imgNextExerciseImage setImage:[UIImage imageNamed:@"imgGrayNext"]];
                [_lblNextExerciseLabel setTextColor: [UIColor colorWithRed:97.0/255.0 green:97.0/255.0 blue:97.0/255.0 alpha:1.0]];
//                [self->_viewNextExerciseButtonContentView setAlpha: nextExerciseOpacity];
                [self->_btnNextExerciseButton setEnabled: false];
            }
            else
            {
                [_imgNextExerciseImage setImage:[UIImage imageNamed:@"imgGreenNext"]];
                [_lblNextExerciseLabel setTextColor: [UIColor whiteColor]];
                [self->_btnNextExerciseButton setEnabled: true];
            }
        }];
        
        [UIView transitionWithView: _lblExerciseLabel duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            int totoalExerciseCount = [[[NSUserDefaults standardUserDefaults] valueForKey: kTOTAL_EXERCISE_COUNT] intValue];
            if (totoalExerciseCount == 0) {
                [self->_lblExerciseLabel setTextColor: cEXERCISE_BLACK];
            } else {
                [self->_lblExerciseLabel setTextColor: cLIGHT_GREEN_2];
            }
            
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _lblTotalTimeLabel duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            int totoalExerciseCount = [[[NSUserDefaults standardUserDefaults] valueForKey: kTOTAL_EXERCISE_COUNT] intValue];
            if (totoalExerciseCount == 0) {
                [self->_lblTotalTimeLabel setTextColor: cEXERCISE_BLACK];
            } else {
                [self->_lblTotalTimeLabel setTextColor: cLIGHT_GREEN_2];
            }
            
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _imgNextExerciseImage duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_imgNextExerciseImage setImage: iGREEN_NEXT_EXERCISE];
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _lblChangeRestCountLabel duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_lblChangeRestCountLabel setTextColor: cPROGRESS_BAR_GREEN];
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _imgSoundImage duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            NSString *isSoundOn = [[NSUserDefaults standardUserDefaults] valueForKey: kIS_SOUND_ON];
            UIImage *imgGreenSound = ([isSoundOn isEqualToString: @"YES"]) ? iGREEN_SOUND : iGREEN_SOUND_OFF;
            [self->_imgSoundImage setImage: imgGreenSound];
            
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _imgEndWorkoutImage duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_imgEndWorkoutImage setImage: iGREEN_END_WORKOUT];
        } completion:^(BOOL finished) {}];
        
    } else {
        
        [UIView transitionWithView: _imgAppBackgroundImage duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_imgAppBackgroundImage setImage: iREST_SCREEN];
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _viewSetAndRestBackgroundView duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            UIBezierPath *setAndRestBackgroundViewShadowPath = [UIBezierPath bezierPathWithRect: [self->_viewSetAndRestBackgroundView bounds]];
            [[self->_viewSetAndRestBackgroundView layer] setMasksToBounds: NO];
            [[self->_viewSetAndRestBackgroundView layer] setShadowColor: [cRED_SHADOW CGColor]];
            [[self->_viewSetAndRestBackgroundView layer] setShadowOffset: CGSizeMake(2.0, 2.0)];
            [[self->_viewSetAndRestBackgroundView layer] setShadowRadius: 15.0];
            [[self->_viewSetAndRestBackgroundView layer] setShadowOpacity: 0.3];
            [[self->_viewSetAndRestBackgroundView layer] setShadowPath: [setAndRestBackgroundViewShadowPath CGPath]];
            
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _viewSetAndRestScreenProgressBackgroundView duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_viewSetAndRestBackgroundView setBackgroundColor: cDARK_RED_BACKGROUND];
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _viewDoSetNumberContentView duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_viewDoSetNumberContentView setHidden: YES];
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _viewRestTimeContentView duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_viewRestTimeContentView setHidden: NO];
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _viewLastExerciseTimeContentView duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_viewLastExerciseTimeContentView setHidden: YES];
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _progressBarSetScreenView duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_progressBarSetScreenView setHidden: YES];
            [self->_imgSetScreenDumbellsImage setHidden:YES];
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _progressBarRestScreenView duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_progressBarRestBackgroungView setHidden: NO];
            [self->_progressBarRestScreenView setHidden: NO];
            [self->_vwRestScreenDumbellsBackgroundImage setHidden: NO];
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _imgRestScreenDumbellsImage duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_imgRestScreenDumbellsImage setImage: iRED_DUMBELLS];
            [self->_imgRestScreenDumbellsBackgroundImage setImage: iRED_DUMBELLS_Bg];
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _viewClickAnywhereContentView duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_viewClickAnywhereContentView setHidden: YES];
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _viewNextSetContentView duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_viewNextSetContentView setHidden: NO];
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _viewExerciseContentView duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_viewExerciseContentView setBackgroundColor: cDARK_RED_2];
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _viewTotalTimeContentView duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_viewTotalTimeContentView setBackgroundColor: cDARK_RED_2];
        } completion:^(BOOL finished) {
            /*if([[self->_viewTotalTimeContentView backgroundColor] isEqual: cWARMUP_BLACK])
            {
                [_imgNextExerciseImage setImage:[UIImage imageNamed:@"imgGrayNext"]];
                [self->_viewNextExerciseButtonContentView setAlpha: nextExerciseOpacity];
                [self->_btnNextExerciseButton setEnabled: false];
            }
            else
            {
                [_imgNextExerciseImage setImage:[UIImage imageNamed:@"imgGreenNext"]];
                [self->_viewNextExerciseButtonContentView setAlpha: 1];
                [self->_btnNextExerciseButton setEnabled: true];
            }*/
        }];
        
        [UIView transitionWithView: _lblExerciseLabel duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_lblExerciseLabel setTextColor: cLIGHT_RED_2];
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _lblTotalTimeLabel duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_lblTotalTimeLabel setTextColor: cLIGHT_RED_2];
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _imgNextExerciseImage duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_imgNextExerciseImage setImage: iRED_NEXT_EXERCISE];
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _lblChangeRestCountLabel duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_lblChangeRestCountLabel setTextColor: cPROGRESS_BAR];
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _imgSoundImage duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            NSString *isSoundOn = [[NSUserDefaults standardUserDefaults] valueForKey: kIS_SOUND_ON];
            UIImage *imgRedSound = ([isSoundOn isEqualToString: @"YES"]) ? iRED_SOUND : iRED_SOUND_OFF;
            [self->_imgSoundImage setImage: imgRedSound];
            
        } completion:^(BOOL finished) {}];
        
        [UIView transitionWithView: _imgEndWorkoutImage duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self->_imgEndWorkoutImage setImage: iRED_END_WORKOUT];
        } completion:^(BOOL finished) {}];
        
    }
    
}

- (void) changeButtonTitle {
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey: @"isEndWOButtonClicked"] isEqualToString: @"NO"]) {
        NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"Continue" attributes: dicStartButtonAttributes];
        [_btnStartWorkoutButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
    } else {
        NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"Start Workout" attributes: dicStartButtonAttributes];
        [_btnStartWorkoutButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
    }
    
    NSArray *arrMinSec = [[[NSUserDefaults standardUserDefaults] valueForKey: kREST_TIME] componentsSeparatedByString: @":"];
    NSInteger rowMin = [arrMinSec[0] integerValue];
    NSInteger rowSec = [arrMinSec[1] integerValue] / 5;
    [_pickerWorkoutRestTimePickerView setDelegate: self];
    [_pickerWorkoutRestTimePickerView setDataSource: self];
    [_pickerWorkoutRestTimePickerView reloadAllComponents];
    [_pickerWorkoutRestTimePickerView selectRow: rowMin inComponent: 0 animated: NO];
    [_pickerWorkoutRestTimePickerView selectRow: rowSec inComponent: 1 animated: NO];
    
}

- (NSAttributedString *) createAttributedStringForTotalTime {
    
    NSMutableAttributedString *attMainString = [[NSMutableAttributedString alloc] init];
    
    NSString *strTotalTime = [[NSUserDefaults standardUserDefaults] valueForKey: kTOTAL_TIME];
    NSArray *arrTimeComponents = [strTotalTime componentsSeparatedByString: @":"];
    int hours = [arrTimeComponents[0] intValue];
    int minutes = [arrTimeComponents[1] intValue];
    int seconds = [arrTimeComponents[2] intValue];
    //    int minutes = 45;
    //    int seconds = 39;
    
    UIFont *fontDigits = (hours > 0) ? [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0] : [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0];
    
    NSAttributedString *strHourCount = [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"%d", hours] attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
    
    NSAttributedString *strHour = [[NSAttributedString alloc] initWithString: @"h" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
    
    NSAttributedString *strSpaceHr = [[NSAttributedString alloc] initWithString: @" " attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 32.0], NSKernAttributeName: @1.0}];
    
    NSAttributedString *strMinCount = [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"%d", minutes] attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
    
    NSAttributedString *strMin = [[NSAttributedString alloc] initWithString: @"min" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
    
    NSAttributedString *strSpace = [[NSAttributedString alloc] initWithString: @" " attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 20.0], NSKernAttributeName: @0.1}];
    
    NSAttributedString *strSecCount = [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"%d", seconds] attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontDigits}];
    
    NSAttributedString *strSeconds = [[NSAttributedString alloc] initWithString: @"sec" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
    
    if (hours > 0) {
        
        [attMainString appendAttributedString: strHourCount];
        [attMainString appendAttributedString: strHour];
        [attMainString appendAttributedString: strSpaceHr];
        [attMainString appendAttributedString: strMinCount];
        [attMainString appendAttributedString: strMin];
        [attMainString appendAttributedString: strSpace];
        [attMainString appendAttributedString: strSecCount];
        [attMainString appendAttributedString: strSeconds];
        
    } else {
        
        [attMainString appendAttributedString: strMinCount];
        [attMainString appendAttributedString: strMin];
        [attMainString appendAttributedString: strSpace];
        [attMainString appendAttributedString: strSecCount];
        [attMainString appendAttributedString: strSeconds];
        
    }
    
    return attMainString;
    
}

- (NSAttributedString *) createAttributedStringForTotalExercise {
    
    NSMutableAttributedString *attMainString = [[NSMutableAttributedString alloc] init];
    
    NSString *strTotalExercise = [[NSUserDefaults standardUserDefaults] valueForKey: kTOTAL_EXERCISE_COUNT];
    //    NSString *strTotalExercise = @"6";
    
    NSAttributedString *strExerciseCount = [[NSAttributedString alloc] initWithString: strTotalExercise attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0]}];
    
    NSAttributedString *strExercise = [[NSAttributedString alloc] initWithString: @" exercises" attributes:  @{ NSForegroundColorAttributeName: cLIGHT_BLACK, NSFontAttributeName: [UIFont fontWithName: fFUTURA_MEDIUM size: 22.0]}];
    
    [attMainString appendAttributedString: strExerciseCount];
    [attMainString appendAttributedString: strExercise];
    
    return attMainString;
    
}

- (void) adjustFontOfDoSetCountLabel {
    
    NSString *strCurrentSetCount = [[NSUserDefaults standardUserDefaults] valueForKey: kSET_COUNT];
    
    CGFloat setCountLabelX = [_lblDoSetNumberCountLabel frame].origin.x;
    CGFloat setCountLabelY = [_lblDoSetNumberCountLabel frame].origin.y;
    CGFloat setCountLabelWidth = [_lblDoSetNumberCountLabel frame].size.width;
    CGFloat setCountLabelHeight = [_lblDoSetNumberCountLabel frame].size.height;
    
    CGRect setCountLabelFrame;
    if (IS_IPHONEXR) {
        setCountLabelFrame = ([strCurrentSetCount length] > 1) ? CGRectMake(setCountLabelX, 22.0, setCountLabelWidth, setCountLabelHeight) : CGRectMake(setCountLabelX, setCountLabelY, setCountLabelWidth, setCountLabelHeight);
        UIFont *fontDoSetCountLabel = ([strCurrentSetCount length] > 1) ? [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 88.0] : [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 142.0];
        [_lblDoSetNumberCountLabel setFrame: setCountLabelFrame];
        [_lblDoSetNumberCountLabel setFont: fontDoSetCountLabel];
    } else if (IS_IPHONEX) {
        setCountLabelFrame = ([strCurrentSetCount length] > 1) ? CGRectMake(208.0, 22.0, setCountLabelWidth, setCountLabelHeight) : CGRectMake(setCountLabelX, setCountLabelY, setCountLabelWidth, setCountLabelHeight);
        UIFont *fontDoSetCountLabel = ([strCurrentSetCount length] > 1) ? [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 88.0] : [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 142.0];
        [_lblDoSetNumberCountLabel setFrame: setCountLabelFrame];
        [_lblDoSetNumberCountLabel setFont: fontDoSetCountLabel];
    } else if (IS_IPHONE8PLUS) {
        setCountLabelFrame = ([strCurrentSetCount length] > 1) ? CGRectMake(setCountLabelX, 22.0, setCountLabelWidth, setCountLabelHeight) : CGRectMake(setCountLabelX, setCountLabelY, setCountLabelWidth, setCountLabelHeight);
        // Vsn - 11/03/2020
        UIFont *fontDoSetCountLabel = ([strCurrentSetCount length] > 1) ? [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 88.0] : [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 102.0]; // 142.0
        [_lblDoSetNumberCountLabel setFrame: setCountLabelFrame];
        [_lblDoSetNumberCountLabel setFont: fontDoSetCountLabel];
    } else if (IS_IPHONE8) {
        
        if (strCurrentSetCount.length == 1) {
            setCountLabelFrame = CGRectMake(244, 20, 121, 104);
        } else {
            setCountLabelFrame = CGRectMake(234, 23, 121, 104);
        }
        UIFont *fontDoSetCountLabel = ([strCurrentSetCount length] > 1) ? [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 78.0] : [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 100.0];
        [_lblDoSetNumberCountLabel setFrame: setCountLabelFrame];
        [_lblDoSetNumberCountLabel setFont: fontDoSetCountLabel];
    } else {
        if (strCurrentSetCount.length == 1) {
            setCountLabelFrame = CGRectMake(220, 30, 80, 100);
            UIFont *fontDoSetCountLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 70.0];
            [_lblDoSetNumberCountLabel setFont: fontDoSetCountLabel];
        } else {
            setCountLabelFrame = CGRectMake(190, 35, 80, 100);
            UIFont *fontDoSetCountLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 60.0];
            [_lblDoSetNumberCountLabel setFont: fontDoSetCountLabel];
            
            [_lblDoSetNumberLabel setFrame: CGRectMake(0.0, 30, 189, 123.0)];
            UIFont *fontDoSetLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0];
            [_lblDoSetNumberLabel setFont: fontDoSetLabel];
        }
        [_lblDoSetNumberCountLabel setFrame: setCountLabelFrame];
    }
}

- (void)displayCongrats {
    
    [self.vwCongrats setHidden:NO];
    CGFloat setAndRestBgWidth = _viewSetAndRestBackgroundView.frame.size.width;
    [_viewWorkoutStatsBackgroundView setBackgroundColor: [UIColor clearColor]];
    [_lblWorkoutCompleteLabel setTextColor:[UIColor colorWithRed:45.0/255.0 green:112.0/255.0 blue:73.0/255.0 alpha:1.0]];
    _lblWorkoutCompleteLabel.text = @"Workout \ncomplete !";
    _lblWorkoutCompleteLabel.textAlignment = NSTextAlignmentCenter;
    
    if (IS_IPHONEXR) {
        //Scroll and content view
        [_scrollViewWorkoutCompleteScreen setFrame: CGRectMake(DEVICE_WIDTH, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        [_scrollViewWorkoutCompleteScreen setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + 600)];
        [_contentViewWorkoutCompleteScreen setFrame: CGRectMake(0.0, 16.0, (_scrollViewWorkoutCompleteScreen.contentSize.width), (_scrollViewWorkoutCompleteScreen.contentSize.height))];
        
        //Gym Timer label
        [_lblGymTimerWorkoutScreenTitleLabel setFrame: CGRectMake(0.0, 0.0, (_contentViewSetAndRestScreen.frame.size.width), 40.0)];
        UIFont *fontGymTimerWorkoutScreenLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblGymTimerWorkoutScreenTitleLabel setFont: fontGymTimerWorkoutScreenLabel];
        // [_lblGymTimerWorkoutScreenTitleLabel setHidden: YES];
        
        //Workout Stats background view
        [_viewWorkoutStatsBackgroundView setFrame: CGRectMake(18.0, 24, (_contentViewWorkoutCompleteScreen.frame.size.width - 36.0), 800)];
        [[_viewWorkoutStatsBackgroundView layer] setCornerRadius: 30.0];
        
        CGFloat workoutCompleteViewHeight = 130;
        CGFloat statsContentWidth = _viewWorkoutStatsBackgroundView.frame.size.width;
        [_viewWorkoutCompleteContentVIew setFrame: CGRectMake(0.0, 0.0, statsContentWidth, workoutCompleteViewHeight)];
        
        // Congrats View
        [self.vwCongrats setFrame:CGRectMake(0.0, _viewWorkoutCompleteContentVIew.frame.origin.y + _viewWorkoutCompleteContentVIew.frame.size.height, _viewWorkoutStatsBackgroundView.frame.size.width, 284)];
        self.vwCongrats.layer.cornerRadius = 30.0;
        self.vwCongrats.layer.borderColor = cNEW_GREEN.CGColor;
        self.vwCongrats.layer.borderWidth = 3;
        
        [self.lblCongrats setFrame:CGRectMake(0, 30, self.vwCongrats.frame.size.width, 41)];
        [self.lblYouReached setFrame:CGRectMake(0, self.lblCongrats.frame.origin.y + self.lblCongrats.frame.size.height, self.vwCongrats.frame.size.width, 19)];
        
        CGFloat imgBadgeX = (self.vwCongrats.frame.size.width / 2) - 73;
        [self.imgBadge setFrame:CGRectMake(imgBadgeX, self.lblYouReached.frame.origin.y + 24, 132, 146)];
        
        [self.lblLevel setFrame:CGRectMake(imgBadgeX + 24, self.imgBadge.frame.origin.y + 10, 85, 108)];
        
        //Stats content view
        [_viewWorkoutStatsContentView setFrame: CGRectMake(0.0, self.vwCongrats.frame.origin.y + self.vwCongrats.frame.size.height + 16, setAndRestBgWidth, 284)];
        [_viewWorkoutStatsContentView setFrame: CGRectMake(0.0, self.vwCongrats.frame.origin.y + self.vwCongrats.frame.size.height + 16, setAndRestBgWidth, 284)];
        [[_viewWorkoutStatsContentView layer] setCornerRadius: 30.0];
        
        //Do set number view and Rest time view
        [_viewWorkoutCompleteContentVIew setFrame: CGRectMake(0.0, 0.0, statsContentWidth, workoutCompleteViewHeight)];
        [_lblWorkoutCompleteLabel setFrame: CGRectMake(0.0, 0.0, _viewWorkoutCompleteContentVIew.frame.size.width, _viewWorkoutCompleteContentVIew.frame.size.height)];
        UIFont *fontWorkoutCompleteLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 54.0];
        [_lblWorkoutCompleteLabel setFont: fontWorkoutCompleteLabel];
        
        [_lblCurrentDateLabel setFrame: CGRectMake(0.0, 0.0, (_viewWorkoutStatsContentView.frame.size.width), 70.0)];
        UIFont *currentDateLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 21.0];
        [_lblCurrentDateLabel setFont: currentDateLabel];
        // Vsn - 10/04/2020
        [_lblRandomWorkoutCompleteTitle setFrame: _lblCurrentDateLabel.frame];
        [_lblRandomWorkoutCompleteTitle setFont:currentDateLabel];
        // End
        
        // New Design
        [self.vwDateTime setFrame:CGRectMake(0, 0, setAndRestBgWidth, 70)];
        [self.vwCompetedBottom setFrame:CGRectMake(0, 70, setAndRestBgWidth, 214)];
        [self.vwQuality setFrame:CGRectMake(0, 0, setAndRestBgWidth / 2, 214)];
        [self.vwTime setFrame:CGRectMake(setAndRestBgWidth / 2, 0, setAndRestBgWidth / 2, 214)];
        
        [self.lblTotalTimeTitle setFrame:CGRectMake(16, 30, self.vwTime.frame.size.width - 16, 20)];
        
        [self.lblTotalExercisetitle setFrame:CGRectMake(16, 107, self.vwTime.frame.size.width - 16, 20)];
        [self.lblTotalExercise setFrame:CGRectMake(16, 134, self.vwTime.frame.size.width - 16, 41)];
        
        [self.lblQuality setFrame:CGRectMake(48, 30, 50, 20)];
        [self.vwQualityProgress setFrame:CGRectMake(38, 65, 118, 118)];
        
        self.vwQualityProgress.valueFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
        self.vwQualityProgress.valueFontSize = 32;
        self.vwQualityProgress.fontColor = cNEW_GREEN;
        self.vwQualityProgress.unitFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
        self.vwQualityProgress.unitFontSize = 18;
        
        //Total workout time views
        [_lblTotalWorkoutTimeLabel setHidden: YES];
        [_lblTotalWorkoutExercisesLabel setHidden: YES];
        
        [_viewHoursTimeFormatContentView setFrame: CGRectMake(37.0, (_lblCurrentDateLabel.frame.origin.y + _lblCurrentDateLabel.frame.size.height + 24.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
        [[_viewHoursTimeFormatContentView layer] setCornerRadius: 15.0];
        
        CGFloat timeCountLabelWidth = ([_viewHoursTimeFormatContentView frame].size.width / 6.0);
        CGFloat timeTitlelabelWidth = ([_viewHoursTimeFormatContentView frame].size.width / 6.0);
        
        //Hours min sec format
        [_lblFirstHoursCountLabel setFrame: CGRectMake(19.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
        [_lblFirstHoursTitleLabel setFrame: CGRectMake((_lblFirstHoursCountLabel.frame.origin.x + _lblFirstHoursCountLabel.frame.size.width) - 0.0, 8.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
        [_lblFirstMinCountLabel setFrame: CGRectMake((_lblFirstHoursTitleLabel.frame.origin.x + _lblFirstHoursTitleLabel.frame.size.width) - 26.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
        [_lblFirstMinTitleLabel setFrame: CGRectMake((_lblFirstMinCountLabel.frame.origin.x + _lblFirstMinCountLabel.frame.size.width) - 0.5, 8.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
        [_lblFirstSecCountLabel setFrame: CGRectMake((_lblFirstMinTitleLabel.frame.origin.x + _lblFirstMinTitleLabel.frame.size.width) - 6.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
        [_lblFirstSecTitleLabel setFrame: CGRectMake((_lblFirstSecCountLabel.frame.origin.x + _lblFirstSecCountLabel.frame.size.width) - 0.0, 8.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
        
        //Min sec format
        [_viewMinTimeFormatContentView setFrame: CGRectMake(37.0, (_lblCurrentDateLabel.frame.origin.y + _lblCurrentDateLabel.frame.size.height + 24.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
        [[_viewMinTimeFormatContentView layer] setCornerRadius: 15.0];
        [_lblSecondMinCountLabel setFrame: CGRectMake(44.0, 0.0, (timeCountLabelWidth + 8.0), (_viewMinTimeFormatContentView.frame.size.height))];
        [_lblSecondMinTitleLabel setFrame: CGRectMake((_lblSecondMinCountLabel.frame.origin.x + _lblSecondMinCountLabel.frame.size.width) - 0.0, 12.0, timeTitlelabelWidth, (_viewMinTimeFormatContentView.frame.size.height - 12.0))];
        [_lblSecondSecCountLabel setFrame: CGRectMake((_lblSecondMinTitleLabel.frame.origin.x + _lblSecondMinTitleLabel.frame.size.width) - 4.0, 0.0, (timeCountLabelWidth + 8.0), (_viewMinTimeFormatContentView.frame.size.height))];
        [_lblSecondSecTitleLabel setFrame: CGRectMake((_lblSecondSecCountLabel.frame.origin.x + _lblSecondSecCountLabel.frame.size.width) - 0.0, 12.0, timeTitlelabelWidth, (_viewMinTimeFormatContentView.frame.size.height - 12.0))];
        
        //Total exercise view
        [_viewTotalExerciseContentView setFrame: CGRectMake(37.0, (_viewHoursTimeFormatContentView.frame.origin.y + _viewHoursTimeFormatContentView.frame.size.height + 18.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
        [[_viewTotalExerciseContentView layer] setCornerRadius: 15.0];
        [_lblTotalExerciseCountLabel setFrame: CGRectMake(45.0, 0.0, (timeCountLabelWidth + 8.0), (_viewTotalExerciseContentView.frame.size.height - 1.0))];
        [_lblExerciseTitleLabel setFrame: CGRectMake((_lblTotalExerciseCountLabel.frame.origin.x + _lblTotalExerciseCountLabel.frame.size.width), 11.0, (_viewTotalExerciseContentView.frame.size.width - (_lblTotalExerciseCountLabel.frame.origin.x + _lblTotalExerciseCountLabel.frame.size.width)), (_viewTotalExerciseContentView.frame.size.height - 11.0))];
        
        lblCounting = [[UICountingLabel alloc] initWithFrame: CGRectMake(60.0, (_viewTotalExerciseContentView.frame.origin.y + _viewTotalExerciseContentView.frame.size.height + 12.0), 100.0, 40.0)];
        [_viewWorkoutStatsContentView addSubview: lblCounting];
        
        [_btnDoneWorkoutButton setFrame:CGRectMake(self.view.frame.size.width / 2 + 40, self.viewWorkoutStatsContentView.frame.origin.y + self.viewWorkoutStatsContentView.frame.size.height + 44, 80, 80)];
        [_btnShareStatsButton setFrame:CGRectMake(self.view.frame.size.width / 2 - 120, self.viewWorkoutStatsContentView.frame.origin.y + self.viewWorkoutStatsContentView.frame.size.height + 44, 80, 80)];
        
        [_scrollViewWorkoutCompleteScreen setContentSize: CGSizeMake(DEVICE_WIDTH, self.btnDoneWorkoutButton.frame.origin.y + self.btnDoneWorkoutButton.frame.size.height + 54)];
    } else if (IS_IPHONEX) {
        
        //Scroll and content view
        [_scrollViewWorkoutCompleteScreen setFrame: CGRectMake(DEVICE_WIDTH, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        [_scrollViewWorkoutCompleteScreen setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + 600)];
        [_contentViewWorkoutCompleteScreen setFrame: CGRectMake(0.0, 16.0, (_scrollViewWorkoutCompleteScreen.contentSize.width), (_scrollViewWorkoutCompleteScreen.contentSize.height))];
        
        //Gym Timer label
        [_lblGymTimerWorkoutScreenTitleLabel setFrame: CGRectMake(0.0, 0.0, (_contentViewSetAndRestScreen.frame.size.width), 40.0)];
        UIFont *fontGymTimerWorkoutScreenLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblGymTimerWorkoutScreenTitleLabel setFont: fontGymTimerWorkoutScreenLabel];
        // [_lblGymTimerWorkoutScreenTitleLabel setHidden: YES];
        
        //Workout Stats background view
        [_viewWorkoutStatsBackgroundView setFrame: CGRectMake(18.0, 24, (_contentViewWorkoutCompleteScreen.frame.size.width - 36.0), 800)];
        [[_viewWorkoutStatsBackgroundView layer] setCornerRadius: 30.0];
        
        // Congrats View
        [self.vwCongrats setFrame:CGRectMake(0.0, _viewWorkoutCompleteContentVIew.frame.origin.y + _viewWorkoutCompleteContentVIew.frame.size.height + 20, _viewWorkoutStatsBackgroundView.frame.size.width, 284)];
        self.vwCongrats.layer.cornerRadius = 30.0;
        self.vwCongrats.layer.borderColor = cNEW_GREEN.CGColor;
        self.vwCongrats.layer.borderWidth = 3;
        
        [self.lblCongrats setFrame:CGRectMake(0, 30, self.vwCongrats.frame.size.width, 41)];
        [self.lblYouReached setFrame:CGRectMake(0, self.lblCongrats.frame.origin.y + self.lblCongrats.frame.size.height, self.vwCongrats.frame.size.width, 19)];
        
        CGFloat imgBadgeX = (self.vwCongrats.frame.size.width / 2) - 73;
        [self.imgBadge setFrame:CGRectMake(imgBadgeX, self.lblYouReached.frame.origin.y + 24, 132, 146)];
        
        [self.lblLevel setFrame:CGRectMake(imgBadgeX + 24, self.imgBadge.frame.origin.y + 10, 85, 108)];
        
        //Stats content view
        CGFloat statsContentWidth = _viewWorkoutStatsBackgroundView.frame.size.width;
        [_viewWorkoutStatsContentView setFrame: CGRectMake(0.0, self.vwCongrats.frame.origin.y + self.vwCongrats.frame.size.height + 16, setAndRestBgWidth, 284)];
        [[_viewWorkoutStatsContentView layer] setCornerRadius: 30.0];
        
        //Do set number view and Rest time view
        CGFloat workoutCompleteViewHeight = 130;
        [_viewWorkoutCompleteContentVIew setFrame: CGRectMake(0.0, 0.0, statsContentWidth, workoutCompleteViewHeight)];
        [_lblWorkoutCompleteLabel setFrame: CGRectMake(0.0, (workoutCompleteViewHeight - 120.0), _viewWorkoutCompleteContentVIew.frame.size.width, _viewWorkoutCompleteContentVIew.frame.size.height)];
        UIFont *fontWorkoutCompleteLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 54.0];
        [_lblWorkoutCompleteLabel setFont: fontWorkoutCompleteLabel];
        
        [_lblCurrentDateLabel setFrame: CGRectMake(0.0, 0.0, (_viewWorkoutStatsContentView.frame.size.width), 70.0)];
        UIFont *currentDateLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 21.0];
        [_lblCurrentDateLabel setFont: currentDateLabel];
        // Vsn - 10/04/2020
        [_lblRandomWorkoutCompleteTitle setFrame: _lblCurrentDateLabel.frame];
        [_lblRandomWorkoutCompleteTitle setFont:currentDateLabel];
        // End
        
        // New Design
        [self.vwDateTime setFrame:CGRectMake(0, 0, setAndRestBgWidth, 70)];
        [self.vwCompetedBottom setFrame:CGRectMake(0, 70, setAndRestBgWidth, 214)];
        [self.vwQuality setFrame:CGRectMake(0, 0, setAndRestBgWidth / 2, 214)];
        [self.vwTime setFrame:CGRectMake(setAndRestBgWidth / 2, 0, setAndRestBgWidth / 2, 214)];
        
        [self.lblTotalTimeTitle setFrame:CGRectMake(16, 30, self.vwTime.frame.size.width - 16, 20)];
        
        [self.lblTotalExercisetitle setFrame:CGRectMake(16, 107, self.vwTime.frame.size.width - 16, 20)];
        [self.lblTotalExercise setFrame:CGRectMake(16, 134, self.vwTime.frame.size.width - 16, 41)];
        
        [self.lblQuality setFrame:CGRectMake(48, 30, 50, 20)];
        [self.vwQualityProgress setFrame:CGRectMake(38, 65, 118, 118)];
        
        self.vwQualityProgress.valueFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
        self.vwQualityProgress.valueFontSize = 32;
        self.vwQualityProgress.fontColor = cNEW_GREEN;
        self.vwQualityProgress.unitFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
        self.vwQualityProgress.unitFontSize = 18;
        
        //Total workout time views
        [_lblTotalWorkoutTimeLabel setHidden: YES];
        [_lblTotalWorkoutExercisesLabel setHidden: YES];
        
        [_viewHoursTimeFormatContentView setFrame: CGRectMake(37.0, (_lblCurrentDateLabel.frame.origin.y + _lblCurrentDateLabel.frame.size.height + 24.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
        [[_viewHoursTimeFormatContentView layer] setCornerRadius: 15.0];
        
        CGFloat timeCountLabelWidth = ([_viewHoursTimeFormatContentView frame].size.width / 6.0);
        CGFloat timeTitlelabelWidth = ([_viewHoursTimeFormatContentView frame].size.width / 6.0);
        
        //Hours min sec format
        [_lblFirstHoursCountLabel setFrame: CGRectMake(19.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
        [_lblFirstHoursTitleLabel setFrame: CGRectMake((_lblFirstHoursCountLabel.frame.origin.x + _lblFirstHoursCountLabel.frame.size.width) - 0.0, 8.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
        [_lblFirstMinCountLabel setFrame: CGRectMake((_lblFirstHoursTitleLabel.frame.origin.x + _lblFirstHoursTitleLabel.frame.size.width) - 26.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
        [_lblFirstMinTitleLabel setFrame: CGRectMake((_lblFirstMinCountLabel.frame.origin.x + _lblFirstMinCountLabel.frame.size.width) - 0.5, 8.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
        [_lblFirstSecCountLabel setFrame: CGRectMake((_lblFirstMinTitleLabel.frame.origin.x + _lblFirstMinTitleLabel.frame.size.width) - 6.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
        [_lblFirstSecTitleLabel setFrame: CGRectMake((_lblFirstSecCountLabel.frame.origin.x + _lblFirstSecCountLabel.frame.size.width) - 0.0, 8.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
        
        //Min sec format
        [_viewMinTimeFormatContentView setFrame: CGRectMake(37.0, (_lblCurrentDateLabel.frame.origin.y + _lblCurrentDateLabel.frame.size.height + 24.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
        [[_viewMinTimeFormatContentView layer] setCornerRadius: 15.0];
        [_lblSecondMinCountLabel setFrame: CGRectMake(44.0, 0.0, (timeCountLabelWidth + 8.0), (_viewMinTimeFormatContentView.frame.size.height))];
        [_lblSecondMinTitleLabel setFrame: CGRectMake((_lblSecondMinCountLabel.frame.origin.x + _lblSecondMinCountLabel.frame.size.width) - 0.0, 12.0, timeTitlelabelWidth, (_viewMinTimeFormatContentView.frame.size.height - 12.0))];
        [_lblSecondSecCountLabel setFrame: CGRectMake((_lblSecondMinTitleLabel.frame.origin.x + _lblSecondMinTitleLabel.frame.size.width) - 4.0, 0.0, (timeCountLabelWidth + 8.0), (_viewMinTimeFormatContentView.frame.size.height))];
        [_lblSecondSecTitleLabel setFrame: CGRectMake((_lblSecondSecCountLabel.frame.origin.x + _lblSecondSecCountLabel.frame.size.width) - 0.0, 12.0, timeTitlelabelWidth, (_viewMinTimeFormatContentView.frame.size.height - 12.0))];
        
        //Total exercise view
        [_viewTotalExerciseContentView setFrame: CGRectMake(37.0, (_viewHoursTimeFormatContentView.frame.origin.y + _viewHoursTimeFormatContentView.frame.size.height + 18.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
        [[_viewTotalExerciseContentView layer] setCornerRadius: 15.0];
        [_lblTotalExerciseCountLabel setFrame: CGRectMake(45.0, 0.0, (timeCountLabelWidth + 8.0), (_viewTotalExerciseContentView.frame.size.height - 1.0))];
        [_lblExerciseTitleLabel setFrame: CGRectMake((_lblTotalExerciseCountLabel.frame.origin.x + _lblTotalExerciseCountLabel.frame.size.width), 11.0, (_viewTotalExerciseContentView.frame.size.width - (_lblTotalExerciseCountLabel.frame.origin.x + _lblTotalExerciseCountLabel.frame.size.width)), (_viewTotalExerciseContentView.frame.size.height - 11.0))];
        
        lblCounting = [[UICountingLabel alloc] initWithFrame: CGRectMake(60.0, (_viewTotalExerciseContentView.frame.origin.y + _viewTotalExerciseContentView.frame.size.height + 12.0), 100.0, 40.0)];
        [_viewWorkoutStatsContentView addSubview: lblCounting];
        
        [_btnShareStatsButton setFrame:CGRectMake(85, self.viewWorkoutStatsContentView.frame.origin.y + self.viewWorkoutStatsContentView.frame.size.height + 64, 80, 80)];
        [_btnDoneWorkoutButton setFrame:CGRectMake(self.btnShareStatsButton.frame.origin.x + self.btnShareStatsButton.frame.size.width + 45, self.viewWorkoutStatsContentView.frame.origin.y + self.viewWorkoutStatsContentView.frame.size.height + 64, 80, 80)];
        
        [_scrollViewWorkoutCompleteScreen setContentSize: CGSizeMake(DEVICE_WIDTH, self.btnDoneWorkoutButton.frame.origin.y + self.btnDoneWorkoutButton.frame.size.height + 54)];
        
    } else if (IS_IPHONE8PLUS) {
        
        //Scroll and content view
        [_scrollViewWorkoutCompleteScreen setFrame: CGRectMake(DEVICE_WIDTH, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        [_scrollViewWorkoutCompleteScreen setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + 600)];
        [_contentViewWorkoutCompleteScreen setFrame: CGRectMake(0.0, 16.0, (_scrollViewWorkoutCompleteScreen.contentSize.width), (_scrollViewWorkoutCompleteScreen.contentSize.height))];
        
        //Gym Timer label
        [_lblGymTimerWorkoutScreenTitleLabel setFrame: CGRectMake(0.0, 0.0, (_contentViewSetAndRestScreen.frame.size.width), 40.0)];
        UIFont *fontGymTimerWorkoutScreenLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblGymTimerWorkoutScreenTitleLabel setFont: fontGymTimerWorkoutScreenLabel];
        // [_lblGymTimerWorkoutScreenTitleLabel setHidden: YES];
        
        //Workout Stats background view
        [_viewWorkoutStatsBackgroundView setFrame: CGRectMake(18.0, 24, (_contentViewWorkoutCompleteScreen.frame.size.width - 36.0), 800)];
        [[_viewWorkoutStatsBackgroundView layer] setCornerRadius: 30.0];
        
        // Congrats View
        [self.vwCongrats setFrame:CGRectMake(0.0, _viewWorkoutCompleteContentVIew.frame.origin.y + _viewWorkoutCompleteContentVIew.frame.size.height + 20, _viewWorkoutStatsBackgroundView.frame.size.width, 284)];
        self.vwCongrats.layer.cornerRadius = 30.0;
        self.vwCongrats.layer.borderColor = cNEW_GREEN.CGColor;
        self.vwCongrats.layer.borderWidth = 3;
        
        [self.lblCongrats setFrame:CGRectMake(0, 30, self.vwCongrats.frame.size.width, 41)];
        [self.lblYouReached setFrame:CGRectMake(0, self.lblCongrats.frame.origin.y + self.lblCongrats.frame.size.height, self.vwCongrats.frame.size.width, 19)];
        
        CGFloat imgBadgeX = (self.vwCongrats.frame.size.width / 2) - 73;
        [self.imgBadge setFrame:CGRectMake(imgBadgeX, self.lblYouReached.frame.origin.y + 24, 132, 146)];
        
        [self.lblLevel setFrame:CGRectMake(imgBadgeX + 24, self.imgBadge.frame.origin.y + 10, 85, 108)];
        
        //Stats content view
        CGFloat statsContentWidth = _viewWorkoutStatsBackgroundView.frame.size.width;
        [_viewWorkoutStatsContentView setFrame: CGRectMake(0.0, self.vwCongrats.frame.origin.y + self.vwCongrats.frame.size.height + 16, setAndRestBgWidth, 284)];
        [[_viewWorkoutStatsContentView layer] setCornerRadius: 30.0];
        
        //Do set number view and Rest time view
        CGFloat workoutCompleteViewHeight = 130;
        [_viewWorkoutCompleteContentVIew setFrame: CGRectMake(0.0, 0.0, statsContentWidth, workoutCompleteViewHeight)];
        [_lblWorkoutCompleteLabel setFrame: CGRectMake(0.0, (workoutCompleteViewHeight - 120.0), _viewWorkoutCompleteContentVIew.frame.size.width, _viewWorkoutCompleteContentVIew.frame.size.height)];
        UIFont *fontWorkoutCompleteLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 54.0];
        [_lblWorkoutCompleteLabel setFont: fontWorkoutCompleteLabel];
        
        [_lblCurrentDateLabel setFrame: CGRectMake(0.0, 0.0, (_viewWorkoutStatsContentView.frame.size.width), 70.0)];
        UIFont *currentDateLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 21.0];
        [_lblCurrentDateLabel setFont: currentDateLabel];
        // Vsn - 10/04/2020
        [_lblRandomWorkoutCompleteTitle setFrame: _lblCurrentDateLabel.frame];
        [_lblRandomWorkoutCompleteTitle setFont:currentDateLabel];
        // End
        
        // New Design
        [self.vwDateTime setFrame:CGRectMake(0, 0, setAndRestBgWidth, 70)];
        [self.vwCompetedBottom setFrame:CGRectMake(0, 70, setAndRestBgWidth, 214)];
        [self.vwQuality setFrame:CGRectMake(0, 0, setAndRestBgWidth / 2, 214)];
        [self.vwTime setFrame:CGRectMake(setAndRestBgWidth / 2, 0, setAndRestBgWidth / 2, 214)];
        
        [self.lblTotalTimeTitle setFrame:CGRectMake(16, 30, self.vwTime.frame.size.width - 16, 20)];
        
        [self.lblTotalExercisetitle setFrame:CGRectMake(16, 107, self.vwTime.frame.size.width - 16, 20)];
        [self.lblTotalExercise setFrame:CGRectMake(16, 134, self.vwTime.frame.size.width - 16, 41)];
        
        [self.lblQuality setFrame:CGRectMake(48, 30, 50, 20)];
        [self.vwQualityProgress setFrame:CGRectMake(38, 65, 118, 118)];
        
        self.vwQualityProgress.valueFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
        self.vwQualityProgress.valueFontSize = 32;
        self.vwQualityProgress.fontColor = cNEW_GREEN;
        self.vwQualityProgress.unitFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
        self.vwQualityProgress.unitFontSize = 18;
        
        //Total workout time views
        [_lblTotalWorkoutTimeLabel setHidden: YES];
        [_lblTotalWorkoutExercisesLabel setHidden: YES];
        
        [_viewHoursTimeFormatContentView setFrame: CGRectMake(37.0, (_lblCurrentDateLabel.frame.origin.y + _lblCurrentDateLabel.frame.size.height + 24.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
        [[_viewHoursTimeFormatContentView layer] setCornerRadius: 15.0];
        
        CGFloat timeCountLabelWidth = ([_viewHoursTimeFormatContentView frame].size.width / 6.0);
        CGFloat timeTitlelabelWidth = ([_viewHoursTimeFormatContentView frame].size.width / 6.0);
        
        //Hours min sec format
        [_lblFirstHoursCountLabel setFrame: CGRectMake(19.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
        [_lblFirstHoursTitleLabel setFrame: CGRectMake((_lblFirstHoursCountLabel.frame.origin.x + _lblFirstHoursCountLabel.frame.size.width) - 0.0, 8.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
        [_lblFirstMinCountLabel setFrame: CGRectMake((_lblFirstHoursTitleLabel.frame.origin.x + _lblFirstHoursTitleLabel.frame.size.width) - 26.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
        [_lblFirstMinTitleLabel setFrame: CGRectMake((_lblFirstMinCountLabel.frame.origin.x + _lblFirstMinCountLabel.frame.size.width) - 0.5, 8.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
        [_lblFirstSecCountLabel setFrame: CGRectMake((_lblFirstMinTitleLabel.frame.origin.x + _lblFirstMinTitleLabel.frame.size.width) - 6.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
        [_lblFirstSecTitleLabel setFrame: CGRectMake((_lblFirstSecCountLabel.frame.origin.x + _lblFirstSecCountLabel.frame.size.width) - 0.0, 8.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
        
        //Min sec format
        [_viewMinTimeFormatContentView setFrame: CGRectMake(37.0, (_lblCurrentDateLabel.frame.origin.y + _lblCurrentDateLabel.frame.size.height + 24.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
        [[_viewMinTimeFormatContentView layer] setCornerRadius: 15.0];
        [_lblSecondMinCountLabel setFrame: CGRectMake(44.0, 0.0, (timeCountLabelWidth + 8.0), (_viewMinTimeFormatContentView.frame.size.height))];
        [_lblSecondMinTitleLabel setFrame: CGRectMake((_lblSecondMinCountLabel.frame.origin.x + _lblSecondMinCountLabel.frame.size.width) - 0.0, 12.0, timeTitlelabelWidth, (_viewMinTimeFormatContentView.frame.size.height - 12.0))];
        [_lblSecondSecCountLabel setFrame: CGRectMake((_lblSecondMinTitleLabel.frame.origin.x + _lblSecondMinTitleLabel.frame.size.width) - 4.0, 0.0, (timeCountLabelWidth + 8.0), (_viewMinTimeFormatContentView.frame.size.height))];
        [_lblSecondSecTitleLabel setFrame: CGRectMake((_lblSecondSecCountLabel.frame.origin.x + _lblSecondSecCountLabel.frame.size.width) - 0.0, 12.0, timeTitlelabelWidth, (_viewMinTimeFormatContentView.frame.size.height - 12.0))];
        
        //Total exercise view
        [_viewTotalExerciseContentView setFrame: CGRectMake(37.0, (_viewHoursTimeFormatContentView.frame.origin.y + _viewHoursTimeFormatContentView.frame.size.height + 18.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
        [[_viewTotalExerciseContentView layer] setCornerRadius: 15.0];
        [_lblTotalExerciseCountLabel setFrame: CGRectMake(45.0, 0.0, (timeCountLabelWidth + 8.0), (_viewTotalExerciseContentView.frame.size.height - 1.0))];
        [_lblExerciseTitleLabel setFrame: CGRectMake((_lblTotalExerciseCountLabel.frame.origin.x + _lblTotalExerciseCountLabel.frame.size.width), 11.0, (_viewTotalExerciseContentView.frame.size.width - (_lblTotalExerciseCountLabel.frame.origin.x + _lblTotalExerciseCountLabel.frame.size.width)), (_viewTotalExerciseContentView.frame.size.height - 11.0))];
        
        lblCounting = [[UICountingLabel alloc] initWithFrame: CGRectMake(60.0, (_viewTotalExerciseContentView.frame.origin.y + _viewTotalExerciseContentView.frame.size.height + 12.0), 100.0, 40.0)];
        [_viewWorkoutStatsContentView addSubview: lblCounting];
        
        [self.btnDoneWorkoutButton setFrame:CGRectMake(self.view.frame.size.width / 2 + 40, self.viewWorkoutStatsContentView.frame.origin.y + self.viewWorkoutStatsContentView.frame.size.height + 58, 80, 80)];
        [self.btnShareStatsButton setFrame:CGRectMake(self.view.frame.size.width / 2 - 120, self.viewWorkoutStatsContentView.frame.origin.y + self.viewWorkoutStatsContentView.frame.size.height + 58, 80, 80)];
        
        [_scrollViewWorkoutCompleteScreen setContentSize: CGSizeMake(DEVICE_WIDTH, self.btnDoneWorkoutButton.frame.origin.y + self.btnDoneWorkoutButton.frame.size.height + 54)];
    } else if (IS_IPHONE8) {
        
        //Scroll and content view
        [_scrollViewWorkoutCompleteScreen setFrame: CGRectMake(DEVICE_WIDTH, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        [_scrollViewWorkoutCompleteScreen setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + 600)];
        [_contentViewWorkoutCompleteScreen setFrame: CGRectMake(0.0, 0.0, (_scrollViewWorkoutCompleteScreen.contentSize.width), (_scrollViewWorkoutCompleteScreen.contentSize.height))];
        
        //Gym Timer label
        [_lblGymTimerWorkoutScreenTitleLabel setFrame: CGRectMake(0.0, 36.0, (_contentViewSetAndRestScreen.frame.size.width), 40.0)];
        UIFont *fontGymTimerWorkoutScreenLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblGymTimerWorkoutScreenTitleLabel setFont: fontGymTimerWorkoutScreenLabel];
        // [_lblGymTimerWorkoutScreenTitleLabel setHidden: YES];
        
        //Workout Stats background view
        [_viewWorkoutStatsBackgroundView setFrame: CGRectMake(18.0, 24, (_contentViewWorkoutCompleteScreen.frame.size.width - 36.0), 800)];
        [[_viewWorkoutStatsBackgroundView layer] setCornerRadius: 30.0];
        
        // Congrats View
        [self.vwCongrats setFrame:CGRectMake(0.0, _viewWorkoutCompleteContentVIew.frame.origin.y + _viewWorkoutCompleteContentVIew.frame.size.height + 20, _viewWorkoutStatsBackgroundView.frame.size.width, 284)];
        self.vwCongrats.layer.cornerRadius = 30.0;
        self.vwCongrats.layer.borderColor = cNEW_GREEN.CGColor;
        self.vwCongrats.layer.borderWidth = 3;
        
        [self.lblCongrats setFrame:CGRectMake(0, 30, self.vwCongrats.frame.size.width, 41)];
        [self.lblYouReached setFrame:CGRectMake(0, self.lblCongrats.frame.origin.y + self.lblCongrats.frame.size.height, self.vwCongrats.frame.size.width, 19)];
        
        CGFloat imgBadgeX = (self.vwCongrats.frame.size.width / 2) - 73;
        [self.imgBadge setFrame:CGRectMake(imgBadgeX, self.lblYouReached.frame.origin.y + 24, 132, 146)];
        
        [self.lblLevel setFrame:CGRectMake(imgBadgeX + 45, self.imgBadge.frame.origin.y + 16, 43, 90)];
        
        //Stats content view
        CGFloat statsContentWidth = _viewWorkoutStatsBackgroundView.frame.size.width;
        [_viewWorkoutStatsContentView setFrame: CGRectMake(0.0, self.vwCongrats.frame.origin.y + self.vwCongrats.frame.size.height + 16, setAndRestBgWidth, 284)];
        [[_viewWorkoutStatsContentView layer] setCornerRadius: 30.0];
        
        //Do set number view and Rest time view
        CGFloat workoutCompleteViewHeight = 130;
        [_viewWorkoutCompleteContentVIew setFrame: CGRectMake(0.0, 0.0, statsContentWidth, workoutCompleteViewHeight)];
        [_lblWorkoutCompleteLabel setFrame: CGRectMake(0.0, (workoutCompleteViewHeight - 120.0), _viewWorkoutCompleteContentVIew.frame.size.width, _viewWorkoutCompleteContentVIew.frame.size.height)];
        UIFont *fontWorkoutCompleteLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 45.0];
        [_lblWorkoutCompleteLabel setFont: fontWorkoutCompleteLabel];
        
        [_lblCurrentDateLabel setFrame: CGRectMake(0.0, 0.0, (_viewWorkoutStatsContentView.frame.size.width), 70.0)];
        UIFont *currentDateLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 21.0];
        [_lblCurrentDateLabel setFont: currentDateLabel];
        // Vsn - 10/04/2020
        [_lblRandomWorkoutCompleteTitle setFrame: _lblCurrentDateLabel.frame];
        [_lblRandomWorkoutCompleteTitle setFont:currentDateLabel];
        // End
        
        // New Design
        [self.vwDateTime setFrame:CGRectMake(0, 0, setAndRestBgWidth, 70)];
        [self.vwCompetedBottom setFrame:CGRectMake(0, 70, setAndRestBgWidth, 214)];
        [self.vwQuality setFrame:CGRectMake(0, 0, setAndRestBgWidth / 2, 214)];
        [self.vwTime setFrame:CGRectMake(setAndRestBgWidth / 2, 0, setAndRestBgWidth / 2, 214)];
        
        [self.lblTotalTimeTitle setFrame:CGRectMake(16, 30, self.vwTime.frame.size.width - 16, 20)];
        
        [self.lblTotalExercisetitle setFrame:CGRectMake(16, 107, self.vwTime.frame.size.width - 16, 20)];
        [self.lblTotalExercise setFrame:CGRectMake(16, 134, self.vwTime.frame.size.width - 16, 41)];
        
        [self.lblQuality setFrame:CGRectMake(48, 30, 50, 20)];
        [self.vwQualityProgress setFrame:CGRectMake(38, 65, 118, 118)];
        
        self.vwQualityProgress.valueFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
        self.vwQualityProgress.valueFontSize = 32;
        self.vwQualityProgress.fontColor = cNEW_GREEN;
        self.vwQualityProgress.unitFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
        self.vwQualityProgress.unitFontSize = 18;
        
        //Total workout time views
        [_lblTotalWorkoutTimeLabel setHidden: YES];
        [_lblTotalWorkoutExercisesLabel setHidden: YES];
        
        [_viewHoursTimeFormatContentView setFrame: CGRectMake(37.0, (_lblCurrentDateLabel.frame.origin.y + _lblCurrentDateLabel.frame.size.height + 24.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
        [[_viewHoursTimeFormatContentView layer] setCornerRadius: 15.0];
        
        CGFloat timeCountLabelWidth = ([_viewHoursTimeFormatContentView frame].size.width / 6.0);
        CGFloat timeTitlelabelWidth = ([_viewHoursTimeFormatContentView frame].size.width / 6.0);
        
        //Hours min sec format
        [_lblFirstHoursCountLabel setFrame: CGRectMake(19.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
        [_lblFirstHoursTitleLabel setFrame: CGRectMake((_lblFirstHoursCountLabel.frame.origin.x + _lblFirstHoursCountLabel.frame.size.width) - 0.0, 8.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
        [_lblFirstMinCountLabel setFrame: CGRectMake((_lblFirstHoursTitleLabel.frame.origin.x + _lblFirstHoursTitleLabel.frame.size.width) - 26.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
        [_lblFirstMinTitleLabel setFrame: CGRectMake((_lblFirstMinCountLabel.frame.origin.x + _lblFirstMinCountLabel.frame.size.width) - 0.5, 8.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
        [_lblFirstSecCountLabel setFrame: CGRectMake((_lblFirstMinTitleLabel.frame.origin.x + _lblFirstMinTitleLabel.frame.size.width) - 6.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
        [_lblFirstSecTitleLabel setFrame: CGRectMake((_lblFirstSecCountLabel.frame.origin.x + _lblFirstSecCountLabel.frame.size.width) - 0.0, 8.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
        
        //Min sec format
        [_viewMinTimeFormatContentView setFrame: CGRectMake(37.0, (_lblCurrentDateLabel.frame.origin.y + _lblCurrentDateLabel.frame.size.height + 24.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
        [[_viewMinTimeFormatContentView layer] setCornerRadius: 15.0];
        [_lblSecondMinCountLabel setFrame: CGRectMake(44.0, 0.0, (timeCountLabelWidth + 8.0), (_viewMinTimeFormatContentView.frame.size.height))];
        [_lblSecondMinTitleLabel setFrame: CGRectMake((_lblSecondMinCountLabel.frame.origin.x + _lblSecondMinCountLabel.frame.size.width) - 0.0, 12.0, timeTitlelabelWidth, (_viewMinTimeFormatContentView.frame.size.height - 12.0))];
        [_lblSecondSecCountLabel setFrame: CGRectMake((_lblSecondMinTitleLabel.frame.origin.x + _lblSecondMinTitleLabel.frame.size.width) - 4.0, 0.0, (timeCountLabelWidth + 8.0), (_viewMinTimeFormatContentView.frame.size.height))];
        [_lblSecondSecTitleLabel setFrame: CGRectMake((_lblSecondSecCountLabel.frame.origin.x + _lblSecondSecCountLabel.frame.size.width) - 0.0, 12.0, timeTitlelabelWidth, (_viewMinTimeFormatContentView.frame.size.height - 12.0))];
        
        //Total exercise view
        [_viewTotalExerciseContentView setFrame: CGRectMake(37.0, (_viewHoursTimeFormatContentView.frame.origin.y + _viewHoursTimeFormatContentView.frame.size.height + 18.0), (_viewWorkoutStatsContentView.frame.size.width - 74.0), 80.0)];
        [[_viewTotalExerciseContentView layer] setCornerRadius: 15.0];
        [_lblTotalExerciseCountLabel setFrame: CGRectMake(45.0, 0.0, (timeCountLabelWidth + 8.0), (_viewTotalExerciseContentView.frame.size.height - 1.0))];
        [_lblExerciseTitleLabel setFrame: CGRectMake((_lblTotalExerciseCountLabel.frame.origin.x + _lblTotalExerciseCountLabel.frame.size.width), 11.0, (_viewTotalExerciseContentView.frame.size.width - (_lblTotalExerciseCountLabel.frame.origin.x + _lblTotalExerciseCountLabel.frame.size.width)), (_viewTotalExerciseContentView.frame.size.height - 11.0))];
        
        lblCounting = [[UICountingLabel alloc] initWithFrame: CGRectMake(60.0, (_viewTotalExerciseContentView.frame.origin.y + _viewTotalExerciseContentView.frame.size.height + 12.0), 100.0, 40.0)];
        [_viewWorkoutStatsContentView addSubview: lblCounting];
        
        [self.btnDoneWorkoutButton setFrame:CGRectMake(self.view.frame.size.width / 2 + 40, self.viewWorkoutStatsContentView.frame.origin.y + self.viewWorkoutStatsContentView.frame.size.height + 58, 80, 80)];
        [self.btnShareStatsButton setFrame:CGRectMake(self.view.frame.size.width / 2 - 120, self.viewWorkoutStatsContentView.frame.origin.y + self.viewWorkoutStatsContentView.frame.size.height + 58, 80, 80)];
        
        [_scrollViewWorkoutCompleteScreen setContentSize: CGSizeMake(DEVICE_WIDTH, self.btnDoneWorkoutButton.frame.origin.y + self.btnDoneWorkoutButton.frame.size.height + 130)];

    } else {
        //Scroll and content view
        [_scrollViewWorkoutCompleteScreen setFrame: CGRectMake(DEVICE_WIDTH, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        [_scrollViewWorkoutCompleteScreen setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + 500)];
        [_contentViewWorkoutCompleteScreen setFrame: CGRectMake(0.0, 0.0, (_scrollViewWorkoutCompleteScreen.contentSize.width), (_scrollViewWorkoutCompleteScreen.contentSize.height))];
        
        //Gym Timer label
        [_lblGymTimerWorkoutScreenTitleLabel setFrame: CGRectMake(0.0, 36.0, (_contentViewSetAndRestScreen.frame.size.width), 40.0)];
        UIFont *fontGymTimerWorkoutScreenLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblGymTimerWorkoutScreenTitleLabel setFont: fontGymTimerWorkoutScreenLabel];
        // [_lblGymTimerWorkoutScreenTitleLabel setHidden: YES];
        
        // Congrats View
        [self.vwCongrats setFrame:CGRectMake(0.0, _viewWorkoutCompleteContentVIew.frame.origin.y + _viewWorkoutCompleteContentVIew.frame.size.height + 20, _viewWorkoutStatsBackgroundView.frame.size.width, 284)];
        self.vwCongrats.layer.cornerRadius = 30.0;
        self.vwCongrats.layer.borderColor = cNEW_GREEN.CGColor;
        self.vwCongrats.layer.borderWidth = 3;
        
        [self.lblCongrats setFrame:CGRectMake(0, 30, self.vwCongrats.frame.size.width, 41)];
        [self.lblYouReached setFrame:CGRectMake(0, self.lblCongrats.frame.origin.y + self.lblCongrats.frame.size.height, self.vwCongrats.frame.size.width, 19)];
        
        CGFloat imgBadgeX = (self.vwCongrats.frame.size.width / 2) - 73;
        [self.imgBadge setFrame:CGRectMake(imgBadgeX, self.lblYouReached.frame.origin.y + 24, 132, 146)];
        
        [self.lblLevel setFrame:CGRectMake(imgBadgeX + 45, self.imgBadge.frame.origin.y + 16, 43, 90)];
        
        //Workout Stats background view
        [_viewWorkoutStatsBackgroundView setFrame: CGRectMake(18.0, 24, (_contentViewWorkoutCompleteScreen.frame.size.width - 36.0), 800)];
        [[_viewWorkoutStatsBackgroundView layer] setCornerRadius: 30.0];
        
        //Stats content view
        CGFloat statsContentWidth = _viewWorkoutStatsBackgroundView.frame.size.width;
        [_viewWorkoutStatsContentView setFrame: CGRectMake(0.0, self.vwCongrats.frame.origin.y + self.vwCongrats.frame.size.height + 16, setAndRestBgWidth, statsContentWidth - 9.0)];
        [[_viewWorkoutStatsContentView layer] setCornerRadius: 30.0];
        
        //Do set number view and Rest time view
        CGFloat workoutCompleteViewHeight = 130;
        [_viewWorkoutCompleteContentVIew setFrame: CGRectMake(0.0, 0.0, statsContentWidth, workoutCompleteViewHeight)];
        [_lblWorkoutCompleteLabel setFrame: CGRectMake(0.0, (workoutCompleteViewHeight - 120.0), _viewWorkoutCompleteContentVIew.frame.size.width, _viewWorkoutCompleteContentVIew.frame.size.height)];
        UIFont *fontWorkoutCompleteLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 35.0];
        [_lblWorkoutCompleteLabel setFont: fontWorkoutCompleteLabel];
        
        [_lblCurrentDateLabel setFrame: CGRectMake(0.0, 0.0, (_viewWorkoutStatsContentView.frame.size.width), 70.0)];
        UIFont *currentDateLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 21.0];
        [_lblCurrentDateLabel setFont: currentDateLabel];
        // Vsn - 10/04/2020
        [_lblRandomWorkoutCompleteTitle setFrame: _lblCurrentDateLabel.frame];
        [_lblRandomWorkoutCompleteTitle setFont:currentDateLabel];
        // End
        
        // New Design
        [self.vwDateTime setFrame:CGRectMake(0, 0, setAndRestBgWidth, 70)];
        [self.vwCompetedBottom setFrame:CGRectMake(0, 70, setAndRestBgWidth, 214)];
        [self.vwQuality setFrame:CGRectMake(0, 0, setAndRestBgWidth / 2, 214)];
        [self.vwTime setFrame:CGRectMake(setAndRestBgWidth / 2, 0, setAndRestBgWidth / 2, 214)];
        
        [self.lblTotalTimeTitle setFrame:CGRectMake(16, 30, self.vwTime.frame.size.width - 16, 20)];
        
        [self.lblTotalExercisetitle setFrame:CGRectMake(16, 107, self.vwTime.frame.size.width - 16, 20)];
        [self.lblTotalExercise setFrame:CGRectMake(16, 134, self.vwTime.frame.size.width - 16, 41)];
        
        [self.lblQuality setFrame:CGRectMake(48, 30, 50, 20)];
        [self.vwQualityProgress setFrame:CGRectMake(18, 65, 118, 118)];
        
        self.vwQualityProgress.valueFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
        self.vwQualityProgress.valueFontSize = 32;
        self.vwQualityProgress.fontColor = cNEW_GREEN;
        self.vwQualityProgress.unitFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
        self.vwQualityProgress.unitFontSize = 18;
        
        //Total workout time views
        [_lblTotalWorkoutTimeLabel setHidden: YES];
        [_lblTotalWorkoutExercisesLabel setHidden: YES];
        
        [_viewHoursTimeFormatContentView setFrame: CGRectMake(17.0, (_lblCurrentDateLabel.frame.origin.y + _lblCurrentDateLabel.frame.size.height + 15.0), (_viewWorkoutStatsContentView.frame.size.width - 35.0), 70.0)];
        [[_viewHoursTimeFormatContentView layer] setCornerRadius: 15.0];
        
        CGFloat timeCountLabelWidth = ([_viewHoursTimeFormatContentView frame].size.width / 6.0);
        CGFloat timeTitlelabelWidth = ([_viewHoursTimeFormatContentView frame].size.width / 6.0);
        
        //Hours min sec format
        [_lblFirstHoursCountLabel setFrame: CGRectMake(19.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
        [_lblFirstHoursTitleLabel setFrame: CGRectMake((_lblFirstHoursCountLabel.frame.origin.x + _lblFirstHoursCountLabel.frame.size.width) - 0.0, 6.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
        [_lblFirstMinCountLabel setFrame: CGRectMake((_lblFirstHoursTitleLabel.frame.origin.x + _lblFirstHoursTitleLabel.frame.size.width) - 26.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
        [_lblFirstMinTitleLabel setFrame: CGRectMake((_lblFirstMinCountLabel.frame.origin.x + _lblFirstMinCountLabel.frame.size.width) - 0.5, 6.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
        [_lblFirstSecCountLabel setFrame: CGRectMake((_lblFirstMinTitleLabel.frame.origin.x + _lblFirstMinTitleLabel.frame.size.width) - 6.0, 0.0, timeCountLabelWidth, (_viewHoursTimeFormatContentView.frame.size.height))];
        [_lblFirstSecTitleLabel setFrame: CGRectMake((_lblFirstSecCountLabel.frame.origin.x + _lblFirstSecCountLabel.frame.size.width) - 0.0, 6.0, timeTitlelabelWidth, (_viewHoursTimeFormatContentView.frame.size.height - 8.0))];
        
        //Min sec format
        [_viewMinTimeFormatContentView setFrame: CGRectMake(17.0, (_lblCurrentDateLabel.frame.origin.y + _lblCurrentDateLabel.frame.size.height + 15.0), (_viewWorkoutStatsContentView.frame.size.width - 35.0), 70.0)];
        [[_viewMinTimeFormatContentView layer] setCornerRadius: 15.0];
        [_lblSecondMinCountLabel setFrame: CGRectMake(44.0, 0.0, (timeCountLabelWidth + 8.0), (_viewMinTimeFormatContentView.frame.size.height))];
        [_lblSecondMinTitleLabel setFrame: CGRectMake((_lblSecondMinCountLabel.frame.origin.x + _lblSecondMinCountLabel.frame.size.width) - 0.0, 12.0, timeTitlelabelWidth, (_viewMinTimeFormatContentView.frame.size.height - 12.0))];
        [_lblSecondSecCountLabel setFrame: CGRectMake((_lblSecondMinTitleLabel.frame.origin.x + _lblSecondMinTitleLabel.frame.size.width) - 4.0, 0.0, (timeCountLabelWidth + 8.0), (_viewMinTimeFormatContentView.frame.size.height))];
        [_lblSecondSecTitleLabel setFrame: CGRectMake((_lblSecondSecCountLabel.frame.origin.x + _lblSecondSecCountLabel.frame.size.width) - 0.0, 12.0, timeTitlelabelWidth, (_viewMinTimeFormatContentView.frame.size.height - 12.0))];
        
        //Total exercise view
        [_viewTotalExerciseContentView setFrame: CGRectMake(17.0, (_viewHoursTimeFormatContentView.frame.origin.y + _viewHoursTimeFormatContentView.frame.size.height) + 15.0, (_viewWorkoutStatsContentView.frame.size.width - 35.0), 70.0)];
        [[_viewTotalExerciseContentView layer] setCornerRadius: 15.0];
        [_lblTotalExerciseCountLabel setFrame: CGRectMake(45.0, 0.0, (timeCountLabelWidth + 8.0), (_viewTotalExerciseContentView.frame.size.height - 1.0))];
        [_lblExerciseTitleLabel setFrame: CGRectMake((_lblTotalExerciseCountLabel.frame.origin.x + _lblTotalExerciseCountLabel.frame.size.width), 11.0, (_viewTotalExerciseContentView.frame.size.width - (_lblTotalExerciseCountLabel.frame.origin.x + _lblTotalExerciseCountLabel.frame.size.width)), (_viewTotalExerciseContentView.frame.size.height - 11.0))];
        
        lblCounting = [[UICountingLabel alloc] initWithFrame: CGRectMake(60.0, (_viewTotalExerciseContentView.frame.origin.y + _viewTotalExerciseContentView.frame.size.height + 12.0), 100.0, 40.0)];
        [_viewWorkoutStatsContentView addSubview: lblCounting];
        
        [self.btnDoneWorkoutButton setFrame:CGRectMake(self.view.frame.size.width / 2 + 20, self.viewWorkoutStatsContentView.frame.origin.y + self.viewWorkoutStatsContentView.frame.size.height + 58, 60, 60)];
        [self.btnShareStatsButton setFrame:CGRectMake(self.view.frame.size.width / 2 - 80, self.viewWorkoutStatsContentView.frame.origin.y + self.viewWorkoutStatsContentView.frame.size.height + 58, 60, 60)];
        
        [_scrollViewWorkoutCompleteScreen setContentSize: CGSizeMake(DEVICE_WIDTH, self.btnDoneWorkoutButton.frame.origin.y + self.btnDoneWorkoutButton.frame.size.height + 132)];
    }
    
}

//MARK:- Rest Time count methods

- (int) convertRestTimeToSecondsFrom: (NSString *) restTime {
    
    NSArray *arrTimeComponents = [restTime componentsSeparatedByString: @":"];
    int minutes = [arrTimeComponents[0] intValue];
    int seconds = [arrTimeComponents[1] intValue];
    currentRestTimeMinutes = minutes;
    currentRestTimeSeconds = seconds;
    //    totalCurrentMin = minutes;
    //    totalCurrentSec = seconds;
    
    int totalSeconds = 0;
    
    if (minutes > 0) {
        totalSeconds += (minutes * 60);
    }
    
    if (seconds > 0) {
        totalSeconds += seconds;
    }
    
    return totalSeconds;
}

- (void) setupForRestScreenTimer {
    
    //    NSLog(@"setupForRestScreenTimer Timer : %@", self->_timerRest);
    
    NSString *strRestTime = [[NSUserDefaults standardUserDefaults] valueForKey: kREST_TIME];
    
    int finalRestTime = [self convertRestTimeToSecondsFrom: strRestTime];
    
    NSDate *restTimerStartDate = [NSDate date];
    NSDate *restTimerEndDate = [NSDate dateWithTimeInterval: finalRestTime sinceDate: [NSDate date]];
    
    [[NSUserDefaults standardUserDefaults] setValue: restTimerStartDate forKey: kREST_TIMER_START_TIME];
    [[NSUserDefaults standardUserDefaults] setValue: restTimerEndDate forKey: kREST_TIMER_END_TIME];
    
    NSTimeInterval time = [restTimerStartDate timeIntervalSinceDate: restTimerEndDate];
    NSLog(@"%f", time);
    
    if (finalRestTime > 0) {
        
        if ((finalRestTime % 60) == 0) {
            finalRestTime -= 1;
        }
        
        [self startRecord];
        
        NSLog(@"Progress Value : %f", _progressBarRestScreenView.value);
        
        [UIView animateWithDuration: finalRestTime delay: 0 options: UIViewAnimationOptionCurveLinear animations:^{
            
            self->_isRestTimerRunning = @"YES";
            //            self->isRestScreenSettingButtonClicked = @"YES";
            [[NSUserDefaults standardUserDefaults] setValue: @"YES" forKey: kREST_TIMER_STATUS];
            
            [self->_progressBarRestScreenView setValue: 100.0];
            
        } completion: ^(BOOL success){
            
            NSLog(@"Completion Timer : %@", self->_timerRest);
            //            NSLog(@"Current VC : %@", self->currentVC);
            
            UIApplicationState appState = [[UIApplication sharedApplication] applicationState];
            
            if (appState == UIApplicationStateBackground) {
                NSLog(@"Background...");
                
            } else {
                
                if ([[[NSUserDefaults standardUserDefaults] valueForKey: kREST_TIMER_STATUS] isEqualToString: @"NO"]) {
                    
                    [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: kREST_TIMER_STATUS];
                    self->_isRestTimerRunning = @"NO";
                    [self->_progressBarRestScreenView setValue: 0.0];
                    //                    [self->_btnSetScreenRestButton setEnabled: YES];
                    
                    //                    int nextSetCount = [[[NSUserDefaults standardUserDefaults] valueForKey: kSET_COUNT] intValue];
                    //                    [[NSUserDefaults standardUserDefaults] setValue: [NSString stringWithFormat: @"%d", (nextSetCount + 1)] forKey: kSET_COUNT];
                    
                    self->isSetScreen = @"YES";
                    [self->_btnStartRestButton setUserInteractionEnabled: YES];
                    [self toogleSetAndRestScreens];
                    [self initializeSetScreenData];
                    //                    [self showRestViewController];
                    
                } else {
                    
                    NSComparisonResult result = [[NSDate date] compare: [[NSUserDefaults standardUserDefaults] valueForKey: kREST_TIMER_END_TIME]];
                    
                    if (result == NSOrderedAscending) {
                        self->_isRestTimerRunning = @"YES";
                    } else {
                        [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: kREST_TIMER_STATUS];
                        self->_isRestTimerRunning = @"NO";
                        [self->_progressBarRestScreenView setValue: 0.0];
                        //                        [self->_btnSetScreenRestButton setEnabled: YES];
                        //                        [self showRestViewController];
                        
                        //                        int nextSetCount = [[[NSUserDefaults standardUserDefaults] valueForKey: kSET_COUNT] intValue];
                        //                        [[NSUserDefaults standardUserDefaults] setValue: [NSString stringWithFormat: @"%d", (nextSetCount + 1)] forKey: kSET_COUNT];
                        
                        self->isSetScreen = @"YES";
                        [self->_btnStartRestButton setUserInteractionEnabled: YES];
                        [self toogleSetAndRestScreens];
                        [self initializeSetScreenData];
                        
                    }
                }
            }
        }];
    }
    
}

- (void)startRecord {
    
    NSLog(@"Current Min : %d", currentRestTimeMinutes);
    NSLog(@"Current Sec : %d", currentRestTimeSeconds);
    
    timeMin = currentRestTimeMinutes;
    timeSec = currentRestTimeSeconds;
    
    if (timeSec == 0) {
        timeSec = 59;
        timeMin -= 1;
    }
    
    if (timeMin == 0 && timeSec <= 10) {
        [_lblRestTimerMinutesLabel setTextColor: cRED_TEXT];
        [_lblRestTimerColonLabel setTextColor: cRED_TEXT];
        [_lblRestTimerSecondsLabel setTextColor: cRED_TEXT];
    } else {
        [_lblRestTimerMinutesLabel setTextColor: [UIColor whiteColor]];
        [_lblRestTimerColonLabel setTextColor: [UIColor whiteColor]];
        [_lblRestTimerSecondsLabel setTextColor: [UIColor whiteColor]];
    }
    
    //String format 00:00
    //NSString *timeNow = [NSString stringWithFormat:@"%02d:%02d", timeMin, timeSec];
    [_lblRestTimerSecondsLabel setText: [NSString stringWithFormat: @"%02d", timeSec]];
    [_lblRestTimerMinutesLabel setText: [NSString stringWithFormat: @"%02d", timeMin]];
    //[_lblRestScreenSetCountLabel setText: timeNow];
    
    if (_timerRest == nil) {
        if ([_timerRest isValid]) {
            [_timerRest invalidate];
            [timerForRest reset];
        }
        
        NSString *strRestTime = [[NSUserDefaults standardUserDefaults] valueForKey: kREST_TIME];
        
        int restTime = [self convertRestTimeToSecondsFrom: strRestTime];
        
        _timerRest = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        
        // Timer for handling rest time
        timerForRest = [[MZTimerLabel alloc] initWithLabel:[[UILabel alloc] init] andTimerType:MZTimerLabelTypeTimer];
        [timerForRest setCountDownTime:restTime];
        [timerForRest setTimeFormat:@"mm:ss"];
        [timerForRest start];
        [timerForRest setResetTimerAfterFinish:YES];
                
        [[NSRunLoop currentRunLoop] addTimer: _timerRest forMode: NSRunLoopCommonModes];
    }
    
}

- (void)timerFired:(NSTimer *)sender {
    
    // Get remaining time and convert into second and minute
    NSTimeInterval remainTime = [timerForRest getTimeRemaining];
    NSLog(@"Counting: %d",timerForRest.counting);
    int rounded = roundf(remainTime);
    timeSec = rounded % 60;
    timeMin = (rounded / 60) % 60;
    
    if (rounded == 0 || rounded < 0 || ![timerForRest counting]) {
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey: kPLAY_SOUND] isEqualToString: @"YES"]) {
            if ([[[NSUserDefaults standardUserDefaults] valueForKey: kIS_SOUND_ON] isEqualToString: @"YES"]) {
                AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, nil);
            }
        }
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey: kIS_NEXT_EXERCISE_BUTTON_CLICKED] isEqualToString: @"YES"]) {
            
            NSString *strCurrentExerciseCount = [[NSUserDefaults standardUserDefaults] valueForKey: kTOTAL_EXERCISE_COUNT];
            NSInteger currentExerciseCount = [strCurrentExerciseCount integerValue] + 1;
            [[NSUserDefaults standardUserDefaults] setValue: [NSString stringWithFormat: @"%ld", (long)currentExerciseCount] forKey: kTOTAL_EXERCISE_COUNT];
            [_lblExerciseCountLabel setText: [NSString stringWithFormat: @"%ld.", (long)currentExerciseCount]];
            
            [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: kIS_NEXT_EXERCISE_BUTTON_CLICKED];
        }
        
        NSLog(@"Completed in Timer Count...");
        [[NSUserDefaults standardUserDefaults] setValue: @"00:00" forKey: kCURRENT_REST_TIME];
        [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: kREST_TIMER_STATUS];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _isRestTimerRunning = @"NO";
        
        self->isSetScreen = @"YES";
        [self->_btnStartRestButton setUserInteractionEnabled: YES];
        [self toogleSetAndRestScreens];
        [self initializeSetScreenData];
        
        [timerForRest reset];
        [_timerRest invalidate];
        _timerRest = nil;
        [[NSUserDefaults standardUserDefaults] setValue: @"00:00" forKey: kCURRENT_REST_TIME];
        [_lblRestTimerMinutesLabel setTextColor: [UIColor whiteColor]];
        [_lblRestTimerColonLabel setTextColor: [UIColor whiteColor]];
        [_lblRestTimerSecondsLabel setTextColor: [UIColor whiteColor]];
    } else {
        
        if ((timeMin == 0) && ((timeSec == 10) || (timeSec == 3) || (timeSec == 1))) {
            if ([[[NSUserDefaults standardUserDefaults] valueForKey: kIS_SOUND_ON] isEqualToString: @"YES"]) {
                NSLog(@"Sound Played...");
                [_audioPlayer play];
            }
        } else if ((timeMin == 0) && ((timeSec == 2) || (timeSec == 0))) {
            
            if ([[[NSUserDefaults standardUserDefaults] valueForKey: kIS_SOUND_ON] isEqualToString: @"YES"]) {
                NSLog(@"Sound Played...");
                [_audioPlayerSecond play];
            }
        }
        
        if (timeMin == 0 && timeSec <= 10) {
            
            [_lblRestTimerMinutesLabel setTextColor: cRED_TEXT];
            [_lblRestTimerColonLabel setTextColor: cRED_TEXT];
            [_lblRestTimerSecondsLabel setTextColor: cRED_TEXT];
            
        } else {
            [_lblRestTimerMinutesLabel setTextColor: [UIColor whiteColor]];
            [_lblRestTimerColonLabel setTextColor: [UIColor whiteColor]];
            [_lblRestTimerSecondsLabel setTextColor: [UIColor whiteColor]];
        }
        
        // String format 00:00
        NSString *timeNow = timerForRest.timeLabel.text;
        NSLog(@"Time now: %@",timeNow);
        
        // Store current time for generate notification
        [[NSUserDefaults standardUserDefaults] setValue:timeNow forKey:kTIME_NOW];
        
        // Get remaining rest time
        NSTimeInterval remainTime = [timerForRest getTimeRemaining];
        
        // Rounding and formatting remaining time
        int rounded = roundf(remainTime);
        NSString *timeFormatted = [self timeFormatted:rounded];
        
        // Store current rest time
        [[NSUserDefaults standardUserDefaults] setValue: timeFormatted forKey: kCURRENT_REST_TIME];
        
        int finalRestTime = [self convertBackgroundRestTimeToSecondsFrom: timeNow];
        
        NSTimeInterval selectedRestTime = [Utils convertRestTimeToSecondsFrom: [[NSUserDefaults standardUserDefaults] valueForKey: kREST_TIME]];
        
        CGFloat currentProgressBarValue = ((100 * (finalRestTime - 1)) / selectedRestTime);
        
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.progressBarRestScreenView setValue: (100 - currentProgressBarValue)];
        } completion:^(BOOL finished) {
        }];
        
        [_lblRestTimerSecondsLabel setText: [NSString stringWithFormat: @"%02d", timeSec]];
        [_lblRestTimerMinutesLabel setText: [NSString stringWithFormat: @"%02d", timeMin]];
        
        [[NSUserDefaults standardUserDefaults] setValue: @"YES" forKey: kREST_TIMER_STATUS];
        _isRestTimerRunning = @"YES";
    }

}

- (int) convertBackgroundRestTimeToSecondsFrom: (NSString *) restTime {
    
    NSArray *arrTimeComponents = [restTime componentsSeparatedByString: @":"];
    int minutes = [arrTimeComponents[0] intValue];
    int seconds = [arrTimeComponents[1] intValue];
    
    currentRestTimeMinutes = minutes;
    currentRestTimeSeconds = seconds;
    
    int totalSeconds = 0;
    
    if (minutes > 0) {
        totalSeconds += (minutes * 60);
    }
    
    if (seconds > 0) {
        totalSeconds += seconds;
    }
    
    return totalSeconds;
}

- (NSString *)timeFormatted:(int)totalSeconds {
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

- (void) startRestTimeTimer {
    
    if (!([Utils convertRestTimeToSecondsFrom: [[NSUserDefaults standardUserDefaults] valueForKey: kCURRENT_REST_TIME]] == 0)) {
        
        [self setupForRestScreenTimerAfterBackground];
        
    } else {
        
        [self setupProgressBar];
        
        [_progressBarRestScreenView setValue: 0.0];
        [_progressBarRestScreenView setMaxValue: 100.0];
        [_progressBarRestScreenView setProgressColor: cPROGRESS_BAR];
        [_progressBarRestScreenView setProgressStrokeColor: cPROGRESS_BAR];
        [_progressBarRestScreenView setProgressAngle: -100.0];
        [_progressBarRestScreenView setProgressRotationAngle: 50.0];
        [_progressBarRestScreenView setEmptyLineColor: cEMPTY_BAR];
        [_progressBarRestScreenView setEmptyLineStrokeColor: cEMPTY_BAR];
        
        if (IS_IPHONEXR) {
            [_progressBarRestScreenView setProgressLineWidth: 12.0];
            [_progressBarRestScreenView setEmptyLineWidth: 12.0];
        } else if (IS_IPHONEX) {
            [_progressBarRestScreenView setProgressLineWidth: 12.0];
            [_progressBarRestScreenView setEmptyLineWidth: 12.0];
        } else if (IS_IPHONE8PLUS) {
            [_progressBarRestScreenView setProgressLineWidth: 10.0];
            [_progressBarRestScreenView setEmptyLineWidth: 10.0];
        } else if (IS_IPHONE8) {
            [_progressBarRestScreenView setProgressLineWidth: 10.0];
            [_progressBarRestScreenView setEmptyLineWidth: 10.0];
        } else {
            [_progressBarRestScreenView setProgressLineWidth: 8.0];
            [_progressBarRestScreenView setEmptyLineWidth: 8.0];
        }
        
        [timerForRest reset];
        [_timerRest invalidate];
        _timerRest = nil;
        
        _isRestTimerRunning = @"NO";
        [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: kREST_TIMER_STATUS];
        [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: kPLAY_SOUND];
        
        //        int nextSetCount = [[[NSUserDefaults standardUserDefaults] valueForKey: kSET_COUNT] intValue];
        //        [[NSUserDefaults standardUserDefaults] setValue: [NSString stringWithFormat: @"%d", (nextSetCount + 1)] forKey: kSET_COUNT];
        
        self->isSetScreen = @"YES";
        [self->_btnStartRestButton setUserInteractionEnabled: YES];
        [self toogleSetAndRestScreens];
        [self initializeSetScreenData];
    }
}

- (void) setupForRestScreenTimerAfterBackground {
    NSString *strRestTime = [[NSUserDefaults standardUserDefaults] valueForKey: kCURRENT_REST_TIME];
    NSLog(@"Current Rest time8 : %@", strRestTime);
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey: kIS_FROM_LOCKED_DEVICE] isEqualToString: @"YES"]) {
        NSTimeInterval time = [Utils convertRestTimeToSecondsFrom: strRestTime];
        time += 2;
        strRestTime = [Utils stringFromTimeInterval: time];
    }
    
    int finalRestTime = [self convertBackgroundRestTimeToSecondsFrom: strRestTime];
    NSLog(@"final Rest time : %d", finalRestTime);
    
    NSTimeInterval selectedRestTime = [Utils convertRestTimeToSecondsFrom: [[NSUserDefaults standardUserDefaults] valueForKey: kREST_TIME]];
    NSLog(@"Selected Rest time : %f", selectedRestTime);
    
    CGFloat currentProgressBarValue;
    if ([[[NSUserDefaults standardUserDefaults] valueForKey: kREST_TIME] isEqual:@"00:05"]) {
        currentProgressBarValue = ((100 * (finalRestTime)) / selectedRestTime);
    } else {
        currentProgressBarValue = ((100 * (finalRestTime)) / selectedRestTime);
    }
    
    if (currentProgressBarValue == 0) {
        NSLog(@"Found Zero");
    }
    NSLog(@"Current progress : %f", currentProgressBarValue);
    
    [UIView performWithoutAnimation:^{
        [self->_progressBarRestScreenView setValue: (100 - currentProgressBarValue)];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        [self->_progressBarRestScreenView setValue: (100 - currentProgressBarValue)];
        NSLog(@"Current progress : %f", currentProgressBarValue);
        NSLog(@"final Rest time : %d", finalRestTime);
        
        if (finalRestTime > 0) {
            
            if ((finalRestTime % 60) == 0) {
                //finalRestTime -= 1;
            }
            
            [self startRecord];
            
            dispatch_async( dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration: finalRestTime - 0 delay: 0 options: UIViewAnimationOptionCurveLinear animations:^{
                    
                    NSLog(@"Running");
                    
                    self->_isRestTimerRunning = @"YES";
                    [[NSUserDefaults standardUserDefaults] setValue: @"YES" forKey: kREST_TIMER_STATUS];
                    
                    [self->_progressBarRestScreenView setValue: 100.0];
                    
                } completion: ^(BOOL success) {
                    
                    UIApplicationState appState = [[UIApplication sharedApplication] applicationState];
                    
                    if (appState == UIApplicationStateBackground) {
                        
                        NSLog(@"Background...");
                        
                    } else {
                        
                        if ([[[NSUserDefaults standardUserDefaults] valueForKey: kREST_TIMER_STATUS] isEqualToString: @"NO"]) {
                            NSLog(@"Completed in IF...");
                            [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: kREST_TIMER_STATUS];
                            self->_isRestTimerRunning = @"NO";
                            [self->_progressBarRestScreenView setValue: 0.0];
                            
                            self->isSetScreen = @"YES";
                            [self->_btnStartRestButton setUserInteractionEnabled: YES];
                            [self toogleSetAndRestScreens];
                            [self initializeSetScreenData];
                        } else {
                            NSComparisonResult result = [[NSDate date] compare: [[NSUserDefaults standardUserDefaults] valueForKey: kREST_TIMER_END_TIME]];
                            
                            if (result == NSOrderedAscending) {
                                NSLog(@"Ascending...");
                                self->_isRestTimerRunning = @"YES";
                            } else {
                                NSLog(@"Completed in ELSE...");
                                [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: kREST_TIMER_STATUS];
                                self->_isRestTimerRunning = @"NO";
                                [self->_progressBarRestScreenView setValue: 0.0];
                                
                                self->isSetScreen = @"YES";
                                [self->_btnStartRestButton setUserInteractionEnabled: YES];
                                [self toogleSetAndRestScreens];
                                [self initializeSetScreenData];
                            }
                        }
                    }
                }];
            });
        } else {
            
            self->isSetScreen = @"YES";
            [self->_btnStartRestButton setUserInteractionEnabled: YES];
            [self toogleSetAndRestScreens];
            [self initializeSetScreenData];
        }
    });
}

//MARK:- Total Time Count Methods

- (void) startTotalTimeTimer {
    
    NSString *strTotalTime = [[NSUserDefaults standardUserDefaults] valueForKey: kTOTAL_TIME];
    [self convertBackgroundTotalTimeToSecondsFrom: strTotalTime];
    [self startRecordingTotalTime];
    
}

- (int) convertTotalTimeToSecondsFrom: (NSString *) restTime {
    
    NSArray *arrTimeComponents = [restTime componentsSeparatedByString: @":"];
    int hours = [arrTimeComponents[0] intValue];
    int minutes = [arrTimeComponents[1] intValue];
    int seconds = [arrTimeComponents[2] intValue];
    
    totalCurrentHour = hours;
    totalCurrentMin = minutes;
    totalCurrentSec = seconds;
    
    int totalSeconds = 0;
    
    if (hours > 0) {
        totalSeconds += (hours * 3600);
    }
    
    if (minutes > 0) {
        totalSeconds += (minutes * 60);
    }
    
    if (seconds > 0) {
        totalSeconds += seconds;
    }
    
    return totalSeconds;
}

- (int) convertBackgroundTotalTimeToSecondsFrom: (NSString *) restTime {
    
    NSArray *arrTimeComponents = [restTime componentsSeparatedByString: @":"];
    int hours = [arrTimeComponents[0] intValue];
    int minutes = [arrTimeComponents[1] intValue];
    int seconds = [arrTimeComponents[2] intValue];
    
    totalCurrentHour = hours;
    totalCurrentMin = minutes;
    totalCurrentSec = seconds;
    
    int totalSeconds = 0;
    
    if (hours > 0) {
        totalSeconds += (hours * 3600);
    }
    
    if (minutes > 0) {
        totalSeconds += (minutes * 60);
    }
    
    if (seconds > 0) {
        totalSeconds += seconds;
    }
    
    return totalSeconds;
}


- (void) startRecordingTotalTime {
    
    totalTimeHour = totalCurrentHour;
    totalTimeMin = totalCurrentMin;
    totalTimeSec = totalCurrentSec;
    
    NSString *timeNow;
    if (totalTimeHour > 0) {
        //        [self setTotalTimeLabelFrameForHour: totalTimeHour];
        //String format 00:00:00
        timeNow = [NSString stringWithFormat:@"%02d:%02d:%02d", totalTimeHour, totalTimeMin, totalTimeSec];
        
        [_viewMinTimeContentView setHidden: YES];
        [_viewHoursTimeContentView setHidden: NO];
        [_lblHoursFirstLabel setText: [NSString stringWithFormat: @"%02d", totalTimeHour]];
        [_lblMinFirstLabel setText: [NSString stringWithFormat: @"%02d", totalTimeMin]];
        [_lblSecondsFirstLabel setText: [NSString stringWithFormat: @"%02d", totalTimeSec]];
        
    } else {
        //        [self setTotalTimeLabelFrameForHour: totalTimeHour];
        //String format 00:00
        timeNow = [NSString stringWithFormat:@"%02d:%02d", totalTimeMin, totalTimeSec];
        
        [_viewMinTimeContentView setHidden: NO];
        [_viewHoursTimeContentView setHidden: YES];
        [_lblMinSecondLabel setText: [NSString stringWithFormat: @"%02d", totalTimeMin]];
        [_lblSecondsSecondLabel setText: [NSString stringWithFormat: @"%02d", totalTimeSec]];
    }
    
    //    //String format 00:00
    //    NSString *timeNow = [NSString stringWithFormat:@"%02d:%02d", totalTimeMin, totalTimeSec];
    //    [_lblTotalTimeCountLabel setText: timeNow];
    
    if (_timerTotalTime == nil) {
        _timerTotalTime = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector(totalTimerFired:) userInfo: nil repeats: YES];
        [[NSRunLoop currentRunLoop] addTimer: _timerTotalTime forMode: NSRunLoopCommonModes];
    }
}

- (void)totalTimerFired:(NSTimer *) sender {
    
    totalTimeSec++;
    if (totalTimeSec == 60) {
        totalTimeSec = 0;
        totalTimeMin++;
    }
    
    if (totalTimeMin == 60) {
        totalTimeSec = 0;
        totalTimeMin = 0;
        totalTimeHour++;
    }
    
    NSString *timeNow;
    if (totalTimeHour > 0) {
        //String format 00:00:00
        timeNow = [NSString stringWithFormat:@"%02d:%02d:%02d", totalTimeHour, totalTimeMin, totalTimeSec];
        
        [_viewMinTimeContentView setHidden: YES];
        [_viewHoursTimeContentView setHidden: NO];
        [_lblHoursFirstLabel setText: [NSString stringWithFormat: @"%02d", totalTimeHour]];
        [_lblMinFirstLabel setText: [NSString stringWithFormat: @"%02d", totalTimeMin]];
        [_lblSecondsFirstLabel setText: [NSString stringWithFormat: @"%02d", totalTimeSec]];
        
    } else {
        //String format 00:00
        timeNow = [NSString stringWithFormat:@"%02d:%02d", totalTimeMin, totalTimeSec];
        
        [_viewMinTimeContentView setHidden: NO];
        [_viewHoursTimeContentView setHidden: YES];
        [_lblMinSecondLabel setText: [NSString stringWithFormat: @"%02d", totalTimeMin]];
        [_lblSecondsSecondLabel setText: [NSString stringWithFormat: @"%02d", totalTimeSec]];
    }
    
    NSString *totalTime = [NSString stringWithFormat:@"%02d:%02d:%02d", totalTimeHour, totalTimeMin, totalTimeSec];
    [[NSUserDefaults standardUserDefaults] setValue: totalTime forKey: kTOTAL_TIME];
    
    // Check Workout Time: If More Than 5 Min Then Save In UserDefalut
    if (totalTimeMin >= 5) {
        
        if ([NSUserDefaults.standardUserDefaults.dictionaryRepresentation.allKeys containsObject:kWORKOUT_START_TIME]) {
            
            NSMutableDictionary *currentWorkout = [[NSMutableDictionary alloc] init];
            NSString *workoutStartTime = [[NSUserDefaults standardUserDefaults] valueForKey: kWORKOUT_START_TIME];
            
            // Get existing stored data
            NSMutableArray *workoutData = [[Utils getWorkoutData] mutableCopy];
            
            // Add existing data dictionary
            for (NSMutableDictionary *data in workoutData) {
                [currentWorkout addEntriesFromDictionary:data];
            }
            
            // Add current workout data
            [currentWorkout setValue:[self getCurrentWorkoutData] forKey:workoutStartTime];
            
            // Add current and existing data in array
            workoutData = [[NSMutableArray alloc] init];
            [workoutData addObject:currentWorkout];
            
            // Store data in UserDefault
            [Utils setWorkoutData:workoutData];
            NSLog(@"%@",[Utils getWorkoutData]);
        }
    }
}

- (NSDictionary *)getCurrentWorkoutData {
    
    /*
     So every click on “rest”, or “next exercise” means +1 set
     - set 1-5 : 7% each
     - set 6-10 : 6% each
     - set 11-15 : 4% each
     - set 16-20 : 2% each
     - set 21-26 : 1% each
     - after set 26 = 100% reached
     */
    
    // Set workout quality data
    int setCount = 0;
    int workoutQuality = 0;
    
    if ([NSUserDefaults.standardUserDefaults.dictionaryRepresentation.allKeys containsObject:kQUALITY_SET_COUNT]) {
        setCount = [[[NSUserDefaults standardUserDefaults] valueForKey:kQUALITY_SET_COUNT] intValue];
    }
    
    // Workout quality calculation
    
    for (int i = 1; i <= setCount; i++) {
        if (i >= 1 && i <= 5) {
            workoutQuality = workoutQuality + 7;
            
        } else if (i >= 6 && i <= 10) {
            workoutQuality = workoutQuality + 6;
            
        } else if (i >= 11 && i <= 15) {
            workoutQuality = workoutQuality + 4;
            
        } else if (i >= 16 && i <= 20) {
            workoutQuality = workoutQuality + 2;
            
        } else if (i >= 21 && i <= 26) {
            workoutQuality = workoutQuality + 1;
            
        } else if (i >= 27) {
            workoutQuality = 100;
        }
        
        if (workoutQuality > 100) {
            workoutQuality = 100;
        }
    }
    
    NSString *totalTime = [[NSUserDefaults standardUserDefaults] valueForKey:kTOTAL_TIME];
    
    NSString *setCountString = [NSString stringWithFormat:@"%d",workoutQuality];
    
    NSString *totalExerciseCount = [[NSUserDefaults standardUserDefaults] valueForKey: kTOTAL_EXERCISE_COUNT];
    
    NSString *workoutStartTime = [[NSUserDefaults standardUserDefaults] valueForKey: kWORKOUT_START_TIME];
    
    // Setup exercise type
    int restTime = [Utils convertRestTimeToSecondsFrom: [[NSUserDefaults standardUserDefaults] valueForKey: kREST_TIME]];
    NSString *strExerciseType = [[NSString alloc] init];
    
    if (restTime < 60) {
        strExerciseType = @"Endurance";
    } else if (restTime >= 60 && restTime < 120) {
        strExerciseType = @"Muscle";
    } else if (restTime >= 120 && restTime <= 599) {
        strExerciseType = @"Strength";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd hh:mm:ss"];
    NSString *strCurrentDate = [dateFormatter stringFromDate: [NSDate date]];
    
    NSDictionary *workoutData = @{
        @"date" : strCurrentDate,
        @"excercise_total_time" : totalTime,
        @"total_exercise" : totalExerciseCount,
        @"exercise_type" : strExerciseType,
        @"workout_start_time" : workoutStartTime,
        @"workout_quality": setCountString
    };
    
    return workoutData;
}

//MARK:- Last exercise timer methods

- (void) startLastExerciseTimeTimer {
    
    NSString *strLastExerciseTime = [[NSUserDefaults standardUserDefaults] valueForKey: kLAST_EXERCISE_TIME];
        
    [self convertLastExerciseTimeToSecondsFrom: strLastExerciseTime];
    [self startRecordingLastExerciseTime];
    
}

- (int) convertLastExerciseTimeToSecondsFrom: (NSString *) exerciseTime {
    
    NSArray *arrTimeComponents = [exerciseTime componentsSeparatedByString: @":"];
    int hours = [arrTimeComponents[0] intValue];
    int minutes = [arrTimeComponents[1] intValue];
    int seconds = [arrTimeComponents[2] intValue];
    
    lastExerciseHour = hours;
    lastExerciseMin = minutes;
    lastExerciseSec = seconds;
    
    int totalSeconds = 0;
    
    if (hours > 0) {
        totalSeconds += (hours * 3600);
    }
    
    if (minutes > 0) {
        totalSeconds += (minutes * 60);
    }
    
    if (seconds > 0) {
        totalSeconds += seconds;
    }
    
    return totalSeconds;
}

- (void) startRecordingLastExerciseTime {
    
    //    totalTimeHour = totalCurrentHour;
    //    totalTimeMin = totalCurrentMin;
    //    totalTimeSec = totalCurrentSec;
    
    NSString *timeNow;
    if (lastExerciseHour > 0) {
        
        //String format 00:00:00
        timeNow = [NSString stringWithFormat:@"%02d:%02d:%02d", lastExerciseHour, lastExerciseMin, lastExerciseSec];
        [_lblSinceLastExerciseLabel setHidden:NO];
        [_viewLastExerciseMinuteFormat setHidden: YES];
        [_viewLastExerciseHoursFormat setHidden: NO];
        [_lblLastExerciseFirstHourLabel setText: [NSString stringWithFormat: @"%02d", lastExerciseHour]];
        [_lblLastExerciseFirstMinLabel setText: [NSString stringWithFormat: @"%02d", lastExerciseMin]];
        [_lblLastExerciseFirstSecLabel setText: [NSString stringWithFormat: @"%02d", lastExerciseSec]];
        
    } else {
        
        //String format 00:00
        timeNow = [NSString stringWithFormat:@"%02d:%02d", lastExerciseMin, lastExerciseSec];
        
        [_lblSinceLastExerciseLabel setHidden:NO];
        [_viewLastExerciseMinuteFormat setHidden: NO];
        [_viewLastExerciseHoursFormat setHidden: YES];
        [_lblLastExerciseSecondMinLabel setText: [NSString stringWithFormat: @"%02d", lastExerciseMin]];
        [_lblLastExerciseSecondSecLabel setText: [NSString stringWithFormat: @"%02d", lastExerciseSec]];
    }
    
    if (_timerLastExerciseTime == nil) {
        _timerLastExerciseTime = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector(lastExerciseTimerFired:) userInfo: nil repeats: YES];
        [[NSRunLoop currentRunLoop] addTimer: _timerLastExerciseTime forMode: NSRunLoopCommonModes];
    }
    
}

- (void) lastExerciseTimerFired: (NSTimer *) sender {
    
    lastExerciseSec++;
    if (lastExerciseSec == 60) {
        lastExerciseSec = 0;
        lastExerciseMin++;
    }
    
    if (lastExerciseMin == 60) {
        lastExerciseSec = 0;
        lastExerciseMin = 0;
        lastExerciseHour++;
    }
    
    NSString *timeNow;
    if (lastExerciseHour > 0) {
        
        //String format 00:00:00
        timeNow = [NSString stringWithFormat:@"%02d:%02d:%02d", lastExerciseHour, lastExerciseMin, lastExerciseSec];
        
        [_lblSinceLastExerciseLabel setHidden:NO];
        [_viewLastExerciseMinuteFormat setHidden: YES];
        [_viewLastExerciseHoursFormat setHidden: NO];
        [_lblLastExerciseFirstHourLabel setText: [NSString stringWithFormat: @"%02d", lastExerciseHour]];
        [_lblLastExerciseFirstMinLabel setText: [NSString stringWithFormat: @"%02d", lastExerciseMin]];
        [_lblLastExerciseFirstSecLabel setText: [NSString stringWithFormat: @"%02d", lastExerciseSec]];
        
    } else {
        
        //String format 00:00
        timeNow = [NSString stringWithFormat:@"%02d:%02d", lastExerciseMin, lastExerciseSec];
        
        [_lblSinceLastExerciseLabel setHidden:NO];
        [_viewLastExerciseMinuteFormat setHidden: NO];
        [_viewLastExerciseHoursFormat setHidden: YES];
        [_lblLastExerciseSecondMinLabel setText: [NSString stringWithFormat: @"%02d", lastExerciseMin]];
        [_lblLastExerciseSecondSecLabel setText: [NSString stringWithFormat: @"%02d", lastExerciseSec]];
    }
    
    self.lblTimeSince.text = timeNow;
    
    //DINAL-11-02-2020
    if(isNextExerciseStart){
        lastExerciseSec = 0;
        lastExerciseMin = 0;
        lastExerciseHour = 0;
        self.lblTimeSince.text = @"00:00";
        
        [[NSUserDefaults standardUserDefaults] setValue: @"00:00:00" forKey: kLAST_EXERCISE_TIME];

        isNextExerciseStart = NO;
    }
    
    NSString *time = [NSString stringWithFormat:@"%02d:%02d:%02d", lastExerciseHour, lastExerciseMin, lastExerciseSec];

    if(![[NSUserDefaults standardUserDefaults] boolForKey:kIsAppInBackGround]){
        [[NSUserDefaults standardUserDefaults] setValue: time forKey: kLAST_EXERCISE_TIME];
    }
}


//MARK:- AVAudioPlayer delegate's methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"played");
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"not played");
}

//MARK:- Service manager delegate and parser methods

- (void)callSaveExerciseAPI {
    NSString *strSetCount = [NSString stringWithFormat:@"%d",(int)self.vwQualityProgress.value];
    
    NSString *strTotalExercise = [[NSUserDefaults standardUserDefaults] valueForKey: kTOTAL_EXERCISE_COUNT];
    
    NSString *strWorkoutStartTime = [[NSUserDefaults standardUserDefaults] valueForKey: kWORKOUT_START_TIME];
    
    int restTime = [Utils convertRestTimeToSecondsFrom: [[NSUserDefaults standardUserDefaults] valueForKey: kREST_TIME]];
    NSString *strExerciseType = [[NSString alloc] init];
    if (restTime < 60) {
        strExerciseType = @"Endurance";
    } else if (restTime >= 60 && restTime < 120) {
        strExerciseType = @"Muscle";
    } else if (restTime >= 120 && restTime <= 599) {
        strExerciseType = @"Strength";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd hh:mm:ss"];
    NSString *strCurrentDate = [dateFormatter stringFromDate: [NSDate date]];
    
    NSDictionary *dicWorkoutsData = @{
        @"date" : strCurrentDate,
        @"excercise_total_time" : currentWorkoutTotalTime,
        @"total_exercise" : strTotalExercise,
        @"exercise_type" : strExerciseType,
        @"workout_start_time" : strWorkoutStartTime,
        @"workout_quality": strSetCount
    };
    NSLog(@"Parameter: %@",dicWorkoutsData);
    
    NSMutableArray *arrWorkoutsData = [[NSMutableArray alloc] init];
    [arrWorkoutsData addObject: dicWorkoutsData];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: arrWorkoutsData options: NSJSONWritingPrettyPrinted error: nil];
    NSString *jsonString = [[NSString alloc] initWithData: jsonData encoding: NSUTF8StringEncoding];
        
    NSDictionary *dicSaveExerciseParams = @{
        @"workout" : jsonString,
        @"user_id" : [dicUserDetails valueForKey: @"id"]
    };
    
    NSLog(@"Params : %@", dicSaveExerciseParams);
    
    if ([Utils isConnectedToInternet]) {
                
        [_btnDoneWorkoutButton setBackgroundColor: UIColor.whiteColor];
        [_btnDoneWorkoutButton setImage: nil forState: UIControlStateNormal];
        spinner = [Utils showActivityIndicatorInView: _btnDoneWorkoutButton withColor: cSTART_BUTTON];
        [[NSUserDefaults standardUserDefaults] setValue: @"YES" forKey: kIS_WORKOUTS_SAVED_ON_SERVER];
        
        NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uSAVE_EXERCISE];
        [serviceManager callWebServiceWithPOST: webpath withTag: tSAVE_EXERCISE paramsDic: dicSaveExerciseParams];
        
    } else {
        
//        NSMutableArray *arrPreWorkouts = [[NSMutableArray alloc] initWithArray: [Utils getUserWorkoutsData]];
//
//        NSMutableDictionary *dicCurrentWorkout = [[NSMutableDictionary alloc] init];
//
//        [dicCurrentWorkout setValue: [dicUserDetails valueForKey: @"id"] forKey: @"user_id"];
//        [dicCurrentWorkout setValue: [dicWorkoutsData valueForKey: @"date"] forKey: @"date"];
//        [dicCurrentWorkout setValue: [dicWorkoutsData valueForKey: @"excercise_total_time"] forKey: @"excercise_total_time"];
//        [dicCurrentWorkout setValue: [dicWorkoutsData valueForKey: @"total_exercise"] forKey: @"total_exercise"];
//        [dicCurrentWorkout setValue: [dicWorkoutsData valueForKey: @"exercise_type"] forKey: @"exercise_type"];
//        [dicCurrentWorkout setValue: [dicWorkoutsData valueForKey: @"workout_start_time"] forKey: @"workout_start_time"];
//        [dicCurrentWorkout setValue:strSetCount forKey:@"workout_quality"];
//        [dicCurrentWorkout setValue: @"YES" forKey: @"isOfflineWorkout"];
//
//        [arrPreWorkouts addObject: dicCurrentWorkout];
//
//        [Utils setUserWorkoutsData: arrPreWorkouts];
        
        [self goBackToWelcomeScreen];
        
//        if (APP_DELEGATE.timerSaveOfflineWorkouts == nil) {
//            [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: kIS_WORKOUTS_SAVED_ON_SERVER];
//            APP_DELEGATE.timerSaveOfflineWorkouts = [NSTimer scheduledTimerWithTimeInterval: 15.0 target: self selector: @selector(callSaveOfflineWorkoutsOnServer) userInfo: nil repeats: YES];
//            [[NSRunLoop currentRunLoop] addTimer: APP_DELEGATE.timerSaveOfflineWorkouts forMode: NSRunLoopCommonModes];
//            [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(callSaveOfflineWorkoutsOnServer) name: nSAVE_OFFLINE_WORKOUTS object: nil];
//        }
    }
    
}

- (void)callMakeProUserAPI {
    NSArray *arrSaveExerciseParams = @[
        @{ @"user_id" : [dicUserDetails valueForKey: @"id"]}
    ];
    
    NSLog(@"Dic : %@", arrSaveExerciseParams);
    
    if ([Utils isConnectedToInternet]) {
        NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uMAKE_PRO_USER];
        [serviceManager callWebServiceWithPOST: webpath withTag: tMAKE_PRO_USER params: arrSaveExerciseParams];
    }
}

- (void)callGetTotalWorkout {
    NSArray *params = @[
        @{ @"user_id" : [dicUserDetails valueForKey: @"id"]}
    ];
    
    NSLog(@"Dic : %@", params);
    
    if ([Utils isConnectedToInternet]) {
        NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uGET_TOTAL_WORKOUT];
        [serviceManager callWebServiceWithPOST: webpath withTag: tGET_TOTAL_WORKOUT params: params];
    }
}

- (void)callGetExerciseHistoryAPI {
    NSArray *arrSaveExerciseParams = @[
        @{ @"user_id" : [dicUserDetails valueForKey: @"id"]}
    ];
    
    NSLog(@"Dic : %@", arrSaveExerciseParams);
    
    if ([Utils isConnectedToInternet]) {
        NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uGET_EXERCISE_HISTORY];
        [serviceManager callWebServiceWithPOST: webpath withTag: tGET_EXERCISE_HISTORY params: arrSaveExerciseParams];
    }
}

- (void)parseGetTotalWorkout:(id)response {
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    NSLog(@"%@",dicResponse);
    
    NSString *workout = [dicResponse valueForKeyPath:@"data.total_workout"];
    if (workout != nil && workout.length > 1) {
        [Utils setTotalWorkout:workout];
    }
}

- (void)parseGetExerciseHistoryResponse:(id)response {
    
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    NSLog(@"%@",dicResponse);
    if ([[dicResponse valueForKey:@"status"] integerValue] == 1) {
        NSDictionary *dicUserStatsData = [[NSMutableDictionary alloc] initWithDictionary: [dicResponse valueForKey: @"data"]];
        NSLog(@"%@", dicUserStatsData);
        
        dicSkillAvarage = dicUserStatsData;
        [_lblRandomWorkoutCompleteSubTitle setAttributedText: [self getWorkoutCompleteLastPopupText]];
    } else {
        [Utils showToast: [dicResponse valueForKey: @"message"] duration: 3.0];
    }
}

// MARK:- Workout Complete last text
- (NSMutableAttributedString *) getWorkoutCompleteLastPopupText {
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    UIFont *font = [UIFont fontWithName:fFUTURA_CONDENSED_EXTRA_BOLD size:22.0];
    
    NSDictionary *attrsGreen = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, [UIColor colorWithRed:0.0/255.0 green:220.0/255.0 blue:93.0/255.0 alpha:1], NSForegroundColorAttributeName, nil];
    NSDictionary *attrsBack = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
    
    
    switch ([Utils getLastRandomWorkoutComplete]) {
        case 1:
            // 1. You trained on average `4.2 times per week` over the last month !
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @"You trained on average" attributes:attrsBack]];
            if ([[Utils getIsPaidUser] isEqualToString: @"YES"]) {
                [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@" %@ times per week", [dicSkillAvarage valueForKeyPath:@"skill.monthly.average"]] attributes:attrsGreen]];
            } else {
                [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @" ? times per week" attributes:attrsGreen]];
            }
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @" over the last month !" attributes:attrsBack]];
            break;
        case 2:
            // 2. The `average duration` of your workouts overall is `?` !
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @"The" attributes:attrsBack]];
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @" average duration" attributes:attrsGreen]];
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @" of your workouts overall is" attributes:attrsBack]];
            if ([[Utils getIsPaidUser] isEqualToString: @"YES"]) {
                [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@" %@", [dicSkillAvarage valueForKeyPath:@"average.total.time"]] attributes:attrsGreen]];
            } else {
                [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @" ?" attributes:attrsGreen]];
            }
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @" !" attributes:attrsBack]];
            break;
        case 3:
            // 3. You `trained ? days` during the last month !
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @"You" attributes:attrsBack]];
            if ([[Utils getIsPaidUser] isEqualToString: @"YES"]) {
                [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@" trained %@ days", [dicSkillAvarage valueForKeyPath:@"skill.monthly.total_workout"]] attributes:attrsGreen]];
            } else {
                [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @" trained ? days" attributes:attrsGreen]];
            }
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @" during the last month !" attributes:attrsBack]];
            break;
        case 4:
            // 4. You `trained ?h ?min ?sec in total` since you started using GymTimer !
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @"You" attributes:attrsBack]];
            if ([[Utils getIsPaidUser] isEqualToString: @"YES"]) {
                NSString *totalTime = [dicSkillAvarage valueForKeyPath:@"skill.total.total_time"];
                NSArray *separatedTime = [totalTime componentsSeparatedByString:@":"];
                
                int hours = [separatedTime[0] intValue];
                int minutes = [separatedTime[1] intValue];
                int sec = [separatedTime[2] intValue];
                
                [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@" trained %dh %dmin %dsec in total", hours, minutes, sec] attributes:attrsGreen]];
            } else {
                [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @" trained ?h ?min ?sec in total" attributes:attrsGreen]];
            }
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @" since you started using GymTimer !" attributes:attrsBack]];
            break;
        case 5:
            // 5. You did on average `? exercises per workout` last month !
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @"You did on average" attributes:attrsBack]];
            if ([[Utils getIsPaidUser] isEqualToString: @"YES"]) {
                [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@" %@ exercises per workout", [dicSkillAvarage valueForKeyPath:@"average.monthly.exercise"]] attributes:attrsGreen]];
            } else {
                [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @" ? exercises per workout" attributes:attrsGreen]];
            }
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @" last month !" attributes:attrsBack]];
            break;
        case 6:
            // 6. You `trained ? days` since you started using GymTimer !
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @"You" attributes:attrsBack]];
            if ([[Utils getIsPaidUser] isEqualToString: @"YES"]) {
                [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@" trained %@ days", [dicSkillAvarage valueForKeyPath:@"skill.total.total_workout"]] attributes:attrsGreen]];
            } else {
                [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @" trained ? days" attributes:attrsGreen]];
            }
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @" since you started using GymTimer !" attributes:attrsBack]];
            break;
        case 7:
            // 7. The `average duration` of your workouts over the last month is `?` !
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @"The" attributes:attrsBack]];
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @" average duration" attributes:attrsGreen]];
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @" of your workouts over the last month is" attributes:attrsBack]];
            if ([[Utils getIsPaidUser] isEqualToString: @"YES"]) {
                [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@" %@", [dicSkillAvarage valueForKeyPath:@"average.monthly.time"]] attributes:attrsGreen]];
            } else {
                [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @" ?" attributes:attrsGreen]];
            }
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @" !" attributes:attrsBack]];
            break;
        case 8:
            // 8. You trained on average `? times per week` since you use GymTimer !
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @"You trained on average" attributes:attrsBack]];
            if ([[Utils getIsPaidUser] isEqualToString: @"YES"]) {
                [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@" %@ times per week", [dicSkillAvarage valueForKeyPath:@"skill.total.average"]] attributes:attrsGreen]];
            } else {
                [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @" ? times per week" attributes:attrsGreen]];
            }
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @" since you use GymTimer !" attributes:attrsBack]];
            break;
        case 9:
            // 9. You `trained ?h ?min ?sec` in total during the last month !
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @"You" attributes:attrsBack]];
            if ([[Utils getIsPaidUser] isEqualToString: @"YES"]) {
                NSString *totalTime = [dicSkillAvarage valueForKeyPath:@"skill.monthly.total_time"];
                NSArray *separatedTime = [totalTime componentsSeparatedByString:@":"];
                
                int hours = [separatedTime[0] intValue];
                int minutes = [separatedTime[1] intValue];
                int sec = [separatedTime[2] intValue];
                
                [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@" trained %dh %dmin %dsec", hours, minutes, sec] attributes:attrsGreen]];
            } else {
                [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @" trained ?h ?min ?sec" attributes:attrsGreen]];
            }
            [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @" in total during the last month !" attributes:attrsBack]];
            break;
        default:
            break;
    }
    return attrString;
}


- (void)parseMakeProUser:(id)response {
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    NSLog(@"%@",dicResponse);
}

- (void) callSaveOfflineWorkoutsOnServer {
    
//    NSLog(@"Save offline workouts method called...");
//
//    if (([Utils isConnectedToInternet]) && ([[[NSUserDefaults standardUserDefaults] valueForKey: kIS_WORKOUTS_SAVED_ON_SERVER] isEqualToString: @"NO"]) && ([[Utils getUserWorkoutsData] count] > 0)) {
//
//        [[NSUserDefaults standardUserDefaults] setValue: @"YES" forKey: kIS_FOR_OFFLINE_SAVE];
//
//        NSMutableArray *arrOfflineWorkouts = [[NSMutableArray alloc] initWithArray: [self filterOfflineWorkoutsFrom: [Utils getUserWorkoutsData]]];
//
//        if ([arrOfflineWorkouts count] > 0) {
//
//            for (int i = 0; i < [arrOfflineWorkouts count]; i++) {
//
//                NSMutableDictionary *dicTemp = [arrOfflineWorkouts objectAtIndex: i];
//
//                NSDictionary *dicNew = @{
//                    @"date" : [dicTemp valueForKey: @"date"],
//                    @"excercise_total_time" : [dicTemp valueForKey: @"excercise_total_time"],
//                    @"total_exercise" : [dicTemp valueForKey: @"total_exercise"],
//                    @"exercise_type" : [dicTemp valueForKey: @"exercise_type"],
//                    @"workout_start_time" : [dicTemp valueForKey: @"workout_start_time"],
//                    @"workout_quality": [dicTemp valueForKey:@"workout_quality"]
//                };
//
//                [arrOfflineWorkouts replaceObjectAtIndex: i withObject: dicNew];
//            }
//
//            NSData *jsonData = [NSJSONSerialization dataWithJSONObject: arrOfflineWorkouts options: NSJSONWritingPrettyPrinted error: nil];
//            NSString *jsonString = [[NSString alloc] initWithData: jsonData encoding: NSUTF8StringEncoding];
//
//            NSDictionary *dicSaveExerciseParams = @{
//                @"workout" : jsonString,
//                @"user_id" : [dicUserDetails valueForKey: @"id"]
//            };
//
//            [serviceManager setDelegate: self];
//            [Utils callSaveOfflineWorkoutsAPI: [dicSaveExerciseParams mutableCopy] withDelegate: self];
//        }
//    }
}

- (NSMutableArray *) filterOfflineWorkoutsFrom: (NSMutableArray *) allWorkouts {
    
    NSMutableArray *arrTempWorkouts = [[NSMutableArray alloc] initWithArray: allWorkouts];
    
    NSPredicate *p = [NSPredicate predicateWithBlock:^BOOL(NSMutableDictionary *  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        
        return ([[evaluatedObject valueForKey: @"isOfflineWorkout"] isEqualToString: @"YES"]) ? true : false;
        
    }];
    
    arrTempWorkouts = [[arrTempWorkouts filteredArrayUsingPredicate: p] mutableCopy];
    return arrTempWorkouts;
}

- (void) webServiceCallFailure: (NSError *) error forTag: (NSString *) tagname {
    NSLog(@"Web service call fails : %@", [error localizedDescription]);
    [self hideLoaderView];
    [Utils hideActivityIndicator:spinner fromView:_btnDoneWorkoutButton];
    [Utils showToast: [error localizedDescription] duration: 3.0];
}

- (void) webServiceCallSuccess:(id) response forTag: (NSString *) tagname {
    
    if ([tagname isEqualToString: tSAVE_EXERCISE]) {
        [self parseSaveExerciseResponse: response];
    } else if ([tagname isEqualToString:tMAKE_PRO_USER]) {
        [self parseMakeProUser:response];
    } else if([tagname isEqualToString:tFRIEND_COUNT]) {
        [self parseFriendCountResponse:response];
    } else if ([tagname isEqualToString:tGET_TOTAL_WORKOUT]) {
        [self parseGetTotalWorkout:response];
    } else if ([tagname isEqualToString: tGET_EXERCISE_HISTORY]) {
        [self parseGetExerciseHistoryResponse: response];
    }
}

- (void) parseFriendCountResponse: (id) response {
    
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    //    NSLog(@"%@", dicResponse);
    
    if ([[dicResponse valueForKey:@"status"] integerValue] == 1) {
        //success
        NSDictionary *dic = [dicResponse valueForKey:@"data"];
        NSString *newFriendRequest = [dic valueForKey:@"new_request"];
        NSString *newRequestAccepted = [dic valueForKey:@"request_accept"];
        
        if ([newFriendRequest isEqualToString:@"1"] || ([newRequestAccepted isEqualToString:@"1"])) {
            //_vwNewRequest.hidden = NO;
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:HasNewNotification];
        } else {
            //_vwNewRequest.hidden = YES;
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:HasNewNotification];
            
        }
        
        //Setup Tab bar Badge
        [self showHideTabBarBadge];
    }
}

- (void)parseSaveExerciseResponse:(id) response {
    
    [self hideLoaderView];
    [Utils hideActivityIndicator:spinner fromView:_btnDoneWorkoutButton];
    
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    
    if([[dicResponse valueForKey:@"status"] integerValue] == 1) {
//    if ([[dicResponse valueForKey:@"status"] integerValue] == 1 && [dicResponse valueForKey: @"data"] != nil) {
        
        NSMutableArray *arrWorkoutsData = [[NSMutableArray alloc] initWithArray: [dicResponse valueForKey: @"data"]];
        
        // Remove workout data.
        [Utils setWorkoutData:[[NSMutableArray alloc] init]];
        
        for (int i = 0; i < [arrWorkoutsData count]; i++) {
            
            NSMutableDictionary *dicWorkout = [[NSMutableDictionary alloc] initWithDictionary: [arrWorkoutsData objectAtIndex: i]];
            [dicWorkout setValue: @"NO" forKey: @"isOfflineWorkout"];
            [arrWorkoutsData replaceObjectAtIndex: i withObject: dicWorkout];
        }
        
        [Utils setUserWorkoutsData: arrWorkoutsData];
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey: kIS_FOR_OFFLINE_SAVE] isEqualToString: @"YES"]) {
            [[NSUserDefaults standardUserDefaults] setValue: @"YES" forKey: kIS_WORKOUTS_SAVED_ON_SERVER];
            [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: kIS_FOR_OFFLINE_SAVE];
            APP_DELEGATE.timerSaveOfflineWorkouts = nil;
            [APP_DELEGATE.timerSaveOfflineWorkouts invalidate];
            [[NSNotificationCenter defaultCenter] removeObserver: self name: nSAVE_OFFLINE_WORKOUTS object: nil];
            [self.vwCongrats setHidden:YES];
        } else {
            [self goBackToWelcomeScreen];
            [self.vwCongrats setHidden:YES];
        }
        
    } else {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey: kIS_FOR_OFFLINE_SAVE] isEqualToString: @"YES"]) {
            [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: kIS_WORKOUTS_SAVED_ON_SERVER];
            [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: kIS_FOR_OFFLINE_SAVE];
            
            [self goBackToWelcomeScreen];
            [self.vwCongrats setHidden:YES];
        } else {
            [self goBackToWelcomeScreen];
            [self.vwCongrats setHidden:YES];
        }
    }
    
}

- (void)goBackToWelcomeScreen {
    
    [_btnDoneWorkoutButton setImage: [UIImage imageNamed: @"imgDoneGreen"] forState: UIControlStateNormal];
    
    [[NSUserDefaults standardUserDefaults] setValue: @"YES" forKey: @"isEndWOButtonClicked"];
    [[NSUserDefaults standardUserDefaults] setValue: @"00:00" forKey: kREST_TIME];
    [[NSUserDefaults standardUserDefaults] setValue: @"00:00:00" forKey: kTOTAL_TIME];
    [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: kPLAY_SOUND];
    [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: kREST_TIMER_STATUS];
    [[NSUserDefaults standardUserDefaults] setValue: @"0" forKey: kTOTAL_EXERCISE_COUNT];
    
    //    [self toogleSetAndRestScreens];
//    [self->_scrollViewWorkoutScreen setFrame: CGRectMake(DEVICE_WIDTH, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
    if (IS_IPHONEXR) {
        [self->_scrollViewWorkoutScreen setFrame: CGRectMake(0.0, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
    } else if (IS_IPHONEX) {
        [self->_scrollViewWorkoutScreen setFrame: CGRectMake(0.0, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
    } else if (IS_IPHONE8PLUS) {
        [self->_scrollViewWorkoutScreen setFrame: CGRectMake(0.0, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
    } else if (IS_IPHONE8) {
        [self->_scrollViewWorkoutScreen setFrame: CGRectMake(0.0, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
    } else {
        [self->_scrollViewWorkoutScreen setFrame: CGRectMake(0.0, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
    }
    
    // Slide left - Welcome back and home contents
    CGPoint viewWorkoutContentViewCenterPoint = self->_viewWorkoutContentView.center;
    [self->_viewWorkoutContentView setCenter:CGPointMake(self->_viewWorkoutContentView.center.x + UIScreen.mainScreen.bounds.size.width, self->_viewWorkoutContentView.center.y)];
    
    // Slide down - GymTimer Boost your workouts
    [self->_vw_gymtimer_boost_your_workouts setCenter:CGPointMake(self->_vw_gymtimer_boost_your_workouts.center.x, self->_vw_gymtimer_boost_your_workouts.center.y - self->_vw_gymtimer_boost_your_workouts.frame.size.height - 50)];
    
    [UIView animateWithDuration: 0.7 delay: 0.0 options: UIViewAnimationOptionTransitionNone animations:^{
        
        [self showTabBar];

        // Slide left - Welcome back and home contents
        [self->_viewWorkoutContentView setCenter:viewWorkoutContentViewCenterPoint];

        // Slide down - GymTimer Boost your workouts
        [self->_vw_gymtimer_boost_your_workouts setCenter:CGPointMake(self->_vw_gymtimer_boost_your_workouts.center.x, self->_vw_gymtimer_boost_your_workouts.center.y + self->_vw_gymtimer_boost_your_workouts.frame.size.height + 50)];
        
        if (IS_IPHONEXR) {
            [self->_scrollViewWorkoutCompleteScreen setFrame: CGRectMake(-DEVICE_WIDTH, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        } else if (IS_IPHONEX) {
            [self->_scrollViewWorkoutCompleteScreen setFrame: CGRectMake(-DEVICE_WIDTH, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        } else if (IS_IPHONE8PLUS) {
            [self->_scrollViewWorkoutCompleteScreen setFrame: CGRectMake(-DEVICE_WIDTH, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        } else if (IS_IPHONE8) {
            [self->_scrollViewWorkoutCompleteScreen setFrame: CGRectMake(-DEVICE_WIDTH, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        } else {
            [self->_scrollViewWorkoutCompleteScreen setFrame: CGRectMake(-DEVICE_WIDTH, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        }
        
    } completion:^(BOOL finished) {
        
        [self initializeStartWorkoutScreenData];
        [self->_scrollViewSetAndRestScreen setFrame: CGRectMake(DEVICE_WIDTH, -44.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
        [self->_scrollViewWorkoutCompleteScreen setFrame: CGRectMake(DEVICE_WIDTH, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
        
        if (IS_IPHONEXR) {
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: YES];
        } else if (IS_IPHONEX) {
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: YES];
        } else if (IS_IPHONE8PLUS) {
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: YES];
        } else if (IS_IPHONE8) {
            [self->_scrollViewSetAndRestScreen setFrame: CGRectMake(DEVICE_WIDTH, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT + 44.0)];
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, 0.0) animated: YES];
        } else {
            [self->_scrollViewSetAndRestScreen setContentOffset: CGPointMake(0.0, -44.0) animated: YES];
        }
        
    }];
    
    [UIView transitionWithView: _imgAppBackgroundImage duration: 0.3 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self->_imgAppBackgroundImage setImage: iWELCOME_SCREEN];
    } completion:^(BOOL finished) {}];
    
}

// MARK: - WCSession Delegate

- (void)session:(nonnull WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(nullable NSError *)error {
    
}

- (void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *,id> *)applicationContext {
    
}

@end

