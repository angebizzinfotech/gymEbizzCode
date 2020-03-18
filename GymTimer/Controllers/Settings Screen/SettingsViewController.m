//
//  SettingsViewController.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 17/04/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "SettingsViewController.h"
#import "CommonImports.h"

@import StoreKit;

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate, ServiceManagerDelegate, UIScrollViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    
    ServiceManager *serviceManager;
    Utils *utils;
    JGProgressHUD *progressHUD;
    NSArray *arrSettingsList;
    CGFloat currentScrollViewYOffset;
    UIActivityIndicatorView *spinner;
}

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLayout];
    
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
                // [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - 68.0), DEVICE_WIDTH, 68.0)];
                
        //        [tabBarItem0 setImage:[[UIImage imageNamed:@"gray_workout_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //        [tabBarItem0 setSelectedImage:[[UIImage imageNamed:@"green_workout_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //        [tabBarItem1 setImage:[[UIImage imageNamed:@"gray_rank_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //        [tabBarItem1 setSelectedImage:[[UIImage imageNamed:@"green_rank_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //        [tabBarItem2 setImage:[[UIImage imageNamed:@"gray_stats_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //        [tabBarItem2 setSelectedImage:[[UIImage imageNamed:@"green_stats_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //        [tabBarItem3 setImage:[[UIImage imageNamed:@"gray_setting_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //        [tabBarItem3 setSelectedImage:[[UIImage imageNamed:@"green_setting_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                
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
                
        //        [tabBarItem0 setImage:[[UIImage imageNamed:@"gray_workout"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //        [tabBarItem0 setSelectedImage:[[UIImage imageNamed:@"green_workout"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //        [tabBarItem1 setImage:[[UIImage imageNamed:@"gray_rank"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //        [tabBarItem1 setSelectedImage:[[UIImage imageNamed:@"green_rank"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //        [tabBarItem2 setImage:[[UIImage imageNamed:@"gray_stats"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //        [tabBarItem2 setSelectedImage:[[UIImage imageNamed:@"green_stats"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //        [tabBarItem3 setImage:[[UIImage imageNamed:@"gray_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //        [tabBarItem3 setSelectedImage:[[UIImage imageNamed:@"green_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                
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
                
        //        [tabBarItem0 setImage:[[UIImage imageNamed:@"gray_workout_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //        [tabBarItem0 setSelectedImage:[[UIImage imageNamed:@"green_workout_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //        [tabBarItem1 setImage:[[UIImage imageNamed:@"gray_rank_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //        [tabBarItem1 setSelectedImage:[[UIImage imageNamed:@"green_rank_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //        [tabBarItem2 setImage:[[UIImage imageNamed:@"gray_stats_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //        [tabBarItem2 setSelectedImage:[[UIImage imageNamed:@"green_stats_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //        [tabBarItem3 setImage:[[UIImage imageNamed:@"gray_setting_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        //        [tabBarItem3 setSelectedImage:[[UIImage imageNamed:@"green_setting_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTabBar) name:ChangeSelectedTab object:nil];
}

- (void)changeTabBar {
    [self.tabBarController setSelectedIndex: 2];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    for (UIView *obj in [self.tabBarController.view subviews]) {
        if (obj.tag == 101) {
            [obj removeFromSuperview];
        }
    }
    
    [self initializeData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HasNewNotification object:nil];

}

- (void)viewWillLayoutSubviews {

    if (IS_IPHONEXR || IS_IPHONEX) {
        [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - 88.0), DEVICE_WIDTH, 88.0)];
    } else if (IS_IPHONE8) {
        [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - 75.0), DEVICE_WIDTH, 75.0)];
    }
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
    
}


//MARK:- UIScrollView's delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//    CGFloat nextScrollViewYOffset = [scrollView contentOffset].y;
//    if ((nextScrollViewYOffset > -44.0) && (nextScrollViewYOffset > currentScrollViewYOffset)) {
//        currentScrollViewYOffset = nextScrollViewYOffset;
//    } else if ((currentScrollViewYOffset > -44.0) && (nextScrollViewYOffset < currentScrollViewYOffset)) {
//        [UIView animateWithDuration: 0.4 delay: 0.0 options: UIViewAnimationOptionTransitionNone animations:^{
//            [scrollView setContentOffset: CGPointMake(0.0, -44.0) animated: NO];
//        } completion:^(BOOL finished) {
//
//        }];
//    } else {}

}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    [UIView animateWithDuration: 0.4 delay: 0.0 options: UIViewAnimationOptionTransitionNone animations:^{
        if (IS_IPHONEXR) {
            [scrollView setContentOffset: CGPointMake(0.0, -44.0) animated: NO];
        } else if (IS_IPHONEX) {
            [scrollView setContentOffset: CGPointMake(0.0, -44.0) animated: NO];
        } else if (IS_IPHONE8PLUS) {
            [scrollView setContentOffset: CGPointMake(0.0, -20.0) animated: NO];
        } else if (IS_IPHONE8) {
            [scrollView setContentOffset: CGPointMake(0.0, -20.0) animated: NO];
        } else {
            //[scrollView setContentOffset: CGPointMake(0.0, -20.0) animated: NO];
        }
    } completion:^(BOOL finished) {}];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [UIView animateWithDuration: 0.4 delay: 0.0 options: UIViewAnimationOptionTransitionNone animations:^{
        if (IS_IPHONEXR) {
            [scrollView setContentOffset: CGPointMake(0.0, -44.0) animated: NO];
        } else if (IS_IPHONEX) {
            [scrollView setContentOffset: CGPointMake(0.0, -44.0) animated: NO];
        } else if (IS_IPHONE8PLUS) {
            [scrollView setContentOffset: CGPointMake(0.0, -20.0) animated: NO];
        } else if (IS_IPHONE8) {
            [scrollView setContentOffset: CGPointMake(0.0, -20.0) animated: NO];
        } else {
            //[scrollView setContentOffset: CGPointMake(0.0, -20.0) animated: NO];
        }
    } completion:^(BOOL finished) {}];
}


