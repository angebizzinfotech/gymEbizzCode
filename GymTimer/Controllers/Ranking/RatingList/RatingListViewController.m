//
//  RatingListViewController.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 09/09/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "RatingListViewController.h"
#import "CommonImports.h"
@import SDWebImage;
@import pop;
@import QuartzCore;

@interface RatingListViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, ServiceManagerDelegate> {
    
    ServiceManager *serviceManager;
    Utils *utils;
    JGProgressHUD *progressHUD;
    UIActivityIndicatorView *spinner;
    NSMutableArray *arrFriendsRanking, *arrWorkout;
    BOOL isHeightAdjusted, canRefresh, isVibration, isModeChanged;
}

@end

@implementation RatingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    canRefresh = YES;
    isVibration = YES;
    isModeChanged = NO;
    
    self.dicRankCell = [[NSMutableDictionary alloc] init];
    serviceManager = [[ServiceManager alloc] init];
    serviceManager.delegate = self;

    [_lblDes setText:@"Number of workout days\nover the last week"];
    
    [self setupLoaderView];
    [self tabBarSetup];

    [self setupLayout];
    
    [self getRankingsAPI:NO];
    
    // Get last week exercise count
    [self getLastWeekExerciseCount];
}

- (void)viewWillAppear:(BOOL)animated {

    if (@available(iOS 11.0, *)) {
        self.scrView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HideNewRequest:) name:@"UpdateNewRequestBadge" object:nil];
    
    [self getFriendsCountAPI];
        
}

- (void)viewDidAppear:(BOOL)animated {
    self.vwTopRanking.clipsToBounds = YES;
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.vwTopRanking.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerTopLeft) cornerRadii:CGSizeMake(25.0, 25.0)].CGPath;
    self.vwTopRanking.layer.mask = maskLayer;
    
    self.vwAddFriends.layer.cornerRadius = self.vwAddFriends.frame.size.height / 2;
    self.vwAddFriends.clipsToBounds = YES;
    
    self.vwHiddenMode.layer.cornerRadius = self.vwHiddenMode.frame.size.height / 2;
    self.vwHiddenMode.clipsToBounds = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    isVibration = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger cellCount = [self.workoutCollection numberOfItemsInSection:0];
        for (int i = 0; i < cellCount; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            
            WorkoutProgressCell *progressCell = (WorkoutProgressCell *)[self.workoutCollection cellForItemAtIndexPath:indexPath];
            progressCell.progressCircle.value = 0.0;
        }
        [self.workoutCollection reloadData];
    });
}

//MARK:- User defined methods

- (void)setupLoaderView {
    
    //Loader view
    [_viewLoaderContentView setClipsToBounds: YES];
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: [_viewLoaderContentView bounds] byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){30.0, 30.}].CGPath;
    [[_viewLoaderContentView layer] setMask: maskLayer];
    
    //Loader view
    [_viewLoaderContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
}

- (void)setupLayout {
        
    self.vwNewRequest.layer.cornerRadius = self.vwNewRequest.frame.size.height / 2;
    self.vwNewRequest.clipsToBounds = YES;
    
    self.tblRanking.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Set more hight for scrolling even when no data
    if (self.vwTblRankingHeight.constant < (self.scrView.frame.size.height - self.vwTop.frame.size.height)) {
        isHeightAdjusted = YES;
        self.vwTblRankingHeight.constant = (self.scrView.frame.size.height - self.vwRanking.frame.origin.y) + 5;
        if (IS_IPHONE8) {
            self.vwTblRankingHeight.constant = (self.scrView.frame.size.height - self.vwRanking.frame.origin.y) + 35;
        }
    }
    
    if (IS_IPHONEXR) {
        self.imgTopTriangleBottom.constant = -0.5;
    } else if (IS_IPHONEX) {
        // ImageView
        self.imgTopTriangleBottom.constant = 0.0;
    } else if (IS_IPHONE8PLUS) {
        //Top view height
        self.vwTopHeight.constant = self.view.frame.size.height * 0.61;
        
        // No of workouts
        self.noOfWorkoutTop.constant = 70.0;
        self.lblNoOfWorkoutTop.constant = 0.0;
        [self.lblNoOfWorkout setFont:[UIFont fontWithName:fFUTURA_CONDENSED_EXTRA_BOLD size:100]];
        
        // ImageView
        self.imgTopTriangleBottom.constant = 0.0;
        
    } else if (IS_IPHONE8) {
        //Top view height
        self.vwTopHeight.constant = self.view.frame.size.height * 0.61;
        
        // No of workouts
        self.noOfWorkoutTop.constant = 50.0;
        self.lblNoOfWorkoutTop.constant = 0.0;
        [self.lblNoOfWorkout setFont:[UIFont fontWithName:fFUTURA_CONDENSED_EXTRA_BOLD size:80]];
        
        // ImageView
        self.imgTopTriangleBottom.constant = -0.4;
    } else {
        //Top view height
        self.vwTopHeight.constant = self.view.frame.size.height * 0.61;
        
        // No of workouts
        self.lblNoOfWorkoutTop.constant = 0.0;
        self.noOfWorkoutTop.constant = 40.0;
        [self.lblNoOfWorkout setFont:[UIFont fontWithName:fFUTURA_CONDENSED_EXTRA_BOLD size:50]];
        
        // Ranking Label
        self.lblRankingLeading.constant = 8.0;
        [self.lblRanking setFont:[UIFont fontWithName:fFUTURA_CONDENSED_EXTRA_BOLD size:35]];
        
        // Top ranking view
        self.vwRankingHeight.constant = 120.0;
        
        // Add Friend Leading
        self.vwAddFriendTop.constant = 4.0;
        self.vwAddFriendLeading.constant = 8.0;
        
        // ImageView
        self.imgTopTriangleBottom.constant = -0.4;
        
        // Workout Progress Leading & Trailing
        self.vwWorkoutProgressLeading.constant = 8;
        self.vwWorkoutProgressTrailing.constant = 8;
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
                [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - 75.0), DEVICE_WIDTH, 75.0)];
