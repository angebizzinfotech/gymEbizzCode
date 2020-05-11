//
//  UpgradeToProVC.m
//  GymTimer
//
//  Created by EbitNHP-i1 on 11/12/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import "UpgradeToProVC.h"
@import StoreKit;

@interface UpgradeToProVC () <UICollectionViewDelegate, UICollectionViewDataSource, SKProductsRequestDelegate, SKPaymentTransactionObserver, UIScrollViewDelegate> {
    UIActivityIndicatorView *spinner;
    int scrollIndex, displayTime;
    BOOL isPriceAnimation;
    NSString *selectedItem;
}

@end

@implementation UpgradeToProVC

// MARK:- View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(_isStats)
    {
        [self.tabBarController.tabBar setHidden: true];
    }
    
    [self initialization];
    [self setupLayout];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.scrView flashScrollIndicators];
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([self.scrollTimer isValid]) {
        [self.scrollTimer invalidate];
        self.scrollTimer = nil;
    }
}

// MARK:- Custom Method

- (void)initialization {
    selectedItem = @"";
    isPriceAnimation = YES;
    
    scrollIndex = 1;
    displayTime = 0;
    
    // Setting radius
    dispatch_async(dispatch_get_main_queue(), ^{
        self.constVwGrayWidth.constant = self.vwProgress.frame.size.width / 2;
    });
    
    // Setup counting label
    [self.lblDollar58 setFormat:@"$%d"];
    [self.lblDollar2 setFormat:@"$%d"];
        
    // Register CollectionView Cell
    UINib *skillLevelNib = [UINib nibWithNibName:@"YourSkillLevelCell" bundle:nil];
    [self.clvCards registerNib:skillLevelNib forCellWithReuseIdentifier:@"YourSkillLevelCell"];
    
    UINib *insightNib = [UINib nibWithNibName:@"insightClvCell" bundle:nil];
    [self.clvCards registerNib:insightNib forCellWithReuseIdentifier:@"insightClvCell"];
    
    UINib *calendarNib = [UINib nibWithNibName:@"WorkoutCalendarCell" bundle:nil];
    [self.clvCards registerNib:calendarNib forCellWithReuseIdentifier:@"WorkoutCalendarCell"];
    
    UINib *averageWorkoutNib = [UINib nibWithNibName:@"AverageWorkoutCell" bundle:nil];
    [self.clvCards registerNib:averageWorkoutNib forCellWithReuseIdentifier:@"AverageWorkoutCell"];
    
    UINib *timeOfDayNib = [UINib nibWithNibName:@"TimeOfDayClvCell" bundle:nil];
    [self.clvCards registerNib:timeOfDayNib forCellWithReuseIdentifier:@"TimeOfDayClvCell"];
    
    UINib *dayOfWeekNib = [UINib nibWithNibName:@"DayOfWeekClvCell" bundle:nil];
    [self.clvCards registerNib:dayOfWeekNib forCellWithReuseIdentifier:@"DayOfWeekClvCell"];
    
    // Remove Existing Observer and Add New
    [NSNotificationCenter.defaultCenter removeObserver:PerformNavigation];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(performNavigation) name:PerformNavigation object:nil];
}

