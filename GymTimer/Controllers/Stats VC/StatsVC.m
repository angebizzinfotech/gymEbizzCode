//
//  StatsVC.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 09/12/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "StatsVC.h"

@interface StatsVC () <FSCalendarDelegate, FSCalendarDataSource, ServiceManagerDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    CAShapeLayer *cellBlackBorder;
    BOOL isBackClicked, isTimesAnimation, isDaysAnimation, isCalendarAnimation, isAverageAnimation;
    int timeMax, dayMax;
    CGFloat numberAnimation;
    NSMutableArray *arrWorkoutsDate;
    NSArray *arrSelectedDates, *arrShortMonthsName, *arrHours, *arrDays, *arrTime, *arrWeek;
    NSMutableDictionary *dicUserDetails, *dicUserStatsData, *dicUserWorkoutHashMap, *dicSkill, *dicAverage;
    ServiceManager *serviceManager;
    Utils *utils;
}

@end

@implementation StatsVC

// MARK:- View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialization];
    [self setupLayout];
    [self tabBarSetup];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupCalendar];
    });
    
    //Temp Vishnu
//    [Utils setIsPaidUser:@"YES"];
    
    if ([[Utils getIsPaidUser] isEqualToString: @"YES"]) {
        // API Calling if user is paid
        [self callGetExerciseHistoryAPI];
        [self.vwParent setHidden:YES];
        
    } else {
        [self.scrView setHidden:YES];
        
        UpgradeToProVC *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"UpgradeToProVC"];
        loginView.isStats = true;
        [self addChildViewController:loginView];

        [loginView.view setFrame:CGRectMake(0.0f, 0.0f, self.vwParent.frame.size.width, self.vwParent.frame.size.height)];
        [self.vwParent addSubview:loginView.view];
        [loginView didMoveToParentViewController:self];
    }
    
}

// MARK:- IBActions

- (IBAction)previousMonthAction:(UIButton *)sender {
    NSDate *currentMonth = self.workoutStatsCalender.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value: -1 toDate:currentMonth options:0];
    [self.workoutStatsCalender setCurrentPage:previousMonth animated:YES];
    
    [self updateMonthYearLabelWithDate: previousMonth];
}

- (IBAction)nextMonthAction:(UIButton *)sender {
    NSDate *currentMonth = self.workoutStatsCalender.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value: 1 toDate:currentMonth options:0];
    [self.workoutStatsCalender setCurrentPage:nextMonth animated:YES];
    
    [self updateMonthYearLabelWithDate: nextMonth];
}

- (IBAction)backToCalendarAction:(UIButton *)sender {
    isBackClicked = YES;
    
    [self.vwSingleDayQuality setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    self.vwSingleDayQuality.value = 0.0;
    
    self.vwSingleDayWorkout.alpha = 0.0;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.vwCalendar.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)skillInTotalAction:(UIButton *)sender {
    [self.btnInTotal setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.constVwSkillSlideX.constant = self.btnInTotal.frame.origin.x;
        [self.view layoutIfNeeded];
    }];
    
    UIColor *grayColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
    [self.btnYearly setTitleColor:grayColor forState:UIControlStateNormal];
    [self.btnMonthly setTitleColor:grayColor forState:UIControlStateNormal];
    [self.btnWeekly setTitleColor:grayColor forState:UIControlStateNormal];
    
    [self setSkillFilter:0];
}

- (IBAction)skillYearlyAction:(UIButton *)sender {
    [self.btnYearly setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.constVwSkillSlideX.constant = self.btnYearly.frame.origin.x;
        [self.view layoutIfNeeded];
    }];
    
    UIColor *grayColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
    [self.btnInTotal setTitleColor:grayColor forState:UIControlStateNormal];
    [self.btnMonthly setTitleColor:grayColor forState:UIControlStateNormal];
    [self.btnWeekly setTitleColor:grayColor forState:UIControlStateNormal];
    
    [self setSkillFilter:1];
}

- (IBAction)skillMonthlyAction:(UIButton *)sender {
    [self.btnMonthly setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.constVwSkillSlideX.constant = self.btnMonthly.frame.origin.x;
        [self.view layoutIfNeeded];
    }];
    
    UIColor *grayColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
    [self.btnInTotal setTitleColor:grayColor forState:UIControlStateNormal];
    [self.btnYearly setTitleColor:grayColor forState:UIControlStateNormal];
    [self.btnWeekly setTitleColor:grayColor forState:UIControlStateNormal];
    
    [self setSkillFilter:2];
}

- (IBAction)skillWeeklyAction:(UIButton *)sender {
    [self.btnWeekly setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.constVwSkillSlideX.constant = self.btnWeekly.frame.origin.x;
        [self.view layoutIfNeeded];
    }];
    
    UIColor *grayColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
    [self.btnInTotal setTitleColor:grayColor forState:UIControlStateNormal];
    [self.btnYearly setTitleColor:grayColor forState:UIControlStateNormal];
    [self.btnMonthly setTitleColor:grayColor forState:UIControlStateNormal];
    
    [self setSkillFilter:3];
}

- (IBAction)avgInTotalAction:(UIButton *)sender {
    [self.btnAvgInTotal setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.constVwAvgSlideX.constant = self.btnAvgInTotal.frame.origin.x;
        [self.view layoutIfNeeded];
    }];
    
    UIColor *grayColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
    [self.btnAvgYearly setTitleColor:grayColor forState:UIControlStateNormal];
    [self.btnAvgMonthly setTitleColor:grayColor forState:UIControlStateNormal];
    [self.btnAvgWeekly setTitleColor:grayColor forState:UIControlStateNormal];
    
    [self setAverageFilter:0];
}

- (IBAction)avgYearlyAction:(UIButton *)sender {
    [self.btnAvgYearly setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.constVwAvgSlideX.constant = self.btnAvgYearly.frame.origin.x;
        [self.view layoutIfNeeded];
    }];
    
    UIColor *grayColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
    [self.btnAvgInTotal setTitleColor:grayColor forState:UIControlStateNormal];
    [self.btnAvgMonthly setTitleColor:grayColor forState:UIControlStateNormal];
    [self.btnAvgWeekly setTitleColor:grayColor forState:UIControlStateNormal];
    
    [self setAverageFilter:1];
}

- (IBAction)avgMonthlyAction:(UIButton *)sender {
    [self.btnAvgMonthly setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.constVwAvgSlideX.constant = self.btnAvgMonthly.frame.origin.x;
        [self.view layoutIfNeeded];
    }];
    
    UIColor *grayColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
    [self.btnAvgInTotal setTitleColor:grayColor forState:UIControlStateNormal];
    [self.btnAvgYearly setTitleColor:grayColor forState:UIControlStateNormal];
    [self.btnAvgWeekly setTitleColor:grayColor forState:UIControlStateNormal];
    
    [self setAverageFilter:2];
}

