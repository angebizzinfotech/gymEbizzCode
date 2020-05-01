//
//  Utils.m
//  Gym Timer
//
//  Created by Vivek on 17/11/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

#import "Utils.h"
#import "CommonImports.h"


@interface Utils() <JGProgressHUDDelegate>
{
    
    
    
}
@end

@implementation Utils


//MARK:- Reachability manager method

+ (BOOL) isConnectedToInternet {
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    
    BOOL internet;
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
        internet = NO;
    } else {
        internet = YES;
    }
    
    return internet;
    
}


//MARK:- WorkoutViewController shared instance

- (WorkoutViewController *) getWorkoutVCInstance {
    WorkoutViewController *workoutObj = [[WorkoutViewController alloc] init];
    return workoutObj;
}


//MARK:- JGProgressHUD method

- (JGProgressHUD *) prototypeHUD {
    //_style = JGProgressHUDStyleDark;
    _style = JGProgressHUDStyleClear;
    _interaction = JGProgressHUDInteractionTypeBlockAllTouches;
    
    _dim = YES;
    _zoom = YES;
    _shadow = YES;
    
    //    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:_style];
    JGProgressHUD *HUD = [[JGProgressHUD alloc] init];
    HUD = [JGProgressHUD progressHUDWithStyle:_style];
    HUD.interactionType = _interaction;
    
    if (_zoom) {
        JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
        HUD.animation = an;
    }
    
    if (_dim) {
        [HUD setBackgroundColor: UIColor.clearColor];
        //HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
        //HUD.backgroundColor = [UIColor colorWithRed: 31.0/255.0 green: 107.0/255.0 blue: 107.0/255.0 alpha: 1.0];
    }
    
    if (_shadow) {
        HUD.HUDView.layer.shadowColor = [UIColor clearColor].CGColor;
//        HUD.HUDView.layer.shadowColor = [UIColor blackColor].CGColor;
        //HUD.HUDView.layer.shadowColor = [[UIColor colorWithRed: 31.0/255.0 green: 107.0/255.0 blue: 107.0/255.0 alpha: 1.0] CGColor];
        HUD.HUDView.layer.shadowOffset = CGSizeZero;
//        HUD.HUDView.layer.shadowOpacity = 2.4f;
        HUD.HUDView.layer.shadowRadius = 8.0f;
        HUD.HUDView.layer.shadowOpacity = 0.0f;

    }
    
    HUD.delegate = self;
    
    return HUD;
}


//MARK:- UIActivityIndicatorView methods

+ (UIActivityIndicatorView *)showActivityIndicatorInView: (UIView *) view {
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setFrame:CGRectMake((view.frame.size.width/2)-(spinner.frame.size.width/2)+0.5, (view.frame.size.height/2)-(spinner.frame.size.height/2)+0.5, spinner.frame.size.width, spinner.frame.size.height)];
    
    [spinner setColor: UIColor.blackColor];
    [spinner setTransform: CGAffineTransformMakeScale(1.0, 1.0)];
    [view addSubview:spinner];
    [spinner startAnimating];
    [view setUserInteractionEnabled:NO];
    return spinner;
    
}

+ (UIActivityIndicatorView *)showActivityIndicatorInViewAtTop: (UIView *) view {
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
    [spinner setFrame:CGRectMake((view.frame.size.width/2)-(spinner.frame.size.width/2), 8, spinner.frame.size.width, spinner.frame.size.height)];
    [spinner setColor: cNEW_GREEN];
    //[spinner setTransform: CGAffineTransformMakeScale(1.0, 1.0)];
    [view addSubview:spinner];
    [spinner startAnimating];
    [view setUserInteractionEnabled:NO];
    return spinner;
    
}

+ (UIActivityIndicatorView *)showBigActivityIndicatorInViewAtTop:(UIView *) view {
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
    [spinner setFrame:CGRectMake((view.frame.size.width/2)-(spinner.frame.size.width/2), 44, spinner.frame.size.width, spinner.frame.size.height)];
    [spinner setColor: [UIColor whiteColor]];
    [spinner setTransform: CGAffineTransformMakeScale(1.2f, 1.2f)];
    [view addSubview:spinner];
    [spinner startAnimating];
    [view setUserInteractionEnabled:NO];
    return spinner;
    
}