//                [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - 68.0), DEVICE_WIDTH, 68.0)];
                
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
    }else{
        if (IS_IPHONEXR || IS_IPHONEX) {
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
    
    
    
//    [[[self.tabBarController tabBar] layer] setBorderWidth:1.0];
//    [[[self.tabBarController tabBar] layer] setBorderColor: [[UIColor lightGrayColor] CGColor]];
//    [[self.tabBarController tabBar] setClipsToBounds:YES];
    
}

- (void) showLoaderView {
    [_viewLoaderBackgroundView setHidden: NO];
}

- (void) hideLoaderView {
    [_viewLoaderBackgroundView setHidden: YES];
}

- (void)showDeleteFriendActionWithMessage:(NSString *)message friendID:(NSString *)friendID {
    UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleActionSheet];
    [deleteAlert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self callDeleteFriendAPIWithFriendId:friendID];
    }]];
    [deleteAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:deleteAlert animated:YES completion:nil];
}

//MARK:- Button Click

- (IBAction)btnShowAddFriends:(id)sender {
    [_parent showMainSearch];
}

- (IBAction)btnHiddenModeAction:(UIButton *)sender {
    isModeChanged = YES;
    AudioServicesPlaySystemSoundWithCompletion(1520, nil);
    if ([self.lblHiddenMode.text isEqual:@"on"]) {
        [self setHiddenModeAPI:@"0"];
    } else if ([self.lblHiddenMode.text isEqual:@"off"]) {
        [self setHiddenModeAPI:@"1"];
    }
}