- (void)setupLayout {
    // Adjust ScrollView Inset
    if (@available(iOS 11.0, *)) {
        [self.scrView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
        
    // CollectionView Layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(DEVICE_WIDTH, 400);
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = 0.0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.clvCards.collectionViewLayout = layout;
    
    // Set Radius To View
    self.vwMonth.layer.cornerRadius = 8;
    self.vwYear.layer.cornerRadius = 8;
    self.vwPopular.layer.cornerRadius = 4;
    self.vwPro.layer.cornerRadius = 8;
    
    self.vwProgress.layer.cornerRadius = self.vwProgress.frame.size.height / 2;
    self.vwGrayProgress.layer.cornerRadius = self.vwGrayProgress.frame.size.height / 2;
    self.vwGreenProgress.layer.cornerRadius = self.vwGreenProgress.frame.size.height / 2;
        
    // Set Shadow
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIBezierPath *enduranceShadow = [UIBezierPath bezierPathWithRoundedRect:[self.vwPopular bounds] cornerRadius:4];
        [[self.vwPopular layer] setMasksToBounds: NO];
        [[self.vwPopular layer] setShadowColor: [[UIColor blackColor] CGColor]];
        [[self.vwPopular layer] setShadowOffset: CGSizeMake(0, 2)];
        [[self.vwPopular layer] setShadowRadius: 5.0];
        [[self.vwPopular layer] setShadowOpacity: 0.2];
        [self.vwPopular.layer setRasterizationScale:[UIScreen.mainScreen scale]];
        [[self.vwPopular layer] setShadowPath: [enduranceShadow CGPath]];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIBezierPath *enduranceShadow = [UIBezierPath bezierPathWithRoundedRect:[self.vwPro bounds] cornerRadius:8];
        [[self.vwPro layer] setMasksToBounds: NO];
        [[self.vwPro layer] setShadowColor: [[UIColor blackColor] CGColor]];
        [[self.vwPro layer] setShadowOffset: CGSizeMake(0, 2)];
        [[self.vwPro layer] setShadowRadius: 5.0];
        [[self.vwPro layer] setShadowOpacity: 0.2];
        [self.vwPro.layer setRasterizationScale:[UIScreen.mainScreen scale]];
        [[self.vwPro layer] setShadowPath: [enduranceShadow CGPath]];
    });
        
    [self.scrollTimer invalidate];
    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performScrolling) userInfo:nil repeats:YES];
}

- (void)performScrolling {
    displayTime += 1;
    
    // Manage scroll index
    if (scrollIndex == 6) {
        scrollIndex = 0;
    }
        
    // Scroll Cards on every 3 seconds
    if (displayTime == 3) {
        displayTime = 0;
        
        [self.clvCards scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self->scrollIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone
        animated:YES];
        
        self->scrollIndex += 1;
    }
    
    // Manage display time
    if (displayTime > 3) {
        displayTime = 0;
    }
}

- (void)performNavigation {
    
    if ([self.isFromSetting isEqualToString:@"Yes"]) {
        [self.navigationController popViewControllerAnimated:YES];
        // For SettingVC
        [[NSNotificationCenter defaultCenter] postNotificationName:ChangeSelectedTab object:nil];
    } else {
        // For StatsVC
        [[NSNotificationCenter defaultCenter] postNotificationName:SelectTab object:nil];
    }
}

