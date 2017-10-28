//
//  BaseVC.m
//  SpamFilter
//
//  Created by hwi on 2017. 9. 21..
//  Copyright © 2017년 hwi. All rights reserved.
//

#import "BaseVC.h"

@implementation BaseVC

static BOOL duplicateCallPreventFlag = NO;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.AD_REMOVE_PRODUCT_ID = @"spamBlock01";
    
    // 만약 앱을 처음 실행한 것이면 가이드 열기
    [[HWILib sharedObject] hwi_func01_delayAndRun:^{
        NSMutableDictionary *settingDic = [[SpamFilterLib sharedSpamFilterLib] spamFilterLib01_getAppDataFromFile];
        
        if(![@"YES" isEqualToString:settingDic[IS_FIRST_RUN_KEY]])
        {
            [settingDic setObject:@"YES" forKey:IS_FIRST_RUN_KEY];
            
            [[SpamFilterLib sharedSpamFilterLib] spamFilterLib02_setAppDataToFileWithDic:settingDic];
            
            UIViewController *targetVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RequiredSettingGuideVC"];
            
            [self.navigationController pushViewController:targetVC animated:YES];
        }
    } afterDelay:0.5];
    
    if(!duplicateCallPreventFlag)
    {
        if([SKPaymentQueue canMakePayments])
        {
            NSLog(@"인앱결제가 가능합니다.");
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
            [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        }
        else
        {
            NSLog(@"인앱결제가 불가합니다!!");
        }
        duplicateCallPreventFlag = YES;
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkPurchase];
}

-(void)checkPurchase
{
    if([@"Y" isEqualToString:[[SpamFilterLib sharedSpamFilterLib] spamFilterLib03_getPurchaseStateYN]] )
    {
        [self.const01_admob_view_height_80 setConstant:0.0];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addTopRightBtnForAddItem
{
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navibar_add"] style:(UIBarButtonItemStylePlain) target:self action:@selector(onAddButtonTouchUpInside:)];
    
    [self.navigationItem setRightBarButtonItem:addButton];
    
}


-(void)onAddButtonTouchUpInside:(id)sender
{
    NSLog(@"BaseVC - 추가버튼 터치 확인");
    
}








#pragma mark - 인앱결제 관련 델리깃
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"인앱결제 아이템 정보 확인 00");
    
    if( [response.products count] > 0 )
    {
        SKProduct *product = [response.products objectAtIndex:0];
        
        NSLog(@"인앱결제 아이템 정보 확인 Title : %@", product.localizedTitle);
        NSLog(@"인앱결제 아이템 정보 확인 Description : %@", product.localizedDescription);
        NSLog(@"인앱결제 아이템 정보 확인 Price : %@", product.price);
        
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        
        
        
    }
    
    if( [response.invalidProductIdentifiers count] > 0 )
    {
        NSString *invalidString = [response.invalidProductIdentifiers objectAtIndex:0];
        NSLog(@"인앱결제 아이템 정보 확인 Invalid Identifiers : %@", invalidString);
    }
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"결제 확인 00 : SKPaymentTransactionStatePurchasing");
                break;
            case SKPaymentTransactionStatePurchased:
                NSLog(@"결제 확인 01 : SKPaymentTransactionStatePurchased");
                [[SpamFilterLib sharedSpamFilterLib] spamFilterLib03_setPurchaseStateYN:@"Y"];
                [self checkPurchase];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"결제 확인 02 : SKPaymentTransactionStateFailed");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"결제 확인 03 : SKPaymentTransactionStateRestored");
                break;
            case SKPaymentTransactionStateDeferred:
                NSLog(@"결제 확인 04 : SKPaymentTransactionStateDeferred");
                break;
            default:
                break;
        }
        
        
    }
}



- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    
    NSLog(@"로그 확인 001 --> restoreCompletedTransactionsFailedWithError");
    NSLog(@"로그 확인 002 --> error : %@",[error localizedDescription]);
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    [[SpamFilterLib sharedSpamFilterLib] spamFilterLib03_setPurchaseStateYN:@"Y"];
    [self checkPurchase];
    NSLog(@"로그확인 003 -> paymentQueueRestoreCompletedTransactionsFinished");
}

@end
