//
//  BaseVC.m
//  SpamFilter
//
//  Created by hwi on 2017. 9. 21..
//  Copyright © 2017년 hwi. All rights reserved.
//

#import "BaseVC.h"

@implementation BaseVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
