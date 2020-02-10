//
//  OnBoardingCollectionViewCell.h
//  GymTimer
//
//  Created by Vivek on 11/01/19.
//  Copyright © 2019 Vivek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnBoardingCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *viewMainView;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *lblGymTimerLabel;
@property (weak, nonatomic) IBOutlet UIView *viewContentView;
@property (weak, nonatomic) IBOutlet UIButton *btnSkipButton;
@property (weak, nonatomic) IBOutlet UIImageView *imgContentIconImage;
@property (weak, nonatomic) IBOutlet UILabel *lblContentMainLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblContentSubLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControlOnboard;
@property (weak, nonatomic) IBOutlet UIButton *btnNavigationButton;

- (IBAction)btnSkipButtonTapped:(UIButton *)sender;
- (IBAction)btnNavigationButtonTapped:(UIButton *)sender;

@end
