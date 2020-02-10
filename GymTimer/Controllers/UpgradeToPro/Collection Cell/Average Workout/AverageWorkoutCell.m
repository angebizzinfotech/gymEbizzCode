//
//  AverageWorkoutCell.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 11/12/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "AverageWorkoutCell.h"

@implementation AverageWorkoutCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Set Shadow with radius
    self.vwShadow.layer.cornerRadius = 30;
    self.vwAverageWorkout.layer.cornerRadius = 30;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIBezierPath *enduranceShadow = [UIBezierPath bezierPathWithRoundedRect:[self.vwShadow bounds] cornerRadius:30];
        [[self.vwShadow layer] setMasksToBounds: NO];
        [[self.vwShadow layer] setShadowColor: [[UIColor blackColor] CGColor]];
        [[self.vwShadow layer] setShadowOffset: CGSizeMake(0, 2)];
        [[self.vwShadow layer] setShadowRadius: 5.0];
        [[self.vwShadow layer] setShadowOpacity: 0.2];
        [self.vwShadow.layer setRasterizationScale:[UIScreen.mainScreen scale]];
        [[self.vwShadow layer] setShadowPath: [enduranceShadow CGPath]];
    });
    
    // Set counting label format
    [self.lblDurationMin setFormat:@"%d"];
    [self.lblDurationSec setFormat:@"%d"];
    [self.lblExercise setFormat:@"%d"];
    
    // Setup Circle Progress
    self.vwQuality.valueFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
    self.vwQuality.valueFontSize = 32;
    self.vwQuality.fontColor = cNEW_GREEN;
    self.vwQuality.unitFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
    self.vwQuality.unitFontSize = 18;
    
    // Filter Setup
    self.vwFilter.layer.cornerRadius = 10;
    
    self.btnYearly.layer.cornerRadius = 9.5;
    [self.btnYearly setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)animateNumbers {
    [UIView animateWithDuration:0.001 animations:^{
        [self.vwQuality setValue:0.0];
        [self layoutIfNeeded];
    }];
        
    [self.lblDurationMin countFrom:0 to:45 withDuration:0.8];
    [self.lblDurationSec countFrom:0 to:39 withDuration:0.8];
    [self.lblExercise countFrom:0 to:6 withDuration:0.8];
}

@end
