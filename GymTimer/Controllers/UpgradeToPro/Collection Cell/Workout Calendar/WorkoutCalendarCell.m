//
//  WorkoutCalendarCell.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 11/12/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "WorkoutCalendarCell.h"

@implementation WorkoutCalendarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    isBackClicked = NO;
    
    arrSelectedDates = @[@"02", @"05", @"07", @"08", @"10", @"11", @"13", @"16", @"19", @"21", @"22", @"23", @"25", @"26"];
    
    arrShortMonthsName = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"];
    
    // Setup Cell Black Border
    cellBlackBorder = [CAShapeLayer layer];
    cellBlackBorder.strokeColor = [UIColor blackColor].CGColor;
    cellBlackBorder.lineWidth = 1.5;
    cellBlackBorder.fillColor = nil;
            
    // Set Shadow with radius
    self.vwWorkoutShadow.layer.cornerRadius = 30;
    self.vwWorkout.layer.cornerRadius = 30;
    
    self.vwCalendarShadow.layer.cornerRadius = 30;
    self.vwCalendar.layer.cornerRadius = 30;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIBezierPath *enduranceShadow = [UIBezierPath bezierPathWithRoundedRect:[self.vwWorkoutShadow bounds] cornerRadius:30];
        [[self.vwWorkoutShadow layer] setMasksToBounds: NO];
        [[self.vwWorkoutShadow layer] setShadowColor: [[UIColor blackColor] CGColor]];
        [[self.vwWorkoutShadow layer] setShadowOffset: CGSizeMake(0, 2)];
        [[self.vwWorkoutShadow layer] setShadowRadius: 5.0];
        [[self.vwWorkoutShadow layer] setShadowOpacity: 0.2];
        [self.vwWorkoutShadow.layer setRasterizationScale:[UIScreen.mainScreen scale]];
        [[self.vwWorkoutShadow layer] setShadowPath: [enduranceShadow CGPath]];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIBezierPath *enduranceShadow = [UIBezierPath bezierPathWithRoundedRect:[self.vwCalendarShadow bounds] cornerRadius:30];
        [[self.vwCalendarShadow layer] setMasksToBounds: NO];
        [[self.vwCalendarShadow layer] setShadowColor: [[UIColor blackColor] CGColor]];
        [[self.vwCalendarShadow layer] setShadowOffset: CGSizeMake(0, 2)];
        [[self.vwCalendarShadow layer] setShadowRadius: 5.0];
        [[self.vwCalendarShadow layer] setShadowOpacity: 0.2];
        [self.vwCalendarShadow.layer setRasterizationScale:[UIScreen.mainScreen scale]];
        [[self.vwCalendarShadow layer] setShadowPath: [enduranceShadow CGPath]];
    });
    
    // Set counting label format
    [self.lblExerciseDone setFormat:@"%d"];
    [self.lblSingleDayHour setFormat:@"%d"];
    [self.lblSingleDayMin setFormat:@"%d"];
    [self.lblSingleDaySec setFormat:@"%d"];
    
    // Setup Circle Progress
    self.vwQuality.valueFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
    self.vwQuality.valueFontSize = 32;
    self.vwQuality.fontColor = cNEW_GREEN;
    self.vwQuality.unitFontName = fFUTURA_CONDENSED_EXTRA_BOLD;
    self.vwQuality.unitFontSize = 18;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupCalendar];
    });
}