//MARK:- Table view's delegate and datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrSettingsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingsTableViewCell *settingCell = [tableView dequeueReusableCellWithIdentifier: tblSETTINGS_CELL forIndexPath: indexPath];
    
    //Set settings icons
    if ([indexPath row] == 0) {
        [settingCell.imgSettingIcon setImage: [UIImage imageNamed: @"imgStatsGreen"]];
    } else if ([indexPath row] == 1) {
        [settingCell.imgSettingIcon setImage: [UIImage imageNamed: @"imgProfileBlack"]];
    } else if ([indexPath row] == 2) {
        [settingCell.imgSettingIcon setImage: [UIImage imageNamed: @"imgWorkoutAdvice"]];
    } else {}
    
    //Set setting name text
    [settingCell.lblSettingNameLabel setText: [arrSettingsList objectAtIndex: [indexPath row]]];
    
    //Set text colour
    if ([indexPath row] == 0) {
        [settingCell.lblSettingNameLabel setTextColor: cSTART_BUTTON];
    } else {
        [settingCell.lblSettingNameLabel setTextColor: UIColor.blackColor];
    }
    
    //Set colour for underline view
    if ([indexPath row] < [arrSettingsList count] - 1) {
        [settingCell.viewSettingUnderlineView setBackgroundColor: cSTART_BUTTON];
    } else {
        [settingCell.viewSettingUnderlineView setBackgroundColor: UIColor.clearColor];
    }
    
    //Assign target on open setting button
    [settingCell.btnOpenSettingButton setTag: [indexPath row]];
    [settingCell.btnOpenSettingButton setUserInteractionEnabled: YES];
    [settingCell.btnOpenSettingButton addTarget: self action: @selector(handleTapOnOpenSetting:) forControlEvents: UIControlEventTouchUpInside];
    
    if (IS_IPHONEXR) {
        
        //Set setting name label font
        UIFont *fontSetting = [UIFont fontWithName: fFUTURA_MEDIUM size: 20.0];
        [settingCell.lblSettingNameLabel setFont: fontSetting];
        
        //Set setting icon
        if ([indexPath row] == 0) {
            
            [settingCell.imgSettingIcon setFrame: CGRectMake(50.0, ((settingCell.frame.size.height - 25.0) / 2.0) - 3.0, 34.0, 26.0)];
            [settingCell.lblSettingNameLabel setFrame: CGRectMake((settingCell.imgSettingIcon.frame.origin.x + settingCell.imgSettingIcon.frame.size.width + 12.0), (settingCell.frame.size.height - 30.0) / 2.0, (DEVICE_WIDTH - 148.0), 30.0)];
            
        } else if ([indexPath row] == 1) {
            
            [settingCell.imgSettingIcon setFrame: CGRectMake(54.0, ((settingCell.frame.size.height - 27.0) / 2.0) - 2.0, 24.0, 29.0)];
            [settingCell.lblSettingNameLabel setFrame: CGRectMake(96.0, (settingCell.frame.size.height - 30.0) / 2.0, (DEVICE_WIDTH - 148.0), 30.0)];
            
        } else if ([indexPath row] == 2) {
            
            [settingCell.imgSettingIcon setFrame: CGRectMake(53.0, ((settingCell.frame.size.height - 26.0) / 2.0) - 1.0, 27.0, 27.0)];
            [settingCell.lblSettingNameLabel setFrame: CGRectMake(96.0, (settingCell.frame.size.height - 30.0) / 2.0, (DEVICE_WIDTH - 148.0), 30.0)];
            
        } else {
            [settingCell.imgSettingIcon setFrame: CGRectMake(48.0, (settingCell.frame.size.height - 30.0) / 2.0, 0.0, 30.0)];
            [settingCell.lblSettingNameLabel setFrame: CGRectMake(50.0, ((settingCell.frame.size.height - 30.0) / 2.0) + 1.0, (DEVICE_WIDTH - 103.0), 30.0)];
        }
        
        //Next icon frame
        [settingCell.imgNextIcon setFrame: CGRectMake((DEVICE_WIDTH - 40.0), ((settingCell.frame.size.height - 25.0) / 2.0) - 1.0, 15.0, 26.0)];
        
        //Set underline view frame
        [settingCell.viewSettingUnderlineView setFrame: CGRectMake(49.0, (settingCell.frame.size.height - 2.0), (DEVICE_WIDTH - 49.0), 2.0)];
        
        //Set frame for open setting button
        [settingCell.btnOpenSettingButton setFrame: CGRectMake(48.0, 0.0, (DEVICE_WIDTH - 48.0), settingCell.frame.size.height)];
        
    } else if (IS_IPHONEX) {
        
        //Set setting name label font
        UIFont *fontSetting = [UIFont fontWithName: fFUTURA_MEDIUM size: 20.0];
        [settingCell.lblSettingNameLabel setFont: fontSetting];
        
        //Set setting icon
        if ([indexPath row] == 0) {
            
            [settingCell.imgSettingIcon setFrame: CGRectMake(50.0, ((settingCell.frame.size.height - 25.0) / 2.0) - 3.0, 34.0, 26.0)];
            [settingCell.lblSettingNameLabel setFrame: CGRectMake((settingCell.imgSettingIcon.frame.origin.x + settingCell.imgSettingIcon.frame.size.width + 12.0), (settingCell.frame.size.height - 30.0) / 2.0, (DEVICE_WIDTH - 148.0), 30.0)];
            
        } else if ([indexPath row] == 1) {
            
            [settingCell.imgSettingIcon setFrame: CGRectMake(54.0, ((settingCell.frame.size.height - 27.0) / 2.0) - 2.0, 24.0, 29.0)];
            [settingCell.lblSettingNameLabel setFrame: CGRectMake(96.0, (settingCell.frame.size.height - 30.0) / 2.0, (DEVICE_WIDTH - 148.0), 30.0)];
            
        } else if ([indexPath row] == 2) {
            
            [settingCell.imgSettingIcon setFrame: CGRectMake(53.0, ((settingCell.frame.size.height - 26.0) / 2.0) - 1.0, 27.0, 27.0)];
            [settingCell.lblSettingNameLabel setFrame: CGRectMake(96.0, (settingCell.frame.size.height - 30.0) / 2.0, (DEVICE_WIDTH - 148.0), 30.0)];
            
        } else {
            [settingCell.imgSettingIcon setFrame: CGRectMake(48.0, (settingCell.frame.size.height - 30.0) / 2.0, 0.0, 30.0)];
            [settingCell.lblSettingNameLabel setFrame: CGRectMake(50.0, ((settingCell.frame.size.height - 30.0) / 2.0) + 1.0, (DEVICE_WIDTH - 103.0), 30.0)];
        }
        
        //Next icon frame
        [settingCell.imgNextIcon setFrame: CGRectMake((DEVICE_WIDTH - 40.0), ((settingCell.frame.size.height - 25.0) / 2.0) - 1.0, 15.0, 26.0)];
        
        //Set underline view frame
        [settingCell.viewSettingUnderlineView setFrame: CGRectMake(49.0, (settingCell.frame.size.height - 2.0), (DEVICE_WIDTH - 49.0), 2.0)];
        
        //Set frame for open setting button
        [settingCell.btnOpenSettingButton setFrame: CGRectMake(48.0, 0.0, (DEVICE_WIDTH - 48.0), settingCell.frame.size.height)];
        
    } else if (IS_IPHONE8PLUS) {
        
        //Set setting name label font
        UIFont *fontSetting = [UIFont fontWithName: fFUTURA_MEDIUM size: 20.0];
        [settingCell.lblSettingNameLabel setFont: fontSetting];
        
        //Set setting icon
        if ([indexPath row] == 0) {
            
            [settingCell.imgSettingIcon setFrame: CGRectMake(50.0, ((settingCell.frame.size.height - 25.0) / 2.0) - 3.0, 34.0, 26.0)];
            [settingCell.lblSettingNameLabel setFrame: CGRectMake((settingCell.imgSettingIcon.frame.origin.x + settingCell.imgSettingIcon.frame.size.width + 12.0), (settingCell.frame.size.height - 30.0) / 2.0, (DEVICE_WIDTH - 148.0), 30.0)];
            
        } else if ([indexPath row] == 1) {
            
            [settingCell.imgSettingIcon setFrame: CGRectMake(54.0, ((settingCell.frame.size.height - 27.0) / 2.0) - 2.0, 24.0, 29.0)];
            [settingCell.lblSettingNameLabel setFrame: CGRectMake(96.0, (settingCell.frame.size.height - 30.0) / 2.0, (DEVICE_WIDTH - 148.0), 30.0)];
            
        } else if ([indexPath row] == 2) {
            
            [settingCell.imgSettingIcon setFrame: CGRectMake(53.0, ((settingCell.frame.size.height - 26.0) / 2.0) - 1.0, 27.0, 27.0)];
            [settingCell.lblSettingNameLabel setFrame: CGRectMake(96.0, (settingCell.frame.size.height - 30.0) / 2.0, (DEVICE_WIDTH - 148.0), 30.0)];
            
        } else {
            [settingCell.imgSettingIcon setFrame: CGRectMake(48.0, (settingCell.frame.size.height - 30.0) / 2.0, 0.0, 30.0)];
            [settingCell.lblSettingNameLabel setFrame: CGRectMake(50.0, ((settingCell.frame.size.height - 30.0) / 2.0) + 1.0, (DEVICE_WIDTH - 103.0), 30.0)];
        }
        
        //Next icon frame
        [settingCell.imgNextIcon setFrame: CGRectMake((DEVICE_WIDTH - 40.0), ((settingCell.frame.size.height - 25.0) / 2.0) - 1.0, 15.0, 26.0)];
        
        //Set underline view frame
        [settingCell.viewSettingUnderlineView setFrame: CGRectMake(49.0, (settingCell.frame.size.height - 2.0), (DEVICE_WIDTH - 49.0), 2.0)];
        
        //Set frame for open setting button
        [settingCell.btnOpenSettingButton setFrame: CGRectMake(48.0, 0.0, (DEVICE_WIDTH - 48.0), settingCell.frame.size.height)];
        
    } else if (IS_IPHONE8) {
        
        //Set setting name label font
        UIFont *fontSetting = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
        [settingCell.lblSettingNameLabel setFont: fontSetting];
        
        //Set setting icon
        if ([indexPath row] == 0) {
            
            [settingCell.imgSettingIcon setFrame: CGRectMake(42.0, ((settingCell.frame.size.height - 25.0) / 2.0) - 3.0, 34.0, 26.0)];
            [settingCell.lblSettingNameLabel setFrame: CGRectMake((settingCell.imgSettingIcon.frame.origin.x + settingCell.imgSettingIcon.frame.size.width + 12.0), (settingCell.frame.size.height - 30.0) / 2.0, (DEVICE_WIDTH - 148.0), 30.0)];
            
        } else if ([indexPath row] == 1) {
            
            [settingCell.imgSettingIcon setFrame: CGRectMake(46.0, ((settingCell.frame.size.height - 27.0) / 2.0) - 2.0, 24.0, 29.0)];
            [settingCell.lblSettingNameLabel setFrame: CGRectMake(88.0, (settingCell.frame.size.height - 30.0) / 2.0, (DEVICE_WIDTH - 148.0), 30.0)];
            
        } else if ([indexPath row] == 2) {
            
            [settingCell.imgSettingIcon setFrame: CGRectMake(45.0, ((settingCell.frame.size.height - 26.0) / 2.0) - 1.0, 27.0, 27.0)];
            [settingCell.lblSettingNameLabel setFrame: CGRectMake(88.0, (settingCell.frame.size.height - 30.0) / 2.0, (DEVICE_WIDTH - 148.0), 30.0)];
            
        } else {
            [settingCell.imgSettingIcon setFrame: CGRectMake(40.0, (settingCell.frame.size.height - 30.0) / 2.0, 0.0, 30.0)];
            [settingCell.lblSettingNameLabel setFrame: CGRectMake(42.0, ((settingCell.frame.size.height - 30.0) / 2.0) + 1.0, (DEVICE_WIDTH - 103.0), 30.0)];
        }
        
        //Next icon frame
        [settingCell.imgNextIcon setFrame: CGRectMake((DEVICE_WIDTH - 40.0), ((settingCell.frame.size.height - 25.0) / 2.0) - 1.0, 15.0, 26.0)];
        
        //Set underline view frame
        [settingCell.viewSettingUnderlineView setFrame: CGRectMake(41.0, (settingCell.frame.size.height - 2.0), (DEVICE_WIDTH - 41.0), 2.0)];
        
        //Set frame for open setting button
        [settingCell.btnOpenSettingButton setFrame: CGRectMake(40.0, 0.0, (DEVICE_WIDTH - 40.0), settingCell.frame.size.height)];
//        [settingCell.btnOpenSettingButton setBackgroundColor: UIColor.grayColor];
        
    } else {
        
        //Set setting name label font
        UIFont *fontSetting = [UIFont fontWithName: fFUTURA_MEDIUM size: 16.0];
        [settingCell.lblSettingNameLabel setFont: fontSetting];
        
        //Set setting icon
        if ([indexPath row] == 0) {
            
            [settingCell.imgSettingIcon setFrame: CGRectMake(42.0, ((settingCell.frame.size.height - 25.0) / 2.0) - 3.0, 34.0, 26.0)];
            [settingCell.lblSettingNameLabel setFrame: CGRectMake((settingCell.imgSettingIcon.frame.origin.x + settingCell.imgSettingIcon.frame.size.width + 12.0), (settingCell.frame.size.height - 30.0) / 2.0, (DEVICE_WIDTH - 148.0), 30.0)];
            
        } else if ([indexPath row] == 1) {
            
            [settingCell.imgSettingIcon setFrame: CGRectMake(46.0, ((settingCell.frame.size.height - 27.0) / 2.0) - 2.0, 24.0, 29.0)];
            [settingCell.lblSettingNameLabel setFrame: CGRectMake(88.0, (settingCell.frame.size.height - 30.0) / 2.0, (DEVICE_WIDTH - 148.0), 30.0)];
            
        } else if ([indexPath row] == 2) {
            
            [settingCell.imgSettingIcon setFrame: CGRectMake(45.0, ((settingCell.frame.size.height - 26.0) / 2.0) - 1.0, 27.0, 27.0)];
            [settingCell.lblSettingNameLabel setFrame: CGRectMake(88.0, (settingCell.frame.size.height - 30.0) / 2.0, (DEVICE_WIDTH - 148.0), 30.0)];
            
        } else {
            [settingCell.imgSettingIcon setFrame: CGRectMake(40.0, (settingCell.frame.size.height - 30.0) / 2.0, 0.0, 30.0)];
            [settingCell.lblSettingNameLabel setFrame: CGRectMake(42.0, ((settingCell.frame.size.height - 30.0) / 2.0) + 1.0, (DEVICE_WIDTH - 103.0), 30.0)];
        }
        
        //Next icon frame
        [settingCell.imgNextIcon setFrame: CGRectMake((DEVICE_WIDTH - 40.0), ((settingCell.frame.size.height - 25.0) / 2.0) - 1.0, 15.0, 26.0)];
        
        //Set underline view frame
        [settingCell.viewSettingUnderlineView setFrame: CGRectMake(41.0, (settingCell.frame.size.height - 2.0), (DEVICE_WIDTH - 41.0), 2.0)];
        
        //Set frame for open setting button
        [settingCell.btnOpenSettingButton setFrame: CGRectMake(48.0, 0.0, (DEVICE_WIDTH - 48.0), settingCell.frame.size.height)];
        
    }
    
    return settingCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (IS_IPHONEXR) {
        
        if ([indexPath row] == 0) {
            return 62.0;
        } else if ([indexPath row] == 1) {
            return 63.0;
        } else if ([indexPath row] == 2) {
            return 64.0;
        } else if ([indexPath row] == 3) {
            return 65.0;
        } else if ([indexPath row] == 4) {
            return 65.0;
        } else {
            return 65.0;
        }
        
    } else if (IS_IPHONEX) {
        
        if ([indexPath row] == 0) {
            return 62.0;
        } else if ([indexPath row] == 1) {
            return 63.0;
        } else if ([indexPath row] == 2) {
            return 64.0;
        } else if ([indexPath row] == 3) {
            return 65.0;
        } else if ([indexPath row] == 4) {
            return 65.0;
        } else {
            return 65.0;
        }
        
    } else if (IS_IPHONE8PLUS) {
        
        if ([indexPath row] == 0) {
            return 62.0;
        } else if ([indexPath row] == 1) {
            return 63.0;
        } else if ([indexPath row] == 2) {
            return 64.0;
        } else if ([indexPath row] == 3) {
            return 65.0;
        } else if ([indexPath row] == 4) {
            return 65.0;
        } else {
            return 65.0;
        }
        
    } else if (IS_IPHONE8) {

        return 58;
        
    } else {
        
        if ([indexPath row] == 0) {
            return 54.0;
        } else if ([indexPath row] == 1) {
            return 55.0;
        } else if ([indexPath row] == 2) {
            return 56.0;
        } else if ([indexPath row] == 3) {
            return 57.0;
        } else if ([indexPath row] == 4) {
            return 57.0;
        } else {
            return 57.0;
        }
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"");
}