//MARK:- UICollectionView Delegate & Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WorkoutProgressCell *progressCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WorkoutProgressCell" forIndexPath:indexPath];
    progressCell.progressCircle.value = 0.0;
    
    progressCell.vwCurrentDay.layer.cornerRadius = progressCell.vwCurrentDay.frame.size.height / 2;
    progressCell.vwCurrentDay.clipsToBounds = YES;
    
    progressCell.centerImage.layer.cornerRadius = progressCell.centerImage.frame.size.height / 2;
    progressCell.centerImage.clipsToBounds = YES;
    
    // Show underline at last cell
    if (indexPath.row == 6) {
        [progressCell.vwCurrentDay setHidden:NO];
    } else {
        [progressCell.vwCurrentDay setHidden:YES];
    }
    
    if (arrWorkout.count == 0 || arrWorkout == nil) {
        progressCell.lblDayName.text = @"";
    } else {
        NSDictionary *workoutData = arrWorkout[indexPath.row];
        NSInteger isWorkout = [[workoutData valueForKey:@"value"] integerValue];
        progressCell.lblDayName.text = [workoutData valueForKey:@"day"];
        
        if (isWorkout == 0) {
            progressCell.centerImage.image = nil;
        } else if (isWorkout == 1) {
            
            // Animation for checkmark image
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                progressCell.centerImage.image = [UIImage imageNamed:@"checkamrknew"];
                
                POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
                sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
                sprintAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.7, 0.7)];
                sprintAnimation.springBounciness = 20.f;
                [progressCell.centerImage pop_removeAllAnimations];
                [progressCell.centerImage pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
            });
            
        }
        
        // Animation for workout progress circle
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            float workoutQuality = [[workoutData valueForKey:@"quality"] floatValue];
            if (workoutQuality > 100) {
                workoutQuality = 100.0;
            }
            
            // Set Animation duration according to workout quality
            
            float totalAnimateDuration = 0.0;
            if (workoutQuality >= 1 && workoutQuality <= 10) {
                totalAnimateDuration = 0.3;
                
            } else if (workoutQuality >= 10 && workoutQuality <= 20) {
                totalAnimateDuration = 0.6;
                
            } else if (workoutQuality >= 20 && workoutQuality <= 30) {
                totalAnimateDuration = 0.9;
                
            } else if (workoutQuality >= 30 && workoutQuality <= 40 ) {
                totalAnimateDuration = 1.2;
                
            } else if (workoutQuality >= 40 && workoutQuality <= 50 ) {
                totalAnimateDuration = 1.5;
                
            } else if (workoutQuality >= 50 && workoutQuality <= 60 ) {
                totalAnimateDuration = 1.8;
                
            } else if (workoutQuality >= 60 && workoutQuality <= 70 ) {
                totalAnimateDuration = 2.1;
                
            } else if (workoutQuality >= 70 && workoutQuality <= 80 ) {
                totalAnimateDuration = 2.4;
                
            } else if (workoutQuality >= 80 && workoutQuality <= 90 ) {
                totalAnimateDuration = 2.7;
                
            } else if (workoutQuality >= 90 && workoutQuality <= 100 ) {
                totalAnimateDuration = 3.0;
            }
            
            // Divide animation duration into 3 separate duration
            float animateFirst = 25.0 * totalAnimateDuration / 100;
            float animateSecond = 30.0 * totalAnimateDuration / 100;
            float animateThird = 50.0 * totalAnimateDuration / 100;
            
            // Divide workout quality into 2 separate value
            float valueFirst = 50.0 * workoutQuality / 100.0;
            float valueSecond = 30.0 * workoutQuality / 100.0;
            
            // Animation for workout quality progress
            progressCell.progressCircle.value = 0.0;
            
            [UIView animateWithDuration:animateFirst delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
                progressCell.progressCircle.value = valueFirst;
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:animateSecond delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                    progressCell.progressCircle.value = valueFirst + valueSecond;
                } completion:^(BOOL finished) {
                    // Vibration if workout quality reach at 100
                    if (workoutQuality == 100) {
                        float timeInterval = animateThird - 0.4;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            if (self->isVibration) {
                                // Vibration
                                AudioServicesPlaySystemSoundWithCompletion(1520, nil);
                            }
                        });
                    }
                    
                    [UIView animateWithDuration:animateThird delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        progressCell.progressCircle.value = workoutQuality;
                    } completion:^(BOOL finished) {
                    }];
                }];
            }];
        });
    }
    return progressCell;
}

