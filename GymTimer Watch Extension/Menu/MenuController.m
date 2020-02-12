//
//  MenuController.m
//  GymTimer Watch Extension
//
//  Created by EbitNHP-i1 on 21/01/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

#import "MenuController.h"
#import "Common.h"

@interface MenuController ()

@end

@implementation MenuController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    [self setupLayout];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [[self btnChangeRest] setAttributedTitle:[WatchUtils getAttributedString:[WatchUtils getWorkoutSelectedTime] withFontSize:15 fontName:fFUTURA_MEDIUM color:[UIColor whiteColor]]];
    
    if ([[WatchUtils isSoundOn] isEqualToString:@"YES"]) {
        [self.imgSound setImageNamed:@"Sound_On"];
        [self.imgSound setAlpha: 1];
        [[self lblSoundTitle] setAttributedText:[WatchUtils getAttributedString:@"Sound: on" withFontSize:9 fontName:fFUTURA_MEDIUM color:[UIColor whiteColor]]];
    } else {
        [self.imgSound setImageNamed:@"Sound_Off"];
        [self.imgSound setAlpha: 0.7];
        [[self lblSoundTitle] setAttributedText:[WatchUtils getAttributedString:@"Sound: off" withFontSize:9 fontName:fFUTURA_MEDIUM color:[UIColor whiteColor]]];
    }
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

// MARK:- Custom Methods

- (void)setupLayout {
    // Set screen setup
    [[self lblNextExerciseTitle] setAttributedText:[WatchUtils getAttributedString:@"Next exercise" withFontSize:9 fontName:fFUTURA_MEDIUM color:[UIColor whiteColor]]];
    
    [[self lblChangeRestTitle] setAttributedText:[WatchUtils getAttributedString:@"Change rest" withFontSize:9 fontName:fFUTURA_MEDIUM color:[UIColor whiteColor]]];
    
    [[self lblEndWorkoutTitle] setAttributedText:[WatchUtils getAttributedString:@"End workout" withFontSize:9 fontName:fFUTURA_MEDIUM color:[UIColor whiteColor]]];
}

// MARK:- IBAction

- (IBAction)nextExerciseAction {
    // Vibration
    [WKInterfaceDevice.currentDevice playHaptic:WKHapticTypeClick];
    
    // Rest set count
    [WatchUtils setExerciseSetCount:@"1"];
    
    // Increase rest and exercise count by 1
    int restCount = [[WatchUtils getRestAndExerciseCount] intValue];
    restCount = restCount + 1;
    [WatchUtils setRestAndExerciseCount:[NSString stringWithFormat:@"%d",restCount]];
    
    // Increase total exercise count by 1
    int exerciseCount = [[WatchUtils getExerciseCount] intValue];
    exerciseCount = exerciseCount + 1;
    [WatchUtils setExerciseCount:[NSString stringWithFormat:@"%d",exerciseCount]];
    
    // Observer for change current page
    [[NSNotificationCenter defaultCenter] postNotificationName:nCHANGE_PAGE object:nil];
    
    // Observer for stop rest
    [[NSNotificationCenter defaultCenter] postNotificationName:nSTOP_REST object:nil];
}

- (IBAction)changeRestAction {
    // Vibration
    [WKInterfaceDevice.currentDevice playHaptic:WKHapticTypeClick];
    
    NSString *context = @"ForChangeRest";
    [self pushControllerWithName:@"HomeController" context:context];
}

- (IBAction)soundAction {
    // Vibration
    [WKInterfaceDevice.currentDevice playHaptic:WKHapticTypeClick];
    
    if ([[WatchUtils isSoundOn] isEqualToString:@"YES"]) {
        [self.imgSound setImageNamed:@"Sound_Off"];
        [self.imgSound setAlpha: 0.7];
        [WatchUtils setSoundStatus:@"NO"];
        [[self lblSoundTitle] setAttributedText:[WatchUtils getAttributedString:@"Sound: off" withFontSize:9 fontName:fFUTURA_MEDIUM color:[UIColor whiteColor]]];
    } else {
        [self.imgSound setImageNamed:@"Sound_On"];
        [self.imgSound setAlpha: 1];
        [WatchUtils setSoundStatus:@"YES"];
        [[self lblSoundTitle] setAttributedText:[WatchUtils getAttributedString:@"Sound: on" withFontSize:9 fontName:fFUTURA_MEDIUM color:[UIColor whiteColor]]];
    }
}

- (IBAction)endWorkoutAction {
    // Vibration
    [WKInterfaceDevice.currentDevice playHaptic:WKHapticTypeClick];
    
    [WatchUtils setWorkoutSelectedTime:@"00:00"];
    
    [[WatchManager sharedInstance] stopExerciseTimer];
    [[WatchManager sharedInstance] stopRestTimer];
    
    [self pushControllerWithName:@"WorkoutCompleteController" context:nil];
}

@end
