//
//  RegistrationViewController.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 25/04/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "RegistrationViewController.h"
#import "CommonImports.h"

@interface RegistrationViewController () <ServiceManagerDelegate, UITextFieldDelegate, AVAudioPlayerDelegate> {
    ServiceManager *serviceManager;
    Utils *utils;
    JGProgressHUD *progressHUD;
    NSString *isSignup;
    UIActivityIndicatorView *spinner;
    NSString *isFromShowLoginScreenNotification;
    NSURL *urlBeepAudio;
    SystemSoundID soundID;
    AVAudioSession *audioSession;
}

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isFromShowLoginScreenNotification = @"NO";
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    if ([isFromShowLoginScreenNotification isEqualToString: @"NO"]) {
        [self setupLayout];
        [self initializeData];
    } else {
        isFromShowLoginScreenNotification = @"NO";
        [[NSNotificationCenter defaultCenter] removeObserver: self name: @"ShowLoginScreen" object: nil];
    }
    //Dinal
    //[self btnLoginButtonTapped:_btnLoginButton];

    //SetUp Top Image
    [self setUpTopImage];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    
    [_tfSignupNameTextField setText: @""];
    [_tfSignupEmailTextField setText: @""];
    [_tfSignupPasswordTextField setText: @""];
    [_tfLoginEmailTextField setText: @""];
    [_tfLoginPasswordTextField setText: @""];
    
}


//MARK:- Button's action methods

- (IBAction)btnLoginButtonTapped:(UIButton *)sender {

//    AudioServicesPlaySystemSoundWithCompletion(1106, nil);     //0x0000003F
//    AudioServicesPlayAlertSoundWithCompletion(1110, nil);
    
    isSignup = @"NO";

    [_tfLoginEmailTextField setText: @""];
    [_tfLoginPasswordTextField setText: @""];
    
    [_tfLoginEmailTextField becomeFirstResponder];
    
    [UIView animateWithDuration: 0.3 delay: 0.0 options: UIViewAnimationOptionTransitionNone animations:^{
       
        if (IS_IPHONEXR) {
            [self->_viewSignupContentView setFrame: CGRectMake(-DEVICE_WIDTH, 32.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 30.0))];
            [self->_viewLoginContentView setFrame: CGRectMake(0.0, 32.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 30.0))];
        } else if (IS_IPHONEX) {
            [self->_viewSignupContentView setFrame: CGRectMake(-DEVICE_WIDTH, 32.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 30.0))];
            [self->_viewLoginContentView setFrame: CGRectMake(0.0, 32.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 30.0))];
        } else if (IS_IPHONE8PLUS) {
            [self->_viewSignupContentView setFrame: CGRectMake(-DEVICE_WIDTH, 32.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 30.0))];
            [self->_viewLoginContentView setFrame: CGRectMake(0.0, 32.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 30.0))];
        } else if (IS_IPHONE8) {
            [self->_viewSignupContentView setFrame: CGRectMake(-DEVICE_WIDTH, 16.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 16.0))];
            [self->_viewLoginContentView setFrame: CGRectMake(0.0, 16.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 16.0))];
        } else {
            [self->_viewSignupContentView setFrame: CGRectMake(-DEVICE_WIDTH, 16.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 16.0))];
            [self->_viewLoginContentView setFrame: CGRectMake(0.0, 16.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 16.0))];
        }
        
    } completion:^(BOOL finished) {
        
        if (IS_IPHONEXR) {
            [self->_viewSignupContentView setFrame: CGRectMake(-DEVICE_WIDTH, 32.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 30.0))];
        } else if (IS_IPHONEX) {
            [self->_viewSignupContentView setFrame: CGRectMake(-DEVICE_WIDTH, 32.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 30.0))];
        } else if (IS_IPHONE8PLUS) {
            [self->_viewSignupContentView setFrame: CGRectMake(-DEVICE_WIDTH, 32.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 30.0))];
        } else if (IS_IPHONE8) {
            [self->_viewSignupContentView setFrame: CGRectMake(-DEVICE_WIDTH, 16.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 16.0))];
        } else {
            [self->_viewSignupContentView setFrame: CGRectMake(-DEVICE_WIDTH, 16.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 16.0))];
        }
        
        [self->_tfSignupNameTextField setText: @""];
        [self->_tfSignupEmailTextField setText: @""];
        [self->_tfSignupPasswordTextField setText: @""];
        
    }];
    
}

- (IBAction)btnSignUpButtonTapped:(UIButton *)sender {
    
//    AudioServicesPlaySystemSoundWithCompletion(1106, nil);     //0x0000003F //1005
//    AudioServicesPlayAlertSoundWithCompletion(1107, nil);
    
    isSignup = @"YES";
    
    [_tfSignupNameTextField setText: @""];
    [_tfSignupEmailTextField setText: @""];
    [_tfSignupPasswordTextField setText: @""];
    
    [_tfSignupNameTextField becomeFirstResponder];
    
    [UIView animateWithDuration: 0.3 delay: 0.0 options: UIViewAnimationOptionTransitionNone animations:^{
        
        if (IS_IPHONEXR) {
            [self->_viewLoginContentView setFrame: CGRectMake(DEVICE_WIDTH, 32.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 30.0))];
            [self->_viewSignupContentView setFrame: CGRectMake(0.0, 32.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 30.0))];
        } else if (IS_IPHONEX) {
            [self->_viewLoginContentView setFrame: CGRectMake(DEVICE_WIDTH, 32.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 30.0))];
            [self->_viewSignupContentView setFrame: CGRectMake(0.0, 32.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 30.0))];
        } else if (IS_IPHONE8PLUS) {
            [self->_viewLoginContentView setFrame: CGRectMake(DEVICE_WIDTH, 32.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 30.0))];
            [self->_viewSignupContentView setFrame: CGRectMake(0.0, 32.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 30.0))];
        } else if (IS_IPHONE8) {
            [self->_viewLoginContentView setFrame: CGRectMake(DEVICE_WIDTH, 16.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 16.0))];
            [self->_viewSignupContentView setFrame: CGRectMake(0.0, 16.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 16.0))];
        } else {
            [self->_viewLoginContentView setFrame: CGRectMake(DEVICE_WIDTH, 16.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 16.0))];
            [self->_viewSignupContentView setFrame: CGRectMake(0.0, 16.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 16.0))];
        }
        
    } completion:^(BOOL finished) {
        
        if (IS_IPHONEXR) {
            [self->_viewLoginContentView setFrame: CGRectMake(DEVICE_WIDTH, 32.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 30.0))];
        } else if (IS_IPHONEX) {
            [self->_viewLoginContentView setFrame: CGRectMake(DEVICE_WIDTH, 32.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 30.0))];
        } else if (IS_IPHONE8PLUS) {
            [self->_viewLoginContentView setFrame: CGRectMake(DEVICE_WIDTH, 32.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 30.0))];
        } else if (IS_IPHONE8) {
            [self->_viewLoginContentView setFrame: CGRectMake(DEVICE_WIDTH, 16.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 16.0))];
        } else {
            [self->_viewLoginContentView setFrame: CGRectMake(DEVICE_WIDTH, 16.0, self->_viewLoginSignupBgView.frame.size.width, (self->_viewLoginSignupBgView.frame.size.height - 16.0))];
        }
        
        [self->_tfLoginEmailTextField setText: @""];
        [self->_tfLoginPasswordTextField setText: @""];
        
    }];
    
}

- (IBAction)btnForgotPasswordButtonTapped:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(handleShowLoginScreenNotification:) name: @"ShowLoginScreen" object: nil];
    [self presentViewController: GETCONTROLLER(@"ForgotPasswordViewController") animated: NO completion: nil];
}

- (IBAction)btnStartButtonTapped:(UIButton *)sender {
    AudioServicesPlaySystemSoundWithCompletion(1520, nil);
    
    [self.view endEditing: YES];
    ([isSignup isEqualToString: @"YES"]) ? [self callSignupAPI] : [self callLoginAPI];
}

//MARK:- UItextfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [[self view] endEditing: YES];
    return YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSString *lastChar = [string substringFromIndex: [string length] - (string.length > 0)];
    NSString *strFinalString = ([lastChar isEqualToString: @" "]) ? [string substringToIndex: string.length - (string.length > 0)] : string;
    
    if ([textField isEqual: _tfSignupEmailTextField]) {
        
        if ([string length] <= 1) {
            return YES;
        } else {
            [_tfSignupEmailTextField setText: strFinalString];
            [_tfSignupPasswordTextField becomeFirstResponder];
            return NO;
        }
        
    } else if ([textField isEqual: _tfLoginEmailTextField]) {
        
        if ([string length] <= 1) {
            return YES;
        } else {
            [_tfLoginEmailTextField setText: strFinalString];
            [_tfLoginPasswordTextField becomeFirstResponder];
            return NO;
        }
        
    } else if ([textField isEqual: _tfSignupPasswordTextField]) {
        
        if ([string length] <= 1) {
            return YES;
        } else {
            [_tfSignupPasswordTextField setText: @""];
            [self performSelector: @selector(clearSignupPasswordFields) withObject: nil afterDelay: 1.0];
            return NO;
        }
        
    } else if ([textField isEqual: _tfLoginPasswordTextField]) {
        
        if ([string length] <= 1) {
            return YES;
        } else {
            [_tfLoginPasswordTextField setText: @""];
            [self performSelector: @selector(clearSignupPasswordFields) withObject: nil afterDelay: 1.0];
            return NO;
        }
        
    } else {}
    
    return YES;

}


