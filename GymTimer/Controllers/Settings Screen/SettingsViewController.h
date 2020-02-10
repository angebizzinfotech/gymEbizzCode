//
//  SettingsViewController.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 17/04/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingsViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIView *viewLoaderBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *imgAppBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *lblLoaderGymTimerLabel;
@property (weak, nonatomic) IBOutlet UIView *viewLoaderContentView;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewSettingsScreen;
@property (weak, nonatomic) IBOutlet UIView *contentViewSettingsScreen;

@property (weak, nonatomic) IBOutlet UILabel *lblSettingsTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tblSettingsTableView;

@end

NS_ASSUME_NONNULL_END
