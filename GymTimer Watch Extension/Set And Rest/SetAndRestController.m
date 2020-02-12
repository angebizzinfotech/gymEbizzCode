//
//  SetAndRestController.m
//  GymTimer Watch Extension
//
//  Created by EbitNHP-i1 on 21/01/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

#import "SetAndRestController.h"
#import "Common.h"

#define SetAndRestFontSize 60

@interface SetAndRestController () <RestTimeDelegate, AVAudioPlayerDelegate> {
    int selectedTime;
    CGFloat doSetNoSize;
}

@end

@implementation SetAndRestController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Set Font Sizes
    [self setFontSize];
    
    // Configure interface objects here.
    [self setupLayout];
    
    // Remove existing observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Observer for stop rest
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopRest) name:nSTOP_REST object:nil];
    
    // Observer for change page
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCurrentPage) name:nCHANGE_PAGE object:nil];
    
    // Display Set Tutorial
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![WatchUtils isSetTutorialDisplayed]) {
            [self pushControllerWithName:@"TutorialController" context:@"FromWorkoutTimer"];
            [WatchUtils setSetTutorialDisplayed:YES];
        }
    });
    
    [self preparePlayer];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

// MARK:- Custom Methods

- (void)setupLayout {
    // Set screen setup
    [[self lblDoSetTitle] setAttributedText:[WatchUtils getAttributedString:@"Do set no." withFontSize:doSetNoSize andFontName:fFUTURA_CONDENSED_EXTRA_BOLD]];
    
    // Set Exercise Set Count
    [[self lblSetNo] setAttributedText:[WatchUtils getAttributedString:[WatchUtils getExerciseSetCount] withFontSize:100 andFontName:fFUTURA_CONDENSED_EXTRA_BOLD]];
    
    // Rest screen setup
    [[self lblRestMin] setAttributedText:[WatchUtils getAttributedString:@"00" withFontSize:SetAndRestFontSize andFontName:fFUTURA_CONDENSED_EXTRA_BOLD]];
    
    [[self lblRestMinTitle] setAttributedText:[WatchUtils getAttributedString:@"min" withFontSize:12 andFontName:fFUTURA_MEDIUM]];
    
    [[self lblRestSec] setAttributedText:[WatchUtils getAttributedString:@"00" withFontSize:SetAndRestFontSize andFontName:fFUTURA_CONDENSED_EXTRA_BOLD]];
    
    [[self lblRestSecTitle] setAttributedText:[WatchUtils getAttributedString:@"sec" withFontSize:12 andFontName:fFUTURA_MEDIUM]];
    
    [[self lblNextSet] setAttributedText:[WatchUtils getAttributedString:@"0" withFontSize:35 andFontName:fFUTURA_CONDENSED_EXTRA_BOLD]];
    
    [[self lblNextSetTitle] setAttributedText:[WatchUtils getAttributedString:@"next set" withFontSize:12 andFontName:fFUTURA_MEDIUM]];
}

- (void)setFontSize {
    // Default Size
    doSetNoSize = 16;
    
    // Size According To Watch Size
    if (IS_38MM) {
        
    } else if (IS_40MM) {
        
    } else if (IS_42MM) {
        doSetNoSize = 24;
    } else if (IS_44MM) {
        doSetNoSize = 24;
    }
}

- (void)timeStringFromSeconds:(int)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;

    // Seconds
    [[self lblRestSec] setAttributedText:[WatchUtils getAttributedString:[NSString stringWithFormat:@"%02d", seconds] withFontSize:SetAndRestFontSize andFontName:fFUTURA_CONDENSED_EXTRA_BOLD]];
    // Minutes
    [[self lblRestMin] setAttributedText:[WatchUtils getAttributedString:[NSString stringWithFormat:@"%02d", minutes] withFontSize:SetAndRestFontSize andFontName:fFUTURA_CONDENSED_EXTRA_BOLD]];
}

