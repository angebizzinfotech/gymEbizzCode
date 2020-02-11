//
//  Constants.h
//  Gym Timer
//
//  Created by Vivek on 17/11/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

//MARK:- In App Purchase

//Product Identifier
#define kProductIdForOneMonth @"com.gymtimerpro.onemonth"
#define kProductIdForOneYear @"com.gymtimerpro.year"

//Shared Secret For Receipt Validation
#define kSharedSecret @"81ea0d15034a4ed9bc4ef8bd6b1bb033"

//MARK:- GymTimer AppStore URL

#define uGYMTIMER_APPSTORE_URL  @"https://itunes.apple.com/us/app/gymtimer-boost-your-workouts/id1448657580?ls=1&mt=8"


//MARK:- API urls

#define uBASE_URL   @"http://ec2-52-207-213-59.compute-1.amazonaws.com/APIs/"

#define uLOGIN                      @"login.php"
#define uSIGNUP                     @"register.php"
#define uFACEBOOK_LOGIN             @"social_login.php"
#define uFORGOT_PASSWORD            @"forgot_password.php"
#define uUSER_FEEDBACK              @"user_feedback.php"
#define uCMS_PAGE                   @"cms_page.php"
#define uLOGOUT                     @"logout.php"
#define uUPDATE_PROFILE             @"update_profile.php"
#define uSAVE_EXERCISE              @"save_multiple_exercise.php"
#define uGET_EXERCISE_HISTORY       @"get_exercise_history.php"
#define uMAKE_PRO_USER              @"make_pro_user.php"
#define uGET_TOTAL_WORKOUT          @"get_total_workout.php"
#define uSEARCH_FRIEND              @"search_friend.php"
#define uSEND_FRIEND_REQUEST        @"send_request.php"
#define uREQUEST_LIST               @"request_list.php"
#define uREQUEST_ACTION             @"request_action.php"
#define uFRIEND_COUNT               @"friend_request_count.php"
#define uGET_FRIEND_RANKINGS        @"get_ranking.php"
#define uLAST_WEEK_EXERCISE_COUNT   @"last_week_exce_count.php"
#define uDELETE_FRIEND              @"delete_friend.php"
#define uHIDDEN_MODE_SETTING        @"setting.php"
#define uCHECK_PRO                  @"check_pro.php"

//MARK:- API tags

#define tLOGIN                      @"Login"
#define tSIGNUP                     @"SignUp"
#define tFACEBOOK_LOGIN             @"FacebokLogin"
#define tFORGOT_PASSWORD            @"ForgotPassword"
#define tUSER_FEEDBACK              @"UserFeedback"
#define tCMS_PAGE                   @"CmsPage"
#define tLOGOUT                     @"Logout"
#define tSEARCH_FRIEND              @"SearchFriend"
#define tSEND_FRIEND_REQUEST        @"SendRequest"
#define tFRIEND_REQUESTS            @"FriendRequest"
#define tUPDATE_PROFILE             @"UpdateProfile"
#define tSAVE_EXERCISE              @"SaveExercise"
#define tGET_EXERCISE_HISTORY       @"GetExerciseHistory"
#define tREQUEST_ACTION             @"RequestAction"
#define tFRIEND_COUNT               @"FriendCount"
#define tGET_FRIEND_RANKINGS        @"FriendRanking"
#define tLAST_WEEK_EXERCISE_COUNT   @"LastWeekExerciseCount"
#define tHIDDEN_MODE_SETTING        @"HiddenModeSetting"
#define tDELETE_FRIEND              @"DeleteFriend"
#define tMAKE_PRO_USER              @"MakeProUser"
#define tGET_TOTAL_WORKOUT          @"GetTotalWorkout"
#define tCHECK_PRO                  @"CheckPro"
#define tSAVE_EXERCISE_DATA         @"SaveExerciseData"
#define tSAVE_REMAINING_DATA        @"SaveRemainingData"

//MARK:- Sound files name constants

#define aBEEP_SOUND     @"beep_sound_latest.mp3"


