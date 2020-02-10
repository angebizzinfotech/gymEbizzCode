//
//  ContactUsViewController.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 18/04/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "ContactUsViewController.h"
#import "CommonImports.h"

@interface ContactUsViewController () <UITabBarControllerDelegate, UITextViewDelegate, ServiceManagerDelegate>
{
    
    ServiceManager *serviceManager;
    Utils *utils;
    JGProgressHUD *progressHUD;
    UILabel *lbl;
    UIActivityIndicatorView *spinner;
    
}
@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLayout];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self initializeData];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    
    [_tvFaqTextView setText: @""];
    
}


//MARK:- Button's action methods

- (IBAction)btnBackButtonTapped:(UIButton *)sender {
    
    [[self navigationController] popViewControllerAnimated: YES];
//    NSMutableArray *arrTabbarVC = [[[self tabBarController] viewControllers] mutableCopy];
//    [arrTabbarVC setObject: GETCONTROLLER(@"SettingsViewController") atIndexedSubscript: 2];
//    [[self tabBarController] setViewControllers: arrTabbarVC animated: NO];
    
}

- (IBAction)btnSendFaqButtonTapped:(UIButton *)sender {
    
    [[self view] endEditing: YES];
    
    if ([[Utils trimString: [_tvFaqTextView text]] isEqualToString: @""]) {
        
        [Utils showToast: @"Please enter your feedbacks or questions." duration: 3.0];
        return;
        
    }
    
    NSArray *arrSendFaqParams = @[
                                  @{ @"user_id" : [[Utils getUserDetails] valueForKey: @"id"]},
                                  @{ @"feedback" : [_tvFaqTextView text]}
                                ];
    
    if ([Utils isConnectedToInternet]) {
        
        [self hideScreenContents];
        spinner = [Utils showActivityIndicatorInView: self.viewLoaderContentView];
        NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uUSER_FEEDBACK];
        [serviceManager callWebServiceWithPOST: webpath withTag: tUSER_FEEDBACK params: arrSendFaqParams];
        
    } 
    
}