//MARK:- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize cellSize = CGSizeMake(collectionView.frame.size.width/7, collectionView.frame.size.width/7 + 20);
    return cellSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//MARK:- UITableView Delegate & Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 92.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (arrFriendsRanking.count > 0) {
        return arrFriendsRanking.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (arrFriendsRanking.count == 0 || arrFriendsRanking == nil) {
        RankListCell *rankListCell = [tableView dequeueReusableCellWithIdentifier:@"RankListCell" forIndexPath:indexPath];
        
        //Set User Details
        rankListCell.lblUserName.text = @"Friend's name";
        rankListCell.lblWorkout.text = @"X workouts";
        rankListCell.imgProfile.image = [UIImage imageNamed:@"Component 8 – 1"];
        
        //Set Layout
        rankListCell.imgProfile.layer.cornerRadius = rankListCell.imgProfile.frame.size.height / 2;
        rankListCell.imgProfile.clipsToBounds = YES;
        
        rankListCell.vwProfileBack.layer.cornerRadius = rankListCell.vwProfileBack.frame.size.height / 2;
        rankListCell.vwProfileBack.clipsToBounds = YES;
        rankListCell.vwProfileBack.layer.borderColor = [cNEW_GREEN CGColor];
        rankListCell.vwProfileBack.layer.borderWidth = 2;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            UIBezierPath *enduranceShadow = [UIBezierPath bezierPathWithRoundedRect:[rankListCell.vwBack bounds] cornerRadius:20];
            
            rankListCell.vwBack.layer.cornerRadius = 20.0;
            [rankListCell.vwBack setClipsToBounds:YES];
            [[rankListCell.vwBack layer] setMasksToBounds: NO];
            [[rankListCell.vwBack layer] setShadowColor: [[UIColor blackColor] CGColor]];
            [[rankListCell.vwBack layer] setShadowOffset: CGSizeMake(0.0, 2.0)];
            [[rankListCell.vwBack layer] setShadowRadius: 5.0];
            [[rankListCell.vwBack layer] setShadowOpacity: 0.2];
            [[rankListCell.vwBack layer] setShadowPath: [enduranceShadow CGPath]];
        });
        
        if (indexPath.row == 0) {
            rankListCell.imgBadge.image = [UIImage imageNamed:@"1"];
            rankListCell.lblIndex.hidden = YES;
            rankListCell.imgBadge.hidden = NO;
        } else if (indexPath.row == 1) {
            rankListCell.imgBadge.image = [UIImage imageNamed:@"2"];
            rankListCell.lblIndex.hidden = YES;
            rankListCell.imgBadge.hidden = NO;
        } else if (indexPath.row == 2) {
            rankListCell.imgBadge.image = [UIImage imageNamed:@"3"];
            rankListCell.lblIndex.hidden = YES;
            rankListCell.imgBadge.hidden = NO;
        } else {
            rankListCell.imgBadge.image = [UIImage imageNamed:@""];
            rankListCell.lblIndex.hidden = NO;
            rankListCell.imgBadge.hidden = YES;
            rankListCell.lblIndex.text = [NSString stringWithFormat:@"%ld.", (long)indexPath.row+1];
        }
        
        return rankListCell;
    } else {
        RankListCell *rankListCell = [tableView dequeueReusableCellWithIdentifier:@"RankListCell" forIndexPath:indexPath];
        rankListCell.index = indexPath.row;
        
        //Set User Details
        NSDictionary *userDetails = arrFriendsRanking[indexPath.row];
        NSString *workoutCount = [userDetails valueForKey:@"workouts"];
        NSString *profileUrl = [userDetails valueForKey:@"profile_pic"];
        
        // Set Tag
        NSInteger userID = [[userDetails valueForKey:@"id"] integerValue];
        rankListCell.tag = userID;
        
        rankListCell.lblUserName.text = [userDetails valueForKey:@"name"];
        rankListCell.lblWorkout.text = [NSString stringWithFormat:@"%@ workouts",workoutCount];
        
        // Set Layout
        rankListCell.imgProfile.layer.cornerRadius = rankListCell.imgProfile.frame.size.height / 2;
        rankListCell.imgProfile.clipsToBounds = YES;
        
        rankListCell.vwProfileBack.layer.cornerRadius = rankListCell.vwProfileBack.frame.size.height / 2;
        rankListCell.vwProfileBack.clipsToBounds = YES;
        rankListCell.vwProfileBack.layer.borderColor = [cNEW_GREEN CGColor];
        rankListCell.vwProfileBack.layer.borderWidth = 2;
        
        UIColor *customGrayColor = [UIColor colorWithRed: 235.0/255.0 green: 235.0/255.0 blue: 235.0/255.0 alpha: 1.0];

        if ([rankListCell.lblUserName.text isEqualToString:@"Friend's name"]) {
            // Defalut data setup
            [rankListCell.lblUserName setTextColor:customGrayColor];
            [rankListCell.lblWorkout setTextColor:customGrayColor];
            rankListCell.vwProfileBack.layer.borderColor = customGrayColor.CGColor;
            rankListCell.imgProfile.image = [UIImage imageNamed:@"GrayUser"];
            [rankListCell.imgProfile setAlpha:1.0];
            [rankListCell.imgBadge setAlpha:1.0];
            [rankListCell.lblIndex setAlpha:1.0];
        } else {
            // Fridends data setup
            [rankListCell.lblUserName setTextColor:[UIColor blackColor]];
            [rankListCell.lblWorkout setTextColor:cNEW_GREEN];
            rankListCell.vwProfileBack.layer.borderColor = [cNEW_GREEN CGColor];
            [rankListCell.imgProfile setAlpha:1.0];
            [rankListCell.lblIndex setAlpha:1.0];
            [rankListCell.imgBadge setAlpha:1.0];
            [rankListCell.imgProfile sd_setImageWithURL:[NSURL URLWithString:profileUrl] placeholderImage:[UIImage imageNamed:@"Component 8 – 1"]];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            UIBezierPath *enduranceShadow = [UIBezierPath bezierPathWithRoundedRect:[rankListCell.vwBack bounds] cornerRadius:20];
            rankListCell.vwBack.layer.cornerRadius = 20.0;
            [[rankListCell.vwBack layer] setMasksToBounds: NO];
            [[rankListCell.vwBack layer] setShadowColor: [[UIColor blackColor] CGColor]];
            [[rankListCell.vwBack layer] setShadowOffset: CGSizeMake(0, 2)];
            [[rankListCell.vwBack layer] setShadowRadius: 3.0];
            [[rankListCell.vwBack layer] setShadowOpacity: 0.2];
            [rankListCell.vwBack.layer setRasterizationScale:[UIScreen.mainScreen scale]];
            [[rankListCell.vwBack layer] setShadowPath: [enduranceShadow CGPath]];
        });
        
        if (indexPath.row == 0) {
            rankListCell.imgBadge.image = [UIImage imageNamed:@"1"];
            rankListCell.lblIndex.hidden = YES;
            rankListCell.imgBadge.hidden = NO;
        } else if (indexPath.row == 1) {
            rankListCell.imgBadge.image = [UIImage imageNamed:@"2"];
            rankListCell.lblIndex.hidden = YES;
            rankListCell.imgBadge.hidden = NO;
        } else if (indexPath.row == 2) {
            rankListCell.imgBadge.image = [UIImage imageNamed:@"3"];
            rankListCell.lblIndex.hidden = YES;
            rankListCell.imgBadge.hidden = NO;
        } else {
            rankListCell.imgBadge.image = [UIImage imageNamed:@""];
            rankListCell.lblIndex.hidden = NO;
            rankListCell.imgBadge.hidden = YES;
            rankListCell.lblIndex.text = [NSString stringWithFormat:@"%ld.", (long)indexPath.row+1];
        }
        
        if (indexPath.row == arrFriendsRanking.count - 1) {
            RankListCell *firstCell = [self.dicRankCell valueForKey:[NSString stringWithFormat:@"%d",0]];
            [firstCell animateCell];
        }
        
        rankListCell.parentVC = self;
        [self.dicRankCell setValue:rankListCell forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
        return rankListCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Display user own profile
    RankListCell *rankListCell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSMutableDictionary *dicUserDetails = [[NSMutableDictionary alloc] initWithDictionary: [Utils getUserDetails]];
    NSInteger userID = [[dicUserDetails valueForKey: @"id"] integerValue];
    
    if (rankListCell.tag == userID) {
        [[self navigationController] pushViewController: GETCONTROLLER(@"ProfileViewController") animated: YES];
    } else if (rankListCell.tag) {
        NSDictionary *userDetails = arrFriendsRanking[indexPath.row];
        NSString *userName = [userDetails valueForKey:@"name"];
        NSString *friendID = [userDetails valueForKey:@"id"];
        NSString *message = [NSString stringWithFormat:@"Are you sure you want to remove %@ from Friends?",userName];
        [self showDeleteFriendActionWithMessage:message friendID:friendID];
    }
}

