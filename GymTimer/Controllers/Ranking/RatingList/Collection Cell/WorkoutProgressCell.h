//
//  WorkoutProgressCell.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 09/09/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonImports.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkoutProgressCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *lblDayName;
@property (strong, nonatomic) IBOutlet MBCircularProgressBarView *progressCircle;
@property (strong, nonatomic) IBOutlet UIImageView *centerImage;
@property (strong, nonatomic) IBOutlet UIView *vwCurrentDay;

@end

NS_ASSUME_NONNULL_END
