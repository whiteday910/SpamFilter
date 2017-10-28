//
//  SpamFilterLib.m
//  SpamFilter
//
//  Created by hwi on 2017. 9. 21..
//  Copyright © 2017년 hwi. All rights reserved.
//

#import "SpamFilterLib.h"


@implementation SpamFilterLib



static SpamFilterLib *sharedSpamFilterLibObj;
static NSUserDefaults *sharedDefaultsObj;




+(SpamFilterLib*)sharedSpamFilterLib
{
    if(sharedSpamFilterLibObj == nil)
    {
        sharedSpamFilterLibObj = [[SpamFilterLib alloc] init];
    }
    
    return sharedSpamFilterLibObj;
}


-(NSUserDefaults*)userDefaults
{
    if(sharedDefaultsObj == nil)
    {
        sharedDefaultsObj = [[NSUserDefaults alloc] initWithSuiteName:APP_GROUP_IDENTIFIER];
    }
    
    return sharedDefaultsObj;
    
}



-(NSMutableDictionary*)spamFilterLib01_getAppDataFromFile
{
    NSString *jsonString = [[[SpamFilterLib sharedSpamFilterLib] userDefaults] objectForKey:APP_DATA_KEY];
    if(jsonString)
    {
        return [[[HWILib sharedObject] hwi_func27_JsonStringTojsonDic:jsonString] mutableCopy];
    }
    else
    {
        NSLog(@"예외상황 발생 : spamFilterLib01_getAppDataFromFile ---->  현재 파일에 저장된 앱데이터가 존재하지 않습니다");
        return [[NSMutableDictionary alloc] init];
    }
    
}


-(void)spamFilterLib02_setAppDataToFileWithDic:(NSDictionary*)appDataDic
{
    NSLog(@"값 저장하기 전 확인 --> appDataDic : %@",appDataDic);
    
    if(appDataDic)
    {
        [[[SpamFilterLib sharedSpamFilterLib] userDefaults] setObject:[[HWILib sharedObject] hwi_func27_jsonDicToJsonString:appDataDic isPrettyFormat:NO] forKey:APP_DATA_KEY];
        [[[SpamFilterLib sharedSpamFilterLib] userDefaults] synchronize];
    }
    else
    {
        NSLog(@"예외상황 발생 --> spamFilterLib02_setAppDataToFileWithDic --> appDataDic 이 nil 입니다.");
    }
}


-(void)spamFilterLib03_setPurchaseStateYN:(NSString*)stringYN
{
    [[[SpamFilterLib sharedSpamFilterLib] userDefaults] setObject:stringYN forKey:@"spamFilterLib03_setPurchaseStateYN"];
    [[[SpamFilterLib sharedSpamFilterLib] userDefaults] synchronize];
}
-(NSString*)spamFilterLib03_getPurchaseStateYN
{
    NSString *purchaseStateYN = [[[SpamFilterLib sharedSpamFilterLib] userDefaults] objectForKey:@"spamFilterLib03_setPurchaseStateYN"];
    
    return purchaseStateYN;
}
@end
