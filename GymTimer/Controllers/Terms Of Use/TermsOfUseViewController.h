//
//  TermsOfUseViewController.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 15/07/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TermsOfUseViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewLoaderBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *imgAppBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *lblLoaderGymTimerLabel;
@property (weak, nonatomic) IBOutlet UIView *viewLoaderContentView;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewTermsOfUse;
@property (weak, nonatomic) IBOutlet UIView *contentViewTermsOfUse;

@property (weak, nonatomic) IBOutlet UILabel *lblTermsOfUseTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnBackButton;
@property (weak, nonatomic) IBOutlet UITextView *tvTermsOfUseTextView;

- (IBAction)btnBackButtonTapped:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
