//
//  ProfileViewController.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 18/04/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIView *viewLoaderBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *imgAppBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *lblLoaderGymTimerLabel;
@property (weak, nonatomic) IBOutlet UIView *viewLoaderContentView;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewProfileScreen;
@property (weak, nonatomic) IBOutlet UIView *contentViewProfileScreen;

@property (weak, nonatomic) IBOutlet UIButton *btnBackButton;
@property (weak, nonatomic) IBOutlet UILabel *lblProfileTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblPrivateInformationLabel;
@property (weak, nonatomic) IBOutlet UIView *viewNameContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblNameTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *tfNameTextField;
@property (weak, nonatomic) IBOutlet UIView *viewNameUnderlineView;
@property (weak, nonatomic) IBOutlet UIView *viewEmailContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblEmailTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *tfEmailTextField;
@property (weak, nonatomic) IBOutlet UIView *viewEmailUnderlineView;
@property (weak, nonatomic) IBOutlet UIView *viewPasswordContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblPasswordTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *tfPasswordTextField;
@property (weak, nonatomic) IBOutlet UIView *viewPasswordUnderlineView;
@property (weak, nonatomic) IBOutlet UIButton *btnProfileUpdateButton;
@property (strong, nonatomic) IBOutlet UIView *viewProfile;
@property (strong, nonatomic) IBOutlet UIView *viewProfileParent;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfile;
@property (strong, nonatomic) IBOutlet UIButton *btnChangeProfile;


- (IBAction)btnProfileUpdateButtonTapped:(UIButton *)sender;
- (IBAction)btnBackButtonTapped:(UIButton *)sender;


@end

NS_ASSUME_NONNULL_END
