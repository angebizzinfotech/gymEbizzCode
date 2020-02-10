//
//  Common.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 13/01/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

#ifndef Common_h
#define Common_h

// MARK:- Watch Size
#define IS_38MM WKInterfaceDevice.currentDevice.screenBounds.size.height == 170
#define IS_40MM WKInterfaceDevice.currentDevice.screenBounds.size.height == 197
#define IS_42MM WKInterfaceDevice.currentDevice.screenBounds.size.height == 195
#define IS_44MM WKInterfaceDevice.currentDevice.screenBounds.size.height == 224

// MARK:- Headers
#import "WatchUtils.h"
#import "TutorialController.h"
#import "WorkoutTimerController.h"
#import "MenuController.h"
#import "SetAndRestController.h"
#import "WorkoutCompleteController.h"
#import "InterfaceController.h"
#import "WatchManager.h"
#import "ServiceManager.h"

// MARK:- UserDefault Keys
#define uWATCH_USER_DATA @"wUserData"
#define uWORKOUT_SELETED_TIME @"wWorkoutSelectedTime"
#define uEXERCISE_COUNT @"wExerciseCount"
#define uEXERCISE_SET_COUNT @"wExerciseSetCount"
#define uEXERCISE_TOTAL_TIME @"wExerciseTotalTime"
#define uHOME_TUTORIAL @"wHomeTutorial"
#define uSET_TUTORIAL @"wSetTutorial"
#define uSET_SOUND_STATUS @"wSoundStatus"
#define uEXERCISE_START_TIME @"wExerciseStartTime"
#define uSET_AND_EXERCISE_COUNT @"wSetAndExerciseCount"

// MARK:- Notification Name
#define nSET_CURRENT_PAGE @"SetCurrentPage"
#define nSTOP_REST @"StopRest"
#define nCHANGE_PAGE @"ChangePage"
#define nCHANGE_COLOR @"ChangeColor"

// MARK:- Fonts
#define fFUTURA_BOLD                      @"Futura-Bold"
#define fFUTURA_CONDENSED_EXTRA_BOLD      @"Futura-CondensedExtraBold"
#define fFUTURA_CONDENSED_MEDIUM          @"Futura-CondensedMedium"
#define fFUTURA_MEDIUM                    @"Futura-Medium"
#define fFUTURA_MEDIUM_ITALIC             @"Futura-MediumItalic"

// MARK:- Colors
#define cGREEN [UIColor colorWithRed: 20.0/255.0 green:204.0/255.0 blue:100.0/255.0 alpha:1.0]
#define cREST_COLOR [UIColor colorWithRed: 230.0/255.0 green:23.0/255.0 blue:23.0/255.0 alpha:1.0]
#define cREST_TEXT_COLOR [UIColor colorWithRed: 133.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]
#define cSET_TEXT_COLOR [UIColor colorWithRed: 38.0/255.0 green:138.0/255.0 blue:67.0/255.0 alpha:1.0]

// MARK:- API Releted

#define uBASE_URL      @"http://ec2-52-207-213-59.compute-1.amazonaws.com/APIs/"
#define uSAVE_EXERCISE @"save_multiple_exercise.php"

#endif /* Common_h */
