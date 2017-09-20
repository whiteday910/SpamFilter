//
//  MessageFilterExtension.m
//  FilterExtension
//
//  Created by hwi on 2017. 9. 20..
//  Copyright © 2017년 hwi. All rights reserved.
//

#import "MessageFilterExtension.h"


@interface MessageFilterExtension () <ILMessageFilterQueryHandling>
@end

@implementation MessageFilterExtension

#pragma mark - ILMessageFilterQueryHandling



- (void)handleQueryRequest:(ILMessageFilterQueryRequest *)queryRequest context:(ILMessageFilterExtensionContext *)context completion:(void (^)(ILMessageFilterQueryResponse *))completion
{
    
    // First, check whether to filter using offline data (if possible).
    ILMessageFilterAction offlineAction = [self offlineActionForQueryRequest:queryRequest];
    
    
    switch (offlineAction)
    {
        case ILMessageFilterActionAllow:
        {
            NSLog(@"테스트 01 : ILMessageFilterActionAllow");
        }
        case ILMessageFilterActionFilter:
        {
            // Based on offline data, we know this message should either be Allowed or Filtered. Send response immediately.
            ILMessageFilterQueryResponse *response = [[ILMessageFilterQueryResponse alloc] init];
            
            response.action = offlineAction;
            NSLog(@"테스트 02 : ILMessageFilterActionFilter");
            
            
            completion(response);
            break;
        }
            
        case ILMessageFilterActionNone:
        {
            NSLog(@"테스트 03 : ILMessageFilterActionNone");
            // Based on offline data, we do not know whether this message should be Allowed or Filtered. Defer to network.
            // Note: Deferring requests to network requires the extension target's Info.plist to contain a key with a URL to use. See documentation for details.
            [context deferQueryRequestToNetworkWithCompletion:^(ILNetworkResponse *_Nullable networkResponse, NSError *_Nullable error)
            {
                ILMessageFilterQueryResponse *response = [[ILMessageFilterQueryResponse alloc] init];
                response.action = ILMessageFilterActionNone;
                
                if (networkResponse)
                {
                    NSLog(@"테스트 04 : ILMessageFilterActionNone");
                    // If we received a network response, parse it to determine an action to return in our response.
                    response.action = [self actionForNetworkResponse:networkResponse];
                } else
                {
                    NSLog(@"테스트 05 : ILMessageFilterActionNone");
                    NSLog(@"Error deferring query request to network: %@", error);
                }
                
                completion(response);
            }];
            
            break;
        }
    }
}

- (ILMessageFilterAction)offlineActionForQueryRequest:(ILMessageFilterQueryRequest *)queryRequest
{
    NSLog(@"테스트 06 : offlineActionForQueryRequest");
    // Replace with logic to perform offline check whether to filter first (if possible).
    
    NSLog(@"테스트 06 - 01 ->  queryRequest.sender :  %@",queryRequest.sender);
    NSLog(@"테스트 06 - 02 ->  queryRequest.messageBody :  %@",queryRequest.messageBody);
    
    /// 국내 법안으로 필터링
    if( [self isContainStringWithLongText:queryRequest.messageBody compareWord:@"(광고)"] )
    {
        return ILMessageFilterActionFilter;
    }
    
    
    /// 등록한 키워드, 전화번호로 필터링
    if( [self isContainsSpamSetting:queryRequest] )
    {
        return ILMessageFilterActionFilter;
    }
    
    
    return ILMessageFilterActionNone;
}

- (ILMessageFilterAction)actionForNetworkResponse:(ILNetworkResponse *)networkResponse
{
    NSLog(@"테스트 07 : actionForNetworkResponse");
    // Replace with logic to parse the HTTP response and data payload of `networkResponse` to return an action.
    return ILMessageFilterActionNone;
}

-(BOOL)isContainStringWithLongText:(NSString*)longText compareWord:(NSString*)compareWord
{
    if(longText && compareWord)
    {
        if([longText rangeOfString:compareWord].location != NSNotFound)
        {
            return YES;
        }
        
    }
    else
    {
        NSLog(@"예외상황입니다 디버깅이 필요합니다!! --> longText : %@   ,  compareWord : %@",longText,compareWord );
    }
    
    
    return NO;
    
}



-(BOOL)isContainsSpamSetting:(ILMessageFilterQueryRequest*)messageInfo
{
    NSMutableDictionary *settingDic = [[SpamFilterLib sharedSpamFilterLib] spamFilterLib01_getAppDataFromFile];
    
    if(settingDic[KEYWORD_KEY])
    {
        NSArray *savedKeywords = settingDic[KEYWORD_KEY];
        
        for(int i=0; i < [savedKeywords count]; i++)
        {
            NSString *savedKeyword = savedKeywords[i];
            
            if([[HWILib sharedObject] hwi_func30_isContainsStringWithLongString:messageInfo.messageBody word:savedKeyword])
            {
                return YES;
            }
        }
        
    }
    
    /*
     
     for(int i=0; i < [self.arr01_spamContact count]; i++)
     {
     NSString *oneSavedNumber = self.arr01_spamContact[i];
     BOOL isSpam = [self isContainStringWithLongText:fromNumber compareWord:oneSavedNumber];
     
     if(isSpam)
     {
     return YES;
     }
     
     }
     */
    return NO;
}


@end
