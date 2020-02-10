//
//  ProCongratsVC.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 09/12/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "ProCongratsVC.h"
#import "CommonImports.h"

@interface ProCongratsVC ()

@end

@implementation ProCongratsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.vwBack.layer.cornerRadius = 8;
    self.vwBack.clipsToBounds = YES;
}

- (IBAction)backAppAction:(UIButton *)sender {
        
    [self dismissViewControllerAnimated:YES completion:^{
        [NSNotificationCenter.defaultCenter postNotificationName:PerformNavigation object:nil];
    }];
}

@end