//MARK:- Service manager delegate and parser methods

- (void)webServiceCallFailure:(NSError *)error forTag:(NSString *)tagname {
    NSLog(@"Web service call fails : %@", [error localizedDescription]);
    [self showScreenContents];
    [Utils hideActivityIndicator:spinner fromView:self.viewLoaderContentView];
    [Utils showToast: [error localizedDescription] duration: 3.0];
}

- (void)webServiceCallSuccess:(id)response forTag:(NSString *)tagname {
    
    if ([tagname isEqualToString: tLOGOUT]) {
        [self parseLogoutResponse: response];
    }
    
}

- (void) parseLogoutResponse: (id) response {
    
    [self showScreenContents];
    [Utils hideActivityIndicator:spinner fromView:self.viewLoaderContentView];
    
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    
    if ([[dicResponse valueForKey:@"status"] integerValue] == 1) {
        
        UIViewController *registerVC = [self.storyboard instantiateViewControllerWithIdentifier: @"LoginOptionViewController"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: registerVC];
        [[[[UIApplication sharedApplication] delegate] window] setRootViewController: navController];
        [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
        
        [[NSUserDefaults standardUserDefaults] setValue: nil forKey: kIS_USER_LOGGED_IN];
        [[NSUserDefaults standardUserDefaults] setValue: nil forKey: kUSER_WORKOUT_STATS];
        [Utils setIsPaidUser: @"NO"];
        
    } else {
        [Utils showToast: [dicResponse valueForKey: @"message"] duration: 3.0];
    }
    
}

//MARK:- User defined methods

- (void) setupLayout {
    
    //Tabbar initialization
    [[self tabBarController] setDelegate: self];
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
    
//    [[[[self tabBarController] tabBar] layer] setShadowOffset: CGSizeMake(0.0, 0.0)];
//    [[[[self tabBarController] tabBar] layer] setShadowRadius: 4.0];
//    [[[[self tabBarController] tabBar] layer] setShadowColor: UIColor.lightGrayColor.CGColor];
//    [[[[self tabBarController] tabBar] layer] setShadowOpacity: 0.25];
//
    
    //Loader view
    [_lblLoaderGymTimerLabel setTextColor: cGYM_TIMER_LABEL];
    [_lblLoaderGymTimerLabel setAlpha: 1.0];
    [_viewLoaderContentView setClipsToBounds: YES];
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: [_viewLoaderContentView bounds] byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){30.0, 30.}].CGPath;
    [[_viewLoaderContentView layer] setMask: maskLayer];
    
    [_lblSettingsTitleLabel setTextColor: cSTART_BUTTON];
    [_tblSettingsTableView setScrollEnabled: YES];
    [_tblSettingsTableView setBounces: YES];
    
    if (IS_IPHONEXR) {
        
        //Loader view
        [_lblLoaderGymTimerLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblLoaderGymTimerLabel setFont: fontGymTimerLabel];
        [_viewLoaderContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        //Scroll and content view
        [_scrollViewSettingsScreen setFrame: CGRectMake(0.0, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        [_scrollViewSettingsScreen setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + 1.0)];
        [_scrollViewSettingsScreen setDelegate: self];
        [_contentViewSettingsScreen setFrame: CGRectMake(0.0, 0.0, (_scrollViewSettingsScreen.contentSize.width), (_scrollViewSettingsScreen.contentSize.height + 1.0))];
        
        //        [_scrollViewSettingsScreen setBackgroundColor: UIColor.redColor];
        //        [_contentViewSettingsScreen setBackgroundColor: UIColor.yellowColor];
        
        //Settings label
        [_lblSettingsTitleLabel setFrame: CGRectMake(0.0, 17.0, DEVICE_WIDTH, 90.0)];
        UIFont *fontSettings = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 70.0];
        [_lblSettingsTitleLabel setFont: fontSettings];
        
        //SettingsList table view
        [_tblSettingsTableView setFrame: CGRectMake(0.0, 185.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 214.0))];
        [_tblSettingsTableView setScrollEnabled: NO];
        
    } else if (IS_IPHONEX) {
        
        //Loader view
        [_lblLoaderGymTimerLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblLoaderGymTimerLabel setFont: fontGymTimerLabel];
        [_viewLoaderContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        //Scroll and content view
        [_scrollViewSettingsScreen setFrame: CGRectMake(0.0, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        [_scrollViewSettingsScreen setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + 1.0)];
        [_scrollViewSettingsScreen setDelegate: self];
        [_contentViewSettingsScreen setFrame: CGRectMake(0.0, 0.0, (_scrollViewSettingsScreen.contentSize.width), (_scrollViewSettingsScreen.contentSize.height + 1.0))];
        
//        [_scrollViewSettingsScreen setBackgroundColor: UIColor.redColor];
//        [_contentViewSettingsScreen setBackgroundColor: UIColor.yellowColor];
        
        //Settings label
        [_lblSettingsTitleLabel setFrame: CGRectMake(0.0, 17.0, DEVICE_WIDTH, 90.0)];
        UIFont *fontSettings = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 70.0];
        [_lblSettingsTitleLabel setFont: fontSettings];
        
        //SettingsList table view
        [_tblSettingsTableView setFrame: CGRectMake(0.0, 135.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 214.0))];
        [_tblSettingsTableView setScrollEnabled: NO];
        
    } else if (IS_IPHONE8PLUS) {
        
        //Loader view
        [_lblLoaderGymTimerLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblLoaderGymTimerLabel setFont: fontGymTimerLabel];
        [_viewLoaderContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        //Scroll and content view
        [_scrollViewSettingsScreen setFrame: CGRectMake(0.0, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        [_scrollViewSettingsScreen setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + 1.0)];
        [_scrollViewSettingsScreen setDelegate: self];
        [_contentViewSettingsScreen setFrame: CGRectMake(0.0, 0.0, (_scrollViewSettingsScreen.contentSize.width), (_scrollViewSettingsScreen.contentSize.height + 1.0))];
        
        //        [_scrollViewSettingsScreen setBackgroundColor: UIColor.redColor];
        //        [_contentViewSettingsScreen setBackgroundColor: UIColor.yellowColor];
        
        //Settings label
        [_lblSettingsTitleLabel setFrame: CGRectMake(0.0, 17.0, DEVICE_WIDTH, 90.0)];
        UIFont *fontSettings = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 70.0];
        [_lblSettingsTitleLabel setFont: fontSettings];
        
        //SettingsList table view
        [_tblSettingsTableView setFrame: CGRectMake(0.0, 150.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 214.0))];
        [_tblSettingsTableView setScrollEnabled: NO];
        
    } else if (IS_IPHONE8) {
        
        //Loader view
        [_lblLoaderGymTimerLabel setFrame: CGRectMake(0.0, 32.0, DEVICE_WIDTH, 30.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 28.0];
        [_lblLoaderGymTimerLabel setFont: fontGymTimerLabel];
        [_viewLoaderContentView setFrame: CGRectMake(0.0, 100.0, DEVICE_WIDTH, DEVICE_HEIGHT - 100.0)];
        
        //Scroll and content view
        [_scrollViewSettingsScreen setFrame: CGRectMake(0.0, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        [_scrollViewSettingsScreen setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + 5.0)];
        [_scrollViewSettingsScreen setDelegate: self];
        [_contentViewSettingsScreen setFrame: CGRectMake(0.0, 0.0, (_scrollViewSettingsScreen.contentSize.width), (_scrollViewSettingsScreen.contentSize.height + 1.0))];

        //Settings label
        [_lblSettingsTitleLabel setFrame: CGRectMake(0.0, -4.0, DEVICE_WIDTH, 90.0)];
        UIFont *fontSettings = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 62.0];
        [_lblSettingsTitleLabel setFont: fontSettings];
        
        //SettingsList table view
        [_tblSettingsTableView setFrame: CGRectMake(0.0, 100.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 170.0))];
        [_tblSettingsTableView setScrollEnabled: NO];
        
    } else {
        
        //Loader view
        [_lblLoaderGymTimerLabel setFrame: CGRectMake(0.0, 32.0, DEVICE_WIDTH, 30.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 28.0];
        [_lblLoaderGymTimerLabel setFont: fontGymTimerLabel];
        [_viewLoaderContentView setFrame: CGRectMake(0.0, 100.0, DEVICE_WIDTH, DEVICE_HEIGHT - 100.0)];
        
        //Scroll and content view
        [_scrollViewSettingsScreen setFrame: CGRectMake(0.0, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        [_scrollViewSettingsScreen setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + 1.0)];
        [_scrollViewSettingsScreen setDelegate: self];
        [_contentViewSettingsScreen setFrame: CGRectMake(0.0, 0.0, (_scrollViewSettingsScreen.contentSize.width), (_scrollViewSettingsScreen.contentSize.height + 1.0))];
        
        //        [_scrollViewSettingsScreen setBackgroundColor: UIColor.redColor];
        //        [_contentViewSettingsScreen setBackgroundColor: UIColor.yellowColor];
        
        //Settings label
        [_lblSettingsTitleLabel setFrame: CGRectMake(0.0, -8.0, DEVICE_WIDTH, 90.0)];
        UIFont *fontSettings = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 60.0];
        [_lblSettingsTitleLabel setFont: fontSettings];
        
        //SettingsList table view
        [_tblSettingsTableView setFrame: CGRectMake(0.0, 100.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 120.0))];
        [_tblSettingsTableView setScrollEnabled: NO];
        
    }
    
    [self showScreenContents];
    
}

