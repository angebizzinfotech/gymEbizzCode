//
//  SettingsTableViewCell.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 17/04/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewSettingBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *imgSettingIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imgNextIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblSettingNameLabel;
@property (weak, nonatomic) IBOutlet UIView *viewSettingUnderlineView;
@property (weak, nonatomic) IBOutlet UIButton *btnOpenSettingButton;

@end

NS_ASSUME_NONNULL_END
