//
//  RequestReceivedCell.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 09/09/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "RequestReceivedCell.h"

@implementation RequestReceivedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//MARK:- Button Click
- (IBAction)btnAcceptClick:(id)sender{
    self.btnAcceptTap();
}

- (IBAction)btnDeclineClick:(id)sender{
    self.btnDeclineTap();
}

@end
