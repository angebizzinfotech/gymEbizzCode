//
//  launchCircleScreenVC.m
//  GymTimer
//
//  Created by macOS on 14/04/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

#import "launchCircleScreenVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import<AuthenticationServices/AuthenticationServices.h>

extern NSString* const setCurrentIdentifier;

@interface launchCircleScreenVC () <ServiceManagerDelegate, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>
{
    UIActivityIndicatorView *spinner;
    ServiceManager *serviceManager;
    Utils *utils;
    NSDictionary *userInfo;
}
@property (nonatomic, strong) UITextView *appleIDLoginInfoTextView;

@end

@implementation launchCircleScreenVC

@synthesize appleIDLoginInfoTextView;
NSString* const setCurrentIdentifier = @"setCurrentIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];

    serviceManager = [[ServiceManager alloc] init];
    [serviceManager setDelegate: self];
    utils = [[Utils alloc] init];
    
    [self.vwProgress setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    [self onboardLaunching];
}

// TODO:- Signup with Email
-(IBAction) signupEmail:(UIButton *)sender {
}
-(IBAction) signinEmail:(UIButton *)sender {
}

// TODO:- Signin with Facebook, Apple, Email
- (IBAction)appleAction:(UIButton *)sender {
    if (@available(iOS 13.0, *)) {
        
        [self handleAuthrization: sender];
        
        [self observeAppleSignInState];
//        [self setupUI];
    }
}
- (IBAction)facebookAction:(UIButton *)sender {
    [self facebookLogin];
}
- (IBAction)EmailAction:(UIButton *)sender {
    CGRect viewSignupEmailFrame = self.vwSignupEmail.frame;
    [self.vwSignupEmail setFrame:CGRectMake(self.vwSignupEmail.frame.origin.x + self.vwSignupEmail.frame.size.width, self.vwSignupEmail.frame.origin.y, self.vwSignupEmail.frame.size.width, self.vwSignupEmail.frame.size.height)];
    [self.vwSignupEmail setHidden: false];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.vwSigninFacebook setFrame: CGRectMake(self.vwSigninFacebook.frame.origin.x - self.vwSigninFacebook.frame.size.width, self.vwSigninFacebook.frame.origin.y, self.vwSigninFacebook.frame.size.width, self.vwSigninFacebook.frame.size.height)];
        [self.vwSignupEmail setFrame: viewSignupEmailFrame];
    } completion:^(BOOL finished) {
        [self.vwSigninFacebook setHidden: true];
    }];
}

// MARK:- Apple Authentication
- (void)observeAppleSignInState {
    if (@available(iOS 13.0, *)) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(handleSignInWithAppleStateChanged:) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
    }
}
- (void)handleSignInWithAppleStateChanged:(id)noti {
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", noti);
}
- (void)setupUI {
    appleIDLoginInfoTextView = [[UITextView alloc] initWithFrame:CGRectMake(.0, 40.0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) * 0.4) textContainer:nil];
    appleIDLoginInfoTextView.font = [UIFont systemFontOfSize:32.0];
    [self.view addSubview:appleIDLoginInfoTextView];

    if (@available(iOS 13.0, *)) {
    // Sign In With Apple Button
    ASAuthorizationAppleIDButton *appleIDButton = [ASAuthorizationAppleIDButton new];

    appleIDButton.frame =  CGRectMake(.0, .0, CGRectGetWidth(self.view.frame) - 40.0, 100.0);
    CGPoint origin = CGPointMake(20.0, CGRectGetMidY(self.view.frame));
    CGRect frame = appleIDButton.frame;
    frame.origin = origin;
    appleIDButton.frame = frame;
    appleIDButton.cornerRadius = CGRectGetHeight(appleIDButton.frame) * 0.25;
    [self.view addSubview:appleIDButton];
    [appleIDButton addTarget:self action:@selector(handleAuthrization:) forControlEvents:UIControlEventTouchUpInside];
    }

    NSMutableString *mStr = [NSMutableString string];
    [mStr appendString:@"Sign In With Apple \n"];
    appleIDLoginInfoTextView.text = [mStr copy];
}

- (void)handleAuthrization:(UIButton *)sender {
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];

        ASAuthorizationAppleIDRequest *request = appleIDProvider.createRequest;
        request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];

        ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];

        controller.delegate = self;
        controller.presentationContextProvider = self;
        [controller performRequests];
    }
}

