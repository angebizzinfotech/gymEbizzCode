//
//  YourSkillLevelCell.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 11/12/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "YourSkillLevelCell.h"

@implementation YourSkillLevelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Set Shadow with radius
    self.vwShadow.layer.cornerRadius = 30;
    self.vwSkillLevel.layer.cornerRadius = 30;
    
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
    
    [self radiusToProgressBar];
    
    // Set counting label format
    [self.lblTrainedHour setFormat:@"%d"];
    [self.lblTrainedMin setFormat:@"%d"];
    [self.lblTrainedSec setFormat:@"%d"];
    [self.lblAverageMin setFormat:@"%d"];
    [self.lblAverageSec setFormat:@"%d"];
    
    // Filter Setup
    self.vwFilter.layer.cornerRadius = 10;
    
    self.btnMonthly.layer.cornerRadius = 9.5;
    [self.btnMonthly setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    // Animate Time Trained
    [self.lblTrainedHour countFrom:0 to:12 withDuration:0.8];
    [self.lblTrainedMin countFrom:0 to:45 withDuration:0.8];
    [self.lblTrainedSec countFrom:0 to:39 withDuration:0.8];

    // Animate Average Workout Per Week
    [self.lblAverageMin countFrom:0 to:3 withDuration:0.8];
    [self.lblAverageSec countFrom:0 to:6 withDuration:0.8];
}

- (void)radiusToProgressBar {
    [self.progress1.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.layer.masksToBounds = YES;
        obj.layer.cornerRadius = 5.0;
    }];
    
    [self.progress2.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.layer.masksToBounds = YES;
        obj.layer.cornerRadius = 5.0;
    }];
    
    [self.progress3.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.layer.masksToBounds = YES;
        obj.layer.cornerRadius = 5.0;
    }];
    
    [self.progress4.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.layer.masksToBounds = YES;
        obj.layer.cornerRadius = 5.0;
    }];
    
    [self.progress5.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.layer.masksToBounds = YES;
        obj.layer.cornerRadius = 5.0;
    }];
}

- (void)animateNumbers {
    // Animate Time Trained
    [self.lblTrainedHour countFrom:0 to:12 withDuration:0.8];
    [self.lblTrainedMin countFrom:0 to:45 withDuration:0.8];
    [self.lblTrainedSec countFrom:0 to:39 withDuration:0.8];

    // Animate Average Workout Per Week
    [self.lblAverageMin countFrom:0 to:3 withDuration:0.8];
    [self.lblAverageSec countFrom:0 to:6 withDuration:0.8];
}

@end
