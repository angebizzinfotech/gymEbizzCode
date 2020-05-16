//
//  launchCircleScreenVC.h
//  GymTimer
//
//  Created by macOS on 14/04/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonImports.h"
#import "Utils.h"

NS_ASSUME_NONNULL_BEGIN

@interface launchCircleScreenVC : UIViewController

@property Boolean withLaunch;
@property Boolean isHome;

@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *vwProgress;
@property (weak, nonatomic) IBOutlet UIView *vwBouncing;
@property (weak, nonatomic) IBOutlet UIView *vwSingleLineBounce;
@property (weak, nonatomic) IBOutlet UIView *vwDoubleLineBounce;
@property (weak, nonatomic) IBOutlet UIView *vwDoubleLineNotificationBounce;

@property (weak, nonatomic) IBOutlet UIView *vwBackgroundGreen;
@property (weak, nonatomic) IBOutlet UIView *vwLaunch;
@property (weak, nonatomic) IBOutlet UIView *vwSigninFacebook;
@property (weak, nonatomic) IBOutlet UIView *vwSignupEmail;
@property (weak, nonatomic) IBOutlet UIView *vwNotification;

@property (weak, nonatomic) IBOutlet UILabel *lblSignup;
@property (weak, nonatomic) IBOutlet UILabel *lblLogin;
@property (weak, nonatomic) IBOutlet UITextField *txtFullName;
@property (weak, nonatomic) IBOutlet UIView *vwFullName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnForgot;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnsGymtimerHeight;


@end

NS_ASSUME_NONNULL_END
