//
//  PreventListVC.m
//  SpamFilter
//
//  Created by hwi on 2017. 9. 21..
//  Copyright © 2017년 hwi. All rights reserved.
//

#import "PreventListVC.h"


@implementation PreventListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTopRightBtnForAddItem];
    [self refreshTableData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshTableData
{
    NSDictionary *appDataDic = [[SpamFilterLib sharedSpamFilterLib] spamFilterLib01_getAppDataFromFile];
    
    if(appDataDic)
    {
        if(self.curVCMode == VCModeKeyword)
        {
            self.arr01_list = appDataDic[KEYWORD_KEY];
        }
        else if(self.curVCMode == VCModeNumber)
        {
            self.arr01_list = appDataDic[NUMBER_KEY];
        }
        
    }
    
    [self.tableview01_content reloadData];
    [self processContentMode];
}

-(void)onAddButtonTouchUpInside:(id)sender
{
    NSString *titleOfAlert;
    NSString *messageOfAlert;
    
    if(self.curVCMode == VCModeKeyword)
    {
        titleOfAlert = @"키워드 등록";
        messageOfAlert = @"필터링할 키워드를 입력해주세요.\n콤마(,)로 구분하여 다수의 키워드입력이 가능합니다.";
    }
    else if(self.curVCMode == VCModeNumber)
    {
        titleOfAlert = @"전화번호 등록";
        messageOfAlert = @"필터링할 전화번호를 입력해주세요.\n예로 070을 입력하면 070으로 시작하는 모든 번호를 필터링합니다.";
    }
    
    
    UIAlertController *alertCont = [UIAlertController alertControllerWithTitle:titleOfAlert message:messageOfAlert preferredStyle:UIAlertControllerStyleAlert];
    
    [alertCont addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        if(self.curVCMode == VCModeKeyword)
        {
        [textField setPlaceholder:@"무료거부,먹튀"];
        }
        else if(self.curVCMode == VCModeNumber)
        {
            [textField setPlaceholder:@"07012341234"];
            [textField setKeyboardType:(UIKeyboardTypePhonePad)];
        }
        
        
    }];
    
    [alertCont addAction:[UIAlertAction actionWithTitle:@"취소" style:(UIAlertActionStyleCancel) handler:nil]];
    [alertCont addAction:[UIAlertAction actionWithTitle:@"추가" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textFieldContent =  alertCont.textFields[0];
        
        [self addContentProcess:textFieldContent.text];
        
    }]];
    
    [self presentViewController:alertCont animated:YES completion:nil];
    
}

-(void)addContentProcess:(NSString*)contents
{
    NSString *checkString = [contents stringByReplacingOccurrencesOfString:@" " withString:@""];
    checkString = [checkString stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    if(  ![@"" isEqualToString:checkString]  )
    {
        NSMutableDictionary *settingDic = [[SpamFilterLib sharedSpamFilterLib] spamFilterLib01_getAppDataFromFile];
        NSMutableArray *savedContentArr;
        if(self.curVCMode == VCModeKeyword)
        {
            if(settingDic[KEYWORD_KEY])
            {
                savedContentArr = [settingDic[KEYWORD_KEY] mutableCopy];
            }
            else
            {
                savedContentArr = [[NSMutableArray alloc] init];
            }
        }
        else if(self.curVCMode == VCModeNumber)
        {
            if(settingDic[NUMBER_KEY])
            {
                savedContentArr = [settingDic[NUMBER_KEY] mutableCopy];
            }
            else
            {
                savedContentArr = [[NSMutableArray alloc] init];
            }
        }
        
        
        
        
        NSArray *inputContentArr = [contents componentsSeparatedByString:@","];
        
        for(int i=0; i < [inputContentArr count]; i++)
        {
            NSString *oneInputContent = inputContentArr[i];
            BOOL isContainsKeyword = NO;
            for(int j=0; j < [savedContentArr count]; j++)
            {
                NSString *oneSavedKeyword = savedContentArr[j];
                if([oneSavedKeyword isEqualToString:oneInputContent])
                {
                    isContainsKeyword = YES;
                    break;
                }
            }
            
            if(!isContainsKeyword)
            {
                [savedContentArr addObject:oneInputContent];
            }
            
        }
        
        if(self.curVCMode == VCModeKeyword)
        {
            [settingDic setObject:savedContentArr forKey:KEYWORD_KEY];
        }
        else if(self.curVCMode == VCModeNumber)
        {
            [settingDic setObject:savedContentArr forKey:NUMBER_KEY];
        }
        
        [[SpamFilterLib sharedSpamFilterLib] spamFilterLib02_setAppDataToFileWithDic:settingDic];
        [self refreshTableData];
    }
    
    
}

-(void)processContentMode
{
    if(self.arr01_list && [self.arr01_list count] > 0)
    {
        [self changeContentMode:KeywordVCContentModeList];
    }
    else
    {
        [self changeContentMode:KeywordVCContentModeEmpty];
    }
}

-(void)changeContentMode:(KeywordVCContentMode)contentMode
{
    [self.view01_01_empty setHidden:YES];
    [self.view01_02_list setHidden:YES];
    
    if(contentMode == KeywordVCContentModeEmpty)
    {
        [self.view01_01_empty setHidden:NO];
    }
    else if(contentMode == KeywordVCContentModeList)
    {
        [self.view01_02_list setHidden:NO];
    }
    
}


#pragma mark - 테이블뷰 델리깃

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    /*
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44)];
    [testView setBackgroundColor:getColorWithHex(0xff00ff)];
    return testView;
    */
    
    GADNativeExpressAdView *adview = [[GADNativeExpressAdView alloc] initWithAdSize:GADAdSizeFromCGSize(CGSizeMake([[UIScreen mainScreen] bounds].size.width, 80))];
    
    [adview setAdUnitID:@"ca-app-pub-8810698137233879/3046742776"];
    [adview setRootViewController:self];
    [adview setDelegate:self];
    GADRequest *request = [GADRequest request];
    [adview loadRequest:request];
    
    
    return adview;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80.0 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.arr01_list)
    {
        return self.arr01_list.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell"];
    
    NSString *selectedTitle = self.arr01_list[indexPath.row];
    
    [cell.textLabel setText:selectedTitle];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.arr01_list removeObjectAtIndex:indexPath.row];
        
        NSMutableDictionary *settingDic = [[SpamFilterLib sharedSpamFilterLib] spamFilterLib01_getAppDataFromFile];
        
        if(self.curVCMode == VCModeKeyword)
        {
            [settingDic setObject:self.arr01_list forKey:KEYWORD_KEY];
        }
        else if(self.curVCMode == VCModeNumber)
        {
            [settingDic setObject:self.arr01_list forKey:NUMBER_KEY];
        }
        
        
        [[SpamFilterLib sharedSpamFilterLib] spamFilterLib02_setAppDataToFileWithDic:settingDic];
        [self.tableview01_content deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
        
        [[HWILib sharedObject] hwi_func01_delayAndRun:^{
            [self refreshTableData];
        } afterDelay:0.5];
    }
}

#pragma mark - Google Admob Delegate
- (void)nativeExpressAdViewDidReceiveAd:(GADNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"PreventListVC 애드몹 테스트 01 : nativeExpressAdViewDidReceiveAd");
    
}


- (void)nativeExpressAdView:(GADNativeExpressAdView *)nativeExpressAdView
didFailToReceiveAdWithError:(GADRequestError *)error
{
    
    NSLog(@"PreventListVC 애드몹 테스트 02 : didFailToReceiveAdWithError --> error : %@",[error localizedDescription]);
    
}
@end
