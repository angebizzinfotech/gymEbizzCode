//
//  WorkoutAdviceViewController.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 18/04/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "WorkoutAdviceViewController.h"
#import "CommonImports.h"

@interface WorkoutAdviceViewController () <UITabBarControllerDelegate, UIScrollViewDelegate>
{
    
    UIFont *fontEnduranceMuscleStrengthSubtitle, *fontEnduranceMuscleStrengthSubtitleBold, *fontEnduranceMuscleStrengthCount, *fontEnduranceMuscleStrengthTitle, *fontSubTitleLabel, *fontSubSubTitleLabel;
    CGFloat currentScrollViewYOffset;
    
}
@end

@implementation WorkoutAdviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLayout];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self initializeData];
    
}


//MARK:- Button's action methods

- (IBAction)btnBackButtonTapped:(UIButton *)sender {
    
    [[self navigationController] popViewControllerAnimated: YES];
//    NSMutableArray *arrTabbarVC = [[[self tabBarController] viewControllers] mutableCopy];
//    [arrTabbarVC setObject: GETCONTROLLER(@"SettingsViewController") atIndexedSubscript: 2];
//    [[self tabBarController] setViewControllers: arrTabbarVC animated: NO];
    
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


//MARK:- UIScrollView's delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
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
    
}

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


//MARK:- User defined methods

