//
//  RankingViewController.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 05/09/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "RankingViewController.h"
#import "CommonImports.h"
#import <UICountingLabel/UICountingLabel.h>
#import <UICountingLabel-umbrella.h>
#import "SearchFriendCell.h"
#import <SDWebImage/SDWebImage.h>
#import "HeaderReqstRecvd.h"
#import "HeaderReqstAcpt.h"
#import "RequestReceivedCell.h"
#import "RequestAccptedCell.h"
#import "RatingListViewController.h"

@import pop;

@interface RankingViewController () <UITabBarControllerDelegate, AVAudioPlayerDelegate, ServiceManagerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextFieldDelegate > {
    
    ServiceManager *serviceManager;
    Utils *utils;
    JGProgressHUD *progressHUD;
    UIActivityIndicatorView *spinner;
    NSMutableArray *arrSearchFriend;
    NSMutableArray *arrAcceptedRequest;
    NSMutableArray *arrReceivedRequest;
    NSIndexPath *selectedIndex;
    UIRefreshControl *refreshControl;
    CGFloat KeyboardHgt, IsBounced;
    
    BOOL isSearchClicked;
    
    // Vsn - 05/04/2020
    int page_token;
    UIActivityIndicatorView *loader;
    NSTimer *searchTimer;
    // End
}

@end

@implementation RankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Vsn - 05/04/2020
    page_token = 0;
    arrSearchFriend = [[NSMutableArray alloc] init];
    loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleLarge];
    loader.frame = CGRectMake(0.0, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT);
    [loader setHidesWhenStopped: true];
    [self.view addSubview: loader];
    // End
    
    isSearchClicked = NO;
    IsBounced = NO;
    _txtSearch.delegate = self;
    KeyboardHgt = 20.0;
    serviceManager = [[ServiceManager alloc] init];
    serviceManager.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    RatingListViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"RatingListViewController"];
    loginView.parent = self;
    [self addChildViewController:loginView];
    [loginView.view setFrame:CGRectMake(0.0f, 0.0f, _viewMainRanking.frame.size.width, _viewMainRanking.frame.size.height)];
    [_viewMainRanking addSubview:loginView.view];
    [loginView didMoveToParentViewController:self];

    _scrlViewSearch.hidden = YES;
    
    [self setupLayout];
    [self setupLoaderView];
    [self addPullToRefresh];
    //[self tabBarSetup];
    
    UITabBarItem *tabBarItem0 = [self.tabBarController.tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem1 = [self.tabBarController.tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem2 = [self.tabBarController.tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem3 = [self.tabBarController.tabBar.items objectAtIndex:3];
    
    if (@available(iOS 13.0, *)){
        if (IS_IPHONEXR || IS_IPHONEX ) {
                
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
    
    //Manage Friend Requests Table Height.
    if (_constTblFriendsHeight.constant < self.scrFriendRequest.frame.size.height) {
        _constTblFriendsHeight.constant = (self.scrFriendRequest.frame.size.height - self.tblFriendRequests.frame.origin.y) + 20;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UpdateTabBarBadge object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    
    [_btnShare.layer setCornerRadius:_btnShare.frame.size.width/2];
    
    if (@available(iOS 11.0, *)) {
        self.scrlViewSearch.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.scrSearch.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.scrFriendRequest.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self createDesigns];
    });
    
    for (UIView *obj in [self.tabBarController.view subviews]) {
        if (obj.tag == 101) {
            [obj removeFromSuperview];
        }
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:HasNewNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    isSearchClicked = NO;
}

- (void)viewWillLayoutSubviews {
    
    if (IS_IPHONEXR || IS_IPHONEX) {
        [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - 88.0), DEVICE_WIDTH, 88.0)];
    } else if (IS_IPHONE8) {
        [[[self tabBarController] tabBar] setFrame: CGRectMake(0.0, (DEVICE_HEIGHT - 80.0), DEVICE_WIDTH, 80.0)];
        
        [self.scrlViewSearch setContentSize:CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT - 40)];
    }
    
}

- (void)layoutSubviews {
    
    [self.progressFriends.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.layer.masksToBounds = YES;
        obj.layer.cornerRadius = self.progressFriends.frame.size.height / 2.0;
    }];
    
}

//MARK:- Notification center
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    KeyboardHgt = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSLog(@"%f", KeyboardHgt);
    //_constVwNoFriendsYet.constant = KeyboardHgt;
}


//MARK:- Textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _constVwNoFriendsYet.constant = KeyboardHgt-30;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    _constVwNoFriendsYet.constant = 50;
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

