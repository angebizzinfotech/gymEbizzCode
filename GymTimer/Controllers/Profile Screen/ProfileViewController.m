//
//  ProfileViewController.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 18/04/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "ProfileViewController.h"
#import "CommonImports.h"
@import SDWebImage;
@import Photos;

@interface ProfileViewController () <UITabBarControllerDelegate, UIScrollViewDelegate, UITextFieldDelegate, ServiceManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    
    ServiceManager *serviceManager;
    Utils *utils;
    UIActivityIndicatorView *spinner;
    CGFloat currentScrollViewYOffset;
    CGRect keyboardFrame;
    NSMutableDictionary *dicUserDetails;
    NSString *isKeyboardOpen;
    
}
@end

@implementation ProfileViewController


//MARK:- View's life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(handleKeyboardWillShowNotification:) name: UIKeyboardWillShowNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(handleKeyboardWillHideNotification:) name: UIKeyboardWillHideNotification object: nil];
    
    [self setupLayout];
    
    dicUserDetails = [Utils getUserDetails];
    NSString *profileUrl = [dicUserDetails valueForKey:@"profile_pic"];
    [self.imgProfile sd_setImageWithURL:[NSURL URLWithString:profileUrl] placeholderImage:[UIImage imageNamed:@"Component 8 – 1"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self initializeData];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self name: UIKeyboardWillShowNotification object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self name: UIKeyboardWillHideNotification object: nil];
}

//MARK:- Button's action methods

- (IBAction)btnProfileUpdateButtonTapped:(UIButton *)sender {
    
    [self.view endEditing: YES];
    [UIView animateWithDuration: 0.4 delay: 0.0 options: UIViewAnimationOptionTransitionNone animations:^{
        [self->_scrollViewProfileScreen setContentOffset: CGPointMake(0.0, -44.0) animated: NO];
    } completion:^(BOOL finished) {
        [self callUpdateProfileAPI];
    }];
    
}

- (IBAction)btnBackButtonTapped:(UIButton *)sender {
    [[self navigationController] popViewControllerAnimated: YES];
//    NSMutableArray *arrTabbarVC = [[[self tabBarController] viewControllers] mutableCopy];
//    [arrTabbarVC setObject: GETCONTROLLER(@"SettingsViewController") atIndexedSubscript: 2];
//    [[self tabBarController] setViewControllers: arrTabbarVC animated: NO];
}

- (IBAction)addProfileAction:(UIButton *)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    UIAlertController *profileAlert = [UIAlertController alertControllerWithTitle:@"" message:@"Select any one option for set profile picture" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [profileAlert addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        } else {
            NSLog(@"Camera not found.");
        }
    }]];
    
    [profileAlert addAction:[UIAlertAction actionWithTitle:@"Photos" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }]];
    
    [profileAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:profileAlert animated:YES completion:nil];
}

//MARK:- UIScrollView's delegate methods

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    NSLog(@"Y : %f", [scrollView contentOffset].y);
//
//    if ([isKeyboardOpen isEqualToString: @"NO"]) {
//
//        CGFloat nextScrollViewYOffset = [scrollView contentOffset].y;
//        if ((nextScrollViewYOffset > -44.0) && (nextScrollViewYOffset > currentScrollViewYOffset)) {
//            currentScrollViewYOffset = nextScrollViewYOffset;
//        } else if ((currentScrollViewYOffset > -44.0) && (nextScrollViewYOffset < currentScrollViewYOffset)) {
//            [UIView animateWithDuration: 0.4 delay: 0.0 options: UIViewAnimationOptionTransitionNone animations:^{
//                [scrollView setContentOffset: CGPointMake(0.0, -44.0) animated: NO];
//            } completion:^(BOOL finished) {}];
//        } else {}
//
//    } else {}
//
//}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    [UIView animateWithDuration: 0.4 delay: 0.0 options: UIViewAnimationOptionTransitionNone animations:^{
        if (IS_IPHONEXR) {
            [scrollView setContentOffset: CGPointMake(0.0, -44.0) animated: NO];
        } else if (IS_IPHONEX) {
            [scrollView setContentOffset: CGPointMake(0.0, -44.0) animated: NO];
        } else if (IS_IPHONE8PLUS) {
        } else if (IS_IPHONE8) {
        } else {
        }
    } completion:^(BOOL finished) {}];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"");
    [UIView animateWithDuration: 0.4 delay: 0.0 options: UIViewAnimationOptionTransitionNone animations:^{
        if (IS_IPHONEXR) {
            [scrollView setContentOffset: CGPointMake(0.0, -44.0) animated: NO];
        } else if (IS_IPHONEX) {
            [scrollView setContentOffset: CGPointMake(0.0, -44.0) animated: NO];
        } else if (IS_IPHONE8PLUS) {
        } else if (IS_IPHONE8) {
        } else {
        }
    } completion:^(BOOL finished) {}];
}


//MARK:- UItextfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [[self view] endEditing: YES];
    isKeyboardOpen = @"NO";
    [UIView animateWithDuration: 0.4 delay: 0.0 options: UIViewAnimationOptionTransitionNone animations:^{
        [self->_scrollViewProfileScreen setContentOffset: CGPointMake(0.0, -44.0) animated: NO];
    } completion:^(BOOL finished) {
        [self setScrollViewFrameForKeyboardHidden];
    }];
    
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
            [_tfPasswordTextField becomeFirstResponder];
            return NO;
        }
        
    } else {}
    
    return YES;
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual: _tfPasswordTextField]) {
        
        [UIView animateWithDuration: 0.4 delay: 0.0 options: UIViewAnimationOptionTransitionNone animations:^{
            [self->_scrollViewProfileScreen setContentOffset: CGPointMake(0.0, 125.0) animated: NO];
        } completion:^(BOOL finished) {}];
        
    }
    
    return YES;
}