//MARK:- Tab bar controller delegate methods

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    NSMutableArray *arrTabbarVC = [[[self tabBarController] viewControllers] mutableCopy];
    NSString *strTabItemName = [[[tabBarController tabBar] selectedItem] title];
    
    if ([strTabItemName isEqualToString: @"Workout"]) {
        
        [arrTabbarVC setObject: GETCONTROLLER(@"WorkoutViewController") atIndexedSubscript: 0];
        [[self tabBarController] setViewControllers: arrTabbarVC animated: NO];
        
    } else if ([strTabItemName isEqualToString: @"Ranking"]) {
        
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


//MARK:- Textview's delegate methods

- (void) textViewDidChange: (UITextView *) textView {
    
    if(![textView hasText]) {
        lbl.hidden = NO;
    }
    else {
        lbl.hidden = YES;
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (![textView hasText]) {
        lbl.hidden = NO;
    }
    
}


//MARK:- Service manager delegate and parser methods

- (void)webServiceCallFailure:(NSError *)error forTag:(NSString *)tagname {
    NSLog(@"Web service call fails : %@", [error localizedDescription]);
    [Utils hideActivityIndicator:spinner fromView:self.viewLoaderContentView];
    [self showScreenContents];
    [Utils showToast: [error localizedDescription] duration: 3.0];
}

- (void)webServiceCallSuccess:(id)response forTag:(NSString *)tagname {
    
    if ([tagname isEqualToString: tUSER_FEEDBACK]) {
        [self parseFaqResponse: response];
    }
    
}

- (void) parseFaqResponse: (id) response {
    
    [Utils hideActivityIndicator:spinner fromView:self.viewLoaderContentView];
    [self showScreenContents];
    
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    [Utils showToast: [dicResponse valueForKey: @"message"] duration: 3.0];
    
    if ([[dicResponse valueForKey:@"status"] integerValue] == 1) {
        [_tvFaqTextView setText: @""];
        [lbl setHidden: NO];
    } else {}
    
}


//MARK:- User defined methods

- (void) setupLayout {
    
    //Tabbar initialization
    [[self tabBarController] setDelegate: self];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 0] setTitle: @"Workout"];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 1] setTitle: @"Ranking"];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 2] setTitle: @"Stats"];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 3] setTitle: @"Settings"];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 3] setTitlePositionAdjustment: UIOffsetMake(0.0, 12.0)];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 3] setImage: [UIImage imageNamed: @"imgSettingsGreen"]];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 3] setImageInsets: UIEdgeInsetsMake(0.0, 0.0, -15.0, 0.0)];
    
    //Loader view
    [_lblLoaderGymTimerLabel setTextColor: cGYM_TIMER_LABEL];
    [_lblLoaderGymTimerLabel setAlpha: 1.0];
    [_viewLoaderContentView setClipsToBounds: YES];
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: [_viewLoaderContentView bounds] byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){30.0, 30.}].CGPath;
    [[_viewLoaderContentView layer] setMask: maskLayer];
    
    [_lblContactUsTitleLabel setTextColor: cSTART_BUTTON];
    [_tvFaqTextView setAutocorrectionType: UITextAutocorrectionTypeNo];
    [_viewFaqUnderlineView setBackgroundColor: cSTART_BUTTON];
    
    [_btnSendFaqButton setClipsToBounds: YES];
    [[_btnSendFaqButton layer] setCornerRadius: 22.0];
    
    UIFont *fontFaqPlaceholder;
    
    if (IS_IPHONEXR) {
        //Loader view
        [_lblLoaderGymTimerLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblLoaderGymTimerLabel setFont: fontGymTimerLabel];
        [_viewLoaderContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        //Contact us label
        [_lblContactUsTitleLabel setFrame: CGRectMake(0.0, 64.0, DEVICE_WIDTH, 90.0)];
        UIFont *fontSettings = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 41.5];
        [_lblContactUsTitleLabel setFont: fontSettings];
        
        //Back button frame
        [_btnBackButton setFrame: CGRectMake(20.0, (_lblContactUsTitleLabel.frame.origin.y + (_lblContactUsTitleLabel.frame.size.height/2 - 15)), 30.0, 30.0)];
        
        //Faq text view
        [_tvFaqTextView setFrame: CGRectMake(48.0, (_lblContactUsTitleLabel.frame.origin.y + _lblContactUsTitleLabel.frame.size.height + 48.0), (DEVICE_WIDTH - 48.0), 150.0)];
        fontFaqPlaceholder = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [_viewFaqUnderlineView setFrame: CGRectMake(48.0, (_tvFaqTextView.frame.origin.y + _tvFaqTextView.frame.size.height + 2.0), (DEVICE_WIDTH - 48.0), 2.0)];
        
        //Send faq button
        
        [_btnSendFaqButton setFrame: CGRectMake(60.0, (_viewFaqUnderlineView.frame.origin.y + 40.0), (DEVICE_WIDTH - 120.0), 60.0)];
        UIFont *fontStartButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 28.0];
        NSDictionary *dicStartButton = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                          NSFontAttributeName : fontStartButton
                                          };
        NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"Send" attributes: dicStartButton];
        [_btnSendFaqButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
    } else if (IS_IPHONEX) {
        
        //Loader view
        [_lblLoaderGymTimerLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblLoaderGymTimerLabel setFont: fontGymTimerLabel];
        [_viewLoaderContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        //Contact us label
        [_lblContactUsTitleLabel setFrame: CGRectMake(0.0, 64.0, DEVICE_WIDTH, 90.0)];
        UIFont *fontSettings = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 41.5];
        [_lblContactUsTitleLabel setFont: fontSettings];
        
        //Back button frame
        [_btnBackButton setFrame: CGRectMake(20.0, (_lblContactUsTitleLabel.frame.origin.y + (_lblContactUsTitleLabel.frame.size.height/2 - 15)), 30.0, 30.0)];
        
        //Faq text view
        [_tvFaqTextView setFrame: CGRectMake(48.0, (_lblContactUsTitleLabel.frame.origin.y + _lblContactUsTitleLabel.frame.size.height + 48.0), (DEVICE_WIDTH - 48.0), 150.0)];
        fontFaqPlaceholder = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [_viewFaqUnderlineView setFrame: CGRectMake(48.0, (_tvFaqTextView.frame.origin.y + _tvFaqTextView.frame.size.height + 2.0), (DEVICE_WIDTH - 48.0), 2.0)];
        
        //Send faq button
        
        [_btnSendFaqButton setFrame: CGRectMake(60.0, (_viewFaqUnderlineView.frame.origin.y + 40.0), (DEVICE_WIDTH - 120.0), 60.0)];
        UIFont *fontStartButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 28.0];
        NSDictionary *dicStartButton = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                          NSFontAttributeName : fontStartButton
                                          };
        NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"Send" attributes: dicStartButton];
        [_btnSendFaqButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
        
    } else if (IS_IPHONE8PLUS) {
        //Loader view
        [_lblLoaderGymTimerLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblLoaderGymTimerLabel setFont: fontGymTimerLabel];
        [_viewLoaderContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        //Contact us label
        [_lblContactUsTitleLabel setFrame: CGRectMake(0.0, 64.0, DEVICE_WIDTH, 90.0)];
        UIFont *fontSettings = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 41.5];
        [_lblContactUsTitleLabel setFont: fontSettings];
        
        //Back button frame
        [_btnBackButton setFrame: CGRectMake(20.0, (_lblContactUsTitleLabel.frame.origin.y + (_lblContactUsTitleLabel.frame.size.height/2 - 15)), 30.0, 30.0)];
        
        //Faq text view
        [_tvFaqTextView setFrame: CGRectMake(48.0, (_lblContactUsTitleLabel.frame.origin.y + _lblContactUsTitleLabel.frame.size.height + 48.0), (DEVICE_WIDTH - 48.0), 150.0)];
        fontFaqPlaceholder = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [_viewFaqUnderlineView setFrame: CGRectMake(48.0, (_tvFaqTextView.frame.origin.y + _tvFaqTextView.frame.size.height + 2.0), (DEVICE_WIDTH - 48.0), 2.0)];
        
        //Send faq button
        
        [_btnSendFaqButton setFrame: CGRectMake(60.0, (_viewFaqUnderlineView.frame.origin.y + 40.0), (DEVICE_WIDTH - 120.0), 60.0)];
        UIFont *fontStartButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 28.0];
        NSDictionary *dicStartButton = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                          NSFontAttributeName : fontStartButton
                                          };
        NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"Send" attributes: dicStartButton];
        [_btnSendFaqButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
    } else if (IS_IPHONE8) {
        //Loader view
        [_lblLoaderGymTimerLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblLoaderGymTimerLabel setFont: fontGymTimerLabel];
        [_viewLoaderContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        //Contact us label
        [_lblContactUsTitleLabel setFrame: CGRectMake(0.0, 64.0, DEVICE_WIDTH, 90.0)];
        UIFont *fontSettings = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 41.5];
        [_lblContactUsTitleLabel setFont: fontSettings];
        
        //Back button frame
        [_btnBackButton setFrame: CGRectMake(20.0, (_lblContactUsTitleLabel.frame.origin.y + (_lblContactUsTitleLabel.frame.size.height/2 - 15)), 30.0, 30.0)];
        
        //Faq text view
        [_tvFaqTextView setFrame: CGRectMake(48.0, (_lblContactUsTitleLabel.frame.origin.y + _lblContactUsTitleLabel.frame.size.height + 48.0), (DEVICE_WIDTH - 48.0), 150.0)];
        fontFaqPlaceholder = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [_viewFaqUnderlineView setFrame: CGRectMake(48.0, (_tvFaqTextView.frame.origin.y + _tvFaqTextView.frame.size.height + 2.0), (DEVICE_WIDTH - 48.0), 2.0)];
        
        //Send faq button
        
        [_btnSendFaqButton setFrame: CGRectMake(60.0, (_viewFaqUnderlineView.frame.origin.y + 40.0), (DEVICE_WIDTH - 120.0), 60.0)];
        UIFont *fontStartButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 28.0];
        NSDictionary *dicStartButton = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                          NSFontAttributeName : fontStartButton
                                          };
        NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"Send" attributes: dicStartButton];
        [_btnSendFaqButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
        
    } else {
        //Loader view
        [_lblLoaderGymTimerLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblLoaderGymTimerLabel setFont: fontGymTimerLabel];
        [_viewLoaderContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        //Contact us label
        [_lblContactUsTitleLabel setFrame: CGRectMake(0.0, 64.0, DEVICE_WIDTH, 90.0)];
        UIFont *fontSettings = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 41.5];
        [_lblContactUsTitleLabel setFont: fontSettings];
        
        //Back button frame
        [_btnBackButton setFrame: CGRectMake(20.0, (_lblContactUsTitleLabel.frame.origin.y + (_lblContactUsTitleLabel.frame.size.height/2 - 15)), 30.0, 30.0)];
        
        //Faq text view
        [_tvFaqTextView setFrame: CGRectMake(48.0, (_lblContactUsTitleLabel.frame.origin.y + _lblContactUsTitleLabel.frame.size.height + 48.0), (DEVICE_WIDTH - 48.0), 150.0)];
        fontFaqPlaceholder = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [_viewFaqUnderlineView setFrame: CGRectMake(48.0, (_tvFaqTextView.frame.origin.y + _tvFaqTextView.frame.size.height + 2.0), (DEVICE_WIDTH - 48.0), 2.0)];
        
        //Send faq button
        
        [_btnSendFaqButton setFrame: CGRectMake(60.0, (_viewFaqUnderlineView.frame.origin.y + 40.0), (DEVICE_WIDTH - 120.0), 60.0)];
        UIFont *fontStartButton = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 28.0];
        NSDictionary *dicStartButton = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                          NSFontAttributeName : fontStartButton
                                          };
        NSAttributedString *attStartButton = [[NSAttributedString alloc] initWithString: @"Send" attributes: dicStartButton];
        [_btnSendFaqButton setAttributedTitle: attStartButton forState: UIControlStateNormal];
    }
    
    [_tvFaqTextView setTintColor: cSTART_BUTTON];
    [_tvFaqTextView setFont: fontFaqPlaceholder];
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(4.0, -3.0, _tvFaqTextView.frame.size.width - 4.0, 60.0)];
    [lbl setNumberOfLines: 0];
    [lbl setLineBreakMode: NSLineBreakByWordWrapping];
    [lbl setText: @" Feedback? Questions?\nWe're listening."];
    [lbl setFont: fontFaqPlaceholder];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextColor:[UIColor darkGrayColor]];
    [lbl setAlpha: 0.4];
    [_tvFaqTextView addSubview:lbl];
    _tvFaqTextView.delegate = self;
    
    [self showScreenContents];
    
}

