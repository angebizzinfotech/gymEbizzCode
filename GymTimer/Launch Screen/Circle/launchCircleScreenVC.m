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
    Boolean isSignUp;
}
@property (nonatomic, strong) UITextView *appleIDLoginInfoTextView;

@end

@implementation launchCircleScreenVC

@synthesize appleIDLoginInfoTextView;
NSString* const setCurrentIdentifier = @"setCurrentIdentifier";

// MARK:- ViewController Liftcycle
- (void)viewDidLoad {
    [super viewDidLoad];

    isSignUp = true;
    
    serviceManager = [[ServiceManager alloc] init];
    [serviceManager setDelegate: self];
    utils = [[Utils alloc] init];
    
    [self manageGYMTimerLabelHeight];
    
    [self.vwProgress setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
    
    if(!_withLaunch)
    {
        [self SigninFacebookAppleEmail];
    }
    
    // Email Signup
    _txtFullName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_txtFullName.placeholder attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:56.0/255.0 alpha:1] }];
    _txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_txtEmail.placeholder attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:56.0/255.0 alpha:1] }];
    _txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_txtPassword.placeholder attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:56.0/255.0 alpha:1] }];
    
    _txtFullName.autocapitalizationType = UITextAutocapitalizationTypeWords;
    _txtFullName.autocorrectionType = UITextAutocorrectionTypeNo;
    _txtEmail.autocorrectionType = UITextAutocorrectionTypeNo;
    _txtPassword.autocorrectionType = UITextAutocorrectionTypeNo;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(_withLaunch)
    {
        [self onboardLaunching];
    }
}
-(void)manageGYMTimerLabelHeight
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
            case 1136:
            case 1334:
            case 1920:
            case 2208:
                _cnsGymtimerHeight.constant = 0.0;
                break;
            case 2436:
            case 2688:
            case 1792:
                _cnsGymtimerHeight.constant = -8.0;
                break;
            default:
                _cnsGymtimerHeight.constant = -8.0;
                break;
        }
    }
}