//MARK:- Tab bar controller delegate methods

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    NSMutableArray *arrTabbarVC = [[[self tabBarController] viewControllers] mutableCopy];
    NSString *strTabItemName = [[[tabBarController tabBar] selectedItem] title];
    
    if ([strTabItemName isEqualToString: @"Workout"]) {
        
        [arrTabbarVC setObject: GETCONTROLLER(@"WorkoutViewController") atIndexedSubscript: 0];
        [[self tabBarController] setViewControllers: arrTabbarVC animated: NO];
        
    }else if ([strTabItemName isEqualToString: @"Ranking"]) {
        
        [arrTabbarVC setObject: GETCONTROLLER(@"RankingViewController") atIndexedSubscript: 1];
        [[self tabBarController] setViewControllers: arrTabbarVC animated: NO];
        
    } else if ([strTabItemName isEqualToString: @"Stats"]) {
        
        [arrTabbarVC setObject: GETCONTROLLER(@"StatsVC") atIndexedSubscript: 2];
        [[self tabBarController] setViewControllers: arrTabbarVC animated: NO];
        
    } else if ([strTabItemName isEqualToString: @"Settings"]) {
        
        [arrTabbarVC setObject: GETCONTROLLER(@"SettingsViewController") atIndexedSubscript: 3];
        [[self tabBarController] setViewControllers: arrTabbarVC animated: NO];
        
    } else {}
    
}


//MARK:- User defined methods