- (void) initializeData {
    
    serviceManager = [[ServiceManager alloc] init];
    [serviceManager setDelegate: self];
    
    utils = [[Utils alloc] init];
    progressHUD = [utils prototypeHUD];
    
    [_tvFaqTextView becomeFirstResponder];
    
    UITapGestureRecognizer *viewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTapOnMainView:)];
    [[self view] addGestureRecognizer: viewTapGesture];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(handleSwipeOnMainView:)];
    [[self view] addGestureRecognizer: swipeGesture];
    
}

- (void) handleTapOnMainView: (UITapGestureRecognizer *) tapGesture {
    [[self view] endEditing: YES];
}

- (void) handleSwipeOnMainView: (UISwipeGestureRecognizer *) swipe {
    
    if ([swipe direction] == UISwipeGestureRecognizerDirectionRight) {
        [[self navigationController] popViewControllerAnimated: YES];
//        NSMutableArray *arrTabbarVC = [[[self tabBarController] viewControllers] mutableCopy];
//        [arrTabbarVC setObject: GETCONTROLLER(@"SettingsViewController") atIndexedSubscript: 2];
//        [[self tabBarController] setViewControllers: arrTabbarVC animated: NO];
    }
    
}

- (void) showScreenContents {
    [_viewLoaderBackgroundView setHidden: YES];
    [_btnBackButton setHidden: NO];
    [_lblContactUsTitleLabel setHidden: NO];
    [_tvFaqTextView setHidden: NO];
    [_viewFaqUnderlineView setHidden: NO];
    [_btnSendFaqButton setHidden: NO];
}

- (void) hideScreenContents {
    [_viewLoaderBackgroundView setHidden: NO];
    [_btnBackButton setHidden: YES];
    [_lblContactUsTitleLabel setHidden: YES];
    [_tvFaqTextView setHidden: YES];
    [_viewFaqUnderlineView setHidden: YES];
    [_btnSendFaqButton setHidden: YES];
}


@end