// MARK:- Facebook Authentication
- (void)facebookLogin {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    if ([UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:@"fb://"]]) {
        [login setLoginBehavior:FBSDKLoginBehaviorBrowser];
    }
    [login logInWithPermissions:@[@"public_profile", @"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            
            NSLog(@"Unexpected login error: %@", error);
            NSString *alertMessage = error.userInfo[FBSDKErrorLocalizedDescriptionKey] ?: @"There was a problem logging in. Please try again later.";
            NSString *alertTitle = error.userInfo[FBSDKErrorLocalizedTitleKey] ?: @"Oops";
            
            // Error Alert
            UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
            [errorAlert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:errorAlert animated:YES completion:nil];
        } else {
            if (result.token) {
                
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                                   parameters:@{@"fields": @"id, picture, name, email"}]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id userinfo, NSError *error) {
                    if (!error) {
                        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                        dispatch_async(queue, ^(void) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"%@",userinfo);
                                self->userInfo = (NSDictionary *)userinfo;
                                
                                // Facebook login API Calling
                                [self callFacebookLogin];
                            });
                        });
                    } else{
                        NSLog(@"%@", [error localizedDescription]);
                    }
                }];
            } else {
                NSLog(@"Login Cancel");
            }
        }
    }];
}
- (void)callFacebookLogin {
    
    NSString *strDeviceToken;
    if ([Utils getDeviceToken] == nil || [[Utils getDeviceToken] isEqualToString: @""]) {
        strDeviceToken = @"";
    } else {
        strDeviceToken = [Utils getDeviceToken];
    }
    
    NSString *strEmail = [userInfo valueForKey:@"email"];
    if (strEmail.length <= 0 || strEmail == nil) {
        strEmail = @"";
    }
    
    NSString *profileUrl = [userInfo valueForKeyPath:@"picture.data.url"];
    profileUrl = [NSString stringWithFormat: @"http://graph.facebook.com/%@/picture?type=large", [userInfo valueForKey:@"id"]];
    if (profileUrl.length <= 0 || profileUrl == nil) {
        profileUrl = @"";
    }
    
    // Load the receipt from the app bundle.
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
    
    NSString * receiptData = @"";
    NSString *sandboxStatus = @"No";

    if (receipt) {
        // Check for in app purchase environment
        NSURL *storeURL = [NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
        BOOL sandbox = [[receiptURL lastPathComponent] isEqualToString:@"sandboxReceipt"];
        
        if (sandbox) {
            sandboxStatus = @"Yes";
            storeURL = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
        } else {
            sandboxStatus = @"No";
        }
                
        receiptData = [receipt base64EncodedStringWithOptions:0];
    }

    NSArray *params = @[
        @{ @"name": [userInfo valueForKey:@"name"] },
        @{ @"social_key": [userInfo valueForKey:@"id"]},
        @{ @"email" : strEmail },
        @{ @"device_type" : @"I" },
        @{ @"device_token" : strDeviceToken },
        @{ @"timezone" : [Utils getLocalTimeZone] },
        @{ @"profile_pic": profileUrl},
        @{ @"receipt-data": receiptData},
        @{@"password": kSharedSecret},
        @{@"isSandbox": sandboxStatus}
    ];
    NSLog(@"Parameters: %@",params);
    
    if ([Utils isConnectedToInternet]) {
        spinner = [Utils showActivityIndicatorInView: self.view];
        [spinner setColor: UIColor.whiteColor];
        CGRect spinnerFrame = spinner.frame;
        UIView *statusBar = [[UIView alloc] init];
        if (@available(iOS 13, *)) {
           statusBar = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame];

        } else {
            statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        }

        if(statusBar.frame.size.height < 44){
            spinnerFrame.origin.y = 30.0;
        }else{
            spinnerFrame.origin.y = 50.0;
        }
        
        [spinner setFrame: spinnerFrame];
        
        NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uFACEBOOK_LOGIN];
        [serviceManager callWebServiceWithPOST: webpath withTag: tFACEBOOK_LOGIN params: params];
    }

}
- (void)parseFacebookLogin:(id)response {
    [Utils hideActivityIndicator:spinner fromView:self.view];
    
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    
    if ([[dicResponse valueForKey:@"status"] integerValue] == 1) {
        NSMutableDictionary *dicUserData = [dicResponse valueForKey:@"data"];
        
        BOOL proStatus = [[dicUserData valueForKey:@"pro_status"] boolValue];
        if (proStatus) {
           [Utils setIsPaidUser:@"YES"];
        } else {
           [Utils setIsPaidUser:@"NO"];
        }
        
        [Utils setUserDetails: dicUserData];
        
        NSMutableArray *arrWorkoutsData = [[NSMutableArray alloc] initWithArray: [dicResponse valueForKey: @"workouts"]];
        
        if ([arrWorkoutsData count] > 0) {
            
            for (int i = 0; i < [arrWorkoutsData count]; i++) {
                
                NSMutableDictionary *dicWorkout = [[NSMutableDictionary alloc] initWithDictionary: [arrWorkoutsData objectAtIndex: i]];
                [dicWorkout setValue: @"NO" forKey: @"isOfflineWorkout"];
                [arrWorkoutsData replaceObjectAtIndex: i withObject: dicWorkout];
                
            }
        }
        
        [Utils setUserWorkoutsData: arrWorkoutsData];
        
        [[NSUserDefaults standardUserDefaults] setValue: @"YES" forKey: kIS_USER_LOGGED_IN];
        HomeScreenViewController *homeScreenVC = GETCONTROLLER(@"HomeScreenViewController");
        [[self navigationController] pushViewController: homeScreenVC animated: YES];
    } else {
        NSLog(@"FBResp: %@",dicResponse);
        [Utils showToast: [dicResponse valueForKey: @"message"] duration: 3.0];
    }
}