//MARK:- UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == _scrSearch) {
        [self.view endEditing:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scrlViewSearch) {
        if (IS_IPHONEX) {
            [_scrlViewSearch setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    } else if (scrollView == _scrSearch) {
        if (self.constTblSearchHeight.constant < self.scrSearch.frame.size.height) {
            [self.scrSearch setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        if(scrollView.contentOffset.y > 0)
        {
            NSLog(@"end scroll");
            if(page_token != -1)
            {
                [loader startAnimating];
                [self SearchFriendAPI: _txtSearch.text];
            }
        }
    } else if (scrollView == _scrFriendRequest) {
        if (self.constTblFriendsHeight.constant < self.scrFriendRequest.frame.size.height) {
            [self.scrFriendRequest setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

//MARK:- User defined methods

- (void)tabBarSetup {
    UITabBarItem *tabBarItem0 = [self.tabBarController.tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem1 = [self.tabBarController.tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem2 = [self.tabBarController.tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem3 = [self.tabBarController.tabBar.items objectAtIndex:3];
    
    if (@available(iOS 13.0, *)){
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
    
    
    [[[self.tabBarController tabBar] layer] setBorderWidth:1.0];
    [[[self.tabBarController tabBar] layer] setBorderColor: [[UIColor lightGrayColor] CGColor]];
}

- (void) setupLoaderView {
    
    //Loader view
    [_viewLoaderContentView setClipsToBounds: YES];
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: [_viewLoaderContentView bounds] byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){30.0, 30.}].CGPath;
    [[_viewLoaderContentView layer] setMask: maskLayer];
    
    //Loader view
    [_viewLoaderContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
    
}
- (void) showLoaderView {
    [_viewLoaderBackgroundView setHidden: NO];
}

- (void) hideLoaderView {
    [_viewLoaderBackgroundView setHidden: YES];
}

- (void) createDesigns {
    _viewSearch.layer.cornerRadius = _viewSearch.frame.size.height / 2;
    _viewParentSearch.layer.cornerRadius = _viewParentSearch.frame.size.height / 2;
    _viewFriendRequest.layer.cornerRadius = _viewFriendRequest.frame.size.height / 2;
    _viewProMember.layer.cornerRadius = 20;
    
    //search placeholder color
    UIColor *color = [UIColor whiteColor];
    _txtSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Type your friend's names..." attributes:@{NSForegroundColorAttributeName: color}];

    _progressFriends.layer.cornerRadius = _progressFriends.layer.frame.size.height/2;
    
    {
        UIBezierPath *enduranceShadow = [UIBezierPath bezierPathWithRoundedRect:[_viewProMember bounds] cornerRadius:20];
        [[_viewProMember layer] setMasksToBounds: NO];
        [[_viewProMember layer] setShadowColor: [[UIColor blackColor] CGColor]];
        [[_viewProMember layer] setShadowOffset: CGSizeMake(0, 2)];
        [[_viewProMember layer] setShadowRadius: 5.0];
        [[_viewProMember layer] setShadowOpacity: 0.2];
        [_viewProMember.layer setRasterizationScale:[UIScreen.mainScreen scale]];
        [[_viewProMember layer] setShadowPath: [enduranceShadow CGPath]];
    }

    //Font mgt.
    if (IS_IPHONEXR) {
        [_lblGetMembership setFont: [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0]];
    } else if (IS_IPHONEX) {
        [_lblGetMembership setFont: [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0]];
    } else if (IS_IPHONE8PLUS) {
        [_lblGetMembership setFont: [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 35.0]];
    } else if (IS_IPHONE8) {
        _constHgtMainView.constant = _viewAddDetail.frame.origin.y + _viewAddDetail.frame.size.height + 20;

        [_lblGetMembership setFont: [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 30.0]];
    } else {
        [_lblGetMembership setFont: [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 20.0]];
    }
}

- (void)showMainSearch {
    self.scrlViewSearch.hidden = NO;
    self.scrlViewSearch.alpha = 0.0;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.scrlViewSearch.alpha = 1.0;
    } completion:nil];

//    [self getFriendsCountAPI];
    
    //Show Get Free popup if not Pro
    if ([[Utils getIsPaidUser] isEqualToString: @"YES"]) {
        //Hide
        [self->_viewProMember setHidden:YES];
        self->_constAddDetailTop.constant = -10.0;
        
        CGFloat screenWdth = UIScreen.mainScreen.bounds.size.width;
        self->_constVwFreeRight.constant = screenWdth / 2.0;
        self->_constVwFreeLeft.constant = screenWdth / 2.0;

    } else {
        //Show
        // Vsn - 09/04/2020
//        [self->_viewProMember setHidden:NO];
        // End
        self->_constAddDetailTop.constant = 15.0;

        self->_constVwFreeRight.constant = 16.0;
        self->_constVwFreeLeft.constant = 16.0;

    }
    
}

- (void)setupLayout {
    if (IS_IPHONEXR) {
        self.constVwYouCanTop.constant = 26;
    } else if (IS_IPHONE8) {
        // Setup layout
        self.constBtnCloseTop.constant = 28;
        self.constBtnSearchCloseTop.constant = 28;
        self.constImgGiftTop.constant = 16;
        self.constVwProgressHeight.constant = 76;
        self.constLblProgressBottom.constant = -4;
        self.constGetMembershipBottom.constant = 0;
        self.constLblAddMsgTop.constant = 8;
        self.constLblAddMsgHeight.constant = 21;
        
        [self.lblAddMsg setFont:[UIFont fontWithName:fFUTURA_MEDIUM size:12.0]];
        
        // Set aspect ration to view
        NSLayoutConstraint *aspectRatioConstraint = [NSLayoutConstraint constraintWithItem:self.viewProMember attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.viewProMember attribute:NSLayoutAttributeWidth multiplier:0.75 constant:0];
        [self.viewProMember addConstraint:aspectRatioConstraint];
        
    } else {
        self.constVwYouCanTop.constant = 8;
    }
    
    _tblSearchFriends.delegate = self;
    _tblSearchFriends.dataSource = self;
    
    _tblFriendRequests.delegate = self;
    _tblFriendRequests.dataSource = self;
    
    _viewSearchFriend.hidden = YES;
    
    _txtSearch.delegate = self;
    
    UINib *friendCellNib = [UINib nibWithNibName: @"SearchFriendCell" bundle: nil];
    [_tblSearchFriends registerNib:friendCellNib forCellReuseIdentifier:@"SearchFriendCell"];

    UINib *reqstAcptedNib = [UINib nibWithNibName: @"RequestAccptedCell" bundle: nil];
    [_tblFriendRequests registerNib:reqstAcptedNib forCellReuseIdentifier:@"RequestAccptedCell"];

    UINib *reqstRecvdNib = [UINib nibWithNibName: @"RequestReceivedCell" bundle: nil];
    [_tblFriendRequests registerNib:reqstRecvdNib forCellReuseIdentifier:@"RequestReceivedCell"];
    
    UINib *noRequestNib = [UINib nibWithNibName:@"NoRequestTableViewCell" bundle:nil];
    [_tblFriendRequests registerNib:noRequestNib forCellReuseIdentifier:@"NoRequestTableViewCell"];
    
    //Tabbar initialization
    [[self tabBarController] setDelegate: self];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 0] setTitle: @"Workout"];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 1] setTitle: @"Ranking"];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 2] setTitle: @"Stats"];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 3] setTitle: @"Settings"];
    
    [[UITabBar appearance] setClipsToBounds:YES];
    [[UITabBar appearance] setBackgroundImage:nil];
    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"Shadow Image"]];
    [[self.tabBarController.tabBar layer] setBorderWidth:0.0];
    [self.tabBarController.tabBar setValue:@(YES) forKeyPath:@"_hidesShadow"];

    //Add shadow to upper part of tabbar
    [[[[self tabBarController] tabBar] layer] setShadowOffset: CGSizeMake(0.0, 0.0)];
    [[[[self tabBarController] tabBar] layer] setShadowRadius: 4.0];
    [[[[self tabBarController] tabBar] layer] setShadowColor: [UIColor.grayColor CGColor]];
    [[[[self tabBarController] tabBar] layer] setShadowOpacity: 0.3];
    
    self.lblIsNewRequest.layer.cornerRadius = self.lblIsNewRequest.frame.size.height / 2;
    self.lblIsNewRequest.clipsToBounds = YES;
    
    self.vwNewRequest.layer.cornerRadius = self.vwNewRequest.frame.size.height / 2;
    self.vwNewRequest.clipsToBounds = YES;
    
    self.vwPro.layer.cornerRadius = self.vwPro.frame.size.height / 2;
    self.vwPro.clipsToBounds = YES;
}

