//
//  OnBoardingViewController.m
//  GymTimer
//
//  Created by Vivek on 11/01/19.
//  Copyright © 2019 Vivek. All rights reserved.
//

#import "OnBoardingViewController.h"
#import "Constants.h"
#import "Utils.h"
#import "OnBoardingCollectionViewCell.h"
#import "AppDelegate.h"
#import "CommonImports.h"

@interface OnBoardingViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    
    UIImage *contentImage;
    NSString *strMainLabel, *strSubLabel, *strNavigationButtonTitle;
    UIFont *fontGymTimer, *fontSkipButton, *fontNavigationButton, *fontSubLabel, *fontMainLabel;
    
}
@end

@implementation OnBoardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden: YES];
    
    UINib *onBoardingNib = [UINib nibWithNibName: cvONBOARDING_CELL bundle: nil];
    [[self cvOnBoardingCollectionView] registerNib: onBoardingNib forCellWithReuseIdentifier: cvONBOARDING_CELL];
    
    [_imgBackgroundImage setFrame: CGRectMake(0.0, 0.0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    
    [_imgContentImage setHidden: YES];
    [_lblContentMainLabel setHidden: YES];
    [_lblContentSubLabel setHidden: YES];
    
    [_viewTest setFrame: CGRectMake(16.0, 492.0, (DEVICE_WIDTH - 32.0), 1.0)];
    [_viewTest setHidden: YES];
    
    
    if (IS_IPHONEXR) {
        
        //Set GymTimer Label Layout
        fontGymTimer = [UIFont fontWithName: @"Futura-CondensedExtraBold" size: 60.0];
        [_lblGymTimerLabel setFrame: CGRectMake(0.0, 50.0, DEVICE_WIDTH, 80.0)];
        [_lblGymTimerLabel setText: @"GymTimer"];
        [_lblGymTimerLabel setFont: fontGymTimer];
        [_lblGymTimerLabel setAlpha: 1.0];
        
        //Set Content View Layout
        [_viewContentView setFrame: CGRectMake(16.0, 148.0, (DEVICE_WIDTH - 32.0), (DEVICE_HEIGHT - 188.0))];
        [_viewContentView setClipsToBounds: YES];
        [[_viewContentView layer] setCornerRadius: 30.0];
        [Utils addShadowFor: _viewContentView atTop: YES atBottom: YES atLeft: YES atRight: YES shadowRadius: 30.0 shadowColor: cGREEN_SHADOW];
        
        //Setup CollectionView Layout
        [_cvOnBoardingCollectionView setFrame: CGRectMake(16.0, 0.0, (DEVICE_WIDTH - 32.0), DEVICE_HEIGHT + 0.0)];
        [_cvOnBoardingCollectionView setBackgroundColor: UIColor.clearColor];
        [_cvOnBoardingCollectionView setDelegate: self];
        [_cvOnBoardingCollectionView setDataSource: self];
        
        [_pageControl setFrame: CGRectMake(_viewContentView.frame.origin.x + ((_viewContentView.frame.size.width - 80.0) / 2), _viewContentView.frame.origin.y + (_viewContentView.frame.size.height - 183.0), 80.0, 37.0)];
        
        //Set Skip Button Layout
        fontSkipButton = [UIFont fontWithName: @"Futura-Medium" size: 14.0];
        [_btnSkipButton setFrame: CGRectMake((_viewContentView.frame.origin.x + 322.0), (_viewContentView.frame.origin.y + 16.0), 30.0, 32.0)];
        [_btnSkipButton setTag: 0];
        NSDictionary *attrs = @{ NSForegroundColorAttributeName : UIColor.darkGrayColor,
                                 NSFontAttributeName : fontSkipButton
                                 };
        NSAttributedString *att = [[NSAttributedString alloc] initWithString: @"Skip" attributes: attrs];
        [_btnSkipButton setAttributedTitle: att forState: UIControlStateNormal];
        [_btnSkipButton setAlpha: 0.8];
        
        //Set Navigation Button Layout
        fontNavigationButton = [UIFont fontWithName: @"Futura-CondensedExtraBold" size: 28.0];
        strNavigationButtonTitle = @"YES";
        CGFloat btnY = _viewContentView.frame.origin.y + (_viewContentView.frame.size.height - 122.0);
        [_btnNavigationButton setFrame: CGRectMake((_viewContentView.frame.origin.x + 40.0), btnY, (DEVICE_WIDTH - 112.0), 90.0)];
        [_btnNavigationButton setTag: 0];
        [_btnNavigationButton setClipsToBounds: YES];
        [[_btnNavigationButton layer] setCornerRadius: 30.0];
        NSDictionary *dicBtnAtt = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                     NSFontAttributeName : fontNavigationButton
                                     };
        NSAttributedString *strBtnAtt = [[NSAttributedString alloc] initWithString: strNavigationButtonTitle attributes: dicBtnAtt];
        [_btnNavigationButton setAttributedTitle: strBtnAtt forState: UIControlStateNormal];
        
    } else if (IS_IPHONEX) {
        
        //Set GymTimer Label Layout
        fontGymTimer = [UIFont fontWithName: @"Futura-CondensedExtraBold" size: 60.0];
        [_lblGymTimerLabel setFrame: CGRectMake(0.0, 50.0, DEVICE_WIDTH, 80.0)];
        [_lblGymTimerLabel setText: @"GymTimer"];
        [_lblGymTimerLabel setFont: fontGymTimer];
        [_lblGymTimerLabel setAlpha: 1.0];
        
        //Set Content View Layout
        [_viewContentView setFrame: CGRectMake(16.0, 148.0, (DEVICE_WIDTH - 32.0), (DEVICE_HEIGHT - 188.0))];
        [_viewContentView setClipsToBounds: YES];
        [[_viewContentView layer] setCornerRadius: 30.0];
        [Utils addShadowFor: _viewContentView atTop: YES atBottom: YES atLeft: YES atRight: YES shadowRadius: 30.0 shadowColor: cGREEN_SHADOW];
        
        //Setup CollectionView Layout
        [_cvOnBoardingCollectionView setFrame: CGRectMake(16.0, 0.0, (DEVICE_WIDTH - 32.0), DEVICE_HEIGHT + 0.0)];
        [_cvOnBoardingCollectionView setBackgroundColor: UIColor.clearColor];
        [_cvOnBoardingCollectionView setDelegate: self];
        [_cvOnBoardingCollectionView setDataSource: self];
        
        [_pageControl setFrame: CGRectMake(_viewContentView.frame.origin.x + ((_viewContentView.frame.size.width - 80.0) / 2), _viewContentView.frame.origin.y + (_viewContentView.frame.size.height - 183.0), 80.0, 37.0)];
        
        //Set Skip Button Layout
        fontSkipButton = [UIFont fontWithName: @"Futura-Medium" size: 14.0];
        [_btnSkipButton setFrame: CGRectMake((_viewContentView.frame.origin.x + 282.0), (_viewContentView.frame.origin.y + 16.0), 30.0, 32.0)];
        [_btnSkipButton setTag: 0];
        NSDictionary *attrs = @{ NSForegroundColorAttributeName : UIColor.darkGrayColor,
                                 NSFontAttributeName : fontSkipButton
                                 };
        NSAttributedString *att = [[NSAttributedString alloc] initWithString: @"Skip" attributes: attrs];
        [_btnSkipButton setAttributedTitle: att forState: UIControlStateNormal];
        [_btnSkipButton setAlpha: 0.8];
        
        //Set Navigation Button Layout
        fontNavigationButton = [UIFont fontWithName: @"Futura-CondensedExtraBold" size: 28.0];
        strNavigationButtonTitle = @"YES";
        CGFloat btnY = _viewContentView.frame.origin.y + (_viewContentView.frame.size.height - 122.0);
        [_btnNavigationButton setFrame: CGRectMake((_viewContentView.frame.origin.x + 40.0), btnY, (DEVICE_WIDTH - 112.0), 90.0)];
        [_btnNavigationButton setTag: 0];
        [_btnNavigationButton setClipsToBounds: YES];
        [[_btnNavigationButton layer] setCornerRadius: 30.0];
        NSDictionary *dicBtnAtt = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                     NSFontAttributeName : fontNavigationButton
                                     };
        NSAttributedString *strBtnAtt = [[NSAttributedString alloc] initWithString: strNavigationButtonTitle attributes: dicBtnAtt];
        [_btnNavigationButton setAttributedTitle: strBtnAtt forState: UIControlStateNormal];
        
    } else if (IS_IPHONE8PLUS) {
        
        //Set GymTimer Label Layout
        fontGymTimer = [UIFont fontWithName: @"Futura-CondensedExtraBold" size: 62.0];
        [_lblGymTimerLabel setFrame: CGRectMake(0.0, 40.0, DEVICE_WIDTH, 80.0)];
        [_lblGymTimerLabel setText: @"GymTimer"];
        [_lblGymTimerLabel setFont: fontGymTimer];
        [_lblGymTimerLabel setAlpha: 1.0];
        
        //Set Content View Layout
        [_viewContentView setFrame: CGRectMake(16.0, 138.0, (DEVICE_WIDTH - 32.0), (DEVICE_HEIGHT - 158.0))];
        [_viewContentView setClipsToBounds: YES];
        [[_viewContentView layer] setCornerRadius: 30.0];
        [Utils addShadowFor: _viewContentView atTop: YES atBottom: YES atLeft: YES atRight: YES shadowRadius: 30.0 shadowColor: cGREEN_SHADOW];
        
        //Setup CollectionView Layout
        [_cvOnBoardingCollectionView setFrame: CGRectMake(16.0, 0.0, (DEVICE_WIDTH - 32.0), DEVICE_HEIGHT + 0.0)];
        [_cvOnBoardingCollectionView setBackgroundColor: UIColor.clearColor];
        [_cvOnBoardingCollectionView setDelegate: self];
        [_cvOnBoardingCollectionView setDataSource: self];
        
        [_pageControl setFrame: CGRectMake(_viewContentView.frame.origin.x + ((_viewContentView.frame.size.width - 80.0) / 2), _viewContentView.frame.origin.y + (_viewContentView.frame.size.height - 158.0), 80.0, 37.0)];
        
        //Set Skip Button Layout
        fontSkipButton = [UIFont fontWithName: @"Futura-Medium" size: 16.0];
        [_btnSkipButton setFrame: CGRectMake((_viewContentView.frame.origin.x + 310.0), (_viewContentView.frame.origin.y + 20.0), 38.0, 32.0)];
        [_btnSkipButton setTag: 0];
        NSDictionary *attrs = @{ NSForegroundColorAttributeName : UIColor.darkGrayColor,
                                 NSFontAttributeName : fontSkipButton
                                 };
        NSAttributedString *att = [[NSAttributedString alloc] initWithString: @"Skip" attributes: attrs];
        [_btnSkipButton setAttributedTitle: att forState: UIControlStateNormal];
        [_btnSkipButton setAlpha: 0.8];
        
        //Set Navigation Button Layout
        fontNavigationButton = [UIFont fontWithName: @"Futura-CondensedExtraBold" size: 28.0];
        strNavigationButtonTitle = @"YES";
        CGFloat btnY = _viewContentView.frame.origin.y + (_viewContentView.frame.size.height - 112.0);
        [_btnNavigationButton setFrame: CGRectMake((_viewContentView.frame.origin.x + 40.0), btnY, (DEVICE_WIDTH - 112.0), 90.0)];
        [_btnNavigationButton setTag: 0];
        [_btnNavigationButton setClipsToBounds: YES];
        [[_btnNavigationButton layer] setCornerRadius: 30.0];
        NSDictionary *dicBtnAtt = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                     NSFontAttributeName : fontNavigationButton
                                     };
        NSAttributedString *strBtnAtt = [[NSAttributedString alloc] initWithString: strNavigationButtonTitle attributes: dicBtnAtt];
        [_btnNavigationButton setAttributedTitle: strBtnAtt forState: UIControlStateNormal];
        
    } else if (IS_IPHONE8) {
        
        //Set GymTimer Label Layout
        fontGymTimer = [UIFont fontWithName: @"Futura-CondensedExtraBold" size: 55.0];
        [_lblGymTimerLabel setFrame: CGRectMake(0.0, 40.0, DEVICE_WIDTH, 80.0)];
        [_lblGymTimerLabel setText: @"GymTimer"];
        [_lblGymTimerLabel setFont: fontGymTimer];
        [_lblGymTimerLabel setAlpha: 1.0];
        
        //Set Content View Layout
        [_viewContentView setFrame: CGRectMake(16.0, 138.0, (DEVICE_WIDTH - 32.0), (DEVICE_HEIGHT - 158.0))];
        [_viewContentView setClipsToBounds: YES];
        [[_viewContentView layer] setCornerRadius: 30.0];
        [Utils addShadowFor: _viewContentView atTop: YES atBottom: YES atLeft: YES atRight: YES shadowRadius: 30.0 shadowColor: cGREEN_SHADOW];
        
        //Setup CollectionView Layout
        [_cvOnBoardingCollectionView setFrame: CGRectMake(16.0, 0.0, (DEVICE_WIDTH - 32.0), DEVICE_HEIGHT + 0.0)];
        [_cvOnBoardingCollectionView setBackgroundColor: UIColor.clearColor];
        [_cvOnBoardingCollectionView setDelegate: self];
        [_cvOnBoardingCollectionView setDataSource: self];
        
        [_pageControl setFrame: CGRectMake(_viewContentView.frame.origin.x + ((_viewContentView.frame.size.width - 80.0) / 2), _viewContentView.frame.origin.y + (_viewContentView.frame.size.height - 146.0), 80.0, 37.0)];
        
        //Set Skip Button Layout
        fontSkipButton = [UIFont fontWithName: @"Futura-Medium" size: 14.0];
        [_btnSkipButton setFrame: CGRectMake((_viewContentView.frame.origin.x + 282.0), (_viewContentView.frame.origin.y + 16.0), 30.0, 32.0)];
        [_btnSkipButton setTag: 0];
        NSDictionary *attrs = @{ NSForegroundColorAttributeName : UIColor.darkGrayColor,
                                 NSFontAttributeName : fontSkipButton
                                 };
        NSAttributedString *att = [[NSAttributedString alloc] initWithString: @"Skip" attributes: attrs];
        [_btnSkipButton setAttributedTitle: att forState: UIControlStateNormal];
        [_btnSkipButton setAlpha: 0.8];
        
        //Set Navigation Button Layout
        fontNavigationButton = [UIFont fontWithName: @"Futura-CondensedExtraBold" size: 24.0];
        strNavigationButtonTitle = @"YES";
        CGFloat btnY = _viewContentView.frame.origin.y + (_viewContentView.frame.size.height - 102.0);
        [_btnNavigationButton setFrame: CGRectMake((_viewContentView.frame.origin.x + 40.0), btnY, (DEVICE_WIDTH - 112.0), 80.0)];
        [_btnNavigationButton setTag: 0];
        [_btnNavigationButton setClipsToBounds: YES];
        [[_btnNavigationButton layer] setCornerRadius: 30.0];
        NSDictionary *dicBtnAtt = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                     NSFontAttributeName : fontNavigationButton
                                     };
        NSAttributedString *strBtnAtt = [[NSAttributedString alloc] initWithString: strNavigationButtonTitle attributes: dicBtnAtt];
        [_btnNavigationButton setAttributedTitle: strBtnAtt forState: UIControlStateNormal];
        
    } else {
     
        //Set GymTimer Label Layout
        fontGymTimer = [UIFont fontWithName: @"Futura-CondensedExtraBold" size: 45.0];
        [_lblGymTimerLabel setFrame: CGRectMake(0.0, 30.0, DEVICE_WIDTH, 80.0)];
        [_lblGymTimerLabel setText: @"GymTimer"];
        [_lblGymTimerLabel setFont: fontGymTimer];
        [_lblGymTimerLabel setAlpha: 1.0];
        
        //Set Content View Layout
        [_viewContentView setFrame: CGRectMake(16.0, 118.0, (DEVICE_WIDTH - 32.0), (DEVICE_HEIGHT - 138.0))];
        [_viewContentView setClipsToBounds: YES];
        [[_viewContentView layer] setCornerRadius: 30.0];
        [Utils addShadowFor: _viewContentView atTop: YES atBottom: YES atLeft: YES atRight: YES shadowRadius: 30.0 shadowColor: cGREEN_SHADOW];
        
        //Setup CollectionView Layout
        [_cvOnBoardingCollectionView setFrame: CGRectMake(16.0, 0.0, (DEVICE_WIDTH - 32.0), DEVICE_HEIGHT + 0.0)];
        [_cvOnBoardingCollectionView setBackgroundColor: UIColor.clearColor];
        [_cvOnBoardingCollectionView setDelegate: self];
        [_cvOnBoardingCollectionView setDataSource: self];
        
        [_pageControl setFrame: CGRectMake(_viewContentView.frame.origin.x + ((_viewContentView.frame.size.width - 80.0) / 2), _viewContentView.frame.origin.y + (_viewContentView.frame.size.height - 130.0), 80.0, 37.0)];
        
        //Set Skip Button Layout
        fontSkipButton = [UIFont fontWithName: @"Futura-Medium" size: 11.0];
        [_btnSkipButton setFrame: CGRectMake((_viewContentView.frame.origin.x + 232.0), (_viewContentView.frame.origin.y + 8.0), 30.0, 32.0)];
        [_btnSkipButton setTag: 0];
        NSDictionary *attrs = @{ NSForegroundColorAttributeName : UIColor.darkGrayColor,
                                 NSFontAttributeName : fontSkipButton
                                 };
        NSAttributedString *att = [[NSAttributedString alloc] initWithString: @"Skip" attributes: attrs];
        [_btnSkipButton setAttributedTitle: att forState: UIControlStateNormal];
        [_btnSkipButton setAlpha: 0.8];
        
        //Set Navigation Button Layout
        fontNavigationButton = [UIFont fontWithName: @"Futura-CondensedExtraBold" size: 20.0];
        strNavigationButtonTitle = @"YES";
        CGFloat btnY = _viewContentView.frame.origin.y + (_viewContentView.frame.size.height - 90.0);
        [_btnNavigationButton setFrame: CGRectMake((_viewContentView.frame.origin.x + 40.0), btnY, (DEVICE_WIDTH - 112.0), 70.0)];
        [_btnNavigationButton setTag: 0];
        [_btnNavigationButton setClipsToBounds: YES];
        [[_btnNavigationButton layer] setCornerRadius: 26.0];
        NSDictionary *dicBtnAtt = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                     NSFontAttributeName : fontNavigationButton
                                     };
        NSAttributedString *strBtnAtt = [[NSAttributedString alloc] initWithString: strNavigationButtonTitle attributes: dicBtnAtt];
        [_btnNavigationButton setAttributedTitle: strBtnAtt forState: UIControlStateNormal];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
}



