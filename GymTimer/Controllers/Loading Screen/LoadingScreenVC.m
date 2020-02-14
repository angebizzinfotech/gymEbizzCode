//
//  LoadingScreenVC.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 07/02/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

#import "LoadingScreenVC.h"
#import "CommonImports.h"

@interface LoadingScreenVC ()

@end

@implementation LoadingScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [NSTimer scheduledTimerWithTimeInterval: 3.0 target: self selector:@selector(redirectScreen) userInfo: nil repeats:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (IS_IPHONEXR) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
        [self.view addSubview: contentView];
        
        UIView *lblView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 7.0, (contentView.frame.size.width), 80.0)];
        [contentView addSubview: lblView];
        
        CGFloat contentViewWidth = contentView.frame.size.width;
        CGFloat contentViewHeight = contentView.frame.size.height;
        CGFloat gymtimerY = lblView.frame.origin.y;
        CGFloat gymtimerHeight = lblView.frame.size.height;
        CGFloat tabbarHeight = 53.0;
        
        UIView *vwImgBackgound = [[UIView alloc] initWithFrame:CGRectMake(18.0, (lblView.frame.origin.y + lblView.frame.size.height + 24.0), (contentViewWidth - 36.0), (contentViewHeight - (gymtimerY + gymtimerHeight + tabbarHeight + 90.0)))];
        [contentView addSubview:vwImgBackgound];
        
        UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(-21.0, -19.0, vwImgBackgound.frame.size.width + 42.0, vwImgBackgound.frame.size.height + 45.0)];
        [bgImage setImage: [UIImage imageNamed:@"Welcome_Back_New"]];
        [vwImgBackgound addSubview:bgImage];
        
    } else if (IS_IPHONEX) {
        
        UIView *contentView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
        [self.view addSubview: contentView];
        
        CGFloat contentViewWidth = contentView.frame.size.width;
        CGFloat contentViewHeight = contentView.frame.size.height;
        UIView *lblView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 7.0, (contentView.frame.size.width), 80.0)];
        [contentView addSubview: lblView];
        
        CGFloat gymtimerY = lblView.frame.origin.y;
        CGFloat gymtimerHeight = lblView.frame.size.height;
        CGFloat tabbarHeight = 53.0;

        UIView *vwImgBackgound = [[UIView alloc] initWithFrame: CGRectMake(18.0, (lblView.frame.origin.y + lblView.frame.size.height + 24.0), (contentViewWidth - 36.0), (contentViewHeight - (gymtimerY + gymtimerHeight + tabbarHeight + 90.0)))];
        [contentView addSubview:vwImgBackgound];

        UIImageView *bgImage = [[UIImageView alloc] initWithFrame: CGRectMake(-21.0, -19.0, vwImgBackgound.frame.size.width + 42.0, vwImgBackgound.frame.size.height + 45.0)];
        [bgImage setImage: [UIImage imageNamed:@"Welcome_Back_New"]];
        [vwImgBackgound addSubview:bgImage];
    
    } else if (IS_IPHONE8PLUS) {
        
        UIView *contentView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
        [self.view addSubview: contentView];
        CGFloat contentViewWidth = contentView.frame.size.width;
        CGFloat contentViewHeight = contentView.frame.size.height;
        
        UIView *lblView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 7.0, (contentView.frame.size.width), 80.0)];
        [contentView addSubview: lblView];
        
        CGFloat gymtimerY = lblView.frame.origin.y;
        CGFloat gymtimerHeight = lblView.frame.size.height;
        CGFloat tabbarHeight = 53.0;
        UIView *vwImgBackgound = [[UIView alloc] initWithFrame: CGRectMake(35.0, (lblView.frame.origin.y + lblView.frame.size.height + 24.0), (contentViewWidth - 70.0), (contentViewHeight - (gymtimerY + gymtimerHeight + tabbarHeight + 50.0)))];
        [contentView addSubview:vwImgBackgound];

        UIImageView *bgImage = [[UIImageView alloc] initWithFrame: CGRectMake(-21.0, -19.0, vwImgBackgound.frame.size.width + 42.0, vwImgBackgound.frame.size.height + 45.0)];
        [bgImage setImage: [UIImage imageNamed:@"Welcome_Back_New"]];
        [vwImgBackgound addSubview:bgImage];
    
    } else if (IS_IPHONE8) {
        UIView *contentView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 30.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
        [self.view addSubview: contentView];

        CGFloat contentViewWidth = contentView.frame.size.width;
        CGFloat contentViewHeight = contentView.frame.size.height;
        UIView *lblView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 0.0, (contentView.frame.size.width), 78.0)];
        [contentView addSubview: lblView];

        CGFloat gymtimerY = lblView.frame.origin.y;
        CGFloat gymtimerHeight = lblView.frame.size.height;
        CGFloat tabbarHeight = 53.0;
        UIView *vwImgBackgound = [[UIView alloc] initWithFrame: CGRectMake(30.0, (lblView.frame.origin.y + lblView.frame.size.height + 10.0), (contentViewWidth - 66.0), (contentViewHeight - (gymtimerY + gymtimerHeight + tabbarHeight + 50.0)))];
        [contentView addSubview:vwImgBackgound];

        UIImageView *bgImage = [[UIImageView alloc] initWithFrame: CGRectMake(-21.0, -19.0, vwImgBackgound.frame.size.width + 42.0, vwImgBackgound.frame.size.height + 45.0)];
        [bgImage setImage: [UIImage imageNamed:@"Welcome_Back_New"]];
        [vwImgBackgound addSubview:bgImage];
    
    } else {
        UIView *contentView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 15.0, DEVICE_WIDTH, (DEVICE_HEIGHT + 26.0))];
        [self.view addSubview: contentView];
        
        CGFloat contentViewWidth = contentView.frame.size.width;
        CGFloat contentViewHeight = contentView.frame.size.height;
        
        UIView *lblView = [[UIView alloc] initWithFrame: CGRectMake(0.0, -2.0, (contentView.frame.size.width), 85.0)];
        [contentView addSubview: lblView];
        
        CGFloat gymtimerY = lblView.frame.origin.y;
        CGFloat gymtimerHeight = lblView.frame.size.height;
        CGFloat tabbarHeight = 53.0;
        UIView *vwImgBackgound = [[UIView alloc] initWithFrame: CGRectMake(18.0, (lblView.frame.origin.y + lblView.frame.size.height), (contentViewWidth - 36.0), (contentViewHeight - (gymtimerY + gymtimerHeight + tabbarHeight + 60.0)))];
        [contentView addSubview:vwImgBackgound];

        UIImageView *bgImage = [[UIImageView alloc] initWithFrame: CGRectMake(-21.0, -19.0, vwImgBackgound.frame.size.width + 42.0, vwImgBackgound.frame.size.height + 45.0)];
        [bgImage setImage: [UIImage imageNamed:@"Welcome_Back_New"]];
        [vwImgBackgound addSubview:bgImage];
    }
}

