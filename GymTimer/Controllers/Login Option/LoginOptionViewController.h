//
//  LoginOptionViewController.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 22/10/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginOptionViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *vwFacebook;
@property (strong, nonatomic) IBOutlet UIButton *btnFacebook;
@property (strong, nonatomic) IBOutlet UILabel *lblFacebook;
@property (strong, nonatomic) IBOutlet UIView *vwEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblLogin;
@property (strong, nonatomic) IBOutlet UIView *vwLogin;
@property (strong, nonatomic) IBOutlet UIImageView *imgBackground;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constLoginTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constVwLoginBottom;

@property (strong, nonatomic) IBOutlet UIView *vwWhiteBg;
@property (strong, nonatomic) IBOutlet UIView *vwBottom;

@end

NS_ASSUME_NONNULL_END
