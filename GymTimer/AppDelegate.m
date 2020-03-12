//
//  AppDelegate.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 16/04/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "AppDelegate.h"
#import "CommonImports.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@import StoreKit;
@import Firebase;


@interface AppDelegate () <UNUserNotificationCenterDelegate, ServiceManagerDelegate> {
    Utils *utils;
    WorkoutViewController *workoutVC;
    ServiceManager *serviceManager;
    UIView *customizedLaunchScreenView;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (IS_IPHONEXR) {
        
    } else if (IS_IPHONEX) {
        
    } else if (IS_IPHONE8PLUS) {
        
    } else if (IS_IPHONE8) {
        
    } else {
        
    }
    
    // Override point for customization after application launch.
//    application.statusBarHidden = true;

    // customized launch screen
    customizedLaunchScreenView = [[UIView alloc] initWithFrame: _window.bounds];
    customizedLaunchScreenView.backgroundColor = [UIColor redColor];
    [_window makeKeyAndVisible];
    [_window addSubview: customizedLaunchScreenView];
    [_window bringSubviewToFront: customizedLaunchScreenView];
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self->customizedLaunchScreenView.alpha = 0;
    } completion:^(BOOL finished) {
        [self->customizedLaunchScreenView removeFromSuperview];
    }];
    
    
    _isLoadScreen = true;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsAppInBackGround];
    
    workoutVC = [[WorkoutViewController alloc] init];
    serviceManager = [[ServiceManager alloc] init];
    [serviceManager setDelegate: self];
    
    [[IQKeyboardManager sharedManager] setEnable: NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar: NO];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(grantNotificationPermission:) name: nNOTIFICATION_PERMISSION object: nil];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    
    // start
//    UIViewController *onboardVC = [storyBoard instantiateViewControllerWithIdentifier: @"NewOnBoardingViewController"];
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: onboardVC];
//    [navController setNavigationBarHidden:YES];
//    [self.window setRootViewController: navController];
//    [self.window makeKeyAndVisible];
    // end
    ///// uncomment for single time onboard screen
    
    // For display onboarding to existing or logged user
    if (![NSUserDefaults.standardUserDefaults.dictionaryRepresentation.allKeys containsObject:kIS_SEEN_ONBOARDING]) {
        
        if ([NSUserDefaults.standardUserDefaults.dictionaryRepresentation.allKeys containsObject:kIS_FIRST_TIME] && [NSUserDefaults.standardUserDefaults.dictionaryRepresentation.allKeys containsObject:kIS_USER_LOGGED_IN]) {
            
            // Remove value from user default
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kIS_FIRST_TIME];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kIS_USER_LOGGED_IN];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUSER_WORKOUT_STATS];
            
            [Utils setIsPaidUser: @"NO"];
            
            [NSUserDefaults.standardUserDefaults setValue:@"YES" forKey:kIS_SEEN_ONBOARDING];
        }
    }
    