- (IBAction)avgWeeklyAction:(UIButton *)sender {
    [self.btnAvgWeekly setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.constVwAvgSlideX.constant = self.btnAvgWeekly.frame.origin.x;
        [self.view layoutIfNeeded];
    }];
    
    UIColor *grayColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
    [self.btnAvgInTotal setTitleColor:grayColor forState:UIControlStateNormal];
    [self.btnAvgYearly setTitleColor:grayColor forState:UIControlStateNormal];
    [self.btnAvgMonthly setTitleColor:grayColor forState:UIControlStateNormal];
    
    [self setAverageFilter:3];
}

// MARK:- Custom Methods

- (void)initialization {
    
    // Hide your skill level detail when data is loading
    [self.vwShowHide setHidden:NO];
    [self.vwShowHide1 setHidden:NO];
    
    numberAnimation = 0.5;
    
    timeMax = 1;
    dayMax = 1;
    
    isTimesAnimation = YES;
    isDaysAnimation = YES;
    isCalendarAnimation = YES;
    isAverageAnimation = YES;
    
    serviceManager = [[ServiceManager alloc] init];
    [serviceManager setDelegate: self];
    
    utils = [[Utils alloc] init];
    
    dicUserDetails = [[NSMutableDictionary alloc] initWithDictionary: [Utils getUserDetails]];
    
    arrSelectedDates = @[@"02", @"05", @"07", @"08", @"10", @"11", @"13", @"16", @"19", @"21", @"22", @"23", @"25", @"26"];
    
    arrShortMonthsName = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"];
    
    arrHours = @[@"00 - 06h", @"06 - 08h", @"08 - 10h", @"10 - 12h", @"12 - 14h", @"14 - 16h", @"16 - 18h", @"18 - 20h", @"20 - 22h", @"22 - 00h"];
    
    arrDays = @[@"M", @"T", @"W", @"T", @"F", @"S", @"S"];
    
    // Remove Existing Observer and Add New
    [NSNotificationCenter.defaultCenter removeObserver:SelectTab];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(changeViewController) name:SelectTab object:nil];
}