- (void)stopRest {
    // Set time
    [[self lblSetNo] setAttributedText:[WatchUtils getAttributedString:[WatchUtils getExerciseSetCount] withFontSize:100 andFontName:fFUTURA_CONDENSED_EXTRA_BOLD]];
    
    // Show set group
    [self setTitle:@"Click to rest"];
    
    [self.setGroup setAlpha:1];
    [self.restGroup setAlpha:0];
    
    // Stop rest timer
    [[WatchManager sharedInstance] stopRestTimer];
}

- (void)preparePlayer {
    NSError *err;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback mode:AVAudioSessionModeDefault options: AVAudioSessionCategoryOptionMixWithOthers error: &err];
    [session setActive:YES error: &err];
    NSURL *assetURL = [[NSBundle mainBundle] URLForResource:@"BeepSound" withExtension:@"wav"];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:assetURL error: &err];
    [self.audioPlayer setDelegate: self];
    [self.audioPlayer prepareToPlay];
}

- (void)changeCurrentPage {
    [self becomeCurrentPage];
}

// MARK:- IBAction

- (IBAction)restAction {
    // Vibration
    [WKInterfaceDevice.currentDevice playHaptic:WKHapticTypeClick];
    
    // Start Rest Timer
    if ([WatchUtils secondsForTimeString:[WatchUtils getWorkoutSelectedTime]] != 0) {
        // Set selected rest time
        [self timeStringFromSeconds:[WatchUtils secondsForTimeString:[WatchUtils getWorkoutSelectedTime]]];
        
        // Increase rest and exercise count by 1
        int restCount = [[WatchUtils getRestAndExerciseCount] intValue];
        restCount = restCount + 1;
        [WatchUtils setRestAndExerciseCount:[NSString stringWithFormat:@"%d",restCount]];
        
        // Increase set count by 1
        int setCount = [[WatchUtils getExerciseSetCount] intValue];
        setCount = setCount + 1;
        [WatchUtils setExerciseSetCount:[NSString stringWithFormat:@"%d",setCount]];
        
        [[self lblNextSet] setAttributedText:[WatchUtils getAttributedString:[WatchUtils getExerciseSetCount] withFontSize:35 andFontName:fFUTURA_CONDENSED_EXTRA_BOLD]];
        
        // Show rest group
        [self.setGroup setAlpha:0];
        [self animateWithDuration:0.2 animations:^{
            [self.restGroup setAlpha:1];
        }];
        
        // Hide title
        [self setTitle:@""];
        
        // Start rest timer
        [[WatchManager sharedInstance] setRestDelegate:self];
        [[WatchManager sharedInstance] startRestTimer];
    }
}

// MARK:- RestTime Delegate

- (void)totalRestTime:(int)time {
    
    if (time <= 0) {
        // Set time
        [[self lblSetNo] setAttributedText:[WatchUtils getAttributedString:[WatchUtils getExerciseSetCount] withFontSize:100 andFontName:fFUTURA_CONDENSED_EXTRA_BOLD]];
        
        // Show set group
        [self setTitle:@"Click to rest"];
        
        [self animateWithDuration:0.2 animations:^{
            [self.setGroup setAlpha:1];
        }];
        [self.restGroup setAlpha:0];
        
        // Stop rest timer
        [[WatchManager sharedInstance] stopRestTimer];
    }
    
    // Play Sound
    if ([[WatchUtils isSoundOn] isEqualToString:@"YES"]) {
        int selectedTime = [WatchUtils secondsForTimeString:[WatchUtils getWorkoutSelectedTime]];
        if (selectedTime <= 10) {
            if (time == 3 || time == 2 || time == 1) {
                [self.audioPlayer play];
            }
        } else {
            if (time == 10 || time == 3 || time == 2 || time == 1) {
                [self.audioPlayer play];
            }
        }
    }
    
    // Set Rest Time
    [self timeStringFromSeconds:time];
}

// MARK:- AVAudioPlayer Delegate's

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"Sound Played");
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"Sound decode error");
}

@end