//MARK:- User defined methods

- (void)setUpTopImage {
    if (IS_IPHONEXR) {
        
    } else if (IS_IPHONEX) {
        
    } else if (IS_IPHONE8PLUS) {
        
    } else if (IS_IPHONE8) {
        [self.imgLoginTop setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 108)];
        self.imgLoginTop.image = [UIImage imageNamed:@"loginTop7"];
    } else {
        
    }
}

- (void) setupLayout {
    
    [[self navigationController] setNavigationBarHidden: YES];
    [self showScreenContents];
    
    //Gym timer title label
//    [_lblGymTimerTitleLabel setTextColor: cGYM_TIMER_LABEL];
    [_lblGymTimerTitleLabel setTextColor: [UIColor whiteColor]];
    [_lblGymTimerTitleLabel setAlpha: 1.0];
    
    //Login Signup background view
    [_viewLoginSignupBgView setClipsToBounds: YES];
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: [_viewLoginSignupBgView bounds] byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){30.0, 30.}].CGPath;
    [[_viewLoginSignupBgView layer] setMask: maskLayer];
    
    //Signup details content view
    [_viewSignupContentView setBackgroundColor: UIColor.clearColor];
    [_lblSignupTitleLabel setTextColor: cSTART_BUTTON];
    
    [_tfSignupNameTextField setDelegate: self];
    [_tfSignupNameTextField setAutocorrectionType: UITextAutocorrectionTypeNo];
    [_tfSignupNameTextField setAutocapitalizationType: UITextAutocapitalizationTypeWords];
    [_tfSignupNameTextField setTintColor: cSTART_BUTTON];
    [_tfSignupNameTextField setAttributedPlaceholder: [[NSAttributedString alloc] initWithString: @" Full Name"]];
    [_viewSignupNameUnderlineView setBackgroundColor: cSTART_BUTTON];
    [_tfSignupEmailTextField setDelegate: self];
    [_tfSignupEmailTextField setAutocorrectionType: UITextAutocorrectionTypeNo];
    [_tfSignupEmailTextField setTintColor: cSTART_BUTTON];
    [_tfSignupEmailTextField setAttributedPlaceholder: [[NSAttributedString alloc] initWithString: @" Email"]];
    [_viewSignupEmailUnderlineView setBackgroundColor: cSTART_BUTTON];
    [_tfSignupPasswordTextField setDelegate: self];
    [_tfSignupPasswordTextField setSecureTextEntry: YES];
    [_tfSignupPasswordTextField setAutocorrectionType: UITextAutocorrectionTypeNo];
    [_tfSignupPasswordTextField setTextContentType: @""];
    [_tfSignupPasswordTextField setTintColor: cSTART_BUTTON];
    [_tfSignupPasswordTextField setAttributedPlaceholder: [[NSAttributedString alloc] initWithString: @" Password"]];
    [_viewSignupPasswordUnderlineView setBackgroundColor: cSTART_BUTTON];
    
    
    //Login details content view
    [_viewLoginContentView setBackgroundColor: UIColor.clearColor];
    [_lblLoginTitleLabel setTextColor: cSTART_BUTTON];
    
    [_tfLoginEmailTextField setDelegate: self];
    [_tfLoginEmailTextField setAutocorrectionType: UITextAutocorrectionTypeNo];
    [_tfLoginEmailTextField setTintColor: cSTART_BUTTON];
    [_tfLoginEmailTextField setAttributedPlaceholder: [[NSAttributedString alloc] initWithString: @" Email"]];
    [_viewLoginEmailUnderlineView setBackgroundColor: cSTART_BUTTON];
    [_tfLoginPasswordTextField setDelegate: self];
    [_tfLoginPasswordTextField setSecureTextEntry: YES];
    [_tfLoginPasswordTextField setAutocorrectionType: UITextAutocorrectionTypeNo];
    [_tfLoginPasswordTextField setTextContentType: @""];
    [_tfLoginPasswordTextField setTintColor: cSTART_BUTTON];
    [_tfLoginPasswordTextField setAttributedPlaceholder: [[NSAttributedString alloc] initWithString: @" Password"]];
    [_viewLoginPasswordUnderlineView setBackgroundColor: cSTART_BUTTON];
    
    
    //Start button
    [_btnStartButton setClipsToBounds: YES];
    
    
    if (IS_IPHONEXR) {
        
        //Gym timer title label
        [_lblGymTimerTitleLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblGymTimerTitleLabel setFont: fontGymTimerLabel];
        
        //Login Signup background view
        [_viewLoginSignupBgView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        
        //Signup details view
        [_viewSignupContentView setFrame: CGRectMake(0.0, 32.0, _viewLoginSignupBgView.frame.size.width, (_viewLoginSignupBgView.frame.size.height - 30.0))];
        
        [_lblSignupTitleLabel setFrame: CGRectMake(41.0, 0.0, (DEVICE_WIDTH - 72.0), 60.0)];
        UIFont *fontLoginLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 44.0];
        UIFont *fontForFreeLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 24.0];
        NSDictionary *dicSignUpLabel = @{ NSForegroundColorAttributeName : cSTART_BUTTON,
                                          NSFontAttributeName : fontLoginLabel
                                          };
        NSAttributedString *attSignUpLabel = [[NSAttributedString alloc] initWithString: @"Sign Up" attributes: dicSignUpLabel];
        NSDictionary *dicForFreeLabel = @{ NSForegroundColorAttributeName : cSTART_BUTTON,
                                           NSFontAttributeName : fontForFreeLabel
                                           };
        NSAttributedString *attForFree = [[NSAttributedString alloc] initWithString: @"  (for FREE)" attributes: dicForFreeLabel];
        NSMutableAttributedString *attSignUpTitleLabel = [[NSMutableAttributedString alloc] init];
        [attSignUpTitleLabel appendAttributedString: attSignUpLabel];
        [attSignUpTitleLabel appendAttributedString: attForFree];
        [_lblSignupTitleLabel setAttributedText: attSignUpTitleLabel];
        
        UIFont *fontNameEmailPassword = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
        [_tfSignupNameTextField setFrame: CGRectMake(41.0, (_lblSignupTitleLabel.frame.origin.y + _lblSignupTitleLabel.frame.size.height + 16.0), (DEVICE_WIDTH - 41.0), 30.0)];
        [_tfSignupNameTextField setFont: fontNameEmailPassword];
        NSAttributedString *attNamePlaceholder = [[NSAttributedString alloc] initWithString: @" Full Name" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontNameEmailPassword}];
        [_tfSignupNameTextField setAttributedPlaceholder: attNamePlaceholder];
        [_viewSignupNameUnderlineView setFrame: CGRectMake(41.0, (_tfSignupNameTextField.frame.origin.y + _tfSignupNameTextField.frame.size.height + 4.0), (DEVICE_WIDTH - 41.0), 2.0)];
        
        [_tfSignupEmailTextField setFrame: CGRectMake(41.0, (_viewSignupNameUnderlineView.frame.origin.y + _viewSignupNameUnderlineView.frame.size.height + 16.0), (DEVICE_WIDTH - 41.0), 30.0)];
        [_tfSignupEmailTextField setFont: fontNameEmailPassword];
        NSAttributedString *attEmailPlaceholder = [[NSAttributedString alloc] initWithString: @" Email" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontNameEmailPassword}];
        [_tfSignupEmailTextField setAttributedPlaceholder: attEmailPlaceholder];
        [_viewSignupEmailUnderlineView setFrame: CGRectMake(41.0, (_tfSignupEmailTextField.frame.origin.y + _tfSignupEmailTextField.frame.size.height + 4.0), (DEVICE_WIDTH - 41.0), 2.0)];
        
        [_tfSignupPasswordTextField setFrame: CGRectMake(41.0, (_viewSignupEmailUnderlineView.frame.origin.y + _viewSignupEmailUnderlineView.frame.size.height + 16.0), (DEVICE_WIDTH - 41.0), 30.0)];
        [_tfSignupPasswordTextField setFont: fontNameEmailPassword];
        NSAttributedString *attPasswordPlaceholder = [[NSAttributedString alloc] initWithString: @" Password" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontNameEmailPassword}];
        [_tfSignupPasswordTextField setAttributedPlaceholder: attPasswordPlaceholder];
        [_viewSignupPasswordUnderlineView setFrame: CGRectMake(41.0, (_tfSignupPasswordTextField.frame.origin.y + _tfSignupPasswordTextField.frame.size.height + 4.0), (DEVICE_WIDTH - 41.0), 2.0)];
        
        [_viewLoginButtonContentView setFrame: CGRectMake(70.0, (_viewSignupPasswordUnderlineView.frame.origin.y + _viewSignupPasswordUnderlineView.frame.size.height + 8.0), DEVICE_WIDTH, 30.0)];
        [_viewLoginButtonContentView setBackgroundColor: UIColor.clearColor];
        [_lblAlreadyMemberLabel setFrame: CGRectMake(0.0, 1.0, (DEVICE_WIDTH - 161.0), 30.0)];
        UIFont *fontNewHereLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 12.0];
        [_lblAlreadyMemberLabel setFont: fontNewHereLabel];
        [_lblAlreadyMemberLabel setTextColor: UIColor.grayColor];
        [_btnLoginButton setFrame: CGRectMake((DEVICE_WIDTH - 151.0), 1.0, 60.0, 30.0)];
        UIFont *fontSignUpButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 16.0];
        NSDictionary *attSignUpButton = @{ NSForegroundColorAttributeName : cSTART_BUTTON,
                                           NSFontAttributeName : fontSignUpButton
                                           };
        NSAttributedString *attSignUp = [[NSAttributedString alloc] initWithString: @"Log In" attributes: attSignUpButton];
        [_btnLoginButton setAttributedTitle: attSignUp forState: UIControlStateNormal];
        
        /*------------------------------------------------------------------------------------*/
        
        //Login details view
        [_viewLoginContentView setFrame: CGRectMake(DEVICE_WIDTH, 32.0, _viewLoginSignupBgView.frame.size.width, (_viewLoginSignupBgView.frame.size.height - 30.0))];
        
        [_lblLoginTitleLabel setFrame: CGRectMake(41.0, 0.0, (DEVICE_WIDTH - 72.0), 60.0)];
        UIFont *fontLoginTitleLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 44.0];
        [_lblLoginTitleLabel setFont: fontLoginTitleLabel];
        
        UIFont *fontEmailPassword = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
        [_tfLoginEmailTextField setFrame: CGRectMake(41.0, (_lblLoginTitleLabel.frame.origin.y + _lblLoginTitleLabel.frame.size.height + 32.0), (DEVICE_WIDTH - 41.0), 30.0)];
        [_tfLoginEmailTextField setFont: fontEmailPassword];
        NSAttributedString *attLoginEmailPlaceholder = [[NSAttributedString alloc] initWithString: @" Email" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontEmailPassword}];
        [_tfLoginEmailTextField setAttributedPlaceholder: attLoginEmailPlaceholder];
        [_viewLoginEmailUnderlineView setFrame: CGRectMake(41.0, (_tfLoginEmailTextField.frame.origin.y + _tfLoginEmailTextField.frame.size.height + 4.0), (DEVICE_WIDTH - 41.0), 2.0)];
        
        [_tfLoginPasswordTextField setFrame: CGRectMake(41.0, (_viewLoginEmailUnderlineView.frame.origin.y + _viewLoginEmailUnderlineView.frame.size.height + 16.0), (DEVICE_WIDTH - 41.0), 30.0)];
        [_tfLoginPasswordTextField setFont: fontEmailPassword];
        NSAttributedString *attLoginPasswordPlaceholder = [[NSAttributedString alloc] initWithString: @" Password" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontEmailPassword}];
        [_tfLoginPasswordTextField setAttributedPlaceholder: attLoginPasswordPlaceholder];
        [_viewLoginPasswordUnderlineView setFrame: CGRectMake(41.0, (_tfLoginPasswordTextField.frame.origin.y + _tfLoginPasswordTextField.frame.size.height + 4.0), (DEVICE_WIDTH - 41.0), 2.0)];
        
        [_btnForgotPasswordButton setFrame: CGRectMake(41.0, (_viewLoginPasswordUnderlineView.frame.origin.y + _viewLoginPasswordUnderlineView.frame.size.height + 2.0), (DEVICE_WIDTH - 41.0), 30.0)];
        UIFont *fontForgotButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 12];
        NSDictionary *attForgotButton = @{ NSForegroundColorAttributeName : UIColor.blackColor,
                                           NSFontAttributeName : fontForgotButton
                                           };
        NSAttributedString *att = [[NSAttributedString alloc] initWithString: @"Forgot password?" attributes: attForgotButton];
        [_btnForgotPasswordButton setAttributedTitle: att forState: UIControlStateNormal];
        [_btnForgotPasswordButton setAlpha: 0.7];
        
        [_viewSignupButtonContentView setFrame: CGRectMake(70.0, (_btnForgotPasswordButton.frame.origin.y + _btnForgotPasswordButton.frame.size.height + 13.0), DEVICE_WIDTH, 30.0)];
        [_viewSignupButtonContentView setBackgroundColor: UIColor.clearColor];
        [_lblAreYouNewHereLabel setFrame: CGRectMake(0.0, 0.0, (DEVICE_WIDTH - 170.0), 30.0)];
        UIFont *fontLoginNewHereLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 12.0];
        [_lblAreYouNewHereLabel setFont: fontLoginNewHereLabel];
        [_lblAreYouNewHereLabel setTextColor: UIColor.grayColor];
        [_btnSignUpButton setFrame: CGRectMake((DEVICE_WIDTH - 160.0), 0.0, 60.0, 30.0)];
        UIFont *fontLoginSignUpButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 16.0];
        NSDictionary *attLoginSignUpButton = @{ NSForegroundColorAttributeName : cSTART_BUTTON,
                                                NSFontAttributeName : fontLoginSignUpButton
                                                };
        NSAttributedString *attLoginSignUp = [[NSAttributedString alloc] initWithString: @"Sign Up" attributes: attLoginSignUpButton];
        [_btnSignUpButton setAttributedTitle: attLoginSignUp forState: UIControlStateNormal];
        
        
        //Start button
        [_btnStartButton setFrame: CGRectMake(58.0, (_viewSignupButtonContentView.frame.origin.y + _viewSignupButtonContentView.frame.size.height + 10.0 + 131.0), (DEVICE_WIDTH - 116.0), 60.0)];
        [_btnStartButton setBackgroundColor: cSTART_BUTTON_BLACK];
        UIFont *fontStartButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 28.0];
        NSDictionary *dicStartButton = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                          NSFontAttributeName : fontStartButton
                                          };
        NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"START" attributes: dicStartButton];
        [_btnStartButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
        [[_btnStartButton layer] setCornerRadius: 20.0];
        
    } else if (IS_IPHONEX) {
        
        //Gym timer title label
        [_lblGymTimerTitleLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblGymTimerTitleLabel setFont: fontGymTimerLabel];
        
        //Login Signup background view
        [_viewLoginSignupBgView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        
        //Signup details view
        [_viewSignupContentView setFrame: CGRectMake(0.0, 32.0, _viewLoginSignupBgView.frame.size.width, (_viewLoginSignupBgView.frame.size.height - 30.0))];
        
        [_lblSignupTitleLabel setFrame: CGRectMake(41.0, 0.0, (DEVICE_WIDTH - 72.0), 60.0)];
        UIFont *fontLoginLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 44.0];
        UIFont *fontForFreeLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 24.0];
        NSDictionary *dicSignUpLabel = @{ NSForegroundColorAttributeName : cSTART_BUTTON,
                                          NSFontAttributeName : fontLoginLabel
                                          };
        NSAttributedString *attSignUpLabel = [[NSAttributedString alloc] initWithString: @"Sign Up" attributes: dicSignUpLabel];
        NSDictionary *dicForFreeLabel = @{ NSForegroundColorAttributeName : cSTART_BUTTON,
                                           NSFontAttributeName : fontForFreeLabel
                                           };
        NSAttributedString *attForFree = [[NSAttributedString alloc] initWithString: @"  (for FREE)" attributes: dicForFreeLabel];
        NSMutableAttributedString *attSignUpTitleLabel = [[NSMutableAttributedString alloc] init];
        [attSignUpTitleLabel appendAttributedString: attSignUpLabel];
        [attSignUpTitleLabel appendAttributedString: attForFree];
        [_lblSignupTitleLabel setAttributedText: attSignUpTitleLabel];
        
        UIFont *fontNameEmailPassword = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
        [_tfSignupNameTextField setFrame: CGRectMake(41.0, (_lblSignupTitleLabel.frame.origin.y + _lblSignupTitleLabel.frame.size.height + 16.0), (DEVICE_WIDTH - 41.0), 30.0)];
        [_tfSignupNameTextField setFont: fontNameEmailPassword];
        NSAttributedString *attNamePlaceholder = [[NSAttributedString alloc] initWithString: @" Full Name" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontNameEmailPassword}];
        [_tfSignupNameTextField setAttributedPlaceholder: attNamePlaceholder];
        [_viewSignupNameUnderlineView setFrame: CGRectMake(41.0, (_tfSignupNameTextField.frame.origin.y + _tfSignupNameTextField.frame.size.height + 4.0), (DEVICE_WIDTH - 41.0), 2.0)];
        
        [_tfSignupEmailTextField setFrame: CGRectMake(41.0, (_viewSignupNameUnderlineView.frame.origin.y + _viewSignupNameUnderlineView.frame.size.height + 16.0), (DEVICE_WIDTH - 41.0), 30.0)];
        [_tfSignupEmailTextField setFont: fontNameEmailPassword];
        NSAttributedString *attEmailPlaceholder = [[NSAttributedString alloc] initWithString: @" Email" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontNameEmailPassword}];
        [_tfSignupEmailTextField setAttributedPlaceholder: attEmailPlaceholder];
        [_viewSignupEmailUnderlineView setFrame: CGRectMake(41.0, (_tfSignupEmailTextField.frame.origin.y + _tfSignupEmailTextField.frame.size.height + 4.0), (DEVICE_WIDTH - 41.0), 2.0)];
        
        [_tfSignupPasswordTextField setFrame: CGRectMake(41.0, (_viewSignupEmailUnderlineView.frame.origin.y + _viewSignupEmailUnderlineView.frame.size.height + 16.0), (DEVICE_WIDTH - 41.0), 30.0)];
        [_tfSignupPasswordTextField setFont: fontNameEmailPassword];
        NSAttributedString *attPasswordPlaceholder = [[NSAttributedString alloc] initWithString: @" Password" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontNameEmailPassword}];
        [_tfSignupPasswordTextField setAttributedPlaceholder: attPasswordPlaceholder];
        [_viewSignupPasswordUnderlineView setFrame: CGRectMake(41.0, (_tfSignupPasswordTextField.frame.origin.y + _tfSignupPasswordTextField.frame.size.height + 4.0), (DEVICE_WIDTH - 41.0), 2.0)];
        
        [_viewLoginButtonContentView setFrame: CGRectMake(80.0, (_viewSignupPasswordUnderlineView.frame.origin.y + _viewSignupPasswordUnderlineView.frame.size.height + 8.0), DEVICE_WIDTH, 30.0)];
        [_viewLoginButtonContentView setBackgroundColor: UIColor.clearColor];
        [_lblAlreadyMemberLabel setFrame: CGRectMake(0.0, 1.0, (DEVICE_WIDTH - 161.0), 30.0)];
        UIFont *fontNewHereLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 12.0];
        [_lblAlreadyMemberLabel setFont: fontNewHereLabel];
        [_lblAlreadyMemberLabel setTextColor: UIColor.grayColor];
        [_btnLoginButton setFrame: CGRectMake((DEVICE_WIDTH - 151.0), 1.0, 60.0, 30.0)];
        UIFont *fontSignUpButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 16.0];
        NSDictionary *attSignUpButton = @{ NSForegroundColorAttributeName : cSTART_BUTTON,
                                           NSFontAttributeName : fontSignUpButton
                                           };
        NSAttributedString *attSignUp = [[NSAttributedString alloc] initWithString: @"Log In" attributes: attSignUpButton];
        [_btnLoginButton setAttributedTitle: attSignUp forState: UIControlStateNormal];
        
        /*------------------------------------------------------------------------------------*/
        
        //Login details view
        [_viewLoginContentView setFrame: CGRectMake(DEVICE_WIDTH, 32.0, _viewLoginSignupBgView.frame.size.width, (_viewLoginSignupBgView.frame.size.height - 30.0))];
        
        [_lblLoginTitleLabel setFrame: CGRectMake(41.0, 0.0, (DEVICE_WIDTH - 72.0), 60.0)];
        UIFont *fontLoginTitleLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 44.0];
        [_lblLoginTitleLabel setFont: fontLoginTitleLabel];
        
        UIFont *fontEmailPassword = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
        [_tfLoginEmailTextField setFrame: CGRectMake(41.0, (_lblLoginTitleLabel.frame.origin.y + _lblLoginTitleLabel.frame.size.height + 32.0), (DEVICE_WIDTH - 41.0), 30.0)];
        [_tfLoginEmailTextField setFont: fontEmailPassword];
        NSAttributedString *attLoginEmailPlaceholder = [[NSAttributedString alloc] initWithString: @" Email" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontEmailPassword}];
        [_tfLoginEmailTextField setAttributedPlaceholder: attLoginEmailPlaceholder];
        [_viewLoginEmailUnderlineView setFrame: CGRectMake(41.0, (_tfLoginEmailTextField.frame.origin.y + _tfLoginEmailTextField.frame.size.height + 4.0), (DEVICE_WIDTH - 41.0), 2.0)];
        
        [_tfLoginPasswordTextField setFrame: CGRectMake(41.0, (_viewLoginEmailUnderlineView.frame.origin.y + _viewLoginEmailUnderlineView.frame.size.height + 16.0), (DEVICE_WIDTH - 41.0), 30.0)];
        [_tfLoginPasswordTextField setFont: fontEmailPassword];
        NSAttributedString *attLoginPasswordPlaceholder = [[NSAttributedString alloc] initWithString: @" Password" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontEmailPassword}];
        [_tfLoginPasswordTextField setAttributedPlaceholder: attLoginPasswordPlaceholder];
        [_viewLoginPasswordUnderlineView setFrame: CGRectMake(41.0, (_tfLoginPasswordTextField.frame.origin.y + _tfLoginPasswordTextField.frame.size.height + 4.0), (DEVICE_WIDTH - 41.0), 2.0)];
        
        [_btnForgotPasswordButton setFrame: CGRectMake(41.0, (_viewLoginPasswordUnderlineView.frame.origin.y + _viewLoginPasswordUnderlineView.frame.size.height + 2.0), (DEVICE_WIDTH - 41.0), 30.0)];
        UIFont *fontForgotButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 12];
        NSDictionary *attForgotButton = @{ NSForegroundColorAttributeName : UIColor.blackColor,
                                           NSFontAttributeName : fontForgotButton
                                           };
        NSAttributedString *att = [[NSAttributedString alloc] initWithString: @"Forgot password?" attributes: attForgotButton];
        [_btnForgotPasswordButton setAttributedTitle: att forState: UIControlStateNormal];
        [_btnForgotPasswordButton setAlpha: 0.7];
        
        [_viewSignupButtonContentView setFrame: CGRectMake(80.0, (_btnForgotPasswordButton.frame.origin.y + _btnForgotPasswordButton.frame.size.height + 13.0), DEVICE_WIDTH, 30.0)];
        [_viewSignupButtonContentView setBackgroundColor: UIColor.clearColor];
        [_lblAreYouNewHereLabel setFrame: CGRectMake(0.0, 0.0, (DEVICE_WIDTH - 170.0), 30.0)];
        UIFont *fontLoginNewHereLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 12.0];
        [_lblAreYouNewHereLabel setFont: fontLoginNewHereLabel];
        [_lblAreYouNewHereLabel setTextColor: UIColor.grayColor];
        [_btnSignUpButton setFrame: CGRectMake((DEVICE_WIDTH - 160.0), 0.0, 60.0, 30.0)];
        UIFont *fontLoginSignUpButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 16.0];
        NSDictionary *attLoginSignUpButton = @{ NSForegroundColorAttributeName : cSTART_BUTTON,
                                           NSFontAttributeName : fontLoginSignUpButton
                                           };
        NSAttributedString *attLoginSignUp = [[NSAttributedString alloc] initWithString: @"Sign Up" attributes: attLoginSignUpButton];
        [_btnSignUpButton setAttributedTitle: attLoginSignUp forState: UIControlStateNormal];
        
        
        //Start button
        [_btnStartButton setFrame: CGRectMake(58.0, (_viewSignupButtonContentView.frame.origin.y + _viewSignupButtonContentView.frame.size.height + 10.0 + 131.0), (DEVICE_WIDTH - 116.0), 60.0)];
        [_btnStartButton setBackgroundColor: cSTART_BUTTON_BLACK];
        UIFont *fontStartButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 28.0];
        NSDictionary *dicStartButton = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                          NSFontAttributeName : fontStartButton
                                          };
        NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"START" attributes: dicStartButton];
        [_btnStartButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
        [[_btnStartButton layer] setCornerRadius: 20.0];
        
    } else if (IS_IPHONE8PLUS) {
        
        //Gym timer title label
        [_lblGymTimerTitleLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblGymTimerTitleLabel setFont: fontGymTimerLabel];
        
        //Login Signup background view
        [_viewLoginSignupBgView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        
        //Signup details view
        [_viewSignupContentView setFrame: CGRectMake(0.0, 32.0, _viewLoginSignupBgView.frame.size.width, (_viewLoginSignupBgView.frame.size.height - 30.0))];
        
        [_lblSignupTitleLabel setFrame: CGRectMake(41.0, 0.0, (DEVICE_WIDTH - 72.0), 60.0)];
        UIFont *fontLoginLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 44.0];
        UIFont *fontForFreeLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 24.0];
        NSDictionary *dicSignUpLabel = @{ NSForegroundColorAttributeName : cSTART_BUTTON,
                                          NSFontAttributeName : fontLoginLabel
                                          };
        NSAttributedString *attSignUpLabel = [[NSAttributedString alloc] initWithString: @"Sign Up" attributes: dicSignUpLabel];
        NSDictionary *dicForFreeLabel = @{ NSForegroundColorAttributeName : cSTART_BUTTON,
                                           NSFontAttributeName : fontForFreeLabel
                                           };
        NSAttributedString *attForFree = [[NSAttributedString alloc] initWithString: @"  (for FREE)" attributes: dicForFreeLabel];
        NSMutableAttributedString *attSignUpTitleLabel = [[NSMutableAttributedString alloc] init];
        [attSignUpTitleLabel appendAttributedString: attSignUpLabel];
        [attSignUpTitleLabel appendAttributedString: attForFree];
        [_lblSignupTitleLabel setAttributedText: attSignUpTitleLabel];
        
        UIFont *fontNameEmailPassword = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
        [_tfSignupNameTextField setFrame: CGRectMake(41.0, (_lblSignupTitleLabel.frame.origin.y + _lblSignupTitleLabel.frame.size.height + 16.0), (DEVICE_WIDTH - 41.0), 30.0)];
        [_tfSignupNameTextField setFont: fontNameEmailPassword];
        NSAttributedString *attNamePlaceholder = [[NSAttributedString alloc] initWithString: @" Full Name" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontNameEmailPassword}];
        [_tfSignupNameTextField setAttributedPlaceholder: attNamePlaceholder];
        [_viewSignupNameUnderlineView setFrame: CGRectMake(41.0, (_tfSignupNameTextField.frame.origin.y + _tfSignupNameTextField.frame.size.height + 4.0), (DEVICE_WIDTH - 41.0), 2.0)];
        
        [_tfSignupEmailTextField setFrame: CGRectMake(41.0, (_viewSignupNameUnderlineView.frame.origin.y + _viewSignupNameUnderlineView.frame.size.height + 16.0), (DEVICE_WIDTH - 41.0), 30.0)];
        [_tfSignupEmailTextField setFont: fontNameEmailPassword];
        NSAttributedString *attEmailPlaceholder = [[NSAttributedString alloc] initWithString: @" Email" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontNameEmailPassword}];
        [_tfSignupEmailTextField setAttributedPlaceholder: attEmailPlaceholder];
        [_viewSignupEmailUnderlineView setFrame: CGRectMake(41.0, (_tfSignupEmailTextField.frame.origin.y + _tfSignupEmailTextField.frame.size.height + 4.0), (DEVICE_WIDTH - 41.0), 2.0)];
        
        [_tfSignupPasswordTextField setFrame: CGRectMake(41.0, (_viewSignupEmailUnderlineView.frame.origin.y + _viewSignupEmailUnderlineView.frame.size.height + 16.0), (DEVICE_WIDTH - 41.0), 30.0)];
        [_tfSignupPasswordTextField setFont: fontNameEmailPassword];
        NSAttributedString *attPasswordPlaceholder = [[NSAttributedString alloc] initWithString: @" Password" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontNameEmailPassword}];
        [_tfSignupPasswordTextField setAttributedPlaceholder: attPasswordPlaceholder];
        [_viewSignupPasswordUnderlineView setFrame: CGRectMake(41.0, (_tfSignupPasswordTextField.frame.origin.y + _tfSignupPasswordTextField.frame.size.height + 4.0), (DEVICE_WIDTH - 41.0), 2.0)];
        
        [_viewLoginButtonContentView setFrame: CGRectMake(80.0, (_viewSignupPasswordUnderlineView.frame.origin.y + _viewSignupPasswordUnderlineView.frame.size.height + 8.0), DEVICE_WIDTH, 30.0)];
        [_viewLoginButtonContentView setBackgroundColor: UIColor.clearColor];
        [_lblAlreadyMemberLabel setFrame: CGRectMake(0.0, 1.0, (DEVICE_WIDTH - 183.0), 30.0)];
        UIFont *fontNewHereLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 12.0];
        [_lblAlreadyMemberLabel setFont: fontNewHereLabel];
        [_lblAlreadyMemberLabel setTextColor: UIColor.grayColor];
        [_btnLoginButton setFrame: CGRectMake((DEVICE_WIDTH - 173.0), 1.0, 60.0, 30.0)];
        UIFont *fontSignUpButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 16.0];
        NSDictionary *attSignUpButton = @{ NSForegroundColorAttributeName : cSTART_BUTTON,
                                           NSFontAttributeName : fontSignUpButton
                                           };
        NSAttributedString *attSignUp = [[NSAttributedString alloc] initWithString: @"Log In" attributes: attSignUpButton];
        [_btnLoginButton setAttributedTitle: attSignUp forState: UIControlStateNormal];
        
        /*------------------------------------------------------------------------------------*/
        
        //Login details view
        [_viewLoginContentView setFrame: CGRectMake(DEVICE_WIDTH, 32.0, _viewLoginSignupBgView.frame.size.width, (_viewLoginSignupBgView.frame.size.height - 30.0))];
        
        [_lblLoginTitleLabel setFrame: CGRectMake(41.0, 0.0, (DEVICE_WIDTH - 72.0), 60.0)];
        UIFont *fontLoginTitleLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 44.0];
        [_lblLoginTitleLabel setFont: fontLoginTitleLabel];
        
        UIFont *fontEmailPassword = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
        [_tfLoginEmailTextField setFrame: CGRectMake(41.0, (_lblLoginTitleLabel.frame.origin.y + _lblLoginTitleLabel.frame.size.height + 32.0), (DEVICE_WIDTH - 41.0), 30.0)];
        [_tfLoginEmailTextField setFont: fontEmailPassword];
        NSAttributedString *attLoginEmailPlaceholder = [[NSAttributedString alloc] initWithString: @" Email" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontEmailPassword}];
        [_tfLoginEmailTextField setAttributedPlaceholder: attLoginEmailPlaceholder];
        [_viewLoginEmailUnderlineView setFrame: CGRectMake(41.0, (_tfLoginEmailTextField.frame.origin.y + _tfLoginEmailTextField.frame.size.height + 4.0), (DEVICE_WIDTH - 41.0), 2.0)];
        
        [_tfLoginPasswordTextField setFrame: CGRectMake(41.0, (_viewLoginEmailUnderlineView.frame.origin.y + _viewLoginEmailUnderlineView.frame.size.height + 16.0), (DEVICE_WIDTH - 41.0), 30.0)];
        [_tfLoginPasswordTextField setFont: fontEmailPassword];
        NSAttributedString *attLoginPasswordPlaceholder = [[NSAttributedString alloc] initWithString: @" Password" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontEmailPassword}];
        [_tfLoginPasswordTextField setAttributedPlaceholder: attLoginPasswordPlaceholder];
        [_viewLoginPasswordUnderlineView setFrame: CGRectMake(41.0, (_tfLoginPasswordTextField.frame.origin.y + _tfLoginPasswordTextField.frame.size.height + 4.0), (DEVICE_WIDTH - 41.0), 2.0)];
        
        [_btnForgotPasswordButton setFrame: CGRectMake(41.0, (_viewLoginPasswordUnderlineView.frame.origin.y + _viewLoginPasswordUnderlineView.frame.size.height + 2.0), (DEVICE_WIDTH - 41.0), 30.0)];
        UIFont *fontForgotButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 12];
        NSDictionary *attForgotButton = @{ NSForegroundColorAttributeName : UIColor.blackColor,
                                           NSFontAttributeName : fontForgotButton
                                           };
        NSAttributedString *att = [[NSAttributedString alloc] initWithString: @"Forgot password?" attributes: attForgotButton];
        [_btnForgotPasswordButton setAttributedTitle: att forState: UIControlStateNormal];
        [_btnForgotPasswordButton setAlpha: 0.7];
        
        [_viewSignupButtonContentView setFrame: CGRectMake(80.0, (_btnForgotPasswordButton.frame.origin.y + _btnForgotPasswordButton.frame.size.height + 13.0), DEVICE_WIDTH, 30.0)];
        [_viewSignupButtonContentView setBackgroundColor: UIColor.clearColor];
        [_lblAreYouNewHereLabel setFrame: CGRectMake(0.0, 0.0, (DEVICE_WIDTH - 190.0), 30.0)];
        UIFont *fontLoginNewHereLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 12.0];
        [_lblAreYouNewHereLabel setFont: fontLoginNewHereLabel];
        [_lblAreYouNewHereLabel setTextColor: UIColor.grayColor];
        [_btnSignUpButton setFrame: CGRectMake((DEVICE_WIDTH - 180.0), 0.0, 60.0, 30.0)];
        UIFont *fontLoginSignUpButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 16.0];
        NSDictionary *attLoginSignUpButton = @{ NSForegroundColorAttributeName : cSTART_BUTTON,
                                                NSFontAttributeName : fontLoginSignUpButton
                                                };
        NSAttributedString *attLoginSignUp = [[NSAttributedString alloc] initWithString: @"Sign Up" attributes: attLoginSignUpButton];
        [_btnSignUpButton setAttributedTitle: attLoginSignUp forState: UIControlStateNormal];
        
        
        //Start button
        [_btnStartButton setFrame: CGRectMake(58.0, (_viewSignupButtonContentView.frame.origin.y + _viewSignupButtonContentView.frame.size.height + 10.0 + 131.0), (DEVICE_WIDTH - 116.0), 60.0)];
        [_btnStartButton setBackgroundColor: cSTART_BUTTON_BLACK];
        UIFont *fontStartButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 28.0];
        NSDictionary *dicStartButton = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                          NSFontAttributeName : fontStartButton
                                          };
        NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"START" attributes: dicStartButton];
        [_btnStartButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
        [[_btnStartButton layer] setCornerRadius: 20.0];
        
    } else if (IS_IPHONE8) {
        
        //Gym timer title label
        [_lblGymTimerTitleLabel setFrame: CGRectMake(0.0, 32.0, DEVICE_WIDTH, 30.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 30.0];
        [_lblGymTimerTitleLabel setFont: fontGymTimerLabel];
        
        //Login Signup background view
        [_viewLoginSignupBgView setFrame: CGRectMake(0.0, 100.0, DEVICE_WIDTH, DEVICE_HEIGHT + 100.0)];
        
        //Signup details view
        [_viewSignupContentView setFrame: CGRectMake(0.0, 18.0, _viewLoginSignupBgView.frame.size.width, (_viewLoginSignupBgView.frame.size.height - 18.0))];
        
        [_lblSignupTitleLabel setFrame: CGRectMake(34.0, 0.0, (DEVICE_WIDTH - 68.0), 60.0)];
        UIFont *fontLoginLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 36.0];
        UIFont *fontForFreeLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 18.0];
        NSDictionary *dicSignUpLabel = @{ NSForegroundColorAttributeName : cSTART_BUTTON,
                                          NSFontAttributeName : fontLoginLabel
                                          };
        NSAttributedString *attSignUpLabel = [[NSAttributedString alloc] initWithString: @"Sign Up" attributes: dicSignUpLabel];
        NSDictionary *dicForFreeLabel = @{ NSForegroundColorAttributeName : cSTART_BUTTON,
                                           NSFontAttributeName : fontForFreeLabel
                                           };
        NSAttributedString *attForFree = [[NSAttributedString alloc] initWithString: @"  (for FREE)" attributes: dicForFreeLabel];
        NSMutableAttributedString *attSignUpTitleLabel = [[NSMutableAttributedString alloc] init];
        [attSignUpTitleLabel appendAttributedString: attSignUpLabel];
        [attSignUpTitleLabel appendAttributedString: attForFree];
        [_lblSignupTitleLabel setAttributedText: attSignUpTitleLabel];
        
        UIFont *fontNameEmailPassword = [UIFont fontWithName: fFUTURA_MEDIUM size: 17.0];
        [_tfSignupNameTextField setFrame: CGRectMake(34.0, (_lblSignupTitleLabel.frame.origin.y + _lblSignupTitleLabel.frame.size.height + 10.0), (DEVICE_WIDTH - 34.0), 30.0)];
        [_tfSignupNameTextField setFont: fontNameEmailPassword];
        NSAttributedString *attNamePlaceholder = [[NSAttributedString alloc] initWithString: @" Full Name" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontNameEmailPassword}];
        [_tfSignupNameTextField setAttributedPlaceholder: attNamePlaceholder];
        [_viewSignupNameUnderlineView setFrame: CGRectMake(34.0, (_tfSignupNameTextField.frame.origin.y + _tfSignupNameTextField.frame.size.height + 1.0), (DEVICE_WIDTH - 34.0), 2.0)];
        
        [_tfSignupEmailTextField setFrame: CGRectMake(34.0, (_viewSignupNameUnderlineView.frame.origin.y + _viewSignupNameUnderlineView.frame.size.height + 10.0), (DEVICE_WIDTH - 34.0), 30.0)];
        [_tfSignupEmailTextField setFont: fontNameEmailPassword];
        NSAttributedString *attEmailPlaceholder = [[NSAttributedString alloc] initWithString: @" Email" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontNameEmailPassword}];
        [_tfSignupEmailTextField setAttributedPlaceholder: attEmailPlaceholder];
        [_viewSignupEmailUnderlineView setFrame: CGRectMake(34.0, (_tfSignupEmailTextField.frame.origin.y + _tfSignupEmailTextField.frame.size.height + 1.0), (DEVICE_WIDTH - 34.0), 2.0)];
        
        [_tfSignupPasswordTextField setFrame: CGRectMake(34.0, (_viewSignupEmailUnderlineView.frame.origin.y + _viewSignupEmailUnderlineView.frame.size.height + 10.0), (DEVICE_WIDTH - 34.0), 30.0)];
        [_tfSignupPasswordTextField setFont: fontNameEmailPassword];
        NSAttributedString *attPasswordPlaceholder = [[NSAttributedString alloc] initWithString: @" Password" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontNameEmailPassword}];
        [_tfSignupPasswordTextField setAttributedPlaceholder: attPasswordPlaceholder];
        [_viewSignupPasswordUnderlineView setFrame: CGRectMake(34.0, (_tfSignupPasswordTextField.frame.origin.y + _tfSignupPasswordTextField.frame.size.height + 1.0), (DEVICE_WIDTH - 34.0), 2.0)];
        
        [_viewLoginButtonContentView setFrame: CGRectMake(75.0, (_viewSignupPasswordUnderlineView.frame.origin.y + _viewSignupPasswordUnderlineView.frame.size.height + 4.0), DEVICE_WIDTH, 30.0)];
        [_viewLoginButtonContentView setBackgroundColor: UIColor.clearColor];
        [_lblAlreadyMemberLabel setFrame: CGRectMake(0.0, 1.0, (DEVICE_WIDTH - 165.0), 30.0)];
        UIFont *fontNewHereLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 12.0];
        [_lblAlreadyMemberLabel setFont: fontNewHereLabel];
        [_lblAlreadyMemberLabel setTextColor: UIColor.grayColor];
        [_btnLoginButton setFrame: CGRectMake((DEVICE_WIDTH - 155.0), 1.0, 60.0, 30.0)];
        UIFont *fontSignUpButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 16.0];
        NSDictionary *attSignUpButton = @{ NSForegroundColorAttributeName : cSTART_BUTTON,
                                           NSFontAttributeName : fontSignUpButton
                                           };
        NSAttributedString *attSignUp = [[NSAttributedString alloc] initWithString: @"Log In" attributes: attSignUpButton];
        [_btnLoginButton setAttributedTitle: attSignUp forState: UIControlStateNormal];
        
        /*------------------------------------------------------------------------------------*/
        
        //Login details view
        [_viewLoginContentView setFrame: CGRectMake(DEVICE_WIDTH, 18.0, _viewLoginSignupBgView.frame.size.width, (_viewLoginSignupBgView.frame.size.height - 18.0))];
        
        [_lblLoginTitleLabel setFrame: CGRectMake(34.0, 0.0, (DEVICE_WIDTH - 68.0), 60.0)];
        UIFont *fontLoginTitleLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 34.0];
        [_lblLoginTitleLabel setFont: fontLoginTitleLabel];
        
        UIFont *fontEmailPassword = [UIFont fontWithName: fFUTURA_MEDIUM size: 17.0];
        [_tfLoginEmailTextField setFrame: CGRectMake(34.0, (_lblLoginTitleLabel.frame.origin.y + _lblLoginTitleLabel.frame.size.height + 20.0), (DEVICE_WIDTH - 34.0), 30.0)];
        [_tfLoginEmailTextField setFont: fontEmailPassword];
        NSAttributedString *attLoginEmailPlaceholder = [[NSAttributedString alloc] initWithString: @" Email" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontEmailPassword}];
        [_tfLoginEmailTextField setAttributedPlaceholder: attLoginEmailPlaceholder];
        [_viewLoginEmailUnderlineView setFrame: CGRectMake(34.0, (_tfLoginEmailTextField.frame.origin.y + _tfLoginEmailTextField.frame.size.height + 1.0), (DEVICE_WIDTH - 34.0), 2.0)];
        
        [_tfLoginPasswordTextField setFrame: CGRectMake(34.0, (_viewLoginEmailUnderlineView.frame.origin.y + _viewLoginEmailUnderlineView.frame.size.height + 10.0), (DEVICE_WIDTH - 34.0), 30.0)];
        [_tfLoginPasswordTextField setFont: fontEmailPassword];
        NSAttributedString *attLoginPasswordPlaceholder = [[NSAttributedString alloc] initWithString: @" Password" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontEmailPassword}];
        [_tfLoginPasswordTextField setAttributedPlaceholder: attLoginPasswordPlaceholder];
        [_viewLoginPasswordUnderlineView setFrame: CGRectMake(34.0, (_tfLoginPasswordTextField.frame.origin.y + _tfLoginPasswordTextField.frame.size.height + 0.0), (DEVICE_WIDTH - 34.0), 2.0)];
        
        [_btnForgotPasswordButton setFrame: CGRectMake(32.0, (_viewLoginPasswordUnderlineView.frame.origin.y + _viewLoginPasswordUnderlineView.frame.size.height + 2.0), (DEVICE_WIDTH - 32.0), 30.0)];
        UIFont *fontForgotButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 11];
        NSDictionary *attForgotButton = @{ NSForegroundColorAttributeName : UIColor.blackColor,
                                           NSFontAttributeName : fontForgotButton
                                           };
        NSAttributedString *att = [[NSAttributedString alloc] initWithString: @"Forgot password?" attributes: attForgotButton];
        [_btnForgotPasswordButton setAttributedTitle: att forState: UIControlStateNormal];
        [_btnForgotPasswordButton setAlpha: 0.7];
        
        [_viewSignupButtonContentView setFrame: CGRectMake(75.0, (_btnForgotPasswordButton.frame.origin.y + _btnForgotPasswordButton.frame.size.height + 8.0), DEVICE_WIDTH, 30.0)];
        [_viewSignupButtonContentView setBackgroundColor: UIColor.clearColor];
        [_lblAreYouNewHereLabel setFrame: CGRectMake(0.0, 0.0, (DEVICE_WIDTH - 172.0), 30.0)];
        UIFont *fontLoginNewHereLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 12.0];
        [_lblAreYouNewHereLabel setFont: fontLoginNewHereLabel];
        [_lblAreYouNewHereLabel setTextColor: UIColor.grayColor];
        [_btnSignUpButton setFrame: CGRectMake((DEVICE_WIDTH - 162.0), 0.0, 60.0, 30.0)];
        UIFont *fontLoginSignUpButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 16.0];
        NSDictionary *attLoginSignUpButton = @{ NSForegroundColorAttributeName : cSTART_BUTTON,
                                                NSFontAttributeName : fontLoginSignUpButton
                                                };
        NSAttributedString *attLoginSignUp = [[NSAttributedString alloc] initWithString: @"Sign Up" attributes: attLoginSignUpButton];
        [_btnSignUpButton setAttributedTitle: attLoginSignUp forState: UIControlStateNormal];
        
        
        //Start button
        [_btnStartButton setFrame: CGRectMake(56.0, (_viewSignupButtonContentView.frame.origin.y + _viewSignupButtonContentView.frame.size.height + 10.0 + 112.0), (DEVICE_WIDTH - 116.0), 54.0)];
        [_btnStartButton setBackgroundColor: cSTART_BUTTON_BLACK];
        UIFont *fontStartButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 25.0];
        NSDictionary *dicStartButton = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                          NSFontAttributeName : fontStartButton
                                          };
        NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"START" attributes: dicStartButton];
        [_btnStartButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
        [[_btnStartButton layer] setCornerRadius: 16.0];
        
    } else {
        
        //Gym timer title label
        [_lblGymTimerTitleLabel setFrame: CGRectMake(0.0, 32.0, DEVICE_WIDTH, 30.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 28.0];
        [_lblGymTimerTitleLabel setFont: fontGymTimerLabel];
        
        //Login Signup background view
        [_viewLoginSignupBgView setFrame: CGRectMake(0.0, 100.0, DEVICE_WIDTH, DEVICE_HEIGHT + 100.0)];
        
        //Signup details view
        [_viewSignupContentView setFrame: CGRectMake(0.0, 16.0, _viewLoginSignupBgView.frame.size.width, (_viewLoginSignupBgView.frame.size.height - 16.0))];
        
        [_lblSignupTitleLabel setFrame: CGRectMake(32.0, 0.0, (DEVICE_WIDTH - 64.0), 60.0)];
        UIFont *fontLoginLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 34.0];
        UIFont *fontForFreeLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 16.0];
        NSDictionary *dicSignUpLabel = @{ NSForegroundColorAttributeName : cSTART_BUTTON,
                                          NSFontAttributeName : fontLoginLabel
                                          };
        NSAttributedString *attSignUpLabel = [[NSAttributedString alloc] initWithString: @"Sign Up" attributes: dicSignUpLabel];
        NSDictionary *dicForFreeLabel = @{ NSForegroundColorAttributeName : cSTART_BUTTON,
                                           NSFontAttributeName : fontForFreeLabel
                                           };
        NSAttributedString *attForFree = [[NSAttributedString alloc] initWithString: @"  (for FREE)" attributes: dicForFreeLabel];
        NSMutableAttributedString *attSignUpTitleLabel = [[NSMutableAttributedString alloc] init];
        [attSignUpTitleLabel appendAttributedString: attSignUpLabel];
        [attSignUpTitleLabel appendAttributedString: attForFree];
        [_lblSignupTitleLabel setAttributedText: attSignUpTitleLabel];
        
        UIFont *fontNameEmailPassword = [UIFont fontWithName: fFUTURA_MEDIUM size: 16.0];
        [_tfSignupNameTextField setFrame: CGRectMake(32.0, (_lblSignupTitleLabel.frame.origin.y + _lblSignupTitleLabel.frame.size.height + 8.0), (DEVICE_WIDTH - 32.0), 30.0)];
        [_tfSignupNameTextField setFont: fontNameEmailPassword];
        NSAttributedString *attNamePlaceholder = [[NSAttributedString alloc] initWithString: @" Full Name" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontNameEmailPassword}];
        [_tfSignupNameTextField setAttributedPlaceholder: attNamePlaceholder];
        [_viewSignupNameUnderlineView setFrame: CGRectMake(32.0, (_tfSignupNameTextField.frame.origin.y + _tfSignupNameTextField.frame.size.height + 0.0), (DEVICE_WIDTH - 32.0), 2.0)];
        
        [_tfSignupEmailTextField setFrame: CGRectMake(32.0, (_viewSignupNameUnderlineView.frame.origin.y + _viewSignupNameUnderlineView.frame.size.height + 8.0), (DEVICE_WIDTH - 32.0), 30.0)];
        [_tfSignupEmailTextField setFont: fontNameEmailPassword];
        NSAttributedString *attEmailPlaceholder = [[NSAttributedString alloc] initWithString: @" Email" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontNameEmailPassword}];
        [_tfSignupEmailTextField setAttributedPlaceholder: attEmailPlaceholder];
        [_viewSignupEmailUnderlineView setFrame: CGRectMake(32.0, (_tfSignupEmailTextField.frame.origin.y + _tfSignupEmailTextField.frame.size.height + 0.0), (DEVICE_WIDTH - 32.0), 2.0)];
        
        [_tfSignupPasswordTextField setFrame: CGRectMake(32.0, (_viewSignupEmailUnderlineView.frame.origin.y + _viewSignupEmailUnderlineView.frame.size.height + 8.0), (DEVICE_WIDTH - 32.0), 30.0)];
        [_tfSignupPasswordTextField setFont: fontNameEmailPassword];
        NSAttributedString *attPasswordPlaceholder = [[NSAttributedString alloc] initWithString: @" Password" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontNameEmailPassword}];
        [_tfSignupPasswordTextField setAttributedPlaceholder: attPasswordPlaceholder];
        [_viewSignupPasswordUnderlineView setFrame: CGRectMake(32.0, (_tfSignupPasswordTextField.frame.origin.y + _tfSignupPasswordTextField.frame.size.height + 0.0), (DEVICE_WIDTH - 32.0), 2.0)];
        
        [_viewLoginButtonContentView setFrame: CGRectMake(70.0, (_viewSignupPasswordUnderlineView.frame.origin.y + _viewSignupPasswordUnderlineView.frame.size.height + 4.0), DEVICE_WIDTH, 30.0)];
        [_viewLoginButtonContentView setBackgroundColor: UIColor.clearColor];
        [_lblAlreadyMemberLabel setFrame: CGRectMake(0.0, 1.0, (DEVICE_WIDTH - 137.0), 30.0)];
        UIFont *fontNewHereLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 11.0];
        [_lblAlreadyMemberLabel setFont: fontNewHereLabel];
        [_lblAlreadyMemberLabel setTextColor: UIColor.grayColor];
        [_btnLoginButton setFrame: CGRectMake((DEVICE_WIDTH - 127.0), 1.0, 60.0, 30.0)];
        UIFont *fontSignUpButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 14.0];
        NSDictionary *attSignUpButton = @{ NSForegroundColorAttributeName : cSTART_BUTTON,
                                           NSFontAttributeName : fontSignUpButton
                                           };
        NSAttributedString *attSignUp = [[NSAttributedString alloc] initWithString: @"Log In" attributes: attSignUpButton];
        [_btnLoginButton setAttributedTitle: attSignUp forState: UIControlStateNormal];
        
        /*------------------------------------------------------------------------------------*/
        
        //Login details view
        [_viewLoginContentView setFrame: CGRectMake(DEVICE_WIDTH, 16.0, _viewLoginSignupBgView.frame.size.width, (_viewLoginSignupBgView.frame.size.height - 16.0))];
        
        [_lblLoginTitleLabel setFrame: CGRectMake(32.0, 0.0, (DEVICE_WIDTH - 64.0), 60.0)];
        UIFont *fontLoginTitleLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 34.0];
        [_lblLoginTitleLabel setFont: fontLoginTitleLabel];
        
        UIFont *fontEmailPassword = [UIFont fontWithName: fFUTURA_MEDIUM size: 16.0];
        [_tfLoginEmailTextField setFrame: CGRectMake(32.0, (_lblLoginTitleLabel.frame.origin.y + _lblLoginTitleLabel.frame.size.height + 16.0), (DEVICE_WIDTH - 32.0), 30.0)];
        [_tfLoginEmailTextField setFont: fontEmailPassword];
        NSAttributedString *attLoginEmailPlaceholder = [[NSAttributedString alloc] initWithString: @" Email" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontEmailPassword}];
        [_tfLoginEmailTextField setAttributedPlaceholder: attLoginEmailPlaceholder];
        [_viewLoginEmailUnderlineView setFrame: CGRectMake(32.0, (_tfLoginEmailTextField.frame.origin.y + _tfLoginEmailTextField.frame.size.height + 0.0), (DEVICE_WIDTH - 32.0), 2.0)];
        
        [_tfLoginPasswordTextField setFrame: CGRectMake(32.0, (_viewLoginEmailUnderlineView.frame.origin.y + _viewLoginEmailUnderlineView.frame.size.height + 10.0), (DEVICE_WIDTH - 32.0), 30.0)];
        [_tfLoginPasswordTextField setFont: fontEmailPassword];
        NSAttributedString *attLoginPasswordPlaceholder = [[NSAttributedString alloc] initWithString: @" Password" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontEmailPassword}];
        [_tfLoginPasswordTextField setAttributedPlaceholder: attLoginPasswordPlaceholder];
        [_viewLoginPasswordUnderlineView setFrame: CGRectMake(32.0, (_tfLoginPasswordTextField.frame.origin.y + _tfLoginPasswordTextField.frame.size.height + 0.0), (DEVICE_WIDTH - 32.0), 2.0)];
        
        [_btnForgotPasswordButton setFrame: CGRectMake(32.0, (_viewLoginPasswordUnderlineView.frame.origin.y + _viewLoginPasswordUnderlineView.frame.size.height + 2.0), (DEVICE_WIDTH - 32.0), 30.0)];
        UIFont *fontForgotButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 10];
        NSDictionary *attForgotButton = @{ NSForegroundColorAttributeName : UIColor.blackColor,
                                           NSFontAttributeName : fontForgotButton
                                           };
        NSAttributedString *att = [[NSAttributedString alloc] initWithString: @"Forgot password?" attributes: attForgotButton];
        [_btnForgotPasswordButton setAttributedTitle: att forState: UIControlStateNormal];
        [_btnForgotPasswordButton setAlpha: 0.7];
        
        [_viewSignupButtonContentView setFrame: CGRectMake(70.0, (_btnForgotPasswordButton.frame.origin.y + _btnForgotPasswordButton.frame.size.height + 4.0), DEVICE_WIDTH, 30.0)];
        [_viewSignupButtonContentView setBackgroundColor: UIColor.clearColor];
        [_lblAreYouNewHereLabel setFrame: CGRectMake(0.0, 0.0, (DEVICE_WIDTH - 148.0), 30.0)];
        UIFont *fontLoginNewHereLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 10.0];
        [_lblAreYouNewHereLabel setFont: fontLoginNewHereLabel];
        [_lblAreYouNewHereLabel setTextColor: UIColor.grayColor];
        [_btnSignUpButton setFrame: CGRectMake((DEVICE_WIDTH - 138.0), 0.0, 60.0, 30.0)];
        UIFont *fontLoginSignUpButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 14.0];
        NSDictionary *attLoginSignUpButton = @{ NSForegroundColorAttributeName : cSTART_BUTTON,
                                                NSFontAttributeName : fontLoginSignUpButton
                                                };
        NSAttributedString *attLoginSignUp = [[NSAttributedString alloc] initWithString: @"Sign Up" attributes: attLoginSignUpButton];
        [_btnSignUpButton setAttributedTitle: attLoginSignUp forState: UIControlStateNormal];
        
        
        //Start button
        [_btnStartButton setFrame: CGRectMake(56.0, (_viewSignupButtonContentView.frame.origin.y + _viewSignupButtonContentView.frame.size.height + 10.0 + 108.0), (DEVICE_WIDTH - 116.0), 48.0)];
        [_btnStartButton setBackgroundColor: cSTART_BUTTON_BLACK];
        UIFont *fontStartButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 24.0];
        NSDictionary *dicStartButton = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                          NSFontAttributeName : fontStartButton
                                          };
        NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"START" attributes: dicStartButton];
        [_btnStartButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
        [[_btnStartButton layer] setCornerRadius: 16.0];
        
    }
    
}

