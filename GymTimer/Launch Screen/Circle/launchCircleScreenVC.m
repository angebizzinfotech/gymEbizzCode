//
//  launchCircleScreenVC.m
//  GymTimer
//
//  Created by macOS on 14/04/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

#import "launchCircleScreenVC.h"

@interface launchCircleScreenVC ()

@end

@implementation launchCircleScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.vwProgress setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [self startAnimating];
}

- (void)startAnimating {
    
    [UIView animateWithDuration: 2.5 animations:^{
        [self.vwProgress setValue:0.0];
    } completion:^(BOOL finished) {
        [self.vwProgress setValue:0.0];
        
        [UIView animateWithDuration:0 delay:0.0 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
        } completion:^(BOOL finished) {
//            self.vwProgress.value = 100.0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
            });
        }];
    }];
}
@end