//MARK:- CollectionView Delegate And DataSource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1.0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4.0;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OnBoardingCollectionViewCell *cellOnboard = [collectionView dequeueReusableCellWithReuseIdentifier: cvONBOARDING_CELL forIndexPath: indexPath];
    
    [cellOnboard setBackgroundColor: UIColor.clearColor];
    
    [cellOnboard.lblGymTimerLabel setHidden: YES];
    [cellOnboard.btnSkipButton setHidden: YES];
    [cellOnboard.pageControlOnboard setHidden: YES];
    [cellOnboard.btnNavigationButton setHidden: YES];
    
    //Set Background Image Layout
    UIImage *bgImage = (indexPath.row != 2) ? iWELCOME_SCREEN : iREST_SCREEN;
    
    [UIView transitionWithView: _imgBackgroundImage duration: 1.0 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{

        [self->_imgBackgroundImage setImage: bgImage];
        
    } completion: nil];
    
    //Set Gym Timer Label Color
    [UIView transitionWithView: _lblGymTimerLabel duration: 1.0 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        (indexPath.row != 2) ? [self->_lblGymTimerLabel setTextColor: cGYM_TIMER_LABEL] : [self->_lblGymTimerLabel setTextColor: [UIColor colorWithRed: 125.0/255.0 green: 45.0/255.0 blue: 45.0/255.0 alpha: 1.0]];
        
    } completion: nil];
    
    [cellOnboard.viewContentView setBackgroundColor: UIColor.clearColor];
    
    if (indexPath.row == 0) {
        
        //Set Navigation Button Title
        strNavigationButtonTitle = @"YES";
        [_btnNavigationButton setTag: 0];
        NSDictionary *dicBtnAtt = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                     NSFontAttributeName : fontNavigationButton
                                     };
        NSAttributedString *strBtnAtt = [[NSAttributedString alloc] initWithString: strNavigationButtonTitle attributes: dicBtnAtt];
        [_btnNavigationButton setAttributedTitle: strBtnAtt forState: UIControlStateNormal];
        [_btnNavigationButton setBackgroundColor: [UIColor colorWithRed:20.0/255.0 green:204.0/255.0 blue:100.0/255.0 alpha:1.0]];
        
        [_pageControl setHidden: YES];
        
    } else if (indexPath.row == 1) {
        
        strNavigationButtonTitle = @"NEXT";
        [_btnNavigationButton setTag: 1];
        NSDictionary *dicBtnAtt = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                     NSFontAttributeName : fontNavigationButton
                                     };
        NSAttributedString *strBtnAtt = [[NSAttributedString alloc] initWithString: strNavigationButtonTitle attributes: dicBtnAtt];
        [_btnNavigationButton setAttributedTitle: strBtnAtt forState: UIControlStateNormal];
        [_btnNavigationButton setBackgroundColor: UIColor.blackColor];
        
        [_pageControl setHidden: NO];
        [_pageControl setCurrentPage: 0];
        
    } else if (indexPath.row == 2) {

        strNavigationButtonTitle = @"NEXT";
        [_btnNavigationButton setTag: 2];
        NSDictionary *dicBtnAtt = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                     NSFontAttributeName : fontNavigationButton
                                     };
        NSAttributedString *strBtnAtt = [[NSAttributedString alloc] initWithString: strNavigationButtonTitle attributes: dicBtnAtt];
        [_btnNavigationButton setAttributedTitle: strBtnAtt forState: UIControlStateNormal];
        [_btnNavigationButton setBackgroundColor: UIColor.blackColor];
        
        [_pageControl setHidden: NO];
        [_pageControl setCurrentPage: 1];
        
    } else if (indexPath.row == 3) {
        
        strNavigationButtonTitle = @"START";
        [_btnNavigationButton setTag: 3];
        NSDictionary *dicBtnAtt = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                                     NSFontAttributeName : fontNavigationButton
                                     };
        NSAttributedString *strBtnAtt = [[NSAttributedString alloc] initWithString: strNavigationButtonTitle attributes: dicBtnAtt];
        [_btnNavigationButton setAttributedTitle: strBtnAtt forState: UIControlStateNormal];
        [_btnNavigationButton setBackgroundColor: UIColor.blackColor];
        
        [_pageControl setHidden: NO];
        [_pageControl setCurrentPage: 2];
        
    } else {}
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OnBoardingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: cvONBOARDING_CELL forIndexPath: indexPath];
    
    [cell.lblGymTimerLabel setHidden: YES];
    [cell.lblGymTimerLabel setHidden: YES];
    [cell.btnSkipButton setHidden: YES];
    [cell.pageControlOnboard setHidden: YES];
    [cell.btnNavigationButton setHidden: YES];
    [cell.viewContentView setBackgroundColor: UIColor.clearColor];
    
    if (IS_IPHONEXR) {
        
        //        fontSkipButton = [UIFont fontWithName: @"Futura-Medium" size: 14.0];
        //        fontNavigationButton = [UIFont fontWithName: @"Futura-CondensedExtraBold" size: 28.0];
        fontMainLabel = [UIFont fontWithName: @"Futura-CondensedExtraBold" size: 32.0];
        fontSubLabel = [UIFont fontWithName: @"Futura-Medium" size: 18.0];
        
        [cell.pageControlOnboard setFrame: CGRectMake((cell.viewContentView.frame.size.width - 80.0) / 2, (cell.viewContentView.frame.size.height - 183.0), 80.0, 37.0)];
        
    } else if (IS_IPHONEX) {
        
//        fontSkipButton = [UIFont fontWithName: @"Futura-Medium" size: 14.0];
//        fontNavigationButton = [UIFont fontWithName: @"Futura-CondensedExtraBold" size: 28.0];
        fontMainLabel = [UIFont fontWithName: @"Futura-CondensedExtraBold" size: 32.0];
        fontSubLabel = [UIFont fontWithName: @"Futura-Medium" size: 18.0];
        
        [cell.pageControlOnboard setFrame: CGRectMake((cell.viewContentView.frame.size.width - 80.0) / 2, (cell.viewContentView.frame.size.height - 183.0), 80.0, 37.0)];
        
    } else if (IS_IPHONE8PLUS) {
        
//        fontSkipButton = [UIFont fontWithName: @"Futura-Medium" size: 14.0];
//        fontNavigationButton = [UIFont fontWithName: @"Futura-CondensedExtraBold" size: 28.0];
        fontMainLabel = [UIFont fontWithName: @"Futura-CondensedExtraBold" size: 32.0];
        fontSubLabel = [UIFont fontWithName: @"Futura-Medium" size: 18.0];
        
        [cell.pageControlOnboard setFrame: CGRectMake((cell.viewContentView.frame.size.width - 80.0) / 2, (cell.viewContentView.frame.size.height - 183.0), 80.0, 37.0)];
        
    } else if (IS_IPHONE8) {
        
//        fontSkipButton = [UIFont fontWithName: @"Futura-Medium" size: 14.0];
//        fontNavigationButton = [UIFont fontWithName: @"Futura-CondensedExtraBold" size: 28.0];
        fontMainLabel = [UIFont fontWithName: @"Futura-CondensedExtraBold" size: 30.0];
        fontSubLabel = [UIFont fontWithName: @"Futura-Medium" size: 16.0];
        
        [cell.pageControlOnboard setFrame: CGRectMake((cell.viewContentView.frame.size.width - 80.0) / 2, (cell.viewContentView.frame.size.height - 183.0), 80.0, 37.0)];
        
    } else {
        
//        fontSkipButton = [UIFont fontWithName: @"Futura-Medium" size: 14.0];
//        fontNavigationButton = [UIFont fontWithName: @"Futura-CondensedExtraBold" size: 28.0];
        fontMainLabel = [UIFont fontWithName: @"Futura-CondensedExtraBold" size: 28.0];
        fontSubLabel = [UIFont fontWithName: @"Futura-Medium" size: 14.0];
        
        [cell.pageControlOnboard setFrame: CGRectMake((cell.viewContentView.frame.size.width - 80.0) / 2, (cell.viewContentView.frame.size.height - 183.0), 80.0, 37.0)];
        
    }
    
    [cell.viewMainView setFrame: CGRectMake(0.0, 0.0, (DEVICE_WIDTH - 32.0), DEVICE_HEIGHT)];
    
    [cell.viewContentView setFrame: CGRectMake(0.0, 148.0, (DEVICE_WIDTH - 32.0), (DEVICE_HEIGHT - 188.0))];
    [cell.viewContentView setClipsToBounds: YES];
    [[cell.viewContentView layer] setCornerRadius: 30.0];
    //[Utils addShadowFor: cell.viewContentView atTop: YES atBottom: YES atLeft: YES atRight: YES shadowRadius: 30.0 shadowColor: cGREEN_SHADOW];
    
    if (indexPath.row == 0) {
        
        //Set Content Icon
        contentImage = [UIImage imageNamed: @"imgOnboardFirst"];
        
        //Set Content Main Label
        strMainLabel = @"Welcome.";
        [cell.lblContentMainLabel setTextColor: UIColor.blackColor];
        
        //Set Content Sub Label
        strSubLabel = @"So you want to boost your workout results ?";
        
//        //Set Navigation Button Title
//        strNavigationButtonTitle = @"YES";
//        [_btnNavigationButton setBackgroundColor: [UIColor colorWithRed:20.0/255.0 green:204.0/255.0 blue:100.0/255.0 alpha:1.0]];
        
        //Set Show-Hide of Page Control
        //[_pageControl setHidden: YES];
        
    } else if (indexPath.row == 1) {
        
        contentImage = [UIImage imageNamed: @"imgOnboardSecond"];
        strMainLabel = @"Let's get effective!";
        [cell.lblContentMainLabel setTextColor: UIColor.blackColor];
        strSubLabel = @"We made it simple for you to train the right way.";
//        strNavigationButtonTitle = @"NEXT";
//        [cell.btnNavigationButton setBackgroundColor: UIColor.blackColor];
//        [_pageControl setHidden: NO];
//        [_pageControl setCurrentPage: 0];
        
    } else if (indexPath.row == 2) {
        
        contentImage = [UIImage imageNamed: @"imgOnboardThird"];
        strMainLabel = @"Time your rest.";
        [cell.lblContentMainLabel setTextColor: cPROGRESS_BAR];
        strSubLabel = @"Taking a precise rest time between each set has been proven to drastically enhance results.";
//        strNavigationButtonTitle = @"NEXT";
//        [cell.btnNavigationButton setBackgroundColor: UIColor.blackColor];
//        [_pageControl setHidden: NO];
//        [_pageControl setCurrentPage: 1];
        
    } else {
        
        contentImage = [UIImage imageNamed: @"imgOnboardFourth"];
        strMainLabel = @"Count your sets.";
        [cell.lblContentMainLabel setTextColor: [UIColor colorWithRed:20.0/255.0 green:204.0/255.0 blue:100.0/255.0 alpha:1.0]];
        strSubLabel = @"We automatically count your sets and exercises to let you focus 100% on your workouts.";
//        strNavigationButtonTitle = @"START";
//        [cell.btnNavigationButton setBackgroundColor: UIColor.blackColor];
//        [_pageControl setHidden: NO];
//        [_pageControl setCurrentPage: 2];
        
    }
    
    
    if (IS_IPHONEXR) {
        
        //Set Skip Button Layout
        [cell.btnSkipButton setFrame: CGRectMake(282.0, 16.0, 30.0, 32.0)];
        [cell.btnSkipButton setTag: indexPath.row];
        NSDictionary *attrs = @{ NSForegroundColorAttributeName : UIColor.darkGrayColor,
                                 NSFontAttributeName : fontSkipButton
                                 };
        NSAttributedString *att = [[NSAttributedString alloc] initWithString: @"Skip" attributes: attrs];
        [cell.btnSkipButton setAttributedTitle: att forState: UIControlStateNormal];
        [cell.btnSkipButton setAlpha: 0.8];
        
        //Set Content image Layout
        [cell.imgContentIconImage setFrame: CGRectMake((cell.viewContentView.frame.size.width - 130.0) / 2, 80.0, 130.0, 130.0)];
        [cell.imgContentIconImage setImage: contentImage];
        [cell.imgContentIconImage setClipsToBounds: YES];
        [[cell.imgContentIconImage layer] setCornerRadius: cell.imgContentIconImage.frame.size.height / 2];
        [Utils addShadowFor: cell.imgContentIconImage atTop: YES atBottom: YES atLeft: YES atRight: YES shadowRadius: cell.imgContentIconImage.frame.size.height / 2 shadowColor: UIColor.lightTextColor];
        
        //Set Content Main label Layout
        CGFloat lblMainY = (2 * cell.imgContentIconImage.frame.origin.y + cell.imgContentIconImage.frame.size.height);
        [cell.lblContentMainLabel setFrame: CGRectMake(0.0, lblMainY, (DEVICE_WIDTH - 32.0), 42.0)];
        [cell.lblContentMainLabel setText: strMainLabel];
        [cell.lblContentMainLabel setFont: fontMainLabel];
        
    } else if (IS_IPHONEX) {
        
        //Set Skip Button Layout
        [cell.btnSkipButton setFrame: CGRectMake(282.0, 16.0, 30.0, 32.0)];
        [cell.btnSkipButton setTag: indexPath.row];
        NSDictionary *attrs = @{ NSForegroundColorAttributeName : UIColor.darkGrayColor,
                                 NSFontAttributeName : fontSkipButton
                                 };
        NSAttributedString *att = [[NSAttributedString alloc] initWithString: @"Skip" attributes: attrs];
        [cell.btnSkipButton setAttributedTitle: att forState: UIControlStateNormal];
        [cell.btnSkipButton setAlpha: 0.8];
        
        //Set Content image Layout
        [cell.imgContentIconImage setFrame: CGRectMake((cell.viewContentView.frame.size.width - 130.0) / 2, 80.0, 130.0, 130.0)];
        [cell.imgContentIconImage setImage: contentImage];
        [cell.imgContentIconImage setClipsToBounds: YES];
        [[cell.imgContentIconImage layer] setCornerRadius: cell.imgContentIconImage.frame.size.height / 2];
        [Utils addShadowFor: cell.imgContentIconImage atTop: YES atBottom: YES atLeft: YES atRight: YES shadowRadius: cell.imgContentIconImage.frame.size.height / 2 shadowColor: UIColor.lightTextColor];
        
        //Set Content Main label Layout
        CGFloat lblMainY = (2 * cell.imgContentIconImage.frame.origin.y + cell.imgContentIconImage.frame.size.height);
        [cell.lblContentMainLabel setFrame: CGRectMake(0.0, lblMainY, (DEVICE_WIDTH - 32.0), 42.0)];
        [cell.lblContentMainLabel setText: strMainLabel];
        [cell.lblContentMainLabel setFont: fontMainLabel];
        
    } else if (IS_IPHONE8PLUS) {
        
        //Set Skip Button Layout
        [cell.btnSkipButton setFrame: CGRectMake(282.0, 16.0, 30.0, 32.0)];
        [cell.btnSkipButton setTag: indexPath.row];
        NSDictionary *attrs = @{ NSForegroundColorAttributeName : UIColor.darkGrayColor,
                                 NSFontAttributeName : fontSkipButton
                                 };
        NSAttributedString *att = [[NSAttributedString alloc] initWithString: @"Skip" attributes: attrs];
        [cell.btnSkipButton setAttributedTitle: att forState: UIControlStateNormal];
        [cell.btnSkipButton setAlpha: 0.8];
        
        //Set Content image Layout
        [cell.imgContentIconImage setFrame: CGRectMake((cell.viewContentView.frame.size.width - 130.0) / 2, 70.0, 130.0, 130.0)];
        [cell.imgContentIconImage setImage: contentImage];
        [cell.imgContentIconImage setClipsToBounds: YES];
        [[cell.imgContentIconImage layer] setCornerRadius: cell.imgContentIconImage.frame.size.height / 2];
        [Utils addShadowFor: cell.imgContentIconImage atTop: YES atBottom: YES atLeft: YES atRight: YES shadowRadius: cell.imgContentIconImage.frame.size.height / 2 shadowColor: UIColor.lightTextColor];
        
        //Set Content Main label Layout
        CGFloat lblMainY = (2 * cell.imgContentIconImage.frame.origin.y + cell.imgContentIconImage.frame.size.height);
        [cell.lblContentMainLabel setFrame: CGRectMake(0.0, lblMainY, (DEVICE_WIDTH - 32.0), 42.0)];
        [cell.lblContentMainLabel setText: strMainLabel];
        [cell.lblContentMainLabel setFont: fontMainLabel];
        
    } else if (IS_IPHONE8) {
        
        //Set Skip Button Layout
        [cell.btnSkipButton setFrame: CGRectMake(282.0, 16.0, 30.0, 32.0)];
        [cell.btnSkipButton setTag: indexPath.row];
        NSDictionary *attrs = @{ NSForegroundColorAttributeName : UIColor.darkGrayColor,
                                 NSFontAttributeName : fontSkipButton
                                 };
        NSAttributedString *att = [[NSAttributedString alloc] initWithString: @"Skip" attributes: attrs];
        [cell.btnSkipButton setAttributedTitle: att forState: UIControlStateNormal];
        [cell.btnSkipButton setAlpha: 0.8];
        
        //Set Content image Layout
        [cell.imgContentIconImage setFrame: CGRectMake((cell.viewContentView.frame.size.width - 110.0) / 2, 60.0, 110.0, 110.0)];
        [cell.imgContentIconImage setImage: contentImage];
        [cell.imgContentIconImage setClipsToBounds: YES];
        [[cell.imgContentIconImage layer] setCornerRadius: cell.imgContentIconImage.frame.size.height / 2];
        [Utils addShadowFor: cell.imgContentIconImage atTop: YES atBottom: YES atLeft: YES atRight: YES shadowRadius: cell.imgContentIconImage.frame.size.height / 2 shadowColor: UIColor.lightTextColor];
        
        //Set Content Main label Layout
        CGFloat lblMainY = (2 * cell.imgContentIconImage.frame.origin.y + cell.imgContentIconImage.frame.size.height);
        [cell.lblContentMainLabel setFrame: CGRectMake(0.0, lblMainY, (DEVICE_WIDTH - 32.0), 42.0)];
        [cell.lblContentMainLabel setText: strMainLabel];
        [cell.lblContentMainLabel setFont: fontMainLabel];
        
    } else {
        
        //Set Skip Button Layout
        [cell.btnSkipButton setFrame: CGRectMake(282.0, 16.0, 30.0, 32.0)];
        [cell.btnSkipButton setTag: indexPath.row];
        NSDictionary *attrs = @{ NSForegroundColorAttributeName : UIColor.darkGrayColor,
                                 NSFontAttributeName : fontSkipButton
                                 };
        NSAttributedString *att = [[NSAttributedString alloc] initWithString: @"Skip" attributes: attrs];
        [cell.btnSkipButton setAttributedTitle: att forState: UIControlStateNormal];
        [cell.btnSkipButton setAlpha: 0.8];
        
        //Set Content image Layout
        [cell.imgContentIconImage setFrame: CGRectMake((cell.viewContentView.frame.size.width - 100.0) / 2, 40.0, 100.0, 100.0)];
        [cell.imgContentIconImage setImage: contentImage];
        [cell.imgContentIconImage setClipsToBounds: YES];
        [[cell.imgContentIconImage layer] setCornerRadius: cell.imgContentIconImage.frame.size.height / 2];
        [Utils addShadowFor: cell.imgContentIconImage atTop: YES atBottom: YES atLeft: YES atRight: YES shadowRadius: cell.imgContentIconImage.frame.size.height / 2 shadowColor: UIColor.lightTextColor];
        
        //Set Content Main label Layout
        CGFloat lblMainY = (2 * cell.imgContentIconImage.frame.origin.y + cell.imgContentIconImage.frame.size.height);
        [cell.lblContentMainLabel setFrame: CGRectMake(0.0, lblMainY, (DEVICE_WIDTH - 32.0), 42.0)];
        [cell.lblContentMainLabel setText: strMainLabel];
        [cell.lblContentMainLabel setFont: fontMainLabel];
        
    }
    
    
    //Set Content Sub label Layout
    if (indexPath.row == 0) {
        
        if (IS_IPHONEXR) {
            CGFloat lblSubY = (cell.lblContentMainLabel.frame.origin.y + cell.lblContentMainLabel.frame.size.height - 32.0);
            CGFloat lblSubHeight = (cell.viewContentView.frame.size.height - (lblSubY + cell.btnNavigationButton.frame.size.height + 96.0));
            [cell.lblContentSubLabel setFrame: CGRectMake(70.0, lblSubY, (cell.viewContentView.frame.size.width - 140.0), lblSubHeight)];
        } else if (IS_IPHONEX) {
            CGFloat lblSubY = (cell.lblContentMainLabel.frame.origin.y + cell.lblContentMainLabel.frame.size.height - 32.0);
            CGFloat lblSubHeight = (cell.viewContentView.frame.size.height - (lblSubY + cell.btnNavigationButton.frame.size.height + 96.0));
            [cell.lblContentSubLabel setFrame: CGRectMake(70.0, lblSubY, (cell.viewContentView.frame.size.width - 140.0), lblSubHeight)];
        } else if (IS_IPHONE8PLUS) {
            CGFloat lblSubY = (cell.lblContentMainLabel.frame.origin.y + cell.lblContentMainLabel.frame.size.height - 38.0);
            CGFloat lblSubHeight = (cell.viewContentView.frame.size.height - (lblSubY + cell.btnNavigationButton.frame.size.height + 46.0));
            [cell.lblContentSubLabel setFrame: CGRectMake(88.0, lblSubY, (cell.viewContentView.frame.size.width - 176.0), lblSubHeight)];
        } else if (IS_IPHONE8) {
            CGFloat lblSubY = (cell.lblContentMainLabel.frame.origin.y + cell.lblContentMainLabel.frame.size.height - 28.0);
            CGFloat lblSubHeight = (cell.viewContentView.frame.size.height - (lblSubY + cell.btnNavigationButton.frame.size.height + 46.0));
            [cell.lblContentSubLabel setFrame: CGRectMake(70.0, lblSubY, (cell.viewContentView.frame.size.width - 140.0), lblSubHeight)];
        } else {
            CGFloat lblSubY = (cell.lblContentMainLabel.frame.origin.y + cell.lblContentMainLabel.frame.size.height + 62.0);
            CGFloat lblSubHeight = (cell.viewContentView.frame.size.height - (lblSubY + cell.btnNavigationButton.frame.size.height + 96.0));
            [cell.lblContentSubLabel setFrame: CGRectMake(70.0, lblSubY, (cell.viewContentView.frame.size.width - 140.0), lblSubHeight)];
        }
        
    } else if (indexPath.row == 1) {
        
        if (IS_IPHONEXR) {
            CGFloat lblSubY = (cell.lblContentMainLabel.frame.origin.y + cell.lblContentMainLabel.frame.size.height - 40.0);
            CGFloat lblSubHeight = (cell.viewContentView.frame.size.height - (lblSubY + cell.btnNavigationButton.frame.size.height + 96.0));
            [cell.lblContentSubLabel setFrame: CGRectMake(60.0, lblSubY, (cell.viewContentView.frame.size.width - 120.0), lblSubHeight)];
        } else if (IS_IPHONEX) {
            CGFloat lblSubY = (cell.lblContentMainLabel.frame.origin.y + cell.lblContentMainLabel.frame.size.height - 40.0);
            CGFloat lblSubHeight = (cell.viewContentView.frame.size.height - (lblSubY + cell.btnNavigationButton.frame.size.height + 96.0));
            [cell.lblContentSubLabel setFrame: CGRectMake(60.0, lblSubY, (cell.viewContentView.frame.size.width - 120.0), lblSubHeight)];
        } else if (IS_IPHONE8PLUS) {
            CGFloat lblSubY = (cell.lblContentMainLabel.frame.origin.y + cell.lblContentMainLabel.frame.size.height - 48.0);
            CGFloat lblSubHeight = (cell.viewContentView.frame.size.height - (lblSubY + cell.btnNavigationButton.frame.size.height + 46.0));
            [cell.lblContentSubLabel setFrame: CGRectMake(80.0, lblSubY, (cell.viewContentView.frame.size.width - 160.0), lblSubHeight)];
        } else if (IS_IPHONE8) {
            CGFloat lblSubY = (cell.lblContentMainLabel.frame.origin.y + cell.lblContentMainLabel.frame.size.height - 28.0);
            CGFloat lblSubHeight = (cell.viewContentView.frame.size.height - (lblSubY + cell.btnNavigationButton.frame.size.height + 46.0));
            [cell.lblContentSubLabel setFrame: CGRectMake(60.0, lblSubY, (cell.viewContentView.frame.size.width - 120.0), lblSubHeight)];
        } else {
            CGFloat lblSubY = (cell.lblContentMainLabel.frame.origin.y + cell.lblContentMainLabel.frame.size.height + 48.0);
            CGFloat lblSubHeight = (cell.viewContentView.frame.size.height - (lblSubY + cell.btnNavigationButton.frame.size.height + 96.0));
            [cell.lblContentSubLabel setFrame: CGRectMake(60.0, lblSubY, (cell.viewContentView.frame.size.width - 120.0), lblSubHeight)];
        }
        
    } else if (indexPath.row == 2) {
        
        if (IS_IPHONEXR) {
            CGFloat lblSubY = (cell.lblContentMainLabel.frame.origin.y + cell.lblContentMainLabel.frame.size.height - 16.0);
            CGFloat lblSubHeight = (cell.viewContentView.frame.size.height - (lblSubY + cell.btnNavigationButton.frame.size.height + 96.0));
            [cell.lblContentSubLabel setFrame: CGRectMake(16.0, lblSubY, (cell.viewContentView.frame.size.width - 32.0), lblSubHeight)];
        } else if (IS_IPHONEX) {
            CGFloat lblSubY = (cell.lblContentMainLabel.frame.origin.y + cell.lblContentMainLabel.frame.size.height - 16.0);
            CGFloat lblSubHeight = (cell.viewContentView.frame.size.height - (lblSubY + cell.btnNavigationButton.frame.size.height + 96.0));
            [cell.lblContentSubLabel setFrame: CGRectMake(16.0, lblSubY, (cell.viewContentView.frame.size.width - 32.0), lblSubHeight)];
        } else if (IS_IPHONE8PLUS) {
            CGFloat lblSubY = (cell.lblContentMainLabel.frame.origin.y + cell.lblContentMainLabel.frame.size.height - 24.0);
            CGFloat lblSubHeight = (cell.viewContentView.frame.size.height - (lblSubY + cell.btnNavigationButton.frame.size.height + 46.0));
            [cell.lblContentSubLabel setFrame: CGRectMake(48.0, lblSubY, (cell.viewContentView.frame.size.width - 96.0), lblSubHeight)];
        } else if (IS_IPHONE8) {
            CGFloat lblSubY = (cell.lblContentMainLabel.frame.origin.y + cell.lblContentMainLabel.frame.size.height - 10.0);
            CGFloat lblSubHeight = (cell.viewContentView.frame.size.height - (lblSubY + cell.btnNavigationButton.frame.size.height + 46.0));
            [cell.lblContentSubLabel setFrame: CGRectMake(32.0, lblSubY, (cell.viewContentView.frame.size.width - 64.0), lblSubHeight)];
        } else {
            CGFloat lblSubY = (cell.lblContentMainLabel.frame.origin.y + cell.lblContentMainLabel.frame.size.height - 32.0);
            CGFloat lblSubHeight = (cell.viewContentView.frame.size.height - (lblSubY + cell.btnNavigationButton.frame.size.height + 0.0));
            [cell.lblContentSubLabel setFrame: CGRectMake(20.0, lblSubY, (cell.viewContentView.frame.size.width - 40.0), lblSubHeight)];
        }
        
    } else {
        
        if (IS_IPHONEXR) {
            CGFloat lblSubY = (cell.lblContentMainLabel.frame.origin.y + cell.lblContentMainLabel.frame.size.height - 7.0);
            CGFloat lblSubHeight = (cell.viewContentView.frame.size.height - (lblSubY + cell.btnNavigationButton.frame.size.height + 96.0));
            [cell.lblContentSubLabel setFrame: CGRectMake(40.0, lblSubY, (cell.viewContentView.frame.size.width - 80.0), lblSubHeight)];
        } else if (IS_IPHONEX) {
            CGFloat lblSubY = (cell.lblContentMainLabel.frame.origin.y + cell.lblContentMainLabel.frame.size.height - 7.0);
            CGFloat lblSubHeight = (cell.viewContentView.frame.size.height - (lblSubY + cell.btnNavigationButton.frame.size.height + 96.0));
            [cell.lblContentSubLabel setFrame: CGRectMake(40.0, lblSubY, (cell.viewContentView.frame.size.width - 80.0), lblSubHeight)];
        } else if (IS_IPHONE8PLUS) {
            CGFloat lblSubY = (cell.lblContentMainLabel.frame.origin.y + cell.lblContentMainLabel.frame.size.height - 16.0);
            CGFloat lblSubHeight = (cell.viewContentView.frame.size.height - (lblSubY + cell.btnNavigationButton.frame.size.height + 46.0));
            [cell.lblContentSubLabel setFrame: CGRectMake(64.0, lblSubY, (cell.viewContentView.frame.size.width - 128.0), lblSubHeight)];
        } else if (IS_IPHONE8) {
            CGFloat lblSubY = (cell.lblContentMainLabel.frame.origin.y + cell.lblContentMainLabel.frame.size.height - 0.0);
            CGFloat lblSubHeight = (cell.viewContentView.frame.size.height - (lblSubY + cell.btnNavigationButton.frame.size.height + 46.0));
            [cell.lblContentSubLabel setFrame: CGRectMake(56.0, lblSubY, (cell.viewContentView.frame.size.width - 112.0), lblSubHeight)];
        } else {
            CGFloat lblSubY = (cell.lblContentMainLabel.frame.origin.y + cell.lblContentMainLabel.frame.size.height - 20.0);
            CGFloat lblSubHeight = (cell.viewContentView.frame.size.height - (lblSubY + cell.btnNavigationButton.frame.size.height + 0.0));
            [cell.lblContentSubLabel setFrame: CGRectMake(40.0, lblSubY, (cell.viewContentView.frame.size.width - 80.0), lblSubHeight)];
        }
        
    }
    
    [cell.lblContentSubLabel setText: strSubLabel];
    [cell.lblContentSubLabel setFont: fontSubLabel];
    [cell.lblContentSubLabel setTextColor: UIColor.darkGrayColor];
    [cell.lblContentSubLabel setAlpha: 0.8];
    
    //Set Navigation Button Layout
    CGFloat btnY = (cell.viewContentView.frame.size.height - 122.0);
    [cell.btnNavigationButton setFrame: CGRectMake(40.0, btnY, (DEVICE_WIDTH - 112.0), 90.0)];
    [cell.btnNavigationButton setTag: indexPath.row];
    [cell.btnNavigationButton setClipsToBounds: YES];
    [[cell.btnNavigationButton layer] setCornerRadius: 30.0];
    NSDictionary *dicBtnAtt = @{ NSForegroundColorAttributeName : UIColor.whiteColor,
                             NSFontAttributeName : fontNavigationButton
                             };
    NSAttributedString *strBtnAtt = [[NSAttributedString alloc] initWithString: strNavigationButtonTitle attributes: dicBtnAtt];
    [cell.btnNavigationButton setAttributedTitle: strBtnAtt forState: UIControlStateNormal];
    