- (void)handleSendRequest:(UIButton *)sender {
    if ([Utils isConnectedToInternet]) {
        // Set Selected Index
        selectedIndex = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        
        //Vibrate
         AudioServicesPlaySystemSoundWithCompletion(1520, nil);     //0x0000003F
        
        // Get Cell
        SearchFriendCell *searchFriendCell = [_tblSearchFriends cellForRowAtIndexPath:selectedIndex];
        
        //Getting User Data
        NSDictionary *friendData = [arrSearchFriend objectAtIndex:selectedIndex.row];
        NSString *userId = [friendData valueForKey:@"user_id"];
        NSInteger isFriend = [[friendData valueForKey:@"is_friend"] integerValue];
        
        if (isFriend == 1) {
            [Utils showToast:@"Request already sent or accepted." duration:3.0];
        } else {
            //Call API For Send Request
            [self sendFriendRequestAPI:userId withLoader:searchFriendCell.vwLoader];
        }
        
    }
}

- (void)addPullToRefresh {
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor clearColor];

    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    if (@available(iOS 10.0, *)) {
        self.scrFriendRequest.refreshControl = refreshControl;
    } else {
        [self.scrFriendRequest addSubview:refreshControl];
    }
}

- (void)refreshTable {
    [refreshControl endRefreshing];
    [self getFriendRequestListAPI];
}