- (void)setupCalendar {
    self.workoutStatsCalender = [[FSCalendar alloc] initWithFrame: CGRectMake(0, 0, self.workoutCalendar.frame.size.width, self.workoutCalendar.frame.size.height)];
    
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    
    [self.workoutStatsCalender registerClass: [FSCalendarCell class] forCellReuseIdentifier: @"WorkoutStatsCell"];
    
    self.workoutStatsCalender.dataSource = self;
    self.workoutStatsCalender.delegate = self;
    
    self.workoutStatsCalender.backgroundColor = [UIColor whiteColor];
    self.workoutStatsCalender.appearance.headerMinimumDissolvedAlpha = 0;
    UIFont *fontDate = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
    [self.workoutStatsCalender.appearance setTitleFont: fontDate];
    [self.workoutStatsCalender setHeaderHeight: 0.0];
    
    [self.workoutStatsCalender setFirstWeekday: 2];
    [self.workoutStatsCalender setAllowsSelection: YES];
    [self.workoutStatsCalender setAllowsMultipleSelection: NO];
    [[self.workoutStatsCalender calendarWeekdayView] setHidden: YES];
    self.workoutStatsCalender.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase;
    self.workoutStatsCalender.placeholderType = FSCalendarPlaceholderTypeNone;
    [self.workoutStatsCalender setScope: FSCalendarScopeMonth animated: NO];
    [self.workoutStatsCalender setScrollEnabled:YES];
    
    [self.workoutStatsCalender.appearance setTodayColor: UIColor.whiteColor];
    [[self.workoutStatsCalender appearance] setTitleTodayColor: UIColor.blackColor];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *currentDate = [formatter dateFromString: @"2019-08-01"];
    [self.workoutStatsCalender setCurrentPage: currentDate];
    
    [self.workoutCalendar addSubview: self.workoutStatsCalender];
    
    NSDate *currentMonth = self.workoutStatsCalender.currentPage;
    [self updateMonthYearLabelWithDate: currentMonth];
}

- (void)updateMonthYearLabelWithDate: (NSDate *) dateObj {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM"];
    NSString *monthString = [dateFormatter stringFromDate: dateObj];
    [self.lblMonthName setText: [NSString stringWithFormat: @"%@", monthString]];
}

- (void)initializeSingleDayWorkoutViewData:(NSMutableDictionary *)workoutDetails {
    
    NSArray *dateComponents = [[[[workoutDetails valueForKey: @"date"] componentsSeparatedByString: @" "] objectAtIndex: 0] componentsSeparatedByString: @"-"];
    NSString *dateString = [dateComponents objectAtIndex: 2];
    NSString *monthString = [arrShortMonthsName objectAtIndex: [[dateComponents objectAtIndex: 1] intValue]];
    NSString *yearString = [dateComponents objectAtIndex: 0];
    
    NSArray *timeComponents = [[[[workoutDetails valueForKey: @"workout_start_time"] componentsSeparatedByString: @" "] objectAtIndex: 1] componentsSeparatedByString: @":"];
    NSString *hourString = [timeComponents objectAtIndex: 0];
    NSString *minuteString = [timeComponents objectAtIndex: 1];
    
    [self.lblDate setText:[NSString stringWithFormat: @"%@. %@ %@, %@:%@", dateString, monthString, yearString, hourString, minuteString]];
    
    NSString *strTotalTime = [workoutDetails valueForKey: @"exercise_time"];
    NSArray *arrTimeComponents = [strTotalTime componentsSeparatedByString: @":"];
    int hours = [arrTimeComponents[0] intValue];
    int minutes = [arrTimeComponents[1] intValue];
    int seconds = [arrTimeComponents[2] intValue];
    NSString *strTotalExercise = [workoutDetails valueForKey: @"total_exercise"];
    int exerciseCount = [strTotalExercise intValue];
    
    CGFloat animationDuation = 0.5;
    
    [self.lblExerciseDone countFrom:0 to:exerciseCount withDuration:animationDuation];
    [self.lblSingleDayHour countFrom: 0 to: hours withDuration: animationDuation];
    [self.lblSingleDayMin countFrom: 0 to: minutes withDuration: animationDuation];
    [self.lblSingleDaySec countFrom: 0 to: seconds withDuration: animationDuation];
}

