//
//  NewOnBoardingViewController.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 06/06/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "NewOnBoardingViewController.h"
#import "OnBoardingCVC.h"

@interface NewOnBoardingViewController () <UIScrollViewDelegate,UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    int Cnt;
    Boolean nextBtnFlag;
    
    NSMutableArray *arrCvcHeader;
    NSMutableArray *arrCvcTitle;
    NSMutableArray * arrCvcDes;
    CGFloat oldPos;
    BOOL isAnimated, isBtnAnimated;
}

@end

@implementation NewOnBoardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    oldPos = 0.0;
    isAnimated = NO;
    isBtnAnimated = NO;
    
    [_btnYes setHidden:YES];
    
    arrCvcHeader = [[NSMutableArray alloc] initWithObjects:@"the gym",@"the gym",@"home",@"home", nil];
    arrCvcTitle = [[NSMutableArray alloc] initWithObjects:@"Count your sets.",@"Time your rest.",@"Review your workout statistics.",@"Compete with your friends!", nil];
    arrCvcDes = [[NSMutableArray alloc] initWithObjects:@"We automatically count your\nsets and exercises to let you\nfocus 100% on your workouts.",@"Taking a precise rest time between\neach set has been proven to\ndrastically enhance results.",@"Effortlessly get clarity on your\nworkout habits with\nour insignful graphs.",@"Compare your workout routine with\nyour friends and show them\nwho's the boss.", nil];
    
    _cvcDetail.delegate = self;
    _cvcDetail.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:@"OnBoardingCVC" bundle:nil];
    [_cvcDetail registerNib:nib forCellWithReuseIdentifier:@"OnBoardingCVC"];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    [_cvcLeftCons setConstant: width];
    [self.constLblAtLeading setConstant:width];
    [self.constLblGymLeading setConstant:width];
    
    [self.scrView setUserInteractionEnabled:NO];
    
    Cnt = 0;
    nextBtnFlag = false;
    _cnstParentTopRoundCornerBottom.constant = -self.vwParentview.frame.size.height;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.9 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self->_cnstParentTopRoundCornerBottom.constant = 0.0;
            [[self view] layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
        
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self->_cvcLeftCons.constant = 0.0;
            self.constLblAtLeading.constant = 44.0;
            self.constLblGymLeading.constant = 44.0;
            [[self view] layoutIfNeeded];
        } completion:^(BOOL finished) {
            [[self scrView] setScrollEnabled:NO];
            [self.btnSkip setHidden:NO];
            [self.vwSkip setHidden:NO];
        }];
    });
    
    [self.vwProgress setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
        
    // Skip Button
    self.vwSkip.layer.cornerRadius = self.vwSkip.frame.size.height / 2;
    self.vwSkip.clipsToBounds = YES;
    [self.vwSkip setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setUpLayout];
    
    [self.btnSkip setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [_cvcDetail reloadData];
    [self startAnimating];
}

- (void)viewDidLayoutSubviews {
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: _vwTopRoundedCorner.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){40.0, 40.0}].CGPath;
    
    _vwTopRoundedCorner.layer.mask = maskLayer;
}