//MARK:- Tableview delegate method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _tblFriendRequests) {
        if (section == 0) {
            if (arrAcceptedRequest.count == 0 || arrAcceptedRequest == nil) {
                return 1;
            } else {
                return arrAcceptedRequest.count;
            }
        } else {
            if (arrReceivedRequest.count == 0 || arrReceivedRequest == nil) {
                return 1;
            } else {
                return arrReceivedRequest.count;
            }
        }
    } else if (tableView == _tblSearchFriends) {
        
        if(arrSearchFriend.count<=3){
            if(isSearchClicked == YES){
                _vwNoFriendsYet.hidden = NO;
                
                if(!IsBounced){
                    
                    IsBounced = YES;
                    
                    POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
                    sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
                    sprintAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.7, 0.7)];
                    sprintAnimation.springBounciness = 20.f;
                    [_vwNoFriendsYet pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
                }
                
            }else{
                _vwNoFriendsYet.hidden = YES;
            }
        }else{
            _vwNoFriendsYet.hidden = YES;
        }
        return arrSearchFriend.count;
    } else {
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tblFriendRequests) {
        
        if (indexPath.section == 0) {
            
            if (arrAcceptedRequest.count == 0 || arrAcceptedRequest == nil) {
                NoRequestTableViewCell *cell = [_tblFriendRequests dequeueReusableCellWithIdentifier:@"NoRequestTableViewCell" forIndexPath:indexPath];
                
                cell.lblTitle.text = @"No new friends accepted your requests";
                cell.friendBGShadow.layer.cornerRadius = 20.0;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    UIBezierPath *enduranceShadowPath = [UIBezierPath bezierPathWithRoundedRect:[cell.friendBGShadow bounds] cornerRadius:20];
                    [[cell.friendBGShadow layer] setMasksToBounds: NO];
                    [[cell.friendBGShadow layer] setShadowColor: [[UIColor blackColor] CGColor]];
                    [[cell.friendBGShadow layer] setShadowOffset: CGSizeMake(0.0, 2.0)];
                    [[cell.friendBGShadow layer] setShadowRadius: 3.0];
                    [[cell.friendBGShadow layer] setShadowOpacity: 0.2];//0.06
                    [cell.friendBGShadow.layer setRasterizationScale:[UIScreen.mainScreen scale]];
                    [[cell.friendBGShadow layer] setShadowPath: [enduranceShadowPath CGPath]];
                });
                
                cell.friendImage.layer.cornerRadius = cell.friendImage.frame.size.height/2;
                cell.friendImageBG.layer.cornerRadius = cell.friendImageBG.frame.size.height/2;
                cell.friendImageBG.layer.borderColor = [cNEW_GREEN CGColor];
                cell.friendImageBG.layer.borderWidth = 2.0;
                cell.friendImage.clipsToBounds = YES;
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            } else {
                RequestAccptedCell *cell = [_tblFriendRequests dequeueReusableCellWithIdentifier:@"RequestAccptedCell" forIndexPath:indexPath];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    
                    cell.friendBGShadow.layer.cornerRadius = 20.0;
                    
                    UIBezierPath *enduranceShadowPath = [UIBezierPath bezierPathWithRoundedRect:[cell.friendBGShadow bounds] cornerRadius:20];
                    [[cell.friendBGShadow layer] setMasksToBounds: NO];
                    [[cell.friendBGShadow layer] setShadowColor: [[UIColor blackColor] CGColor]];
                    [[cell.friendBGShadow layer] setShadowOffset: CGSizeMake(0.0, 2.0)];
                    [[cell.friendBGShadow layer] setShadowRadius: 3.0];
                    [cell.friendBGShadow.layer setRasterizationScale:[UIScreen.mainScreen scale]];
                    [[cell.friendBGShadow layer] setShadowOpacity: 0.2];//0.06
                    [[cell.friendBGShadow layer] setShadowPath: [enduranceShadowPath CGPath]];
                    
                    cell.friendImage.layer.cornerRadius = cell.friendImage.frame.size.height/2;
                    cell.friendImageBG.layer.cornerRadius = cell.friendImageBG.frame.size.height/2;
                    cell.friendImageBG.layer.borderColor = [cNEW_GREEN CGColor];
                    cell.friendImageBG.layer.borderWidth = 2.0;
                    
                });
                cell.friendImage.clipsToBounds = YES;
                
                NSDictionary *friendData = [arrAcceptedRequest objectAtIndex:indexPath.row];
                NSString *name = [friendData valueForKey:@"name"];
                NSString *workouts = [friendData valueForKey:@"workouts"];
                NSString *profile_pic = [friendData valueForKey:@"profile_pic"];
                
                [cell.friendImage sd_setImageWithURL:[[NSURL alloc] initWithString:profile_pic] placeholderImage:[UIImage imageNamed:@"Component 8 – 1"]];
                cell.friendName.text = name;
                cell.friendWorkout.text = @"3 workouts";
                cell.friendWorkout.text = [NSString stringWithFormat:@"%@ workouts", workouts];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }
            
        } else {
            
            if (arrReceivedRequest.count == 0 || arrReceivedRequest == nil) {
                NoRequestTableViewCell *cell = [_tblFriendRequests dequeueReusableCellWithIdentifier:@"NoRequestTableViewCell" forIndexPath:indexPath];
                
                cell.lblTitle.text = @"You received no new friend requests";
                cell.friendBGShadow.layer.cornerRadius = 20.0;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    
                    UIBezierPath *enduranceShadowPath = [UIBezierPath bezierPathWithRoundedRect:[cell.friendBGShadow bounds] cornerRadius:20];
                    [[cell.friendBGShadow layer] setMasksToBounds: NO];
                    [[cell.friendBGShadow layer] setShadowColor: [[UIColor blackColor] CGColor]];
                    [[cell.friendBGShadow layer] setShadowOffset: CGSizeMake(0.0, 2.0)];
                    [[cell.friendBGShadow layer] setShadowRadius: 3.0];
                    [[cell.friendBGShadow layer] setShadowOpacity: 0.2];//0.06
                    [cell.friendBGShadow.layer setRasterizationScale:[UIScreen.mainScreen scale]];
                    [[cell.friendBGShadow layer] setShadowPath: [enduranceShadowPath CGPath]];
                    
                });
                
                cell.friendImage.layer.cornerRadius = cell.friendImage.frame.size.height/2;
                cell.friendImageBG.layer.cornerRadius = cell.friendImageBG.frame.size.height/2;
                cell.friendImageBG.layer.borderColor = [cNEW_GREEN CGColor];
                cell.friendImageBG.layer.borderWidth = 2.0;
                cell.friendImage.clipsToBounds = YES;
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            } else {
                RequestReceivedCell *cell = [_tblFriendRequests dequeueReusableCellWithIdentifier:@"RequestReceivedCell" forIndexPath:indexPath];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    
                    cell.friendBGShadow.layer.cornerRadius = 20.0;
                    
                    UIBezierPath *enduranceShadowPath = [UIBezierPath bezierPathWithRoundedRect:[cell.friendBGShadow bounds] cornerRadius:20];
                    [[cell.friendBGShadow layer] setMasksToBounds: NO];
                    [[cell.friendBGShadow layer] setShadowColor: [[UIColor blackColor] CGColor]];
                    [[cell.friendBGShadow layer] setShadowOffset: CGSizeMake(0.0, 2.0)];
                    [[cell.friendBGShadow layer] setShadowRadius: 3.0];
                    [[cell.friendBGShadow layer] setShadowOpacity: 0.2];//0.06
                    [[cell.friendBGShadow layer] setShadowPath: [enduranceShadowPath CGPath]];
                    
                    cell.friendImage.layer.cornerRadius = cell.friendImage.frame.size.height/2;
                    cell.friendImageBG.layer.cornerRadius = cell.friendImageBG.frame.size.height/2;
                    cell.friendImageBG.layer.borderColor = [cNEW_GREEN CGColor];
                    cell.friendImageBG.layer.borderWidth = 2.0;
                    
                });
                cell.friendImage.clipsToBounds = YES;
                
                NSDictionary *friendData = [arrReceivedRequest objectAtIndex:indexPath.row];
                NSString *request_id = [friendData valueForKey:@"request_id"];
                NSString *name = [friendData valueForKey:@"name"];
                NSString *email = [friendData valueForKey:@"email"];
                NSString *profile_pic = [friendData valueForKey:@"profile_pic"];
                
                [cell.friendImage sd_setImageWithURL:[[NSURL alloc] initWithString:profile_pic] placeholderImage:[UIImage imageNamed:@"Component 8 – 1"]];
                cell.friendName.text = name;
                cell.friendEmail.text = email;
                
                cell.btnAcceptTap = ^{
                    [self AcceptRejectFriendRequestAPI:request_id action:@"accept"];
                };
                
                cell.btnDeclineTap = ^{
                    [self AcceptRejectFriendRequestAPI:request_id action:@"reject"];
                };
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }
        }
        
    } else {
        
        SearchFriendCell *cell = [_tblSearchFriends dequeueReusableCellWithIdentifier:@"SearchFriendCell" forIndexPath:indexPath];
        
        NSDictionary *friendData = [arrSearchFriend objectAtIndex:indexPath.row];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            cell.friendBGShadow.layer.cornerRadius = 20.0;
            
            UIBezierPath *enduranceShadowPath = [UIBezierPath bezierPathWithRoundedRect:[cell.friendBGShadow bounds] cornerRadius:20];
            [[cell.friendBGShadow layer] setMasksToBounds: NO];
            [[cell.friendBGShadow layer] setShadowColor: [[UIColor blackColor] CGColor]];
            [[cell.friendBGShadow layer] setShadowOffset: CGSizeMake(0.0, 2.0)];
            [[cell.friendBGShadow layer] setShadowRadius: 3.0];
            [cell.friendBGShadow.layer setRasterizationScale:[UIScreen.mainScreen scale]];
            [[cell.friendBGShadow layer] setShadowOpacity: 0.15];//0.06
            [[cell.friendBGShadow layer] setShadowPath: [enduranceShadowPath CGPath]];
        });
        
        cell.friendImage.layer.cornerRadius = cell.friendImage.frame.size.height/2;
        cell.friendImageBG.layer.cornerRadius = cell.friendImageBG.frame.size.height/2;
        cell.friendImageBG.layer.borderColor = [cNEW_GREEN CGColor];
        cell.friendImageBG.layer.borderWidth = 2.0;
        
        cell.vwLoader.layer.cornerRadius = cell.vwLoader.frame.size.height / 2;
        cell.vwLoader.clipsToBounds = YES;
        
        cell.friendImage.clipsToBounds = YES;
        
        NSString *email = [friendData valueForKey:@"email"];
        NSString *name = [friendData valueForKey:@"name"];
        NSString *profile_pic = [friendData valueForKey:@"profile_pic"];
        
        [cell.friendImage sd_setImageWithURL:[[NSURL alloc] initWithString:profile_pic] placeholderImage:[UIImage imageNamed:@"Component 8 – 1"]];
        cell.friendName.text = name;
        cell.friendEmail.text = email;
        cell.btnAddFriend.tag = indexPath.row;
        
        //Check if already friend
        // 1 = Already Friend & 0 = Not
        NSInteger isFriend = [[friendData valueForKey:@"is_friend"] integerValue];
        if (isFriend == 1) {
            [cell.vwLoader setHidden:YES];
            [cell.btnAddFriend setImage:[UIImage imageNamed:@"trueClear"] forState:UIControlStateNormal];
        } else {
            [cell.btnAddFriend setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        }
        
        [cell.btnAddFriend addTarget:self action:@selector(handleSendRequest:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tblFriendRequests) {
        return 2;
    } else {
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView == _tblFriendRequests) {
        if (section == 0) {
            
            UIView *view = [[HeaderReqstAcpt alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, tableView.frame.size.width, 40)];
            [label setText: @"Requests accepted"];
            [label setFont: [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 30.0]];
            label.textColor = cNEW_GREEN;
            [view addSubview:label];
            [view setBackgroundColor:[UIColor clearColor]];

            return view;
        } else {
            UIView *view = [[HeaderReqstAcpt alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, tableView.frame.size.width, 40)];
            [label setText: @"Requests received"];
            [label setFont: [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 30.0]];
            label.textColor = cNEW_GREEN;
            [view addSubview:label];
            [view setBackgroundColor:[UIColor clearColor]];
            
            return view;
        }
    } else {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tblFriendRequests) {
        if (indexPath.section == 0) {
            return 92;
        } else if (indexPath.section == 1) {
            if (arrReceivedRequest.count == 0 || arrReceivedRequest == nil) {
                return 92;
            } else {
                return 152;
            }
        } else {
            return 0;
        }
    } else if (tableView == _tblSearchFriends) {
        return 92;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == _tblFriendRequests) {
        return 40.0;
    } else {
        return 0.0;
    }
    
}

//MARK:- Button Click
- (IBAction)btnNoFriendsShareAction:(UIButton *)sender{

    NSString *text = @"Hi ! Join me on this workout app so we can compare our gym trainings !!";
    NSURL *url = [NSURL URLWithString: uGYMTIMER_APPSTORE_URL];
    
    if (url != nil && [url.absoluteString length] != 0) {
        NSMutableArray *arrObjectsToShare = [[NSMutableArray alloc] init];
        [arrObjectsToShare addObject:text];
        [arrObjectsToShare addObject:url];
        
        UIActivityViewController *vcShare = [[UIActivityViewController alloc] initWithActivityItems:arrObjectsToShare applicationActivities:nil];
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            vcShare.popoverPresentationController.sourceView = sender;
            vcShare.popoverPresentationController.sourceRect = sender.bounds;
            vcShare.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
        }
        [self presentViewController:vcShare animated:true completion:nil];
    }
    
}