- (void) initializeData {
    
    serviceManager = [[ServiceManager alloc] init];
    [serviceManager setDelegate: self];
    
    utils = [[Utils alloc] init];
    progressHUD = [utils prototypeHUD];
    
    [_tfSignupNameTextField resignFirstResponder];
    [_tfSignupNameTextField becomeFirstResponder];
    
    isSignup = @"YES";
    
    audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory: AVAudioSessionCategoryPlayback error: &err];
    urlBeepAudio = [NSURL URLWithString: @"file:///System/Library/Audio/UISounds/beep-beep.caf"];
    AudioServicesCreateSystemSoundID((__bridge_retained CFURLRef) urlBeepAudio, &soundID);
    
}

- (BOOL) isValidForSignup {
    
    if ([[Utils trimString: [_tfSignupNameTextField text]] isEqualToString: @""]) {
        
        [Utils showToast: @"Please enter your name." duration: 3.0];
        return NO;
        
    } else if ([[Utils trimString: [_tfSignupEmailTextField text]] isEqualToString: @""]) {
        
        [Utils showToast: @"Please enter your Email." duration: 3.0];
        return NO;
        
    } else if (![Utils IsValidEmail: [_tfSignupEmailTextField text]]) {
        
        [Utils showToast: @"Please enter valid email." duration: 3.0];
        return NO;
        
    } else if ([[Utils trimString: [_tfSignupPasswordTextField text]] isEqualToString: @""]) {
        
        [Utils showToast: @"Please enter your password." duration: 3.0];
        return NO;
        
    } else {
        return YES;
    }
    
}