// MARK:- Collection view delegate and datasource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_cvcDetail.frame.size.width, _cvcDetail.frame.size.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OnBoardingCVC *onBoardingCell = [_cvcDetail dequeueReusableCellWithReuseIdentifier:@"OnBoardingCVC" forIndexPath:indexPath];
    onBoardingCell.lblTitleLabel.text = arrCvcTitle[indexPath.row];
    onBoardingCell.lblDescription.text = arrCvcDes[indexPath.row];
    onBoardingCell.btnNext.layer.cornerRadius = 20;
    onBoardingCell.btnNext.clipsToBounds = YES;
    
    // Next button Action
    [onBoardingCell.btnNext addTarget:self action:@selector(btnNextAction) forControlEvents:UIControlEventTouchUpInside];
    
    if (IS_IPHONE5s) {
        onBoardingCell.constBtnNextBottom.constant = 8;
        onBoardingCell.constPageControlBottom.constant = 4;
    }
    
    if (IS_IPHONEXR) {
        _constPageControlBottom.constant = 8;
    } else if (IS_IPHONEX) {
        _constPageControlBottom.constant = 8;
    } else if (IS_IPHONE8PLUS) {
        _constPageControlBottom.constant = 8;
    } else if (IS_IPHONE8) {
        _constPageControlBottom.constant = 8;
    } else {
        _constPageControlBottom.constant = 4;
    }
    
    if(!isBtnAnimated){
        [onBoardingCell.btnNext setHidden:NO];
        [onBoardingCell.pageControl setHidden:NO];
    }else{
        [onBoardingCell.btnNext setHidden:YES];
        [onBoardingCell.pageControl setHidden:YES];
    }
    
    if(indexPath.row == 1){
        
        [onBoardingCell.vwLoader setHidden:NO];
        [onBoardingCell.imgIcon setHidden:NO];
        
    }else{
        [onBoardingCell.vwLoader setHidden:YES];
        [onBoardingCell.imgIcon setHidden:NO];

    }
    
    return onBoardingCell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [_pageControl setCurrentPage:indexPath.row];
    
    OnBoardingCVC *cell1 = (OnBoardingCVC *)cell;
    if (indexPath.row == 0) {
        [cell1.imgIcon setImage:[UIImage imageNamed:@"iconGreenExercise"]];
        
        cell1.lblTitleLabel.textColor = [UIColor colorWithDisplayP3Red:18.0/255.0 green:210.0/255.0 blue:111.0/255.0 alpha:1.0];
        cell1.lblGym2.textColor = [UIColor colorWithDisplayP3Red:52.0/255.0 green:132.0/255.0 blue:90.0/255.0 alpha:1.0];
        cell1.lblGym2.text = @"";
        [cell1.lblGym2 setHidden:YES];
        [cell1.pageControl setCurrentPage:0];
    } else if(indexPath.row == 1) {
        //[cell1.imgIcon setImage:[UIImage imageNamed:@"iconRedExercise"]];
        if(isAnimated){
            UIImage * toImage = [UIImage imageNamed:@"iconGreenExercise"];
            UIImage * toImage1 = [UIImage imageNamed:@"Ranking1"];
            [cell1.imgIcon setImage:toImage];
            self.imgScene2.image = toImage1;
            
            [cell1.imgIcon setHidden:NO];
            [cell1.vwLoader setHidden:YES];
            
            [self.btnSkip setTitleColor:[UIColor colorWithRed: 5.0/255.0 green: 83.0/255.0 blue: 40.0/255.0 alpha: 1.0] forState:UIControlStateNormal];
            self->_lblAt2.textColor = [UIColor colorWithDisplayP3Red:52.0/255.0 green:132.0/255.0 blue:90.0/255.0 alpha:1.0];
            self.lblGym2.textColor = [UIColor colorWithDisplayP3Red:52.0/255.0 green:132.0/255.0 blue:90.0/255.0 alpha:1.0];
            
            cell1.lblTitleLabel.textColor = [UIColor colorWithDisplayP3Red:18.0/255.0 green:210.0/255.0 blue:111.0/255.0 alpha:1.0];
            
            self.lblGym2.text = @"the gym";
        }
        else{
            [cell1.imgIcon setHidden:YES];
            cell1.lblTitleLabel.textColor = [UIColor colorWithRed:227.0/255.0 green:21.0/255.0 blue:24.0/255.0 alpha:1.0];
            cell1.lblGym2.textColor = [UIColor colorWithRed:135.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1.0];
            cell1.lblGym2.text = @"";
            [cell1.lblGym2 setHidden:YES];
            [cell1.pageControl setCurrentPage:1];
            
            [cell1.vwProgress setTransform: CGAffineTransformMakeScale(-1.0, 1.0)];
        }
    } else if (indexPath.row == 2) {
        [cell1.imgIcon setImage:[UIImage imageNamed:@"iconStatistics"]];
        cell1.lblTitleLabel.textColor = [UIColor colorWithRed:31.0/255.0 green:31.0/255.0 blue:31.0/255.0 alpha:1.0];
        cell1.lblGym2.textColor = [UIColor colorWithDisplayP3Red:52.0/255.0 green:132.0/255.0 blue:90.0/255.0 alpha:1.0];
        cell1.lblGym2.text = @"home";
        [cell1.lblGym2 setHidden:YES];
        [cell1.pageControl setCurrentPage:2];
    } else if(indexPath.row == 3) {
        [cell1.imgIcon setImage:[UIImage imageNamed:@"iconGroup"]];
        cell1.lblTitleLabel.textColor = [UIColor colorWithRed:31.0/255.0 green:31.0/255.0 blue:31.0/255.0 alpha:1.0];
        cell1.lblGym2.textColor = [UIColor colorWithDisplayP3Red:52.0/255.0 green:132.0/255.0 blue:90.0/255.0 alpha:1.0];
        [cell1.lblGym2 setHidden:YES];
        [cell1.pageControl setCurrentPage:3];
    }
}

