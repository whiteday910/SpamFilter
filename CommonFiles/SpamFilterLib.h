//
//  SpamFilterLib.h
//  SpamFilter
//
//  Created by hwi on 2017. 9. 21..
//  Copyright © 2017년 hwi. All rights reserved.
//

#import "HWILib.h"

@interface SpamFilterLib : NSObject
+(SpamFilterLib*)sharedSpamFilterLib;

-(NSUserDefaults*)userDefaults;
-(NSDictionary*)spamFilterLib01_getAppDataFromFile;
-(NSDictionary*)spamFilterLib01_getAppDataFromMemory;
-(void)spamFilterLib02_setAppDataToFileWithDic:(NSDictionary*)appDataDic;
@end