// TODO:- Onboarding Launch
-(void)onboardLaunching {
    [self.vwLaunch setHidden: false];
    [self startAnimating];
    [self characterAnimation];
}
- (void)startAnimating {
    
    [UIView animateWithDuration: 2.5 animations:^{
        [self.vwProgress setValue:0.0];
    } completion:^(BOOL finished) {
        [self.vwProgress setValue:0.0];
        
        CGRect viewSigninFbFrame = self.vwSigninFacebook.frame;
        [self.vwSigninFacebook setFrame:CGRectMake(self.vwSigninFacebook.frame.origin.x + self.vwSigninFacebook.frame.size.width, self.vwSigninFacebook.frame.origin.y, self.vwSigninFacebook.frame.size.width, self.vwSigninFacebook.frame.size.height)];
        [self.vwSigninFacebook setHidden: false];
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.vwLaunch setFrame: CGRectMake(self.vwLaunch.frame.origin.x - self.vwLaunch.frame.size.width, self.vwLaunch.frame.origin.y, self.vwLaunch.frame.size.width, self.vwLaunch.frame.size.height)];
            [self.vwSigninFacebook setFrame: viewSigninFbFrame];
        } completion:^(BOOL finished) {
            [self.vwLaunch setHidden: true];
        }];
        
//        [UIView animateWithDuration:0 delay:0.0 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
//        } completion:^(BOOL finished) {
////            self.vwProgress.value = 100.0;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//            });
//        }];
    }];
}

-(void) characterAnimation
{
    CGRect viewBouncingFrame = _vwBouncing.frame;
    [_vwBouncing setFrame: CGRectMake(viewBouncingFrame.origin.x, viewBouncingFrame.origin.y + viewBouncingFrame.size.height, viewBouncingFrame.size.width, viewBouncingFrame.size.height)];
    [_vwBouncing setHidden: false];
    [UIView animateWithDuration:0.7 delay:1.0 usingSpringWithDamping:0.45 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
           [[self vwBouncing] setFrame: viewBouncingFrame];
           [[self view] layoutIfNeeded];
       } completion:^(BOOL finished) {
    }];
}


// MARK:- ServiceManager Delegate
- (void)webServiceCallSuccess:(id)response forTag:(NSString *)tagname {
    if ([tagname isEqualToString:tFACEBOOK_LOGIN]) {
        [self parseFacebookLogin:response];
    }
}

- (void)webServiceCallFailure:(NSError *)error forTag:(NSString *)tagname {
    NSLog(@"Web service call fails : %@  tagname: %@", [error localizedDescription], tagname);
    [Utils hideActivityIndicator:spinner fromView:self.view];
    [Utils showToast: [error localizedDescription] duration: 3.0];
}
@end
