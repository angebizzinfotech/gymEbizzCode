//
//  WatchUtils.h
//  GymTimer Watch Extension
//
//  Created by EbitNHP-i1 on 17/01/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WatchUtils : NSObject

+ (NSAttributedString *)getAttributedString:(NSString *)string withFontSize:(CGFloat)size andFontName:(NSString *)name;

+ (NSMutableAttributedString *)getAttributedString:(NSString *)string withFontSize:(CGFloat)size fontName:(NSString *)name color:(UIColor *)color;

+ (NSString *)timeStringForSeconds:(int)totalSeconds;

+ (int)secondsForTimeString:(NSString *)string;

+ (NSString *)hourlyFormatFromSeconds:(int)totalSeconds;

+ (void)setWorkoutSelectedTime:(NSString *)time;
+ (NSString *)getWorkoutSelectedTime;

+ (void)setExerciseCount:(NSString *)exercise;
+ (NSString *)getExerciseCount;

+ (void)setExerciseSetCount:(NSString *)exercise;
+ (NSString *)getExerciseSetCount;

+ (void)setExerciseTotalTime:(NSString *)exercise;
+ (NSString *)getExerciseTotalTime;

+ (BOOL)isHomeTutorialDisplayed;
+ (void)setHomeTutorialDisplayed:(BOOL)value;

+ (BOOL)isSetTutorialDisplayed;
+ (void)setSetTutorialDisplayed:(BOOL)value;

+ (NSString *)isSoundOn;
+ (void)setSoundStatus:(NSString *)value;

+ (void)setExerciseStartTime:(NSString *)time;
+ (NSString *)getExerciseStartTime;

+ (void)setRestAndExerciseCount:(NSString *)count;
+ (NSString *)getRestAndExerciseCount;

@end

NS_ASSUME_NONNULL_END
