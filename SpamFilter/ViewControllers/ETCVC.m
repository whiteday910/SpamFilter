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
    
    self.arr01_menu = [[NSMutableArray alloc] init];
    
    
    [self.arr01_menu addObject:@"SPAM BLOCK 설정가이드"];
    [self.arr01_menu addObject:@"기능개선 요청"];
    
    
    
    
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
    } afterDelay:1];
    
    
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

@end