// MARK:- IBActions
- (IBAction)monthAction:(UIButton *)sender {
    if ([Utils isConnectedToInternet]) {
        selectedItem = @"Month";
        
        for (UIView* view in self.vwMonth.subviews)
            [view setHidden: true];
        
        spinner = [Utils showActivityIndicatorInView: self.vwMonth];
        [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        spinner.color = [UIColor whiteColor];
        
        [self inAppPurchaseWithProductId:kProductIdForOneMonth];
    }
}

- (IBAction)yearAction:(UIButton *)sender {
    if ([Utils isConnectedToInternet]) {
        selectedItem = @"Year";
        
        for (UIView* view in self.vwYear.subviews)
            [view setHidden: true];
        
        spinner = [Utils showActivityIndicatorInView: self.vwYear];
        [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        spinner.color = [UIColor whiteColor];
        
        [self inAppPurchaseWithProductId:kProductIdForOneYear];
    } 
}

- (IBAction)termsOfUseAction:(UIButton *)sender {
    TermsOfUseViewController *termsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsOfUseViewController"];
    [self.navigationController pushViewController:termsVC animated:YES];
}

- (IBAction)closeAction:(UIButton *)sender {
    if (self.tabBarController.selectedIndex == 2) {
        [self.tabBarController.tabBar setHidden: false];
        [self.tabBarController setSelectedIndex: 0];
//        [self.tabBarController.viewControllers[0] viewDidLoad];
//        [self.tabBarController.viewControllers[0] viewWillAppear: true];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// MARK:- UICollectionView Delegate & Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        YourSkillLevelCell *skillCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YourSkillLevelCell" forIndexPath:indexPath];
        return skillCell;
        
    } else if (indexPath.row == 1) {
        insightClvCell *insightCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"insightClvCell" forIndexPath: indexPath];
        return insightCell;
    }
    else if (indexPath.row == 2) {
        WorkoutCalendarCell *calendarCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WorkoutCalendarCell" forIndexPath:indexPath];
        return calendarCell;

    } else if (indexPath.row == 3) {
        AverageWorkoutCell *averageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AverageWorkoutCell" forIndexPath:indexPath];
        return averageCell;

    } else if (indexPath.row == 4) {
        TimeOfDayClvCell *timeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TimeOfDayClvCell" forIndexPath:indexPath];
        return timeCell;

    } else if (indexPath.row == 5) {
        DayOfWeekClvCell *weekCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DayOfWeekClvCell" forIndexPath:indexPath];
        return weekCell;

    } else {
        return [[UICollectionViewCell alloc] initWithFrame:CGRectZero];
    }

}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

    displayTime = 0;
    
    if (indexPath.row == 0) {
        YourSkillLevelCell *skillCell = (YourSkillLevelCell *)cell;
        [skillCell animateNumbers];
        
    } else if (indexPath.row == 2) {
        WorkoutCalendarCell *calendarCell = (WorkoutCalendarCell *)cell;
        [calendarCell reloadCalendar];
        
    } else if (indexPath.row == 3) {
        AverageWorkoutCell *averageCell = (AverageWorkoutCell *)cell;
        [averageCell animateNumbers];
        
        [UIView animateWithDuration:1.7 animations:^{
            [averageCell.vwQuality setValue:0.0];
            [averageCell.vwQuality setValue:74.0];
            [averageCell layoutIfNeeded];
        }];
    } else if (indexPath.row == 4) {
        TimeOfDayClvCell *timeCell = (TimeOfDayClvCell *)cell;
        [timeCell.tblTimeOfDay reloadData];
        
    } else if (indexPath.row == 5) {
        DayOfWeekClvCell *weekCell = (DayOfWeekClvCell *)cell;
        [weekCell.clvDayOfWeek reloadData];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        AverageWorkoutCell *averageCell = (AverageWorkoutCell *)cell;
        averageCell.vwQuality.value = 0.0;
    }
}

// MARK:- In-App Purchase

- (void)inAppPurchaseWithProductId:(NSString *)productId {
    
    NSLog(@"User requests to Purchase Product");
    
    if ([SKPaymentQueue canMakePayments]) {
        NSLog(@"User can make payments");
        
        //Request product with product identifier
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:productId]];
        
        //Set Delegate
        productsRequest.delegate = self;
        
        //Send request to App Store
        [productsRequest start];
        
    } else {
        
        for (UIView* view in self.vwMonth.subviews)
            if(![view isKindOfClass:[UIActivityIndicatorView class]])
                [view setHidden: false];
        for (UIView* view in self.vwYear.subviews)
            if(![view isKindOfClass:[UIActivityIndicatorView class]])
                [view setHidden: false];
        
        //Hide Spinner
        [Utils hideActivityIndicator:spinner fromView:self.vwMonth];
        [Utils hideActivityIndicator:spinner fromView:self.vwYear];
        
        [self displayAlert:@"GymTimer" message:@"Sorry, Due to parental controls we could not process your purchase."];
        NSLog(@"User cannot make payments due to parental controls");
    }
}