- (void) setupLayout {
    
    [self resetProgressView];
    
    //Tabbar initialization
    [[self tabBarController] setDelegate: self];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 0] setTitle: @"Workout"];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 1] setTitle: @"Ranking"];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 2] setTitle: @"Stats"];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 3] setTitle: @"Settings"];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 3] setTitlePositionAdjustment: UIOffsetMake(0.0, 12.0)];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 3] setImage: [UIImage imageNamed: @"imgSettingsGreen"]];
    [[[[[self tabBarController] tabBar] items] objectAtIndex: 3] setImageInsets: UIEdgeInsetsMake(0.0, 0.0, -15.0, 0.0)];
    
    //Advice title label
    [_lblAdviceTitleLabel setTextColor: cSTART_BUTTON];
    [_lblAdviceSubTitleLabel setTextColor: UIColor.grayColor];
    
    //Progress bar setup
    [self setupProgressBarRecommendedRestTime];
    [self setupProgressBarEndurance];
    [self setupProgressBarMuscle];
    [self setupProgressBarStrength];
    
    //Endurance, muscle and strength title
    [_lblEnduranceProgressCountLabel setTextColor: UIColor.whiteColor];
    [_lblEnduranceTitleLabel setTextColor: UIColor.whiteColor];
    [_lblEnduranceSubtitleLabel setTextColor: UIColor.whiteColor];
    [_lblMuscleProgressBarCount setTextColor: UIColor.whiteColor];
    [_lblMuscleTitleLabel setTextColor: UIColor.whiteColor];
    [_lblMuscleSubtitleLabel setTextColor: UIColor.whiteColor];
    [_lblStrengthProgressBarCount setTextColor: UIColor.whiteColor];
    [_lblStrengthTitleLabel setTextColor: UIColor.whiteColor];
    [_lblStrengthSubtitleLabel setTextColor: UIColor.whiteColor];
    
    if (IS_IPHONEXR) {
        
        //Scroll and content view
        [_viewWorkoutAdviceScrollView setFrame: CGRectMake(0.0, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        [_viewWorkoutAdviceScrollView setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + 100.0)];
        [_viewWorkoutAdviceScrollView setDelegate: self];
        [_viewWorkoutAdviceContentView setFrame: CGRectMake(0.0, 0.0, (_viewWorkoutAdviceScrollView.frame.size.width), (_viewWorkoutAdviceScrollView.frame.size.height + 100.0))];
        
        //Contact us label
        [_lblAdviceTitleLabel setFrame: CGRectMake(0.0, 20.0, DEVICE_WIDTH, 90.0)];
        UIFont *fontSettings = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 71.0];
        [_lblAdviceTitleLabel setFont: fontSettings];
        
        //Back button frame
        [_btnBackButton setFrame: CGRectMake(17.0, (_lblAdviceTitleLabel.frame.origin.y + (_lblAdviceTitleLabel.frame.size.height/2 - 17.0)), 34.0, 34.0)];
        
        //Advice sub title label frame
        CGFloat adviceSubtitleY = (_lblAdviceTitleLabel.frame.origin.y + _lblAdviceSubTitleLabel.frame.size.height + 54.0);
        [_lblAdviceSubTitleLabel setFrame: CGRectMake(20.0, adviceSubtitleY, (DEVICE_WIDTH - 40.0), 50.0)];
        UIFont *fontAdviceSubtitle = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [_lblAdviceSubTitleLabel setFont: fontAdviceSubtitle];
        
        //Recommended rest view frame
        CGFloat recommendedViewY = (_lblAdviceSubTitleLabel.frame.origin.y + _lblAdviceSubTitleLabel.frame.size.height + 27.0);
        [_viewRecommendedRestTimeContentView setFrame: CGRectMake(0.0, recommendedViewY, DEVICE_WIDTH, 30.0)];
        [_progressBarRecommendedRestView setFrame: CGRectMake(64.0, 3.0, 23.5, 23.5)];
        [_lblRecommendedRestTimeLabel setFrame: CGRectMake(98.0, 0.0, (DEVICE_WIDTH - 110.0), 30.0)];
        UIFont *fontRecommendedRest = [UIFont fontWithName: fFUTURA_MEDIUM size: 13.8];
        [_lblRecommendedRestTimeLabel setFont: fontRecommendedRest];
        
        //Endurance view frame
        [_viewEnduranceContentView setBackgroundColor: cENDURANCE_VIEW];
        CGFloat enduranceViewY = (_viewRecommendedRestTimeContentView.frame.origin.y + _viewRecommendedRestTimeContentView.frame.size.height + 11.0);
        [_viewEnduranceContentView setFrame: CGRectMake(14.0, enduranceViewY, (DEVICE_WIDTH - 28.0), 159.0)];
        [[_viewEnduranceContentView layer] setCornerRadius: 32.0];
        
        [_progressBarEnduranceView setFrame: CGRectMake(14.0, (_viewEnduranceContentView.frame.size.height - 114.0) / 2.0, 114.0, 114.0)];
        [_lblEnduranceProgressCountLabel setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
        [_lblEnduranceProgressCountLabel setFrame: CGRectMake(0.0, ((_progressBarEnduranceView.frame.size.height - 30.0) / 2.0), (_progressBarEnduranceView.frame.size.width), 30.0)];
        fontEnduranceMuscleStrengthCount = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 33.1];
        [_lblEnduranceProgressCountLabel setFont: fontEnduranceMuscleStrengthCount];
        
        CGFloat enduranceTitleX = (_progressBarEnduranceView.frame.origin.x + _progressBarEnduranceView.frame.size.width + 14.0);
        CGFloat enduranceTitleY = (_progressBarEnduranceView.frame.origin.y + 10.0);
        CGFloat enduranceTitleWidth = (DEVICE_WIDTH - enduranceTitleX);
        [_lblEnduranceTitleLabel setFrame: CGRectMake(enduranceTitleX, enduranceTitleY, enduranceTitleWidth, 25.0)];
        fontEnduranceMuscleStrengthTitle = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblEnduranceTitleLabel setFont: fontEnduranceMuscleStrengthTitle];
        
        CGFloat enduranceSubtitleHeight = (140.0 - (_lblEnduranceTitleLabel.frame.size.height + enduranceTitleY)) / 3.0;
        [_lblEnduranceSubtitleLabel setFrame: CGRectMake(enduranceTitleX, (enduranceTitleY + 30.0), (enduranceTitleWidth - 80.0), (enduranceSubtitleHeight * 2))];
        fontEnduranceMuscleStrengthSubtitle = [UIFont fontWithName: fFUTURA_MEDIUM size: 16.0];
        fontEnduranceMuscleStrengthSubtitleBold = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 12.0];
        fontSubTitleLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        fontSubSubTitleLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 14.0];
        [_lblEnduranceSubtitleLabel setFont: fontEnduranceMuscleStrengthSubtitle];
        [_lblEnduranceSubtitleLabel setText: @"Resist longer and burn more calories."];
        
        [_lblEnduranceDoSetsLabel setFrame: CGRectMake(enduranceTitleX, (_lblEnduranceSubtitleLabel.frame.origin.y + (enduranceSubtitleHeight * 2) - 8.0), (enduranceTitleWidth - 60.0), enduranceSubtitleHeight)];
        [_lblEnduranceDoSetsLabel setAttributedText: [self createAttributedEnduranceSubtitleString]];
        
        
        //Muscle view
        [_viewMuscleContentView setBackgroundColor: cMUSCLE_VIEW];
        CGFloat muscleViewY = (_viewEnduranceContentView.frame.origin.y + _viewEnduranceContentView.frame.size.height + 12.0);
        [_viewMuscleContentView setFrame: CGRectMake(14.0, muscleViewY, (DEVICE_WIDTH - 28.0), 159.0)];
        [_viewMuscleContentView setClipsToBounds: YES];
        [[_viewMuscleContentView layer] setCornerRadius: 32.0];
        
        [_progressBarMuscleView setFrame: CGRectMake(14.0, (_viewMuscleContentView.frame.size.height - 114.0) / 2.0, 114.0, 114.0)];
        [_lblMuscleProgressBarCount setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
        [_lblMuscleProgressBarCount setFrame: CGRectMake(0.0, ((_progressBarMuscleView.frame.size.height - 30.0) / 2.0), (_progressBarMuscleView.frame.size.width), 30.0)];
        [_lblMuscleProgressBarCount setFont: fontEnduranceMuscleStrengthCount];
        
        CGFloat muscleTitleX = (_progressBarMuscleView.frame.origin.x + _progressBarMuscleView.frame.size.width + 14.0);
        CGFloat muscleTitleY = (_progressBarMuscleView.frame.origin.y + 10.0);
        CGFloat muscleTitleWidth = (DEVICE_WIDTH - muscleTitleX);
        [_lblMuscleTitleLabel setFrame: CGRectMake(muscleTitleX, muscleTitleY, muscleTitleWidth, 25.0)];
        [_lblMuscleTitleLabel setFont: fontEnduranceMuscleStrengthTitle];
        
        CGFloat muscleSubtitleHeight = (140.0 - (_lblEnduranceTitleLabel.frame.size.height + enduranceTitleY)) / 3.0;
        [_lblMuscleSubtitleLabel setFrame: CGRectMake(muscleTitleX, (muscleTitleY + 30.0), (muscleTitleWidth - 80.0), (muscleSubtitleHeight * 2))];
        [_lblMuscleSubtitleLabel setFont: fontEnduranceMuscleStrengthSubtitle];
        [_lblMuscleSubtitleLabel setText: @"Build stronger and more visible muscle."];
        
        [_lblMuscleDoSetsLabel setFrame: CGRectMake(muscleTitleX, (_lblMuscleSubtitleLabel.frame.origin.y + (muscleSubtitleHeight * 2) - 8.0), (muscleTitleWidth - 60.0), muscleSubtitleHeight)];
        [_lblMuscleDoSetsLabel setAttributedText: [self createAttributedMuscleSubtitleString]];
        
        
        //Strength view
        [_viewStrengthContentView setBackgroundColor: cSTRENGTH_VIEW];
        CGFloat strengthViewY = (_viewMuscleContentView.frame.origin.y + _viewMuscleContentView.frame.size.height + 12.0);
        [_viewStrengthContentView setFrame: CGRectMake(14.0, strengthViewY, (DEVICE_WIDTH - 28.0), 159.0)];
        [_viewStrengthContentView setClipsToBounds: YES];
        [[_viewStrengthContentView layer] setCornerRadius: 32.0];
        
        [_progressBarStrengthView setFrame: CGRectMake(14.0, (_viewStrengthContentView.frame.size.height - 114.0) / 2.0, 114.0, 114.0)];
        [_lblStrengthProgressBarCount setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
        [_lblStrengthProgressBarCount setFrame: CGRectMake(0.0, ((_progressBarStrengthView.frame.size.height - 30.0) / 2.0), (_progressBarStrengthView.frame.size.width), 30.0)];
        [_lblStrengthProgressBarCount setFont: fontEnduranceMuscleStrengthCount];
        
        CGFloat strengthTitleX = (_progressBarStrengthView.frame.origin.x + _progressBarStrengthView.frame.size.width + 14.0);
        CGFloat strengthTitleY = (_progressBarStrengthView.frame.origin.y + 10.0);
        CGFloat strengthTitleWidth = (DEVICE_WIDTH - strengthTitleX);
        [_lblStrengthTitleLabel setFrame: CGRectMake(strengthTitleX, strengthTitleY, strengthTitleWidth, 25.0)];
        [_lblStrengthTitleLabel setFont: fontEnduranceMuscleStrengthTitle];
        
        CGFloat strengthSubtitleHeight = (140.0 - (_lblStrengthTitleLabel.frame.size.height + muscleTitleY)) / 3.0;
        [_lblStrengthSubtitleLabel setFrame: CGRectMake(strengthTitleX, (strengthTitleY + 30.0), (strengthTitleWidth - 40.0), (strengthSubtitleHeight * 2))];
        [_lblStrengthSubtitleLabel setFont: fontEnduranceMuscleStrengthSubtitle];
        [_lblStrengthSubtitleLabel setText: @"Become stronger and more powerful."];
        
        [_lblStrengthDoSetsLabel setFrame: CGRectMake(strengthTitleX, (_lblStrengthSubtitleLabel.frame.origin.y + (strengthSubtitleHeight * 2) - 8.0), (strengthTitleWidth - 60.0), strengthSubtitleHeight)];
        [_lblStrengthDoSetsLabel setAttributedText: [self createAttributedStrengthSubtitleString]];
        
    } else if (IS_IPHONEX) {
        
        //Scroll and content view
        [_viewWorkoutAdviceScrollView setFrame: CGRectMake(0.0, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        [_viewWorkoutAdviceScrollView setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + 100.0)];
        [_viewWorkoutAdviceScrollView setDelegate: self];
        [_viewWorkoutAdviceContentView setFrame: CGRectMake(0.0, 0.0, (_viewWorkoutAdviceScrollView.frame.size.width), (_viewWorkoutAdviceScrollView.frame.size.height + 100.0))];
        
        //Contact us label
        [_lblAdviceTitleLabel setFrame: CGRectMake(0.0, 20.0, DEVICE_WIDTH, 90.0)];
        UIFont *fontSettings = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 71.0];
        [_lblAdviceTitleLabel setFont: fontSettings];
        
        //Back button frame
        [_btnBackButton setFrame: CGRectMake(17.0, (_lblAdviceTitleLabel.frame.origin.y + (_lblAdviceTitleLabel.frame.size.height/2 - 17.0)), 34.0, 34.0)];
        
        //Advice sub title label frame
        CGFloat adviceSubtitleY = (_lblAdviceTitleLabel.frame.origin.y + _lblAdviceSubTitleLabel.frame.size.height + 54.0);
        [_lblAdviceSubTitleLabel setFrame: CGRectMake(20.0, adviceSubtitleY, (DEVICE_WIDTH - 40.0), 50.0)];
        UIFont *fontAdviceSubtitle = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [_lblAdviceSubTitleLabel setFont: fontAdviceSubtitle];
        
        //Recommended rest view frame
        CGFloat recommendedViewY = (_lblAdviceSubTitleLabel.frame.origin.y + _lblAdviceSubTitleLabel.frame.size.height + 27.0);
        [_viewRecommendedRestTimeContentView setFrame: CGRectMake(0.0, recommendedViewY, DEVICE_WIDTH, 30.0)];
        [_progressBarRecommendedRestView setFrame: CGRectMake(64.0, 3.0, 23.5, 23.5)];
        [_lblRecommendedRestTimeLabel setFrame: CGRectMake(98.0, 0.0, (DEVICE_WIDTH - 110.0), 30.0)];
        UIFont *fontRecommendedRest = [UIFont fontWithName: fFUTURA_MEDIUM size: 13.8];
        [_lblRecommendedRestTimeLabel setFont: fontRecommendedRest];
        
        //Endurance view frame
        [_viewEnduranceContentView setBackgroundColor: cENDURANCE_VIEW];
        CGFloat enduranceViewY = (_viewRecommendedRestTimeContentView.frame.origin.y + _viewRecommendedRestTimeContentView.frame.size.height + 11.0);
        [_viewEnduranceContentView setFrame: CGRectMake(14.0, enduranceViewY, (DEVICE_WIDTH - 28.0), 159.0)];
        [[_viewEnduranceContentView layer] setCornerRadius: 32.0];
        
        [_progressBarEnduranceView setFrame: CGRectMake(14.0, (_viewEnduranceContentView.frame.size.height - 114.0) / 2.0, 114.0, 114.0)];
        [_lblEnduranceProgressCountLabel setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
        [_lblEnduranceProgressCountLabel setFrame: CGRectMake(0.0, ((_progressBarEnduranceView.frame.size.height - 30.0) / 2.0), (_progressBarEnduranceView.frame.size.width), 30.0)];
        fontEnduranceMuscleStrengthCount = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 33.1];
        [_lblEnduranceProgressCountLabel setFont: fontEnduranceMuscleStrengthCount];
        
        CGFloat enduranceTitleX = (_progressBarEnduranceView.frame.origin.x + _progressBarEnduranceView.frame.size.width + 14.0);
        CGFloat enduranceTitleY = (_progressBarEnduranceView.frame.origin.y + 10.0);
        CGFloat enduranceTitleWidth = (DEVICE_WIDTH - enduranceTitleX);
        [_lblEnduranceTitleLabel setFrame: CGRectMake(enduranceTitleX, enduranceTitleY, enduranceTitleWidth, 25.0)];
        fontEnduranceMuscleStrengthTitle = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblEnduranceTitleLabel setFont: fontEnduranceMuscleStrengthTitle];
        
        CGFloat enduranceSubtitleHeight = (140.0 - (_lblEnduranceTitleLabel.frame.size.height + enduranceTitleY)) / 3.0;
        [_lblEnduranceSubtitleLabel setFrame: CGRectMake(enduranceTitleX, (enduranceTitleY + 30.0), (enduranceTitleWidth - 80.0), (enduranceSubtitleHeight * 2))];
        fontEnduranceMuscleStrengthSubtitle = [UIFont fontWithName: fFUTURA_MEDIUM size: 16.0];
        fontEnduranceMuscleStrengthSubtitleBold = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 12.0];
        fontSubTitleLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        fontSubSubTitleLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 14.0];
        [_lblEnduranceSubtitleLabel setFont: fontEnduranceMuscleStrengthSubtitle];
        [_lblEnduranceSubtitleLabel setText: @"Resist longer and burn more calories."];
        
        [_lblEnduranceDoSetsLabel setFrame: CGRectMake(enduranceTitleX, (_lblEnduranceSubtitleLabel.frame.origin.y + (enduranceSubtitleHeight * 2) - 8.0), (enduranceTitleWidth - 60.0), enduranceSubtitleHeight)];
        [_lblEnduranceDoSetsLabel setAttributedText: [self createAttributedEnduranceSubtitleString]];
        
        
        //Muscle view
        [_viewMuscleContentView setBackgroundColor: cMUSCLE_VIEW];
        CGFloat muscleViewY = (_viewEnduranceContentView.frame.origin.y + _viewEnduranceContentView.frame.size.height + 12.0);
        [_viewMuscleContentView setFrame: CGRectMake(14.0, muscleViewY, (DEVICE_WIDTH - 28.0), 159.0)];
        [_viewMuscleContentView setClipsToBounds: YES];
        [[_viewMuscleContentView layer] setCornerRadius: 32.0];
        
        [_progressBarMuscleView setFrame: CGRectMake(14.0, (_viewMuscleContentView.frame.size.height - 114.0) / 2.0, 114.0, 114.0)];
        [_lblMuscleProgressBarCount setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
        [_lblMuscleProgressBarCount setFrame: CGRectMake(0.0, ((_progressBarMuscleView.frame.size.height - 30.0) / 2.0), (_progressBarMuscleView.frame.size.width), 30.0)];
        [_lblMuscleProgressBarCount setFont: fontEnduranceMuscleStrengthCount];
        
        CGFloat muscleTitleX = (_progressBarMuscleView.frame.origin.x + _progressBarMuscleView.frame.size.width + 14.0);
        CGFloat muscleTitleY = (_progressBarMuscleView.frame.origin.y + 10.0);
        CGFloat muscleTitleWidth = (DEVICE_WIDTH - muscleTitleX);
        [_lblMuscleTitleLabel setFrame: CGRectMake(muscleTitleX, muscleTitleY, muscleTitleWidth, 25.0)];
        [_lblMuscleTitleLabel setFont: fontEnduranceMuscleStrengthTitle];
        
        CGFloat muscleSubtitleHeight = (140.0 - (_lblEnduranceTitleLabel.frame.size.height + enduranceTitleY)) / 3.0;
        [_lblMuscleSubtitleLabel setFrame: CGRectMake(muscleTitleX, (muscleTitleY + 30.0), (muscleTitleWidth - 80.0), (muscleSubtitleHeight * 2))];
        [_lblMuscleSubtitleLabel setFont: fontEnduranceMuscleStrengthSubtitle];
        [_lblMuscleSubtitleLabel setText: @"Build stronger and more visible muscle."];
        
        [_lblMuscleDoSetsLabel setFrame: CGRectMake(muscleTitleX, (_lblMuscleSubtitleLabel.frame.origin.y + (muscleSubtitleHeight * 2) - 8.0), (muscleTitleWidth - 60.0), muscleSubtitleHeight)];
        [_lblMuscleDoSetsLabel setAttributedText: [self createAttributedMuscleSubtitleString]];
        
        
        //Strength view
        [_viewStrengthContentView setBackgroundColor: cSTRENGTH_VIEW];
        CGFloat strengthViewY = (_viewMuscleContentView.frame.origin.y + _viewMuscleContentView.frame.size.height + 12.0);
        [_viewStrengthContentView setFrame: CGRectMake(14.0, strengthViewY, (DEVICE_WIDTH - 28.0), 159.0)];
        [_viewStrengthContentView setClipsToBounds: YES];
        [[_viewStrengthContentView layer] setCornerRadius: 32.0];
        
        [_progressBarStrengthView setFrame: CGRectMake(14.0, (_viewStrengthContentView.frame.size.height - 114.0) / 2.0, 114.0, 114.0)];
        [_lblStrengthProgressBarCount setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
        [_lblStrengthProgressBarCount setFrame: CGRectMake(0.0, ((_progressBarStrengthView.frame.size.height - 30.0) / 2.0), (_progressBarStrengthView.frame.size.width), 30.0)];
        [_lblStrengthProgressBarCount setFont: fontEnduranceMuscleStrengthCount];
        
        CGFloat strengthTitleX = (_progressBarStrengthView.frame.origin.x + _progressBarStrengthView.frame.size.width + 14.0);
        CGFloat strengthTitleY = (_progressBarStrengthView.frame.origin.y + 10.0);
        CGFloat strengthTitleWidth = (DEVICE_WIDTH - strengthTitleX);
        [_lblStrengthTitleLabel setFrame: CGRectMake(strengthTitleX, strengthTitleY, strengthTitleWidth, 25.0)];
        [_lblStrengthTitleLabel setFont: fontEnduranceMuscleStrengthTitle];
        
        CGFloat strengthSubtitleHeight = (140.0 - (_lblStrengthTitleLabel.frame.size.height + muscleTitleY)) / 3.0;
        [_lblStrengthSubtitleLabel setFrame: CGRectMake(strengthTitleX, (strengthTitleY + 30.0), (strengthTitleWidth - 40.0), (strengthSubtitleHeight * 2))];
        [_lblStrengthSubtitleLabel setFont: fontEnduranceMuscleStrengthSubtitle];
        [_lblStrengthSubtitleLabel setText: @"Become stronger and more powerful."];
        
        [_lblStrengthDoSetsLabel setFrame: CGRectMake(strengthTitleX, (_lblStrengthSubtitleLabel.frame.origin.y + (strengthSubtitleHeight * 2) - 8.0), (strengthTitleWidth - 60.0), strengthSubtitleHeight)];
        [_lblStrengthDoSetsLabel setAttributedText: [self createAttributedStrengthSubtitleString]];
        
    } else if (IS_IPHONE8PLUS) {
        
        //Scroll and content view
        [_viewWorkoutAdviceScrollView setFrame: CGRectMake(0.0, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        [_viewWorkoutAdviceScrollView setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + 100.0)];
        [_viewWorkoutAdviceScrollView setDelegate: self];
        [_viewWorkoutAdviceContentView setFrame: CGRectMake(0.0, 0.0, (_viewWorkoutAdviceScrollView.frame.size.width), (_viewWorkoutAdviceScrollView.frame.size.height + 100.0))];
        
        //Contact us label
        [_lblAdviceTitleLabel setFrame: CGRectMake(0.0, 20.0, DEVICE_WIDTH, 90.0)];
        UIFont *fontSettings = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 71.0];
        [_lblAdviceTitleLabel setFont: fontSettings];
        
        //Back button frame
        [_btnBackButton setFrame: CGRectMake(17.0, (_lblAdviceTitleLabel.frame.origin.y + (_lblAdviceTitleLabel.frame.size.height/2 - 17.0)), 34.0, 34.0)];
        
        //Advice sub title label frame
        CGFloat adviceSubtitleY = (_lblAdviceTitleLabel.frame.origin.y + _lblAdviceSubTitleLabel.frame.size.height + 54.0);
        [_lblAdviceSubTitleLabel setFrame: CGRectMake(20.0, adviceSubtitleY, (DEVICE_WIDTH - 60.0), 50.0)];
        UIFont *fontAdviceSubtitle = [UIFont fontWithName: fFUTURA_MEDIUM size: 16.0];
        [_lblAdviceSubTitleLabel setFont: fontAdviceSubtitle];
        
        //Recommended rest view frame
        CGFloat recommendedViewY = (_lblAdviceSubTitleLabel.frame.origin.y + _lblAdviceSubTitleLabel.frame.size.height + 24.0);
        [_viewRecommendedRestTimeContentView setFrame: CGRectMake(0.0, recommendedViewY, DEVICE_WIDTH, 30.0)];
        [_progressBarRecommendedRestView setFrame: CGRectMake(80.0, 3.0, 23.5, 23.5)];
        [_lblRecommendedRestTimeLabel setFrame: CGRectMake(114.0, 0.0, (DEVICE_WIDTH - 110.0), 30.0)];
        UIFont *fontRecommendedRest = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [_lblRecommendedRestTimeLabel setFont: fontRecommendedRest];
        
        //Endurance view frame
        [_viewEnduranceContentView setBackgroundColor: cENDURANCE_VIEW];
        CGFloat enduranceViewY = (_viewRecommendedRestTimeContentView.frame.origin.y + _viewRecommendedRestTimeContentView.frame.size.height + 12.0);
        [_viewEnduranceContentView setFrame: CGRectMake(14.0, enduranceViewY, (DEVICE_WIDTH - 28.0), 146.66)];
        [[_viewEnduranceContentView layer] setCornerRadius: 32.0];
        
        [_progressBarEnduranceView setFrame: CGRectMake(14.0, (_viewEnduranceContentView.frame.size.height - 114.0) / 2.0, 114.0, 114.0)];
        [_lblEnduranceProgressCountLabel setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
        [_lblEnduranceProgressCountLabel setFrame: CGRectMake(0.0, ((_progressBarEnduranceView.frame.size.height - 30.0) / 2.0), (_progressBarEnduranceView.frame.size.width), 30.0)];
        fontEnduranceMuscleStrengthCount = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 33.1];
        [_lblEnduranceProgressCountLabel setFont: fontEnduranceMuscleStrengthCount];
        
        CGFloat enduranceTitleX = (_progressBarEnduranceView.frame.origin.x + _progressBarEnduranceView.frame.size.width + 14.0);
        CGFloat enduranceTitleY = (_progressBarEnduranceView.frame.origin.y + 10.0);
        CGFloat enduranceTitleWidth = (DEVICE_WIDTH - enduranceTitleX);
        [_lblEnduranceTitleLabel setFrame: CGRectMake(enduranceTitleX, enduranceTitleY, enduranceTitleWidth, 25.0)];
        fontEnduranceMuscleStrengthTitle = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblEnduranceTitleLabel setFont: fontEnduranceMuscleStrengthTitle];
        
        CGFloat enduranceSubtitleHeight = (140.0 - (_lblEnduranceTitleLabel.frame.size.height + enduranceTitleY)) / 3.0;
        [_lblEnduranceSubtitleLabel setFrame: CGRectMake(enduranceTitleX, (enduranceTitleY + 30.0), (enduranceTitleWidth - 80.0), (enduranceSubtitleHeight * 2))];
        fontEnduranceMuscleStrengthSubtitle = [UIFont fontWithName: fFUTURA_MEDIUM size: 16.0];
        fontEnduranceMuscleStrengthSubtitleBold = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 12.0];
        fontSubTitleLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        fontSubSubTitleLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 14.0];
        [_lblEnduranceSubtitleLabel setFont: fontEnduranceMuscleStrengthSubtitle];
        [_lblEnduranceSubtitleLabel setText: @"Resist longer and burn more calories."];
        
        [_lblEnduranceDoSetsLabel setFrame: CGRectMake(enduranceTitleX, (_lblEnduranceSubtitleLabel.frame.origin.y + (enduranceSubtitleHeight * 2) - 8.0), (enduranceTitleWidth - 60.0), enduranceSubtitleHeight)];
        [_lblEnduranceDoSetsLabel setAttributedText: [self createAttributedEnduranceSubtitleString]];
        
        
        //Muscle view
        [_viewMuscleContentView setBackgroundColor: cMUSCLE_VIEW];
        CGFloat muscleViewY = (_viewEnduranceContentView.frame.origin.y + _viewEnduranceContentView.frame.size.height + 12.0);
        [_viewMuscleContentView setFrame: CGRectMake(14.0, muscleViewY, (DEVICE_WIDTH - 28.0), 146.66)];
        [_viewMuscleContentView setClipsToBounds: YES];
        [[_viewMuscleContentView layer] setCornerRadius: 32.0];
        
        [_progressBarMuscleView setFrame: CGRectMake(14.0, (_viewMuscleContentView.frame.size.height - 114.0) / 2.0, 114.0, 114.0)];
        [_lblMuscleProgressBarCount setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
        [_lblMuscleProgressBarCount setFrame: CGRectMake(0.0, ((_progressBarMuscleView.frame.size.height - 30.0) / 2.0), (_progressBarMuscleView.frame.size.width), 30.0)];
        [_lblMuscleProgressBarCount setFont: fontEnduranceMuscleStrengthCount];
        
        CGFloat muscleTitleX = (_progressBarMuscleView.frame.origin.x + _progressBarMuscleView.frame.size.width + 14.0);
        CGFloat muscleTitleY = (_progressBarMuscleView.frame.origin.y + 10.0);
        CGFloat muscleTitleWidth = (DEVICE_WIDTH - muscleTitleX);
        [_lblMuscleTitleLabel setFrame: CGRectMake(muscleTitleX, muscleTitleY, muscleTitleWidth, 25.0)];
        [_lblMuscleTitleLabel setFont: fontEnduranceMuscleStrengthTitle];
        
        CGFloat muscleSubtitleHeight = (140.0 - (_lblEnduranceTitleLabel.frame.size.height + enduranceTitleY)) / 3.0;
        [_lblMuscleSubtitleLabel setFrame: CGRectMake(muscleTitleX, (muscleTitleY + 30.0), (muscleTitleWidth - 80.0), (muscleSubtitleHeight * 2))];
        [_lblMuscleSubtitleLabel setFont: fontEnduranceMuscleStrengthSubtitle];
        [_lblMuscleSubtitleLabel setText: @"Build stronger and more visible muscle."];
        
        [_lblMuscleDoSetsLabel setFrame: CGRectMake(muscleTitleX, (_lblMuscleSubtitleLabel.frame.origin.y + (muscleSubtitleHeight * 2) - 8.0), (muscleTitleWidth - 60.0), muscleSubtitleHeight)];
        [_lblMuscleDoSetsLabel setAttributedText: [self createAttributedMuscleSubtitleString]];
        
        
        //Strength view
        [_viewStrengthContentView setBackgroundColor: cSTRENGTH_VIEW];
        CGFloat strengthViewY = (_viewMuscleContentView.frame.origin.y + _viewMuscleContentView.frame.size.height + 12.0);
        [_viewStrengthContentView setFrame: CGRectMake(14.0, strengthViewY, (DEVICE_WIDTH - 28.0), 146.66)];
        [_viewStrengthContentView setClipsToBounds: YES];
        [[_viewStrengthContentView layer] setCornerRadius: 32.0];
        
        [_progressBarStrengthView setFrame: CGRectMake(14.0, (_viewStrengthContentView.frame.size.height - 114.0) / 2.0, 114.0, 114.0)];
        [_lblStrengthProgressBarCount setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
        [_lblStrengthProgressBarCount setFrame: CGRectMake(0.0, ((_progressBarStrengthView.frame.size.height - 30.0) / 2.0), (_progressBarStrengthView.frame.size.width), 30.0)];
        [_lblStrengthProgressBarCount setFont: fontEnduranceMuscleStrengthCount];
        
        CGFloat strengthTitleX = (_progressBarStrengthView.frame.origin.x + _progressBarStrengthView.frame.size.width + 14.0);
        CGFloat strengthTitleY = (_progressBarStrengthView.frame.origin.y + 10.0);
        CGFloat strengthTitleWidth = (DEVICE_WIDTH - strengthTitleX);
        [_lblStrengthTitleLabel setFrame: CGRectMake(strengthTitleX, strengthTitleY, strengthTitleWidth, 25.0)];
        [_lblStrengthTitleLabel setFont: fontEnduranceMuscleStrengthTitle];
        
        CGFloat strengthSubtitleHeight = (140.0 - (_lblStrengthTitleLabel.frame.size.height + muscleTitleY)) / 3.0;
        [_lblStrengthSubtitleLabel setFrame: CGRectMake(strengthTitleX, (strengthTitleY + 30.0), (strengthTitleWidth - 40.0), (strengthSubtitleHeight * 2))];
        [_lblStrengthSubtitleLabel setFont: fontEnduranceMuscleStrengthSubtitle];
        [_lblStrengthSubtitleLabel setText: @"Become stronger and more powerful."];
        
        [_lblStrengthDoSetsLabel setFrame: CGRectMake(strengthTitleX, (_lblStrengthSubtitleLabel.frame.origin.y + (strengthSubtitleHeight * 2) - 8.0), (strengthTitleWidth - 60.0), strengthSubtitleHeight)];
        [_lblStrengthDoSetsLabel setAttributedText: [self createAttributedStrengthSubtitleString]];
        
    } else if (IS_IPHONE8) {
        
        //Scroll and content view
        [_viewWorkoutAdviceScrollView setFrame: CGRectMake(0.0, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        [_viewWorkoutAdviceScrollView setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + 1.0)];
        [_viewWorkoutAdviceScrollView setDelegate: self];
        [_viewWorkoutAdviceContentView setFrame: CGRectMake(0.0, 0.0, (_viewWorkoutAdviceScrollView.contentSize.width), (_viewWorkoutAdviceScrollView.contentSize.height + 1.0))];
        
        //Contact us label
        [_lblAdviceTitleLabel setFrame: CGRectMake(0.0, 0.0, DEVICE_WIDTH, 90.0)];
        UIFont *fontSettings = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 64.0];
        [_lblAdviceTitleLabel setFont: fontSettings];
        
        //Back button frame
        [_btnBackButton setFrame: CGRectMake(17.0, (_lblAdviceTitleLabel.frame.origin.y + (_lblAdviceTitleLabel.frame.size.height/2 - 15.0)), 30.0, 30.0)];
        
        //Advice sub title label frame
        CGFloat adviceSubtitleY = (_lblAdviceTitleLabel.frame.origin.y + _lblAdviceSubTitleLabel.frame.size.height + 38.0);
        [_lblAdviceSubTitleLabel setFrame: CGRectMake(20.0, adviceSubtitleY, (DEVICE_WIDTH - 40.0), 50.0)];
        UIFont *fontAdviceSubtitle = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [_lblAdviceSubTitleLabel setFont: fontAdviceSubtitle];
        
        //Recommended rest view frame
        CGFloat recommendedViewY = (_lblAdviceSubTitleLabel.frame.origin.y + _lblAdviceSubTitleLabel.frame.size.height + 12.0);
        [_viewRecommendedRestTimeContentView setFrame: CGRectMake(0.0, recommendedViewY, DEVICE_WIDTH, 30.0)];
        [_progressBarRecommendedRestView setFrame: CGRectMake(64.0, 4.0, 22.0, 22.0)];
        [_lblRecommendedRestTimeLabel setFrame: CGRectMake(92.0, 0.0, (DEVICE_WIDTH - 110.0), 30.0)];
        UIFont *fontRecommendedRest = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        [_lblRecommendedRestTimeLabel setFont: fontRecommendedRest];
        
        //Endurance view frame
        [_viewEnduranceContentView setBackgroundColor: cENDURANCE_VIEW];
        CGFloat enduranceViewY = (_viewRecommendedRestTimeContentView.frame.origin.y + _viewRecommendedRestTimeContentView.frame.size.height + 14.0);
        [_viewEnduranceContentView setFrame: CGRectMake(14.0, enduranceViewY, (DEVICE_WIDTH - 28.0), 139.0)];
        [[_viewEnduranceContentView layer] setCornerRadius: 32.0];
        
        [_progressBarEnduranceView setFrame: CGRectMake(14.0, (_viewEnduranceContentView.frame.size.height - 108.0) / 2.0, 108.0, 108.0)];
        [_lblEnduranceProgressCountLabel setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
        [_lblEnduranceProgressCountLabel setFrame: CGRectMake(0.0, ((_progressBarEnduranceView.frame.size.height - 30.0) / 2.0), (_progressBarEnduranceView.frame.size.width), 30.0)];
        fontEnduranceMuscleStrengthCount = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblEnduranceProgressCountLabel setFont: fontEnduranceMuscleStrengthCount];
        
        CGFloat enduranceTitleX = (_progressBarEnduranceView.frame.origin.x + _progressBarEnduranceView.frame.size.width + 18.0);
        CGFloat enduranceTitleY = (_progressBarEnduranceView.frame.origin.y + 4.0);
        CGFloat enduranceTitleWidth = (DEVICE_WIDTH - enduranceTitleX);
        [_lblEnduranceTitleLabel setFrame: CGRectMake(enduranceTitleX, enduranceTitleY, enduranceTitleWidth, 25.0)];
        fontEnduranceMuscleStrengthTitle = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 32.0];
        [_lblEnduranceTitleLabel setFont: fontEnduranceMuscleStrengthTitle];
        
        CGFloat enduranceSubtitleHeight = (140.0 - (_lblEnduranceTitleLabel.frame.size.height + enduranceTitleY)) / 3.0;
        [_lblEnduranceSubtitleLabel setFrame: CGRectMake(enduranceTitleX, (enduranceTitleY + 24.0), (enduranceTitleWidth - 60.0), (enduranceSubtitleHeight * 2))];
        fontEnduranceMuscleStrengthSubtitle = [UIFont fontWithName: fFUTURA_MEDIUM size: 18.0];
        fontEnduranceMuscleStrengthSubtitleBold = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 14.0];
        fontSubTitleLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 16.0];
        fontSubSubTitleLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 16.0];
        [_lblEnduranceSubtitleLabel setFont: fontEnduranceMuscleStrengthSubtitle];
        [_lblEnduranceSubtitleLabel setText: @"Resist longer and burn more calories."];
        
        [_lblEnduranceDoSetsLabel setFrame: CGRectMake(enduranceTitleX, (_lblEnduranceSubtitleLabel.frame.origin.y + (enduranceSubtitleHeight * 2) - 12.0), (enduranceTitleWidth - 20.0), enduranceSubtitleHeight)];
        [_lblEnduranceDoSetsLabel setAttributedText: [self createAttributedEnduranceSubtitleString]];
        
        
        //Muscle view
        [_viewMuscleContentView setBackgroundColor: cMUSCLE_VIEW];
        CGFloat muscleViewY = (_viewEnduranceContentView.frame.origin.y + _viewEnduranceContentView.frame.size.height + 12.0);
        [_viewMuscleContentView setFrame: CGRectMake(14.0, muscleViewY, (DEVICE_WIDTH - 28.0), 139.0)];
        [_viewMuscleContentView setClipsToBounds: YES];
        [[_viewMuscleContentView layer] setCornerRadius: 32.0];
        
        [_progressBarMuscleView setFrame: CGRectMake(14.0, (_viewMuscleContentView.frame.size.height - 108.0) / 2.0, 108.0, 108.0)];
        [_lblMuscleProgressBarCount setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
        [_lblMuscleProgressBarCount setFrame: CGRectMake(0.0, ((_progressBarMuscleView.frame.size.height - 30.0) / 2.0), (_progressBarMuscleView.frame.size.width), 30.0)];
        [_lblMuscleProgressBarCount setFont: fontEnduranceMuscleStrengthCount];
        
        CGFloat muscleTitleX = (_progressBarMuscleView.frame.origin.x + _progressBarMuscleView.frame.size.width + 18.0);
        CGFloat muscleTitleY = (_progressBarMuscleView.frame.origin.y + 4.0);
        CGFloat muscleTitleWidth = (DEVICE_WIDTH - muscleTitleX);
        [_lblMuscleTitleLabel setFrame: CGRectMake(muscleTitleX, muscleTitleY, muscleTitleWidth, 32.0)];
        [_lblMuscleTitleLabel setFont: fontEnduranceMuscleStrengthTitle];
        
        CGFloat muscleSubtitleHeight = (140.0 - (_lblEnduranceTitleLabel.frame.size.height + enduranceTitleY)) / 3.0;
        [_lblMuscleSubtitleLabel setFrame: CGRectMake(muscleTitleX, (muscleTitleY + 28.0), (muscleTitleWidth - 60.0), (muscleSubtitleHeight * 2))];
        [_lblMuscleSubtitleLabel setFont: fontEnduranceMuscleStrengthSubtitle];
        [_lblMuscleSubtitleLabel setText: @"Build stronger and more visible muscle."];
        
        [_lblMuscleDoSetsLabel setFrame: CGRectMake(muscleTitleX, (_lblMuscleSubtitleLabel.frame.origin.y + (muscleSubtitleHeight * 2) - 10.0), (muscleTitleWidth - 20.0), muscleSubtitleHeight)];
        [_lblMuscleDoSetsLabel setAttributedText: [self createAttributedMuscleSubtitleString]];
        
        
        //Strength view
        [_viewStrengthContentView setBackgroundColor: cSTRENGTH_VIEW];
        CGFloat strengthViewY = (_viewMuscleContentView.frame.origin.y + _viewMuscleContentView.frame.size.height + 12.0);
        [_viewStrengthContentView setFrame: CGRectMake(14.0, strengthViewY, (DEVICE_WIDTH - 28.0), 139.0)];
        [_viewStrengthContentView setClipsToBounds: YES];
        [[_viewStrengthContentView layer] setCornerRadius: 32.0];
        
        [_progressBarStrengthView setFrame: CGRectMake(14.0, (_viewStrengthContentView.frame.size.height - 108.0) / 2.0, 108.0, 108.0)];
        [_lblStrengthProgressBarCount setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
        [_lblStrengthProgressBarCount setFrame: CGRectMake(0.0, ((_progressBarStrengthView.frame.size.height - 30.0) / 2.0), (_progressBarStrengthView.frame.size.width), 30.0)];
        [_lblStrengthProgressBarCount setFont: fontEnduranceMuscleStrengthCount];
        
        CGFloat strengthTitleX = (_progressBarStrengthView.frame.origin.x + _progressBarStrengthView.frame.size.width + 18.0);
        CGFloat strengthTitleY = (_progressBarStrengthView.frame.origin.y + 4.0);
        CGFloat strengthTitleWidth = (DEVICE_WIDTH - strengthTitleX);
        [_lblStrengthTitleLabel setFrame: CGRectMake(strengthTitleX, strengthTitleY, strengthTitleWidth, 32.0)];
        [_lblStrengthTitleLabel setFont: fontEnduranceMuscleStrengthTitle];
        
        CGFloat strengthSubtitleHeight = (140.0 - (_lblStrengthTitleLabel.frame.size.height + muscleTitleY)) / 3.0;
        [_lblStrengthSubtitleLabel setFrame: CGRectMake(strengthTitleX, (strengthTitleY + 28.0), (strengthTitleWidth - 60.0), (strengthSubtitleHeight * 2))];
        [_lblStrengthSubtitleLabel setFont: fontEnduranceMuscleStrengthSubtitle];
        [_lblStrengthSubtitleLabel setText: @"Become stronger and more powerful."];
        
        [_lblStrengthDoSetsLabel setFrame: CGRectMake(strengthTitleX, (_lblStrengthSubtitleLabel.frame.origin.y + (strengthSubtitleHeight * 2) - 8.0), (strengthTitleWidth - 00.0), strengthSubtitleHeight)];
        [_lblStrengthDoSetsLabel setAttributedText: [self createAttributedStrengthSubtitleString]];
        
    } else {
        
        //Scroll and content view
        [_viewWorkoutAdviceScrollView setFrame: CGRectMake(0.0, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        [_viewWorkoutAdviceScrollView setContentSize: CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + 1.0)];
        [_viewWorkoutAdviceScrollView setDelegate: self];
        [_viewWorkoutAdviceContentView setFrame: CGRectMake(0.0, 0.0, (_viewWorkoutAdviceScrollView.contentSize.width), (_viewWorkoutAdviceScrollView.contentSize.height + 1.0))];
        
        //Contact us label
        [_lblAdviceTitleLabel setFrame: CGRectMake(0.0, -16.0, DEVICE_WIDTH, 90.0)];
        UIFont *fontSettings = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 48.0];
        [_lblAdviceTitleLabel setFont: fontSettings];
        
        //Back button frame
        [_btnBackButton setFrame: CGRectMake(17.0, (_lblAdviceTitleLabel.frame.origin.y + (_lblAdviceTitleLabel.frame.size.height/2 - 15.0)), 30.0, 30.0)];
        
        //Advice sub title label frame
        CGFloat adviceSubtitleY = (_lblAdviceTitleLabel.frame.origin.y + _lblAdviceSubTitleLabel.frame.size.height + 34.0);
        [_lblAdviceSubTitleLabel setFrame: CGRectMake(20.0, adviceSubtitleY, (DEVICE_WIDTH - 40.0), 50.0)];
        UIFont *fontAdviceSubtitle = [UIFont fontWithName: fFUTURA_MEDIUM size: 12.0];
        [_lblAdviceSubTitleLabel setFont: fontAdviceSubtitle];
        
        //Recommended rest view frame
        CGFloat recommendedViewY = (_lblAdviceSubTitleLabel.frame.origin.y + _lblAdviceSubTitleLabel.frame.size.height + 12.0);
        [_viewRecommendedRestTimeContentView setFrame: CGRectMake(0.0, recommendedViewY, DEVICE_WIDTH, 30.0)];
        [_progressBarRecommendedRestView setFrame: CGRectMake(52.0, 5.0, 20.0, 20.0)];
        [_lblRecommendedRestTimeLabel setFrame: CGRectMake(80.0, 0.0, (DEVICE_WIDTH - 110.0), 30.0)];
        UIFont *fontRecommendedRest = [UIFont fontWithName: fFUTURA_MEDIUM size: 12.0];
        [_lblRecommendedRestTimeLabel setFont: fontRecommendedRest];
        
        //Endurance view frame
        [_viewEnduranceContentView setBackgroundColor: cENDURANCE_VIEW];
        CGFloat enduranceViewY = (_viewRecommendedRestTimeContentView.frame.origin.y + _viewRecommendedRestTimeContentView.frame.size.height + 6.0);
        [_viewEnduranceContentView setFrame: CGRectMake(14.0, enduranceViewY, (DEVICE_WIDTH - 28.0), 115.0)];
        [[_viewEnduranceContentView layer] setCornerRadius: 32.0];
        
        [_progressBarEnduranceView setFrame: CGRectMake(14.0, (_viewEnduranceContentView.frame.size.height - 92.0) / 2.0, 92.0, 92.0)];
        [_lblEnduranceProgressCountLabel setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
        [_lblEnduranceProgressCountLabel setFrame: CGRectMake(0.0, ((_progressBarEnduranceView.frame.size.height - 30.0) / 2.0), (_progressBarEnduranceView.frame.size.width), 30.0)];
        fontEnduranceMuscleStrengthCount = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 30.0];
        [_lblEnduranceProgressCountLabel setFont: fontEnduranceMuscleStrengthCount];
        
        CGFloat enduranceTitleX = (_progressBarEnduranceView.frame.origin.x + _progressBarEnduranceView.frame.size.width + 14.0);
        CGFloat enduranceTitleY = (_progressBarEnduranceView.frame.origin.y + 4.0);
        CGFloat enduranceTitleWidth = (DEVICE_WIDTH - enduranceTitleX);
        [_lblEnduranceTitleLabel setFrame: CGRectMake(enduranceTitleX, enduranceTitleY, enduranceTitleWidth, 25.0)];
        fontEnduranceMuscleStrengthTitle = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 28.0];
        [_lblEnduranceTitleLabel setFont: fontEnduranceMuscleStrengthTitle];
        
        CGFloat enduranceSubtitleHeight = (140.0 - (_lblEnduranceTitleLabel.frame.size.height + enduranceTitleY)) / 3.0;
        [_lblEnduranceSubtitleLabel setFrame: CGRectMake(enduranceTitleX, (enduranceTitleY + 14.0), (enduranceTitleWidth - 60.0), (enduranceSubtitleHeight * 2))];
        fontEnduranceMuscleStrengthSubtitle = [UIFont fontWithName: fFUTURA_MEDIUM size: 14.0];
        fontEnduranceMuscleStrengthSubtitleBold = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 10.0];
        fontSubTitleLabel = [UIFont fontWithName: fFUTURA_MEDIUM size: 12.0];
        fontSubSubTitleLabel = [UIFont fontWithName: fFUTURA_CONDENSED_EXTRA_BOLD size: 12.0];
        [_lblEnduranceSubtitleLabel setFont: fontEnduranceMuscleStrengthSubtitle];
        [_lblEnduranceSubtitleLabel setText: @"Resist longer and burn more calories."];
        
        [_lblEnduranceDoSetsLabel setFrame: CGRectMake(enduranceTitleX, (_lblEnduranceSubtitleLabel.frame.origin.y + (enduranceSubtitleHeight * 2) - 20.0), (enduranceTitleWidth - 20.0), enduranceSubtitleHeight)];
        [_lblEnduranceDoSetsLabel setAttributedText: [self createAttributedEnduranceSubtitleString]];
        
        
        //Muscle view
        [_viewMuscleContentView setBackgroundColor: cMUSCLE_VIEW];
        CGFloat muscleViewY = (_viewEnduranceContentView.frame.origin.y + _viewEnduranceContentView.frame.size.height + 12.0);
        [_viewMuscleContentView setFrame: CGRectMake(14.0, muscleViewY, (DEVICE_WIDTH - 28.0), 115.0)];
        [_viewMuscleContentView setClipsToBounds: YES];
        [[_viewMuscleContentView layer] setCornerRadius: 32.0];
        
        [_progressBarMuscleView setFrame: CGRectMake(14.0, (_viewMuscleContentView.frame.size.height - 92.0) / 2.0, 92.0, 92.0)];
        [_lblMuscleProgressBarCount setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
        [_lblMuscleProgressBarCount setFrame: CGRectMake(0.0, ((_progressBarMuscleView.frame.size.height - 30.0) / 2.0), (_progressBarMuscleView.frame.size.width), 30.0)];
        [_lblMuscleProgressBarCount setFont: fontEnduranceMuscleStrengthCount];
        
        CGFloat muscleTitleX = (_progressBarMuscleView.frame.origin.x + _progressBarMuscleView.frame.size.width + 14.0);
        CGFloat muscleTitleY = (_progressBarMuscleView.frame.origin.y + 4.0);
        CGFloat muscleTitleWidth = (DEVICE_WIDTH - muscleTitleX);
        [_lblMuscleTitleLabel setFrame: CGRectMake(muscleTitleX, muscleTitleY, muscleTitleWidth, 25.0)];
        [_lblMuscleTitleLabel setFont: fontEnduranceMuscleStrengthTitle];
        
        CGFloat muscleSubtitleHeight = (140.0 - (_lblEnduranceTitleLabel.frame.size.height + enduranceTitleY)) / 3.0;
        [_lblMuscleSubtitleLabel setFrame: CGRectMake(muscleTitleX, (muscleTitleY + 14.0), (muscleTitleWidth - 60.0), (muscleSubtitleHeight * 2))];
        [_lblMuscleSubtitleLabel setFont: fontEnduranceMuscleStrengthSubtitle];
        [_lblMuscleSubtitleLabel setText: @"Build stronger and more visible muscle."];
        
        [_lblMuscleDoSetsLabel setFrame: CGRectMake(muscleTitleX, (_lblMuscleSubtitleLabel.frame.origin.y + (muscleSubtitleHeight * 2) - 20.0), (muscleTitleWidth - 20.0), muscleSubtitleHeight)];
        [_lblMuscleDoSetsLabel setAttributedText: [self createAttributedMuscleSubtitleString]];
        
        
        //Strength view
        [_viewStrengthContentView setBackgroundColor: cSTRENGTH_VIEW];
        CGFloat strengthViewY = (_viewMuscleContentView.frame.origin.y + _viewMuscleContentView.frame.size.height + 12.0);
        [_viewStrengthContentView setFrame: CGRectMake(14.0, strengthViewY, (DEVICE_WIDTH - 28.0), 115.0)];
        [_viewStrengthContentView setClipsToBounds: YES];
        [[_viewStrengthContentView layer] setCornerRadius: 32.0];
        
        [_progressBarStrengthView setFrame: CGRectMake(14.0, (_viewStrengthContentView.frame.size.height - 92.0) / 2.0, 92.0, 92.0)];
        [_lblStrengthProgressBarCount setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
        [_lblStrengthProgressBarCount setFrame: CGRectMake(0.0, ((_progressBarStrengthView.frame.size.height - 30.0) / 2.0), (_progressBarStrengthView.frame.size.width), 30.0)];
        [_lblStrengthProgressBarCount setFont: fontEnduranceMuscleStrengthCount];
        
        CGFloat strengthTitleX = (_progressBarStrengthView.frame.origin.x + _progressBarStrengthView.frame.size.width + 14.0);
        CGFloat strengthTitleY = (_progressBarStrengthView.frame.origin.y + 4.0);
        CGFloat strengthTitleWidth = (DEVICE_WIDTH - strengthTitleX);
        [_lblStrengthTitleLabel setFrame: CGRectMake(strengthTitleX, strengthTitleY, strengthTitleWidth, 25.0)];
        [_lblStrengthTitleLabel setFont: fontEnduranceMuscleStrengthTitle];
        
        CGFloat strengthSubtitleHeight = (140.0 - (_lblStrengthTitleLabel.frame.size.height + muscleTitleY)) / 3.0;
        [_lblStrengthSubtitleLabel setFrame: CGRectMake(strengthTitleX, (strengthTitleY + 14.0), (strengthTitleWidth - 60.0), (strengthSubtitleHeight * 2))];
        [_lblStrengthSubtitleLabel setFont: fontEnduranceMuscleStrengthSubtitle];
        [_lblStrengthSubtitleLabel setText: @"Become stronger and more powerful."];
        
        [_lblStrengthDoSetsLabel setFrame: CGRectMake(strengthTitleX, (_lblStrengthSubtitleLabel.frame.origin.y + (strengthSubtitleHeight * 2) - 20.0), (strengthTitleWidth - 00.0), strengthSubtitleHeight)];
        [_lblStrengthDoSetsLabel setAttributedText: [self createAttributedStrengthSubtitleString]];
        
    }
    
    [self startAnimatingProgressViews];
    
    //Add shadow to views
    UIBezierPath *enduranceShadowPath = [UIBezierPath bezierPathWithRect: [_viewEnduranceContentView bounds]];
    [_viewEnduranceContentView setClipsToBounds: YES];
    [[_viewEnduranceContentView layer] setMasksToBounds: NO];
    [[_viewEnduranceContentView layer] setShadowColor: [[UIColor blackColor] CGColor]];
    [[_viewEnduranceContentView layer] setShadowOffset: CGSizeMake(0.0, 10.0)];
    [[_viewEnduranceContentView layer] setShadowRadius: 10.0];
    [[_viewEnduranceContentView layer] setShadowOpacity: 0.1];
    [[_viewEnduranceContentView layer] setShadowPath: [enduranceShadowPath CGPath]];
    
    UIBezierPath *muscleShadowPath = [UIBezierPath bezierPathWithRect: [_viewMuscleContentView bounds]];
    [_viewMuscleContentView setClipsToBounds: YES];
    [[_viewMuscleContentView layer] setMasksToBounds: NO];
    [[_viewMuscleContentView layer] setShadowColor: [[UIColor blackColor] CGColor]];
    [[_viewMuscleContentView layer] setShadowOffset: CGSizeMake(10.0, 10.0)];
    [[_viewMuscleContentView layer] setShadowRadius: 10.0];
    [[_viewMuscleContentView layer] setShadowOpacity: 0.1];
    [[_viewMuscleContentView layer] setShadowPath: [muscleShadowPath CGPath]];
    
}