- (void)setupLayout {
        
    isBackClicked = NO;
    
    self.vwProgress1.layer.cornerRadius = self.vwProgress1.frame.size.height / 2;
    self.vwProgress2.layer.cornerRadius = self.vwProgress2.frame.size.height / 2;
    self.vwProgress3.layer.cornerRadius = self.vwProgress3.frame.size.height / 2;
    self.vwProgress4.layer.cornerRadius = self.vwProgress4.frame.size.height / 2;
    self.vwProgress5.layer.cornerRadius = self.vwProgress5.frame.size.height / 2;
        
    // Setup Circle Progress
    self.vwQuality.valueFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
    self.vwQuality.valueFontSize = 32;
    self.vwQuality.fontColor = cNEW_GREEN;
    self.vwQuality.unitFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
    self.vwQuality.unitFontSize = 18;
    
    self.vwSingleDayQuality.valueFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
    self.vwSingleDayQuality.valueFontSize = 32;
    self.vwSingleDayQuality.fontColor = cNEW_GREEN;
    self.vwSingleDayQuality.unitFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
    self.vwSingleDayQuality.unitFontSize = 18;
    
    // Filter Setup
    self.vwFilter.layer.cornerRadius = 12;
    self.vwAvgFilter.layer.cornerRadius = 12;
    
    self.vwSkillSlide.layer.cornerRadius = 11.5;
    self.vwAvgSlide.layer.cornerRadius = 11.5;
    
    [self.btnInTotal setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnAvgInTotal setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    // Days CollectionView Layout
    dispatch_async(dispatch_get_main_queue(), ^{
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((self.clvDaysOfWeek.frame.size.width - 40) / 7, self.clvDaysOfWeek.frame.size.height);
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        self.clvDaysOfWeek.collectionViewLayout = layout;
    });
    
    // Set Collectionview Edge Inset
    self.clvDaysOfWeek.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    
    // Set Blank Footer View
    self.tblTimesOfDay.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Set View Radius
    self.vwYourSkill.layer.cornerRadius = 30;
    self.vwYourSkill.clipsToBounds = YES;
    
    self.vwTimes.layer.cornerRadius = 30;
    self.vwTimes.clipsToBounds = YES;
    
    self.vwCalendar.layer.cornerRadius = 30;
    self.vwCalendar.clipsToBounds = YES;
    
    self.vwAverageWorkout.layer.cornerRadius = 30;
    self.vwAverageWorkout.clipsToBounds = YES;
    
    self.vwSingleDayWorkout.layer.cornerRadius = 30;
    self.vwSingleDayWorkout.clipsToBounds = YES;
    
    self.vwDays.layer.cornerRadius = 30;
    self.vwDays.clipsToBounds = YES;
    
    // Set counting label format
    [self.lblTrainedHour setFormat:@"%.2d"];
    [self.lblTrainedMin setFormat:@"%.2d"];
    [self.lblTrainedSec setFormat:@"%.2d"];
    [self.lblAverageMin setFormat:@"%d"];
    [self.lblAverageSec setFormat:@"%d"];
    [self.lblWorkout setFormat:@"%.2d"];
    [self.lblWorkoutHours setFormat:@"%.2d"];
    [self.lblWorkoutMin setFormat:@"%.2d"];
    [self.lblWorkoutSec setFormat:@"%.2d"];
    [self.lblExerciseDone setFormat:@"%.2d"];
    [self.lblSingleDayHours setFormat:@"%.2d"];
    [self.lblSingleDayMin setFormat:@"%.2d"];
    [self.lblSingleDaySec setFormat:@"%.2d"];
    [self.lblSingleDayExercise setFormat:@"%.2d"];
    
    // Setup Cell Black Border
    cellBlackBorder = [CAShapeLayer layer];
    cellBlackBorder.strokeColor = [UIColor blackColor].CGColor;
    cellBlackBorder.lineWidth = 1.5;
    cellBlackBorder.fillColor = nil;
    
//    if (IS_IPHONEXR) {
//        cellBlackBorder.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(6.8, 0.5, 30.4, 30.4) cornerRadius:20].CGPath;
//    } else if (IS_IPHONEX) {
//        cellBlackBorder.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(5.3, 0.5, 30.4, 30.4) cornerRadius:20].CGPath;
//    } else if (IS_IPHONE8PLUS) {
//        cellBlackBorder.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(6.8, 0.5, 30.4, 30.4) cornerRadius:20].CGPath;
//    } else if (IS_IPHONE8) {
//        cellBlackBorder.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(5.3, 0.5, 30.4, 30.4) cornerRadius:20].CGPath;
//    } else {
//        cellBlackBorder.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(4.8, 0.5, 30.4, 30.4) cornerRadius:20].CGPath;
//    }
    
    // Adjust layout for small device
    if (IS_IPHONE5s) {
        self.workoutCalendarLeading.constant = 0;
        self.workoutCalendarTrailing.constant = 0;
        
        self.lblHourTitle.font = [UIFont fontWithName:fFUTURA_CONDENSED_EXTRA_BOLD size:25.0];
        self.lblMinTitle.font = [UIFont fontWithName:fFUTURA_CONDENSED_EXTRA_BOLD size:25.0];
        self.lblSecTitle.font = [UIFont fontWithName:fFUTURA_CONDENSED_EXTRA_BOLD size:20.0];
        
        self.lblTrainedHour.font = [UIFont fontWithName:fFUTURA_CONDENSED_EXTRA_BOLD size:25.0];
        self.lblTrainedMin.font = [UIFont fontWithName:fFUTURA_CONDENSED_EXTRA_BOLD size:25.0];
        self.lblTrainedSec.font = [UIFont fontWithName:fFUTURA_CONDENSED_EXTRA_BOLD size:25.0];
        
        // Set Collectionview Edge Inset
        self.clvDaysOfWeek.contentInset = UIEdgeInsetsMake(0, 9.5, 0, 9.5);
    }
}

- (void)tabBarSetup {
    UITabBarItem *tabBarItem0 = [self.tabBarController.tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem1 = [self.tabBarController.tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem2 = [self.tabBarController.tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem3 = [self.tabBarController.tabBar.items objectAtIndex:3];
    
    if (@available(iOS 13.0, *)){
        if (IS_IPHONEXR || IS_IPHONEX ) {
            [tabBarItem0 setTitlePositionAdjustment: UIOffsetMake(15.0, 12.0)];
            [tabBarItem1 setTitlePositionAdjustment: UIOffsetMake(3.0, 12.0)];
            [tabBarItem2 setTitlePositionAdjustment: UIOffsetMake(-3.0, 12.0)];
            [tabBarItem3 setTitlePositionAdjustment: UIOffsetMake(-15.0, 12.0)];
        } else if (IS_IPHONE8PLUS) {
            
            // Vsn - 13/03/2020
            [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - 75.0), DEVICE_WIDTH, 75.0)];
//            [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - 68.0), DEVICE_WIDTH, 68.0)];
            
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
        if (IS_IPHONEXR || IS_IPHONEX ) {
            [tabBarItem0 setTitlePositionAdjustment: UIOffsetMake(15.0, 12.0)];
            [tabBarItem1 setTitlePositionAdjustment: UIOffsetMake(3.0, 12.0)];
            [tabBarItem2 setTitlePositionAdjustment: UIOffsetMake(-3.0, 12.0)];
            [tabBarItem3 setTitlePositionAdjustment: UIOffsetMake(-15.0, 12.0)];
        } else if (IS_IPHONE8PLUS) {
            // Vsn - 13/03/2020
            [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - 75.0), DEVICE_WIDTH, 75.0)];
            // [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - 68.0), DEVICE_WIDTH, 68.0)];
            
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
}

- (void)setupCalendar {
    self.workoutStatsCalender = [[FSCalendar alloc] initWithFrame: CGRectMake(0, 0, self.workoutCalendar.frame.size.width, self.workoutCalendar.frame.size.height)];
    
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    
    [self.workoutStatsCalender registerClass: [FSCalendarCell class] forCellReuseIdentifier: @"WorkoutStatsCell"];
    
    self.workoutStatsCalender.dataSource = self;
    self.workoutStatsCalender.delegate = self;
    
    self.workoutStatsCalender.backgroundColor = [UIColor whiteColor];
    self.workoutStatsCalender.appearance.headerMinimumDissolvedAlpha = 0;
    UIFont *fontDate = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
    [self.workoutStatsCalender.appearance setTitleFont: fontDate];
    [self.workoutStatsCalender setHeaderHeight: 0.0];
    
    [self.workoutStatsCalender setFirstWeekday: 2];
    [self.workoutStatsCalender setAllowsSelection: YES];
    [self.workoutStatsCalender setAllowsMultipleSelection: NO];
    [[self.workoutStatsCalender calendarWeekdayView] setHidden: YES];
    self.workoutStatsCalender.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase;
    self.workoutStatsCalender.placeholderType = FSCalendarPlaceholderTypeNone;
    [self.workoutStatsCalender setScope: FSCalendarScopeMonth animated: NO];
    [self.workoutStatsCalender setScrollEnabled:YES];
    
    [self.workoutStatsCalender.appearance setTodayColor: UIColor.whiteColor];
    [[self.workoutStatsCalender appearance] setTitleTodayColor: UIColor.blackColor];
    
    if ([[Utils getIsPaidUser] isEqualToString: @"YES"]) {
        
    } else {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: @"yyyy-MM-dd"];
        NSDate *currentDate = [formatter dateFromString: @"2019-08-01"];
        [self.workoutStatsCalender setCurrentPage: currentDate];
    }
    
    [self.workoutCalendar addSubview: self.workoutStatsCalender];
    
    NSDate *currentMonth = self.workoutStatsCalender.currentPage;
    [self updateMonthYearLabelWithDate: currentMonth];
}

- (void)updateMonthYearLabelWithDate: (NSDate *) dateObj {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM"];
    NSString *monthString = [dateFormatter stringFromDate: dateObj];
    [self.lblMonth setText: [NSString stringWithFormat: @"%@", monthString]];
}

- (void)popAnimation:(FSCalendarCell *)cell {
    NSDate *date = [_workoutStatsCalender dateForCell:cell];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if ([[Utils getIsPaidUser] isEqualToString: @"YES"]) {
        [formatter setDateFormat: @"yyyy-MM-dd"];
        NSString *dayString = [formatter stringFromDate: date];
        
        if ([arrWorkoutsDate containsObject:dayString]) {
            [cell.shapeLayer setFillColor: cSTART_BUTTON.CGColor];
            [cell.titleLabel setTextColor: UIColor.whiteColor];
            
            POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
            sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
            sprintAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.7, 0.7)];
            sprintAnimation.springBounciness = 20.f;
            [cell pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
        }
    } else {
        NSDate *date = [_workoutStatsCalender dateForCell:cell];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat: @"dd"];
        NSString *dayString = [formatter stringFromDate: date];
        [formatter setDateFormat: @"yyyy-MM-dd"];
        
        //Dont show any green mark after August Month
        [formatter setLocale:[NSLocale currentLocale]];
        NSDate *augustDate = [formatter dateFromString:@"2019-08-31"];
        NSComparisonResult result = [augustDate compare:date];
        
        if (result == NSOrderedAscending || result == NSOrderedSame) {
        } else {
            if ([arrSelectedDates containsObject:dayString]) {
                [cell.shapeLayer setFillColor: cSTART_BUTTON.CGColor];
                [cell.titleLabel setTextColor: UIColor.whiteColor];
                
                POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
                sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
                sprintAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.7, 0.7)];
                sprintAnimation.springBounciness = 20.f;
                [cell pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
            } else {
            }
        }
    }
}

