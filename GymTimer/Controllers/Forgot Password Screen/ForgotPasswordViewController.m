//
//  ForgotPasswordViewController.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 25/04/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "CommonImports.h"

@interface ForgotPasswordViewController () <ServiceManagerDelegate, UITextFieldDelegate>
{
    
    ServiceManager *serviceManager;
    Utils *utils;
    JGProgressHUD *progressHUD;
    UIActivityIndicatorView *spinner;
    
}
@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLayout];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self initializeData];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    
    [_tfEmailTextField setText: @""];
    
}



//MARK:- Button's action methods

- (IBAction)btnRequestNewOneButtonTapped:(UIButton *)sender {
    [[self view] endEditing: YES];
    [self callForgotPasswordAPI];
}

- (IBAction)btnCancelButtonTapped:(UIButton *)sender {
    [[self view] endEditing: YES];
    [self dismissViewControllerAnimated: NO completion: nil];
    //[[self navigationController] popViewControllerAnimated: NO];
}


//MARK:- UItextfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [[self view] endEditing: YES];
    return YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSString *lastChar = [string substringFromIndex: [string length] - (string.length > 0)];
    NSString *strFinalString = ([lastChar isEqualToString: @" "]) ? [string substringToIndex: string.length - (string.length > 0)] : string;

    if ([textField isEqual: _tfEmailTextField]) {
        
        if ([string length] <= 1) {
            return YES;
        } else {
            [_tfEmailTextField setText: strFinalString];
            [_tfEmailTextField resignFirstResponder];
            return NO;
        }
        
    } else {}

    return YES;

}


//MARK:- User-defined methods