// TODO:- Notification
-(void) NotificationPermission {
    [self.vwLaunch setHidden: true];
    [self.vwSigninFacebook setHidden: true];
    [self.vwSignupEmail setHidden: true];
    [self.vwNotification setHidden: false];
    
    [self.vwSingleLineBounce setHidden: true];
    [self.vwDoubleLineBounce setHidden: true];
    [self.vwDoubleLineNotificationBounce setHidden: false];
}
-(IBAction)btnYesNotification:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setValue: @"YES" forKey: kNOTIFICATION_PERMISSION];
    [self redirectLoginToHome];
}
-(IBAction)btnNoNotification:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setValue: @"NO" forKey: kNOTIFICATION_PERMISSION];
    [self redirectLoginToHome];
}
-(void) redirectLoginToHome{
    [[NSUserDefaults standardUserDefaults] setValue: @"YES" forKey: kIS_USER_LOGGED_IN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    HomeScreenViewController *homeScreenVC = GETCONTROLLER(@"HomeScreenViewController");
    [[self navigationController] pushViewController: homeScreenVC animated: YES];
}

// TODO:- Signup with Email
-(void) SignupEmail {
    [self.vwLaunch setHidden: true];
    [self.vwSigninFacebook setHidden: true];
    [self.vwSignupEmail setHidden: false];
    [self.vwNotification setHidden: true];
    
    [_txtFullName becomeFirstResponder];
}
-(IBAction)btnSignupEmail:(UIButton *)sender {
    isSignUp = true;
    
    _lblSignup.textColor = UIColor.whiteColor;
    _lblLogin.textColor = [UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:56.0/255.0 alpha:1];
    
    [_txtFullName setHidden:false];
    [_vwFullName setHidden:false];
    [_txtPassword setPlaceholder: @" Password (at least x characters)"];
    [_btnForgot setHidden: true];
}
-(IBAction)btnSigninEmail:(UIButton *)sender {
    isSignUp = false;
    
    _lblSignup.textColor = [UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:56.0/255.0 alpha:1];
    _lblLogin.textColor = UIColor.whiteColor;
    
    [_txtFullName setHidden:true];
    [_vwFullName setHidden:true];
    [_txtPassword setPlaceholder: @" Password"];
    [_btnForgot setHidden: false];
}
-(IBAction)btnForgotPassword:(UIButton *)sender {
    [self presentViewController: GETCONTROLLER(@"ForgotPasswordViewController") animated: true completion: nil];
}
-(IBAction)btnDone:(UIButton *)sender {
    [self.view endEditing: YES];

    isSignUp ? [self callSignupAPI] : [self callLoginAPI];
}

- (BOOL) isValidForSignup {
    if ([[Utils trimString: [_txtFullName text]] isEqualToString: @""]) {
        [Utils showToast: @"Please enter your name." duration: 3.0];
        return NO;
    } else if ([[Utils trimString: [_txtEmail text]] isEqualToString: @""]) {
        [Utils showToast: @"Please enter your Email." duration: 3.0];
        return NO;
    } else if (![Utils IsValidEmail: [_txtEmail text]]) {
        [Utils showToast: @"Please enter valid email." duration: 3.0];
        return NO;
    } else if ([[Utils trimString: [_txtPassword text]] isEqualToString: @""]) {
        [Utils showToast: @"Please enter your password." duration: 3.0];
        return NO;
    } else {
        return YES;
    }
}
- (BOOL) isValidForLogin {
    
    if ([[Utils trimString: [_txtEmail text]] isEqualToString: @""]) {
        [Utils showToast: @"Please enter your Email." duration: 3.0];
        return NO;
    } else if (![Utils IsValidEmail: [_txtEmail text]]) {
        [Utils showToast: @"Please enter valid email." duration: 3.0];
        return NO;
    } else if ([[Utils trimString: [_txtPassword text]] isEqualToString: @""]) {
        [Utils showToast: @"Please enter your password." duration: 3.0];
        return NO;
    } else {
        return YES;
    }
}
- (void) callSignupAPI {
    if ([self isValidForSignup]) {
        NSString *strDeviceToken;
        if ([Utils getDeviceToken] == nil || [[Utils getDeviceToken] isEqualToString: @""]) {
            strDeviceToken = @"";
        } else {
            strDeviceToken = [Utils getDeviceToken];
        }
        
        NSArray *arrSignUpParams = @[
                                     @{ @"name" : [_txtFullName text] },
                                     @{ @"email" : [_txtEmail text] },
                                     @{ @"password" : [_txtPassword text] },
                                     @{ @"device_type" : @"I" },
                                     @{ @"device_token" : strDeviceToken },
                                     @{ @"timezone" : [Utils getLocalTimeZone] },
                                     @{ @"mobile" : @"" },
                                     @{ @"gender" : @"" }
                                 ];
        if ([Utils isConnectedToInternet]) {
            spinner = [Utils showActivityIndicatorInView: self.view]; //_viewLoginSignupBgView
            NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uSIGNUP];
            [serviceManager callWebServiceWithPOST: webpath withTag: tSIGNUP params: arrSignUpParams];
        }
    }
}
- (void) callLoginAPI {
    if ([self isValidForLogin]) {
        NSString *strDeviceToken;
        if ([Utils getDeviceToken] == nil || [[Utils getDeviceToken] isEqualToString: @""]) {
            strDeviceToken = @"";
        } else {
            strDeviceToken = [Utils getDeviceToken];
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

        NSArray *arrLoginParams = @[
                                    @{ @"email" : [_txtEmail text]},
                                    @{ @"password" : [_txtPassword text]},
                                    @{ @"device_type" : @"I"},
                                    @{ @"device_token" : strDeviceToken},
                                    @{ @"receipt-data": receiptData},
                                    @{ @"password2": kSharedSecret},
                                    @{ @"isSandbox": sandboxStatus}
                                ];
        if ([Utils isConnectedToInternet]) {
            spinner = [Utils showActivityIndicatorInView: self.view]; //_viewLoginSignupBgView
            NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uLOGIN];
            [serviceManager callWebServiceWithPOST: webpath withTag: tLOGIN params: arrLoginParams];
        }
    }
}
- (void) parseSignUpResponse: (id) response {
    [Utils hideActivityIndicator:spinner fromView: self.view];
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    
    if ([[dicResponse valueForKey:@"status"] integerValue] == 1) {
        [_txtFullName setText: @""];
        [_txtEmail setText: @""];
        [_txtPassword setText: @""];
        
        [self.view endEditing: YES];
        
        NSMutableDictionary *dicUserData = [dicResponse valueForKey:@"data"];
        [Utils setUserDetails: dicUserData];
        
        [self afterLoginAnmation];
    } else {
        [Utils showToast: [dicResponse valueForKey: @"message"] duration: 3.0];
    }
}
- (void)parseLoginResponse:(id)response {
    [Utils hideActivityIndicator:spinner fromView: self.view];
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    
    if ([[dicResponse valueForKey:@"status"] integerValue] == 1) {
        [_txtFullName setText: @""];
        [_txtEmail setText: @""];
        [_txtPassword setText: @""];
        
        [self.view endEditing: YES];
        
        NSMutableDictionary *dicUserData = [dicResponse valueForKey:@"data"];
        [Utils setUserDetails: dicUserData];
        
        BOOL proStatus = [[dicUserData valueForKey:@"pro_status"] boolValue];
        if (proStatus) {
           [Utils setIsPaidUser:@"YES"];
        } else {
           [Utils setIsPaidUser:@"NO"];
        }
        
        NSMutableArray *arrWorkoutsData = [[NSMutableArray alloc] initWithArray: [dicResponse valueForKey: @"workouts"]];
        
        if ([arrWorkoutsData count] > 0) {
            for (int i = 0; i < [arrWorkoutsData count]; i++) {
                NSMutableDictionary *dicWorkout = [[NSMutableDictionary alloc] initWithDictionary: [arrWorkoutsData objectAtIndex: i]];
                [dicWorkout setValue: @"NO" forKey: @"isOfflineWorkout"];
                [arrWorkoutsData replaceObjectAtIndex: i withObject: dicWorkout];
            }
        }
        
        [Utils setUserWorkoutsData: arrWorkoutsData];
        
        [self afterLoginAnmation];
    } else {
        [Utils showToast: [dicResponse valueForKey: @"message"] duration: 3.0];
    }
}