- (void)progressAnimationWithWorkoutQuality:(int)workoutQuality {
    
    if (workoutQuality > 100) {
        workoutQuality = 100;
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
    
    if (!isBackClicked) {
        
        [UIView animateWithDuration:animateFirst delay:0.3 options:UIViewAnimationOptionCurveLinear animations:^{
            if (!self->isBackClicked) {
                self.vwSingleDayQuality.value = valueFirst;
            } else {
                [UIView performWithoutAnimation:^{
                    self.vwSingleDayQuality.value = 0.0;
                }];
            }
            
        } completion:^(BOOL finished) {
            if (!self->isBackClicked) {
                [UIView animateWithDuration:animateSecond delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                    if (!self->isBackClicked) {
                        self.vwSingleDayQuality.value = valueFirst + valueSecond;
                    } else {
                        [UIView performWithoutAnimation:^{
                            self.vwSingleDayQuality.value = 0.0;
                        }];
                    }
                    
                } completion:^(BOOL finished) {
                    if (!self->isBackClicked) {
                        
                        // Spring animation effect if workout quality reach at 100
                        if (workoutQuality == 100) {
                            float delayedTime = animateThird - 0.6;
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayedTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                if (!self->isBackClicked) {
                                    [self springAnimation];
                                }
                            });
                        }
                        
                        [UIView animateWithDuration:animateThird delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                            if (!self->isBackClicked) {
                                self.vwSingleDayQuality.value = workoutQuality;
                            } else {
                                [UIView performWithoutAnimation:^{
                                    self.vwSingleDayQuality.value = 0.0;
                                }];
                            }
                        } completion:^(BOOL finished) {
                            if (!self->isBackClicked) {
                                if (workoutQuality == 100) {
                                    // Vibration
                                    AudioServicesPlaySystemSoundWithCompletion(1520, nil);
                                }
                            } else {
                                [UIView performWithoutAnimation:^{
                                    self.vwSingleDayQuality.value = 0.0;
                                }];
                            }
                            
                        }];
                    } else {
                        [UIView performWithoutAnimation:^{
                            self.vwSingleDayQuality.value = 0.0;
                        }];
                    }
                    
                }];
            } else {
                [UIView performWithoutAnimation:^{
                    self.vwSingleDayQuality.value = 0.0;
                }];
            }
            
        }];
    } else {
        [UIView performWithoutAnimation:^{
            self.vwSingleDayQuality.value = 0.0;
        }];
    }
}

