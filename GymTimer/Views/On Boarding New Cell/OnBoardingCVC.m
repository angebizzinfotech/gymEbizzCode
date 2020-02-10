//
//  OnBoardingCVC.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 31/10/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "OnBoardingCVC.h"

@implementation OnBoardingCVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if (IS_IPHONEXR) {
        [_lblTitleTopCons setConstant:90.0];
        [_lblDesTopCons setConstant:25.0];
    } else if (IS_IPHONEX) {
        [_lblTitleTopCons setConstant:85.0];
        [_lblDesTopCons setConstant:20.0];
    } else if (IS_IPHONE8PLUS) {
        
    } else if (IS_IPHONE8) {
        // Set Top Label Font
        UIFont *gymFont = [UIFont fontWithName:fFUTURA_CONDENSED_EXTRA_BOLD size:75.0];
        [self.lblGym2 setFont:gymFont];
    } else {
        // Set Top Label Font
        UIFont *gymFont = [UIFont fontWithName:fFUTURA_CONDENSED_EXTRA_BOLD size:65.0];
        [self.lblGym2 setFont:gymFont];
    }
}

@end
