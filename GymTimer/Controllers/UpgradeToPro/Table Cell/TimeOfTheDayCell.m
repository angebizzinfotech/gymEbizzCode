//
//  TimeOfTheDayCell.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 12/12/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "TimeOfTheDayCell.h"

@implementation TimeOfTheDayCell

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