//    //Add Skip Button Click
//    [cell.btnSkipButton addTarget: self action: @selector(handleSkipButtonTappedEvent:) forControlEvents: UIControlEventTouchUpInside];
//
//    //Add Navigation Button Click
//    [cell.btnNavigationButton addTarget: self action: @selector(handleNavigationButtonTappedEvent:) forControlEvents: UIControlEventTouchUpInside];
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((DEVICE_WIDTH - 32.0), DEVICE_HEIGHT);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(-10.0, 0.0, 0.0, 0.0);
    
}




//MARK:- Button Events Methods

- (void) handleSkipButtonTappedEvent: (UIButton *) button {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    UIViewController *registerVC = [storyBoard instantiateViewControllerWithIdentifier: @"RegistrationViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: registerVC];
    [APP_DELEGATE.window setRootViewController: navController];
    [APP_DELEGATE.window makeKeyAndVisible];
    
    [[NSUserDefaults standardUserDefaults] setValue: @"0" forKey: kIS_FIRST_TIME];
    
}

- (void) handleNavigationButtonTappedEvent: (UIButton *) button {
    
    NSLog(@"%ld", (long)button.tag);
    
    if (button.tag == 0) {
        
        [_cvOnBoardingCollectionView scrollToItemAtIndexPath: [NSIndexPath indexPathForRow: 1 inSection: 0] atScrollPosition: UICollectionViewScrollPositionNone animated: YES];
        
    } else if (button.tag == 1) {
        
        [_cvOnBoardingCollectionView scrollToItemAtIndexPath: [NSIndexPath indexPathForRow: 2 inSection: 0] atScrollPosition: UICollectionViewScrollPositionNone animated: YES];
        
    } else if (button.tag == 2) {
        
        [_cvOnBoardingCollectionView scrollToItemAtIndexPath: [NSIndexPath indexPathForRow: 3 inSection: 0] atScrollPosition: UICollectionViewScrollPositionNone animated: YES];

    } else if (button.tag == 3) {
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
        UIViewController *registerVC = [storyBoard instantiateViewControllerWithIdentifier: @"RegistrationViewController"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: registerVC];
        [APP_DELEGATE.window setRootViewController: navController];
        [APP_DELEGATE.window makeKeyAndVisible];
        
        [[NSUserDefaults standardUserDefaults] setValue: @"0" forKey: kIS_FIRST_TIME];
        
    } else {}
    
}



- (IBAction)btnSkipButtonTapped:(UIButton *)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    UIViewController *registerVC = [storyBoard instantiateViewControllerWithIdentifier: @"RegistrationViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: registerVC];
    [APP_DELEGATE.window setRootViewController: navController];
    [APP_DELEGATE.window makeKeyAndVisible];

    [[NSUserDefaults standardUserDefaults] setValue: @"0" forKey: kIS_FIRST_TIME];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName: nNOTIFICATION_PERMISSION object: nil];
    
}

