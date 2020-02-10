//
//  NewOnBoardingViewController.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 06/06/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Utils.h"
#import "AppDelegate.h"
#import "CommonImports.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewOnBoardingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *btnSkip;
@property (weak, nonatomic) IBOutlet UIButton *btnYes;

// sumit
@property (strong, nonatomic) IBOutlet UIView *vwTopRoundedCorner;
@property (strong, nonatomic) IBOutlet UIView *vwParentview;
@property (strong, nonatomic) IBOutlet UIImageView *imgIcon;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cnstParentTopRoundCornerBottom;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;

@property (weak, nonatomic) IBOutlet UIView *vwFirst;
@property (weak, nonatomic) IBOutlet UIView *vwSecond;
@property (weak, nonatomic) IBOutlet UIView *vwThird;
@property (weak, nonatomic) IBOutlet UIView *vwForth;
@property (strong, nonatomic) IBOutlet UIView *vwFifth;
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *vwProgress;
@property (strong, nonatomic) IBOutlet UIImageView *imgScene1;
@property (strong, nonatomic) IBOutlet UIImageView *imgScene2;
@property (strong, nonatomic) IBOutlet UIImageView *imgScene3;
@property (strong, nonatomic) IBOutlet UIImageView *imgScene4;
@property (strong, nonatomic) IBOutlet UIView *vwSkip;

@property (strong, nonatomic) IBOutlet UILabel *lblAt2;
@property (strong, nonatomic) IBOutlet UILabel *lblGym2;
@property (strong, nonatomic) IBOutlet UILabel *lblAt3;
@property (strong, nonatomic) IBOutlet UILabel *lblGym3;
@property (strong, nonatomic) IBOutlet UILabel *lblAt4;
@property (strong, nonatomic) IBOutlet UILabel *lblHome4;
@property (strong, nonatomic) IBOutlet UILabel *lblAt5;
@property (strong, nonatomic) IBOutlet UILabel *lblHome5;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *howToUseHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *progressWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *progressHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextBtnBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextBtnHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageControlBottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scene2TopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scene3TopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scene4TopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scene5TopConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constAt2Top;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constAt3Top;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constAt4Top;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constAt5Top;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constVwProgressTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constHowToTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constDumbelHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constDumbelWidth;

@property (strong, nonatomic) IBOutlet UICollectionView *cvcDetail;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cvcLeftCons;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vwBounceHgtCons;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constLblAtLeading;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constLblGymLeading;
@property (strong, nonatomic) IBOutlet UILabel *lblHome;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constLblGym2Trailing;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constLblHomeLeading;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constLblHomeTrailing;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constPageControlBottom;

@end

NS_ASSUME_NONNULL_END
