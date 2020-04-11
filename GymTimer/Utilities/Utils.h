//
//  Utils.h
//  Gym Timer
//
//  Created by Vivek on 17/11/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JGProgressHUD/JGProgressHUD.h>
#import "CommonImports.h"
#import "WorkoutViewController.h"

#define maxSegmentsCount 10

@interface Utils : NSObject
{
    
    JGProgressHUDStyle _style;
    JGProgressHUDInteractionType _interaction;
    BOOL _zoom;
    BOOL _dim;
    BOOL _shadow;
    
}

//MARK:- Reachability manager method
+ (BOOL) isConnectedToInternet;

+ (NSString *)userLoginStatus;
//MARK:- WorkoutViewController shared instance
//+ (WorkoutViewController *) getWorkoutVCInstance;


//MARK:- JGProgressHUD method
- (JGProgressHUD *) prototypeHUD;


//MARK:- UIActivityIndicatorView methods
+ (UIActivityIndicatorView *)showBigActivityIndicatorInViewAtTop:(UIView *) view;

+ (UIActivityIndicatorView *)showActivityIndicatorInViewAtTop: (UIView *) view;

+ (UIActivityIndicatorView *) showActivityIndicatorInView: (UIView *) view;

+ (UIActivityIndicatorView *) showActivityIndicatorInView: (UIView *) view withColor: (UIColor *) color;

+ (void) hideActivityIndicator: (UIActivityIndicatorView *) spinner;

+ (void)hideActivityIndicator:(UIActivityIndicatorView *)spinner fromView:(UIView *)view;

//MARK:- KSToastView method
+ (void)showToast:(NSString *)message duration:(CGFloat)interval;


//MARK:- Input validation methods
+ (NSString *) trimString: (NSString *) originalString;

+ (BOOL) IsValidEmail: (NSString *) checkString;


//MARK:- Getter and setter methods
+ (void) setDeviceToken: (NSString *) deviceToken;

+ (NSString *) getDeviceToken;

+ (void) setUserDetails: (NSMutableDictionary *) dicUserDetails;

+ (NSMutableDictionary *) getUserDetails;

+ (void) setIsPaidUser: (NSString *) answer;

+ (NSString *) getIsPaidUser;

+ (void) setUserWorkoutsData: (NSMutableArray *) workoutsData;

+ (NSMutableArray *) getUserWorkoutsData;


//MARK:- Status bar background setter
+ (void) setStatusBarBackgroundWithImage: (NSString *) imageName;


//MARK:- Device details methods
+ (CGFloat) getDeviceScreenHeight;

+ (CGFloat) getDeviceScreenWidth;


//MARK:- Methods for applying shadow to any objects
+ (void) addShadowFor:(id)object atTop:(BOOL)top atBottom:(BOOL)bottom atLeft:(BOOL)left atRight:(BOOL)right shadowRadius:(float)radius shadowColor: (UIColor *) color;


//MARK:- Date-Time conversion methods
+ (NSString *) stringFromTimeInterval: (NSTimeInterval) timeInterval;

+ (NSString *) stringFromTotalTimeInterval: (NSTimeInterval) timeInterval;

+ (NSTimeInterval) convertRestTimeToSecondsFrom: (NSString *) restTime;

+ (NSTimeInterval) convertTotalTimeToSecondsFrom: (NSString *) restTime;


//Get local timezone method
+ (NSString *) getLocalTimeZone;


//MARK:- Save offline workouts on server

+ (void) callSaveOfflineWorkoutsAPI: (NSMutableDictionary *) dicParams withDelegate: (id) delegate;

+ (void)setIsStartAnimation:(NSString *)value;

+ (NSString *)getIsStartAnimation;

+ (UIColor *)colorForIndex:(NSInteger)index;

+ (void)setWorkoutAnimationStatus:(NSString *)value;

+ (NSString *)getWorkoutAnimationStatus;

+ (void)setWorkoutData:(NSMutableArray *)workoutData;

+ (NSMutableArray *)getWorkoutData;

+ (void)setTotalWorkout:(NSString *)workout;

+ (NSString *)getTotalWorkout;

+ (int)getLastRandomWorkoutComplete;
+ (void)setLastRandomWorkoutComplete;
@end
