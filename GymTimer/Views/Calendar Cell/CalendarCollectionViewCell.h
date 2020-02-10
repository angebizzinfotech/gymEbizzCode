//
//  CalendarCollectionViewCell.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 23/04/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CalendarCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *viewContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblDateLabel;

@end

NS_ASSUME_NONNULL_END
