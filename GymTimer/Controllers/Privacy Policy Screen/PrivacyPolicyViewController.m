//
//  PrivacyPolicyViewController.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 18/04/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "PrivacyPolicyViewController.h"
#import "CommonImports.h"

@interface PrivacyPolicyViewController () <UITabBarControllerDelegate, ServiceManagerDelegate, UIScrollViewDelegate>
{
    
    ServiceManager *serviceManager;
    Utils *utils;
    JGProgressHUD *progressHUD;
    CGFloat currentScrollViewYOffset;
    UIActivityIndicatorView *spinner;
    
}
@end

@implementation PrivacyPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLayout];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self initializeData];
    
}


//MARK:- Button's action method

- (IBAction)btnBackButtonTapped:(UIButton *)sender {
    [[self navigationController] popViewControllerAnimated: YES];
//    NSMutableArray *arrTabbarVC = [[[self tabBarController] viewControllers] mutableCopy];
//    [arrTabbarVC setObject: GETCONTROLLER(@"SettingsViewController") atIndexedSubscript: 2];
//    [[self tabBarController] setViewControllers: arrTabbarVC animated: NO];
}


//MARK:- UIScrollView's delegate methods

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    CGFloat nextScrollViewYOffset = [scrollView contentOffset].y;
//    if ((nextScrollViewYOffset > -44.0) && (nextScrollViewYOffset > currentScrollViewYOffset)) {
//        currentScrollViewYOffset = nextScrollViewYOffset;
//    } else if ((currentScrollViewYOffset > -44.0) && (nextScrollViewYOffset < currentScrollViewYOffset)) {
//        [UIView animateWithDuration: 0.4 delay: 0.0 options: UIViewAnimationOptionTransitionNone animations:^{
//            [scrollView setContentOffset: CGPointMake(0.0, -44.0) animated: NO];
//        } completion:^(BOOL finished) {
//
//        }];
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
            [scrollView setContentOffset: CGPointMake(0.0, -20.0) animated: NO];
        } else if (IS_IPHONE8) {
            [scrollView setContentOffset: CGPointMake(0.0, -20.0) animated: NO];
        } else {
            [scrollView setContentOffset: CGPointMake(0.0, -20.0) animated: NO];
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
            [scrollView setContentOffset: CGPointMake(0.0, -20.0) animated: NO];
        } else if (IS_IPHONE8) {
            [scrollView setContentOffset: CGPointMake(0.0, -20.0) animated: NO];
        } else {
            [scrollView setContentOffset: CGPointMake(0.0, -20.0) animated: NO];
        }
    } completion:^(BOOL finished) {}];
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


//MARK:- Service manager delegate and parser methods

- (void)webServiceCallFailure:(NSError *)error forTag:(NSString *)tagname {
    NSLog(@"Web service call fails : %@", [error localizedDescription]);
    [Utils hideActivityIndicator:spinner fromView:self.viewLoaderContentView];
    [self showScreenContents];
    [Utils showToast: [error localizedDescription] duration: 3.0];
}

- (void)webServiceCallSuccess:(id)response forTag:(NSString *)tagname {
    
    if ([tagname isEqualToString: tCMS_PAGE]) {
        [self parsePrivacyPolicyResponse: response];
    }
    
}