- (void) initializeData {
    
    currentScrollViewYOffset = [_viewWorkoutAdviceScrollView contentOffset].y;
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(handleSwipeOnMainView:)];
    [[self view] addGestureRecognizer: swipeGesture];
    
}

- (void) setupProgressBarRecommendedRestTime {
    
    [_progressBarRecommendedRestView setBackgroundColor: UIColor.clearColor];
    [_progressBarRecommendedRestView setProgressColor: UIColor.blackColor];
    [_progressBarRecommendedRestView setProgressStrokeColor: UIColor.blackColor];
    [_progressBarRecommendedRestView setEmptyLineColor: cLIGHT_GRAY];
    [_progressBarRecommendedRestView setEmptyLineStrokeColor: cLIGHT_GRAY];
    [_progressBarRecommendedRestView setProgressLineWidth: 1.5];
    [_progressBarRecommendedRestView setEmptyLineWidth: 1.5];
    [_progressBarRecommendedRestView setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
    
}

- (void) setupProgressBarEndurance {
    
    [_progressBarEnduranceView setBackgroundColor: UIColor.clearColor];
    [_progressBarEnduranceView setProgressColor: UIColor.whiteColor];
    [_progressBarEnduranceView setProgressStrokeColor: UIColor.whiteColor];
    [_progressBarEnduranceView setEmptyLineColor: cENDURANCE_EMPTY_PROGRESS];
    [_progressBarEnduranceView setEmptyLineStrokeColor: cENDURANCE_EMPTY_PROGRESS];
    [_progressBarEnduranceView setProgressLineWidth: 6.0];
    [_progressBarEnduranceView setEmptyLineWidth: 6.0];
    [_progressBarEnduranceView setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
    
}

- (void) setupProgressBarMuscle {
    
    [_progressBarMuscleView setBackgroundColor: UIColor.clearColor];
    [_progressBarMuscleView setProgressColor: UIColor.whiteColor];
    [_progressBarMuscleView setProgressStrokeColor: UIColor.whiteColor];
    [_progressBarMuscleView setEmptyLineColor: cMUSCLE_EMPTY_PROGRESS];
    [_progressBarMuscleView setEmptyLineStrokeColor: cMUSCLE_EMPTY_PROGRESS];
    [_progressBarMuscleView setProgressLineWidth: 6.0];
    [_progressBarMuscleView setEmptyLineWidth: 6.0];
    [_progressBarMuscleView setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
    
}

- (void) setupProgressBarStrength {
    
    [_progressBarStrengthView setBackgroundColor: UIColor.clearColor];
    [_progressBarStrengthView setProgressColor: UIColor.whiteColor];
    [_progressBarStrengthView setProgressStrokeColor: UIColor.whiteColor];
    [_progressBarStrengthView setEmptyLineColor: cSTRENGTH_EMPTY_PROGRESS];
    [_progressBarStrengthView setEmptyLineStrokeColor: cSTRENGTH_EMPTY_PROGRESS];
    [_progressBarStrengthView setProgressLineWidth: 6.0];
    [_progressBarStrengthView setEmptyLineWidth: 6.0];
    [_progressBarStrengthView setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
    
}

- (NSMutableAttributedString *) createAttributedEnduranceSubtitleString {
    
    NSMutableAttributedString *strEnduranceSubtitle = [[NSMutableAttributedString alloc] init];
    
    NSAttributedString *strOne = [[NSAttributedString alloc] initWithString: @"Do " attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontSubTitleLabel}];
    NSAttributedString *strTwo = [[NSAttributedString alloc] initWithString: @"1-3" attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontSubSubTitleLabel}];
    NSAttributedString *strThree = [[NSAttributedString alloc] initWithString: @" sets of " attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontSubTitleLabel}];
    NSAttributedString *strFour = [[NSAttributedString alloc] initWithString: @"10-20" attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontSubSubTitleLabel}];
    NSAttributedString *strFive = [[NSAttributedString alloc] initWithString: @" reps." attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontSubTitleLabel}];
    
    [strEnduranceSubtitle appendAttributedString: strOne];
    [strEnduranceSubtitle appendAttributedString: strTwo];
    [strEnduranceSubtitle appendAttributedString: strThree];
    [strEnduranceSubtitle appendAttributedString: strFour];
    [strEnduranceSubtitle appendAttributedString: strFive];
    
    return strEnduranceSubtitle;
    
}

