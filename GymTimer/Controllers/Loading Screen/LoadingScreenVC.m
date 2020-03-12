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
{
    NSTimeInterval timeInterval;
    CGFloat smallHeight;
    CGFloat smallWidth;
    CGFloat mediumHeight;
    CGFloat mediumWidth;
}
@end

@implementation LoadingScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    timeInterval = 1.5;
    [NSTimer scheduledTimerWithTimeInterval: timeInterval target: self selector:@selector(redirectScreen) userInfo: nil repeats:NO];
    
    smallWidth = 215;
    smallHeight = 312;
    mediumWidth = 285;
    mediumHeight = 422;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self.bgImage layer] setMasksToBounds: NO];
    [[self.bgImage layer] setShadowColor: [cGYM_TIMER_LABEL CGColor]];
    [[self.bgImage layer] setShadowOffset: CGSizeMake(10.0, 10.0)];
    [[self.bgImage layer] setShadowRadius: 30.0];
    [[self.bgImage layer] setShadowOpacity: 1.0];
    
    if (IS_IPHONEXR) {
        [self.contentView setFrame: CGRectMake(0.0, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
//        [self.view addSubview: contentView];
        
        UIView *lblView = [[UIView alloc] initWithFrame:CGRectMake(0.0, -8.0, (_contentView.frame.size.width), 95.0)];
        [_contentView addSubview: lblView];
        
        CGFloat contentViewWidth = _contentView.frame.size.width;
        CGFloat contentViewHeight = _contentView.frame.size.height;
        CGFloat gymtimerY = lblView.frame.origin.y;
        CGFloat gymtimerHeight = lblView.frame.size.height;
        CGFloat tabbarHeight = 53.0;
        
        [UIView animateWithDuration:timeInterval/4 animations:^{
            [self.vwImgBackgound setFrame: CGRectMake((DEVICE_WIDTH-self->smallWidth)/2, (DEVICE_HEIGHT-self->smallHeight)/2, self->smallWidth, self->smallHeight)];
            UIBezierPath *workoutViewShadowPath = [UIBezierPath bezierPathWithRect: self.bgImage.frame];
            [[self.bgImage layer] setShadowPath: [workoutViewShadowPath CGPath]];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:self->timeInterval/4 animations:^{
                [self.vwImgBackgound setFrame: CGRectMake((DEVICE_WIDTH-self->mediumWidth)/2, (DEVICE_HEIGHT-self->mediumHeight)/2, self->mediumWidth, self->mediumHeight)];
                UIBezierPath *workoutViewShadowPath = [UIBezierPath bezierPathWithRect: self.bgImage.frame];
                [[self.bgImage layer] setShadowPath: [workoutViewShadowPath CGPath]];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:self->timeInterval/4 animations:^{
                    [self.vwImgBackgound setFrame: CGRectMake((DEVICE_WIDTH-self->smallWidth)/2, (DEVICE_HEIGHT-self->smallHeight)/2, self->smallWidth, self->smallHeight)];
                    UIBezierPath *workoutViewShadowPath = [UIBezierPath bezierPathWithRect: self.bgImage.frame];
                    [[self.bgImage layer] setShadowPath: [workoutViewShadowPath CGPath]];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration: self->timeInterval/4 animations:^{
                        [self.bgImage setContentMode: UIViewContentModeScaleToFill];
                        [self.vwImgBackgound setFrame: CGRectMake(18.0, (lblView.frame.origin.y + lblView.frame.size.height + 24.0), (contentViewWidth - 36.0), (contentViewHeight - (gymtimerY + gymtimerHeight + tabbarHeight + 90.0)))];
                        UIBezierPath *workoutViewShadowPath = [UIBezierPath bezierPathWithRect: self.bgImage.frame];
                        [[self.bgImage layer] setShadowPath: [workoutViewShadowPath CGPath]];
                    }];
                }];
            }];
        }];
//        [contentView addSubview:vwImgBackgound];
        
        [self.bgImage setFrame: CGRectMake(-21.0, -19.0, self.vwImgBackgound.frame.size.width + 42.0, self.vwImgBackgound.frame.size.height + 45.0)];