- (IBAction)btnCloseFriendRequestAction:(UIButton *)sender {
    _viewFriendRequestList.hidden = YES;
    [self.view endEditing:YES];
//    [self getFriendsCountAPI];
}

- (IBAction)btnFriendRequestListAction:(UIButton *)sender {
    // Hide notification 
    _lblIsNewRequest.hidden = YES;
    _vwNewRequest.hidden = YES;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateNewRequestBadge" object:nil];
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:HasNewNotification];
    [[NSNotificationCenter defaultCenter] postNotificationName:UpdateTabBarBadge object:nil];

    _viewFriendRequestList.hidden = NO;
    [self getFriendRequestListAPI];
    [self.view endEditing:YES];
}

- (IBAction)btnCloseSearchAction:(UIButton *)sender {
    _txtSearch.text = @"";
    [arrSearchFriend removeAllObjects];
    [_tblSearchFriends reloadData];
    
    isSearchClicked = NO;
    IsBounced = NO;
    
    _scrSearch.hidden = YES;
    _vwNoFriendsYet.hidden = YES;
    [self.view endEditing:true];
}

- (IBAction)btnCloseSearchHomeAction:(UIButton *)sender {
    _scrSearch.hidden = YES;
    _vwNoFriendsYet.hidden = YES;
    [self.view endEditing:true];
    
    self.scrlViewSearch.alpha = 1.0;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.scrlViewSearch.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.scrlViewSearch.hidden = YES;
    }];
}

