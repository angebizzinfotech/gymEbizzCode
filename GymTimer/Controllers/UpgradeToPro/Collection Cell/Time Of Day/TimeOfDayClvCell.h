//
//  TimeOfDayClvCell.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 11/12/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeOfDayClvCell : UICollectionViewCell <UITableViewDelegate, UITableViewDataSource> {
    NSArray *arrHours, *arrCounts;
}

@property (strong, nonatomic) IBOutlet UITableView *tblTimeOfDay;
@property (strong, nonatomic) IBOutlet UIView *vwTimeOfDayShadow;
@property (strong, nonatomic) IBOutlet UIView *vwTimeOfDay;

@end

NS_ASSUME_NONNULL_END
