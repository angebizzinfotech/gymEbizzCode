//
//  RankListCell.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 09/09/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RankListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgBadge;
@property (strong, nonatomic) IBOutlet UILabel *lblIndex;
@property (strong, nonatomic) IBOutlet UIView *vwBack;
@property (strong, nonatomic) IBOutlet UIView *vwProfileBack;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfile;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblWorkout;
@property (strong, nonatomic) IBOutlet UIView *vwTop;

@property (strong, nonatomic) UIViewController *parentVC;
@property (nonatomic) NSInteger index;
- (void)animateCell;

@end

NS_ASSUME_NONNULL_END
