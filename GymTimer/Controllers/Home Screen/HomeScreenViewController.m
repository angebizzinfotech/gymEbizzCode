//
//  HomeScreenViewController.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 17/04/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "CommonImports.h"

@interface HomeScreenViewController() {
    UIFont *fontTabBarTitle;
}

@end

@implementation HomeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(hideTabbar) name: @"HideTabBar" object: nil];
    [[NSNotificationCenter defaultCenter] postNotificationName: nNOTIFICATION_PERMISSION object: nil];
    [self setupLayout];
    
}

- (void)viewDidLayoutSubviews {
    if (IS_IPHONEX || IS_IPHONEXR) {
        [self.tabBar setFrame:CGRectMake(0.0, (DEVICE_HEIGHT - 88.0), DEVICE_WIDTH, 88.0)];
    } else if (IS_IPHONE8) {
        [self.tabBar setFrame:CGRectMake(0.0, (DEVICE_HEIGHT - 80.0), DEVICE_WIDTH, 80.0)];
        
        UITabBarItem *tabBarItem0 = [self.tabBarController.tabBar.items objectAtIndex:0];
        UITabBarItem *tabBarItem1 = [self.tabBarController.tabBar.items objectAtIndex:1];
        UITabBarItem *tabBarItem2 = [self.tabBarController.tabBar.items objectAtIndex:2];
        UITabBarItem *tabBarItem3 = [self.tabBarController.tabBar.items objectAtIndex:3];

        
        [tabBarItem0 setImage:[[UIImage imageNamed:@"gray_workout"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [tabBarItem0 setSelectedImage:[[UIImage imageNamed:@"green_workout"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [tabBarItem1 setImage:[[UIImage imageNamed:@"gray_rank"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [tabBarItem1 setSelectedImage:[[UIImage imageNamed:@"green_rank"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

        [tabBarItem2 setImage:[[UIImage imageNamed:@"gray_stats"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [tabBarItem2 setSelectedImage:[[UIImage imageNamed:@"green_stats"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [tabBarItem3 setImage:[[UIImage imageNamed:@"gray_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [tabBarItem3 setSelectedImage:[[UIImage imageNamed:@"green_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [tabBarItem0 setTitlePositionAdjustment: UIOffsetMake(0.0, -20.0)];
        [tabBarItem0 setImageInsets: UIEdgeInsetsMake(-20.0, 0.0, 0.0, 0.0)];
        [tabBarItem1 setTitlePositionAdjustment: UIOffsetMake(0.0, -20.0)];
        [tabBarItem1 setImageInsets: UIEdgeInsetsMake(-20.0, 0.0, 0.0, 0.0)];
        [tabBarItem2 setTitlePositionAdjustment: UIOffsetMake(0.0, -20.0)];
        [tabBarItem2 setImageInsets: UIEdgeInsetsMake(-20.0, 0.0, 0.0, 0.0)];
        [tabBarItem3 setTitlePositionAdjustment: UIOffsetMake(0.0, -20.0)];
        [tabBarItem3 setImageInsets: UIEdgeInsetsMake(-20.0, 0.0, 0.0, 0.0)];

    }
}

//MARK:- User defined methods

- (void) setupLayout {
    
    //hide navigation bar
    [[self navigationController] setNavigationBarHidden: YES];
    
    [[UITabBar appearance] setBackgroundColor: UIColor.whiteColor];
    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"Shadow Image"]];
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"Shadow Image"]];
    
    //Set tabbar items
    NSMutableArray *arrTabBarItems = [[NSMutableArray alloc] init];

    UITabBarItem *itemWorkout = [[UITabBarItem alloc] initWithTitle: @"Workout" image: [UIImage imageNamed: @"imgWorkoutGrayRight"] selectedImage: [UIImage imageNamed: @"imgWorkoutGreenRight"]];
    UITabBarItem *itemRanking = [[UITabBarItem alloc] initWithTitle: @"Ranking" image: [UIImage imageNamed: @"imgRankGray"] selectedImage: [UIImage imageNamed: @"imgRankGreen"]];
    UITabBarItem *itemStats = [[UITabBarItem alloc] initWithTitle: @"Stats" image: [UIImage imageNamed: @"imgStatsGray"] selectedImage: [UIImage imageNamed: @"imgStatsGreen"]];
    UITabBarItem *itemSettings = [[UITabBarItem alloc] initWithTitle: @"Settings" image: [UIImage imageNamed: @"test"] selectedImage: [UIImage imageNamed: @"test"]];
    
    [arrTabBarItems addObject: itemWorkout];
    [arrTabBarItems addObject: itemRanking];
    [arrTabBarItems addObject: itemStats];
    [arrTabBarItems addObject: itemSettings];
    [[[self tabBarController] tabBar] setItems: arrTabBarItems];
//    [[UITabBar appearance] setTintColor: cSTART_BUTTON];
    
    //Set title text appearence
    if (IS_IPHONEXR) {
        fontTabBarTitle = [UIFont fontWithName: fFUTURA_MEDIUM size: 12.0];
    } else if (IS_IPHONEX) {
        fontTabBarTitle = [UIFont fontWithName: fFUTURA_MEDIUM size: 12.0];
    } else if (IS_IPHONE8PLUS) {
        fontTabBarTitle = [UIFont fontWithName: fFUTURA_MEDIUM size: 12.0];
    } else if (IS_IPHONE8) {
        fontTabBarTitle = [UIFont fontWithName: fFUTURA_MEDIUM size: 12.0];
    } else {
        fontTabBarTitle = [UIFont fontWithName: fFUTURA_MEDIUM size: 10.0];
    }
    
    NSDictionary *dicNormal = @{NSForegroundColorAttributeName : UIColor.grayColor, NSFontAttributeName : fontTabBarTitle};
    [[UITabBarItem appearance] setTitleTextAttributes: dicNormal forState: UIControlStateNormal];
    
    NSDictionary *dicSelected = @{NSForegroundColorAttributeName : cSTART_BUTTON, NSFontAttributeName : fontTabBarTitle};
    [[UITabBarItem appearance] setTitleTextAttributes: dicSelected forState: UIControlStateSelected];    
}

- (void) hideTabbar {
    
    [self setHidesBottomBarWhenPushed: YES];
    [[self tabBar] setHidden: YES];
    
}

@end