//MARK:- API call

- (void)HideNewRequest:(NSNotification *)notification{
    [_vwNewRequest setHidden:YES];
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:HasNewNotification];
    _parent.tabBarItem.badgeValue = @"";
    [[NSNotificationCenter defaultCenter] postNotificationName:UpdateTabBarBadge object:nil];
}

- (void)getFriendsCountAPI {
    
    NSMutableDictionary *dicUserDetails = [[NSMutableDictionary alloc] initWithDictionary: [Utils getUserDetails]];
    
    NSArray *FriendCountParams = @[
                                    @{ @"user_id" : [dicUserDetails valueForKey: @"id"]}
                                    ];
    
    NSLog(@"Dic : %@", FriendCountParams);
    
    if ([Utils isConnectedToInternet]) {
        NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uFRIEND_COUNT];
        [serviceManager callWebServiceWithPOST: webpath withTag: tFRIEND_COUNT params: FriendCountParams];
    } 
    
}

- (void)getRankingsAPI:(BOOL)isFromScroll {
    
    NSMutableDictionary *dicUserDetails = [[NSMutableDictionary alloc] initWithDictionary: [Utils getUserDetails]];
    
    NSArray *RequestACtionParams = @[
                                     @{ @"user_id" : [dicUserDetails valueForKey: @"id"]}
                                     ];
    
    NSLog(@"Dic : %@", RequestACtionParams);
    
    if ([Utils isConnectedToInternet]) {
        [self showLoaderView];
        
        // Set top spinner frame
        if (IS_IPHONEXR || IS_IPHONEX || IS_IPHONE8PLUS) {
            if (isFromScroll) {
                spinner = [Utils showBigActivityIndicatorInViewAtTop:_viewLoaderContentView];
                
            } else {
                spinner = [Utils showActivityIndicatorInViewAtTop:_viewLoaderContentView];
                spinner.color = [UIColor whiteColor];
                [spinner setFrame:CGRectMake((_viewLoaderContentView.frame.size.width/2)-(spinner.frame.size.width/2), 44, spinner.frame.size.width, spinner.frame.size.height)];
            }
        } else {
            spinner = [Utils showActivityIndicatorInViewAtTop:_viewLoaderContentView];
            spinner.color = [UIColor whiteColor];
            [spinner setFrame:CGRectMake((_viewLoaderContentView.frame.size.width/2)-(spinner.frame.size.width/2), 22, spinner.frame.size.width, spinner.frame.size.height)];
        }
        
        NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uGET_FRIEND_RANKINGS];
        [serviceManager callWebServiceWithPOST: webpath withTag: tGET_FRIEND_RANKINGS params: RequestACtionParams];
    } else {
        [self hideLoaderView];
    }
    
}

