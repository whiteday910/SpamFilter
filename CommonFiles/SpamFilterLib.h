//
//  SpamFilterLib.h
//  SpamFilter
//
//  Created by hwi on 2017. 9. 21..
//  Copyright © 2017년 hwi. All rights reserved.
//

#import "HWILib.h"
#import <MessageUI/MessageUI.h>


#define APP_GROUP_IDENTIFIER @"group.kr.co.elimsoft.SpamFilter"
#define APP_DATA_KEY @"AppData"
#define KEYWORD_KEY @"keyword"
#define NUMBER_KEY @"number"
#define IS_FIRST_RUN_KEY @"IS_FIRST_RUN_KEY"

@interface SpamFilterLib : NSObject
+(SpamFilterLib*)sharedSpamFilterLib;

-(NSUserDefaults*)userDefaults;
-(NSMutableDictionary*)spamFilterLib01_getAppDataFromFile;
-(void)spamFilterLib02_setAppDataToFileWithDic:(NSDictionary*)appDataDic;
@end