- (BOOL) isValidForLogin {
    
    if ([[Utils trimString: [_tfLoginEmailTextField text]] isEqualToString: @""]) {
        
        [Utils showToast: @"Please enter your Email." duration: 3.0];
        return NO;
        
    } else if (![Utils IsValidEmail: [_tfLoginEmailTextField text]]) {
        
        [Utils showToast: @"Please enter valid email." duration: 3.0];
        return NO;
        
    } else if ([[Utils trimString: [_tfLoginPasswordTextField text]] isEqualToString: @""]) {
        
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
                                     @{ @"name" : [_tfSignupNameTextField text] },
                                     @{ @"email" : [_tfSignupEmailTextField text] },
                                     @{ @"password" : [_tfSignupPasswordTextField text] },
                                     @{ @"device_type" : @"I" },
                                     @{ @"device_token" : strDeviceToken },
                                     @{ @"timezone" : [Utils getLocalTimeZone] },
                                     @{ @"mobile" : @"" },
                                     @{ @"gender" : @"" }
                                     ];
        
        if ([Utils isConnectedToInternet]) {
            
            [self hideScreenContents];
            spinner = [Utils showActivityIndicatorInView: _viewLoginSignupBgView];
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
                                    @{ @"email" : [_tfLoginEmailTextField text]},
                                    @{ @"password" : [_tfLoginPasswordTextField text]},
                                    @{ @"device_type" : @"I"},
                                    @{ @"device_token" : strDeviceToken},
                                    @{ @"receipt-data": receiptData},
                                    @{ @"password2": kSharedSecret},
                                    @{ @"isSandbox": sandboxStatus}
                                    ];
        
        if ([Utils isConnectedToInternet]) {
            
            [self hideScreenContents];
            spinner = [Utils showActivityIndicatorInView: _viewLoginSignupBgView];
            NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uLOGIN];
            [serviceManager callWebServiceWithPOST: webpath withTag: tLOGIN params: arrLoginParams];
            
        } 
        
    }
    
}

