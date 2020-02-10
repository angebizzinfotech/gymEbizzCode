//
//  RankListCell.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 09/09/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "RankListCell.h"
#import "CommonImports.h"

@implementation RankListCell {
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)animateCell {
    self.vwTop.alpha = 1.0;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.vwTop.alpha = 0.0;
    } completion:^(BOOL finished) {
        RatingListViewController *ratingList = (RatingListViewController *)self.parentVC;
        RankListCell *nextCell = [ratingList.dicRankCell valueForKey:[NSString stringWithFormat:@"%ld",self.index + 1]];
        [nextCell animateCell];
    }];
}

@end