//        [bgImage setImage: [UIImage imageNamed:@"home_buttom_gym"]];
//        [vwImgBackgound addSubview:bgImage];
        
    } else if (IS_IPHONEX) {
        [UIView animateWithDuration:timeInterval animations:^{
            [self.contentView setFrame: CGRectMake(0.0, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
        }];
//        [self.view addSubview: contentView];
        
        CGFloat contentViewWidth = _contentView.frame.size.width;
        CGFloat contentViewHeight = _contentView.frame.size.height;
        UIView *lblView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 7.0, (_contentView.frame.size.width), 80.0)];
        [_contentView addSubview: lblView];
        
        CGFloat gymtimerY = lblView.frame.origin.y;
        CGFloat gymtimerHeight = lblView.frame.size.height;
        CGFloat tabbarHeight = 53.0;

        [UIView animateWithDuration:timeInterval/4 animations:^{
            [self.vwImgBackgound setFrame: CGRectMake((DEVICE_WIDTH-self->smallWidth)/2, (DEVICE_HEIGHT-self->smallHeight)/2, self->smallWidth, self->smallHeight)];
            UIBezierPath *workoutViewShadowPath = [UIBezierPath bezierPathWithRect: self.bgImage.frame];
            [[self.bgImage layer] setShadowPath: [workoutViewShadowPath CGPath]];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:self->timeInterval/4 animations:^{
                [self.vwImgBackgound setFrame: CGRectMake((DEVICE_WIDTH-self->mediumWidth)/2, (DEVICE_HEIGHT-self->mediumHeight)/2, self->mediumWidth, self->mediumHeight)];
                UIBezierPath *workoutViewShadowPath = [UIBezierPath bezierPathWithRect: self.bgImage.frame];
                [[self.bgImage layer] setShadowPath: [workoutViewShadowPath CGPath]];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:self->timeInterval/4 animations:^{
                    [self.vwImgBackgound setFrame: CGRectMake((DEVICE_WIDTH-self->smallWidth)/2, (DEVICE_HEIGHT-self->smallHeight)/2, self->smallWidth, self->smallHeight)];
                    UIBezierPath *workoutViewShadowPath = [UIBezierPath bezierPathWithRect: self.bgImage.frame];
                    [[self.bgImage layer] setShadowPath: [workoutViewShadowPath CGPath]];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration: self->timeInterval/4 animations:^{
                        [self.bgImage setContentMode: UIViewContentModeScaleToFill];
                        [self.vwImgBackgound setFrame: CGRectMake(18.0, (lblView.frame.origin.y + lblView.frame.size.height + 24.0), (contentViewWidth - 36.0), (contentViewHeight - (gymtimerY + gymtimerHeight + tabbarHeight + 90.0)))];
                        UIBezierPath *workoutViewShadowPath = [UIBezierPath bezierPathWithRect: self.bgImage.frame];
                        [[self.bgImage layer] setShadowPath: [workoutViewShadowPath CGPath]];
                    }];
                }];
            }];
        }];
//        [contentView addSubview:vwImgBackgound];

        [self.bgImage setFrame: CGRectMake(-21.0, -19.0, self.vwImgBackgound.frame.size.width + 42.0, self.vwImgBackgound.frame.size.height + 45.0)];
