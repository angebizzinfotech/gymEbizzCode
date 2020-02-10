//
//  PrivacyPolicyViewController.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 18/04/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrivacyPolicyViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIView *viewLoaderBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *imgAppBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *lblLoaderGymTimerLabel;
@property (weak, nonatomic) IBOutlet UIView *viewLoaderContentView;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewPrivacyPolicy;
@property (weak, nonatomic) IBOutlet UIView *contentViewPrivacyPolicy;

@property (weak, nonatomic) IBOutlet UILabel *lblPrivacyPolicyTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnBackButton;
@property (weak, nonatomic) IBOutlet UITextView *tvPrivacyPolicyTextView;

- (IBAction)btnBackButtonTapped:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
