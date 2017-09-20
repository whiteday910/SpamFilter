//
//  SpamFilterLib.m
//  SpamFilter
//
//  Created by hwi on 2017. 9. 21..
//  Copyright © 2017년 hwi. All rights reserved.
//

#import "SpamFilterLib.h"


@implementation SpamFilterLib

#define APP_GROUP_IDENTIFIER @"group.kr.co.elimsoft.SpamFilter"
#define APP_DATA_KEY @"AppData"

static SpamFilterLib *sharedSpamFilterLibObj;
static NSUserDefaults *sharedDefaultsObj;
static NSDictionary *sharedAppData;



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



-(NSDictionary*)spamFilterLib01_getAppDataFromFile
{
    NSString *jsonString = [[[SpamFilterLib sharedSpamFilterLib] userDefaults] objectForKey:APP_DATA_KEY];
    if(jsonString)
    {
        return [[HWILib sharedObject] hwi_func27_JsonStringTojsonDic:jsonString];
    }
    else
    {
        NSLog(@"예외상황 발생 : spamFilterLib01_getAppDataFromFile ---->  현재 파일에 저장된 앱데이터가 존재하지 않습니다");
        return [[NSDictionary alloc] init];
    }
    
}

-(NSDictionary*)spamFilterLib01_getAppDataFromMemory
{
    if(sharedAppData)
    {
        return sharedAppData;
    }
    else
    {
        NSLog(@"예외상황 발생 : spamFilterLib01_getAppDataFromMemory ---->  메모리에 저장된 앱데이터가 존재하지 않습니다");
        NSLog(@"예외상황 발생 : spamFilterLib01_getAppDataFromMemory ---->  파일에 저장된 값을 리턴합니다.");
        return [[SpamFilterLib sharedSpamFilterLib] spamFilterLib01_getAppDataFromFile];
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




@end