- (NSMutableAttributedString *) createAttributedMuscleSubtitleString {
    
    NSMutableAttributedString *strEnduranceSubtitle = [[NSMutableAttributedString alloc] init];
    
    NSAttributedString *strOne = [[NSAttributedString alloc] initWithString: @"Do " attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontSubTitleLabel}];
    NSAttributedString *strTwo = [[NSAttributedString alloc] initWithString: @"3-6" attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontSubSubTitleLabel}];
    NSAttributedString *strThree = [[NSAttributedString alloc] initWithString: @" sets of " attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontSubTitleLabel}];
    NSAttributedString *strFour = [[NSAttributedString alloc] initWithString: @"6-10" attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontSubSubTitleLabel}];
    NSAttributedString *strFive = [[NSAttributedString alloc] initWithString: @" reps." attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontSubTitleLabel}];
    
    [strEnduranceSubtitle appendAttributedString: strOne];
    [strEnduranceSubtitle appendAttributedString: strTwo];
    [strEnduranceSubtitle appendAttributedString: strThree];
    [strEnduranceSubtitle appendAttributedString: strFour];
    [strEnduranceSubtitle appendAttributedString: strFive];
    
    return strEnduranceSubtitle;
    
}

- (NSMutableAttributedString *) createAttributedStrengthSubtitleString {
    
    NSMutableAttributedString *strEnduranceSubtitle = [[NSMutableAttributedString alloc] init];
    
    NSAttributedString *strOne = [[NSAttributedString alloc] initWithString: @"Do " attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontSubTitleLabel}];
    NSAttributedString *strTwo = [[NSAttributedString alloc] initWithString: @"6-9" attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontSubSubTitleLabel}];
    NSAttributedString *strThree = [[NSAttributedString alloc] initWithString: @" sets of " attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontSubTitleLabel}];
    NSAttributedString *strFour = [[NSAttributedString alloc] initWithString: @"1-6" attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontSubSubTitleLabel}];
    NSAttributedString *strFive = [[NSAttributedString alloc] initWithString: @" reps." attributes:  @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: fontSubTitleLabel}];
    
    [strEnduranceSubtitle appendAttributedString: strOne];
    [strEnduranceSubtitle appendAttributedString: strTwo];
    [strEnduranceSubtitle appendAttributedString: strThree];
    [strEnduranceSubtitle appendAttributedString: strFour];
    [strEnduranceSubtitle appendAttributedString: strFive];
    
    return strEnduranceSubtitle;
    
}