//    UIViewController *LoadingScreenVC = [storyBoard instantiateViewControllerWithIdentifier: @"LoadingScreenVC"];
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: LoadingScreenVC];
//    [navController setNavigationBarHidden:YES];
//    [self.window setRootViewController: navController];
//    [self.window makeKeyAndVisible];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey: kIS_FIRST_TIME] == nil) {

        //Temp
        [[NSUserDefaults standardUserDefaults] setValue: @"0" forKey: kIS_FIRST_TIME];
        [NSUserDefaults.standardUserDefaults setValue:@"YES" forKey:kIS_SEEN_ONBOARDING];

        UIViewController *onboardVC = [storyBoard instantiateViewControllerWithIdentifier: @"NewOnBoardingViewController"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: onboardVC];
        [navController setNavigationBarHidden:YES];
        [self.window setRootViewController: navController];
        [self.window makeKeyAndVisible];

    } else if ([[NSUserDefaults standardUserDefaults] valueForKey: kIS_USER_LOGGED_IN] == nil) {
        UIViewController *loginOptionVC = [storyBoard instantiateViewControllerWithIdentifier: @"LoginOptionViewController"];
//        UIViewController *loginOptionVC = [storyBoard instantiateViewControllerWithIdentifier: @"StatsVC"];

        [loginOptionVC.navigationController setNavigationBarHidden:YES];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: loginOptionVC];
        [self.window setRootViewController: navController];
        [self.window makeKeyAndVisible];

    } else {

        UIViewController *homeVC = [storyBoard instantiateViewControllerWithIdentifier: @"HomeScreenViewController"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: homeVC];
        [self.window setRootViewController: navController];
        [self.window makeKeyAndVisible];
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    application.applicationIconBadgeNumber = 0;
    
    //Set Status Bar colour
    [Utils setStatusBarBackgroundWithImage: @"Welcome screen"];
    
    //Set Total Exercise Count & Total Time
    //[[NSUserDefaults standardUserDefaults] setValue: @"00:00" forKey: kREST_TIME];
    [[NSUserDefaults standardUserDefaults] setValue: @"0" forKey: kTOTAL_EXERCISE_COUNT];
    [[NSUserDefaults standardUserDefaults] setValue: @"00:00:00" forKey: kTOTAL_TIME];
    [[NSUserDefaults standardUserDefaults] setValue: @"00:00:00" forKey: kLAST_EXERCISE_TIME];
    [[NSUserDefaults standardUserDefaults] setValue: @"00:00" forKey: kCURRENT_REST_TIME];
    [[NSUserDefaults standardUserDefaults] setValue: @"1" forKey: kSET_COUNT];
    [[NSUserDefaults standardUserDefaults] setValue: @"YES" forKey: @"isEndWOButtonClicked"];
    [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: kREST_TIMER_STATUS];
    [[NSUserDefaults standardUserDefaults] setValue: @"YES" forKey: kPLAY_SOUND];
    [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: kIS_NEXT_EXERCISE_BUTTON_CLICKED];
    [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: kIS_DEVICE_LOCKED];
    [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: kIS_FROM_LOCKED_DEVICE];
    [[NSUserDefaults standardUserDefaults] setValue: @"YES" forKey: kIS_SOUND_ON];
    
    // Check If user is Pro or Free
    if ([Utils isConnectedToInternet]) {
        [self checkInAppPurchaseStatusForUser];
    }
    
    // Store workout data
    [self saveWorkoutData];
    
    // Facebook Setup
    [[FBSDKApplicationDelegate sharedInstance] application:application
    didFinishLaunchingWithOptions:launchOptions];
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"ImgName"]];
    [UITabBar appearance].layer.borderWidth = 0.0f;
    [UITabBar appearance].clipsToBounds = YES;
    
    [FIRApp configure];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    // Add any custom logic here.
    return handled;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
    NSLog(@"Will resign active...");
    
    //For Rest Timer
    if ([[[NSUserDefaults standardUserDefaults] valueForKey: kREST_TIMER_STATUS] isEqualToString: @"YES"]) {
        NSLog(@"removeAllAnimations");
//        [[workoutVC.progressBarRestScreenView layer] removeAllAnimations];
        
        //NSLog(@"Rest : %@", _viewController.timerRest);
//        workoutVC.timerRest = nil;
//        [workoutVC.timerRest invalidate];
    }
    
    //For Total Timer
    //NSLog(@"%@", _viewController.timerTotalTime);
    [workoutVC.timerTotalTime invalidate];
    workoutVC.timerTotalTime = nil;
    
    //For Last Exercise Timer
    //NSLog(@"%@", _viewController.timerTotalTime);
    [workoutVC.timerLastExerciseTime invalidate];
    workoutVC.timerLastExerciseTime = nil;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"DidEnterBackground");
    
    UIApplication *app = [UIApplication sharedApplication];
    self.bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:self.bgTask];
    }];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsAppInBackGround];
    
    //For Rest Timer
    if ([[[NSUserDefaults standardUserDefaults] valueForKey: kREST_TIMER_STATUS] isEqualToString: @"YES"]) {
        [[NSUserDefaults standardUserDefaults] setValue: [NSDate date] forKey: @"RestTimerStopDate"];
        
        if (![[[NSUserDefaults standardUserDefaults] valueForKey: @"isEndWOButtonClicked"] isEqualToString: @"YES"]) {
            
            if ([NSUserDefaults.standardUserDefaults.dictionaryRepresentation.allKeys containsObject:kTIME_NOW]) {
                NSTimeInterval currentTime = [Utils convertRestTimeToSecondsFrom: [[NSUserDefaults standardUserDefaults] valueForKey: kTIME_NOW]];
                NSLog(@"Notification time: %f", currentTime);
                if (currentTime > 11) {
                    [self generateLocalNotification: nil withTimeInterval: currentTime - 11];
                }
            }
        }
    }
    
    //For Total Timer
    workoutVC.timerTotalTime = nil;
    [workoutVC.timerTotalTime invalidate];
    [[NSUserDefaults standardUserDefaults] setValue: [NSDate date] forKey: @"TotalTimerStopDate"];
    
    //For Last Exercise Timer
    workoutVC.timerLastExerciseTime = nil;
    [workoutVC.timerLastExerciseTime invalidate];
    [[NSUserDefaults standardUserDefaults] setValue: [NSDate date] forKey: @"LastExerciseTimerStopDate"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    NSLog(@"will enter fg...");
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsAppInBackGround];
    
    application.applicationIconBadgeNumber = 0;
    
    [self->workoutVC setupProgressBar];
    
    [self->workoutVC.progressBarRestScreenView setValue: 0.0];
    [self->workoutVC.progressBarRestScreenView setMaxValue: 100.0];
    [self->workoutVC.progressBarRestScreenView setProgressColor: cPROGRESS_BAR];
    [self->workoutVC.progressBarRestScreenView setProgressStrokeColor: cPROGRESS_BAR];
    [self->workoutVC.progressBarRestScreenView setProgressLineWidth: 6.0];
    [self->workoutVC.progressBarRestScreenView setProgressAngle: -100.0];
    [self->workoutVC.progressBarRestScreenView setProgressRotationAngle: 50.0];
    [self->workoutVC.progressBarRestScreenView setEmptyLineColor: cEMPTY_BAR];
    [self->workoutVC.progressBarRestScreenView setEmptyLineStrokeColor: cEMPTY_BAR];
    [self->workoutVC.progressBarRestScreenView setEmptyLineWidth: 6.0];
    
    //Calculate rest time difference and set new rest time...
    NSLog(@"Is RestTimer Running : %@", [[NSUserDefaults standardUserDefaults] valueForKey: kREST_TIMER_STATUS]);
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey: kREST_TIMER_STATUS] isEqualToString: @"YES"]) {
        _restTimerStopDate = [[NSUserDefaults standardUserDefaults] valueForKey: @"RestTimerStopDate"];
        NSLog(@"Get Rest Timer Stop Date : %@", _restTimerStopDate);

//        NSTimeInterval restTimeDifference = [[NSDate date] timeIntervalSinceDate: _restTimerStopDate];
//        NSLog(@"Rest time difference : %f", restTimeDifference);
        
//        restTimeDifference -= [Utils convertRestTimeToSecondsFrom: [[NSUserDefaults standardUserDefaults] valueForKey: kCURRENT_REST_TIME]];
//        NSLog(@"Current rest time : %f", -restTimeDifference);

//        NSString *strCurrentTime = [Utils stringFromTimeInterval: -(restTimeDifference)];
//        NSLog(@"Current rest time (String): %@", strCurrentTime);
        
//        [[NSUserDefaults standardUserDefaults] setValue: strCurrentTime forKey: kCURRENT_REST_TIME];

//        [[NSNotificationCenter defaultCenter] postNotificationName: nREST_TOTAL_TIME object: nil];
    }
    
    //Calculate total time difference and set new total time...
    
    if (![[[NSUserDefaults standardUserDefaults] valueForKey: @"isEndWOButtonClicked"] isEqualToString: @"YES"]) {
        
        _totalTimerStopDate = [[NSUserDefaults standardUserDefaults] valueForKey: @"TotalTimerStopDate"];

        NSTimeInterval totalTimeDifference = [[NSDate date] timeIntervalSinceDate: _totalTimerStopDate];

        totalTimeDifference += [Utils convertTotalTimeToSecondsFrom: [[NSUserDefaults standardUserDefaults] valueForKey: kTOTAL_TIME]];

        NSString *strTotalTime = [Utils stringFromTotalTimeInterval: totalTimeDifference - 1];

        [[NSUserDefaults standardUserDefaults] setValue: strTotalTime forKey: kTOTAL_TIME];

        [[NSNotificationCenter defaultCenter] postNotificationName: nSET_TOTAL_TIME object: nil];
        
    } else {
        [[NSUserDefaults standardUserDefaults] setValue: @"00:00:00" forKey: kTOTAL_TIME];
    }
    
    //Calculate last ecercise time difference and set new last exercise time...
    
    _lastExerciseTimerStopDate = [[NSUserDefaults standardUserDefaults] valueForKey: @"LastExerciseTimerStopDate"];
    
    NSTimeInterval lastExerciseTimeDifference = [[NSDate date] timeIntervalSinceDate: _lastExerciseTimerStopDate];

    lastExerciseTimeDifference += [Utils convertTotalTimeToSecondsFrom: [[NSUserDefaults standardUserDefaults] valueForKey: kLAST_EXERCISE_TIME]];

    NSString *strLastExerciseTime = [Utils stringFromTotalTimeInterval: lastExerciseTimeDifference - 1];
    
    [[NSUserDefaults standardUserDefaults] setValue: strLastExerciseTime forKey: kLAST_EXERCISE_TIME];

    [[NSNotificationCenter defaultCenter] postNotificationName: nSET_LAST_EXERCISE_TIME object: nil];
    
    // Post notification to save offline workouts