- (void)springAnimation {
    
    if (!self->isBackClicked) {
        
        [self.vwSingleDayQuality setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
        
        [UIView animateWithDuration:0.27 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            if (!self->isBackClicked) {
                [self.vwSingleDayQuality setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
            } else {
                [UIView performWithoutAnimation:^{
                    [self.vwSingleDayQuality setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
                    self.vwSingleDayQuality.value = 0.0;
                }];
            }
            
        } completion:^(BOOL finished) {
            
            if (!self->isBackClicked) {
                [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:5.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    if (!self->isBackClicked) {
                        [self.vwSingleDayQuality setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
                        [self.view layoutIfNeeded];
                    } else {
                        [UIView performWithoutAnimation:^{
                            [self.vwSingleDayQuality setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
                            self.vwSingleDayQuality.value = 0.0;
                        }];
                    }
                    
                } completion:^(BOOL finished) {
                    [self.vwSingleDayQuality setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
                    [self.view layoutIfNeeded];
                }];
            } else {
                [UIView performWithoutAnimation:^{
                    [self.vwSingleDayQuality setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
                    self.vwSingleDayQuality.value = 0.0;
                }];
            }
            
        }];
        
    } else {
        [UIView performWithoutAnimation:^{
            [self.vwSingleDayQuality setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
            self.vwSingleDayQuality.value = 0.0;
        }];
    }
}

- (void)initializeSingleDayWorkoutViewData:(NSMutableDictionary *)workoutDetails {
    
    // Convert and Set Date
    NSString *workoutStartDate = [workoutDetails valueForKey:@"workout_start_time"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *workoutDate = [dateFormatter dateFromString:workoutStartDate];
    dateFormatter.dateFormat = @"dd. MMM yyyy, HH:mm";
    
    NSString *dateString = [dateFormatter stringFromDate:workoutDate];
    self.lblSelectedDate.text = dateString;
       
    // Set Duration And Exercises Done
    NSString *strTotalTime = [workoutDetails valueForKey: @"exercise_time"];
    NSArray *arrTimeComponents = [strTotalTime componentsSeparatedByString: @":"];
    
    CGFloat hours = [arrTimeComponents[0] floatValue];
    CGFloat minutes = [arrTimeComponents[1] floatValue];
    CGFloat seconds = [arrTimeComponents[2] floatValue];
    
    CGFloat exerciseDone = [[workoutDetails valueForKey:@"total_exercise"] floatValue];
        
    [self.lblSingleDayHours countFromZeroTo:hours withDuration:numberAnimation];
    [self.lblSingleDayMin countFromZeroTo:minutes withDuration:numberAnimation];
    [self.lblSingleDaySec countFromZeroTo:seconds withDuration:numberAnimation];
    [self.lblSingleDayExercise countFromZeroTo:exerciseDone withDuration:numberAnimation];
}

- (void)setupSkillData:(NSMutableDictionary *)dicSkill {
    // Set Skill Level
    int skillLevel = [[dicSkill valueForKeyPath:@"total.level"] intValue];
    self.lblLevel.text = [dicSkill valueForKeyPath:@"total.level"];
    
    self.lblUpcomingLevel.text = [NSString stringWithFormat:@"%d",(skillLevel + 1)];
    
    // Green Progress bar
    [self setSkillFilter:0];
    
    // Workout Complete
    [self.lblWorkout countFromZeroTo:[[dicSkill valueForKeyPath:@"total.total_workout"] floatValue] withDuration:numberAnimation];
        
    // Time Trained
    NSString *totalTime = [dicSkill valueForKeyPath:@"total.total_time"];
    NSArray *separatedTime = [totalTime componentsSeparatedByString:@":"];
    
    CGFloat hours = [separatedTime[0] floatValue];
    CGFloat minutes = [separatedTime[1] floatValue];
    CGFloat sec = [separatedTime[2] floatValue];
    
    [self.lblTrainedHour countFromZeroTo:hours withDuration:numberAnimation];
    [self.lblTrainedMin countFromZeroTo:minutes withDuration:numberAnimation];
    [self.lblTrainedSec countFromZeroTo:sec withDuration:numberAnimation];
    
    // Average Workout
    NSString *averageWorkout = [dicSkill valueForKeyPath:@"total.average"];
    NSArray *separatedWorkout = [averageWorkout componentsSeparatedByString:@"."];
    
    CGFloat avgMins = [separatedWorkout[0] floatValue];
    CGFloat avgSec = 0;
    if (separatedWorkout.count > 1) {
        avgSec = [separatedWorkout[1] floatValue];
    }
    
    [self.lblAverageMin countFromZeroTo:avgMins withDuration:numberAnimation];
    [self.lblAverageSec countFromZeroTo:avgSec withDuration:numberAnimation];
}

- (void)setupAverageData:(NSMutableDictionary *)dicAverage {
    if ([dicAverage.allKeys count] > 0) {
        // Workout Quality
        [self.vwQuality setValue:0];
        
        CGFloat quality = [[dicAverage valueForKeyPath:@"total.quantity"] floatValue];
        if (quality > 100) {
            quality = 100;
        }
        
        [UIView animateWithDuration:1.5 animations:^{
            [self.vwQuality setValue:quality];
        }];
        
        // Exercise Done
        CGFloat exerciseDone = [[dicAverage valueForKeyPath:@"total.exercise"] floatValue];
        [self.lblExerciseDone countFromZeroTo:exerciseDone withDuration:numberAnimation];
        
        // Duration
        NSString *duration = [dicAverage valueForKeyPath:@"total.time"];
        NSArray *separatedTime = [duration componentsSeparatedByString:@":"];
        
        CGFloat hours = [separatedTime[0] floatValue];
        CGFloat minutes = [separatedTime[1] floatValue];
        CGFloat sec = [separatedTime[2] floatValue];
        
        [self.lblWorkoutHours countFromZeroTo:hours withDuration:numberAnimation];
        [self.lblWorkoutMin countFromZeroTo:minutes withDuration:numberAnimation];
        [self.lblWorkoutSec countFromZeroTo:sec withDuration:numberAnimation];
    }
}

- (void)changeViewController {
    NSMutableArray *arrTabbarVC = [[[self tabBarController] viewControllers] mutableCopy];
    [arrTabbarVC replaceObjectAtIndex:2 withObject:GETCONTROLLER(@"StatsVC")];
    [[self tabBarController] setViewControllers: arrTabbarVC animated: NO];
}

- (void)setSkillFilter:(int) index {
   
    int skillLevel = 0;
    CGFloat workout = 0.0;
    NSString *totalTime = @"00:00:00";
    NSString *averageWorkout = @"0.0";
    
    if (index == 0) {
        
        // Skill Level
        skillLevel = [[dicSkill valueForKeyPath:@"total.level"] intValue];
        
        // Workout Complete
        workout = [[dicSkill valueForKeyPath:@"total.total_workout"] floatValue];
        
        // Time Trained
        totalTime = [dicSkill valueForKeyPath:@"total.total_time"];
        
        // Average Workout
        averageWorkout = [dicSkill valueForKeyPath:@"total.average"];

        // Set Green Progress Bars
        int result = ((int) workout % 5);
        [self animateProgress: result];
    } else if (index == 1) {
        
        // Skill Level
        skillLevel = [[dicSkill valueForKeyPath:@"yearly.level"] intValue];
        
        // Workout Complete
        workout = [[dicSkill valueForKeyPath:@"yearly.total_workout"] floatValue];
        
        // Time Trained
        totalTime = [dicSkill valueForKeyPath:@"yearly.total_time"];
        
        // Average Workout
        averageWorkout = [dicSkill valueForKeyPath:@"yearly.average"];
        
    } else if (index == 2) {
        
        // Skill Level
        skillLevel = [[dicSkill valueForKeyPath:@"monthly.level"] intValue];
        
        // Workout Complete
        workout = [[dicSkill valueForKeyPath:@"monthly.total_workout"] floatValue];
        
        // Time Trained
        totalTime = [dicSkill valueForKeyPath:@"monthly.total_time"];
        
        // Average Workout
        averageWorkout = [dicSkill valueForKeyPath:@"monthly.average"];
        
    } else if (index == 3) {
        
        // Skill Level
        skillLevel = [[dicSkill valueForKeyPath:@"weekly.level"] intValue];
        
        // Workout Complete
        workout = [[dicSkill valueForKeyPath:@"weekly.total_workout"] floatValue];
        
        // Time Trained
        totalTime = [dicSkill valueForKeyPath:@"weekly.total_time"];
        
        // Average Workout
        averageWorkout = [dicSkill valueForKeyPath:@"weekly.average"];
    }
        
    // Set Skill Level
    self.lblLevel.text = [NSString stringWithFormat:@"%d",skillLevel];
    self.lblUpcomingLevel.text = [NSString stringWithFormat:@"%d",skillLevel + 1];
        
    // Set Workout Complete
    [self.lblWorkout countFromZeroTo:workout withDuration:numberAnimation];
    
    // Set Time Trained
    NSArray *separatedTime = [totalTime componentsSeparatedByString:@":"];
    
    CGFloat hours = [separatedTime[0] floatValue];
    CGFloat minutes = [separatedTime[1] floatValue];
    CGFloat sec = [separatedTime[2] floatValue];
    
    [self.lblTrainedHour countFromZeroTo:hours withDuration:numberAnimation];
    [self.lblTrainedMin countFromZeroTo:minutes withDuration:numberAnimation];
    [self.lblTrainedSec countFromZeroTo:sec withDuration:numberAnimation];
    
    // Set Average Workout
    NSArray *separatedWorkout = [averageWorkout componentsSeparatedByString:@"."];
    
    CGFloat avgMins = [separatedWorkout[0] floatValue];
    
    CGFloat avgSec = 0;
    if (separatedWorkout.count > 1) {
        avgSec = [separatedWorkout[1] floatValue];
    }
    
    [self.lblAverageMin countFromZeroTo:avgMins withDuration:numberAnimation];
    [self.lblAverageSec countFromZeroTo:avgSec withDuration:numberAnimation];
}

- (void)setAverageFilter:(int)index {
    if (index == 0) {
        // Workout Quality
        [UIView performWithoutAnimation:^{
            [self.vwQuality setValue:0];
        }];
        
        CGFloat quality = [[dicAverage valueForKeyPath:@"total.quantity"] floatValue];
        if (quality > 100) {
            quality = 100;
        }
        
        [UIView animateWithDuration:1.5 animations:^{
            [self.vwQuality setValue:quality];
        }];
        
        // Exercise Done
        CGFloat exerciseDone = [[dicAverage valueForKeyPath:@"total.exercise"] floatValue];
        [self.lblExerciseDone countFromZeroTo:exerciseDone withDuration:numberAnimation];
        
        // Duration
        NSString *duration = [dicAverage valueForKeyPath:@"total.time"];
        NSArray *separatedTime = [duration componentsSeparatedByString:@":"];
        
        CGFloat hours = [separatedTime[0] floatValue];
        CGFloat minutes = [separatedTime[1] floatValue];
        CGFloat sec = [separatedTime[2] floatValue];
        
        [self.lblWorkoutHours countFromZeroTo:hours withDuration:numberAnimation];
        [self.lblWorkoutMin countFromZeroTo:minutes withDuration:numberAnimation];
        [self.lblWorkoutSec countFromZeroTo:sec withDuration:numberAnimation];
        
    } else if (index == 1) {
        
        // Workout Quality
        [UIView performWithoutAnimation:^{
            [self.vwQuality setValue:0];
        }];
        
        CGFloat quality = [[dicAverage valueForKeyPath:@"yearly.quantity"] floatValue];
        if (quality > 100) {
            quality = 100;
        }
        
        [UIView animateWithDuration:1.5 animations:^{
            [self.vwQuality setValue:quality];
        }];
        
        // Exercise Done
        CGFloat exerciseDone = [[dicAverage valueForKeyPath:@"yearly.exercise"] floatValue];
        [self.lblExerciseDone countFromZeroTo:exerciseDone withDuration:numberAnimation];
        
        // Duration
        NSString *duration = [dicAverage valueForKeyPath:@"yearly.time"];
        NSArray *separatedTime = [duration componentsSeparatedByString:@":"];
        
        CGFloat hours = [separatedTime[0] floatValue];
        CGFloat minutes = [separatedTime[1] floatValue];
        CGFloat sec = [separatedTime[2] floatValue];
        
        [self.lblWorkoutHours countFromZeroTo:hours withDuration:numberAnimation];
        [self.lblWorkoutMin countFromZeroTo:minutes withDuration:numberAnimation];
        [self.lblWorkoutSec countFromZeroTo:sec withDuration:numberAnimation];
        
    } else if (index == 2) {
        
        // Workout Quality
        [UIView performWithoutAnimation:^{
            [self.vwQuality setValue:0];
        }];
        
        CGFloat quality = [[dicAverage valueForKeyPath:@"monthly.quantity"] floatValue];
        if (quality > 100) {
            quality = 100;
        }
        
        [UIView animateWithDuration:1.5 animations:^{
            [self.vwQuality setValue:quality];
        }];
        
        // Exercise Done
        CGFloat exerciseDone = [[dicAverage valueForKeyPath:@"monthly.exercise"] floatValue];
        [self.lblExerciseDone countFromZeroTo:exerciseDone withDuration:numberAnimation];
        
        // Duration
        NSString *duration = [dicAverage valueForKeyPath:@"monthly.time"];
        NSArray *separatedTime = [duration componentsSeparatedByString:@":"];
        
        CGFloat hours = [separatedTime[0] floatValue];
        CGFloat minutes = [separatedTime[1] floatValue];
        CGFloat sec = [separatedTime[2] floatValue];
        
        [self.lblWorkoutHours countFromZeroTo:hours withDuration:numberAnimation];
        [self.lblWorkoutMin countFromZeroTo:minutes withDuration:numberAnimation];
        [self.lblWorkoutSec countFromZeroTo:sec withDuration:numberAnimation];
           
    } else if (index == 3) {
           
        // Workout Quality
        [UIView performWithoutAnimation:^{
            [self.vwQuality setValue:0];
        }];
        
        CGFloat quality = [[dicAverage valueForKeyPath:@"weekly.quantity"] floatValue];
        if (quality > 100) {
            quality = 100;
        }
        
        [UIView animateWithDuration:1.5 animations:^{
            [self.vwQuality setValue:quality];
        }];
        
        // Exercise Done
        CGFloat exerciseDone = [[dicAverage valueForKeyPath:@"weekly.exercise"] floatValue];
        [self.lblExerciseDone countFromZeroTo:exerciseDone withDuration:numberAnimation];
        
        // Duration
        NSString *duration = [dicAverage valueForKeyPath:@"weekly.time"];
        NSArray *separatedTime = [duration componentsSeparatedByString:@":"];
        
        CGFloat hours = [separatedTime[0] floatValue];
        CGFloat minutes = [separatedTime[1] floatValue];
        CGFloat sec = [separatedTime[2] floatValue];
        
        [self.lblWorkoutHours countFromZeroTo:hours withDuration:numberAnimation];
        [self.lblWorkoutMin countFromZeroTo:minutes withDuration:numberAnimation];
        [self.lblWorkoutSec countFromZeroTo:sec withDuration:numberAnimation];
    }
}

- (void)animateProgress:(int)workout {
    
    // Set Green Progress Bars
    int result = (workout % 5);
    NSMutableArray *arrProgress = [[NSMutableArray alloc] init];
    
    switch (result) {
        case 0:
            arrProgress = [[NSMutableArray alloc] initWithArray: @[@0.0, @0.0, @0.0, @0.0, @0.0]];
            break;
        case 1:
            arrProgress = [[NSMutableArray alloc] initWithArray: @[@1.0, @0.0, @0.0, @0.0, @0.0]];
            break;
        case 2:
            arrProgress = [[NSMutableArray alloc] initWithArray: @[@1.0, @1.0, @0.0, @0.0, @0.0]];
            break;
        case 3:
            arrProgress = [[NSMutableArray alloc] initWithArray: @[@1.0, @1.0, @1.0, @0.0, @0.0]];
            break;
        case 4:
            arrProgress = [[NSMutableArray alloc] initWithArray: @[@1.0, @1.0, @1.0, @1.0, @0.0]];
            break;
        case 5:
            arrProgress = [[NSMutableArray alloc] initWithArray: @[@1.0, @1.0, @1.0, @1.0, @1.0]];
            break;
        default:
            arrProgress = [[NSMutableArray alloc] initWithArray: @[@0.0, @0.0, @0.0, @0.0, @0.0]];
            break;
    }
    
    self.vwProgress1.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    self.vwProgress2.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    self.vwProgress3.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    self.vwProgress4.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    self.vwProgress5.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    
    CGFloat duration = 0.0;
    
    [UIView animateWithDuration:duration delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
        if ([arrProgress[0] floatValue] == 1.0) {
            self.vwProgress1.backgroundColor = [UIColor colorWithRed:20.0/255.0 green:204.0/255.0 blue:100.0/255.0 alpha:1.0];
        } else {
            self.vwProgress1.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
        }
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration delay:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
            if ([arrProgress[1] floatValue] == 1.0) {
                self.vwProgress2.backgroundColor = [UIColor colorWithRed:20.0/255.0 green:204.0/255.0 blue:100.0/255.0 alpha:1.0];
            } else {
                self.vwProgress2.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
            }
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:duration delay:0.25 options:UIViewAnimationOptionCurveLinear animations:^{
                if ([arrProgress[2] floatValue] == 1.0) {
                    self.vwProgress3.backgroundColor = [UIColor colorWithRed:20.0/255.0 green:204.0/255.0 blue:100.0/255.0 alpha:1.0];
                } else {
                    self.vwProgress3.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
                }
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:duration delay:0.3 options:UIViewAnimationOptionCurveLinear animations:^{
                    if ([arrProgress[3] floatValue] == 1.0) {
                        self.vwProgress4.backgroundColor = [UIColor colorWithRed:20.0/255.0 green:204.0/255.0 blue:100.0/255.0 alpha:1.0];
                    } else {
                        self.vwProgress4.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
                    }
                    
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:duration delay:0.35 options:UIViewAnimationOptionCurveLinear animations:^{
                        if ([arrProgress[4] floatValue] == 1.0) {
                            self.vwProgress5.backgroundColor = [UIColor colorWithRed:20.0/255.0 green:204.0/255.0 blue:100.0/255.0 alpha:1.0];
                        } else {
                            self.vwProgress5.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
                        }
                    } completion:^(BOOL finished) {
                    }];
                }];
            }];
        }];
    }];
}

// MARK:- API Calling

- (void)callGetExerciseHistoryAPI {
    NSArray *arrSaveExerciseParams = @[
        @{ @"user_id" : [dicUserDetails valueForKey: @"id"]}
    ];
    
    NSLog(@"Dic : %@", arrSaveExerciseParams);
    
    if ([Utils isConnectedToInternet]) {
        NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uGET_EXERCISE_HISTORY];
        [serviceManager callWebServiceWithPOST: webpath withTag: tGET_EXERCISE_HISTORY params: arrSaveExerciseParams];

    } else {
        [self.scrView setHidden:NO];
    }
}

