//
//  RankingViewController.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 05/09/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RankingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewSearch;
@property (weak, nonatomic) IBOutlet UIView *viewFriendRequest;
@property (weak, nonatomic) IBOutlet UIView *viewProMember;
@property (weak, nonatomic) IBOutlet UIView *viewAddDetail;
@property (weak, nonatomic) IBOutlet UIView *viewParentFriendRequest;
@property (weak, nonatomic) IBOutlet UIView *viewSearchFriend;
@property (weak, nonatomic) IBOutlet UIView *viewFriendRequestList;
@property (weak, nonatomic) IBOutlet UIView *viewMainRanking;

@property (weak, nonatomic) IBOutlet UITableView *tblSearchFriends;
@property (weak, nonatomic) IBOutlet UITableView *tblFriendRequests;

@property (weak, nonatomic) IBOutlet UIView *viewLoaderBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *viewLoaderContentView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrlViewSearch;

@property (weak, nonatomic) IBOutlet UILabel *lblGetMembership;
@property (weak, nonatomic) IBOutlet UILabel *lblAddMsg;
@property (weak, nonatomic) IBOutlet UILabel *lblIsNewRequest;
@property (weak, nonatomic) IBOutlet UILabel *msg1;
@property (weak, nonatomic) IBOutlet UILabel *msg2;
@property (weak, nonatomic) IBOutlet UILabel *msg3;

@property (weak, nonatomic) IBOutlet UIProgressView *progressFriends;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet UILabel *lblProgress;
@property (strong, nonatomic) IBOutlet UIView *vwProgress;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constGetMembershipBottom;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constLblAddMsgTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constLblAddMsgHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constLblProgressBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constLeftLblProgress;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constTblFriendsHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constVwYouCanTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constVwProMemberHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constVwProgressHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constVwProMemberRatio;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constVwFreeHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constAddDetailTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constVwFreeRight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constVwFreeLeft;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constVwNoFriendsYet;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constBtnCloseTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constBtnSearchCloseTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constImgGiftTop;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constTblSearchHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constHgtMainView;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet UIScrollView *scrFriendRequest;
@property (strong, nonatomic) IBOutlet UIScrollView *scrSearch;
@property (strong, nonatomic) IBOutlet UIView *viewParentSearch;
@property (strong, nonatomic) IBOutlet UIView *vwPro;
@property (strong, nonatomic) IBOutlet UIView *vwNoFriendsYet;
@property (strong, nonatomic) IBOutlet UIView *vwNewRequest;
@property (strong, nonatomic) IBOutlet UIButton *btnShare;

- (IBAction)btnCloseFriendRequestAction:(UIButton *)sender;
- (IBAction)btnNoFriendsShareAction:(UIButton *)sender;
- (void) showMainSearch;

@end

NS_ASSUME_NONNULL_END