- (void) setupLayout {
    
    [[self tabBarController] setDelegate: self];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 0] setTitle: @"Workout"];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 1] setTitle: @"Ranking"];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 2] setTitle: @"Stats"];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 3] setTitle: @"Settings"];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 3] setTitlePositionAdjustment: UIOffsetMake(0.0, 12.0)];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 3] setImage: [UIImage imageNamed: @"imgSettingsGreen"]];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 3] setImageInsets: UIEdgeInsetsMake(0.0, 0.0, -15.0, 0.0)];
    
    //Set Profile Layout
    self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height/2;
    self.imgProfile.clipsToBounds = YES;
    
    self.viewProfile.layer.cornerRadius = self.viewProfile.frame.size.height/2;
    self.viewProfile.layer.borderColor = [cNEW_GREEN CGColor];
    self.viewProfile.layer.borderWidth = 5.0;
    
    //Loader view
    [_lblLoaderGymTimerLabel setTextColor: cGYM_TIMER_LABEL];
    [_lblLoaderGymTimerLabel setAlpha: 1.0];
    [_viewLoaderContentView setClipsToBounds: YES];
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: [_viewLoaderContentView bounds] byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){30.0, 30.}].CGPath;
    [[_viewLoaderContentView layer] setMask: maskLayer];
    
    //Scroll and content view
    [_scrollViewProfileScreen setFrame: CGRectMake(0.0, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    [_scrollViewProfileScreen setDelegate: self];
    [self setScrollViewFrameForKeyboardHidden];
//    CGFloat updateProfileButtonLast = (_contentViewProfileScreen.frame.size.height - (_btnProfileUpdateButton.frame.origin.y + _btnProfileUpdateButton.frame.size.height));
//    CGFloat additionalContentHeight = fabs(291.0 - updateProfileButtonLast) + 44.0;
//    [_scrollViewProfileScreen setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + additionalContentHeight)];
//    [_contentViewProfileScreen setFrame: CGRectMake(0.0, 0.0, (_scrollViewProfileScreen.frame.size.width), (_scrollViewProfileScreen.frame.size.height + additionalContentHeight))];
    
    [_lblProfileTitleLabel setTextColor: cSTART_BUTTON];
    [_lblPrivateInformationLabel setTextColor: UIColor.darkGrayColor];
    [_lblPrivateInformationLabel setAlpha: 0.7];
    [_lblNameTitleLabel setTextColor: cSTART_BUTTON];
    [_lblEmailTitleLabel setTextColor: cSTART_BUTTON];
    [_lblPasswordTitleLabel setTextColor: cSTART_BUTTON];
    [_viewNameUnderlineView setBackgroundColor: cSTART_BUTTON];
    [_viewEmailUnderlineView setBackgroundColor: cSTART_BUTTON];
    [_viewPasswordUnderlineView setBackgroundColor: cSTART_BUTTON];
    
    [_tfNameTextField setDelegate: self];
    [_tfNameTextField setAutocorrectionType: UITextAutocorrectionTypeNo];
    [_tfNameTextField setAutocapitalizationType: UITextAutocapitalizationTypeWords];
    [_tfNameTextField setTintColor: cSTART_BUTTON];
    [_tfNameTextField setAttributedPlaceholder: [[NSAttributedString alloc] initWithString: @" Name"]];
    
    [_tfEmailTextField setDelegate: self];
    [_tfEmailTextField setAutocorrectionType: UITextAutocorrectionTypeNo];
    [_tfEmailTextField setTintColor: cSTART_BUTTON];
    [_tfEmailTextField setAttributedPlaceholder: [[NSAttributedString alloc] initWithString: @" Email"]];
    
    [_tfPasswordTextField setDelegate: self];
    [_tfPasswordTextField setSecureTextEntry: NO];
    [_tfPasswordTextField setAutocorrectionType: UITextAutocorrectionTypeNo];
    [_tfPasswordTextField setTextContentType: @""];
    [_tfPasswordTextField setTintColor: cSTART_BUTTON];
    [_tfPasswordTextField setAttributedPlaceholder: [[NSAttributedString alloc] initWithString: @" Need to change your password?"]];

    [_btnProfileUpdateButton setClipsToBounds: YES];
    
    if (IS_IPHONEXR) {
        //Loader view
        [_lblLoaderGymTimerLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblLoaderGymTimerLabel setFont: fontGymTimerLabel];
        [_viewLoaderContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        //Profile label
        [_lblProfileTitleLabel setFrame: CGRectMake(0.0, 17.0, DEVICE_WIDTH, 90.0)];
        UIFont *fontProfile = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 70.0];
        [_lblProfileTitleLabel setFont: fontProfile];
        
        //Back button frame
        [_btnBackButton setFrame: CGRectMake(20.0, (_lblProfileTitleLabel.frame.origin.y + (_lblProfileTitleLabel.frame.size.height/2 - 15)), 30.0, 30.0)];
        
        //Sub title frame and font
        [_lblPrivateInformationLabel setFrame: CGRectMake(0.0, (_lblProfileTitleLabel.frame.origin.y + _lblProfileTitleLabel.frame.size.height + 20.0), DEVICE_WIDTH, 20.0)];
        UIFont *fontInformation = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [_lblPrivateInformationLabel setFont: fontInformation];
        
        //Common fonts
        UIFont *fontNameTitle = [UIFont fontWithName: fFUTURA_BOLD size: 20.0];
        UIFont *fontUserName = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
        
        //Profile View Frame
        [_viewProfileParent setFrame:CGRectMake(_viewProfileParent.frame.origin.x, _lblPrivateInformationLabel.frame.origin.y + _lblPrivateInformationLabel.frame.size.height + 40, 103, 103)];
        
        //Name view frame
        [_viewNameContentView setFrame: CGRectMake(0.0, (_viewProfileParent.frame.origin.y + _viewProfileParent.frame.size.height + 65.0), DEVICE_WIDTH, 73.0)];
        [_lblNameTitleLabel setFrame: CGRectMake(51.0, 8.0, (DEVICE_WIDTH - 51.0), 21.0)];
        [_lblNameTitleLabel setFont: fontNameTitle];
        [_tfNameTextField setFrame: CGRectMake(51.0, 39.0, (DEVICE_WIDTH - 51.0), 30.0)];
        [_tfNameTextField setFont: fontUserName];
        NSAttributedString *attNamePlaceholder = [[NSAttributedString alloc] initWithString: @" Name" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontUserName}];
        [_tfNameTextField setAttributedPlaceholder: attNamePlaceholder];
        [_viewNameUnderlineView setFrame: CGRectMake(50.0, 71.0, (DEVICE_WIDTH - 50.0), 2.0)];
        
        //Email view frame
        [_viewEmailContentView setFrame: CGRectMake(0.0, (_viewNameContentView.frame.origin.y + _viewNameContentView.frame.size.height + 41.0), DEVICE_WIDTH, 73.0)];
        [_lblEmailTitleLabel setFrame: CGRectMake(51.0, 8.0, (DEVICE_WIDTH - 51.0), 21.0)];
        [_lblEmailTitleLabel setFont: fontNameTitle];
        [_tfEmailTextField setFrame: CGRectMake(51.0, 39.0, (DEVICE_WIDTH - 51.0), 30.0)];
        [_tfEmailTextField setFont: fontUserName];
        NSAttributedString *attEmailPlaceholder = [[NSAttributedString alloc] initWithString: @" Email" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontUserName}];
        [_tfEmailTextField setAttributedPlaceholder: attEmailPlaceholder];
        [_viewEmailUnderlineView setFrame: CGRectMake(50.0, 71.0, (DEVICE_WIDTH - 50.0), 2.0)];
        
        //Password view frame
        [_viewPasswordContentView setFrame: CGRectMake(0.0, (_viewEmailContentView.frame.origin.y + _viewEmailContentView.frame.size.height + 41.0), DEVICE_WIDTH, 73.0)];
        [_lblPasswordTitleLabel setFrame: CGRectMake(51.0, 8.0, (DEVICE_WIDTH - 51.0), 21.0)];
        [_lblPasswordTitleLabel setFont: fontNameTitle];
        [_tfPasswordTextField setFrame: CGRectMake(51.0, 39.0, (DEVICE_WIDTH - 51.0), 30.0)];
        [_tfPasswordTextField setFont: fontUserName];
        NSAttributedString *attPasswordPlaceholder = [[NSAttributedString alloc] initWithString: @" Need to change your password?" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontUserName}];
        [_tfPasswordTextField setAttributedPlaceholder: attPasswordPlaceholder];
        [_viewPasswordUnderlineView setFrame: CGRectMake(50.0, 71.0, (DEVICE_WIDTH - 50.0), 2.0)];
        
        //Update profile button
        [_btnProfileUpdateButton setFrame: CGRectMake(60.0, (_viewPasswordContentView.frame.origin.y + _viewPasswordContentView.frame.size.height + 30.0), (DEVICE_WIDTH - 120.0), 60.0)];
        [_btnProfileUpdateButton setBackgroundColor: cSTART_BUTTON_BLACK];
        UIFont *fontStartButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 20.0];
        NSDictionary *dicStartButton = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                          NSFontAttributeName : fontStartButton
                                          };
        NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"Update" attributes: dicStartButton];
        [_btnProfileUpdateButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
        [[_btnProfileUpdateButton layer] setCornerRadius: 20.0];
    } else if (IS_IPHONEX) {
        
        //Loader view
        [_lblLoaderGymTimerLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblLoaderGymTimerLabel setFont: fontGymTimerLabel];
        [_viewLoaderContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        //Profile label
        [_lblProfileTitleLabel setFrame: CGRectMake(0.0, 17.0, DEVICE_WIDTH, 90.0)];
        UIFont *fontProfile = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 70.0];
        [_lblProfileTitleLabel setFont: fontProfile];
        
        //Back button frame
        [_btnBackButton setFrame: CGRectMake(20.0, (_lblProfileTitleLabel.frame.origin.y + (_lblProfileTitleLabel.frame.size.height/2 - 15)), 30.0, 30.0)];
        
        //Sub title frame and font
        [_lblPrivateInformationLabel setFrame: CGRectMake(0.0, (_lblProfileTitleLabel.frame.origin.y + _lblProfileTitleLabel.frame.size.height + 20.0), DEVICE_WIDTH, 20.0)];
        UIFont *fontInformation = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [_lblPrivateInformationLabel setFont: fontInformation];
        
        //Common fonts
        UIFont *fontNameTitle = [UIFont fontWithName: fFUTURA_BOLD size: 20.0];
        UIFont *fontUserName = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
        
        //Profile View Frame
        [_viewProfileParent setFrame:CGRectMake(_viewProfileParent.frame.origin.x, _lblPrivateInformationLabel.frame.origin.y + _lblPrivateInformationLabel.frame.size.height + 40, 103, 103)];
        
        //Name view frame
        [_viewNameContentView setFrame: CGRectMake(0.0, (_viewProfileParent.frame.origin.y + _viewProfileParent.frame.size.height + 40), DEVICE_WIDTH, 73.0)];
        [_lblNameTitleLabel setFrame: CGRectMake(51.0, 8.0, (DEVICE_WIDTH - 51.0), 21.0)];
        [_lblNameTitleLabel setFont: fontNameTitle];
        [_tfNameTextField setFrame: CGRectMake(51.0, 39.0, (DEVICE_WIDTH - 51.0), 30.0)];
        [_tfNameTextField setFont: fontUserName];
        NSAttributedString *attNamePlaceholder = [[NSAttributedString alloc] initWithString: @" Name" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontUserName}];
        [_tfNameTextField setAttributedPlaceholder: attNamePlaceholder];
        [_viewNameUnderlineView setFrame: CGRectMake(50.0, 71.0, (DEVICE_WIDTH - 50.0), 2.0)];
        
        //Email view frame
        [_viewEmailContentView setFrame: CGRectMake(0.0, (_viewNameContentView.frame.origin.y + _viewNameContentView.frame.size.height + 41.0), DEVICE_WIDTH, 73.0)];
        [_lblEmailTitleLabel setFrame: CGRectMake(51.0, 8.0, (DEVICE_WIDTH - 51.0), 21.0)];
        [_lblEmailTitleLabel setFont: fontNameTitle];
        [_tfEmailTextField setFrame: CGRectMake(51.0, 39.0, (DEVICE_WIDTH - 51.0), 30.0)];
        [_tfEmailTextField setFont: fontUserName];
        NSAttributedString *attEmailPlaceholder = [[NSAttributedString alloc] initWithString: @" Email" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontUserName}];
        [_tfEmailTextField setAttributedPlaceholder: attEmailPlaceholder];
        [_viewEmailUnderlineView setFrame: CGRectMake(50.0, 71.0, (DEVICE_WIDTH - 50.0), 2.0)];
        
        //Password view frame
        [_viewPasswordContentView setFrame: CGRectMake(0.0, (_viewEmailContentView.frame.origin.y + _viewEmailContentView.frame.size.height + 41.0), DEVICE_WIDTH, 73.0)];
        [_lblPasswordTitleLabel setFrame: CGRectMake(51.0, 8.0, (DEVICE_WIDTH - 51.0), 21.0)];
        [_lblPasswordTitleLabel setFont: fontNameTitle];
        [_tfPasswordTextField setFrame: CGRectMake(51.0, 39.0, (DEVICE_WIDTH - 51.0), 30.0)];
        [_tfPasswordTextField setFont: fontUserName];
        NSAttributedString *attPasswordPlaceholder = [[NSAttributedString alloc] initWithString: @" Need to change your password?" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontUserName}];
        [_tfPasswordTextField setAttributedPlaceholder: attPasswordPlaceholder];
        [_viewPasswordUnderlineView setFrame: CGRectMake(50.0, 71.0, (DEVICE_WIDTH - 50.0), 2.0)];
        
        //Update profile button
        [_btnProfileUpdateButton setFrame: CGRectMake(60.0, (_viewPasswordContentView.frame.origin.y + _viewPasswordContentView.frame.size.height + 30.0), (DEVICE_WIDTH - 120.0), 60.0)];
        [_btnProfileUpdateButton setBackgroundColor: cSTART_BUTTON_BLACK];
        UIFont *fontStartButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 20.0];
        NSDictionary *dicStartButton = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                          NSFontAttributeName : fontStartButton
                                          };
        NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"Update" attributes: dicStartButton];
        [_btnProfileUpdateButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
        [[_btnProfileUpdateButton layer] setCornerRadius: 20.0];
        
    } else if (IS_IPHONE8PLUS) {
        //Loader view
        [_lblLoaderGymTimerLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblLoaderGymTimerLabel setFont: fontGymTimerLabel];
        [_viewLoaderContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        //Profile label
        [_lblProfileTitleLabel setFrame: CGRectMake(0.0, 17.0, DEVICE_WIDTH, 90.0)];
        UIFont *fontProfile = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 70.0];
        [_lblProfileTitleLabel setFont: fontProfile];
        
        //Back button frame
        [_btnBackButton setFrame: CGRectMake(20.0, (_lblProfileTitleLabel.frame.origin.y + (_lblProfileTitleLabel.frame.size.height/2 - 15)), 30.0, 30.0)];
        
        //Sub title frame and font
        [_lblPrivateInformationLabel setFrame: CGRectMake(0.0, (_lblProfileTitleLabel.frame.origin.y + _lblProfileTitleLabel.frame.size.height + 20.0), DEVICE_WIDTH, 20.0)];
        UIFont *fontInformation = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [_lblPrivateInformationLabel setFont: fontInformation];
        
        //Common fonts
        UIFont *fontNameTitle = [UIFont fontWithName: fFUTURA_BOLD size: 20.0];
        UIFont *fontUserName = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
        
        //Profile View Frame
        [_viewProfileParent setFrame:CGRectMake(_viewProfileParent.frame.origin.x, _lblPrivateInformationLabel.frame.origin.y + _lblPrivateInformationLabel.frame.size.height + 40, 103, 103)];
        
        //Name view frame
        [_viewNameContentView setFrame: CGRectMake(0.0, (_viewProfileParent.frame.origin.y + _viewProfileParent.frame.size.height + 25.0), DEVICE_WIDTH, 73.0)];
        [_lblNameTitleLabel setFrame: CGRectMake(51.0, 8.0, (DEVICE_WIDTH - 51.0), 21.0)];
        [_lblNameTitleLabel setFont: fontNameTitle];
        [_tfNameTextField setFrame: CGRectMake(51.0, 39.0, (DEVICE_WIDTH - 51.0), 30.0)];
        [_tfNameTextField setFont: fontUserName];
        NSAttributedString *attNamePlaceholder = [[NSAttributedString alloc] initWithString: @" Name" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontUserName}];
        [_tfNameTextField setAttributedPlaceholder: attNamePlaceholder];
        [_viewNameUnderlineView setFrame: CGRectMake(50.0, 71.0, (DEVICE_WIDTH - 50.0), 2.0)];
        
        //Email view frame
        [_viewEmailContentView setFrame: CGRectMake(0.0, (_viewNameContentView.frame.origin.y + _viewNameContentView.frame.size.height + 41.0), DEVICE_WIDTH, 73.0)];
        [_lblEmailTitleLabel setFrame: CGRectMake(51.0, 8.0, (DEVICE_WIDTH - 51.0), 21.0)];
        [_lblEmailTitleLabel setFont: fontNameTitle];
        [_tfEmailTextField setFrame: CGRectMake(51.0, 39.0, (DEVICE_WIDTH - 51.0), 30.0)];
        [_tfEmailTextField setFont: fontUserName];
        NSAttributedString *attEmailPlaceholder = [[NSAttributedString alloc] initWithString: @" Email" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontUserName}];
        [_tfEmailTextField setAttributedPlaceholder: attEmailPlaceholder];
        [_viewEmailUnderlineView setFrame: CGRectMake(50.0, 71.0, (DEVICE_WIDTH - 50.0), 2.0)];
        
        //Password view frame
        [_viewPasswordContentView setFrame: CGRectMake(0.0, (_viewEmailContentView.frame.origin.y + _viewEmailContentView.frame.size.height + 41.0), DEVICE_WIDTH, 73.0)];
        [_lblPasswordTitleLabel setFrame: CGRectMake(51.0, 8.0, (DEVICE_WIDTH - 51.0), 21.0)];
        [_lblPasswordTitleLabel setFont: fontNameTitle];
        [_tfPasswordTextField setFrame: CGRectMake(51.0, 39.0, (DEVICE_WIDTH - 51.0), 30.0)];
        [_tfPasswordTextField setFont: fontUserName];
        NSAttributedString *attPasswordPlaceholder = [[NSAttributedString alloc] initWithString: @" Need to change your password?" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontUserName}];
        [_tfPasswordTextField setAttributedPlaceholder: attPasswordPlaceholder];
        [_viewPasswordUnderlineView setFrame: CGRectMake(50.0, 71.0, (DEVICE_WIDTH - 50.0), 2.0)];
        
        //Update profile button
        [_btnProfileUpdateButton setFrame: CGRectMake(60.0, (_viewPasswordContentView.frame.origin.y + _viewPasswordContentView.frame.size.height + 30.0), (DEVICE_WIDTH - 120.0), 60.0)];
        [_btnProfileUpdateButton setBackgroundColor: cSTART_BUTTON_BLACK];
        UIFont *fontStartButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 20.0];
        NSDictionary *dicStartButton = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                          NSFontAttributeName : fontStartButton
                                          };
        NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"Update" attributes: dicStartButton];
        [_btnProfileUpdateButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
        [[_btnProfileUpdateButton layer] setCornerRadius: 20.0];
    } else if (IS_IPHONE8) {
        //Loader view
        [_lblLoaderGymTimerLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblLoaderGymTimerLabel setFont: fontGymTimerLabel];
        [_viewLoaderContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        //Profile label
        [_lblProfileTitleLabel setFrame: CGRectMake(0.0, 17.0, DEVICE_WIDTH, 90.0)];
        UIFont *fontProfile = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 70.0];
        [_lblProfileTitleLabel setFont: fontProfile];
        
        //Back button frame
        [_btnBackButton setFrame: CGRectMake(20.0, (_lblProfileTitleLabel.frame.origin.y + (_lblProfileTitleLabel.frame.size.height/2 - 15)), 30.0, 30.0)];
        
        //Sub title frame and font
        [_lblPrivateInformationLabel setFrame: CGRectMake(0.0, (_lblProfileTitleLabel.frame.origin.y + _lblProfileTitleLabel.frame.size.height), DEVICE_WIDTH, 20.0)];
        UIFont *fontInformation = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [_lblPrivateInformationLabel setFont: fontInformation];
        
        //Common fonts
        UIFont *fontNameTitle = [UIFont fontWithName: fFUTURA_BOLD size: 20.0];
        UIFont *fontUserName = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
        
        //Profile View Frame
        [_viewProfileParent setFrame:CGRectMake(_viewProfileParent.frame.origin.x, _lblPrivateInformationLabel.frame.origin.y + _lblPrivateInformationLabel.frame.size.height + 20, 103, 103)];
        
        //Name view frame
        [_viewNameContentView setFrame: CGRectMake(0.0, (_viewProfileParent.frame.origin.y + _viewProfileParent.frame.size.height + 5.0), DEVICE_WIDTH, 73.0)];
        [_lblNameTitleLabel setFrame: CGRectMake(51.0, 8.0, (DEVICE_WIDTH - 51.0), 21.0)];
        [_lblNameTitleLabel setFont: fontNameTitle];
        [_tfNameTextField setFrame: CGRectMake(51.0, 39.0, (DEVICE_WIDTH - 51.0), 30.0)];
        [_tfNameTextField setFont: fontUserName];
        NSAttributedString *attNamePlaceholder = [[NSAttributedString alloc] initWithString: @" Name" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontUserName}];
        [_tfNameTextField setAttributedPlaceholder: attNamePlaceholder];
        [_viewNameUnderlineView setFrame: CGRectMake(50.0, 71.0, (DEVICE_WIDTH - 50.0), 2.0)];
        
        //Email view frame
        [_viewEmailContentView setFrame: CGRectMake(0.0, (_viewNameContentView.frame.origin.y + _viewNameContentView.frame.size.height + 41.0), DEVICE_WIDTH, 73.0)];
        [_lblEmailTitleLabel setFrame: CGRectMake(51.0, 8.0, (DEVICE_WIDTH - 51.0), 21.0)];
        [_lblEmailTitleLabel setFont: fontNameTitle];
        [_tfEmailTextField setFrame: CGRectMake(51.0, 39.0, (DEVICE_WIDTH - 51.0), 30.0)];
        [_tfEmailTextField setFont: fontUserName];
        NSAttributedString *attEmailPlaceholder = [[NSAttributedString alloc] initWithString: @" Email" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontUserName}];
        [_tfEmailTextField setAttributedPlaceholder: attEmailPlaceholder];
        [_viewEmailUnderlineView setFrame: CGRectMake(50.0, 71.0, (DEVICE_WIDTH - 50.0), 2.0)];
        
        //Password view frame
        [_viewPasswordContentView setFrame: CGRectMake(0.0, (_viewEmailContentView.frame.origin.y + _viewEmailContentView.frame.size.height + 41.0), DEVICE_WIDTH, 73.0)];
        [_lblPasswordTitleLabel setFrame: CGRectMake(51.0, 8.0, (DEVICE_WIDTH - 51.0), 21.0)];
        [_lblPasswordTitleLabel setFont: fontNameTitle];
        [_tfPasswordTextField setFrame: CGRectMake(51.0, 39.0, (DEVICE_WIDTH - 51.0), 30.0)];
        [_tfPasswordTextField setFont: fontUserName];
        NSAttributedString *attPasswordPlaceholder = [[NSAttributedString alloc] initWithString: @" Need to change your password?" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontUserName}];
        [_tfPasswordTextField setAttributedPlaceholder: attPasswordPlaceholder];
        [_viewPasswordUnderlineView setFrame: CGRectMake(50.0, 71.0, (DEVICE_WIDTH - 50.0), 2.0)];
        
        //Update profile button
        [_btnProfileUpdateButton setFrame: CGRectMake(60.0, (_viewPasswordContentView.frame.origin.y + _viewPasswordContentView.frame.size.height + 30.0), (DEVICE_WIDTH - 120.0), 60.0)];
        [_btnProfileUpdateButton setBackgroundColor: cSTART_BUTTON_BLACK];
        UIFont *fontStartButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 20.0];
        NSDictionary *dicStartButton = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                          NSFontAttributeName : fontStartButton
                                          };
        NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"Update" attributes: dicStartButton];
        [_btnProfileUpdateButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
        [[_btnProfileUpdateButton layer] setCornerRadius: 20.0];
    } else {
        //Loader view
        [_lblLoaderGymTimerLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblLoaderGymTimerLabel setFont: fontGymTimerLabel];
        [_viewLoaderContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        //Profile label
        [_lblProfileTitleLabel setFrame: CGRectMake(0.0, 17.0, DEVICE_WIDTH, 90.0)];
        UIFont *fontProfile = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 70.0];
        [_lblProfileTitleLabel setFont: fontProfile];
        
        //Back button frame
        [_btnBackButton setFrame: CGRectMake(20.0, (_lblProfileTitleLabel.frame.origin.y + (_lblProfileTitleLabel.frame.size.height/2 - 15)), 30.0, 30.0)];
        
        //Sub title frame and font
        [_lblPrivateInformationLabel setFrame: CGRectMake(0.0, (_lblProfileTitleLabel.frame.origin.y + _lblProfileTitleLabel.frame.size.height + 20.0), DEVICE_WIDTH, 20.0)];
        UIFont *fontInformation = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [_lblPrivateInformationLabel setFont: fontInformation];
        
        //Common fonts
        UIFont *fontNameTitle = [UIFont fontWithName: fFUTURA_BOLD size: 20.0];
        UIFont *fontUserName = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
        
        //Profile View Frame
        [_viewProfileParent setFrame:CGRectMake(_viewProfileParent.frame.origin.x, _lblPrivateInformationLabel.frame.origin.y + _lblPrivateInformationLabel.frame.size.height + 40, 103, 103)];
        
        //Name view frame
        [_viewNameContentView setFrame: CGRectMake(0.0, (_viewProfileParent.frame.origin.y + _viewProfileParent.frame.size.height + 15.0), DEVICE_WIDTH, 73.0)];
        [_lblNameTitleLabel setFrame: CGRectMake(51.0, 8.0, (DEVICE_WIDTH - 51.0), 21.0)];
        [_lblNameTitleLabel setFont: fontNameTitle];
        [_tfNameTextField setFrame: CGRectMake(51.0, 39.0, (DEVICE_WIDTH - 51.0), 30.0)];
        [_tfNameTextField setFont: fontUserName];
        NSAttributedString *attNamePlaceholder = [[NSAttributedString alloc] initWithString: @" Name" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontUserName}];
        [_tfNameTextField setAttributedPlaceholder: attNamePlaceholder];
        [_viewNameUnderlineView setFrame: CGRectMake(50.0, 71.0, (DEVICE_WIDTH - 50.0), 2.0)];
        
        //Email view frame
        [_viewEmailContentView setFrame: CGRectMake(0.0, (_viewNameContentView.frame.origin.y + _viewNameContentView.frame.size.height + 41.0), DEVICE_WIDTH, 73.0)];
        [_lblEmailTitleLabel setFrame: CGRectMake(51.0, 8.0, (DEVICE_WIDTH - 51.0), 21.0)];
        [_lblEmailTitleLabel setFont: fontNameTitle];
        [_tfEmailTextField setFrame: CGRectMake(51.0, 39.0, (DEVICE_WIDTH - 51.0), 30.0)];
        [_tfEmailTextField setFont: fontUserName];
        NSAttributedString *attEmailPlaceholder = [[NSAttributedString alloc] initWithString: @" Email" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontUserName}];
        [_tfEmailTextField setAttributedPlaceholder: attEmailPlaceholder];
        [_viewEmailUnderlineView setFrame: CGRectMake(50.0, 71.0, (DEVICE_WIDTH - 50.0), 2.0)];
        
        //Password view frame
        [_viewPasswordContentView setFrame: CGRectMake(0.0, (_viewEmailContentView.frame.origin.y + _viewEmailContentView.frame.size.height + 41.0), DEVICE_WIDTH, 73.0)];
        [_lblPasswordTitleLabel setFrame: CGRectMake(51.0, 8.0, (DEVICE_WIDTH - 51.0), 21.0)];
        [_lblPasswordTitleLabel setFont: fontNameTitle];
        [_tfPasswordTextField setFrame: CGRectMake(51.0, 39.0, (DEVICE_WIDTH - 51.0), 30.0)];
        [_tfPasswordTextField setFont: fontUserName];
        NSAttributedString *attPasswordPlaceholder = [[NSAttributedString alloc] initWithString: @" Need to change your password?" attributes: @{NSForegroundColorAttributeName: cPLACEHOLDER, NSFontAttributeName : fontUserName}];
        [_tfPasswordTextField setAttributedPlaceholder: attPasswordPlaceholder];
        [_viewPasswordUnderlineView setFrame: CGRectMake(50.0, 71.0, (DEVICE_WIDTH - 50.0), 2.0)];
        
        //Update profile button
        [_btnProfileUpdateButton setFrame: CGRectMake(60.0, (_viewPasswordContentView.frame.origin.y + _viewPasswordContentView.frame.size.height + 30.0), (DEVICE_WIDTH - 120.0), 60.0)];
        [_btnProfileUpdateButton setBackgroundColor: cSTART_BUTTON_BLACK];
        UIFont *fontStartButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 20.0];
        NSDictionary *dicStartButton = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                          NSFontAttributeName : fontStartButton
                                          };
        NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"Update" attributes: dicStartButton];
        [_btnProfileUpdateButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
        [[_btnProfileUpdateButton layer] setCornerRadius: 20.0];
        
        [_scrollViewProfileScreen setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + 200)];
        [_contentViewProfileScreen setFrame: CGRectMake(0.0, 0.0, (_scrollViewProfileScreen.frame.size.width), (_scrollViewProfileScreen.frame.size.height + 200))];
    }
    
    [self showScreenContents];
    
}