- (IBAction)btnSearchAction:(UIButton *)sender {
    self.scrSearch.hidden = NO;
    
    [_tblSearchFriends reloadData];
    
    [self.txtSearch becomeFirstResponder];
    [self textFieldDidBeginEditing:_txtSearch];
}

//MARK:- UItextfield delegate method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    searchStr = [searchStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if ([string isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
    }else if ([searchStr isEqualToString:@""]) {
        isSearchClicked = NO;
        
        _viewSearchFriend.hidden = YES;
        [arrSearchFriend removeAllObjects];
        [_tblSearchFriends reloadData];
    }  else {
        if(searchTimer == nil)
        {
            searchTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(searchTextDelay) userInfo:nil repeats:NO];
        }
    }
    [self setTableHeight];
    return YES;
}

-(void)searchTextDelay
{
    searchTimer = nil;
    page_token = 0;
    [arrSearchFriend removeAllObjects];
    [self SearchFriendAPI: _txtSearch.text];
}

//MARK:- API call

-(void)AcceptRejectFriendRequestAPI : (NSString *)RequestId action:(NSString *)actionTo {
    
    NSMutableDictionary *dicUserDetails = [[NSMutableDictionary alloc] initWithDictionary: [Utils getUserDetails]];
    
    NSArray *RequestACtionParams = @[
                                   @{ @"user_id" : [dicUserDetails valueForKey: @"id"]},
                                   @{ @"request_id" : RequestId},
                                   @{ @"action" : actionTo}
                                   ];
    
    NSLog(@"Dic : %@", RequestACtionParams);
    
    if ([Utils isConnectedToInternet]) {
        
        [self showLoaderView];
        spinner = [Utils showActivityIndicatorInViewAtTop:_viewLoaderContentView];
        
        NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uREQUEST_ACTION];
        [serviceManager callWebServiceWithPOST: webpath withTag: tREQUEST_ACTION params: RequestACtionParams];
    } else {
        
        [self  hideLoaderView];
        
    }
    
}

-(void)sendFriendRequestAPI:(NSString *)toUserId withLoader:(UIView *)view {
    
    NSMutableDictionary *dicUserDetails = [[NSMutableDictionary alloc] initWithDictionary: [Utils getUserDetails]];
    
    NSArray *SendRequestParams = @[
        @{ @"from_user_id" : [dicUserDetails valueForKey: @"id"]},
        @{ @"to_user_id" : toUserId}
    ];
    
    NSLog(@"Dic : %@", SendRequestParams);
    
    if ([Utils isConnectedToInternet]) {
        
        [self showLoaderView];
        if (view.isHidden) {
            [view setHidden:NO];
        }
        spinner = [Utils showActivityIndicatorInView: view];
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [spinner setColor: UIColor.whiteColor];
        
        NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uSEND_FRIEND_REQUEST];
        [serviceManager callWebServiceWithPOST: webpath withTag: tSEND_FRIEND_REQUEST params: SendRequestParams];
    } else {
        
        [self hideLoaderView];
        
    }
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