//MARK:- IBActions

- (IBAction)btnSkipAction:(UIButton *)sender {
    [self navigateToLogin];
}

- (IBAction)btnYesAction:(UIButton *)sender {
    
    [self btnNextAction];
    
    /*
    CGFloat x = _cvcDetail.contentOffset.x;
    CGFloat row = x / [UIScreen mainScreen].bounds.size.width;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow: row+1 inSection:0] ;
    
    if (x / [UIScreen mainScreen].bounds.size.width == 3) {
        [self navigateToLogin];
    } else {
        [_cvcDetail scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        [self btnNextSwipe:row+1];
    }
     */
}

- (void)btnNextAction {
    CGFloat x = _cvcDetail.contentOffset.x;
    CGFloat row = x / [UIScreen mainScreen].bounds.size.width;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow: row+1 inSection:0] ;
    
    if (x / [UIScreen mainScreen].bounds.size.width == 3) {
        [self navigateToLogin];
    } else {
        [_cvcDetail scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        [self btnNextSwipe:row+1];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollViewDidEndDecelerating:self->_scrView];

    });
}

//MARK:- Custom Methods

- (void)setUpLayout {
    if (IS_IPHONEXR) {
    } else if (IS_IPHONEX) {
    } else if (IS_IPHONE8PLUS) {
        self.constVwProgressTop.constant = 85;
        
        // Top Text
        _constAt2Top.constant = 60;
        _constAt3Top.constant = 60;
        _constAt4Top.constant = 60;
        _constAt5Top.constant = 60;
        
        // Background image
        _scene2TopConstraint.constant = 70;
        _scene3TopConstraint.constant = 70;
        _scene4TopConstraint.constant = 70;
        _scene5TopConstraint.constant = 70;
        
        //Get Current Page
        int page = _scrView.contentOffset.x / _scrView.frame.size.width;
        
        if (page == 1) {
        }
        
        _nextBtnBottomConstraint.constant = 50;
        _nextBtnHeightConstraint.constant = 80;
        _pageControlBottomConstraint.constant = 11;

    } else if (IS_IPHONE8) {
        // Set Top Label Font
        UIFont *atFont = [UIFont fontWithName:fFUTURA_CONDENSED_EXTRA_BOLD size:45.0];
        UIFont *gymFont = [UIFont fontWithName:fFUTURA_CONDENSED_EXTRA_BOLD size:75.0];
        
        [self.lblAt2 setFont:atFont];
        [self.lblAt3 setFont:atFont];
        [self.lblAt4 setFont:atFont];
        [self.lblAt5 setFont:atFont];
        
        [self.lblGym2 setFont:gymFont];
        [self.lblGym3 setFont:gymFont];
        [self.lblHome setFont:gymFont];
        [self.lblHome4 setFont:gymFont];
        [self.lblHome5 setFont:gymFont];
        
        self.constVwProgressTop.constant = 70;
        
        // Top Text
        self.constAt2Top.constant = 60;
        self.constAt3Top.constant = 60;
        self.constAt4Top.constant = 60;
        self.constAt5Top.constant = 60;
        
        // Background image
        self.scene2TopConstraint.constant = 70;
        self.scene3TopConstraint.constant = 70;
        self.scene4TopConstraint.constant = 70;
        self.scene5TopConstraint.constant = 70;
        
        // How to use height
        self.howToUseHeight.constant = 115;
        
        //Get Current Page
        int page = _scrView.contentOffset.x / _scrView.frame.size.width;
        
        if (page == 1) {
        }
        
        _nextBtnBottomConstraint.constant = 50;
        _nextBtnHeightConstraint.constant = 80;
        _pageControlBottomConstraint.constant = 0;

        
    } else {
        
        // Set Top Label Font
        UIFont *atFont = [UIFont fontWithName:fFUTURA_CONDENSED_EXTRA_BOLD size:35.0];
        UIFont *gymFont = [UIFont fontWithName:fFUTURA_CONDENSED_EXTRA_BOLD size:65.0];
        
        [self.lblAt2 setFont:atFont];
        [self.lblAt3 setFont:atFont];
        [self.lblAt4 setFont:atFont];
        [self.lblAt5 setFont:atFont];
        
        [self.lblGym2 setFont:gymFont];
        [self.lblGym3 setFont:gymFont];
        [self.lblHome setFont:gymFont];
        [self.lblHome4 setFont:gymFont];
        [self.lblHome5 setFont:gymFont];
        
        self.constVwProgressTop.constant = 70;
        self.constDumbelWidth.constant = 75;
        self.constDumbelHeight.constant = 35;
        
        // Top Text
        self.constAt2Top.constant = 60;
        self.constAt3Top.constant = 60;
        self.constAt4Top.constant = 60;
        self.constAt5Top.constant = 60;
        
        // Background image
        self.scene2TopConstraint.constant = 70;
        self.scene3TopConstraint.constant = 70;
        self.scene4TopConstraint.constant = 70;
        self.scene5TopConstraint.constant = 70;
        
        // How to use height
        self.howToUseHeight.constant = 80;
        
        // Progress view height & width
        self.progressHeight.constant = 140;
        self.progressWidth.constant = 140;
        
        //Get Current Page
        _nextBtnBottomConstraint.constant = 8;
        _nextBtnHeightConstraint.constant = 60;
        _pageControlBottomConstraint.constant = 11;

    }
    
    self.lblHome.textColor = [UIColor colorWithDisplayP3Red:52.0/255.0 green:132.0/255.0 blue:90.0/255.0 alpha:1.0];
    self.constLblHomeLeading.constant = ([UIScreen mainScreen].bounds.size.width * 2) + 44;
}