- (void) initializeData {
    
    serviceManager = [[ServiceManager alloc] init];
    [serviceManager setDelegate: self];
    
    utils = [[Utils alloc] init];
    
    isKeyboardOpen = @"NO";
    
    [_tfNameTextField setText: [dicUserDetails valueForKey: @"name"]];
    [_tfEmailTextField setText: [dicUserDetails valueForKey: @"email"]];
    [_tfPasswordTextField setText: @""];
//    [_tfPasswordTextField setText: [dicUserDetails valueForKey: @"password"]];
    
    currentScrollViewYOffset = [_scrollViewProfileScreen contentOffset].y;
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(handleSwipeOnMainView:)];
    [[self view] addGestureRecognizer: swipeGesture];
    
}

- (void) handleSwipeOnMainView: (UISwipeGestureRecognizer *) swipe {
    
    if ([swipe direction] == UISwipeGestureRecognizerDirectionRight) {
        [[self navigationController] popViewControllerAnimated: YES];
//        NSMutableArray *arrTabbarVC = [[[self tabBarController] viewControllers] mutableCopy];
//        [arrTabbarVC setObject: GETCONTROLLER(@"SettingsViewController") atIndexedSubscript: 2];
//        [[self tabBarController] setViewControllers: arrTabbarVC animated: NO];
    }
    
}

