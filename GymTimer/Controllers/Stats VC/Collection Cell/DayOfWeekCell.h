//
//  DayOfWeekCell.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 10/12/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonImports.h"

NS_ASSUME_NONNULL_BEGIN

@interface DayOfWeekCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIView *vwBar;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblCount;
@property (strong, nonatomic) IBOutlet UILabel *lblDay;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vwBarHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vwDaysBarWidth;

@end

NS_ASSUME_NONNULL_END
