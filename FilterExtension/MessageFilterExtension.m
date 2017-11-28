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
                    if(error.code == ILMessageFilterErrorSystem)
                    {
                        NSLog(@"네트워크 에러 01 : ILMessageFilterErrorSystem");
                    }
                    else if(error.code == ILMessageFilterErrorInvalidNetworkURL)
                    {
                        NSLog(@"네트워크 에러 02 : ILMessageFilterErrorInvalidNetworkURL");
                    }
                    else if(error.code == ILMessageFilterErrorNetworkURLUnauthorized)
                    {
                        NSLog(@"네트워크 에러 03 : ILMessageFilterErrorNetworkURLUnauthorized");
                    }
                    else if(error.code == ILMessageFilterErrorNetworkRequestFailed)
                    {
                        NSLog(@"네트워크 에러 04 : ILMessageFilterErrorNetworkRequestFailed");
                    }
                    else if(error.code == ILMessageFilterErrorRedundantNetworkDeferral)
                    {
                        NSLog(@"네트워크 에러 05 : ILMessageFilterErrorRedundantNetworkDeferral");
                    }
                    
                    NSLog(@"Error deferring query request to network: %@", [error localizedDescription]);
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
    
    NSLog(@"테스트 06 - 01 ->  queryRequest.sender : %@",queryRequest.sender);
    NSLog(@"테스트 06 - 02 ->  queryRequest.messageBody :  %@",queryRequest.messageBody);
    
    /// 국내 법안 및 070 전화번호로 필터링
    if( [self isContainStringWithLongText:queryRequest.messageBody compareWord:@"(광고)"]
       ||  [queryRequest.sender hasPrefix:@"070"])
    {
        NSLog(@"테스트 06 - 03");
        return ILMessageFilterActionFilter;
    }
    
    NSLog(@"테스트 06 - 04");
    /// 등록한 키워드, 전화번호로 필터링
    if( [self isContainsSpamSetting:queryRequest] )
    {
        NSLog(@"테스트 06 - 05");
        return ILMessageFilterActionFilter;
    }
    
    
    /// 이미지만 달랑 온 경우 필터링
    NSString *checkString = [queryRequest.messageBody stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    NSLog(@"checkString : [%@], length : %ld",checkString,[checkString length]);
    
    /// 정말 알수없는 특수문자로 필터링 됨 --> @"" 이거 안에 이상한 값 하나 있음
    if([@"￼" isEqualToString:checkString])
    {
        NSLog(@"테스트 06 - 06");
        return ILMessageFilterActionFilter;
    }
    
    NSLog(@"테스트 06 - 07");
    return ILMessageFilterActionNone;
}

- (ILMessageFilterAction)actionForNetworkResponse:(ILNetworkResponse *)networkResponse
{
    NSLog(@"테스트 07 : actionForNetworkResponse  --> networkResponse : %@",networkResponse);
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
    
    /// 키워드 셋팅 확인
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
    
    /// 전화번호 확인
    if(settingDic[NUMBER_KEY])
    {
        NSArray *savedNumbers = settingDic[NUMBER_KEY];
        for(int i=0; i < [savedNumbers count]; i++)
        {
            NSString *oneSavedNumber = savedNumbers[i];
            
            NSString *senderNumber = [self removeWhiteSpaceAndSpecialChar:messageInfo.sender];
            oneSavedNumber = [self removeWhiteSpaceAndSpecialChar:oneSavedNumber];
            
            BOOL isSpam =  [senderNumber hasPrefix:oneSavedNumber];
            
            if(isSpam)
            {
                return YES;
            }
            
        }
        
    }
    
    
     
    
    
    return NO;
}


-(NSString*)removeWhiteSpaceAndSpecialChar:(NSString*)input
{
    NSString *resultString = input;
    resultString = [resultString stringByReplacingOccurrencesOfString:@"82 10" withString:@"010"];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"+" withString:@""];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    resultString = [resultString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    return resultString;
    
}


@end