- (void)purchase:(SKProduct *)product {
    //Get Product Price
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    //Add Observer In Payment Queue
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    //Add payment request in Queue
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

// MARK:- SKProductsRequest Delegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    SKProduct *validProduct = nil;
    
    if (response.products.count > 0) {
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        
        [self purchase:validProduct];
    } else if (!validProduct) {
        for (UIView* view in self.vwMonth.subviews)
            if(![view isKindOfClass:[UIActivityIndicatorView class]])
                [view setHidden: false];
        for (UIView* view in self.vwYear.subviews)
            if(![view isKindOfClass:[UIActivityIndicatorView class]])
                [view setHidden: false];
        
        //Hide Spinner
        [Utils hideActivityIndicator:spinner fromView:self.vwMonth];
        [Utils hideActivityIndicator:spinner fromView:self.vwYear];
        
        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Failed to load list of products.");
    NSLog(@"Error: %@",error.localizedDescription);
    
    for (UIView* view in self.vwMonth.subviews)
        if(![view isKindOfClass:[UIActivityIndicatorView class]])
            [view setHidden: false];
    for (UIView* view in self.vwYear.subviews)
        if(![view isKindOfClass:[UIActivityIndicatorView class]])
            [view setHidden: false];
    
    //Hide Spinner
    [Utils hideActivityIndicator:spinner fromView:self.vwMonth];
    [Utils hideActivityIndicator:spinner fromView:self.vwYear];
}

- (void)requestDidFinish:(SKRequest*)request {
    if ([request isKindOfClass:[SKReceiptRefreshRequest class]]) {
        NSLog(@"YES, You purchased this app");
    }
}

// MARK:- SKPaymentTransactionObserver

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    NSLog(@"Received restored transactions: %lu", (unsigned long)queue.transactions.count);
    
    for (SKPaymentTransaction *transaction in queue.transactions) {
        if (transaction.transactionState == SKPaymentTransactionStateRestored) {
            
            for (UIView* view in self.vwMonth.subviews)
                if(![view isKindOfClass:[UIActivityIndicatorView class]])
                    [view setHidden: false];
            for (UIView* view in self.vwYear.subviews)
                if(![view isKindOfClass:[UIActivityIndicatorView class]])
                    [view setHidden: false];
            
            //Hide Spinner
            [Utils hideActivityIndicator:spinner fromView:self.vwMonth];
            [Utils hideActivityIndicator:spinner fromView:self.vwYear];
            
            //Called when the user successfully restores a purchase
            NSLog(@"Transaction state -> Restored");
            
            NSString *productID = transaction.payment.productIdentifier;
            if ([productID isEqual:kProductIdForOneMonth]) {
                NSLog(@"Product ID: %@",kProductIdForOneMonth);
            } else if ([productID isEqual:kProductIdForOneYear]) {
                NSLog(@"Product ID: %@",kProductIdForOneYear);
            }
            
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }
    
    // Check If user is Pro or Free
    if ([Utils isConnectedToInternet]) {
        for (UIView* view in self.vwMonth.subviews)
            if(![view isKindOfClass:[UIActivityIndicatorView class]])
                [view setHidden: false];
        for (UIView* view in self.vwYear.subviews)
            if(![view isKindOfClass:[UIActivityIndicatorView class]])
                [view setHidden: false];
        
        //Start Spinner
        if ([selectedItem isEqualToString:@"Month"]) {
            spinner = [Utils showActivityIndicatorInView: self.vwMonth];
        } else if ([selectedItem isEqualToString:@"Year"]) {
            spinner = [Utils showActivityIndicatorInView: self.vwYear];
        }
        
        BOOL isProUser = [self checkInAppPurchaseStatus];
        
        //Hide Spinner
        [Utils hideActivityIndicator:spinner fromView:self.vwMonth];
        [Utils hideActivityIndicator:spinner fromView:self.vwYear];
        
        if (isProUser) {
            [self proUserAlertWithMessage:@"Your purchase restored successfully. You are now a Pro user."];
            [Utils setIsPaidUser:@"YES"];
        } else {
            [self displayAlert:@"GymTimer" message:@"Your purchase restored successfully. No active subscription found."];
            [Utils setIsPaidUser:@"NO"];
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    for (UIView* view in self.vwMonth.subviews)
        if(![view isKindOfClass:[UIActivityIndicatorView class]])
            [view setHidden: false];
    for (UIView* view in self.vwYear.subviews)
        if(![view isKindOfClass:[UIActivityIndicatorView class]])
            [view setHidden: false];
    
    //Hide Spinner
    [Utils hideActivityIndicator:spinner fromView:self.vwMonth];
    [Utils hideActivityIndicator:spinner fromView:self.vwYear];
    
    if ([error.domain isEqual:SKErrorDomain] && error.code == SKErrorPaymentCancelled) {
        return;
    }
    [self displayAlert:@"GymTimer" message:@"There are no items available to restore at this time."];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    
    NSString *strMessage = [[NSString alloc] init];
    
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                //User Purchasing Product
                NSLog(@"Transaction state -> Purchasing");
                break;
                
            case SKPaymentTransactionStatePurchased:
                for (UIView* view in self.vwMonth.subviews)
                    if(![view isKindOfClass:[UIActivityIndicatorView class]])
                        [view setHidden: false];
                for (UIView* view in self.vwYear.subviews)
                    if(![view isKindOfClass:[UIActivityIndicatorView class]])
                        [view setHidden: false];
                
                //Hide Spinner
                [Utils hideActivityIndicator:spinner fromView:self.vwMonth];
                [Utils hideActivityIndicator:spinner fromView:self.vwYear];
                
                NSLog(@"Transaction state -> Purchased");
                
                //User Purchased Product
                [Utils setIsPaidUser: @"YES"];
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                [self proUserAlertWithMessage:@"You are now a Pro user."];
                break;
                
            case SKPaymentTransactionStateRestored:
                for (UIView* view in self.vwMonth.subviews)
                    if(![view isKindOfClass:[UIActivityIndicatorView class]])
                        [view setHidden: false];
                for (UIView* view in self.vwYear.subviews)
                    if(![view isKindOfClass:[UIActivityIndicatorView class]])
                        [view setHidden: false];
                
                //Hide Spinner
                [Utils hideActivityIndicator:spinner fromView:self.vwMonth];
                [Utils hideActivityIndicator:spinner fromView:self.vwYear];
                
                NSLog(@"Transaction state -> Restored");
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                for (UIView* view in self.vwMonth.subviews)
                    if(![view isKindOfClass:[UIActivityIndicatorView class]])
                        [view setHidden: false];
                for (UIView* view in self.vwYear.subviews)
                    if(![view isKindOfClass:[UIActivityIndicatorView class]])
                        [view setHidden: false];
                
                //Hide Spinner
                [Utils hideActivityIndicator:spinner fromView:self.vwMonth];
                [Utils hideActivityIndicator:spinner fromView:self.vwYear];
                
                //User Purchase Failed
                if (transaction.error.code == SKErrorPaymentCancelled) {
                    strMessage = @"Payment Cancelled.";
                    NSLog(@"Transaction state -> User Cancelled");
                } else if (transaction.error.code == SKErrorPaymentInvalid) {
                    strMessage = @"Payment Invalid.";
                    NSLog(@"Transaction state -> Payment Invalid");
                } else if (transaction.error.code == SKErrorPaymentNotAllowed) {
                    strMessage = @"Payment Not Allowed.";
                    NSLog(@"Transaction state -> Payment NotAllowed");
                }
                
                if (strMessage.length > 0) {
                    [self displayAlert:@"GymTimer" message:strMessage];
                }
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction] ;
                break;
                
            case SKPaymentTransactionStateDeferred:
                for (UIView* view in self.vwMonth.subviews)
                    if(![view isKindOfClass:[UIActivityIndicatorView class]])
                        [view setHidden: false];
                for (UIView* view in self.vwYear.subviews)
                    if(![view isKindOfClass:[UIActivityIndicatorView class]])
                        [view setHidden: false];
                
                //Hide Spinner
                [Utils hideActivityIndicator:spinner fromView:self.vwMonth];
                [Utils hideActivityIndicator:spinner fromView:self.vwYear];
                
                strMessage = @"Something went wrong please try again later.";
                [self displayAlert:@"GymTimer" message:strMessage];
                
                NSLog(@"Transaction state -> Deferred");
                break;
        }
    }
}

