//
//  LoadingScreenVC.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 07/02/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoadingScreenVC : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imgWelcomback;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *vwImgBackgound;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@end

NS_ASSUME_NONNULL_END