//    [[NSNotificationCenter defaultCenter] postNotificationName: nSAVE_OFFLINE_WORKOUTS object: nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // End Background Task
    if (self.bgTask != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

//MARK:- Register for push notifications

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Failed to register for remote notification with error : %@", [error localizedDescription]);
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *token = [self stringFromDeviceToken:deviceToken];
    NSLog(@"Device Token: %@", token);
    
    [Utils setDeviceToken: token];
}

//MARK:- UNUserNotification's Methods

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
    NSLog(@"didReceiveNotificationResponse");
    NSLog(@"%@",response.notification.request.content.userInfo);
    completionHandler();
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    NSDictionary *dic = [[[notification request] content] userInfo];
    if (![[dic valueForKey:@"Type"] isEqualToString:@"WorkoutNotification"]) {
        completionHandler(UNNotificationPresentationOptionAlert);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"%@",userInfo);
}

//MARK:- Generate Local Notification Method

- (void)generateLocalNotification: (id) sender withTimeInterval:(NSTimeInterval) timeInterval {
    int nextSetCount = [[[NSUserDefaults standardUserDefaults] valueForKey: kSET_COUNT] intValue];
    NSString *strNotificationTitle = [NSString stringWithFormat: @"Get ready for SET %d", (nextSetCount)];
    
    UNMutableNotificationContent *localNotification = [UNMutableNotificationContent new];
    localNotification.title = [NSString localizedUserNotificationStringForKey: strNotificationTitle arguments:nil];
    localNotification.sound = [UNNotificationSound defaultSound];
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval: timeInterval repeats: NO];
    
    NSMutableDictionary *dicData = [[NSMutableDictionary alloc] init];
    [dicData setValue:@"WorkoutNotification" forKey:@"Type"];
    localNotification.userInfo = dicData;
    
    localNotification.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] +1);
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Time for a run!" content:localNotification trigger:trigger];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"Notification created");
    }];
}

