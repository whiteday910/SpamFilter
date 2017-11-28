//
//  ETCVC.m
//  SpamFilter
//
//  Created by hwi on 2017. 9. 21..
//  Copyright © 2017년 hwi. All rights reserved.
//

#import "ETCVC.h"


@implementation ETCVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.AD_REMOVE_PRODUCT_ID = @"spamBlock01";
    
    self.arr01_menu = [[NSMutableArray alloc] init];
    
    
    [self.arr01_menu addObject:@"SPAM BLOCK 설정가이드"];
    [self.arr01_menu addObject:@"기능개선 요청"];
    [self.arr01_menu addObject:@"광고제거 및 후원($0.99) 구매"];
    [self.arr01_menu addObject:@"광고제거 및 후원 구매복원"];
    
    
    
    
    [self.tableview01_content reloadData];
    [[HWILib sharedObject] hwi_func01_delayAndRun:^{
        [self.const01_tableviewHeight setConstant:self.tableview01_content.contentSize.height];
    } afterDelay:0.05];
    
    
    
    
    /// 광고화면 로드
    [[HWILib sharedObject] hwi_func01_delayAndRun:^{
        GADNativeExpressAdView *adview = [[GADNativeExpressAdView alloc] initWithAdSize:GADAdSizeFromCGSize(self.view01_ad.frame.size)];
        [adview setAdUnitID:@"ca-app-pub-8810698137233879/3046742776"];
        [adview setRootViewController:self];
        [adview setDelegate:self];
        GADRequest *request = [GADRequest request];
        [adview loadRequest:request];
        
        [self.view01_ad addSubview:adview];
    } afterDelay:0.1];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 테이블뷰 델리깃
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.arr01_menu)
    {
        return [self.arr01_menu count];
    }
    
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = self.arr01_menu[indexPath.row];
    UITableViewCell *oneCell = [tableView dequeueReusableCellWithIdentifier:@"BasicETCCell"];
    
    [oneCell.textLabel setText:title];
    
    return oneCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *selectedTitle = self.arr01_menu[indexPath.row];
    
    if([@"SPAM BLOCK 설정가이드" isEqualToString:selectedTitle])
    {
        UIViewController *targetVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RequiredSettingGuideVC"];
        
        [self.navigationController pushViewController:targetVC animated:YES];
    }
    else if([@"기능개선 요청" isEqualToString:selectedTitle])
    {
        if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
            mail.mailComposeDelegate = self;
            [mail setSubject:@"[SPAM BLOCK] 기능개선 요청"];
            [mail setMessageBody:@"안녕하세요.\n SPAM BLOCK에 아래와 같은 기능개선을 요청드립니다." isHTML:NO];
            [mail setToRecipients:@[@"contact@elimsoft.co.kr"]];
            
            [self presentViewController:mail animated:YES completion:NULL];
        }
        else
        {
            NSLog(@"This device cannot send email");
            [[HWILib sharedObject] hwi_func04_showSimpleAlert:@"메일 설정 에러" message:@"이 기기는 현재 이메일을 보낼수 없습니다.\n메일설정을 확인해주세요" btnTitle:@"확인" btnHandler:^(UIAlertAction *action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            } vc:self];
        }
    }
    else if([@"광고제거 및 후원($0.99) 구매" isEqualToString:selectedTitle])
    {
        if([SKPaymentQueue canMakePayments])
        {
            NSLog(@"인앱결제가 가능합니다.");
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
            
            SKProductsRequest *skProductsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:self.AD_REMOVE_PRODUCT_ID]];
            
            [skProductsRequest setDelegate:self];
            [skProductsRequest start];
        }
        else
        {
            NSLog(@"인앱결제가 불가합니다!!");
            
            [[HWILib sharedObject] hwi_func04_showSimpleAlert:@"이 기기는 현재 인앱결제가 불가합니다." message:nil btnTitle:@"확인" btnHandler:nil vc:self];
            
        }
        
        
    }
    else if([@"광고제거 및 후원 구매복원" isEqualToString:selectedTitle])
    {
        NSLog(@"터치 확인 -> 광고제거 및 후원 구매복원 01");
        if([SKPaymentQueue canMakePayments])
        {
            NSLog(@"터치 확인 -> 광고제거 및 후원 구매복원 02");
            [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        }
        else
        {
            NSLog(@"인앱결제가 불가합니다!!");
            
            [[HWILib sharedObject] hwi_func04_showSimpleAlert:@"이 기기는 현재 인앱결제가 불가합니다." message:nil btnTitle:@"확인" btnHandler:nil vc:self];
            
        }
        
    }
    
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error
{
    NSString *title = @"예외상황 발생";
    NSString *desc = @"예외상황입니다.";
    
    if( result == MFMailComposeResultSent )
    {
        title = @"성공";
        desc = @"성공적으로 메일을 발송하였습니다.";
    }
    else if( result == MFMailComposeResultFailed )
    {
        title = @"실패";
        desc = @"메일발송이 실패하였습니다.";
    }
    else if( result == MFMailComposeResultCancelled )
    {
        title = @"취소";
        desc = @"메일발송이 취소되었습니다.";
    }
    else if( result == MFMailComposeResultSaved )
    {
        title = @"보류";
        desc = @"메일을 저장하였습니다.";
    }
    
    
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    [[HWILib sharedObject] hwi_func01_delayAndRun:^{
        [[HWILib sharedObject] hwi_func04_showSimpleAlert:title message:desc btnTitle:@"확인" btnHandler:nil vc:self];
    } afterDelay:0.5];
    
    
}


#pragma mark - AdMob 광고뷰 델리깃
- (void)nativeExpressAdViewDidReceiveAd:(GADNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"ETCVC 애드몹 테스트 01 : nativeExpressAdViewDidReceiveAd");
    
}


- (void)nativeExpressAdView:(GADNativeExpressAdView *)nativeExpressAdView
didFailToReceiveAdWithError:(GADRequestError *)error
{
    
    NSLog(@"ETCVC 애드몹 테스트 02 : didFailToReceiveAdWithError --> error : %@",[error localizedDescription]);
    
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
    
    
    
    NSArray<SKPaymentTransaction *> *transactions = [queue transactions];
    
    BOOL isRestored = NO;
    for(int i=0; i < [transactions count]; i++)
    {
        SKPaymentTransaction *transaction = transactions[i];
        NSString *productIdentifier = [[transaction payment] productIdentifier];
        NSLog(@"구매했던 프로덕트 아이덴티파이어 확인 i : %d ,  productIdentifier : %@",i, productIdentifier);
        
        if([productIdentifier isEqualToString:self.AD_REMOVE_PRODUCT_ID])
        {
            [[SpamFilterLib sharedSpamFilterLib] spamFilterLib03_setPurchaseStateYN:@"Y"];
            [self checkPurchase];
            break;
        }
        
    }
    
    if(!isRestored)
    {
        [[HWILib sharedObject] hwi_func04_showSimpleAlert:@"구매확인" message:@"광고제거 및 후원을 구매하신 적이 없습니다." btnTitle:@"OK" btnHandler:nil vc:self];
    }
    
    
    
    
    
    NSLog(@"로그확인 003 -> paymentQueueRestoreCompletedTransactionsFinished");
}




@end