- (void)SearchFriendAPI : (NSString *)friend{
    
    NSMutableDictionary *dicUserDetails = [[NSMutableDictionary alloc] initWithDictionary: [Utils getUserDetails]];

    NSArray *SearchFriendParams = @[
                                    @{ @"user_id" : [dicUserDetails valueForKey: @"id"]},
                                    @{ @"name" : friend},
                                    @{ @"page_token": [NSString stringWithFormat:@"%d", page_token]}
                                    ];
    
    NSLog(@"Dic : %@", SearchFriendParams);
    
    if ([Utils isConnectedToInternet]) {
        isSearchClicked = YES;

        NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uSEARCH_FRIEND];
        [serviceManager callWebServiceWithPOST: webpath withTag: tSEARCH_FRIEND params: SearchFriendParams];
    }
    
}

- (void)getFriendRequestListAPI {
    
    NSMutableDictionary *dicUserDetails = [[NSMutableDictionary alloc] initWithDictionary: [Utils getUserDetails]];
    
    NSArray *FriendListParam = @[
                                 @{ @"user_id" : [dicUserDetails valueForKey: @"id"]}
                                 ];
    
    NSLog(@"Dic : %@", FriendListParam);
    
    if ([Utils isConnectedToInternet]) {
        
        [self showLoaderView];
        spinner = [Utils showActivityIndicatorInViewAtTop:_viewLoaderContentView];
        
        NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uREQUEST_LIST];
        [serviceManager callWebServiceWithPOST: webpath withTag: tFRIEND_REQUESTS params: FriendListParam];
        
    } else {
        [self hideLoaderView];
        
    }
    
}

//MARK:- Service manager delegate and parser methods

- (void)webServiceCallFailure:(NSError *)error forTag:(NSString *)tagname {
    NSLog(@"Web service call fails : %@", [error localizedDescription]);
    [self hideLoaderView];
    [Utils hideActivityIndicator:spinner fromView:_viewLoaderContentView];
    [Utils showToast: @"Server Error" duration: 3.0];
}

- (void)webServiceCallSuccess:(id)response forTag:(NSString *)tagname {
    
    if ([tagname isEqualToString: tSEARCH_FRIEND]) {
        [self parseSearchFriendResponse: response];
    }else if ([tagname isEqualToString: tFRIEND_REQUESTS]){
        [self parseFriendRequestResponse: response];
    }else if([tagname isEqualToString:tSEND_FRIEND_REQUEST]){
        [self parseSendFriendRequestResponse:response];
    }else if([tagname isEqualToString:tREQUEST_ACTION]){
        [self parseRequestActionResponse:response];
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
        NSString *totalFriend = [dic valueForKey:@"total_friend"];
        NSString *newFriendRequest = [dic valueForKey:@"new_request"];
        NSString *newRequestAccepted = [dic valueForKey:@"request_accept"];
        
        if ([newFriendRequest isEqualToString:@"1"] || ([newRequestAccepted isEqualToString:@"1"])) {
            _lblIsNewRequest.hidden = NO;
            _vwNewRequest.hidden = NO;
            
        } else {
            _lblIsNewRequest.hidden = YES;
            _vwNewRequest.hidden = YES;
            
        }

        
        if ([totalFriend isEqualToString:@"0"]) {
            [self layoutSubviews];
            
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [self.progressFriends setProgress:0.052];
                self.constLeftLblProgress.constant = 20 - (self.lblProgress.frame.size.width/2);
                self.lblProgress.text = @"0/5";
                
                [self.view layoutIfNeeded];
                [self layoutSubviews];
            } completion:nil];
        } else {
            [self layoutSubviews];
            [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveLinear  animations:^{
                
                int noOfFriend = [totalFriend intValue];
                if (noOfFriend <= 5) {
                    [self.progressFriends setProgress:noOfFriend/5.0];
                    self.constLeftLblProgress.constant = 20 - (self.lblProgress.frame.size.width/2) + ((self.progressFriends.frame.size.width/5) * noOfFriend);
                    self.lblProgress.text = [NSString stringWithFormat:@"%@/5", totalFriend];
                } else {
                    self.lblProgress.text = [NSString stringWithFormat:@"5/5"];
                    [self.progressFriends setProgress:1.0];
                    self.constLeftLblProgress.constant = 20 - (self.lblProgress.frame.size.width/2) + ((self.progressFriends.frame.size.width/5) * 5);
                }
                
                [self.view layoutIfNeeded];
                [self layoutSubviews];
            } completion:^(BOOL finished) {
                //code for completion
            }];
            
        }
        
    } else {
        [Utils showToast: [dicResponse valueForKey: @"message"] duration: 3.0];
    }
    
    [self hideLoaderView];
    [Utils hideActivityIndicator:spinner fromView:_viewLoaderContentView];
    
}

- (void) parseRequestActionResponse: (id) response {
    
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    NSLog(@"%@", dicResponse);
    
    if ([[dicResponse valueForKey:@"status"] integerValue] == 1) {
        //[Utils showToast: [dicResponse valueForKey: @"message"] duration: 3.0];
        [self getFriendRequestListAPI];
    } else {
        [Utils showToast: [dicResponse valueForKey: @"message"] duration: 3.0];
    }
    
    [self hideLoaderView];
    [Utils hideActivityIndicator:spinner fromView:_viewLoaderContentView];
}