- (void) showScreenContents {
    
    [_viewSignupContentView setHidden: NO];
    [_viewLoginContentView setHidden: NO];
    [_btnStartButton setHidden: NO];
    
}

- (void) hideScreenContents {
    
    [_viewSignupContentView setHidden: YES];
    [_viewLoginContentView setHidden: YES];
    [_btnStartButton setHidden: YES];
    
}

- (void) clearSignupPasswordFields {
    [_tfSignupPasswordTextField setText: @""];
    [_tfSignupPasswordTextField becomeFirstResponder];
}

- (void) clearLoginPasswordFields {
    [_tfLoginPasswordTextField setText: @""];
    [_tfLoginPasswordTextField becomeFirstResponder];
}

- (void) handleShowLoginScreenNotification: (NSNotification *) notification {
    isFromShowLoginScreenNotification = @"YES";
}


//MARK:- Service manager delegate and parser methods

- (void) webServiceCallFailure: (NSError *) error forTag: (NSString *) tagname {
    NSLog(@"Web service call fails : %@", [error localizedDescription]);
//    [progressHUD dismissAnimated: YES];
    [Utils hideActivityIndicator:spinner fromView:_viewLoginSignupBgView];
    [Utils showToast: [error localizedDescription] duration: 3.0];
}

- (void) webServiceCallSuccess: (id) response forTag: (NSString *) tagname {
    
    if ([tagname isEqualToString: tSIGNUP]) {
        [self parseSignUpResponse: response];
    } else if ([tagname isEqualToString: tLOGIN]) {
        [self parseLoginResponse: response];
    }
    
}