- (BOOL) isValidForUpdateProfile {
    
    if ([[Utils trimString: [_tfNameTextField text]] isEqualToString: @""]) {
        
        [Utils showToast: @"Please enter your name." duration: 3.0];
        return NO;
        
    } else if ([[Utils trimString: [_tfEmailTextField text]] isEqualToString: @""]) {
        
        [Utils showToast: @"Please enter your Email." duration: 3.0];
        return NO;
        
    } else if (![Utils IsValidEmail: [_tfEmailTextField text]]) {
        
        [Utils showToast: @"Please enter valid email." duration: 3.0];
        return NO;
        
    } else {
        return YES;
    }
    
}

- (void) callUpdateProfileAPI {
    
    if ([self isValidForUpdateProfile]) {
        
        NSArray *arrSignUpParams = @[
                                     @{ @"name" : [_tfNameTextField text] },
                                     @{ @"email" : [_tfEmailTextField text] },
                                     @{ @"password" : [_tfPasswordTextField text] },
                                     @{ @"user_id" : [dicUserDetails valueForKey: @"id"]},
                                     ];
        NSMutableArray *arrProfile = [[NSMutableArray alloc] initWithObjects:self.imgProfile.image, nil];
        if ([Utils isConnectedToInternet]) {
            
            [self hideScreenContents];
            spinner = [Utils showActivityIndicatorInView: self.viewLoaderBackgroundView];
            [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [spinner setColor:cNEW_GREEN];
            
            NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uUPDATE_PROFILE];
            [serviceManager callWebServiceWithPOSTForImageUpload:webpath withTag:tUPDATE_PROFILE params:arrSignUpParams imgArray:arrProfile];
        } 
    }
    
}