- (void) setupLayout {
    
    [self showScreenContents];
    
    //Gym timer title label
    [_lblGymTimerTitleLabel setTextColor: cGYM_TIMER_LABEL];
    [_lblGymTimerTitleLabel setAlpha: 1.0];
    
    //Login Signup background view
    [_viewForgotPasswordContentView setClipsToBounds: YES];
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: [_viewForgotPasswordContentView bounds] byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){30.0, 30.}].CGPath;
    [[_viewForgotPasswordContentView layer] setMask: maskLayer];
    
    [_lblForgotYourPasswordLabel setTextColor: cSTART_BUTTON];
    
    [_tfEmailTextField setDelegate: self];
    [_tfEmailTextField setAutocorrectionType: UITextAutocorrectionTypeNo];
    [_tfEmailTextField setTintColor: cSTART_BUTTON];
    [_tfEmailTextField setAttributedPlaceholder: [[NSAttributedString alloc] initWithString: @" Email"]];
    [_viewEmailUnderlineView setBackgroundColor: cSTART_BUTTON];
    
    //Start button
    [_btnRequestNewOneButton setClipsToBounds: YES];
    [_btnCancelButton setClipsToBounds: YES];
    [[_btnCancelButton layer] setCornerRadius: 22.0];
    
    if (IS_IPHONEXR) {
        
        //Gym timer title label
        [_lblGymTimerTitleLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblGymTimerTitleLabel setFont: fontGymTimerLabel];
        
        //Forgot password content view
        [_viewForgotPasswordContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        //Login title
        [_lblForgotYourPasswordLabel setFrame: CGRectMake(41.0, 32.0, (DEVICE_WIDTH - 72.0), 102.0)];
        UIFont *fontLoginLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0];
        [_lblForgotYourPasswordLabel setFont: fontLoginLabel];
        
        //Email and password
        UIFont *fontEmailPassword = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
        [_tfEmailTextField setFrame: CGRectMake(41.0, (_lblForgotYourPasswordLabel.frame.origin.y + _lblForgotYourPasswordLabel.frame.size.height + 40.0), (DEVICE_WIDTH - 41.0), 30.0)];
        [_tfEmailTextField setFont: fontEmailPassword];
        NSAttributedString *attEmailPlaceholder = [[NSAttributedString alloc] initWithString: @" Email" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontEmailPassword}];
        [_tfEmailTextField setAttributedPlaceholder: attEmailPlaceholder];
        [_viewEmailUnderlineView setFrame: CGRectMake(41.0, (_tfEmailTextField.frame.origin.y + _tfEmailTextField.frame.size.height + 4.0), (DEVICE_WIDTH - 41.0), 2.0)];
        
        //Request new password button  +68.0
        [_btnRequestNewOneButton setFrame: CGRectMake(58.0, (_viewEmailUnderlineView.frame.origin.y + _viewEmailUnderlineView.frame.size.height + 28.0), (DEVICE_WIDTH - 116.0), 60.0)];
        [_btnRequestNewOneButton setBackgroundColor: cSTART_BUTTON_BLACK];
        UIFont *fontStartButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 20.0];
        NSDictionary *dicStartButton = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                          NSFontAttributeName : fontStartButton
                                          };
        NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"Request a new one" attributes: dicStartButton];
        [_btnRequestNewOneButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
        [[_btnRequestNewOneButton layer] setCornerRadius: 22.0];
        
        //Cancel button
        [_btnCancelButton setFrame: CGRectMake(58.0, (_btnRequestNewOneButton.frame.origin.y + _btnRequestNewOneButton.frame.size.height + 16.0), (DEVICE_WIDTH - 116.0), 60.0)];
        [_btnCancelButton setBackgroundColor: UIColor.whiteColor];
        UIFont *fontCancelButton = [UIFont fontWithName: fFUTURA_MEDIUM size: 17.0];
        NSDictionary *dicCancelButton = @{ NSForegroundColorAttributeName : UIColor.blackColor,
                                           NSFontAttributeName : fontCancelButton
                                           };
        NSAttributedString *attCancelButton = [[NSAttributedString alloc] initWithString: @"Cancel" attributes: dicCancelButton];
        [_btnCancelButton setAttributedTitle: attCancelButton forState: UIControlStateNormal];
        
        
    } else if (IS_IPHONEX) {
        
        //Gym timer title label
        [_lblGymTimerTitleLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblGymTimerTitleLabel setFont: fontGymTimerLabel];
        
        //Forgot password content view
        [_viewForgotPasswordContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        //Login title
        [_lblForgotYourPasswordLabel setFrame: CGRectMake(41.0, 32.0, (DEVICE_WIDTH - 72.0), 102.0)];
        UIFont *fontLoginLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0];
        [_lblForgotYourPasswordLabel setFont: fontLoginLabel];
        
        //Email and password
        UIFont *fontEmailPassword = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
        [_tfEmailTextField setFrame: CGRectMake(41.0, (_lblForgotYourPasswordLabel.frame.origin.y + _lblForgotYourPasswordLabel.frame.size.height + 40.0), (DEVICE_WIDTH - 41.0), 30.0)];
        [_tfEmailTextField setFont: fontEmailPassword];
        NSAttributedString *attEmailPlaceholder = [[NSAttributedString alloc] initWithString: @" Email" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontEmailPassword}];
        [_tfEmailTextField setAttributedPlaceholder: attEmailPlaceholder];
        [_viewEmailUnderlineView setFrame: CGRectMake(41.0, (_tfEmailTextField.frame.origin.y + _tfEmailTextField.frame.size.height + 4.0), (DEVICE_WIDTH - 41.0), 2.0)];
        
        //Request new password button  +68.0
        [_btnRequestNewOneButton setFrame: CGRectMake(58.0, (_viewEmailUnderlineView.frame.origin.y + _viewEmailUnderlineView.frame.size.height + 28.0), (DEVICE_WIDTH - 116.0), 60.0)];
        [_btnRequestNewOneButton setBackgroundColor: cSTART_BUTTON_BLACK];
        UIFont *fontStartButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 20.0];
        NSDictionary *dicStartButton = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                          NSFontAttributeName : fontStartButton
                                          };
        NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"Request a new one" attributes: dicStartButton];
        [_btnRequestNewOneButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
        [[_btnRequestNewOneButton layer] setCornerRadius: 22.0];
        
        //Cancel button
        [_btnCancelButton setFrame: CGRectMake(58.0, (_btnRequestNewOneButton.frame.origin.y + _btnRequestNewOneButton.frame.size.height + 16.0), (DEVICE_WIDTH - 116.0), 60.0)];
        [_btnCancelButton setBackgroundColor: UIColor.whiteColor];
        UIFont *fontCancelButton = [UIFont fontWithName: fFUTURA_MEDIUM size: 17.0];
        NSDictionary *dicCancelButton = @{ NSForegroundColorAttributeName : UIColor.blackColor,
                                          NSFontAttributeName : fontCancelButton
                                          };
        NSAttributedString *attCancelButton = [[NSAttributedString alloc] initWithString: @"Cancel" attributes: dicCancelButton];
        [_btnCancelButton setAttributedTitle: attCancelButton forState: UIControlStateNormal];
        
        
    } else if (IS_IPHONE8PLUS) {
        
        //Gym timer title label
        [_lblGymTimerTitleLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblGymTimerTitleLabel setFont: fontGymTimerLabel];
        
        //Forgot password content view
        [_viewForgotPasswordContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        //Login title
        [_lblForgotYourPasswordLabel setFrame: CGRectMake(41.0, 32.0, (DEVICE_WIDTH - 72.0), 102.0)];
        UIFont *fontLoginLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 40.0];
        [_lblForgotYourPasswordLabel setFont: fontLoginLabel];
        
        //Email and password
        UIFont *fontEmailPassword = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
        [_tfEmailTextField setFrame: CGRectMake(41.0, (_lblForgotYourPasswordLabel.frame.origin.y + _lblForgotYourPasswordLabel.frame.size.height + 40.0), (DEVICE_WIDTH - 41.0), 30.0)];
        [_tfEmailTextField setFont: fontEmailPassword];
        NSAttributedString *attEmailPlaceholder = [[NSAttributedString alloc] initWithString: @" Email" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontEmailPassword}];
        [_tfEmailTextField setAttributedPlaceholder: attEmailPlaceholder];
        [_viewEmailUnderlineView setFrame: CGRectMake(41.0, (_tfEmailTextField.frame.origin.y + _tfEmailTextField.frame.size.height + 4.0), (DEVICE_WIDTH - 41.0), 2.0)];
        
        //Request new password button  +68.0
        [_btnRequestNewOneButton setFrame: CGRectMake(58.0, (_viewEmailUnderlineView.frame.origin.y + _viewEmailUnderlineView.frame.size.height + 28.0), (DEVICE_WIDTH - 116.0), 60.0)];
        [_btnRequestNewOneButton setBackgroundColor: cSTART_BUTTON_BLACK];
        UIFont *fontStartButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 20.0];
        NSDictionary *dicStartButton = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                          NSFontAttributeName : fontStartButton
                                          };
        NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"Request a new one" attributes: dicStartButton];
        [_btnRequestNewOneButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
        [[_btnRequestNewOneButton layer] setCornerRadius: 22.0];
        
        //Cancel button
        [_btnCancelButton setFrame: CGRectMake(58.0, (_btnRequestNewOneButton.frame.origin.y + _btnRequestNewOneButton.frame.size.height + 16.0), (DEVICE_WIDTH - 116.0), 60.0)];
        [_btnCancelButton setBackgroundColor: UIColor.whiteColor];
        UIFont *fontCancelButton = [UIFont fontWithName: fFUTURA_MEDIUM size: 17.0];
        NSDictionary *dicCancelButton = @{ NSForegroundColorAttributeName : UIColor.blackColor,
                                           NSFontAttributeName : fontCancelButton
                                           };
        NSAttributedString *attCancelButton = [[NSAttributedString alloc] initWithString: @"Cancel" attributes: dicCancelButton];
        [_btnCancelButton setAttributedTitle: attCancelButton forState: UIControlStateNormal];
        
        
    } else if (IS_IPHONE8) {
        
        //Gym timer title label
        [_lblGymTimerTitleLabel setFrame: CGRectMake(0.0, 32.0, DEVICE_WIDTH, 30.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 28.0];
        [_lblGymTimerTitleLabel setFont: fontGymTimerLabel];
        
        //Forgot password content view
        [_viewForgotPasswordContentView setFrame: CGRectMake(0.0, 100.0, DEVICE_WIDTH, DEVICE_HEIGHT - 100.0)];
        
        //Login title
        [_lblForgotYourPasswordLabel setFrame: CGRectMake(32.0, 12.0, (DEVICE_WIDTH - 72.0), 102.0)];
        UIFont *fontLoginLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblForgotYourPasswordLabel setFont: fontLoginLabel];
        
        //Email and password
        UIFont *fontEmailPassword = [UIFont fontWithName: fFUTURA_MEDIUM size: 16.0];
        [_tfEmailTextField setFrame: CGRectMake(32.0, (_lblForgotYourPasswordLabel.frame.origin.y + _lblForgotYourPasswordLabel.frame.size.height + 26.0), (DEVICE_WIDTH - 32.0), 30.0)];
        [_tfEmailTextField setFont: fontEmailPassword];
        NSAttributedString *attEmailPlaceholder = [[NSAttributedString alloc] initWithString: @" Email" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontEmailPassword}];
        [_tfEmailTextField setAttributedPlaceholder: attEmailPlaceholder];
        [_viewEmailUnderlineView setFrame: CGRectMake(32.0, (_tfEmailTextField.frame.origin.y + _tfEmailTextField.frame.size.height + 0.0), (DEVICE_WIDTH - 32.0), 2.0)];
        
        //Request new password button  +68.0
        [_btnRequestNewOneButton setFrame: CGRectMake(56.0, (_viewEmailUnderlineView.frame.origin.y + _viewEmailUnderlineView.frame.size.height + 20.0), (DEVICE_WIDTH - 112.0), 48.0)];
        [_btnRequestNewOneButton setBackgroundColor: cSTART_BUTTON_BLACK];
        UIFont *fontStartButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 16.0];
        NSDictionary *dicStartButton = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                          NSFontAttributeName : fontStartButton
                                          };
        NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"Request a new one" attributes: dicStartButton];
        [_btnRequestNewOneButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
        [[_btnRequestNewOneButton layer] setCornerRadius: 18.0];
        
        //Cancel button
        [_btnCancelButton setFrame: CGRectMake(58.0, (_btnRequestNewOneButton.frame.origin.y + _btnRequestNewOneButton.frame.size.height + 10.0), (DEVICE_WIDTH - 116.0), 60.0)];
        [_btnCancelButton setBackgroundColor: UIColor.whiteColor];
        UIFont *fontCancelButton = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        NSDictionary *dicCancelButton = @{ NSForegroundColorAttributeName : UIColor.blackColor,
                                           NSFontAttributeName : fontCancelButton
                                           };
        NSAttributedString *attCancelButton = [[NSAttributedString alloc] initWithString: @"Cancel" attributes: dicCancelButton];
        [_btnCancelButton setAttributedTitle: attCancelButton forState: UIControlStateNormal];
        
    } else {
        
        //Gym timer title label
        [_lblGymTimerTitleLabel setFrame: CGRectMake(0.0, 32.0, DEVICE_WIDTH, 30.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 28.0];
        [_lblGymTimerTitleLabel setFont: fontGymTimerLabel];
        
        //Forgot password content view
        [_viewForgotPasswordContentView setFrame: CGRectMake(0.0, 100.0, DEVICE_WIDTH, DEVICE_HEIGHT - 100.0)];
        
        //Login title
        [_lblForgotYourPasswordLabel setFrame: CGRectMake(32.0, 12.0, (DEVICE_WIDTH - 72.0), 102.0)];
        UIFont *fontLoginLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblForgotYourPasswordLabel setFont: fontLoginLabel];
        
        //Email and password
        UIFont *fontEmailPassword = [UIFont fontWithName: fFUTURA_MEDIUM size: 16.0];
        [_tfEmailTextField setFrame: CGRectMake(32.0, (_lblForgotYourPasswordLabel.frame.origin.y + _lblForgotYourPasswordLabel.frame.size.height + 26.0), (DEVICE_WIDTH - 32.0), 30.0)];
        [_tfEmailTextField setFont: fontEmailPassword];
        NSAttributedString *attEmailPlaceholder = [[NSAttributedString alloc] initWithString: @" Email" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontEmailPassword}];
        [_tfEmailTextField setAttributedPlaceholder: attEmailPlaceholder];
        [_viewEmailUnderlineView setFrame: CGRectMake(32.0, (_tfEmailTextField.frame.origin.y + _tfEmailTextField.frame.size.height + 0.0), (DEVICE_WIDTH - 32.0), 2.0)];
        
        //Request new password button  +68.0
        [_btnRequestNewOneButton setFrame: CGRectMake(56.0, (_viewEmailUnderlineView.frame.origin.y + _viewEmailUnderlineView.frame.size.height + 20.0), (DEVICE_WIDTH - 112.0), 48.0)];
        [_btnRequestNewOneButton setBackgroundColor: cSTART_BUTTON_BLACK];
        UIFont *fontStartButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 16.0];
        NSDictionary *dicStartButton = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                          NSFontAttributeName : fontStartButton
                                          };
        NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"Request a new one" attributes: dicStartButton];
        [_btnRequestNewOneButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
        [[_btnRequestNewOneButton layer] setCornerRadius: 18.0];
        
        //Cancel button
        [_btnCancelButton setFrame: CGRectMake(58.0, (_btnRequestNewOneButton.frame.origin.y + _btnRequestNewOneButton.frame.size.height + 10.0), (DEVICE_WIDTH - 116.0), 60.0)];
        [_btnCancelButton setBackgroundColor: UIColor.whiteColor];
        UIFont *fontCancelButton = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        NSDictionary *dicCancelButton = @{ NSForegroundColorAttributeName : UIColor.blackColor,
                                           NSFontAttributeName : fontCancelButton
                                           };
        NSAttributedString *attCancelButton = [[NSAttributedString alloc] initWithString: @"Cancel" attributes: dicCancelButton];
        [_btnCancelButton setAttributedTitle: attCancelButton forState: UIControlStateNormal];
        
    }
    
}

