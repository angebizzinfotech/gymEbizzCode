//
//  OnBoardingViewController.h
//  GymTimer
//
//  Created by Vivek on 11/01/19.
//  Copyright © 2019 Vivek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Utils.h"

@interface OnBoardingViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *imgBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *lblGymTimerLabel;
@property (weak, nonatomic) IBOutlet UIView *viewContentView;
@property (weak, nonatomic) IBOutlet UIButton *btnSkipButton;
@property (weak, nonatomic) IBOutlet UIImageView *imgContentImage;
@property (weak, nonatomic) IBOutlet UILabel *lblContentMainLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblContentSubLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *btnNavigationButton;
@property (weak, nonatomic) IBOutlet UICollectionView *cvOnBoardingCollectionView;

@property (weak, nonatomic) IBOutlet UIView *viewTest;

- (IBAction)btnSkipButtonTapped:(UIButton *)sender;
- (IBAction)btnNavigationButtonTapped:(UIButton *)sender;


@end