// MARK:- API Response Parsing
- (void)parseGetExerciseHistoryResponse:(id)response {
    [self.scrView setHidden:NO];
    
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    NSLog(@"%@",dicResponse);
    if ([[dicResponse valueForKey:@"status"] integerValue] == 1) {
        
        [self.vwShowHide setHidden:YES];
        [self.vwShowHide1 setHidden:YES];
        
        dicUserStatsData = [[NSMutableDictionary alloc] initWithDictionary: [dicResponse valueForKey: @"data"]];
        
        // Set Skill Data
        dicSkill = [dicUserStatsData valueForKey:@"skill"];
        [self setupSkillData:dicSkill];
        
        // Set Average Workout Data
        dicAverage = [dicUserStatsData valueForKeyPath:@"average"];
        
        // For Times of the day
        arrTime = [dicUserStatsData valueForKeyPath:@"time.time_of_day"];
        timeMax = [[dicUserStatsData valueForKeyPath:@"time.max"] intValue];
        
        // For Days of the week
        arrWeek = [dicUserStatsData valueForKeyPath:@"week.day_of_week"];
        dayMax = [[dicUserStatsData valueForKeyPath:@"week.max"] intValue];
        
        NSMutableArray *arrWorkouts = [[NSMutableArray alloc] initWithArray: [dicUserStatsData valueForKey: @"calender"]];
        arrWorkoutsDate = [[NSMutableArray alloc] init];
        dicUserWorkoutHashMap = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i < [arrWorkouts count]; i++) {
            
            NSString *strDateTimeObject = [[arrWorkouts objectAtIndex: i] valueForKey: @"date"];
            NSArray *arrDateTimeComponents = [strDateTimeObject componentsSeparatedByString: @" "];
            [arrWorkoutsDate addObject: [arrDateTimeComponents firstObject]];
            [dicUserWorkoutHashMap setValue: [arrWorkouts objectAtIndex: i] forKey: [arrDateTimeComponents firstObject]];
        }
        
        // Vsn - 17/02/2020
//        if (IS_IPHONEXR) {
//            [self.workoutStatsCalender reloadData];
//        }
        if (isCalendarAnimation) {
            isCalendarAnimation = NO;
            [self.workoutStatsCalender reloadData];
        }
    } else {
        [Utils showToast: [dicResponse valueForKey: @"message"] duration: 3.0];
    }
    
}