- (void)progressAnimationWithWorkoutQuality:(int)workoutQuality {
    
    if (workoutQuality > 100) {
        workoutQuality = 100;
    }
    // Set Animation duration according to workout quality
    float totalAnimateDuration = 0.0;
    if (workoutQuality >= 1 && workoutQuality <= 14) {
        totalAnimateDuration = 0.8;
    } else if (workoutQuality >= 14 && workoutQuality <= 30) {
        totalAnimateDuration = 1.2;
    } else if (workoutQuality >= 30 && workoutQuality <= 60) {
        totalAnimateDuration = 1.8;
    } else if (workoutQuality >= 60 && workoutQuality <= 100 ) {
        totalAnimateDuration = 2.7;
    }
    
    // Divide animation duration into 3 separate duration
    float animateFirst = 25.0 * totalAnimateDuration / 100;
    float animateSecond = 30.0 * totalAnimateDuration / 100;
    float animateThird = 50.0 * totalAnimateDuration / 100;
    
    // Divide workout quality into 2 separate value
    float valueFirst = 50.0 * workoutQuality / 100.0;
    float valueSecond = 30.0 * workoutQuality / 100.0;
    
    // Animation for workout quality progress
    
    if (!isBackClicked) {
        
        [UIView animateWithDuration:animateFirst delay:0.3 options:UIViewAnimationOptionCurveLinear animations:^{
            if (!self->isBackClicked) {
                self.vwQuality.value = valueFirst;
            } else {
                [UIView performWithoutAnimation:^{
                    self.vwQuality.value = 0.0;
                }];
            }
            
        } completion:^(BOOL finished) {
            if (!self->isBackClicked) {
                [UIView animateWithDuration:animateSecond delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                    if (!self->isBackClicked) {
                        self.vwQuality.value = valueFirst + valueSecond;
                    } else {
                        [UIView performWithoutAnimation:^{
                            self.vwQuality.value = 0.0;
                        }];
                    }
                    
                } completion:^(BOOL finished) {
                    if (!self->isBackClicked) {
                        
                        // Spring animation effect if workout quality reach at 100
                        if (workoutQuality == 100) {
                            float delayedTime = animateThird - 0.6;
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayedTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                if (!self->isBackClicked) {
                                    [self springAnimation];
                                }
                            });
                        }
                        
                        [UIView animateWithDuration:animateThird delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                            if (!self->isBackClicked) {
                                self.vwQuality.value = workoutQuality;
                            } else {
                                [UIView performWithoutAnimation:^{
                                    self.vwQuality.value = 0.0;
                                }];
                            }
                        } completion:^(BOOL finished) {
                            if (!self->isBackClicked) {
                                if (workoutQuality == 100) {
                                    // Vibration
                                    AudioServicesPlaySystemSoundWithCompletion(1520, nil);
                                }
                            } else {
                                [UIView performWithoutAnimation:^{
                                    self.vwQuality.value = 0.0;
                                }];
                            }
                            
                        }];
                    } else {
                        [UIView performWithoutAnimation:^{
                            self.vwQuality.value = 0.0;
                        }];
                    }
                    
                }];
            } else {
                [UIView performWithoutAnimation:^{
                    self.vwQuality.value = 0.0;
                }];
            }
            
        }];
    } else {
        [UIView performWithoutAnimation:^{
            self.vwQuality.value = 0.0;
        }];
    }
}