- (void) initializeData {
    
    serviceManager = [[ServiceManager alloc] init];
    [serviceManager setDelegate: self];
    
    utils = [[Utils alloc] init];
    progressHUD = [utils prototypeHUD];
    
    [_tfEmailTextField becomeFirstResponder];
    
}

- (void) callForgotPasswordAPI {
    
    if ([[Utils trimString: [_tfEmailTextField text]] isEqualToString: @""]) {
        
        [Utils showToast: @"Please enter your email." duration: 3.0];
        return;
        
    } else if (![Utils IsValidEmail: [_tfEmailTextField text]]) {
        
        [Utils showToast: @"Please enter valid email." duration: 3.0];
        return;
        
    } else {}
    
    NSArray *arrForgotPasswordParams = @[
                                         @{ @"email" : [_tfEmailTextField text]}
                                         ];
    
    if ([Utils isConnectedToInternet]) {
        
        [self hideScreenContents];
        spinner = [Utils showActivityIndicatorInView: _viewForgotPasswordContentView];
        NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uFORGOT_PASSWORD];
        [serviceManager callWebServiceWithPOST: webpath withTag: tFORGOT_PASSWORD params: arrForgotPasswordParams];
        
    } 
    
}

- (void) showScreenContents {
    
    [_lblForgotYourPasswordLabel setHidden: NO];
    [_tfEmailTextField setHidden: NO];
    [_viewEmailUnderlineView setHidden: NO];
    [_btnRequestNewOneButton setHidden: NO];
    [_btnCancelButton setHidden: NO];
    
}

