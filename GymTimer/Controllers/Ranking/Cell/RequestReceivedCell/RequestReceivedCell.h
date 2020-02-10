//
//  RequestReceivedCell.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 09/09/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RequestReceivedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *friendBGShadow;
@property (weak, nonatomic) IBOutlet UIImageView *friendImage;
@property (weak, nonatomic) IBOutlet UIView *friendImageBG;
@property (weak, nonatomic) IBOutlet UILabel *friendName;
@property (weak, nonatomic) IBOutlet UILabel *friendEmail;

@property (nonatomic, copy) void(^btnAcceptTap)(void);
- (IBAction)btnAcceptClick:(id)sender;

@property (nonatomic, copy) void(^btnDeclineTap)(void);
- (IBAction)btnDeclineClick:(id)sender;

@end

NS_ASSUME_NONNULL_END
