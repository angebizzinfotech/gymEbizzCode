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

@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *vwProgress;
@property (weak, nonatomic) IBOutlet UIView *vwBouncing;

@property (weak, nonatomic) IBOutlet UIView *vwLaunch;
@property (weak, nonatomic) IBOutlet UIView *vwSigninFacebook;
@property (weak, nonatomic) IBOutlet UIView *vwSignupEmail;

@end

NS_ASSUME_NONNULL_END
