//
//  ContactUsViewController.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 18/04/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactUsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewLoaderBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *imgAppBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *lblLoaderGymTimerLabel;
@property (weak, nonatomic) IBOutlet UIView *viewLoaderContentView;


@property (weak, nonatomic) IBOutlet UILabel *lblContactUsTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnBackButton;
@property (weak, nonatomic) IBOutlet UITextView *tvFaqTextView;
@property (weak, nonatomic) IBOutlet UIView *viewFaqUnderlineView;
@property (weak, nonatomic) IBOutlet UIButton *btnSendFaqButton;

- (IBAction)btnBackButtonTapped:(UIButton *)sender;
- (IBAction)btnSendFaqButtonTapped:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