- (void) startAnimatingProgressViews {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [UIView animateWithDuration: 0.0 animations:^{

            [self->_progressBarRecommendedRestView setValue: 75.0];

        }];
        
        [UIView animateWithDuration: 4.0 animations:^{
            [self->_progressBarEnduranceView setValue: 0.0];
        } completion:^(BOOL finished) {
            [self->_progressBarEnduranceView setValue: 0.0];
        }];

//        [UIView animateWithDuration: 1.0 animations:^{
//
//            [self->_progressBarEnduranceView setValue: 100.0];
//
//        }];

        [UIView animateWithDuration: 5.0 animations:^{
            [self->_progressBarMuscleView setValue: 0.0];
        } completion:^(BOOL finished) {
            [self->_progressBarMuscleView setValue: 0.0];
        }];
        
//        [UIView animateWithDuration: 2.0 animations:^{
//
//            [self->_progressBarMuscleView setValue: 75.0];
//
//        }];
        
        [UIView animateWithDuration: 6.0 animations:^{
            [self->_progressBarStrengthView setValue: 0.0];
        } completion:^(BOOL finished) {
            [self->_progressBarStrengthView setValue: 0.0];
        }];

//        [UIView animateWithDuration: 3.0 animations:^{
//
//            [self->_progressBarStrengthView setValue: 75.0];
//
//        }];

    });

}

- (void) resetProgressView {
    
    [_progressBarRecommendedRestView setValue: 0.0];
    [_progressBarEnduranceView setValue: 100.0];
    [_progressBarMuscleView setValue: 100.0];
    [_progressBarStrengthView setValue: 100.0];
    
}

- (void) handleSwipeOnMainView: (UISwipeGestureRecognizer *) swipe {
    
    if ([swipe direction] == UISwipeGestureRecognizerDirectionRight) {
        [[self navigationController] popViewControllerAnimated: YES];
//        NSMutableArray *arrTabbarVC = [[[self tabBarController] viewControllers] mutableCopy];
//        [arrTabbarVC setObject: GETCONTROLLER(@"SettingsViewController") atIndexedSubscript: 2];
//        [[self tabBarController] setViewControllers: arrTabbarVC animated: NO];
    }
    
}


@end