- (void) parsePrivacyPolicyResponse: (id) response {
    
    [Utils hideActivityIndicator:spinner fromView:self.viewLoaderContentView];
    [self showScreenContents];
    
    NSMutableDictionary *dicResponse = (NSMutableDictionary *)response;
    
    if ([[dicResponse valueForKey:@"status"] integerValue] == 1) {
        
        NSString *strPrivacyPolicyContent = [[dicResponse valueForKey: @"data"] valueForKey: @"content"];
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData: [strPrivacyPolicyContent dataUsingEncoding:NSUnicodeStringEncoding] options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes: nil error: nil];
        
        UIFont *fontPrivacyPolicy = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [_tvPrivacyPolicyTextView setFont: fontPrivacyPolicy];
        [_tvPrivacyPolicyTextView setAttributedText: attributedString];
        
    } else {
        [Utils showToast: [dicResponse valueForKey: @"message"] duration: 3.0];
    }
    
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
    
    //Scroll and content view
    [_scrollViewPrivacyPolicy setFrame: CGRectMake(0.0, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    [_scrollViewPrivacyPolicy setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + 100.0)];
    [_scrollViewPrivacyPolicy setDelegate: self];
    [_contentViewPrivacyPolicy setFrame: CGRectMake(0.0, 0.0, (_scrollViewPrivacyPolicy.frame.size.width), (_scrollViewPrivacyPolicy.frame.size.height + 100.0))];
    
    [_lblPrivacyPolicyTitleLabel setTextColor: cSTART_BUTTON];
    [_tvPrivacyPolicyTextView setTextColor: UIColor.blackColor];
    
    if (IS_IPHONEXR) {
        //Loader view
        [_lblLoaderGymTimerLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblLoaderGymTimerLabel setFont: fontGymTimerLabel];
        [_viewLoaderContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        //Settings label
        [_lblPrivacyPolicyTitleLabel setFrame: CGRectMake((DEVICE_WIDTH - 200.0) / 2.0, 0.0, 200.0, 150.0)];
        UIFont *fontSettings = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 43.5];
        [_lblPrivacyPolicyTitleLabel setFont: fontSettings];
        [_lblPrivacyPolicyTitleLabel setNumberOfLines: 0];
        [_lblPrivacyPolicyTitleLabel setLineBreakMode: NSLineBreakByWordWrapping];
        
        //Back button frame
        [_btnBackButton setFrame: CGRectMake(20.0, (_lblPrivacyPolicyTitleLabel.frame.origin.y + (_lblPrivacyPolicyTitleLabel.frame.size.height/2 - 15)), 30.0, 30.0)];
        
        //Privacy policy text view frame
        CGFloat privacyPolicyY = (_lblPrivacyPolicyTitleLabel.frame.origin.y + _lblPrivacyPolicyTitleLabel.frame.size.height + 32.0);
        [_tvPrivacyPolicyTextView setFrame: CGRectMake(32.0, privacyPolicyY, (DEVICE_WIDTH - 64.0), (DEVICE_HEIGHT - (privacyPolicyY + 32.0)))];
        UIFont *fontPrivacyPolicy = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [_tvPrivacyPolicyTextView setFont: fontPrivacyPolicy];
    } else if (IS_IPHONEX) {
        
        //Loader view
        [_lblLoaderGymTimerLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblLoaderGymTimerLabel setFont: fontGymTimerLabel];
        [_viewLoaderContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        //Settings label
        [_lblPrivacyPolicyTitleLabel setFrame: CGRectMake((DEVICE_WIDTH - 200.0) / 2.0, 0.0, 200.0, 150.0)];
        UIFont *fontSettings = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 43.5];
        [_lblPrivacyPolicyTitleLabel setFont: fontSettings];
        [_lblPrivacyPolicyTitleLabel setNumberOfLines: 0];
        [_lblPrivacyPolicyTitleLabel setLineBreakMode: NSLineBreakByWordWrapping];
        
        //Back button frame
        [_btnBackButton setFrame: CGRectMake(20.0, (_lblPrivacyPolicyTitleLabel.frame.origin.y + (_lblPrivacyPolicyTitleLabel.frame.size.height/2 - 15)), 30.0, 30.0)];
        
        //Privacy policy text view frame
        CGFloat privacyPolicyY = (_lblPrivacyPolicyTitleLabel.frame.origin.y + _lblPrivacyPolicyTitleLabel.frame.size.height + 32.0);
        [_tvPrivacyPolicyTextView setFrame: CGRectMake(32.0, privacyPolicyY, (DEVICE_WIDTH - 64.0), (DEVICE_HEIGHT - (privacyPolicyY + 32.0)))];
        UIFont *fontPrivacyPolicy = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [_tvPrivacyPolicyTextView setFont: fontPrivacyPolicy];
        
    } else if (IS_IPHONE8PLUS) {
        //Loader view
        [_lblLoaderGymTimerLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblLoaderGymTimerLabel setFont: fontGymTimerLabel];
        [_viewLoaderContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        //Settings label
        [_lblPrivacyPolicyTitleLabel setFrame: CGRectMake((DEVICE_WIDTH - 200.0) / 2.0, 0.0, 200.0, 150.0)];
        UIFont *fontSettings = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 43.5];
        [_lblPrivacyPolicyTitleLabel setFont: fontSettings];
        [_lblPrivacyPolicyTitleLabel setNumberOfLines: 0];
        [_lblPrivacyPolicyTitleLabel setLineBreakMode: NSLineBreakByWordWrapping];
        
        //Back button frame
        [_btnBackButton setFrame: CGRectMake(20.0, (_lblPrivacyPolicyTitleLabel.frame.origin.y + (_lblPrivacyPolicyTitleLabel.frame.size.height/2 - 15)), 30.0, 30.0)];
        
        //Privacy policy text view frame
        CGFloat privacyPolicyY = (_lblPrivacyPolicyTitleLabel.frame.origin.y + _lblPrivacyPolicyTitleLabel.frame.size.height + 32.0);
        [_tvPrivacyPolicyTextView setFrame: CGRectMake(32.0, privacyPolicyY, (DEVICE_WIDTH - 64.0), (DEVICE_HEIGHT - (privacyPolicyY + 32.0)))];
        UIFont *fontPrivacyPolicy = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [_tvPrivacyPolicyTextView setFont: fontPrivacyPolicy];
    } else if (IS_IPHONE8) {
        //Loader view
        [_lblLoaderGymTimerLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblLoaderGymTimerLabel setFont: fontGymTimerLabel];
        [_viewLoaderContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        //Settings label
        [_lblPrivacyPolicyTitleLabel setFrame: CGRectMake((DEVICE_WIDTH - 200.0) / 2.0, 0.0, 200.0, 150.0)];
        UIFont *fontSettings = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 43.5];
        [_lblPrivacyPolicyTitleLabel setFont: fontSettings];
        [_lblPrivacyPolicyTitleLabel setNumberOfLines: 0];
        [_lblPrivacyPolicyTitleLabel setLineBreakMode: NSLineBreakByWordWrapping];
        
        //Back button frame
        [_btnBackButton setFrame: CGRectMake(20.0, (_lblPrivacyPolicyTitleLabel.frame.origin.y + (_lblPrivacyPolicyTitleLabel.frame.size.height/2 - 15)), 30.0, 30.0)];
        
        //Privacy policy text view frame
        CGFloat privacyPolicyY = (_lblPrivacyPolicyTitleLabel.frame.origin.y + _lblPrivacyPolicyTitleLabel.frame.size.height + 32.0);
        [_tvPrivacyPolicyTextView setFrame: CGRectMake(32.0, privacyPolicyY, (DEVICE_WIDTH - 64.0), (DEVICE_HEIGHT - (privacyPolicyY + 32.0)))];
        UIFont *fontPrivacyPolicy = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [_tvPrivacyPolicyTextView setFont: fontPrivacyPolicy];
    } else {
        //Loader view
        [_lblLoaderGymTimerLabel setFrame: CGRectMake(0.0, 36.0, DEVICE_WIDTH, 40.0)];
        UIFont *fontGymTimerLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblLoaderGymTimerLabel setFont: fontGymTimerLabel];
        [_viewLoaderContentView setFrame: CGRectMake(0.0, 102.0, DEVICE_WIDTH, DEVICE_HEIGHT - 102.0)];
        
        //Settings label
        [_lblPrivacyPolicyTitleLabel setFrame: CGRectMake((DEVICE_WIDTH - 200.0) / 2.0, 0.0, 200.0, 150.0)];
        UIFont *fontSettings = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 43.5];
        [_lblPrivacyPolicyTitleLabel setFont: fontSettings];
        [_lblPrivacyPolicyTitleLabel setNumberOfLines: 0];
        [_lblPrivacyPolicyTitleLabel setLineBreakMode: NSLineBreakByWordWrapping];
        
        //Back button frame
        [_btnBackButton setFrame: CGRectMake(20.0, (_lblPrivacyPolicyTitleLabel.frame.origin.y + (_lblPrivacyPolicyTitleLabel.frame.size.height/2 - 15)), 30.0, 30.0)];
        
        //Privacy policy text view frame
        CGFloat privacyPolicyY = (_lblPrivacyPolicyTitleLabel.frame.origin.y + _lblPrivacyPolicyTitleLabel.frame.size.height + 32.0);
        [_tvPrivacyPolicyTextView setFrame: CGRectMake(32.0, privacyPolicyY, (DEVICE_WIDTH - 64.0), (DEVICE_HEIGHT - (privacyPolicyY + 32.0)))];
        UIFont *fontPrivacyPolicy = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [_tvPrivacyPolicyTextView setFont: fontPrivacyPolicy];
    }
    
    [self showScreenContents];
    
}