- (IBAction)btnNavigationButtonTapped: (UIButton *)sender {
    
    NSLog(@"%ld", (long)sender.tag);
    
    if (sender.tag == 0) {
        
        [_btnNavigationButton setTag: 1];
        [_cvOnBoardingCollectionView scrollToItemAtIndexPath: [NSIndexPath indexPathForRow: 1 inSection: 0] atScrollPosition: UICollectionViewScrollPositionNone animated: YES];
        
    } else if (sender.tag == 1) {
        
        [_btnNavigationButton setTag: 2];
        [_cvOnBoardingCollectionView scrollToItemAtIndexPath: [NSIndexPath indexPathForRow: 2 inSection: 0] atScrollPosition: UICollectionViewScrollPositionNone animated: YES];
        
    } else if (sender.tag == 2) {
        
        [_btnNavigationButton setTag: 3];
        [_cvOnBoardingCollectionView scrollToItemAtIndexPath: [NSIndexPath indexPathForRow: 3 inSection: 0] atScrollPosition: UICollectionViewScrollPositionNone animated: YES];
        
    } else if (sender.tag == 3) {
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
        UIViewController *registerVC = [storyBoard instantiateViewControllerWithIdentifier: @"RegistrationViewController"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: registerVC];
        [APP_DELEGATE.window setRootViewController: navController];
        [APP_DELEGATE.window makeKeyAndVisible];
        
        [[NSUserDefaults standardUserDefaults] setValue: @"0" forKey: kIS_FIRST_TIME];
        
        //[[NSNotificationCenter defaultCenter] postNotificationName: nNOTIFICATION_PERMISSION object: nil];
        
    } else {}
    
}


@end
