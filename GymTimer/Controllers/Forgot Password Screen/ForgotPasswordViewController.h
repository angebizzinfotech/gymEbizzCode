//
//  ForgotPasswordViewController.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 25/04/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ForgotPasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgAppBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *lblGymTimerTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *viewForgotPasswordContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblForgotYourPasswordLabel;
@property (weak, nonatomic) IBOutlet UITextField *tfEmailTextField;
@property (weak, nonatomic) IBOutlet UIView *viewEmailUnderlineView;
@property (weak, nonatomic) IBOutlet UIButton *btnRequestNewOneButton;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelButton;

- (IBAction)btnRequestNewOneButtonTapped:(UIButton *)sender;
- (IBAction)btnCancelButtonTapped:(UIButton *)sender;


@end

NS_ASSUME_NONNULL_END