//MARK:- Check for iPhone Devices

#define IS_IPHONE4 (([[UIScreen mainScreen] bounds].size.height-480)?NO:YES)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
#define IS_IPHONE5s ([[UIScreen mainScreen] bounds].size.height <= 568?YES:NO)
#define IS_IPHONE8 ([[UIScreen mainScreen] bounds].size.height == 667?YES:NO)
#define IS_IPHONE8PLUS ([[UIScreen mainScreen] bounds].size.height == 736?YES:NO)
#define IS_IPHONEX ([[UIScreen mainScreen] bounds].size.height == 812?YES:NO)
#define IS_IPHONEXR ([[UIScreen mainScreen] bounds].size.height == 896?YES:NO)


//MARK:- App delegate constant

#define APP_DELEGATE    ((AppDelegate *) [[UIApplication sharedApplication] delegate])


//MARK:- Current Device Height and Width
#define DEVICE_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define DEVICE_WIDTH   [[UIScreen mainScreen] bounds].size.width


//MARK:- Assets Images Constants
#define iWARMUP_SCREEN          [UIImage imageNamed: @"WarmUp BG"]
#define iWELCOME_SCREEN         [UIImage imageNamed: @"Welcome screen"]
#define iREST_SCREEN            [UIImage imageNamed: @"Rest Screen"]
//#define iGREEN_DUMBELLS         [UIImage imageNamed: @"green_1"]
#define iGREEN_DUMBELLS         [UIImage imageNamed: @"SetScreenCharacter"]
#define iRED_DUMBELLS           [UIImage imageNamed: @"SleepingCharacter"]
#define iRED_DUMBELLS_Bg           [UIImage imageNamed: @"SleepingCharacterbackground"]
#define iGREEN_NEXT_EXERCISE    [UIImage imageNamed: @"imgGreenNext"]
#define iRED_NEXT_EXERCISE      [UIImage imageNamed: @"imgNextRed"]
#define iGREEN_SOUND            [UIImage imageNamed: @"imgSoundGreen"]
#define iRED_SOUND              [UIImage imageNamed: @"imgSoundOnRed"]
#define iGREEN_SOUND_OFF        [UIImage imageNamed: @"imgSoundOffGreen"]
#define iRED_SOUND_OFF          [UIImage imageNamed: @"imgSoundOffRed"]
#define iGREEN_END_WORKOUT      [UIImage imageNamed: @"imgCloseGreen"]
#define iRED_END_WORKOUT        [UIImage imageNamed: @"imgCancelRed"]


//MARK:- NSNotification Constant

#define nCHANGE_BUTTON_TITLE            @"ChangeButtonTitle"
#define nSET_LAST_EXERCISE_TIME         @"SetLastExerciseTime"
#define nSET_TOTAL_TIME                 @"SetTotalTime"
#define nREST_TOTAL_TIME                @"RestTotalTime"
#define nNOTIFICATION_PERMISSION        @"NotificationPermission"
#define nSAVE_OFFLINE_WORKOUTS          @"SaveOfflineWorkouts"
#define HasNewNotification              @"HasNewNotification"
#define UpdateTabBarBadge               @"UpdateTabBarBadge"
#define PerformNavigation               @"PerformNavigation"
#define ChangeSelectedTab               @"ChangeSelectedTab"
#define SelectTab                       @"SelectTab"

//MARK:- Futura fonts constants

#define fFUTURA_BOLD                      @"Futura-Bold"
#define fFUTURA_CONDENSED_EXTRA_BOLD      @"Futura-CondensedExtraBold"
#define fFUTURA_CONDENSED_MEDIUM          @"Futura-CondensedMedium"
#define fFUTURA_MEDIUM                    @"Futura-Medium"
#define fFUTURA_MEDIUM_ITALIC             @"Futura-MediumItalic"


//MARK:- Colour Constants

