//
//  InterfaceController.m
//  GymTimer Watch Extension
//
//  Created by EbitNHP-i1 on 13/01/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

#import "InterfaceController.h"
#import "Common.h"

@interface InterfaceController () <WCSessionDelegate> {
    NSArray *arrSeconds, *arrMinutes;
    NSMutableArray *arrTime;
    NSString *strSelectedTime;
    BOOL isForChangeRest;
}

@end

@implementation InterfaceController

// MARK:-

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    if ([context isEqualToString:@"ForChangeRest"]) {
        isForChangeRest = YES;
    }
    
    arrSeconds = @[@"00", @"05", @"10", @"15", @"20", @"25", @"30", @"35", @"40", @"45", @"50", @"55"];
    arrMinutes = @[@"00", @"01", @"02", @"03", @"04", @"05"];
    strSelectedTime = @"00:00";
    
    arrTime = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrMinutes.count; i++) {
        for (int j = 0; j < arrSeconds.count; j++) {
            NSString *strTime = [NSString stringWithFormat:@"%@:%@",arrMinutes[i], arrSeconds[j]];
            [arrTime addObject:strTime];
        }
    }
    
    NSMutableArray *pickerItem = [[NSMutableArray alloc] init];
    for (NSString *string in arrTime) {
        WKPickerItem *item = [[WKPickerItem alloc] init];
        item.title = string;
        [pickerItem addObject:item];
    }
    
    [self.timePicker setItems:pickerItem];
    
    // Configure interface objects here.
    if ([WCSession isSupported]) {
        
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    
    // Setup Layout
    [self setupLayout];
    
    [self.timePicker focus];
    
    // Display tutorial after 1 second
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![WatchUtils isHomeTutorialDisplayed]) {
            [self.homeGroup setAlpha:0.0];
            [self animateWithDuration:0.3 animations:^{
                [self.tutorialGroup setAlpha:1.0];
            }];
            [WatchUtils setHomeTutorialDisplayed:YES];
        }
    });
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
    [[self lblMinTitle] setAttributedText:[WatchUtils getAttributedString:@"min" withFontSize:10 andFontName:fFUTURA_MEDIUM]];
    
    [[self lblSecTime] setAttributedText:[WatchUtils getAttributedString:@"sec" withFontSize:10 andFontName:fFUTURA_MEDIUM]];
    
    [[self lblChooseTime] setAttributedText:[WatchUtils getAttributedString:@"Choose a rest time" withFontSize:9 andFontName:@"System"]];
    
    [[self lblClickAnyWhereTitle] setAttributedText:[WatchUtils getAttributedString:@"(click anywhere to start workout)" withFontSize:7 andFontName:fFUTURA_MEDIUM]];
    
    [[self lblTime] setAttributedText:[WatchUtils getAttributedString:@"00:00" withFontSize:35 andFontName:fFUTURA_CONDENSED_EXTRA_BOLD]];
    NSLog(@"User Data: %@", [[NSUserDefaults standardUserDefaults] valueForKey:uWATCH_USER_DATA]);
}

// MARK:-

- (void)session:(nonnull WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(nullable NSError *)error {
}

- (void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *,id> *)applicationContext {

    if (applicationContext != nil) {
        NSLog(@"User Data Received : %@",applicationContext);
        [[NSUserDefaults standardUserDefaults] setValue:applicationContext forKey:uWATCH_USER_DATA];
        
        NSString *dataReceivedfromiPhone = @"Data received from iPhone";

         WKAlertAction *action = [WKAlertAction actionWithTitle:@"OK" style:WKAlertActionStyleDefault handler:^{}];

        NSString *title = @"Data Received";

        NSString *message = dataReceivedfromiPhone;

        [self presentAlertControllerWithTitle:title message:message preferredStyle:WKAlertControllerStyleAlert actions:@[ action ]];
    } else {
        
        NSLog(@"Login failed on iPhone App");
        
        WKAlertAction *action = [WKAlertAction actionWithTitle:@"OK" style:WKAlertActionStyleDefault handler:^{}];
        
        NSString *title = @"Oops!";
        
        NSString *message = @"iPhone App failed to login.";
        
        [self presentAlertControllerWithTitle:title message:message preferredStyle:WKAlertControllerStyleAlert actions:@[ action ]];
    }
    
}

// MARK:- IBAction

- (IBAction)exitTutorialAction {
    [self animateWithDuration:0.3 animations:^{
        [self.homeGroup setAlpha:1.0];
        [self.tutorialGroup setAlpha:0.0];
    }];

    [self.timePicker focus];
}

- (IBAction)timePicker:(NSInteger)value {
    strSelectedTime = arrTime[value];
    [[self lblTime] setAttributedText:[WatchUtils getAttributedString:arrTime[value] withFontSize:35 andFontName:fFUTURA_CONDENSED_EXTRA_BOLD]];
}

- (IBAction)startWorkoutAction {
    NSLog(@"%@", strSelectedTime);
        
    // Set selected workout time
    [WatchUtils setWorkoutSelectedTime:strSelectedTime];
    
    if (isForChangeRest) {
        // Stop Rest Timer 
        [[WatchManager sharedInstance] stopRestTimer];
        [self popController];
        
        // Observer for change page
        [[NSNotificationCenter defaultCenter] postNotificationName:nCHANGE_PAGE object:nil];
    } else {
                
        // DateFormatter For Workout Start Time
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        NSString *formattedDate = [dateFormatter stringFromDate: [NSDate date]];
        
        // Save Workout Start Time
        [WatchUtils setExerciseStartTime:formattedDate];
        [WatchUtils setExerciseCount:@"1"];
        
        // Start Workout Timer
        [[WatchManager sharedInstance] startExerciseTimer];
        
        // Display Pages
        [WKInterfaceController reloadRootPageControllersWithNames:@[@"MenuController", @"SetAndRestController", @"WorkoutTimerController"] contexts:@[] orientation:WKPageOrientationHorizontal pageIndex:1];
    }
}

@end