- (void) parseSignUpResponse: (id) response {
    
    [Utils hideActivityIndicator:spinner fromView:_viewLoginSignupBgView];
    [self showScreenContents];
    
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    
    if ([[dicResponse valueForKey:@"status"] integerValue] == 1) {
        
        [_tfSignupNameTextField setText: @""];
        [_tfSignupEmailTextField setText: @""];
        [_tfSignupPasswordTextField setText: @""];
        
        [self.view endEditing: YES];
        
        NSMutableDictionary *dicUserData = [dicResponse valueForKey:@"data"];
        [Utils setUserDetails: dicUserData];
        
        [[NSUserDefaults standardUserDefaults] setValue: @"YES" forKey: kIS_USER_LOGGED_IN];
        HomeScreenViewController *homeScreenVC = GETCONTROLLER(@"HomeScreenViewController");
        [[self navigationController] pushViewController: homeScreenVC animated: YES];
        
    } else {
        [Utils showToast: [dicResponse valueForKey: @"message"] duration: 3.0];
    }
    
}

- (void)parseLoginResponse:(id)response {
    
    //[progressHUD dismissAnimated: YES];
    [Utils hideActivityIndicator:spinner fromView:_viewLoginSignupBgView];
    [self showScreenContents];
    
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    
    if ([[dicResponse valueForKey:@"status"] integerValue] == 1) {
        
        [_tfLoginEmailTextField setText: @""];
        [_tfLoginEmailTextField setText: @""];
        
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
        
        [[NSUserDefaults standardUserDefaults] setValue: @"YES" forKey: kIS_USER_LOGGED_IN];
        HomeScreenViewController *homeScreenVC = GETCONTROLLER(@"HomeScreenViewController");
        [[self navigationController] pushViewController: homeScreenVC animated: YES];
        
    } else {
        [Utils showToast: [dicResponse valueForKey: @"message"] duration: 3.0];
    }
    
}


@end