#define cGYM_TIMER_LABEL [UIColor colorWithRed: 34.0/255.0 green:113.0/255.0 blue:68.0/255.0 alpha:1.0]
#define cPROGRESS_BAR [UIColor colorWithRed: 226.0/255.0 green:21.0/255.0 blue:23.0/255.0 alpha:1.0]
#define cEMPTY_BAR [UIColor colorWithRed: 254.0/255.0 green:239.0/255.0 blue:236.0/255.0 alpha:1.0]
#define cSTART_BUTTON [UIColor colorWithRed:20.0/255.0 green:204.0/255.0 blue:100.0/255.0 alpha:1.0]
#define cSTART_BUTTON_BLACK [UIColor colorWithRed:29.0/255.0 green:29.0/255.0 blue:29.0/255.0 alpha:1.0]
#define cREST_BUTTON [UIColor colorWithRed:29.0/255.0 green:29.0/255.0 blue:29.0/255.0 alpha:1.0]
#define cPROGRESS_BAR_GREEN [UIColor colorWithRed: 20.0/255.0 green:197.0/255.0 blue:89.0/255.0 alpha:1.0]
#define cGREEN_SHADOW [UIColor colorWithRed: 6.0/255.0 green: 48.0/255.0 blue: 26.0/255.0 alpha: 1.0]
#define cNEW_GREEN [UIColor colorWithRed:21.0/255.0 green:197.0/255.0 blue:89.0/255.0 alpha:1.0]
#define GreenTextColor [UIColor colorWithRed:20.0/255.0 green:204.0/255.0 blue:100.0/255.0 alpha:1.0]
#define GrayTextColor [UIColor colorWithRed:21.0/255.0 green:197.0/255.0 blue:89.0/255.0 alpha:1.0]
#define cRED_SHADOW [UIColor colorWithRed: 48.0/255.0 green: 6.0/255.0 blue: 6.0/255.0 alpha: 1.0]
#define cRED_TEXT [UIColor colorWithRed: 230.0/255.0 green: 23.0/255.0 blue: 23.0/255.0 alpha: 1.0]
#define cLIGHT_GRAY [UIColor colorWithRed: 227.0/255.0 green: 228.0/255.0 blue: 228.0/255.0 alpha: 1.0]
#define cENDURANCE_VIEW [UIColor colorWithRed: 183.0/255.0 green: 183.0/255.0 blue: 183.0/255.0 alpha: 0.8]
#define cENDURANCE_EMPTY_PROGRESS [UIColor colorWithRed: 203.0/255.0 green: 203.0/255.0 blue: 203.0/255.0 alpha: 1.0]
#define cMUSCLE_VIEW [UIColor colorWithRed: 205.0/255.0 green: 162.0/255.0 blue: 85.0/255.0 alpha: 1.0]
#define cMUSCLE_EMPTY_PROGRESS [UIColor colorWithRed: 222.0/255.0 green: 186.0/255.0 blue: 125.0/255.0 alpha: 1.0]
#define cSTRENGTH_VIEW [UIColor colorWithRed: 29.0/255.0 green: 29.0/255.0 blue: 29.0/255.0 alpha: 1.0]
#define cSTRENGTH_EMPTY_PROGRESS [UIColor colorWithRed: 91.0/255.0 green: 91.0/255.0 blue: 91.0/255.0 alpha: 1.0]
#define cPLACEHOLDER [UIColor colorWithRed  : 128.0/255.0 green: 128.0/255.0 blue: 128.0/255.0 alpha: 0.5]
#define cDARK_GREEN_BACKGROUND [UIColor colorWithRed  : 2.0/255.0 green: 54.0/255.0 blue: 15.0/255.0 alpha: 1.0]
#define cDARK_RED_BACKGROUND [UIColor colorWithRed  : 56.0/255.0 green: 0.0/255.0 blue: 1.0/255.0 alpha: 1.0]
#define cLIGHT_GREEN [UIColor colorWithRed  : 37.0/255.0 green: 96.0/255.0 blue: 61.0/255.0 alpha: 1.0]
#define cDARK_GREEN_2 [UIColor colorWithRed  : 17.0/255.0 green: 84.0/255.0 blue: 31.0/255.0 alpha: 1.0]
#define cLIGHT_GREEN_2 [UIColor colorWithRed  : 69.0/255.0 green: 181.0/255.0 blue: 112.0/255.0 alpha: 1.0]
#define cDARK_RED_2 [UIColor colorWithRed  : 93.0/255.0 green: 0.0/255.0 blue: 4.0/255.0 alpha: 1.0]
#define cLIGHT_RED_2 [UIColor colorWithRed  : 199.0/255.0 green: 81.0/255.0 blue: 81.0/255.0 alpha: 1.0]
#define cLIGHT_BLACK [UIColor colorWithRed  : 117.0/255.0 green: 117.0/255.0 blue: 117.0/255.0 alpha: 1.0]
#define cWARMUP_BLACK [UIColor colorWithRed  : 40.0/255.0 green: 40.0/255.0 blue: 40.0/255.0 alpha: 1.0]
#define cEXERCISE_BLACK [UIColor colorWithRed  : 77.0/255.0 green: 77.0/255.0 blue: 77.0/255.0 alpha: 1.0]
#define cBLACK_RING [UIColor colorWithRed  : 45.0/255.0 green: 45.0/255.0 blue: 45.0/255.0 alpha: 1.0]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