- (void)springAnimation {
    
    if (!self->isBackClicked) {
        
        [self.vwQuality setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
        
        [UIView animateWithDuration:0.27 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            if (!self->isBackClicked) {
                [self.vwQuality setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
            } else {
                [UIView performWithoutAnimation:^{
                    [self.vwQuality setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
                    self.vwQuality.value = 0.0;
                }];
            }
            
        } completion:^(BOOL finished) {
            
            if (!self->isBackClicked) {
                [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:5.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    if (!self->isBackClicked) {
                        [self.vwQuality setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
                        [self layoutIfNeeded];
                    } else {
                        [UIView performWithoutAnimation:^{
                            [self.vwQuality setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
                            self.vwQuality.value = 0.0;
                        }];
                    }
                    
                } completion:^(BOOL finished) {
                    [self.vwQuality setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
                    [self layoutIfNeeded];
                }];
            } else {
                [UIView performWithoutAnimation:^{
                    [self.vwQuality setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
                    self.vwQuality.value = 0.0;
                }];
            }
            
        }];
        
    } else {
        [UIView performWithoutAnimation:^{
            [self.vwQuality setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
            self.vwQuality.value = 0.0;
        }];
    }
}

- (void)popAnimation:(FSCalendarCell *)cell {
    NSDate *date = [_workoutStatsCalender dateForCell:cell];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat: @"dd"];
    NSString *dayString = [formatter stringFromDate: date];
    [formatter setDateFormat: @"yyyy-MM-dd"];
    
    //Dont show any green mark after August Month
    [formatter setLocale:[NSLocale currentLocale]];
    NSDate *augustDate = [formatter dateFromString:@"2019-08-31"];
    NSComparisonResult result = [augustDate compare:date];
    
    if (result == NSOrderedAscending || result == NSOrderedSame) {
    } else {
        if ([arrSelectedDates containsObject:dayString]) {
            [cell.shapeLayer setFillColor: cSTART_BUTTON.CGColor];
            [cell.titleLabel setTextColor: UIColor.whiteColor];
            
            POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
            sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
            sprintAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.7, 0.7)];
            sprintAnimation.springBounciness = 20.f;
            [cell pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
        } else {
        }
    }
}

- (void)reloadCalendar {
    [self.workoutStatsCalender reloadData];
}

// MARK:- IBActions

- (IBAction)backAction:(UIButton *)sender {
    isBackClicked = YES;
    
    [self.vwQuality setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    self.vwQuality.value = 0.0;
    
    self.vwWorkoutShadow.alpha = 0.0;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.vwCalendarShadow.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}

// MARK:- FSCalendar Delegate & Datasource

- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position {
    
    FSCalendarCell *cell = [calendar dequeueReusableCellWithIdentifier: @"WorkoutStatsCell" forDate: date atMonthPosition: position];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"dd"];
    
    NSString *dayString = [formatter stringFromDate: date];
    [formatter setDateFormat: @"yyyy-MM-dd"];
    
    NSString *dateString = [formatter stringFromDate: date];
    
    // Dont show any green mark after August Month
    [formatter setLocale:[NSLocale currentLocale]];
    NSDate *augustDate = [formatter dateFromString:@"2019-08-31"];
    NSComparisonResult result = [augustDate compare:date];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self->cellBlackBorder.path = [UIBezierPath bezierPathWithRoundedRect:cell.shapeLayer.frame cornerRadius:cell.shapeLayer.bounds.size.height / 2].CGPath;
    });
        
    if (result == NSOrderedAscending) {
        // Date is greater than August Month
        UIFont *fontCurrentDate = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [[calendar appearance] setTitleFont: fontCurrentDate];
        [cell.titleLabel setTextColor: UIColor.blackColor];
        [cell.shapeLayer setFillColor: UIColor.whiteColor.CGColor];
        
    } else {
        if ([arrSelectedDates containsObject: dayString]) {
            UIFont *fontCurrentDate = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
            [[calendar appearance] setTitleFont: fontCurrentDate];
            [cell.titleLabel setTextColor: UIColor.whiteColor];
            [cell.shapeLayer setFillColor: cSTART_BUTTON.CGColor];
            
        } else if ([dateString isEqualToString: @"2019-08-28"]) {
            if ([[cell pop_animationKeys] containsObject:@"springAnimation"]) {
                [cell pop_removeAnimationForKey:@"springAnimation"];
            }
            
            [cellBlackBorder removeFromSuperlayer];
            [cell.layer addSublayer:cellBlackBorder];
            
            UIFont *fontCurrentDate = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
            [[calendar appearance] setTitleFont: fontCurrentDate];
            [cell.titleLabel setTextColor: UIColor.blackColor];
            [cell.shapeLayer setFillColor: UIColor.whiteColor.CGColor];
        } else {
            if ([[cell pop_animationKeys] containsObject:@"springAnimation"]) {
                [cell pop_removeAnimationForKey:@"springAnimation"];
            }
            
            UIFont *fontCurrentDate = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
            [[calendar appearance] setTitleFont: fontCurrentDate];
            [cell.titleLabel setTextColor: UIColor.blackColor];
            [cell.shapeLayer setFillColor: UIColor.whiteColor.CGColor];
        }
    }
    
    return cell;
}

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    
    FSCalendarCell *diyCell = (FSCalendarCell *)cell;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat: @"dd"];
    NSString *dayString = [formatter stringFromDate: date];
    [formatter setDateFormat: @"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate: date];
    
    //Dont show any green mark after August Month
    [formatter setLocale:[NSLocale currentLocale]];
    NSDate *augustDate = [formatter dateFromString:@"2019-08-31"];
    NSComparisonResult result = [augustDate compare:date];
    
    if (result == NSOrderedAscending) {
        if ([[cell pop_animationKeys] containsObject:@"springAnimation"]) {
            [cell pop_removeAnimationForKey:@"springAnimation"];
        }
        
        if ([[cell.layer sublayers] containsObject:cellBlackBorder]) {
            for (CALayer *layer in cell.layer.sublayers) {
                if ([layer isKindOfClass:[cellBlackBorder class]]) {
                    [layer removeFromSuperlayer];
                }
            }
        }
        
        UIFont *fontCurrentDate = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [[calendar appearance] setTitleFont: fontCurrentDate];
        [diyCell.titleLabel setTextColor: UIColor.blackColor];
        [diyCell.shapeLayer setFillColor: UIColor.whiteColor.CGColor];
        
    } else {
        
        if ([arrSelectedDates containsObject: dayString]) {
            if ([[cell.layer sublayers] containsObject:cellBlackBorder]) {
                for (CALayer *layer in cell.layer.sublayers) {
                    if ([layer isKindOfClass:[cellBlackBorder class]]) {
                        [layer removeFromSuperlayer];
                    }
                }
            }
            
            UIFont *fontCurrentDate = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
            [[calendar appearance] setTitleFont: fontCurrentDate];
            [diyCell.titleLabel setTextColor: UIColor.blackColor];
            
            //Cell Animation
            [self performSelector:@selector(popAnimation:) withObject:cell afterDelay:0.5];
            
        } else if ([dateString isEqualToString:@"2019-08-28"]) {
            
            UIFont *fontCurrentDate = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
            [[calendar appearance] setTitleFont: fontCurrentDate];
            [diyCell.titleLabel setTextColor: UIColor.blackColor];
            [diyCell.shapeLayer setFillColor: UIColor.whiteColor.CGColor];
            
        } else {
            if ([[cell pop_animationKeys] containsObject:@"springAnimation"]) {
                [cell pop_removeAnimationForKey:@"springAnimation"];
            }
            
            if ([[cell.layer sublayers] containsObject:cellBlackBorder]) {
                for (CALayer *layer in cell.layer.sublayers) {
                    if ([layer isKindOfClass:[cellBlackBorder class]]) {
                        [layer removeFromSuperlayer];
                    }
                }
            }
            
            UIFont *fontCurrentDate = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
            [[calendar appearance] setTitleFont: fontCurrentDate];
            [diyCell.titleLabel setTextColor: UIColor.blackColor];
            [diyCell.shapeLayer setFillColor: UIColor.whiteColor.CGColor];
        }
    }
    
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    NSDate *currentMonth = self.workoutStatsCalender.currentPage;
    
    [self.workoutStatsCalender setCurrentPage: currentMonth animated:YES];
    
    [self updateMonthYearLabelWithDate: currentMonth];
}

@end
