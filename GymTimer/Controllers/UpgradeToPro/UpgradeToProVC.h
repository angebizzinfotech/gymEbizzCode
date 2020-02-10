//
//  UpgradeToProVC.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 11/12/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonImports.h"

NS_ASSUME_NONNULL_BEGIN

@interface UpgradeToProVC : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *btnClose;
@property (strong, nonatomic) IBOutlet UIScrollView *scrView;
@property (strong, nonatomic) IBOutlet UICollectionView *clvCards;
@property (strong, nonatomic) IBOutlet UIView *vwMonth;
@property (strong, nonatomic) IBOutlet UIView *vwYear;
@property (strong, nonatomic) IBOutlet UIView *vwPopular;
@property (strong, nonatomic) IBOutlet UIView *vwGrayProgress;
@property (strong, nonatomic) IBOutlet UIView *vwGreenProgress;
@property (strong, nonatomic) IBOutlet UIButton *btnTermsOfUse;
@property (strong, nonatomic) IBOutlet UIButton *btnMonth;
@property (strong, nonatomic) IBOutlet UIButton *btnYear;
@property (strong, nonatomic) IBOutlet UIView *vwPro;
@property (strong, nonatomic) IBOutlet UILabel *lblTermsOfUs;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblDollar58;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblDollar2;
@property (strong, nonatomic) IBOutlet UILabel *lblYourAverage;
@property (strong, nonatomic) IBOutlet UIView *vwProgress;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constVwGrayWidth;

@property (weak) NSTimer *scrollTimer;
@property (strong, nonatomic) NSString *isFromSetting;

@end

NS_ASSUME_NONNULL_END
