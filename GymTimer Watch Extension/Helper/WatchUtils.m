//
//  WatchUtils.m
//  GymTimer Watch Extension
//
//  Created by EbitNHP-i1 on 17/01/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

#import "WatchUtils.h"
#import "Common.h"

@implementation WatchUtils 

// MARK:-

+ (NSMutableAttributedString *)getAttributedString:(NSString *)string withFontSize:(CGFloat)size andFontName:(NSString *)name {
    NSDictionary *attributes = [[NSDictionary alloc] init];
    
    if ([name caseInsensitiveCompare:@"system"] == NSOrderedSame) {
        attributes = @{
            NSFontAttributeName: [UIFont systemFontOfSize:size weight:UIFontWeightBold]
        };
    } else {
        attributes = @{
            NSFontAttributeName: [UIFont fontWithName:name size:size]
        };
    }
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    return [attributedText initWithString:string attributes:attributes];
}

+ (NSMutableAttributedString *)getAttributedString:(NSString *)string withFontSize:(CGFloat)size fontName:(NSString *)name color:(UIColor *)color {
    
    NSDictionary *attributes = @{
        NSFontAttributeName: [UIFont fontWithName:name size:size],
        NSForegroundColorAttributeName: color
    };
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    return [attributedText initWithString:string attributes:attributes];
}

+ (NSString *)timeStringForSeconds:(int)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    if (totalSeconds >= 3600) {
        int hours = totalSeconds / 3600;
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    } else {
        return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
}

+ (NSString *)hourlyFormatFromSeconds:(int)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

+ (int)secondsForTimeString:(NSString *)string {

    NSArray *components = [string componentsSeparatedByString:@":"];
    NSInteger hours = 0;
    NSInteger minutes = 0;
    NSInteger seconds = 0;
    
    if (components.count == 1) {
        seconds = [[components objectAtIndex:0] integerValue];
    }
    
    if (components.count == 2) {
        minutes = [[components objectAtIndex:0] integerValue];
        seconds = [[components objectAtIndex:1] integerValue];
    }
    
    if (components.count == 3) {
        hours = [[components objectAtIndex:0] integerValue];
        minutes = [[components objectAtIndex:1] integerValue];
        seconds = [[components objectAtIndex:2] integerValue];
    }
    
    return (hours * 60 * 60) + (minutes * 60) + seconds;
}

// MARK:- 

+ (void)setWorkoutSelectedTime:(NSString *)time {
    [[NSUserDefaults standardUserDefaults] setValue:time forKey:uWORKOUT_SELETED_TIME];
}

+ (NSString *)getWorkoutSelectedTime {
    if ([NSUserDefaults.standardUserDefaults.dictionaryRepresentation.allKeys containsObject:uWORKOUT_SELETED_TIME]) {
        return [[NSUserDefaults standardUserDefaults] valueForKey:uWORKOUT_SELETED_TIME];
    } else {
        return @"00:00";
    }
}

+ (void)setExerciseCount:(NSString *)exercise {
    [[NSUserDefaults standardUserDefaults] setValue:exercise forKey:uEXERCISE_COUNT];
}

+ (NSString *)getExerciseCount {
    if ([NSUserDefaults.standardUserDefaults.dictionaryRepresentation.allKeys containsObject:uEXERCISE_COUNT]) {
        return [[NSUserDefaults standardUserDefaults] valueForKey:uEXERCISE_COUNT];
    } else {
        return @"1";
    }
}

+ (void)setExerciseSetCount:(NSString *)exercise {
    [[NSUserDefaults standardUserDefaults] setValue:exercise forKey:uEXERCISE_SET_COUNT];
}

+ (NSString *)getExerciseSetCount {
    if ([NSUserDefaults.standardUserDefaults.dictionaryRepresentation.allKeys containsObject:uEXERCISE_SET_COUNT]) {
        return [[NSUserDefaults standardUserDefaults] valueForKey:uEXERCISE_SET_COUNT];
    } else {
        return @"0";
    }
}

+ (void)setExerciseTotalTime:(NSString *)exercise {
    [[NSUserDefaults standardUserDefaults] setValue:exercise forKey:uEXERCISE_TOTAL_TIME];
}

+ (NSString *)getExerciseTotalTime {
    if ([NSUserDefaults.standardUserDefaults.dictionaryRepresentation.allKeys containsObject:uEXERCISE_TOTAL_TIME]) {
        return [[NSUserDefaults standardUserDefaults] valueForKey:uEXERCISE_TOTAL_TIME];
    } else {
        return @"00:00:00";
    }
}

+ (BOOL)isHomeTutorialDisplayed {
    if ([NSUserDefaults.standardUserDefaults.dictionaryRepresentation.allKeys containsObject:uHOME_TUTORIAL]) {
        return [[NSUserDefaults standardUserDefaults] valueForKey:uHOME_TUTORIAL];
    } else {
        return NO;
    }
}

+ (void)setHomeTutorialDisplayed:(BOOL)value {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:uHOME_TUTORIAL];
}

+ (BOOL)isSetTutorialDisplayed {
    if ([NSUserDefaults.standardUserDefaults.dictionaryRepresentation.allKeys containsObject:uSET_TUTORIAL]) {
        return [[NSUserDefaults standardUserDefaults] valueForKey:uSET_TUTORIAL];
    } else {
        return NO;
    }
}

+ (void)setSetTutorialDisplayed:(BOOL)value {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:uSET_TUTORIAL];
}

+ (NSString *)isSoundOn {
    if ([NSUserDefaults.standardUserDefaults.dictionaryRepresentation.allKeys containsObject:uSET_SOUND_STATUS]) {
        return [[NSUserDefaults standardUserDefaults] valueForKey:uSET_SOUND_STATUS];
    } else {
        return @"NO";
    }
}

+ (void)setSoundStatus:(NSString *)value {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:uSET_SOUND_STATUS];
}

+ (void)setExerciseStartTime:(NSString *)time {
    [[NSUserDefaults standardUserDefaults] setValue:time forKey:uEXERCISE_START_TIME];
}

+ (NSString *)getExerciseStartTime {
    if ([NSUserDefaults.standardUserDefaults.dictionaryRepresentation.allKeys containsObject:uEXERCISE_START_TIME]) {
        return [[NSUserDefaults standardUserDefaults] valueForKey:uEXERCISE_START_TIME];
    } else {
        return @"00:00:00";
    }
}

+ (void)setRestAndExerciseCount:(NSString *)count {
    [[NSUserDefaults standardUserDefaults] setValue:count forKey:uSET_AND_EXERCISE_COUNT];
}

+ (NSString *)getRestAndExerciseCount {
    if ([NSUserDefaults.standardUserDefaults.dictionaryRepresentation.allKeys containsObject:uSET_AND_EXERCISE_COUNT]) {
        return [[NSUserDefaults standardUserDefaults] valueForKey:uSET_AND_EXERCISE_COUNT];
    } else {
        return @"0";
    }
}
@end