+ (UIActivityIndicatorView *) showActivityIndicatorInView: (UIView *) view withColor: (UIColor *) color {
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setFrame:CGRectMake((view.frame.size.width/2)-(spinner.frame.size.width/2), (view.frame.size.height/2)-(spinner.frame.size.height/2), spinner.frame.size.width, spinner.frame.size.height)];
    [spinner setColor: color];
    [spinner setTransform: CGAffineTransformMakeScale(1.0, 1.0)];
    [view addSubview:spinner];
    [spinner startAnimating];
    return spinner;
}

+ (UIActivityIndicatorView *) showMyActivityIndicatorInView: (UIView *) view withColor: (UIColor *) color {
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setFrame: CGRectMake(view.frame.origin.x + 2.0, view.frame.origin.y + 2.0, view.frame.size.width, view.frame.size.height)];
//    [spinner setCenter: view.center];
    [spinner setColor: color];
//    [spinner setTransform: CGAffineTransformMakeScale(1.0, 1.0)];
    [view.superview addSubview:spinner];
    [spinner startAnimating];
    return spinner;
}

+ (void) hideActivityIndicator: (UIActivityIndicatorView *) spinner {
    
    [spinner stopAnimating];
}

+ (void)hideActivityIndicator:(UIActivityIndicatorView *)spinner fromView:(UIView *)view {
    [view setUserInteractionEnabled:YES];
    [spinner stopAnimating];
}

//MARK:- KSToastView method

+ (void)showToast:(NSString *)message duration:(CGFloat)interval {
    
    [KSToastView ks_setAppearanceBackgroundColor: [UIColor whiteColor]];
    [KSToastView ks_setAppearanceTextColor:[UIColor grayColor]];
    [KSToastView ks_showToast: message duration: interval];
    
}


//MARK:- Input validation methods