- (void)startAnimating {
    //Dinal 4.0
    
    [UIView animateWithDuration: 2.5 animations:^{
        [self.vwProgress setValue:0.0];
    } completion:^(BOOL finished) {
        [self.scrView setUserInteractionEnabled:YES];
        [self.vwProgress setValue:0.0];
        CGRect frame = self.scrView.frame;
        
        //If your scroll is horizonal
        frame.origin.x = frame.size.width * 1;
        frame.origin.y = 0;
        
        [UIView animateWithDuration:0 delay:0.0 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
            [self.scrView scrollRectToVisible:frame animated:NO];
        } completion:^(BOOL finished) {
            self.vwProgress.value = 100.0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self->_btnYes setHidden:NO];
                [self->_pageControl setHidden:NO];
                self->isBtnAnimated = YES;
                [self->_cvcDetail reloadData];
            });
            //            [self.scrView setUserInteractionEnabled:YES];
        }];
    }];
}

- (void)navigateToLogin {
    
    [_btnYes setHidden:YES];
    [self.btnSkip setHidden:YES];
    [self.vwSkip setHidden:YES];
    [self.lblGym2 setHidden:YES];
    [self.lblAt2 setHidden:YES];
    [self.lblHome setHidden:YES];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    [_cvcLeftCons setConstant: width];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    UIViewController *registerVC = [storyBoard instantiateViewControllerWithIdentifier: @"LoginOptionViewController"];
    
    UIView *snapShot = [APP_DELEGATE.window snapshotViewAfterScreenUpdates:YES];
    UIView *snap = [registerVC.view snapshotViewAfterScreenUpdates:YES];
    snap.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:snapShot];
    [self.view addSubview:snap];

    [UIView animateWithDuration:0.6 animations:^{
//        snapShot.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        snap.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

    } completion:^(BOOL finished) {
        [self.navigationController pushViewController:registerVC animated:NO];
        [snapShot removeFromSuperview];
        [snap removeFromSuperview];
    }];
    
    //    [[NSUserDefaults standardUserDefaults] setValue: @"0" forKey: kIS_FIRST_TIME];
}