- (void)setHiddenModeAPI:(NSString *)status {
    // status: 0 = Off & 1 = On
    NSMutableDictionary *dicUserDetails = [[NSMutableDictionary alloc] initWithDictionary: [Utils getUserDetails]];
    
    NSArray *parameter = @[
        @{ @"user_id" : [dicUserDetails valueForKey: @"id"]},
        @{ @"hidden_mode": status}
    ];
    
    NSLog(@"Parameter : %@", parameter);
    
    if ([Utils isConnectedToInternet]) {
        
        [self showLoaderView];
        spinner = [Utils showActivityIndicatorInViewAtTop:_viewLoaderContentView];
        spinner.color = [UIColor whiteColor];
        
        // Set top spinner frame
        if (IS_IPHONEXR || IS_IPHONEX || IS_IPHONE8PLUS) {
            [spinner setFrame:CGRectMake((_viewLoaderContentView.frame.size.width/2)-(spinner.frame.size.width/2), 44, spinner.frame.size.width, spinner.frame.size.height)];
        } else {
            [spinner setFrame:CGRectMake((_viewLoaderContentView.frame.size.width/2)-(spinner.frame.size.width/2), 22, spinner.frame.size.width, spinner.frame.size.height)];
        }
        
        NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uHIDDEN_MODE_SETTING];
        [serviceManager callWebServiceWithPOST: webpath withTag: tHIDDEN_MODE_SETTING params: parameter];
        
    } else {
        [self hideLoaderView];
    }

}

- (void)getLastWeekExerciseCount {
    NSMutableDictionary *dicUserDetails = [[NSMutableDictionary alloc] initWithDictionary: [Utils getUserDetails]];
    
    NSArray *param = @[
        @{ @"user_id" : [dicUserDetails valueForKey: @"id"]}
    ];
    
    NSLog(@"Dic : %@", param);
    
    if ([Utils isConnectedToInternet]) {
        NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uLAST_WEEK_EXERCISE_COUNT];
        [serviceManager callWebServiceWithPOST: webpath withTag: tLAST_WEEK_EXERCISE_COUNT params: param];
    } else {
        [self hideLoaderView];
    }
}

- (void)callDeleteFriendAPIWithFriendId:(NSString *)friendId {
    NSMutableDictionary *dicUserDetails = [[NSMutableDictionary alloc] initWithDictionary: [Utils getUserDetails]];
    
    NSArray *param = @[
                       @{ @"user_id" : [dicUserDetails valueForKey: @"id"]},
                       @{ @"other_user_id": friendId}
                       ];
    
    NSLog(@"Dic : %@", param);
    
    if ([Utils isConnectedToInternet]) {
        [self showLoaderView];
        spinner = [Utils showActivityIndicatorInViewAtTop:_viewLoaderContentView];
        spinner.color = [UIColor whiteColor];
        
        // Set top spinner frame
        if (IS_IPHONEXR || IS_IPHONEX || IS_IPHONE8PLUS) {
            [spinner setFrame:CGRectMake((_viewLoaderContentView.frame.size.width/2)-(spinner.frame.size.width/2), 44, spinner.frame.size.width, spinner.frame.size.height)];
        } else {
            [spinner setFrame:CGRectMake((_viewLoaderContentView.frame.size.width/2)-(spinner.frame.size.width/2), 22, spinner.frame.size.width, spinner.frame.size.height)];
        }
        
        NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uDELETE_FRIEND];
        [serviceManager callWebServiceWithPOST: webpath withTag: tDELETE_FRIEND params: param];
    } else {
        [self hideLoaderView];
    }
}

//MARK:- Service manager delegate and parser methods

- (void)webServiceCallFailure:(NSError *)error forTag:(NSString *)tagname {
    NSLog(@"Web service call fails : %@", [error localizedDescription]);
    [self hideLoaderView];
    [Utils hideActivityIndicator:spinner fromView:_viewLoaderContentView];
}

