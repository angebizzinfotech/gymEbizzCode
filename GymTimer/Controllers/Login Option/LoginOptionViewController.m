//
//  LoginOptionViewController.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 22/10/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "LoginOptionViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "CommonImports.h"

@interface LoginOptionViewController ()<ServiceManagerDelegate> {
    UIActivityIndicatorView *spinner;
    ServiceManager *serviceManager;
    Utils *utils;
    NSDictionary *userInfo;
}

@end

@implementation LoginOptionViewController

// MARK:- ViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self setupLayout];
}

- (void)viewWillAppear:(BOOL)animated {
   
    [[self navigationController] setNavigationBarHidden: YES];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.vwBottom setBackgroundColor:[UIColor whiteColor]];
    [self.vwWhiteBg setBackgroundColor:[UIColor whiteColor]];
    [self.vwLogin setBackgroundColor:[UIColor whiteColor]];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.imgBackground setAlpha:1.0];
        [self.vwWhiteBg setAlpha:1.0];
    }];
}

// MARK:- Custom Method

- (void)initialize {
    serviceManager = [[ServiceManager alloc] init];
    [serviceManager setDelegate: self];
    
    utils = [[Utils alloc] init];
    
    [self.imgBackground setAlpha:0.0];
    [self.vwWhiteBg setAlpha:0.0];
}

- (void)setupLayout {
        
    // Set Corner radius
    self.vwFacebook.layer.cornerRadius = self.vwFacebook.frame.size.height / 2;
    self.vwEmail.layer.cornerRadius = self.vwEmail.frame.size.height / 2;
    self.vwWhiteBg.layer.cornerRadius = 40.0;
    
    // Set Border
    self.vwEmail.layer.borderWidth = 3.0;
    self.vwEmail.layer.borderColor = [[UIColor colorWithRed: 68.0/255.0 green: 190.0/255.0 blue: 124.0/255.0 alpha: 1.0] CGColor];
    
    if (IS_IPHONEXR) {
    } else if (IS_IPHONEX) {
    } else if (IS_IPHONE8PLUS) {
    } else if (IS_IPHONE8) {
        self.constLoginTop.constant = 46;
        [self.lblLogin setFont:[UIFont fontWithName:fFUTURA_CONDENSED_EXTRA_BOLD size:69]];
    } else {
        self.constLoginTop.constant = 36;
        self.constVwLoginBottom.constant = 40;
        [self.lblLogin setFont:[UIFont fontWithName:fFUTURA_CONDENSED_EXTRA_BOLD size:59]];
    }
}

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

- (void)navigateToEmailLogin {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    UIViewController *registerVC = [storyBoard instantiateViewControllerWithIdentifier: @"RegistrationViewController"];
    UIView *snapShot = [APP_DELEGATE.window snapshotViewAfterScreenUpdates:YES];
    UIView *snap = [registerVC.view snapshotViewAfterScreenUpdates:YES];
    //Dinal
    snap.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:snapShot];
    [self.view addSubview:snap];
    
    //Dinal 1.0
    [UIView animateWithDuration:0.5 animations:^{
        //Dinal
        snapShot.frame = CGRectMake(0, -[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        snap.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
    } completion:^(BOOL finished) {
        [self.navigationController pushViewController:registerVC animated:NO];
        [snapShot removeFromSuperview];
        [snap removeFromSuperview];
    }];
}

// MARK:- API Calling

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

// MARK:- API Response Parsing

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

// MARK:- IBActions

- (IBAction)facebookAction:(UIButton *)sender {
    [self facebookLogin];
}

- (IBAction)emailAction:(UIButton *)sender {
    [self navigateToEmailLogin];
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