// MARK:- UITableView Delegate & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrHours.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimeOfDayCell *timeOfDayCell = [tableView dequeueReusableCellWithIdentifier:@"TimeOfDayCell" forIndexPath:indexPath];
    // Assign Data
    timeOfDayCell.lblTimeDuration.text = arrHours[indexPath.row];
    
    // Cell Layout
    timeOfDayCell.vwBar.layer.cornerRadius = timeOfDayCell.vwBar.frame.size.height / 2;
    
    NSDictionary *dicTime = arrTime[indexPath.row];
    
    // Set bar height
    int workout = [[dicTime valueForKey:@"workout"] intValue];
    
    if (timeMax > 0) {
        [timeOfDayCell.lblTimeCount countFromZeroTo:workout withDuration:1.0];
        //.text = [NSString stringWithFormat:@"%d",workout];
        
        // Calculate bar width
        dispatch_async(dispatch_get_main_queue(), ^{
            // Bar default width +  Trailing + Timecount lable width
            int timeCountWidth = 62 + 8 + timeOfDayCell.lblTimeCount.frame.size.width;
            int cellWidth = timeOfDayCell.frame.size.width - timeCountWidth;;
            
            int width = cellWidth / self->timeMax;
            
            [UIView animateWithDuration:1.0 animations:^{
                timeOfDayCell.vwBarWidth.constant = (width * workout) + 62;
                [timeOfDayCell.vwBar layoutIfNeeded];
                [timeOfDayCell layoutIfNeeded];
            }];
        });
    } else {
        // Bar default width
        timeOfDayCell.lblTimeCount.text = @"";
        timeOfDayCell.vwBarWidth.constant = 62;
    }
       
    return timeOfDayCell;
}

// MARK:- UICollectionView Delegate & Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arrDays.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DayOfWeekCell *dayOfWeekCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DayOfWeekCell" forIndexPath:indexPath];
    
    // Cell Layout
    dispatch_async(dispatch_get_main_queue(), ^{
        CAShapeLayer * maskLayer = [CAShapeLayer layer];
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: dayOfWeekCell.vwBar.bounds byRoundingCorners: UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii: CGSizeMake(8, 8)].CGPath;

        dayOfWeekCell.vwBar.layer.mask = maskLayer;
    });
    
    if (IS_IPHONE5s) {
        dayOfWeekCell.vwDaysBarWidth.constant = 20;
    }
    
    // Assign Data
    dayOfWeekCell.lblDay.text = arrDays[indexPath.row];
    
    NSDictionary *dicTime = arrWeek[indexPath.row];
    
    // Set bar height
    if (dayMax > 0) {
        // Cell Default height + Leading and Trailing + Count label height
        int countHeight = 28 + 16 + 30;
        int cellHeight = self.clvDaysOfWeek.frame.size.height - countHeight;
        
        int height = cellHeight / dayMax;
        int workout = [[dicTime valueForKey:@"workout"] intValue];
        
        [dayOfWeekCell.lblCount setFormat:@"%d"];
        [dayOfWeekCell.lblCount countFromZeroTo:workout withDuration:1.0];
        
        [UIView animateWithDuration:1.0 animations:^{
            dayOfWeekCell.vwBarHeight.constant = (height * workout) + 28;
            [dayOfWeekCell.vwBar layoutIfNeeded];
            [dayOfWeekCell layoutIfNeeded];
        }];
    } else {
        dayOfWeekCell.lblCount.text = @"";
        dayOfWeekCell.vwBarHeight.constant = 28;
    }
        
    return dayOfWeekCell;
}

// MARK:- FSCalendar Delegate & Datasource

- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position {
    
    FSCalendarCell *cell = [calendar dequeueReusableCellWithIdentifier: @"WorkoutStatsCell" forDate: date atMonthPosition: position];
    
    if ([[Utils getIsPaidUser] isEqualToString: @"YES"]) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: @"yyyy-MM-dd"];
        NSString *dateString = [formatter stringFromDate: date];
        NSString *currentDate = [formatter stringFromDate: [NSDate date]];
        
        if ([arrWorkoutsDate containsObject: dateString]) {
            
            if ([dateString isEqualToString: currentDate]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->cellBlackBorder.path = [UIBezierPath bezierPathWithRoundedRect:cell.shapeLayer.frame cornerRadius:cell.shapeLayer.bounds.size.height / 2].CGPath;
                });
                [cellBlackBorder removeFromSuperlayer];
                [cell.layer addSublayer:cellBlackBorder];
                
                UIFont *fontCurrentDate = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
                [[calendar appearance] setTitleFont: fontCurrentDate];
                [cell.titleLabel setTextColor: UIColor.whiteColor];
                [cell.shapeLayer setFillColor: cSTART_BUTTON.CGColor];
                
            } else {
                UIFont *fontCurrentDate = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
                [[calendar appearance] setTitleFont: fontCurrentDate];
                [cell.titleLabel setTextColor: UIColor.whiteColor];
                [cell.shapeLayer setFillColor: cSTART_BUTTON.CGColor];
            }
            
        } else if ([dateString isEqualToString: currentDate]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self->cellBlackBorder.path = [UIBezierPath bezierPathWithRoundedRect:cell.shapeLayer.frame cornerRadius:cell.shapeLayer.bounds.size.height / 2].CGPath;
            });
            
            [cellBlackBorder removeFromSuperlayer];
            
            [cell.layer addSublayer:cellBlackBorder];
        } else {
            UIFont *fontCurrentDate = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
            [[calendar appearance] setTitleFont: fontCurrentDate];
            [cell.titleLabel setTextColor: UIColor.blackColor];
            [cell.shapeLayer setFillColor: UIColor.whiteColor.CGColor];
        }
    }
    return cell;
}

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    
    FSCalendarCell *diyCell = (FSCalendarCell *)cell;
    
    if ([[Utils getIsPaidUser] isEqualToString: @"YES"]) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: @"yyyy-MM-dd"];
        NSString *dateString = [formatter stringFromDate: date];
        NSString *currentDate = [formatter stringFromDate: [NSDate date]];
        
        if ([arrWorkoutsDate containsObject: dateString]) {
            
            if ([dateString isEqualToString: currentDate]) {
                UIFont *fontCurrentDate = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
                [[calendar appearance] setTitleFont: fontCurrentDate];
                [cell.titleLabel setTextColor: UIColor.blackColor];
                
            } else {
                if ([[cell.layer sublayers] containsObject:cellBlackBorder]) {
                    for (CALayer *layer in cell.layer.sublayers) {
                        if ([layer isKindOfClass:[cellBlackBorder class]]) {
                            [layer removeFromSuperlayer];
                        }
                    }
                }
                
                UIFont *fontCurrentDate = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
                [[_workoutStatsCalender appearance] setTitleFont: fontCurrentDate];
                [diyCell.titleLabel setTextColor: UIColor.blackColor];
            }
            
            //Cell Animation
            [self performSelector:@selector(popAnimation:) withObject:cell afterDelay:0.5];
            
        } else if ([dateString isEqualToString: currentDate]) {
            
        } else {
            if ([[cell.layer sublayers] containsObject:cellBlackBorder]) {
                for (CALayer *layer in cell.layer.sublayers) {
                    if ([layer isKindOfClass:[cellBlackBorder class]]) {
                        [layer removeFromSuperlayer];
                    }
                }
            }
            
            UIFont *fontCurrentDate = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
            [[_workoutStatsCalender appearance] setTitleFont: fontCurrentDate];
            [diyCell.titleLabel setTextColor: UIColor.blackColor];
            [diyCell.shapeLayer setFillColor: UIColor.whiteColor.CGColor];
        }
    }
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    NSDate *currentMonth = self.workoutStatsCalender.currentPage;
    
    [self.workoutStatsCalender setCurrentPage: currentMonth animated:YES];
    
    [self updateMonthYearLabelWithDate: currentMonth];
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    isBackClicked = NO;
    
    AudioServicesPlaySystemSoundWithCompletion(1520, nil);
    
    [calendar deselectDate:date];
    [calendar reloadInputViews];
    
    if ([[Utils getIsPaidUser] isEqualToString: @"YES"]) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: @"yyyy-MM-dd"];
        NSString *dateString = [formatter stringFromDate: date];
        
        NSArray *arrVisibleCells = [calendar visibleCells];
        
        for (FSCalendarCell *cell in arrVisibleCells) {
            
            [cell.shapeLayer removeAllAnimations];
            [formatter setDateFormat: @"yyyy-MM-dd"];
            NSString *cellString = [formatter stringFromDate: [calendar dateForCell: cell]];
            
            if ([arrWorkoutsDate containsObject: cellString]) {
                [cell.titleLabel setTextColor: UIColor.whiteColor];
                [cell.shapeLayer setFillColor: cSTART_BUTTON.CGColor];
            }
        }
        
        if ([arrWorkoutsDate containsObject: dateString]) {
            
            [self initializeSingleDayWorkoutViewData: [dicUserWorkoutHashMap valueForKey: dateString]];
            
            self.vwSingleDayWorkout.alpha = 0.0;
            
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.vwSingleDayWorkout.alpha = 1.0;
            } completion:^(BOOL finished) {
                [calendar reloadData];
            }];
        }
        
        int workoutQuality = [[[dicUserWorkoutHashMap valueForKey: dateString] valueForKey:@"workout_quality"] intValue];
        
        // Circle progress animation
        [self progressAnimationWithWorkoutQuality:workoutQuality];
    }
}

// MARK:- ServiceManager Delegate

- (void)webServiceCallSuccess:(id)response forTag:(NSString *)tagname {
    if ([tagname isEqualToString: tGET_EXERCISE_HISTORY]) {
        [self parseGetExerciseHistoryResponse: response];
    }
}

- (void)webServiceCallFailure:(NSError *)error forTag:(NSString *)tagname {
    NSLog(@"Web service call fails : %@", [error localizedDescription]);
    [Utils showToast: [error localizedDescription] duration: 3.0];
}

// MARK:- UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrView) {
        
        CGRect container = CGRectMake(self.scrView.contentOffset.x, self.scrView.contentOffset.y, self.scrView.frame.size.width, self.scrView.frame.size.height);
                
        // Check if workout calendar view visible on screen
        CGRect calendarPosition  = CGRectMake(self.vwCalendar.frame.origin.x, (self.vwCalendar.frame.origin.y + 130), self.vwCalendar.frame.size.width, self.vwCalendar.frame.size.height);
                
        if (CGRectIntersectsRect(calendarPosition, container)) {
            if (isCalendarAnimation) {
                isCalendarAnimation = NO;
                
                [self.workoutStatsCalender reloadData];
            }
        }
        
        // Check if average workout view visible on screen
        CGRect averagePosition = CGRectMake(self.vwAverageWorkout.frame.origin.x, (self.vwAverageWorkout.frame.origin.y + 150), self.vwAverageWorkout.frame.size.width, self.vwAverageWorkout.frame.size.height);
        
        if (CGRectIntersectsRect(averagePosition, container)) {
            if (isAverageAnimation) {
                isAverageAnimation = NO;
                
                [self setupAverageData:dicAverage];
            }
        }
                
        // Check if Time of the day view visible on screen
        CGRect timePosition = CGRectMake(self.vwTimes.frame.origin.x, (self.vwTimes.frame.origin.y + 150), self.vwTimes.frame.size.width, self.vwTimes.frame.size.height);
        
        if (CGRectIntersectsRect(timePosition, container)) {
            if (isTimesAnimation) {
                isTimesAnimation = NO;
                
                [self.tblTimesOfDay reloadData];
            }
        }
        
        // Check if Days of the week view visible on screen
        CGRect daysPosition = CGRectMake(self.vwDays.frame.origin.x, (self.vwDays.frame.origin.y + 150), self.vwDays.frame.size.width, self.vwDays.frame.size.height);
        
        if (CGRectIntersectsRect(daysPosition, container)) {
            if (isDaysAnimation) {
                isDaysAnimation = NO;
                
                [self.clvDaysOfWeek reloadData];
            }
        }
    }
}

@end
