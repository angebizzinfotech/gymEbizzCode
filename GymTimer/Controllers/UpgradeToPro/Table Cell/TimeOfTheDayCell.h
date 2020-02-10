//
//  TimeOfTheDayCell.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 12/12/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonImports.h"

NS_ASSUME_NONNULL_BEGIN

@interface TimeOfTheDayCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *vwBar;
@property (strong, nonatomic) IBOutlet UILabel *lblTimeDuration;
@property (strong, nonatomic) IBOutlet UICountingLabel *lblTimeCount;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vwBarWidth;

@end

NS_ASSUME_NONNULL_END
