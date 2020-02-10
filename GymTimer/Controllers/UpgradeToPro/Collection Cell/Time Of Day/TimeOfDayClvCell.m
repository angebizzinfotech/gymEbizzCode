//
//  TimeOfDayClvCell.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 11/12/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "TimeOfDayClvCell.h"
#import "CommonImports.h"

@implementation TimeOfDayClvCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    arrHours = @[@"00 - 06h", @"06 - 08h", @"08 - 10h", @"10 - 12h", @"12 - 14h", @"14 - 16h", @"16 - 18h", @"18 - 20h", @"20 - 22h", @"22 - 00h"];
    
    arrCounts = @[@"0", @"1", @"0", @"3", @"4", @"5", @"2", @"5", @"4", @"2"];
    
    // Register TableView Cell
    UINib *timeOfTheDayNib = [UINib nibWithNibName:@"TimeOfTheDayCell" bundle:nil];
    [self.tblTimeOfDay registerNib:timeOfTheDayNib forCellReuseIdentifier:@"TimeOfTheDayCell"];
    
    // Set Delegate
    self.tblTimeOfDay.delegate = self;
    self.tblTimeOfDay.dataSource = self;
    
    // Set Radius
    self.vwTimeOfDay.layer.cornerRadius = 30.0;
    self.vwTimeOfDayShadow.layer.cornerRadius = 30.0;
    
    // Set Shadow
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIBezierPath *enduranceShadow = [UIBezierPath bezierPathWithRoundedRect:[self.vwTimeOfDayShadow bounds] cornerRadius:30];
        [[self.vwTimeOfDayShadow layer] setMasksToBounds: NO];
        [[self.vwTimeOfDayShadow layer] setShadowColor: [[UIColor blackColor] CGColor]];
        [[self.vwTimeOfDayShadow layer] setShadowOffset: CGSizeMake(0, 2)];
        [[self.vwTimeOfDayShadow layer] setShadowRadius: 5.0];
        [[self.vwTimeOfDayShadow layer] setShadowOpacity: 0.2];
        [self.vwTimeOfDayShadow.layer setRasterizationScale:[UIScreen.mainScreen scale]];
        [[self.vwTimeOfDayShadow layer] setShadowPath: [enduranceShadow CGPath]];
    });
    
}

// MARK:- UITableView Delegate & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrHours.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimeOfTheDayCell *timeOfDayCell = [tableView dequeueReusableCellWithIdentifier:@"TimeOfTheDayCell" forIndexPath:indexPath];
    
    // Cell Layout    
    timeOfDayCell.vwBar.layer.cornerRadius = timeOfDayCell.vwBar.frame.size.height / 2;
    
    // Assign Data
    int count = [arrCounts[indexPath.row] intValue];
    
    timeOfDayCell.lblTimeDuration.text = arrHours[indexPath.row];
    [timeOfDayCell.lblTimeCount countFromZeroTo:count withDuration:1.0];
        
    // Set bar height
    
    if (count > 0) {
        int cellWidth = self.tblTimeOfDay.frame.size.width - 88;
        int width = cellWidth / 5;
        timeOfDayCell.vwBarWidth.constant = 62;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.0 animations:^{
                timeOfDayCell.vwBarWidth.constant = (width * count) + 62;
                [timeOfDayCell.vwBar layoutIfNeeded];
                [timeOfDayCell layoutIfNeeded];
            }];
        });
        
    } else {
        timeOfDayCell.lblTimeCount.text = @"";
        timeOfDayCell.vwBarWidth.constant = 62;
    }
        
    return timeOfDayCell;
}

@end