- (void)changeRootViewController:(UIViewController*)viewController {
    
    if (!APP_DELEGATE.window.rootViewController) {
        APP_DELEGATE.window.rootViewController = viewController;
        return;
    }
    
    UIView *snapShot = [APP_DELEGATE.window snapshotViewAfterScreenUpdates:YES];
    [viewController.view addSubview:snapShot];
    
    APP_DELEGATE.window.rootViewController = viewController;
    
    viewController.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [UIView animateWithDuration:1.0 animations:^{
        snapShot.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        [snapShot removeFromSuperview];
    }];
}

- (void)setProgressValue {
    if (self.vwProgress.value < 1) {
        self.vwProgress.value = 100.0;
    }
}

//MARK:- UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x = self.cvcDetail.contentOffset.x;
    CGFloat pos = x / [UIScreen mainScreen].bounds.size.width;
    
    if (self.cvcDetail.contentOffset.x > [UIScreen mainScreen].bounds.size.width) {
        self.constLblGymLeading.constant = ([UIScreen mainScreen].bounds.size.width - self.cvcDetail.contentOffset.x) + 44;
    }
    
    if (self.cvcDetail.contentOffset.x > ([UIScreen mainScreen].bounds.size.width)) {
        
        self.constLblHomeLeading.constant = ([UIScreen mainScreen].bounds.size.width - self.cvcDetail.contentOffset.x) + ([UIScreen mainScreen].bounds.size.width + 44);
        if (pos > 2.0) {
            self.constLblHomeLeading.constant = 44;
        }
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //    int page = _scrView.contentOffset.x / _scrView.frame.size.width;
    //    if (page == 0) {
    //        [self startAnimating];
    //    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
        
    CGFloat x = _cvcDetail.contentOffset.x;
    CGFloat pos = x / [UIScreen mainScreen].bounds.size.width;
    self->oldPos = pos;

    if (pos == 0) {
        UIImage * toImage = [UIImage imageNamed:@"Ranking1"];
        [UIView transitionWithView:self.imgScene2
                          duration:0.5f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
            [self.btnSkip setTitleColor:[UIColor colorWithRed: 5.0/255.0 green: 83.0/255.0 blue: 40.0/255.0 alpha: 1.0] forState:UIControlStateNormal];
            self->_lblAt2.textColor = [UIColor colorWithDisplayP3Red:52.0/255.0 green:132.0/255.0 blue:90.0/255.0 alpha:1.0];
            self.lblGym2.textColor = [UIColor colorWithDisplayP3Red:52.0/255.0 green:132.0/255.0 blue:90.0/255.0 alpha:1.0];
            self.lblGym2.text = @"the gym";
            self.imgScene2.image = toImage;
        } completion:^(BOOL finished) {
        }];
        
    }  else if (pos == 1) {
  
        if(!isAnimated)
        {
            isAnimated = YES;
            
            UIImage *toImage = [UIImage imageNamed:@"Rest Screen"];
                    [UIView transitionWithView:self.imgScene2
                                      duration:0.5f
                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                    animations:^{
                        [self.btnSkip setTitleColor:[UIColor colorWithRed: 98.0/255.0 green: 8.0/255.0 blue: 7.0/255.0 alpha: 1.0] forState:UIControlStateNormal];
                        self->_lblAt2.textColor = [UIColor colorWithRed:135.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1.0];
                        self.lblGym2.textColor = [UIColor colorWithRed:135.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1.0];
                        self.lblGym2.text = @"the gym";
                        self.imgScene2.image = toImage;
                        
                    } completion:^(BOOL finished) {
                        
            //            self.lblGym2.text = @"";
            //            OnBoardingCVC *cell = (OnBoardingCVC *)[self->_cvcDetail cellForItemAtIndexPath:[NSIndexPath indexPathForItem:pos inSection:0]];
            //            cell.lblGym2.text = @"the gym";
                        
                    }];
            
            OnBoardingCVC *cell = (OnBoardingCVC *)[self->_cvcDetail cellForItemAtIndexPath:[NSIndexPath indexPathForItem:pos inSection:0]];
            [cell.vwProgress setValue:100.0];
              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration: 2.0 animations:^{
                    [cell.vwProgress setValue:0.0];
                } completion:^(BOOL finished) {
//                    [cell.vwProgress setValue:0.0];
                    
                    [UIView transitionWithView:self.imgScene2
                                      duration:0.5f
                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                    animations:^{
                        self.imgScene2.image = [UIImage imageNamed:@"Ranking1"];
                    } completion:^(BOOL finished) {
                        
                    }];
                    
                    UIImage * toImage = [UIImage imageNamed:@"iconGreenExercise"];
                    UIImage * toImage1 = [UIImage imageNamed:@"Ranking1"];
                    [cell.imgIcon setImage:toImage];
                    self.imgScene2.image = toImage1;
                    
                    [cell.imgIcon setHidden:NO];
                    [cell.vwLoader setHidden:YES];
                    
                    [self.btnSkip setTitleColor:[UIColor colorWithRed: 5.0/255.0 green: 83.0/255.0 blue: 40.0/255.0 alpha: 1.0] forState:UIControlStateNormal];
                    self->_lblAt2.textColor = [UIColor colorWithDisplayP3Red:52.0/255.0 green:132.0/255.0 blue:90.0/255.0 alpha:1.0];
                    self.lblGym2.textColor = [UIColor colorWithDisplayP3Red:52.0/255.0 green:132.0/255.0 blue:90.0/255.0 alpha:1.0];
                    
                    cell.lblTitleLabel.textColor = [UIColor colorWithDisplayP3Red:18.0/255.0 green:210.0/255.0 blue:111.0/255.0 alpha:1.0];
                    
                    
//                    CGFloat x = self->_cvcDetail.contentOffset.x;
//                    CGFloat row = x / [UIScreen mainScreen].bounds.size.width;
//                    NSIndexPath *indexpath = [NSIndexPath indexPathForRow: row+1 inSection:0] ;
//
//                    if (x / [UIScreen mainScreen].bounds.size.width == 3) {
//                        [self navigateToLogin];
//                    } else {
//                        [self->_cvcDetail scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
//                        [self btnNextSwipe:row+1];
//                    }
//
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [self scrollViewDidEndDecelerating:self->_scrView];
//
//                    });
                    
                }];
            });
        }
    } else if (pos == 2) {
        UIImage * toImage = [UIImage imageNamed:@"Ranking1"];
        [UIView transitionWithView:self.imgScene2
                          duration:0.5f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
            [self.btnSkip setTitleColor:[UIColor colorWithRed: 5.0/255.0 green: 83.0/255.0 blue: 40.0/255.0 alpha: 1.0] forState:UIControlStateNormal];
            self->_lblAt2.textColor = [UIColor colorWithDisplayP3Red:52.0/255.0 green:132.0/255.0 blue:90.0/255.0 alpha:1.0];
            self.lblGym2.textColor = [UIColor colorWithDisplayP3Red:52.0/255.0 green:132.0/255.0 blue:90.0/255.0 alpha:1.0];
            self.lblGym2.text = @"home";
            self.imgScene2.image = toImage;
            
//            OnBoardingCVC *cell = (OnBoardingCVC *)[self->_cvcDetail cellForItemAtIndexPath:[NSIndexPath indexPathForItem:pos inSection:0]];
//            cell.lblGym2.text = @"home";

            
        } completion:^(BOOL finished) {
            
//            self.lblGym2.text = @"home";
//
//            OnBoardingCVC *cell = (OnBoardingCVC *)[self->_cvcDetail cellForItemAtIndexPath:[NSIndexPath indexPathForItem:pos inSection:0]];
//            cell.lblGym2.text = @"";

            
        }];
        
    } else if (pos == 3) {
        UIImage * toImage = [UIImage imageNamed:@"Ranking1"];
        [UIView transitionWithView:self.imgScene2
                          duration:0.5f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
            [self.btnSkip setTitleColor:[UIColor colorWithRed: 5.0/255.0 green: 83.0/255.0 blue: 40.0/255.0 alpha: 1.0] forState:UIControlStateNormal];
            self->_lblAt2.textColor = [UIColor colorWithDisplayP3Red:52.0/255.0 green:132.0/255.0 blue:90.0/255.0 alpha:1.0];
            self.lblGym2.textColor = [UIColor colorWithDisplayP3Red:52.0/255.0 green:132.0/255.0 blue:90.0/255.0 alpha:1.0];
            self.lblGym2.text = @"home";
            self.imgScene2.image = toImage;
        } completion:^(BOOL finished) {
            
        }];
    }
  
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//    CGFloat x = _cvcDetail.contentOffset.x;
//    CGFloat pos = x / [UIScreen mainScreen].bounds.size.width;
//
//    if(pos>oldPos){
//        NSLog(@"DINAL - R");
//
//        if (pos == 0) {
//
//           self.lblGym2.text = @"the gym";
//           self.lblGym2.textColor = [UIColor colorWithRed:135.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1.0];
//
//           OnBoardingCVC *onBoardingCell = (OnBoardingCVC *)[self->_cvcDetail cellForItemAtIndexPath:[NSIndexPath indexPathForItem:pos inSection:0]];
//           onBoardingCell.lblGym2.text = @"";
//
//
//        }  else if (pos == 1) {
//
//            self.lblGym2.text = @"";
//            self.lblGym2.textColor = [UIColor colorWithRed:135.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1.0];
//
//            OnBoardingCVC *onBoardingCell = (OnBoardingCVC *)[self->_cvcDetail cellForItemAtIndexPath:[NSIndexPath indexPathForItem:pos inSection:0]];
//            onBoardingCell.lblGym2.text = @"home";
//
//
//        } else if (pos == 2) {
//
//            self.lblGym2.text = @"home";
//            self.lblGym2.textColor = [UIColor colorWithRed:135.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1.0];
//
//            OnBoardingCVC *onBoardingCell = (OnBoardingCVC *)[self->_cvcDetail cellForItemAtIndexPath:[NSIndexPath indexPathForItem:pos inSection:0]];
//            onBoardingCell.lblGym2.text = @"";
//
//
//        } else if (pos == 3) {
//
//            self.lblGym2.text = @"home";
//            self.lblGym2.textColor = [UIColor colorWithRed:135.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1.0];
//
//            OnBoardingCVC *onBoardingCell = (OnBoardingCVC *)[self->_cvcDetail cellForItemAtIndexPath:[NSIndexPath indexPathForItem:pos inSection:0]];
//            onBoardingCell.lblGym2.text = @"";
//        }
//
//    }else{
//        NSLog(@"DINAL - L");
//
//        if (pos == 0) {
//
//            self.lblGym2.text = @"the gym";
//            self.lblGym2.textColor = [UIColor colorWithRed:135.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1.0];
//
//            OnBoardingCVC *onBoardingCell = (OnBoardingCVC *)[self->_cvcDetail cellForItemAtIndexPath:[NSIndexPath indexPathForItem:pos inSection:0]];
//            onBoardingCell.lblGym2.text = @"";
//
//        }  else if (pos == 1) {
//
//            self.lblGym2.text = @"the gym";
//            self.lblGym2.textColor = [UIColor colorWithRed:135.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1.0];
//
//            OnBoardingCVC *onBoardingCell = (OnBoardingCVC *)[self->_cvcDetail cellForItemAtIndexPath:[NSIndexPath indexPathForItem:pos inSection:0]];
//            onBoardingCell.lblGym2.text = @"";
//
//
//        } else if (pos == 2) {
//
//            self.lblGym2.text = @"";
//            self.lblGym2.textColor = [UIColor colorWithRed:135.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1.0];
//
//            OnBoardingCVC *onBoardingCell = (OnBoardingCVC *)[self->_cvcDetail cellForItemAtIndexPath:[NSIndexPath indexPathForItem:pos inSection:0]];
//            onBoardingCell.lblGym2.text = @"the gym";
//
//
//        } else if (pos == 3) {
//
//            self.lblGym2.text = @"home";
//            self.lblGym2.textColor = [UIColor colorWithRed:135.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1.0];
//
//            OnBoardingCVC *onBoardingCell = (OnBoardingCVC *)[self->_cvcDetail cellForItemAtIndexPath:[NSIndexPath indexPathForItem:pos inSection:0]];
//            onBoardingCell.lblGym2.text = @"";
//
//        }
//
//    }
//}


