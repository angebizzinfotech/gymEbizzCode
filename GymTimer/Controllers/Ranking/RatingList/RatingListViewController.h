//
//  RatingListViewController.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 09/09/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankingViewController.h"
#import "CommonImports.h"

NS_ASSUME_NONNULL_BEGIN

@interface RatingListViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *vwAddFriends;
@property (strong, nonatomic) IBOutlet UIView *vwTopRanking;
@property (strong, nonatomic) IBOutlet UIButton *btnAddFriends;
@property (strong, nonatomic) IBOutlet UITableView *tblRanking;
@property (strong, nonatomic) IBOutlet UIView *vwWorkoutProgress;
@property (strong, nonatomic) IBOutlet UICollectionView *workoutCollection;

@property (weak, nonatomic) IBOutlet UIView *viewLoaderBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *viewLoaderContentView;

@property (strong, nonatomic) IBOutlet UICountingLabel *lblNoOfWorkout;
- (IBAction)btnShowAddFriends:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblRanking;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vwTopHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vwAddFriendTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vwAddFriendLeading;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblRankingLeading;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vwWorkoutProgressTrailing;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vwWorkoutProgressLeading;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vwRankingHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblNoOfWorkoutTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vwTblRankingHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *noOfWorkoutTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgTopTriangleBottom;
@property (strong, nonatomic) IBOutlet UIView *vwRanking;
@property (strong, nonatomic) IBOutlet UIView *vwTop;
@property (strong, nonatomic) IBOutlet UIScrollView *scrView;

@property (strong, nonatomic) IBOutlet UIButton *btnHiddenMode;
@property (strong, nonatomic) IBOutlet UILabel *lblHiddenMode;
@property (strong, nonatomic) IBOutlet UILabel *lblHiddenModeTitle;
@property (strong, nonatomic) IBOutlet UIView *vwHiddenMode;

@property (strong, nonatomic) RankingViewController *parent;
@property (strong, nonatomic) NSMutableDictionary *dicRankCell;

@property (strong, nonatomic) IBOutlet UILabel *lblDes;
@property (strong, nonatomic) IBOutlet UIView *vwNewRequest;

@end

NS_ASSUME_NONNULL_END
