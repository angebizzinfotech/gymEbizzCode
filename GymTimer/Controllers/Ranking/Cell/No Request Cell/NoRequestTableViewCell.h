//
//  NoRequestTableViewCell.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 14/09/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoRequestTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIView *friendBGShadow;
@property (weak, nonatomic) IBOutlet UIImageView *friendImage;
@property (weak, nonatomic) IBOutlet UIView *friendImageBG;

@end

NS_ASSUME_NONNULL_END