- (void) showScreenContents {
    [_viewLoaderBackgroundView setHidden: YES];
    [_scrollViewProfileScreen setHidden: NO];
}

- (void) hideScreenContents {
    [_viewLoaderBackgroundView setHidden: NO];
    [_scrollViewProfileScreen setHidden: YES];
}

- (void) setScrollViewFrameForKeyboardOpen {
    
    CGFloat kbHeight = (!CGRectIsNull(keyboardFrame)) ? keyboardFrame.size.height : 0.0;
    CGFloat updateProfileButtonLast = (_contentViewProfileScreen.frame.size.height - (_btnProfileUpdateButton.frame.origin.y + _btnProfileUpdateButton.frame.size.height));
    CGFloat additionalContentHeight = fabs(kbHeight - updateProfileButtonLast) + 44.0;
    
    [_scrollViewProfileScreen setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + additionalContentHeight)];
    [_contentViewProfileScreen setFrame: CGRectMake(0.0, 0.0, (_scrollViewProfileScreen.frame.size.width), (_scrollViewProfileScreen.frame.size.height + additionalContentHeight))];
    [_scrollViewProfileScreen setDelegate: self];
}

- (void) setScrollViewFrameForKeyboardHidden {
    
    CGFloat scrollViewHeight = (DEVICE_HEIGHT + 100.0);
    [_scrollViewProfileScreen setContentSize: CGSizeMake(DEVICE_WIDTH, scrollViewHeight)];
    [_scrollViewProfileScreen setDelegate: self];
    [_contentViewProfileScreen setFrame: CGRectMake(0.0, 0.0, (_scrollViewProfileScreen.frame.size.width), scrollViewHeight)];
}