- (void) initializeData {
    
    serviceManager = [[ServiceManager alloc] init];
    [serviceManager setDelegate: self];
    
    utils = [[Utils alloc] init];
    progressHUD = [utils prototypeHUD];
    
    //Register setting nib
    UINib *settingNib = [UINib nibWithNibName: tblSETTINGS_CELL bundle: nil];
    [_tblSettingsTableView registerNib: settingNib forCellReuseIdentifier: tblSETTINGS_CELL];
    
    //Initialize settings list array and reload table
    arrSettingsList = @[@"Upgrade to PRO", @"Profile", @"Workout advice", @"Restore Purchase", @"Privacy Policy", @"Terms Of Use", @"Contact Us", @"Log Out"];
    [_tblSettingsTableView setDelegate: self];
    [_tblSettingsTableView setDataSource: self];
    [_tblSettingsTableView reloadData];
    
    currentScrollViewYOffset = [_scrollViewSettingsScreen contentOffset].y;
}

- (void) showScreenContents {
    [_viewLoaderBackgroundView setHidden: YES];
    [_scrollViewSettingsScreen setHidden: NO];
    [self showTabBar];
}

- (void) hideScreenContents {
    [_viewLoaderBackgroundView setHidden: NO];
    [_scrollViewSettingsScreen setHidden: YES];
    [self hideTabBar];
}

