//
//  SearchFriendCell.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 07/09/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchFriendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *friendBGShadow;
@property (weak, nonatomic) IBOutlet UIImageView *friendImage;
@property (weak, nonatomic) IBOutlet UIView *friendImageBG;
@property (weak, nonatomic) IBOutlet UILabel *friendName;
@property (weak, nonatomic) IBOutlet UILabel *friendEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnAddFriend;
@property (strong, nonatomic) IBOutlet UIView *vwLoader;

@end

NS_ASSUME_NONNULL_END
