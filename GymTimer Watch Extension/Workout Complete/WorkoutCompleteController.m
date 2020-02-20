//
//  WorkoutCompleteController.m
//  GymTimer Watch Extension
//
//  Created by EbitNHP-i1 on 17/01/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

#import "WorkoutCompleteController.h"
#import "Common.h"

@interface WorkoutCompleteController () <NSURLSessionDelegate, ServiceManagerDelegate> {
    CGFloat delayTime;
    int qualityText, workoutQuality;
    ServiceManager *serviceManager;
}

@end

@implementation WorkoutCompleteController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
//    [self.mainGrp setRelativeWidth:1 withAdjustment:0];
    [self.mainGrp setRelativeHeight:0 withAdjustment:0];
    [self animateWithDuration:0.5 animations:^{
//        [self.mainGrp setRelativeWidth:1 withAdjustment:0];
        [self.mainGrp setRelativeHeight:1 withAdjustment:0];
    }];
    
    // Configure interface objects here.
    [self.groupActivity setHidden:YES];
    [self.btnExit setEnabled:YES];
    
    [self setupLayout];
        
    [[self lblTotalTime] setAttributedText:[WatchUtils getAttributedString:[WatchUtils getExerciseTotalTime] withFontSize:35 andFontName:fFUTURA_CONDENSED_EXTRA_BOLD]];
    
    [[self lblExercises] setAttributedText:[WatchUtils getAttributedString:[WatchUtils getExerciseCount] withFontSize:55 andFontName:fFUTURA_CONDENSED_EXTRA_BOLD]];
    
    [self setTitle:@"Click to exit"];

    // Workout Quality
    [self calculateAndAnimateWorkoutQuality];
    
    // Init Service Manager
    serviceManager = [[ServiceManager alloc] init];
    [serviceManager setDelegate: self];
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
    [[self lblWorkoutComplete] setAttributedText:[WatchUtils getAttributedString:@"Workout complete !" withFontSize:13 andFontName:fFUTURA_CONDENSED_EXTRA_BOLD]];
    
    [[self lblTotalTimeTitle] setAttributedText:[WatchUtils getAttributedString:@"Total time" withFontSize:12 andFontName:fFUTURA_MEDIUM]];
    
    [[self lblExercisesTitle] setAttributedText:[WatchUtils getAttributedString:@"Exercises" withFontSize:11 andFontName:fFUTURA_MEDIUM]];
    
    [[self lblQualityTitle] setAttributedText:[WatchUtils getAttributedString:@"  Quality" withFontSize:11 andFontName:fFUTURA_MEDIUM]];
    
    // Quality Percentage
    NSAttributedString *quality = [WatchUtils getAttributedString:@"0" withFontSize:18 andFontName:fFUTURA_CONDENSED_EXTRA_BOLD];
    NSAttributedString *percentage = [WatchUtils getAttributedString:@"%" withFontSize:8 andFontName:fFUTURA_MEDIUM];
    NSMutableAttributedString *strQuality = [[NSMutableAttributedString alloc] initWithAttributedString:quality];
    [strQuality appendAttributedString:percentage];
    
    [[self lblQuality] setAttributedText:strQuality];
}

- (void)calculateAndAnimateWorkoutQuality {
    /*
     So every click on “rest”, or “next exercise” means +1 set
     - set 1-5 : 7% each
     - set 6-10 : 6% each
     - set 11-15 : 4% each
     - set 16-20 : 2% each
     - set 21-26 : 1% each
     - after set 26 = 100% reached
     */
    
    // Set workout quality data
    int setCount = [[WatchUtils getRestAndExerciseCount] intValue];
    
    workoutQuality = 0;
    
    // Workout quality calculation
    
    for (int i = 1; i <= setCount; i++) {
        if (i >= 1 && i <= 5) {
            workoutQuality = workoutQuality + 7;
            
        } else if (i >= 6 && i <= 10) {
            workoutQuality = workoutQuality + 6;
            
        } else if (i >= 11 && i <= 15) {
            workoutQuality = workoutQuality + 4;
            
        } else if (i >= 16 && i <= 20) {
            workoutQuality = workoutQuality + 2;
            
        } else if (i >= 21 && i <= 26) {
            workoutQuality = workoutQuality + 1;
            
        } else if (i >= 27) {
            workoutQuality = 100;
        }
        
        if (workoutQuality > 100) {
            workoutQuality = 100;
        }
    }

    // Set Animation duration according to workout quality
    float totalAnimateDuration = 0.0;
    if (workoutQuality >= 1 && workoutQuality <= 14) {
        totalAnimateDuration = 0.4;
    } else if (workoutQuality >= 14 && workoutQuality <= 30) {
        totalAnimateDuration = 0.8;
    } else if (workoutQuality >= 30 && workoutQuality <= 60) {
        totalAnimateDuration = 1.4;
    } else if (workoutQuality >= 60 && workoutQuality <= 100 ) {
        totalAnimateDuration = 2.2;
    }
    
    if (workoutQuality == 0) {
        [self.imgQuality setImageNamed:@"EmptyProgress"];
    } else {
        [self.imgQuality setImageNamed:@"Progress"];
        [self.imgQuality startAnimatingWithImagesInRange:NSMakeRange(0, workoutQuality) duration:totalAnimateDuration repeatCount:1];
    }
    
    delayTime = totalAnimateDuration / workoutQuality;
    qualityText = 0;
    [self changeQualityText];
}