// TODO:- Signin with Facebook, Apple, Email
-(void) SigninFacebookAppleEmail {
    [self.vwLaunch setHidden: true];
    [self.vwSigninFacebook setHidden: false];
    [self.vwSignupEmail setHidden: true];
    [self.vwNotification setHidden: true];

    [self.vwBouncing setHidden: false];
    [self.vwSingleLineBounce setHidden: true];
    [self.vwDoubleLineBounce setHidden: false];
    [self.vwDoubleLineNotificationBounce setHidden: true];
}
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
        [self SignupEmail];
    }];
}
- (IBAction)btnPrivacyPolicy:(UIButton *)sender {
    _withLaunch = false;
    [[self navigationController] pushViewController: GETCONTROLLER(@"PrivacyPolicyViewController") animated: YES];
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

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)){

    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", controller);
    NSLog(@"%@", authorization);

    NSLog(@"authorization.credential：%@", authorization.credential);

    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
        NSString *user = appleIDCredential.user;
        [[NSUserDefaults standardUserDefaults] setValue:user forKey:setCurrentIdentifier];
        NSString *familyName = appleIDCredential.fullName.familyName;
        NSString *givenName = appleIDCredential.fullName.givenName;
        NSString *fullName = [NSString stringWithFormat:@"%@ %@", givenName, familyName];
        NSString *email = appleIDCredential.email;
        NSString *userId = appleIDCredential.user;
        
        if(email == nil) {
            [Utils showToast: @"Required email" duration: 3.0];
        } else if(givenName == nil && familyName == nil) {
            [Utils showToast: @"Required name" duration: 3.0];
        } else if(userId == nil) {
            [Utils showToast: @"Something went wrong" duration: 3.0];
        } else {
            userInfo = [[NSDictionary alloc] initWithObjectsAndKeys: email, @"email", fullName, @"name", userId, @"id", nil];
            [self callFacebookLogin];
        }
        
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        ASPasswordCredential *passwordCredential = authorization.credential;
        NSString *user = passwordCredential.user;
        NSString *password = passwordCredential.password;
//        [mStr appendString:user?:@""];
//        [mStr appendString:password?:@""];
//        [mStr appendString:@"\n"];
//        NSLog(@"mStr：%@", mStr);
//        appleIDLoginInfoTextView.text = mStr;
    } else {
//         mStr = [@"check" mutableCopy];
//        appleIDLoginInfoTextView.text = mStr;
    }
}


- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  API_AVAILABLE(ios(13.0)){

    NSLog(@"%s", __FUNCTION__);
    NSLog(@"error ：%@", error);
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"ASAuthorizationErrorCanceled";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"ASAuthorizationErrorFailed";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"ASAuthorizationErrorInvalidResponse";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"ASAuthorizationErrorNotHandled";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"ASAuthorizationErrorUnknown";
            break;
    }

    NSMutableString *mStr = [appleIDLoginInfoTextView.text mutableCopy];
    [mStr appendString:errorMsg];
    [mStr appendString:@"\n"];
    appleIDLoginInfoTextView.text = [mStr copy];

    if (errorMsg) {
        return;
    }

    if (error.localizedDescription) {
        NSMutableString *mStr = [appleIDLoginInfoTextView.text mutableCopy];
        [mStr appendString:error.localizedDescription];
        [mStr appendString:@"\n"];
        appleIDLoginInfoTextView.text = [mStr copy];
    }
    NSLog(@"controller requests：%@", controller.authorizationRequests);
    /*
     ((ASAuthorizationAppleIDRequest *)(controller.authorizationRequests[0])).requestedScopes
     <__NSArrayI 0x2821e2520>(
     full_name,
     email
     )
     */
}

//! Tells the delegate from which window it should present content to the user.
 - (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){

    NSLog(@"window：%s", __FUNCTION__);
    return self.view.window;
}

- (void)dealloc {

    if (@available(iOS 13.0, *)) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
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
    if (profileUrl.length <= 0 || profileUrl == nil) {
        profileUrl = @"";
    } else {
        profileUrl = [NSString stringWithFormat: @"http://graph.facebook.com/%@/picture?type=large", [userInfo valueForKey:@"id"]];
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
        
        [self afterLoginAnmation];
    } else {
        NSLog(@"FBResp: %@",dicResponse);
        [Utils showToast: [dicResponse valueForKey: @"message"] duration: 3.0];
    }
}
-(void)afterLoginAnmation {
    CGRect viewNotificationFrame = self.vwNotification.frame;
    [self.vwNotification setFrame:CGRectMake(self.vwNotification.frame.origin.x + self.vwNotification.frame.size.width, self.vwNotification.frame.origin.y, self.vwNotification.frame.size.width, self.vwNotification.frame.size.height)];
    [self.vwNotification setHidden: false];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.vwSignupEmail setFrame: CGRectMake(self.vwSignupEmail.frame.origin.x - self.vwSignupEmail.frame.size.width, self.vwSignupEmail.frame.origin.y, self.vwSignupEmail.frame.size.width, self.vwSignupEmail.frame.size.height)];
        [self.vwSigninFacebook setFrame: CGRectMake(self.vwSigninFacebook.frame.origin.x - self.vwSigninFacebook.frame.size.width, self.vwSigninFacebook.frame.origin.y, self.vwSigninFacebook.frame.size.width, self.vwSigninFacebook.frame.size.height)];
        [self.vwNotification setFrame: viewNotificationFrame];
    } completion:^(BOOL finished) {
        [self NotificationPermission];
    }];
}