- (void) initializeData {
    
    serviceManager = [[ServiceManager alloc] init];
    [serviceManager setDelegate: self];
    
    utils = [[Utils alloc] init];
    progressHUD = [utils prototypeHUD];
    
    [self callPrivacyPolicyAPI];
    
    currentScrollViewYOffset = [_scrollViewPrivacyPolicy contentOffset].y;
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(handleSwipeOnMainView:)];
    [[self view] addGestureRecognizer: swipeGesture];
    
}

- (void) callPrivacyPolicyAPI {
    
    NSArray *arrSendFaqParams = @[
                                  @{ @"type" : @"privacy_policy" }
                                  ];
    
    if ([Utils isConnectedToInternet]) {
        
        [self hideScreenContents];
        spinner = [Utils showActivityIndicatorInView: self.viewLoaderContentView];
        NSString *webpath = [NSString stringWithFormat:@"%@%@", uBASE_URL, uCMS_PAGE];
        [serviceManager callWebServiceWithPOST: webpath withTag: tCMS_PAGE params: arrSendFaqParams];
        
    } 
    
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
    [_scrollViewPrivacyPolicy setHidden: NO];
}

- (void) hideScreenContents {
    [_viewLoaderBackgroundView setHidden: NO];
    [_scrollViewPrivacyPolicy setHidden: YES];
}


@end