-(void)redirectScreen
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([[NSUserDefaults standardUserDefaults] valueForKey: kIS_FIRST_TIME] == nil) {

            //Temp
            [[NSUserDefaults standardUserDefaults] setValue: @"0" forKey: kIS_FIRST_TIME];
            [NSUserDefaults.standardUserDefaults setValue:@"YES" forKey:kIS_SEEN_ONBOARDING];

            UIViewController *onboardVC = [storyBoard instantiateViewControllerWithIdentifier: @"NewOnBoardingViewController"];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: onboardVC];
            [navController setNavigationBarHidden:YES];
            [appDelegate.window setRootViewController: navController];
            [appDelegate.window makeKeyAndVisible];

        } else if ([[NSUserDefaults standardUserDefaults] valueForKey: kIS_USER_LOGGED_IN] == nil) {
            UIViewController *loginOptionVC = [storyBoard instantiateViewControllerWithIdentifier: @"LoginOptionViewController"];
    //        UIViewController *loginOptionVC = [storyBoard instantiateViewControllerWithIdentifier: @"StatsVC"];
            
            [loginOptionVC.navigationController setNavigationBarHidden:YES];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: loginOptionVC];
            [appDelegate.window setRootViewController: navController];
            [appDelegate.window makeKeyAndVisible];

        } else {

            UIViewController *homeVC = [storyBoard instantiateViewControllerWithIdentifier: @"HomeScreenViewController"];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: homeVC];
            [appDelegate.window setRootViewController: navController];
            [appDelegate.window makeKeyAndVisible];
        }
}

@end