- (void)showTabBar {
    
    [UIView animateWithDuration: 1.0 delay: 0.0 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [[[self tabBarController] tabBar] setTranslucent: YES];
        [[[self tabBarController] tabBar] setHidden: NO];
    } completion:^(BOOL finished) {}];
}

- (void)hideTabBar {
    
    [UIView animateWithDuration: 1.0 delay: 0.0 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [[[self tabBarController] tabBar] setTranslucent: YES];
        [[[self tabBarController] tabBar] setHidden: YES];
    } completion:^(BOOL finished) {}];
    
}

- (void)callLogoutAPI {
    
    NSArray *arrSendFaqParams = @[
                                  @{ @"user_id" : [[Utils getUserDetails] valueForKey: @"id"]}
                                  ];
    
    if ([Utils isConnectedToInternet]) {
        
        [self hideScreenContents];
        spinner = [Utils showActivityIndicatorInView: self.viewLoaderContentView];
        NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uLOGOUT];
        [serviceManager callWebServiceWithPOST: webpath withTag: tLOGOUT params: arrSendFaqParams];
        
    }
}

// MARK:- Selector's methods

- (void) handleTapOnOpenSetting: (UIButton *) button {
    
    NSInteger settingRow = [button tag];
    UpgradeToProVC *upgradeToProVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UpgradeToProVC"];
    
    switch (settingRow) {
        case 0:
            upgradeToProVC.isFromSetting = @"Yes";
            [[self navigationController] pushViewController: upgradeToProVC animated: YES];
            break;
            
        case 1:
            [[self navigationController] pushViewController: GETCONTROLLER(@"ProfileViewController") animated: YES];
            break;
            
        case 2:
            [[self navigationController] pushViewController: GETCONTROLLER(@"WorkoutAdviceViewController") animated: YES];
            break;
            
        case 3:
            if ([Utils isConnectedToInternet]) {
                //This is called when the user restores purchases
                [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
                [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
            } 
            break;
            
        case 4:
            [[self navigationController] pushViewController: GETCONTROLLER(@"PrivacyPolicyViewController") animated: YES];
            break;
            
        case 5:
            [[self navigationController] pushViewController: GETCONTROLLER(@"TermsOfUseViewController") animated: YES];
            break;
            
        case 6:
            [[self navigationController] pushViewController: GETCONTROLLER(@"ContactUsViewController") animated: YES];
            break;
        case 7:
            [self callLogoutAPI];
        default:
            break;
    }
    
}

// MARK:- In-App Purchase

- (void)inAppPurchaseWithProductId:(NSString *)productId {
    
    NSLog(@"User requests to Purchase Product");
    
    if ([SKPaymentQueue canMakePayments]) {
        NSLog(@"User can make payments");
        
        //Request product with product identifier
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:productId]];
        
        //Set Delegate
        productsRequest.delegate = self;
        
        //Send request to App Store
        [productsRequest start];
        
    } else {
        //Hide Spinner
        [Utils hideActivityIndicator:spinner fromView:self.view];
        
        [self displayAlert:@"GymTimer" message:@"Sorry, Due to parental controls we could not process your purchase."];
        NSLog(@"User cannot make payments due to parental controls");
    }
}