//MARK:- Notification Grant Method

- (void)grantNotificationPermission: (UIApplication *) application {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center setDelegate: self];
    
    [center requestAuthorizationWithOptions: (UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
    }];
}

//MARK:- Save offline workouts on server

+ (void) callSaveOfflineWorkoutsAPI: (NSMutableArray *) arrWorkouts {
    
//    NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uSAVE_EXERCISE];
//    [[ServiceManager sharedManager] callWebServiceWithPOST: webpath withTag: tSAVE_EXERCISE paramsDic: [arrWorkouts objectAtIndex: 0]];
}

// MARK:- In-App Purchase Receipt Validation

- (BOOL)checkInAppPurchaseStatus {
    
    // Load the receipt from the app bundle.
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
    
    if (receipt) {
        BOOL sandbox = [[receiptURL lastPathComponent] isEqualToString:@"sandboxReceipt"];
        // Create the JSON object that describes the request
        NSError *error;
        NSDictionary *requestContents = @{
                                          @"receipt-data": [receipt base64EncodedStringWithOptions:0],
                                          @"password": kSharedSecret
                                          };
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                              options:0
                                                                error:&error];
        
        if (requestData) {
            // Create a POST request with the receipt data.
            NSURL *storeURL = [NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
            if (sandbox) {
                storeURL = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
            }
            NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
            [storeRequest setHTTPMethod:@"POST"];
            [storeRequest setHTTPBody:requestData];
            
            BOOL rs = NO;
            
            NSError *error;
            NSURLResponse *response;
            NSData *resData = [NSURLConnection sendSynchronousRequest:storeRequest returningResponse:&response error:&error];
            if (error) {
                rs = NO;
            } else {
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:resData options:0 error:&error];
                if (!jsonResponse) {
                    rs = NO;
                } else {
                    NSLog(@"jsonResponse:%@", jsonResponse);
                    
                    NSDictionary *dictLatestReceiptsInfo = jsonResponse[@"latest_receipt_info"];
                    NSLog(@"Maxx %@",[dictLatestReceiptsInfo valueForKeyPath:@"@max.expires_date_ms"]);
                    long long int expirationDateMs = [[dictLatestReceiptsInfo valueForKeyPath:@"@max.expires_date_ms"] longLongValue];
                    long long requestDateMs = [jsonResponse[@"receipt"][@"request_date_ms"] longLongValue];
                    
                    NSLog(@"%lld--%lld", expirationDateMs, requestDateMs);
                    rs = [[jsonResponse objectForKey:@"status"] integerValue] == 0 && (expirationDateMs > requestDateMs);
                }
            }
            return rs;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

// MARK:- API Calling

- (void)checkInAppPurchaseStatusForUser {
    
    if ([Utils isConnectedToInternet] && [[Utils userLoginStatus] isEqual:@"YES"]) {
        // Load the receipt from the app bundle.
        NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
        
        if (receipt) {
            // Check for in app purchase environment
            NSURL *storeURL = [NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
            BOOL sandbox = [[receiptURL lastPathComponent] isEqualToString:@"sandboxReceipt"];
            NSString *sandboxStatus = [[NSString alloc] init];
            
            if (sandbox) {
                sandboxStatus = @"Yes";
                storeURL = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
            } else {
                sandboxStatus = @"No";
            }
            
            NSMutableDictionary *userDetail = [[NSMutableDictionary alloc] initWithDictionary: [Utils getUserDetails]];
            
            NSDictionary *requestContents = @{
                                              @"receipt-data": [receipt base64EncodedStringWithOptions:0],
                                              @"password": kSharedSecret,
                                              @"user_id": [userDetail valueForKey: @"id"],
                                              @"isSandbox": sandboxStatus
                                              };
            NSLog(@"%@",requestContents);
            
            NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uCHECK_PRO];
            [serviceManager callWebServiceWithPOST:webpath withTag:tCHECK_PRO paramsDic:requestContents];
        }else{

            NSMutableDictionary *userDetail = [[NSMutableDictionary alloc] initWithDictionary: [Utils getUserDetails]];
            
            NSDictionary *requestContents = @{
                                              @"receipt-data": @"",
                                              @"password": kSharedSecret,
                                              @"user_id": [userDetail valueForKey: @"id"],
                                              @"isSandbox": @"No"
                                              };
            NSLog(@"%@",requestContents);
            
            NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uCHECK_PRO];
            [serviceManager callWebServiceWithPOST:webpath withTag:tCHECK_PRO paramsDic:requestContents];
        }

    }
}

- (void)saveWorkoutData {
    
    if ([Utils isConnectedToInternet]) {
        if ([[NSUserDefaults standardUserDefaults] valueForKey: kIS_USER_LOGGED_IN] != nil) {
            
            // Get workout data from UserDefault
            NSMutableArray *workoutData = [[Utils getWorkoutData] mutableCopy];
            
            if (workoutData.count > 0 && workoutData != nil) {
                NSMutableDictionary *dicWorkout = [[NSMutableDictionary alloc] init];
                
                // Add existing data dictionary
                for (NSMutableDictionary *data in workoutData) {
                    [dicWorkout addEntriesFromDictionary:data];
                }
                
                // Get All Values
                NSArray *workoutArray = [dicWorkout allValues];
                
                if (workoutArray != nil && workoutArray.count > 0) {
                    
                    // Converting to JSON Data
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: workoutArray options: NSJSONWritingPrettyPrinted error: nil];
                    NSString *jsonString = [[NSString alloc] initWithData: jsonData encoding: NSUTF8StringEncoding];
                    
                    NSMutableDictionary *userDetails = [[NSMutableDictionary alloc] initWithDictionary: [Utils getUserDetails]];
                    
                    NSDictionary *parameters = @{
                        @"workout" : jsonString,
                        @"user_id" : [userDetails valueForKey: @"id"]
                    };
                    
                    NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uSAVE_EXERCISE];
                    [serviceManager callWebServiceWithPOST: webpath withTag: tSAVE_REMAINING_DATA paramsDic: parameters];
                }
            }
        }
    }
}

