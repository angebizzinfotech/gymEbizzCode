//
//  WarmUpView.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 31/01/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

#import "WarmUpView.h"

@implementation WarmUpView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) [self setup];
    
    // Set Radius
    self.vwMessage.layer.cornerRadius = self.vwMessage.frame.size.height / 2;
    [self.vwMessage setClipsToBounds: YES];
    
    self.vwPro.layer.cornerRadius = 5;
    self.vwFree1.layer.cornerRadius = 5;
    self.vwFree2.layer.cornerRadius = 5;
    self.vwWarmUp.layer.cornerRadius = 30;
    
    // Set Shadow
    [self setShadow:self.vwPro];
    [self setShadow:self.vwFree1];
    [self setShadow:self.vwFree2];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) [self setup];
    return self;
}

- (void)setup {
    // Load NIB
    [NSBundle.mainBundle loadNibNamed:@"WarmUpView" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight);
}

- (void)setShadow:(UIView *)view {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIBezierPath *enduranceShadow = [UIBezierPath bezierPathWithRoundedRect:[view bounds] cornerRadius:4];
        [[view layer] setMasksToBounds: NO];
        [[view layer] setShadowColor: [[UIColor blackColor] CGColor]];
        [[view layer] setShadowOffset: CGSizeMake(0, 2)];
        [[view layer] setShadowRadius: 5.0];
        [[view layer] setShadowOpacity: 0.2];
        [view.layer setRasterizationScale:[UIScreen.mainScreen scale]];
        [[view layer] setShadowPath: [enduranceShadow CGPath]];
    });
}

@end