- (void)webServiceCallSuccess:(id)response forTag:(NSString *)tagname {
    
    if ([tagname isEqualToString: tGET_FRIEND_RANKINGS]) {
        [self parseGetRankingsResponse: response];
    } else if ([tagname isEqualToString:tHIDDEN_MODE_SETTING]) {
        [self parseSetHiddenMode:response];
    } else if ([tagname isEqualToString:tLAST_WEEK_EXERCISE_COUNT]) {
        [self parseLastWeekExerciseCount:response];
    } else if ([tagname isEqualToString:tDELETE_FRIEND]) {
        [self parseDeleteFriendAPI:response];
    }else if([tagname isEqualToString:tFRIEND_COUNT]){
        [self parseFriendCountResponse:response];
    }
    
}

//MARK:- Parsing method

- (void) parseFriendCountResponse: (id) response {

NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
NSLog(@"%@", dicResponse);

    if ([[dicResponse valueForKey:@"status"] integerValue] == 1) {
        //success
        NSDictionary *dic = [dicResponse valueForKey:@"data"];
        NSString *newFriendRequest = [dic valueForKey:@"new_request"];
        NSString *newRequestAccepted = [dic valueForKey:@"request_accept"];
        
        if ([newFriendRequest isEqualToString:@"1"] || ([newRequestAccepted isEqualToString:@"1"])) {
            _vwNewRequest.hidden = NO;
        } else {
            _vwNewRequest.hidden = YES;
        }
        //SEtup Tab bar Badge

    }
}

- (void)parseGetRankingsResponse:(id) response {
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    NSLog(@"%@", dicResponse);
    
    // Setup Hidden Mode
    NSInteger isHiddenMode = [[dicResponse valueForKey:@"hidden_mode"] integerValue];
    [self.lblHiddenModeTitle setHidden:NO];
    if (isHiddenMode == 0) {
        [self.btnHiddenMode setImage:[UIImage imageNamed:@"HiddenOff"] forState:UIControlStateNormal];
        self.lblHiddenMode.text = @"off";
    } else if (isHiddenMode == 1) {
        [self.btnHiddenMode setImage:[UIImage imageNamed:@"HiddenOn"] forState:UIControlStateNormal];
        self.lblHiddenMode.text = @"on";
    }
    
    if ([[dicResponse valueForKey:@"status"] integerValue] == 1) {
        arrFriendsRanking = [[NSMutableArray alloc] init];
        arrWorkout = [[NSMutableArray alloc] init];
        
        arrFriendsRanking = [[dicResponse valueForKey:@"data"] mutableCopy];
        arrWorkout = [dicResponse valueForKey:@"workout"];
        
        if(isModeChanged){
            isModeChanged = NO;
        }else{
            NSInteger cellCount = [self.workoutCollection numberOfItemsInSection:0];
            for (int i = 0; i < cellCount; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                
                WorkoutProgressCell *progressCell = (WorkoutProgressCell *)[self.workoutCollection cellForItemAtIndexPath:indexPath];
                progressCell.progressCircle.value = 0.0;
            }
            [self.workoutCollection reloadData];
        }
        
        // Add default data if records are less than 10
        if (arrFriendsRanking.count < 10) {
            NSMutableDictionary *defaultData = [[NSMutableDictionary alloc] init];
            [defaultData setValue:@"" forKey:@"id"];
            [defaultData setValue:@"Friend's name" forKey:@"name"];
            [defaultData setValue:@"" forKey:@"profile_pic"];
            [defaultData setValue:@"X" forKey:@"workouts"];
            
            for (int i = (int)arrFriendsRanking.count; i < 10; i++) {
                [arrFriendsRanking addObject:defaultData];
            }
        }
        
        self.vwTblRankingHeight.constant = arrFriendsRanking.count * 92;
        [_tblRanking reloadData];
        
        // Set more hight for scrolling even when no data
        if (self.vwTblRankingHeight.constant < (self.scrView.frame.size.height - self.vwTop.frame.size.height)) {
            isHeightAdjusted = YES;
            self.vwTblRankingHeight.constant = (self.scrView.frame.size.height - self.vwRanking.frame.origin.y) + 15;
            
            if (IS_IPHONE8) {
                self.vwTblRankingHeight.constant = self.vwTblRankingHeight.constant + 35;
            }
        } else {
            isHeightAdjusted = NO;
            self.vwTblRankingHeight.constant = self.vwTblRankingHeight.constant + 15;
            
            if (IS_IPHONE8) {
                self.vwTblRankingHeight.constant = self.vwTblRankingHeight.constant + 40;
            }
        }
        
    } else {
        // Height for 10 default records
        isHeightAdjusted = NO;
        self.vwTblRankingHeight.constant = (10 * 92) + 15;
        
        if (IS_IPHONE8) {
            self.vwTblRankingHeight.constant = (10 * 92) + 35;
        }
    }
    
    [self hideLoaderView];
    [Utils hideActivityIndicator:spinner fromView:_viewLoaderContentView];
}

