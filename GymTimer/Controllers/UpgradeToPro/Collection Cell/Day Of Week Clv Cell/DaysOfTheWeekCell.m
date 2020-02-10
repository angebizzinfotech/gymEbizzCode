//
//  DaysOfTheWeekCell.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 12/12/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "DaysOfTheWeekCell.h"

@implementation DaysOfTheWeekCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.lblCount setFormat:@"%d"];
}

@end
