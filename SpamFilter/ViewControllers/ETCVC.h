//
//  ETCVC.h
//  SpamFilter
//
//  Created by hwi on 2017. 9. 21..
//  Copyright © 2017년 hwi. All rights reserved.
//

#import "BaseVC.h"
#import <StoreKit/StoreKit.h>

@interface ETCVC : BaseVC <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, GADNativeExpressAdViewDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate>
@property NSMutableArray *arr01_menu;

@property NSString *AD_REMOVE_PRODUCT_ID;

@property (weak, nonatomic) IBOutlet UITableView *tableview01_content;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *const01_tableviewHeight;
@property (weak, nonatomic) IBOutlet UIView *view01_ad;




@end
