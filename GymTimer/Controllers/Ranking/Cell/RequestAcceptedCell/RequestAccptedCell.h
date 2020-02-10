//
//  RequestAccptedCell.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 09/09/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RequestAccptedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *friendBGShadow;
@property (weak, nonatomic) IBOutlet UIImageView *friendImage;
@property (weak, nonatomic) IBOutlet UIView *friendImageBG;
@property (weak, nonatomic) IBOutlet UILabel *friendName;
@property (weak, nonatomic) IBOutlet UILabel *friendWorkout;

@end

NS_ASSUME_NONNULL_END