//MARK:-  Userdefaults Keys

#define kDEVICE_TOKEN           @"DeviceToken"
#define kIS_FIRST_TIME          @"IsFirstTime"
#define kIS_SEEN_ONBOARDING     @"IsSeenOnBoarding"
#define kIS_USER_LOGGED_IN      @"IsUserLoggedIn"
#define kUSER_DETAILS           @"UserDetails"
#define kSTART_TIME             @"StartTime"
#define kREST_TIME              @"RestTime"
#define kTOTAL_EXERCISE_COUNT   @"TotalExerciseCount"
#define kTOTAL_TIME             @"TotalTime"
#define kSET_COUNT              @"SetCount"
#define kQUALITY_SET_COUNT      @"QualitySetCount" // For workout quality calculation
#define kCURRENT_REST_TIME      @"CurrentRestTime"
#define kREST_TIMER_STATUS      @"RestTimerStatus"      //Is Rest timer is running or not
#define kPLAY_SOUND             @"PlaySound"            //Need to play sound or not
#define kIS_REST_SCREEN         @"IsRestScreen"
#define kIS_NEXT_EXERCISE_BUTTON_CLICKED         @"IsNextExerciseButtonClicked"
#define kIS_DEVICE_LOCKED       @"IsDeviceLocked"
#define kIS_FROM_LOCKED_DEVICE  @"IsFromLockedDevice"
#define kREST_TIMER_START_TIME  @"RestTimerStartTime"
#define kREST_TIMER_END_TIME    @"RestTimerEndTime"
#define kIS_SOUND_ON            @"IsSoundOn"
#define kLAST_EXERCISE_TIME     @"LastExerciseTime"
#define kWORKOUT_START_TIME     @"WorkoutStartTime"
#define kWORKOUT_TIME           @"WorkoutOnlyTime"
#define kIS_PAID_USER           @"IsPaidUser"
#define kUSER_WORKOUT_STATS     @"UserWorkoutStats"
#define kTOTAL_WORKOUT          @"TotalWorkouts"
#define kIS_WORKOUTS_SAVED_ON_SERVER     @"IsWorkoutsSavedOnServer"
#define kIS_FOR_OFFLINE_SAVE    @"ISForOfflineWorkoutsSaveAPICalled"
#define kTIME_NOW               @"TimeNow"
#define kIsAppInBackGround      @"ApplicationState"

//MARK:-  CollectionView Identifier Constant
#define cvONBOARDING_CELL       @"OnBoardingCollectionViewCell"
#define tblSETTINGS_CELL        @"SettingsTableViewCell"


#define GETCONTROLLER(vc) [self.storyboard instantiateViewControllerWithIdentifier: vc]


#endif /* Constants_h */
