//
//  DayOfWeekClvCell.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 11/12/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "DayOfWeekClvCell.h"
#import "CommonImports.h"

@implementation DayOfWeekClvCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    arrDays = @[@"M", @"T", @"W", @"T", @"F", @"S", @"S"];
    
    arrCount = @[@"4", @"3", @"5", @"4", @"2", @"5", @"3"];
        
    // Register CollectionView Cell
    UINib *daysOfWeekNib = [UINib nibWithNibName:@"DaysOfTheWeekCell" bundle:nil];
    [self.clvDayOfWeek registerNib:daysOfWeekNib forCellWithReuseIdentifier:@"DaysOfTheWeekCell"];
    
    // Set Delegate
    self.clvDayOfWeek.delegate = self;
    self.clvDayOfWeek.dataSource = self;
    
    // Set Radius
    self.vwDayOfWeek.layer.cornerRadius = 30.0;
    self.vwDayOfWeekShadow.layer.cornerRadius = 30.0;
    
    // Set Collectionview Edge Inset
    if (IS_IPHONE5s) {
        self.clvDayOfWeek.contentInset = UIEdgeInsetsMake(0, 9.5, 0, 9.5);
    } else {
        self.clvDayOfWeek.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    }

    // Days CollectionView Layout
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat itemWidth = (self.clvDayOfWeek.frame.size.width) - (self.clvDayOfWeek.contentInset.left +  self.clvDayOfWeek.contentInset.right);
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemWidth / 7, self.clvDayOfWeek.frame.size.height);
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        self.clvDayOfWeek.collectionViewLayout = layout;
    });
    
    // Set Shadow
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIBezierPath *enduranceShadow = [UIBezierPath bezierPathWithRoundedRect:[self.vwDayOfWeekShadow bounds] cornerRadius:30];
        [[self.vwDayOfWeekShadow layer] setMasksToBounds: NO];
        [[self.vwDayOfWeekShadow layer] setShadowColor: [[UIColor blackColor] CGColor]];
        [[self.vwDayOfWeekShadow layer] setShadowOffset: CGSizeMake(0, 2)];
        [[self.vwDayOfWeekShadow layer] setShadowRadius: 5.0];
        [[self.vwDayOfWeekShadow layer] setShadowOpacity: 0.2];
        [self.vwDayOfWeekShadow.layer setRasterizationScale:[UIScreen.mainScreen scale]];
        [[self.vwDayOfWeekShadow layer] setShadowPath: [enduranceShadow CGPath]];
    });
}

// MARK:- UICollectionView Delegate & Datasource 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arrDays.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DaysOfTheWeekCell *dayOfWeekCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DaysOfTheWeekCell" forIndexPath:indexPath];
    
    // Cell Layout
    dayOfWeekCell.vwBar.layer.cornerRadius = 8;
    
    // Assign Data
    int count = [arrCount[indexPath.row] intValue];
    dayOfWeekCell.lblDay.text = arrDays[indexPath.row];
    
    [dayOfWeekCell.lblCount countFromZeroTo:count withDuration:1.0];
    
    // Set bar height
    int cellHeight = self.clvDayOfWeek.frame.size.height - 74;
        
    if (count > 0) {
        int height = cellHeight / 5;
        dayOfWeekCell.lblCount.text = arrCount[indexPath.row];
        
        dayOfWeekCell.vwBarHeight.constant = 28;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.0 animations:^{
                dayOfWeekCell.vwBarHeight.constant = (height * count) + 28;
                [dayOfWeekCell.vwBar layoutIfNeeded];
                [dayOfWeekCell layoutIfNeeded];
            }];
            
        });
    } else {
        dayOfWeekCell.lblCount.text = @"";
        dayOfWeekCell.vwBarHeight.constant = 28;
    }
    
    return dayOfWeekCell;
}

@end
