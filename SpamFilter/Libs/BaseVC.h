//
//  BaseVC.h
//  SpamFilter
//
//  Created by hwi on 2017. 9. 21..
//  Copyright © 2017년 hwi. All rights reserved.
//
@import GoogleMobileAds;
#import "SpamFilterLib.h"
#import <StoreKit/StoreKit.h>

@interface BaseVC : UIViewController< SKPaymentTransactionObserver, SKProductsRequestDelegate>
@property NSString *AD_REMOVE_PRODUCT_ID;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *const01_admob_view_height_80;


-(void)addTopRightBtnForAddItem;
-(void)onAddButtonTouchUpInside:(id)sender;
-(void)checkPurchase;
@end
