//
//  DayOfWeekClvCell.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 11/12/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DayOfWeekClvCell : UICollectionViewCell <UICollectionViewDelegate, UICollectionViewDataSource> {
    NSArray *arrDays, *arrCount;
}

@property (strong, nonatomic) IBOutlet UIView *vwDayOfWeekShadow;
@property (strong, nonatomic) IBOutlet UIView *vwDayOfWeek;
@property (strong, nonatomic) IBOutlet UICollectionView *clvDayOfWeek;

@end

NS_ASSUME_NONNULL_END