// MARK:- API Data Parsing

- (void)parseCheckPro:(id)response {
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    NSLog(@"%@", dicResponse);
    
    if ([[dicResponse valueForKey:@"status"] integerValue] == 1) {
        BOOL proStatus = [[dicResponse valueForKey:@"pro_status"] boolValue];
        if (proStatus) {
            [Utils setIsPaidUser:@"YES"];
        } else {
            [Utils setIsPaidUser:@"NO"];
        }
    }
}

- (void)parseWorkoutData:(id)response {
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    NSLog(@"%@", dicResponse);
    
    if ([[dicResponse valueForKey:@"status"] integerValue] == 1) {
        // Remove workout data.
        [Utils setWorkoutData:[[NSMutableArray alloc] init]];
    }
}

// MARK:- ServiceManager Delegate

- (void)webServiceCallSuccess:(id)response forTag:(NSString *)tagname {
    if ([tagname isEqual: tCHECK_PRO]) {
        [self parseCheckPro:response];
    } else if ([tagname isEqual:tSAVE_REMAINING_DATA]) {
        [self parseWorkoutData:response];
    }
}

- (void)webServiceCallFailure:(NSError *)error forTag:(NSString *)tagname {
    NSLog(@"%@",error.description);
}

- (int)convertBackgroundRestTimeToSecondsFrom: (NSString *) restTime {
    
    NSArray *arrTimeComponents = [restTime componentsSeparatedByString: @":"];
    int minutes = [arrTimeComponents[0] intValue];
    int seconds = [arrTimeComponents[1] intValue];
    
    int totalSeconds = 0;
    
    if (minutes > 0) {
        totalSeconds += (minutes * 60);
    }
    
    if (seconds > 0) {
        totalSeconds += seconds;
    }
    
    return totalSeconds;
}

- (NSString *)stringFromDeviceToken:(NSData *)deviceToken {
    NSUInteger length = deviceToken.length;
    if (length == 0) {
        return nil;
    }
    const unsigned char *buffer = deviceToken.bytes;
    NSMutableString *hexString  = [NSMutableString stringWithCapacity:(length * 2)];
    for (int i = 0; i < length; ++i) {
        [hexString appendFormat:@"%02x", buffer[i]];
    }
    return [hexString copy];
}

@end

