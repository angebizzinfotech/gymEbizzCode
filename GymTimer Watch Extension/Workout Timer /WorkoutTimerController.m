//
//  WorkoutTimerController.m
//  GymTimer Watch Extension
//
//  Created by EbitNHP-i1 on 18/01/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

#import "WorkoutTimerController.h"
#import "Common.h"

@interface WorkoutTimerController () <ExerciseTimeDelegate> {
    CGFloat exerciseSize;
}

@end

@implementation WorkoutTimerController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Set Font Size
    [self setFontSize];
    
    // Configure interface objects here.
    [self setupLayout];

    [[WatchManager sharedInstance] setExerciseDelegate:self];
    
    // Remove existing observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Observer for page navigation
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCurrentPage) name:nSET_CURRENT_PAGE object:nil];
    
    // Observer for change screen color
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeColor) name:nCHANGE_COLOR object:nil];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    // Change color
    [self changeColor];
    
    // Set Exercise Count
    NSString *exerciseText = [NSString stringWithFormat:@" %@.", [WatchUtils getExerciseCount]];
    [[self lblExercise] setAttributedText:[WatchUtils getAttributedString:exerciseText withFontSize:exerciseSize andFontName:fFUTURA_CONDENSED_EXTRA_BOLD]];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

// MARK:- Custom Methods

- (void)setFontSize {
    // Default Size
    exerciseSize = 40;
    
    // Size According To Watch Size
    if (IS_38MM) {
        
    } else if (IS_40MM) {
        
    } else if (IS_42MM) {
        exerciseSize = 44;
    } else if (IS_44MM) {
        exerciseSize = 44;
    }
}

- (void)setupLayout {
    [[self lblExerciseTitle] setAttributedText:[WatchUtils getAttributedString:@"exercise" withFontSize:15 andFontName:fFUTURA_MEDIUM]];
    
    [[self lblTotalTime] setAttributedText:[WatchUtils getAttributedString:@"00:00" withFontSize:38 andFontName:fFUTURA_CONDENSED_EXTRA_BOLD]];
    [[self lblTotalTimeMin] setAttributedText:[WatchUtils getAttributedString:@"00" withFontSize:36 andFontName:fFUTURA_CONDENSED_EXTRA_BOLD]];
    [[self lblTotalTimeDot] setAttributedText:[WatchUtils getAttributedString:@":" withFontSize:36 andFontName:fFUTURA_CONDENSED_EXTRA_BOLD]];
    [[self lblTotalTimeSec] setAttributedText:[WatchUtils getAttributedString:@"00" withFontSize:36 andFontName:fFUTURA_CONDENSED_EXTRA_BOLD]];
    
    [[self lblTotalTimeTitle] setAttributedText:[WatchUtils getAttributedString:@"total time" withFontSize:15 andFontName:fFUTURA_MEDIUM]];
}

- (void)changeColor {
    // Set Red color if rest timer is running
    if ([[WatchManager sharedInstance] isRestTimerRunning]) {
        [self.exerciseGroup setBackgroundColor:cREST_COLOR];
        [self.totalTimeGroup setBackgroundColor:cREST_COLOR];
        [self.lblExerciseTitle setTextColor:cREST_TEXT_COLOR];
        [self.lblTotalTimeTitle setTextColor:cREST_TEXT_COLOR];
        
    } else {
        [self animateWithDuration:0.3 animations:^{
            [self.exerciseGroup setBackgroundColor:cGREEN];
            [self.totalTimeGroup setBackgroundColor:cGREEN];
            [self.lblExerciseTitle setTextColor:cSET_TEXT_COLOR];
            [self.lblTotalTimeTitle setTextColor:cSET_TEXT_COLOR];
        }];
    }
}

- (void)changeCurrentPage {
    [self becomeCurrentPage];
}

// MARK:- ExerciseTime Delegate

- (void)totalExerciseTime:(int)time {
    [[self lblTotalTime] setAttributedText:[WatchUtils getAttributedString:[WatchUtils timeStringForSeconds:time] withFontSize:38 andFontName:fFUTURA_CONDENSED_EXTRA_BOLD]];
    
    NSArray *timer = [[WatchUtils timeStringForSeconds:time] componentsSeparatedByString: @":"];
    [[self lblTotalTimeMin] setAttributedText:[WatchUtils getAttributedString:timer[timer.count-2] withFontSize:36 andFontName:fFUTURA_CONDENSED_EXTRA_BOLD]];
    [[self lblTotalTimeSec] setAttributedText:[WatchUtils getAttributedString:timer[timer.count-1] withFontSize:36 andFontName:fFUTURA_CONDENSED_EXTRA_BOLD]];
    
    [WatchUtils setExerciseTotalTime:[WatchUtils hourlyFormatFromSeconds:time]];
}

@end