//MARK:- Selector methods

- (void) handleKeyboardWillShowNotification: (NSNotification *) notification {
    
    NSValue *kbFrame = [[notification userInfo] valueForKey: UIKeyboardFrameEndUserInfoKey];
    
    keyboardFrame = [kbFrame CGRectValue];
    isKeyboardOpen = @"YES";
    [self setScrollViewFrameForKeyboardOpen];
    
}

- (void) handleKeyboardWillHideNotification: (NSNotification *) notification {
    isKeyboardOpen = @"NO";
    [self setScrollViewFrameForKeyboardHidden];
}


//MARK:- Service manager delegate and parser methods

- (void) webServiceCallFailure: (NSError *) error forTag: (NSString *) tagname {
    NSLog(@"Web service call fails : %@", [error localizedDescription]);
    //    [progressHUD dismissAnimated: YES];
    [Utils hideActivityIndicator:spinner fromView:self.viewLoaderContentView];
    [Utils showToast: [error localizedDescription] duration: 3.0];
}

- (void) webServiceCallSuccess: (id) response forTag: (NSString *) tagname {
    
    if ([tagname isEqualToString: tUPDATE_PROFILE]) {
        [self parseUpdateProfileResponse: response];
    }
    
}

- (void) parseUpdateProfileResponse: (id) response {
    
    [Utils hideActivityIndicator:spinner fromView:self.viewLoaderContentView];
    [self showScreenContents];
    
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    [Utils showToast: [dicResponse valueForKey: @"message"] duration: 3.0];
    
    if ([[dicResponse valueForKey:@"status"] integerValue] == 1) {
        
        [self.view endEditing: YES];
        
        NSMutableDictionary *dicUserData = [dicResponse valueForKey:@"data"];
        [Utils setUserDetails: dicUserData];
        dicUserDetails = dicUserData;
        
        [_tfNameTextField setText: [dicUserData valueForKey: @"name"]];
        [_tfEmailTextField setText: [dicUserData valueForKey: @"email"]];
        [_tfPasswordTextField setText: @""];
        
        [[self navigationController] popViewControllerAnimated: YES];
        
    } else {}
    
}

//MARK:- UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [self.imgProfile setImage:[UIImage imageWithData:UIImageJPEGRepresentation(chosenImage, 0.2)]];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

@end