//        [bgImage setImage: [UIImage imageNamed:@"home_buttom_gym"]];
//        [vwImgBackgound addSubview:bgImage];
        
    } else if (IS_IPHONE8PLUS) {
        
        [UIView animateWithDuration:timeInterval animations:^{
            [self.contentView setFrame: CGRectMake(0.0, 44.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
        }];
//        [self.view addSubview: contentView];
        
        CGFloat contentViewWidth = _contentView.frame.size.width;
        CGFloat contentViewHeight = _contentView.frame.size.height;
        
        UIView *lblView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 7.0, (_contentView.frame.size.width), 80.0)];
        [_contentView addSubview: lblView];
        
        CGFloat gymtimerY = lblView.frame.origin.y;
        CGFloat gymtimerHeight = lblView.frame.size.height;
        CGFloat tabbarHeight = 53.0;
        
        [UIView animateWithDuration:timeInterval/4 animations:^{
            [self.vwImgBackgound setFrame: CGRectMake((DEVICE_WIDTH-self->smallWidth)/2, (DEVICE_HEIGHT-self->smallHeight)/2, self->smallWidth, self->smallHeight)];
            UIBezierPath *workoutViewShadowPath = [UIBezierPath bezierPathWithRect: self.bgImage.frame];
            [[self.bgImage layer] setShadowPath: [workoutViewShadowPath CGPath]];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:self->timeInterval/4 animations:^{
                [self.vwImgBackgound setFrame: CGRectMake((DEVICE_WIDTH-self->mediumWidth)/2, (DEVICE_HEIGHT-self->mediumHeight)/2, self->mediumWidth, self->mediumHeight)];
                UIBezierPath *workoutViewShadowPath = [UIBezierPath bezierPathWithRect: self.bgImage.frame];
                [[self.bgImage layer] setShadowPath: [workoutViewShadowPath CGPath]];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:self->timeInterval/4 animations:^{
                    [self.vwImgBackgound setFrame: CGRectMake((DEVICE_WIDTH-self->smallWidth)/2, (DEVICE_HEIGHT-self->smallHeight)/2, self->smallWidth, self->smallHeight)];
                    UIBezierPath *workoutViewShadowPath = [UIBezierPath bezierPathWithRect: self.bgImage.frame];
                    [[self.bgImage layer] setShadowPath: [workoutViewShadowPath CGPath]];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration: self->timeInterval/4 animations:^{
                        [self.bgImage setContentMode: UIViewContentModeScaleToFill];
                        [self.vwImgBackgound setFrame: CGRectMake(35.0, (lblView.frame.origin.y + lblView.frame.size.height + 24.0), (contentViewWidth - 70.0), (contentViewHeight - (gymtimerY + gymtimerHeight + tabbarHeight + 50.0)))];
                        UIBezierPath *workoutViewShadowPath = [UIBezierPath bezierPathWithRect: self.bgImage.frame];
                        [[self.bgImage layer] setShadowPath: [workoutViewShadowPath CGPath]];
                    }];
                }];
            }];
        }];
//        [contentView addSubview:vwImgBackgound];

        [self.bgImage setFrame: CGRectMake(-21.0, -19.0, self.vwImgBackgound.frame.size.width + 42.0, self.vwImgBackgound.frame.size.height + 45.0)];
//        [bgImage setImage: [UIImage imageNamed:@"home_buttom_gym"]];
//        [vwImgBackgound addSubview:bgImage];
    
    } else if (IS_IPHONE8) {
        [UIView animateWithDuration:timeInterval animations:^{
            [self.contentView setFrame: CGRectMake(0.0, 30.0, DEVICE_WIDTH, (DEVICE_HEIGHT - 44.0))];
        }];
//        [self.view addSubview: contentView];

        CGFloat contentViewWidth = _contentView.frame.size.width;
        CGFloat contentViewHeight = _contentView.frame.size.height;
        UIView *lblView = [[UIView alloc] initWithFrame: CGRectMake(0.0, -27.0, (_contentView.frame.size.width), 113.0)];
        [_contentView addSubview: lblView];

        CGFloat gymtimerY = lblView.frame.origin.y;
        CGFloat gymtimerHeight = lblView.frame.size.height;
        CGFloat tabbarHeight = 53.0;
        
        [UIView animateWithDuration:timeInterval/4 animations:^{
            [self.vwImgBackgound setFrame: CGRectMake((DEVICE_WIDTH-self->smallWidth)/2, (DEVICE_HEIGHT-self->smallHeight)/2, self->smallWidth, self->smallHeight)];
            UIBezierPath *workoutViewShadowPath = [UIBezierPath bezierPathWithRect: self.bgImage.frame];
            [[self.bgImage layer] setShadowPath: [workoutViewShadowPath CGPath]];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:self->timeInterval/4 animations:^{
                [self.vwImgBackgound setFrame: CGRectMake((DEVICE_WIDTH-self->mediumWidth)/2, (DEVICE_HEIGHT-self->mediumHeight)/2, self->mediumWidth, self->mediumHeight)];
                UIBezierPath *workoutViewShadowPath = [UIBezierPath bezierPathWithRect: self.bgImage.frame];
                [[self.bgImage layer] setShadowPath: [workoutViewShadowPath CGPath]];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:self->timeInterval/4 animations:^{
                    [self.vwImgBackgound setFrame: CGRectMake((DEVICE_WIDTH-self->smallWidth)/2, (DEVICE_HEIGHT-self->smallHeight)/2, self->smallWidth, self->smallHeight)];
                    UIBezierPath *workoutViewShadowPath = [UIBezierPath bezierPathWithRect: self.bgImage.frame];
                    [[self.bgImage layer] setShadowPath: [workoutViewShadowPath CGPath]];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration: self->timeInterval/4 animations:^{
                        [self.bgImage setContentMode: UIViewContentModeScaleToFill];
                        [self.vwImgBackgound setFrame: CGRectMake(30.0, (lblView.frame.origin.y + lblView.frame.size.height + 10.0), (contentViewWidth - 66.0), (contentViewHeight - (gymtimerY + gymtimerHeight + tabbarHeight + 50.0)))];
                        UIBezierPath *workoutViewShadowPath = [UIBezierPath bezierPathWithRect: self.bgImage.frame];
                        [[self.bgImage layer] setShadowPath: [workoutViewShadowPath CGPath]];
                    }];
                }];
            }];
        }];
