//
//  TimeOfDayCell.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 10/12/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "TimeOfDayCell.h"

@implementation TimeOfDayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.lblTimeCount setFormat:@"%d"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
