//
//  DaysOfTheWeekCell.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 12/12/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonImports.h"

NS_ASSUME_NONNULL_BEGIN

@interface DaysOfTheWeekCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIView *vwBar;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblCount;
@property (strong, nonatomic) IBOutlet UILabel *lblDay;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vwBarHeight;

@end

NS_ASSUME_NONNULL_END
