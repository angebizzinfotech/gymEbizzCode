//
//  OnBoardingCVC.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 31/10/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Utils.h"

NS_ASSUME_NONNULL_BEGIN

@interface OnBoardingCVC : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblGym2;
@property (strong, nonatomic) IBOutlet UIImageView *imgIcon;
@property (strong, nonatomic) IBOutlet UIView *vwLoader;
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *vwProgress;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblTitleTopCons;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblDesTopCons;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constBtnNextBottom;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constPageControlBottom;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constBtnNextHeight;

@end

NS_ASSUME_NONNULL_END