// MARK:- In-App Purchase Receipt Validation

- (BOOL)checkInAppPurchaseStatus {
    
    // Load the receipt from the app bundle.
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
    
    if (receipt) {
        BOOL sandbox = [[receiptURL lastPathComponent] isEqualToString:@"sandboxReceipt"];
        // Create the JSON object that describes the request
        NSError *error;
        NSDictionary *requestContents = @{
                                          @"receipt-data": [receipt base64EncodedStringWithOptions:0],
                                          @"password": kSharedSecret
                                          };
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                              options:0
                                                                error:&error];
        
        if (requestData) {
            // Create a POST request with the receipt data.
            NSURL *storeURL = [NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
            if (sandbox) {
                storeURL = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
            }
            NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
            [storeRequest setHTTPMethod:@"POST"];
            [storeRequest setHTTPBody:requestData];
            
            BOOL rs = NO;
            
            NSError *error;
            NSURLResponse *response;
            NSData *resData = [NSURLConnection sendSynchronousRequest:storeRequest returningResponse:&response error:&error];
            if (error) {
                rs = NO;
            } else {
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:resData options:0 error:&error];
                if (!jsonResponse) {
                    rs = NO;
                } else {
                    NSLog(@"jsonResponse:%@", jsonResponse);
                    
                    NSDictionary *dictLatestReceiptsInfo = jsonResponse[@"latest_receipt_info"];
                    long long int expirationDateMs = [[dictLatestReceiptsInfo valueForKeyPath:@"@max.expires_date_ms"] longLongValue];
                    long long requestDateMs = [jsonResponse[@"receipt"][@"request_date_ms"] longLongValue];
                    NSLog(@"%lld--%lld", expirationDateMs, requestDateMs);
                    rs = [[jsonResponse objectForKey:@"status"] integerValue] == 0 && (expirationDateMs > requestDateMs);
                }
            }
            return rs;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

// MARK:- UIAlertView Releted

- (void)displayAlert:(NSString *)title message:(NSString *)msg {
    if (msg.length < 1) {
        return;
    }
    UIAlertController *alert = [UIAlertController  alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)proUserAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController  alertControllerWithTitle:@"GymTimer" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self welcomeToProCommunity];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)welcomeToProCommunity {
    ProCongratsVC *proCongratsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProCongratsVC"];
    proCongratsVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:proCongratsVC animated:YES completion:nil];
}

// MARK:- UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrView) {
        
        CGRect container = CGRectMake(self.scrView.contentOffset.x, self.scrView.contentOffset.y, self.scrView.frame.size.width, self.scrView.frame.size.height);
        CGRect thePosition = self.lblYourAverage.frame;
        
        // Check if $58 label visible on screen
        if (CGRectIntersectsRect(thePosition, container)) {
            if (isPriceAnimation) {
                isPriceAnimation = NO;
                
                [UIView animateWithDuration:3.8 animations:^{
                    self.constVwGrayWidth.constant = self.vwProgress.frame.size.width - 12;//;
                    [self.vwProgress layoutIfNeeded];
                }];
                
                [self.lblDollar58 countFromZeroTo:58 withDuration:3.0];
                [self.lblDollar2 countFromZeroTo:2 withDuration:1.0];
            }
        }

    } else {
        int currentIndex = self.clvCards.contentOffset.x / self.clvCards.frame.size.width;
        [self.pageControl setCurrentPage:currentIndex];
        
        scrollIndex = (currentIndex + 1);
    }
}

@end