+ (NSString *) trimString: (NSString *) originalString {
    
    NSString *trimmedString = [originalString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    return trimmedString;
    
}

+ (BOOL) IsValidEmail: (NSString *) checkString {
    
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
//    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *stricterFilterString = @"^[0-9a-z\\._%+-]+@([a-z0-9-]+\\.)+[a-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
    
    /*
     NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
     NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
     return [emailTest evaluateWithObject:checkString];
     */
    
}


//MARK:- Getter and setter methods
+ (NSString *)userLoginStatus {
    if ([NSUserDefaults.standardUserDefaults.dictionaryRepresentation.allKeys containsObject:kIS_USER_LOGGED_IN]) {
        return [[NSUserDefaults standardUserDefaults] valueForKey:kIS_USER_LOGGED_IN];
    } else {
        return @"";
    }
}

+ (void) setDeviceToken: (NSString *) deviceToken {
    
    [[NSUserDefaults standardUserDefaults] setValue: deviceToken forKey: kDEVICE_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (NSString *) getDeviceToken {
    
    return [[NSUserDefaults standardUserDefaults] valueForKey: kDEVICE_TOKEN];
    
}

+ (void) setUserDetails: (NSMutableDictionary *) dicUserDetails {
    
    [[NSUserDefaults standardUserDefaults] setValue: dicUserDetails forKey: kUSER_DETAILS];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (NSMutableDictionary *) getUserDetails {
    
    return [[[NSUserDefaults standardUserDefaults] valueForKey: kUSER_DETAILS] mutableCopy];
    
}

+ (void) setIsPaidUser: (NSString *) answer {
    
    [[NSUserDefaults standardUserDefaults] setValue: answer forKey: kIS_PAID_USER];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (NSString *) getIsPaidUser {
    
    if ([[[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys] containsObject:kIS_PAID_USER]) {
        return [[NSUserDefaults standardUserDefaults] valueForKey: kIS_PAID_USER];
    } else {
        return @"NO";
    }
}

+ (void) setUserWorkoutsData: (NSMutableArray *) workoutsData {
    
    [[NSUserDefaults standardUserDefaults] setValue: workoutsData forKey: kUSER_WORKOUT_STATS];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (NSMutableArray *) getUserWorkoutsData {
    
    return [[[NSUserDefaults standardUserDefaults] valueForKey: kUSER_WORKOUT_STATS] mutableCopy];
    
}

+ (void)setTotalWorkout:(NSString *)workout {
    [[NSUserDefaults standardUserDefaults] setValue:workout forKey:kTOTAL_WORKOUT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getTotalWorkout {
    if ([NSUserDefaults.standardUserDefaults.dictionaryRepresentation.allKeys containsObject:kTOTAL_WORKOUT]) {
        return [[NSUserDefaults standardUserDefaults] valueForKey: kTOTAL_WORKOUT];
    } else {
        return @"0";
    }
}

//MARK:- Status bar background setter

+ (void) setStatusBarBackgroundWithImage: (NSString *) imageName {
    
    //Set Status Bar colour
    UIView *statusBar = [[UIView alloc] init];
    if (@available(iOS 13, *)) {
       statusBar = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame];

    } else {
        statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    }
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        
        statusBar.backgroundColor = [UIColor clearColor];
        //statusBar.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: imageName]];
        
    }
    
}


//MARK:- Device details methods

+ (CGFloat) getDeviceScreenHeight {
    
    return ([[UIScreen mainScreen] bounds].size.height);
    
}

+ (CGFloat) getDeviceScreenWidth {
    
    return ([[UIScreen mainScreen] bounds].size.width);
    
}


//MARK:- Methods for applying shadow to any objects

+ (void) addShadowFor:(UIView *)object atTop:(BOOL)top atBottom:(BOOL)bottom atLeft:(BOOL)left atRight:(BOOL)right shadowRadius:(float)radius shadowColor: (UIColor *) color {
    
    double x, y;
    
    [[object layer] setMasksToBounds:false];
    [[object layer] setShadowColor: color.CGColor];
    [[object layer] setShadowOffset:CGSizeMake(0, 0)];
    [[object layer] setShadowRadius:radius];
    [[object layer] setShadowOpacity: 0.1];
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    x = 0.0;
    y = 0.0;
    float objectWidth = [object frame].size.width;
    float objectHeight = [object frame].size.height;
    
    if (!top){
        y += (radius + 1);
    }
    if (!bottom){
        objectHeight -= (radius + 1);
    }
    if (!left){
        x += (radius + 1);
    }
    if (!right){
        objectWidth -= (radius + 1);
    }
    
    [path moveToPoint:CGPointMake(x, y)];
    [path addLineToPoint:CGPointMake(x, objectHeight)];
    [path addLineToPoint:CGPointMake(objectWidth, objectHeight)];
    [path addLineToPoint:CGPointMake(objectWidth, y)];
    [path closePath];
    [[object layer] setShadowPath:path.CGPath];
}


//MARK:- Date-Time conversion methods

+ (NSString *) stringFromTimeInterval: (NSTimeInterval) timeInterval {
    
    NSInteger interval = timeInterval;
    
    long seconds = interval % 60;
    long minutes = (interval / 60) % 60;
    
    return [NSString stringWithFormat:@"%0.2ld:%0.2ld", minutes, seconds];
    
}

+ (NSString *) stringFromTotalTimeInterval: (NSTimeInterval) timeInterval {
    
    NSInteger interval = timeInterval;
    
    long seconds = interval % 60;
    long minutes = (interval / 60) % 60;
    long hours = (interval / 3600);
    
    return [NSString stringWithFormat:@"%0.2ld:%0.2ld:%0.2ld", hours, minutes, seconds];
    
}

+ (NSTimeInterval) convertRestTimeToSecondsFrom: (NSString *) restTime {
    
    NSArray *arrTimeComponents = [restTime componentsSeparatedByString: @":"];
    int minutes = [arrTimeComponents[0] intValue];
    int seconds = [arrTimeComponents[1] intValue];
    
    NSTimeInterval totalSeconds = 0;
    
    if (minutes > 0) {
        totalSeconds += (minutes * 60);
    }
    
    if (seconds > 0) {
        totalSeconds += seconds;
    }
    
    return totalSeconds;
}

+ (NSTimeInterval) convertTotalTimeToSecondsFrom: (NSString *) restTime {
    
    NSArray *arrTimeComponents = [restTime componentsSeparatedByString: @":"];
    int hours = [arrTimeComponents[0] intValue];
    int minutes = [arrTimeComponents[1] intValue];
    int seconds = [arrTimeComponents[2] intValue];
    
    NSTimeInterval totalSeconds = 0;
    
    if (hours > 0) {
        totalSeconds += (hours * 3600);
    }
    
    if (minutes > 0) {
        totalSeconds += (minutes * 60);
    }
    
    if (seconds > 0) {
        totalSeconds += seconds;
    }
    
    return totalSeconds;
}


//Get local timezone method

+ (NSString *) getLocalTimeZone {
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSString *strLocalTimeZone = [timeZone name];
    return strLocalTimeZone;
    
}


//MARK:- Save offline workouts on server

+ (void) callSaveOfflineWorkoutsAPI: (NSMutableDictionary *) dicParams withDelegate: (id) delegate {
    
//    NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uSAVE_EXERCISE];
//    [[ServiceManager sharedManager] setDelegate: delegate];
//    [[ServiceManager sharedManager] callWebServiceWithPOST: webpath withTag: tSAVE_EXERCISE paramsDic: dicParams];
 
}

+ (void)setIsStartAnimation:(NSString *)value {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:@"IsStartAnimation"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getIsStartAnimation {
    if ([[[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys] containsObject:@"IsStartAnimation"]) {
        return [[NSUserDefaults standardUserDefaults] valueForKey:@"IsStartAnimation"];
    } else {
        return @"NA";
    }
}

+ (void)setWorkoutAnimationStatus:(NSString *)value {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:@"workoutAnimationStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getWorkoutAnimationStatus {
    if ([[[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys] containsObject:@"workoutAnimationStatus"]) {
        return [[NSUserDefaults standardUserDefaults] valueForKey:@"workoutAnimationStatus"];
    } else {
        return @"NA";
    }
}

// MARK:- Store workout data

/// Store workout data which are more then 5 minutes and not stored in backend yet.
+ (void)setWorkoutData:(NSMutableArray *)workoutData {
    [[NSUserDefaults standardUserDefaults] setValue:workoutData forKey:tSAVE_EXERCISE_DATA];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// Return workout data which are need to be stored in backend.
+ (NSMutableArray *)getWorkoutData {
    if ([[[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys] containsObject:tSAVE_EXERCISE_DATA]) {
        return [[NSUserDefaults standardUserDefaults] valueForKey:tSAVE_EXERCISE_DATA];
    } else {
        return [[NSMutableArray alloc] init];
    }
}

typedef struct _Color {
    CGFloat red, green, blue;
} Color;

static Color _colors[maxSegmentsCount] = {
    {87, 140, 169}, {246, 209, 85}, {0, 75, 141}, {242, 85, 44}, {149, 222, 227}, {237, 205, 194}, {206, 49, 117}, {90, 114, 71}, {207, 176, 149}, {220, 76, 70}
};

+ (UIColor *)colorForIndex:(NSInteger)index {
    Color color = _colors[index];
    return [UIColor colorWithRed:(color.red / 255.0f) green:(color.green / 255.0f) blue:(color.blue / 255.0f) alpha:1.0f];
}

+ (int)getLastRandomWorkoutComplete
{
    if([[NSUserDefaults standardUserDefaults] valueForKey: kGET_RANDOM_WORKOUT_COUNT] == nil || [[NSUserDefaults standardUserDefaults] valueForKey: kGET_RANDOM_WORKOUT_COUNT] == 0)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kGET_RANDOM_WORKOUT_COUNT];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return 1;
    }
    return [[[NSUserDefaults standardUserDefaults] valueForKey: kGET_RANDOM_WORKOUT_COUNT] intValue];
}
+ (void)setLastRandomWorkoutComplete
{
    int i = [[[NSUserDefaults standardUserDefaults] valueForKey: kGET_RANDOM_WORKOUT_COUNT] intValue];
    if(i < 9)
    {
        i++;
    } else {
        i = 1;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:i forKey:kGET_RANDOM_WORKOUT_COUNT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSAttributedString *)getLastWorkout
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    UIFont *font = [UIFont fontWithName:fFUTURA_CONDENSED_EXTRA_BOLD size: 16.0];
    NSDictionary *attrsBlack = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:77.0/255.0 alpha:1], NSForegroundColorAttributeName, nil];
    NSDictionary *attrsGreen = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, [UIColor colorWithRed:20.0/255.0 green:204.0/255.0 blue:100.0/255.0 alpha:1], NSForegroundColorAttributeName, nil];

    [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @"Your last workout was" attributes:attrsBlack]];
    [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @" %@", [[NSUserDefaults standardUserDefaults] valueForKey: kLAST_WORKOUT_ATTRIBUTE]] attributes:attrsGreen]];
    [attrString appendAttributedString: [[NSAttributedString alloc] initWithString: @"." attributes:attrsBlack]];
    
    return attrString;
}
+(void)setLastWorkout:(NSString *)message
{
    [[NSUserDefaults standardUserDefaults] setObject:message forKey:kLAST_WORKOUT_ATTRIBUTE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end