- (void) hideScreenContents {
    
    [_lblForgotYourPasswordLabel setHidden: YES];
    [_tfEmailTextField setHidden: YES];
    [_viewEmailUnderlineView setHidden: YES];
    [_btnRequestNewOneButton setHidden: YES];
    [_btnCancelButton setHidden: YES];
    
}


//MARK:- Service manager delegate and parser methods

- (void)webServiceCallFailure:(NSError *)error forTag:(NSString *)tagname {
    NSLog(@"Web service call fails : %@", [error localizedDescription]);
//    [progressHUD dismissAnimated: YES];
    [Utils hideActivityIndicator:spinner fromView:_viewForgotPasswordContentView];
    [Utils showToast: [error localizedDescription] duration: 3.0];
}

- (void)webServiceCallSuccess:(id)response forTag:(NSString *)tagname {
    
    if ([tagname isEqualToString: tFORGOT_PASSWORD]) {
        [self parseForgotPasswordResponse: response];
    }
    
}

- (void) parseForgotPasswordResponse: (id) response {
    
//    [progressHUD dismissAnimated: YES];
    [Utils hideActivityIndicator:spinner fromView:_viewForgotPasswordContentView];
    [self showScreenContents];
    
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    [Utils showToast: [dicResponse valueForKey: @"message"] duration: 3.0];
    
    if ([[dicResponse valueForKey:@"status"] integerValue] == 1) {
        
        [self dismissViewControllerAnimated: NO completion: nil];
        [[NSNotificationCenter defaultCenter] postNotificationName: @"ShowLoginScreen" object: nil];
        //[[self navigationController] popViewControllerAnimated: NO];
        
    } else {}
    
}



@end