- (void)parseSetHiddenMode:(id) response {
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    NSLog(@"%@", dicResponse);
    
    if ([[dicResponse valueForKey:@"status"] integerValue] == 1) {
        
        [self.lblHiddenModeTitle setHidden:NO];
        
        if ([self.lblHiddenMode.text isEqual:@"on"]) {
            [self.btnHiddenMode setImage:[UIImage imageNamed:@"HiddenOff"] forState:UIControlStateNormal];
            self.lblHiddenMode.text = @"off";
            
        } else if ([self.lblHiddenMode.text isEqual:@"off"]) {
            [self.btnHiddenMode setImage:[UIImage imageNamed:@"HiddenOn"] forState:UIControlStateNormal];
            self.lblHiddenMode.text = @"on";
        }
        
        [self getRankingsAPI:NO];
    }
    
    [self hideLoaderView];
    [Utils hideActivityIndicator:spinner fromView:_viewLoaderContentView];
}

- (void)parseLastWeekExerciseCount:(id)response {
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    NSLog(@"%@", dicResponse);
    
    if ([[dicResponse valueForKey:@"status"] integerValue] == 1) {
        //Set Total workout
        NSString *totalWorkout = [NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"total_workout"]];
        
        [self.lblNoOfWorkout setHidden:NO];
        [self.lblNoOfWorkout setFormat:@"%d"];
        
        float animationDuration = 0.0;
        if ([totalWorkout integerValue] >= 1 && [totalWorkout integerValue] <= 10) {
            animationDuration = 0.2;
        } else if ([totalWorkout integerValue] >= 10 && [totalWorkout integerValue] <= 30) {
            animationDuration = 0.5;
        } else if ([totalWorkout integerValue] >= 30 && [totalWorkout integerValue] <= 60) {
            animationDuration = 0.8;
        } else if ([totalWorkout integerValue] >= 60 && [totalWorkout integerValue] <= 100) {
            animationDuration = 1.2;
        }
        
        [self.lblNoOfWorkout countFrom:0 to:[totalWorkout integerValue] withDuration:animationDuration];
        self.lblNoOfWorkout.text = totalWorkout;
    }
    
    [self hideLoaderView];
    [Utils hideActivityIndicator:spinner fromView:_viewLoaderContentView];
}

- (void)parseDeleteFriendAPI:(id)response {
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    NSLog(@"%@", dicResponse);
    
    if ([[dicResponse valueForKey:@"status"] integerValue] == 1) {
        [self getRankingsAPI:NO];
    }
    
    [self hideLoaderView];
    [Utils hideActivityIndicator:spinner fromView:_viewLoaderContentView];
}

//MARK:- UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrView && isHeightAdjusted) {
        [self.scrView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollY = 0.0;
    
    // For change background color when scrollview bounce
    if (scrollView == self.scrView) {
        BOOL contentFillsScrollEdges = scrollView.contentSize.height + scrollView.contentInset.top + scrollView.contentInset.bottom >= CGRectGetHeight(scrollView.bounds);
        BOOL bouncingBottom = contentFillsScrollEdges && scrollView.contentOffset.y > scrollView.contentSize.height - CGRectGetHeight(scrollView.bounds) + scrollView.contentInset.bottom;
        
        // Bouncing Top
        if (scrollView.contentOffset.y < 0) {
            scrollView.backgroundColor = [UIColor clearColor];
        }
        
        // Bouncing Bottom
        if (bouncingBottom) {
            scrollY = scrollView.contentOffset.y;
            scrollView.backgroundColor = [UIColor whiteColor];
        }
        
        if (scrollY == 0.0) {
            scrollView.backgroundColor = [UIColor clearColor];
        }
    }
    
    // For custom pull to refresh
    if (scrollView == self.scrView) {
        if (scrollView.contentOffset.y < -100) {
            if (canRefresh) {
                canRefresh = NO;
                
                // Vibration
                AudioServicesPlaySystemSoundWithCompletion(1520, nil);
                
                // API Calling
                [self getRankingsAPI:YES];
                [self getFriendsCountAPI];
            }
        } else if (self.scrView.contentOffset.y >= 0) {
            canRefresh = YES;
        }
    }
}

@end