//        [contentView addSubview:vwImgBackgound];

        [self.bgImage setFrame: CGRectMake(-21.0, -19.0, self.vwImgBackgound.frame.size.width + 42.0, self.vwImgBackgound.frame.size.height + 45.0)];
//        [bgImage setImage: [UIImage imageNamed:@"home_buttom_gym"]];
//        [vwImgBackgound addSubview:bgImage];
    
    } else {
        [UIView animateWithDuration:timeInterval animations:^{
            [self.contentView setFrame: CGRectMake(0.0, 15.0, DEVICE_WIDTH, (DEVICE_HEIGHT + 26.0))];
        }];
//        [self.view addSubview: contentView];
        
        CGFloat contentViewWidth = _contentView.frame.size.width;
        CGFloat contentViewHeight = _contentView.frame.size.height;
        
        UIView *lblView = [[UIView alloc] initWithFrame: CGRectMake(0.0, -2.0, (_contentView.frame.size.width), 85.0)];
        [_contentView addSubview: lblView];
        
        CGFloat gymtimerY = lblView.frame.origin.y;
        CGFloat gymtimerHeight = lblView.frame.size.height;
        CGFloat tabbarHeight = 53.0;
        
        [UIView animateWithDuration:timeInterval/4 animations:^{
            [self.vwImgBackgound setFrame: CGRectMake((DEVICE_WIDTH-self->smallWidth)/2, (DEVICE_HEIGHT-self->smallHeight)/2, self->smallWidth, self->smallHeight)];
            UIBezierPath *workoutViewShadowPath = [UIBezierPath bezierPathWithRect: self.bgImage.frame];
            [[self.bgImage layer] setShadowPath: [workoutViewShadowPath CGPath]];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:self->timeInterval/4 animations:^{
                [self.vwImgBackgound setFrame: CGRectMake((DEVICE_WIDTH-self->mediumWidth)/2, (DEVICE_HEIGHT-self->mediumHeight)/2, self->mediumWidth, self->mediumHeight)];
                UIBezierPath *workoutViewShadowPath = [UIBezierPath bezierPathWithRect: self.bgImage.frame];
                [[self.bgImage layer] setShadowPath: [workoutViewShadowPath CGPath]];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:self->timeInterval/4 animations:^{
                    [self.vwImgBackgound setFrame: CGRectMake((DEVICE_WIDTH-self->smallWidth)/2, (DEVICE_HEIGHT-self->smallHeight)/2, self->smallWidth, self->smallHeight)];
                    UIBezierPath *workoutViewShadowPath = [UIBezierPath bezierPathWithRect: self.bgImage.frame];
                    [[self.bgImage layer] setShadowPath: [workoutViewShadowPath CGPath]];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration: self->timeInterval/4 animations:^{
                        [self.bgImage setContentMode: UIViewContentModeScaleToFill];
                        [self.vwImgBackgound setFrame: CGRectMake(18.0, (lblView.frame.origin.y + lblView.frame.size.height), (contentViewWidth - 36.0), (contentViewHeight - (gymtimerY + gymtimerHeight + tabbarHeight + 60.0)))];
                        UIBezierPath *workoutViewShadowPath = [UIBezierPath bezierPathWithRect: self.bgImage.frame];
                        [[self.bgImage layer] setShadowPath: [workoutViewShadowPath CGPath]];
                    }];
                }];
            }];
        }];
//        [contentView addSubview:vwImgBackgound];

        [self.bgImage setFrame: CGRectMake(-21.0, -19.0, self.vwImgBackgound.frame.size.width + 42.0, self.vwImgBackgound.frame.size.height + 45.0)];
//        [bgImage setImage: [UIImage imageNamed:@"home_buttom_gym"]];
//        [vwImgBackgound addSubview:bgImage];
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