- (void)purchase:(SKProduct *)product {
    //Get Product Price
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    //Add Observer In Payment Queue
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    //Add payment request in Queue
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

// MARK:- SKProductsRequest Delegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    SKProduct *validProduct = nil;
    
    if (response.products.count > 0) {
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        
        [self purchase:validProduct];
    } else if (!validProduct) {
        //Hide Spinner
        [Utils hideActivityIndicator:spinner fromView:self.view];
        
        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Failed to load list of products.");
    NSLog(@"Error: %@",error.localizedDescription);
    
    //Hide Spinner
    [Utils hideActivityIndicator:spinner fromView:self.view];
}

- (void)requestDidFinish:(SKRequest*)request {
    if ([request isKindOfClass:[SKReceiptRefreshRequest class]]) {
        NSLog(@"YES, You purchased this app");
    }
}

// MARK:- SKPaymentTransactionObserver

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    NSLog(@"Received restored transactions: %lu", (unsigned long)queue.transactions.count);
    
    if (queue.transactions.count < 1) {
        [self displayAlert:@"GymTimer" message:@"There are no items available to restore at this time."];
        return;
    }
    
    for (SKPaymentTransaction *transaction in queue.transactions) {
        if (transaction.transactionState == SKPaymentTransactionStateRestored) {
            
            //Hide Spinner
            [Utils hideActivityIndicator:spinner fromView:self.view];
            
            //Called when the user successfully restores a purchase
            NSLog(@"Transaction state -> Restored");
            
            NSString *productID = transaction.payment.productIdentifier;
            if ([productID isEqual:kProductIdForOneMonth]) {
                NSLog(@"Product ID: %@",kProductIdForOneMonth);
            } else if ([productID isEqual:kProductIdForOneYear]) {
                NSLog(@"Product ID: %@",kProductIdForOneYear);
            }
            
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }
    
    //Check If user is Pro or Free
    
    if ([Utils isConnectedToInternet]) {
        BOOL isProUser = [self checkInAppPurchaseStatus];
        
        //Hide Spinner
        [Utils hideActivityIndicator:spinner fromView:self.view];
        
        if (isProUser) {
            [self proUserAlertWithMessage:@"Your purchase restored successfully. You are now a Pro user."];
            [Utils setIsPaidUser: @"YES"];
        } else {
            [self proUserAlertWithMessage:@"Your purchase restored successfully. No active subscription found."];
            [Utils setIsPaidUser:@"NO"];
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    //Hide Spinner
    [Utils hideActivityIndicator:spinner fromView:self.view];
    
    if ([error.domain isEqual:SKErrorDomain] && error.code == SKErrorPaymentCancelled) {
        return;
    }
    [self displayAlert:@"GymTimer" message:@"There are no items available to restore at this time."];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    
    NSString *strMessage = [[NSString alloc] init];
    
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                //User Purchasing Product
                NSLog(@"Transaction state -> Purchasing");
                break;
                
            case SKPaymentTransactionStatePurchased:
                //Hide Spinner
                [Utils hideActivityIndicator:spinner fromView:self.view];
                
                NSLog(@"Transaction state -> Purchased");
                
                //User Purchased Product
                [Utils setIsPaidUser: @"YES"];
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                [self proUserAlertWithMessage:@"You are now a Pro user."];
                break;
                
            case SKPaymentTransactionStateRestored:
                //Hide Spinner
                [Utils hideActivityIndicator:spinner fromView:self.view];
                
                NSLog(@"Transaction state -> Restored");
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                break;
                
            case SKPaymentTransactionStateFailed:
                //Hide Spinner
                [Utils hideActivityIndicator:spinner fromView:self.view];
                
                //User Purchase Failed
                if (transaction.error.code == SKErrorPaymentCancelled) {
                    strMessage = @"Payment Cancelled.";
                    NSLog(@"Transaction state -> User Cancelled");
                } else if (transaction.error.code == SKErrorPaymentInvalid) {
                    strMessage = @"Payment Invalid.";
                    NSLog(@"Transaction state -> Payment Invalid");
                } else if (transaction.error.code == SKErrorPaymentNotAllowed) {
                    strMessage = @"Payment Not Allowed.";
                    NSLog(@"Transaction state -> Payment NotAllowed");
                }
                
                [self displayAlert:@"GymTimer" message:strMessage];
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateDeferred:
                //Hide Spinner
                [Utils hideActivityIndicator:spinner fromView:self.view];
                
                strMessage = @"Something went wrong please try again later.";
                [self displayAlert:@"GymTimer" message:strMessage];
                
                NSLog(@"Transaction state -> Deferred");
                break;
        }
    }
}

//MARK:- In-App Purchase Receipt Validation

- (BOOL)checkInAppPurchaseStatus {
    
    //Start Spinner
    spinner = [Utils showActivityIndicatorInView: self.view];
    
    // Load the receipt from the app bundle.
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
    
    if (receipt) {
        BOOL sandbox = [[receiptURL lastPathComponent] isEqualToString:@"sandboxReceipt"];
        // Create the JSON object that describes the request
        NSError *error;
        NSDictionary *requestContents = @{
                                          @"receipt-data": [receipt base64EncodedStringWithOptions:0],
                                          @"password": kSharedSecret
                                          };
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                              options:0
                                                                error:&error];
        
        if (requestData) {
            // Create a POST request with the receipt data.
            NSURL *storeURL = [NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
            if (sandbox) {
                storeURL = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
            }
            NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
            [storeRequest setHTTPMethod:@"POST"];
            [storeRequest setHTTPBody:requestData];
            
            BOOL rs = NO;
            
            NSError *error;
            NSURLResponse *response;
            NSData *resData = [NSURLConnection sendSynchronousRequest:storeRequest returningResponse:&response error:&error];
            if (error) {
                rs = NO;
            } else {
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:resData options:0 error:&error];
                if (!jsonResponse) {
                    rs = NO;
                } else {
                    NSLog(@"jsonResponse:%@", jsonResponse);
                    
                    NSDictionary *dictLatestReceiptsInfo = jsonResponse[@"latest_receipt_info"];
                    
                    long long int expirationDateMs = [[dictLatestReceiptsInfo valueForKeyPath:@"@max.expires_date_ms"] longLongValue];
                    long long requestDateMs = [jsonResponse[@"receipt"][@"request_date_ms"] longLongValue];
                    
                    NSLog(@"%lld--%lld", expirationDateMs, requestDateMs);
                    rs = [[jsonResponse objectForKey:@"status"] integerValue] == 0 && (expirationDateMs > requestDateMs);
                }
            }
            //Hide Spinner
            [Utils hideActivityIndicator:spinner fromView:self.view];
            
            return rs;
        } else {
            //Hide Spinner
            [Utils hideActivityIndicator:spinner fromView:self.view];
            
            return NO;
        }
    } else {
        //Hide Spinner
        [Utils hideActivityIndicator:spinner fromView:self.view];
        
        return NO;
    }
}

//MARK:- UIAlertView Releted

- (void)displayAlert:(NSString *)title  message:(NSString *)msg {
    UIAlertController *alert = [UIAlertController  alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)proUserAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController  alertControllerWithTitle:@"GymTimer" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //[self.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
