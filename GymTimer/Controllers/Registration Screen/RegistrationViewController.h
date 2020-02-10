//
//  RegistrationViewController.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 25/04/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonImports.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegistrationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgAppBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *lblGymTimerTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *viewLoginSignupBgView;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;


//Signup Content View
@property (weak, nonatomic) IBOutlet UIView *viewSignupContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblSignupTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *tfSignupNameTextField;
@property (weak, nonatomic) IBOutlet UIView *viewSignupNameUnderlineView;
@property (weak, nonatomic) IBOutlet UITextField *tfSignupEmailTextField;
@property (weak, nonatomic) IBOutlet UIView *viewSignupEmailUnderlineView;
@property (weak, nonatomic) IBOutlet UITextField *tfSignupPasswordTextField;
@property (weak, nonatomic) IBOutlet UIView *viewSignupPasswordUnderlineView;
@property (weak, nonatomic) IBOutlet UIView *viewLoginButtonContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblAlreadyMemberLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnLoginButton;

- (IBAction)btnLoginButtonTapped:(UIButton *)sender;


//Login Content View
@property (weak, nonatomic) IBOutlet UIView *viewLoginContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblLoginTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *tfLoginEmailTextField;
@property (weak, nonatomic) IBOutlet UIView *viewLoginEmailUnderlineView;
@property (weak, nonatomic) IBOutlet UITextField *tfLoginPasswordTextField;
@property (weak, nonatomic) IBOutlet UIView *viewLoginPasswordUnderlineView;
@property (weak, nonatomic) IBOutlet UIButton *btnForgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIView *viewSignupButtonContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblAreYouNewHereLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUpButton;

- (IBAction)btnSignUpButtonTapped:(UIButton *)sender;
- (IBAction)btnForgotPasswordButtonTapped:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imgLoginTop;

@property (weak, nonatomic) IBOutlet UIButton *btnStartButton;
- (IBAction)btnStartButtonTapped:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