- (void)btnNextSwipe:(int)x {
    if (x == 1) {
        
//        UIImage * toImage = [UIImage imageNamed:@"Rest Screen"];
//        [UIView transitionWithView:self.imgScene2
//                          duration:0.5f
//                           options:UIViewAnimationOptionTransitionCrossDissolve
//                        animations:^{
//            [self.btnSkip setTitleColor:[UIColor colorWithRed: 98.0/255.0 green: 8.0/255.0 blue: 7.0/255.0 alpha: 1.0] forState:UIControlStateNormal];
//            self->_lblAt2.textColor = [UIColor colorWithRed:135.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1.0];
//            self.lblGym2.textColor = [UIColor colorWithRed:135.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1.0];
//            self.imgScene2.image = toImage;
//        } completion:^(BOOL finished) {
//
//        }];
        
    } else if ( x == 0 || x == 2 || x == 3) {
        
        UIImage * toImage = [UIImage imageNamed:@"Ranking1"];
        [UIView transitionWithView:self.imgScene2
                          duration:0.5f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
            [self.btnSkip setTitleColor:[UIColor colorWithRed: 5.0/255.0 green: 83.0/255.0 blue: 40.0/255.0 alpha: 1.0] forState:UIControlStateNormal];
            self->_lblAt2.textColor = [UIColor colorWithDisplayP3Red:52.0/255.0 green:132.0/255.0 blue:90.0/255.0 alpha:1.0];
            self.lblGym2.textColor = [UIColor colorWithDisplayP3Red:52.0/255.0 green:132.0/255.0 blue:90.0/255.0 alpha:1.0];
            self.imgScene2.image = toImage;
        } completion:^(BOOL finished) {
        }];
    }
}

@end