// TODO:- Onboarding Launch
-(void)onboardLaunching {
    [self.vwLaunch setHidden: false];
    [self.vwSigninFacebook setHidden: true];
    [self.vwSignupEmail setHidden: true];
    [self.vwNotification setHidden: true];
    
//    [[self.vwBackgroundGreen layer] setCornerRadius: 8.0];
//    UIBezierPath *vwBackgroundGreenShadowPath = [UIBezierPath bezierPathWithRect: [self.vwBackgroundGreen bounds]];
//    [[self.vwBackgroundGreen layer] setMasksToBounds: NO];
//    [[self.vwBackgroundGreen layer] setShadowColor: [[UIColor blackColor] CGColor]];
//    [[self.vwBackgroundGreen layer] setShadowOffset: CGSizeMake(2.0, 2.0)];
//    [[self.vwBackgroundGreen layer] setShadowRadius: 8.0];
//    [[self.vwBackgroundGreen layer] setShadowOpacity: 0.25];
//    [[self.vwBackgroundGreen layer] setShadowPath: [vwBackgroundGreenShadowPath CGPath]];

    [self startAnimating];
    [self characterAnimation];
}
- (void)startAnimating {
    
    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.vwProgress setValue: 0.0];
    } completion:^(BOOL finished) {
        [self.vwProgress setValue:0.0];
        if(self.isHome)
        {
            UIViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier: @"HomeScreenViewController"];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: homeVC];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate.window setRootViewController: navController];
            [appDelegate.window makeKeyAndVisible];
        }
    }];
    
    if(self.isHome)
    { } else {
        CGRect viewSigninFbFrame = self.vwSigninFacebook.frame;
        [self.vwSigninFacebook setFrame:CGRectMake(self.vwSigninFacebook.frame.origin.x + self.vwSigninFacebook.frame.size.width, self.vwSigninFacebook.frame.origin.y, self.vwSigninFacebook.frame.size.width, self.vwSigninFacebook.frame.size.height)];
        [self.vwSigninFacebook setHidden: false];
        
        [UIView animateWithDuration:0.5 delay: 1.5 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
            [self.vwLaunch setFrame: CGRectMake(self.vwLaunch.frame.origin.x - self.vwLaunch.frame.size.width, self.vwLaunch.frame.origin.y, self.vwLaunch.frame.size.width, self.vwLaunch.frame.size.height)];
            [self.vwSigninFacebook setFrame: viewSigninFbFrame];
        } completion:^(BOOL finished) {
            [self SigninFacebookAppleEmail];
        }];
    }
}

-(void) characterAnimation
{
    CGRect viewBouncingFrame = _vwBouncing.frame;
    [_vwBouncing setFrame: CGRectMake(viewBouncingFrame.origin.x, viewBouncingFrame.origin.y + viewBouncingFrame.size.height + 10.0, viewBouncingFrame.size.width, viewBouncingFrame.size.height)];
    [_vwBouncing setHidden: false];
    [UIView animateWithDuration:0.8 delay:0.2 usingSpringWithDamping:0.45 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
           [[self vwBouncing] setFrame: viewBouncingFrame];
           [[self view] layoutIfNeeded];
       } completion:^(BOOL finished) {
    }];
}


// MARK:- ServiceManager Delegate
- (void)webServiceCallSuccess:(id)response forTag:(NSString *)tagname {
    if ([tagname isEqualToString:tFACEBOOK_LOGIN]) {
        [self parseFacebookLogin:response];
    } else if ([tagname isEqualToString: tSIGNUP]) {
        [self parseSignUpResponse: response];
    } else if ([tagname isEqualToString: tLOGIN]) {
        [self parseLoginResponse: response];
    }
}

- (void)webServiceCallFailure:(NSError *)error forTag:(NSString *)tagname {
    NSLog(@"Web service call fails : %@  tagname: %@", [error localizedDescription], tagname);
    [Utils hideActivityIndicator:spinner fromView:self.view];
    [Utils showToast: [error localizedDescription] duration: 3.0];
}
@end