- (void)changeQualityText {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
        // Set Attributed String
        NSAttributedString *quality = [WatchUtils getAttributedString:[NSString stringWithFormat:@"%d",self->qualityText] withFontSize:16 fontName:fFUTURA_CONDENSED_EXTRA_BOLD color:cGREEN];
        NSAttributedString *percentage = [WatchUtils getAttributedString:@"%" withFontSize:8 fontName:fFUTURA_MEDIUM color:cGREEN];
        NSMutableAttributedString *strQuality = [[NSMutableAttributedString alloc] initWithAttributedString:quality];
        [strQuality appendAttributedString:percentage];
        
        // Set Quality Percentage Text
        [[self lblQuality] setAttributedText:strQuality];
        
        if (self->qualityText < self->workoutQuality) {
            [self changeQualityText];
        }
        
        // Increase quality by 1
        self->qualityText = self->qualityText + 1;
    });
}

- (void)startActivityIndicator {
    [self.groupActivity setHidden:NO];
    [self.imgActivity setImageNamed:@"Activity"];
    [self.imgActivity startAnimatingWithImagesInRange:NSMakeRange(0, 10) duration:1.0 repeatCount:0];
}

- (void)resetValues {
    // Reset UserDefault Value
    [WatchUtils setExerciseCount:@"1"];
    [WatchUtils setExerciseSetCount:@"1"];
    [WatchUtils setExerciseTotalTime:@"00:00:00"];
    [WatchUtils setWorkoutSelectedTime:@"00:00"];
    [WatchUtils setSoundStatus:@"YES"];
    [WatchUtils setRestAndExerciseCount:@"0"];
}

// MARK:- API Calling

- (void)callSaveExerciseAPI {
    [self startActivityIndicator];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd hh:mm:ss"];
    NSString *currentDate = [dateFormatter stringFromDate: [NSDate date]];
    
    // Exercise Type 
    int restTime = [WatchUtils secondsForTimeString:[WatchUtils getWorkoutSelectedTime]];
    NSString *exerciseType = [[NSString alloc] init];
    if (restTime < 60) {
        exerciseType = @"Endurance";
    } else if (restTime >= 60 && restTime < 120) {
        exerciseType = @"Muscle";
    } else if (restTime >= 120 && restTime <= 599) {
        exerciseType = @"Strength";
    }
    
    NSDictionary *dicWorkoutsData = @{
        @"date" : currentDate,
        @"excercise_total_time" : [WatchUtils getExerciseTotalTime],
        @"total_exercise" : [WatchUtils getExerciseCount],
        @"exercise_type" : exerciseType,
        @"workout_start_time" : [WatchUtils getExerciseStartTime],
        @"workout_quality": [NSString stringWithFormat:@"%d",workoutQuality]
    };
    NSLog(@"Parameter: %@",dicWorkoutsData);
    
    // Convert dictionary into JSON String
    NSMutableArray *arrWorkoutsData = [[NSMutableArray alloc] init];
    [arrWorkoutsData addObject: dicWorkoutsData];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: arrWorkoutsData options: NSJSONWritingPrettyPrinted error: nil];
    NSString *jsonString = [[NSString alloc] initWithData: jsonData encoding: NSUTF8StringEncoding];
    
    NSString *userID = [[[NSUserDefaults standardUserDefaults] valueForKey:uWATCH_USER_DATA] valueForKey:@"id"];
    NSDictionary *dicParam = @{
        @"workout" : jsonString,
        @"user_id" : userID
    };
    
    NSString *webPath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uSAVE_EXERCISE];
    [serviceManager callWebServiceWithPOST: webPath withTag: uSAVE_EXERCISE paramsDic: dicParam];
    
    // Reset UserDefault Value
    [self resetValues];
}

- (void)parseSaveExerciseAPI:(id) response {
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    
    if ([[dicResponse valueForKey:@"status"] integerValue] == 1) {
        NSLog(@"%@",dicResponse);
    }
}

// MARK:- IBAction

- (IBAction)exitAction {
    // Disable Exit Button
    [self.btnExit setEnabled:NO];
    
    // Get Exercise Seconds
    int exerciseSeconds = [WatchUtils secondsForTimeString:[WatchUtils getExerciseTotalTime]];

    // Save exercise data in backend if workout greater than 5 min else not.
    if (exerciseSeconds > 300 && [[NSUserDefaults standardUserDefaults] valueForKey:uWATCH_USER_DATA]) {
        // API Calling
        [self callSaveExerciseAPI];
        
    } else {
        // Reset UserDefault Value
        [self resetValues];
        
        // Navigation
        dispatch_async(dispatch_get_main_queue(), ^{
            [WKInterfaceController reloadRootPageControllersWithNames:@[@"HomeController"] contexts:@[] orientation:WKPageOrientationHorizontal pageIndex:0];
        });
    }
    
}

// MARK:- ServiceManager Delegate

- (void)webServiceCallSuccess:(id)response forTag:(NSString *)tagname {
    if ([tagname isEqualToString: uSAVE_EXERCISE]) {
        [self parseSaveExerciseAPI:response];
    }
}

- (void)webServiceCallFailure:(NSError *)error forTag:(NSString *)tagname {
    [self.imgActivity stopAnimating];
    [self.groupActivity setHidden:YES];
    
    // Navigation
    dispatch_async(dispatch_get_main_queue(), ^{
        [WKInterfaceController reloadRootPageControllersWithNames:@[@"HomeController"] contexts:@[] orientation:WKPageOrientationHorizontal pageIndex:0];
    });
}

@end