- (void) parseSendFriendRequestResponse: (id) response {
    
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    NSLog(@"%@", dicResponse);
    
    SearchFriendCell *searchFriendCell = [_tblSearchFriends cellForRowAtIndexPath:selectedIndex];
    [searchFriendCell.vwLoader setHidden:YES];
    if ([[dicResponse valueForKey:@"status"] integerValue] == 1) {
        [searchFriendCell.btnAddFriend setImage:[UIImage imageNamed:@"trueClear"] forState:UIControlStateNormal];
    } else {
        [Utils showToast: [dicResponse valueForKey: @"message"] duration: 3.0];
    }
    
    [self hideLoaderView];
    [Utils hideActivityIndicator:spinner fromView:_viewLoaderContentView];
}

- (void) parseFriendRequestResponse: (id) response {
    
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    NSLog(@"%@", dicResponse);
    
    arrAcceptedRequest = [[NSMutableArray alloc] init];
    arrReceivedRequest = [[NSMutableArray alloc] init];
    
    if ([[dicResponse valueForKey:@"status"] integerValue] == 1) {
        NSArray *arrTemp = [dicResponse valueForKey:@"data"];
        
        for (int i=0; i<arrTemp.count; i++) {
            NSDictionary *dic = [arrTemp objectAtIndex:i];
            if ([[dic valueForKey:@"status"] isEqualToString:@"1"]) {
                [arrAcceptedRequest addObject:dic];
            } else if ([[dic valueForKey:@"status"] isEqualToString:@"0"]) {
                [arrReceivedRequest addObject:dic];
            }
        }
        
        //Manage Friend Requests Table Height
        NSInteger sectionHeight = 0;
        NSInteger rowHeight = 0;
        
        //For Section 0
        if (arrAcceptedRequest.count == 0 || arrAcceptedRequest == nil) {
            sectionHeight = sectionHeight + 40;
            rowHeight = rowHeight + 92;
        } else {
            sectionHeight = sectionHeight + 40;
            rowHeight = rowHeight + (arrAcceptedRequest.count * 92);
        }
        
        //For Section 1
        if (arrReceivedRequest.count == 0 || arrReceivedRequest == nil) {
            sectionHeight = sectionHeight + 40;
            rowHeight = rowHeight + 92;
        } else {
            sectionHeight = sectionHeight + 40;
            rowHeight = rowHeight + (arrReceivedRequest.count * 152);;
        }
        _constTblFriendsHeight.constant = (sectionHeight + rowHeight) + 20;
        
        // Set more hight for scrolling even when no data
        if (_constTblFriendsHeight.constant < self.scrFriendRequest.frame.size.height) {
            _constTblFriendsHeight.constant = (self.scrFriendRequest.frame.size.height - self.tblFriendRequests.frame.origin.y) + 20;
        }
        
        [_tblFriendRequests reloadData];
        
    } else {
        //Manage Friend Requests Table Height
        NSInteger sectionHeight = 0;
        NSInteger rowHeight = 0;
        
        //For Section 0
        if (arrAcceptedRequest.count == 0 || arrAcceptedRequest == nil) {
            sectionHeight = sectionHeight + 40;
            rowHeight = rowHeight + 92;
        } else {
            sectionHeight = sectionHeight + 40;
            rowHeight = rowHeight + (arrAcceptedRequest.count * 92);
        }
        
        //For Section 1
        if (arrReceivedRequest.count == 0 || arrReceivedRequest == nil) {
            sectionHeight = sectionHeight + 40;
            rowHeight = rowHeight + 92;
        } else {
            sectionHeight = sectionHeight + 40;
            rowHeight = rowHeight + (arrReceivedRequest.count * 152);;
        }
        
        _constTblFriendsHeight.constant = (sectionHeight + rowHeight) + 20;
        
        // Set more hight for scrolling even when no data
        if (_constTblFriendsHeight.constant < self.scrFriendRequest.frame.size.height) {
            _constTblFriendsHeight.constant = (self.scrFriendRequest.frame.size.height - self.tblFriendRequests.frame.origin.y) + 20;
        }
        
        [_tblFriendRequests reloadData];
    }
    
    [self hideLoaderView];
    [Utils hideActivityIndicator:spinner fromView:_viewLoaderContentView];
}

- (void) setTableHeight{
    //Setting Search Table Height
    _constTblSearchHeight.constant = (92 * arrSearchFriend.count) + 5;
    
    if (_constTblSearchHeight.constant < self.scrSearch.frame.size.height) {
        _constTblSearchHeight.constant = (self.scrSearch.frame.size.height - self.viewSearchFriend.frame.origin.y) + 20;
    } else {
        if (IS_IPHONE8) {
            _constTblSearchHeight.constant = (92 * arrSearchFriend.count) + 35;
        }
    }
}

- (void) parseSearchFriendResponse: (id) response {
    
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    NSLog(@"%@", dicResponse);
//    arrSearchFriend = [[NSMutableArray alloc] init];

    if ([[dicResponse valueForKey:@"status"] integerValue] == 1) {
        
        page_token = [[dicResponse valueForKey:@"page_token"] intValue];

        //success
        [arrSearchFriend addObjectsFromArray: [[dicResponse valueForKey:@"data"] mutableCopy]];
        
        //Setting Search Table Height
        [self setTableHeight];
        
        [_tblSearchFriends reloadData];
    }
    else
    {
        [arrSearchFriend removeAllObjects];
        [self setTableHeight];
        
        [_tblSearchFriends reloadData];
    }
    
    if (arrSearchFriend.count == 0) {
        _viewSearchFriend.hidden = YES;
    } else {
        _viewSearchFriend.hidden = NO;
    }
    
    [loader stopAnimating];
}

@end
