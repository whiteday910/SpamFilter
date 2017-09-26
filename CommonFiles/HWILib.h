//
//  HWILib.h
//  FoodFile
//
//  Created by KimJeonghwi on 2015. 11. 2..
//  Copyright © 2015년 Elimsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>


/// 컬러 관련 정의
#define getColorWithRGB(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define getColorWithRGBA(r, g, b, a)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define getColorWithHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]


#define getColorWithHexAndAlpha(rgbValue,a) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:(a)]



/// NSLog 가 짤리는 현상 방지
#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);




//// 키보드 움직임 관련 델리깃
@protocol HWILibDelegate <NSObject>

-(void)onKeyboardShow:(NSNotification*)notification keyboardHeight:(CGFloat)keyboardHeight;
-(void)onKeyboardHide:(NSNotification*)notification keyboardHeight:(CGFloat)keyboardHeight;

@end


@interface HWILib : NSObject <CLLocationManagerDelegate>

@property id<HWILibDelegate> delegate;

+(HWILib*)sharedObject;

/// 특정시간 이후 블럭코드 실행
-(void)hwi_func01_delayAndRun:(void (^)(void))block afterDelay:(NSTimeInterval)delayInSeconds;

/// 메인스레드에서 작업
-(void)hwi_func02_workInMainThread:(void (^)(void))block;


/// 이메일 유효성 체크
-(BOOL)hwi_func03_isValidEmail:(NSString*)emailText;



/// 간단한 얼럿뷰 표시
-(void)hwi_func04_showSimpleAlert:(NSString*)title message:(NSString*)message btnTitle:(NSString*)btnTitle btnHandler:(void (^)(UIAlertAction *action))btnHandler vc:(UIViewController*)vc;

/// 랜덤 색상 뽑기
-(UIColor*)hwi_func05_getRandomColor;

/// String, 폰트, 가로크기 를 대입해서 해당하는 뷰의 세로크기 반환
-(CGFloat)hwi_func06_getHeightForViewWithString:(NSString*)text font:(UIFont*)font width:(CGFloat)width;

/// APNS 등록
///-(void)hwi_func07_registAPNSWithCallback:(void (^)(BOOL isGranted))grantedCallback;



/////         -----------        GUIDE
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// AppDelegate 에 아래와 같은 값을 추가하여 HWILib의 APNS 서비스를 사용한다.
/*
 #pragma markr - Push
 - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
 {
 NSLog(@"디바이스 토큰 수신 완료(가공 전) : %@",deviceToken);
 
 NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
 token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
 NSLog(@"디바이스 토큰 수신 완료(가공 후) : %@",token);
 
 
 [[HWILib sharedObject] hwi_func25_setAPNSTokenToLocal:token];
 
 }
 
 - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
 {
 NSLog(@"---푸시노티피케이션 수신 테스트---");
 NSLog(@"userInfo : %@",userInfo);
 }
 */
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



/// 텍스트와 폰트를 통해서 가로 길이 반환
-(CGFloat)hwi_func08_getWidthOfText:(NSString*)text font:(UIFont*)font;

/// 이미지의 로테이션을 정상화함
-(UIImage*)hwi_func09_fixrotation:(UIImage *)image;

/// 뷰를 정원 형태로 Crop
-(void)hwi_func10_makeViewRound:(UIView*)view;

//// 라벨 특정 부위를 굵은 글씨로 변경
-(void)hwi_func11_makeTextBoldRangeOfString:(NSString*)wantBoldText label:(UILabel*)label customBoldFontIsWant:(UIFont*)customBoldFont;




/// 현재 위치를 찾음 --> latitude, longitude 반환.
-(void)hwi_func12_getCurrentLocationLatitudeAndLongitudeWithCallback:( void(^)(double latitude, double longitude))callback;


/// 위치값을 통해 주소값을 가져옴
-(void)hwi_func13_getCurrentLocationAddressTextWithLocation_latitude:(double)latitude longitude:(double)longitude callback:( void (^)(NSString *addressText))callback;

/// PlaceMark 객체를 통해 주소를 가져옴
-(NSString*)hwi_func14_getAddressTextFromPlaceMarker:(CLPlacemark*)placeMark;


/// 현재 로케일 코드를 반환
-(NSString*)hwi_func15_getCurrentLocaleCode;

/// 현재 언어 코드를 반환
-(NSString*)hwi_func16_getCurrentLanguageCode;

/// 현재 언어 코드를 앞부분 2글자만 가져옴
-(NSString*)hwi_func16_getCurrentLanguageCode_2char;

/// 객체가 null 이나 nil 인지 검사한다.
-(BOOL)hwi_func17_isNULLnilWithObj:(id)obj;



/// 라벨에서 특정 부분의 텍스트 컬러를 변경한다
-(void)hwi_func18_changeColorToLabelSpecificPart:(UILabel*)label partText:(NSString*)partText wantColor:(UIColor*)wantColor;

/// 텍스트뷰에서 특정 부분의 텍스트 컬러를 변경한다.
-(void)hwi_func18_changeColorToTextViewSpecificPart:(UITextView*)textView partText:(NSString*)partText wantColor:(UIColor*)wantColor;


/// 테이블뷰에서 현재 셀을 통해서 테이블 뷰를 가져온다.
-(UITableView*)hwi_func19_getTableviewFromCell:(UITableViewCell*)currentCell;


/// 현재 기기의 모델이름을 가져온다.
-(NSString*)hwi_func20_getDeviceModelString;



/// 1000의 자리 수마다 콤마(,)를 추가한다.
-(NSString*)hwi_func22_addCommaThousandWithString:(NSString*)text;

/// 현재 앱의 버전값을 가져온다.
-(NSString*)hwi_func23_getVersionOfApp;


/// 이미지의 사이즈를 조절한다.
-(UIImage*)hwi_func24_resizeImageWithOriginImage:(UIImage*)originImage newSize:(CGSize)newSize;


/// APNS 토큰 저장 및 로드
-(NSString*)hwi_func25_getAPNSTokenFromLocal;
-(void)hwi_func25_setAPNSTokenToLocal:(NSString*)token;

/// 이미지 사이즈 수정 -> 세로 값에 맞춰서 비율 보정하여 이미지 크기 수정
-(UIImage*)hwi_func26_imageWithImage: (UIImage*) sourceImage scaledToHeight: (float) i_height;

/// NSDictionary 를 NSString 형태로 변환
-(NSString*)hwi_func27_jsonDicToJsonString:(id)dictionaryORArray isPrettyFormat:(BOOL)isPretty;


/// NSString 를 NSDictionary 형태로 변환
-(id)hwi_func27_JsonStringTojsonDic:(NSString*)jsonString;



/// 10보다 작은 수의 경우 앞에 0을 삽입한 두자리 수를 만들어준다 예> 9 --> 09
-(NSString*)hwi_func28_makeZeroWhenSmallerThan10:(int)inputInt;

/// string 의 화이트스페이스를 제거한 값이 공백인지 검사한다.
-(BOOL)hwi_func29_isStringEmpty:(NSString*)checkString;

/// 텍스트에 특정 단어가 포함되어있는지 검사한다.
-(BOOL)hwi_func30_isContainsStringWithLongString:(NSString*)longString word:(NSString*)word;

/// fade out 에니메이션
-(void)hwi_func31_fadeOutWithView:(UIView*)targetView complete:(void (^)(void))complete;
/// fade in 애니메이션
-(void)hwi_func31_fadeInWithView:(UIView*)targetView complete:(void (^)(void))complete;


/// 스크롤뷰가 마지막 위치에 닿았는지 검사한다.
-(BOOL)hwi_func32_isScrollviewReachEnd:(UIScrollView*)scrollV;

/// 화면 가로크기에 맞췄을 때 비율에 맞춘 세로값을 반환한다.
-(CGFloat)hwi_func33_getHeightForRatioScreen_width:(CGFloat)width height:(CGFloat)height;

/// 키보드 show/hide 위임자를 등록한다.
-(void)hwi_func34_registKeyboardShowHideDelegate:(id<HWILibDelegate>)delegate;

/// 키보드 show/hide 위임자를 해제한다.
-(void)hwi_func34_removeKeyboardObserverDelegate;

/// AppDelegate에서 rootviewcontroller를 통해 현재 보여지는 VC를 리턴받는다.
//-(UIViewController*)hwi_func35_getCurrentTopViewController;


/// 2가지 물음에 대해 선택할 수 있는 얼럿 창 표시
-(void)hwi_func36_showSelect2AlertWithTitle:(NSString*)title message:(NSString*)message yesTitle:(NSString*)yesTitle yesHandler:(void (^)(UIAlertAction *action))yesHandler noTitle:(NSString*)noTitle noHandler:(void (^)(UIAlertAction *action))noHandler vc:(UIViewController*)vc;



/// 블러뷰를 만들어서 가져옴
-(UIView*)hwi_func37_makeBlurV:(UIView*)targetView;


/// Dictionary 를 MutableDictionary 로 변경해준다.
-(NSMutableArray*)hwi_func38_changeDicToMutableDicInArr:(NSArray*)arr;


/// 오늘 날짜를 가져온다   예>  2016.09.01
-(NSString*)hwi_func39_getTodayString;


/// 현재날짜에서 1일을 더한 날짜를 가져온다 예 > 2016.09.01 17:22
-(NSString*)hwi_func40_getTodayPlusOneDayWithTimeString;


/// 현재 날짜를 숫자비교 가능한 형태로 가져온다  예 >  20160910
-(double)hwi_func41_getCurrentDateNumberString_year_month_day;

/// 사람이 보는 날짜에서 NSDate를 생성해낸다. 2016-11-26 --> NSDate객체.
-(NSDate*)hwi_func42_makeNSDateFromYearMonthDay_year:(int)year month:(int)month day:(int)day;

/// URL 파라미터에서 Key & Value 딕셔너리로 쿼리를 빼온다.
-(NSDictionary *)hwi_func43_parseQueryString:(NSString *)query;



/// 타임스탬프를 사람이 보기 좋은 날짜 형태로 변환한다.
-(NSString*)hwi_func44_getHumanDateStringFromTimestamp:(double)timestamp;

/// 현재 뷰의 모든 폰트를 지정한 폰트로 변경해 버린다.
-(void)hwi_func45_setFontToAllWithFont:(NSString*)fontName view:(UIView*)view;


/// 현재 뷰에서 내가 속해있는 뷰 컨트롤러를 가지고 온다. --> 리스폰더 체인을 활용해서 리턴!
-(UIViewController*)hwi_func46_getCurrentViewControllerFromSubV:(UIView*)curV;

/// SNS 에서 사용하는 방식으로 시간 표시 -> 예> 15시간 전
-(NSString*)hwi_func47_getDateStringUseSNS:(double)timestamp;



/// 라벨에 줄 간격 셋팅
-(void)hwi_func49_setLineSpacingToLabelHeightWithHeight:(CGFloat)height label:(UILabel*)label;

/// 글의 좌우 여백을 삭제함.
-(NSString*)hwi_func50_trimString:(NSString*)originString;

/// 뷰에 그라데이션 백그라운드 컬러를 적용
-(void)hwi_func51_setBackgroundColorToGradientWithStartColor:(UIColor*)startColor endColor:(UIColor*)endColor targetView:(UIView*)targetView;

/// 사용가능한 폰트 출력
-(void)hwi_func52_printAllAvailableFonts;


//// 로컬노티피케이션 표시
-(void)hwi_func53_showLocalNotificationWithTitle:(NSString*)title subtitle:(NSString*)subtitle body:(NSString*)body identifier:(NSString*)identifier delayTime:(double)delayTime delegate:(id<UNUserNotificationCenterDelegate>)delegate;


/// 초를 받아서 00:00 과 같은 형태로 분:초 로 리턴해준다.
-(NSString*)hwi_func54_getMinutesAndSecondFromSecVal:(double)seconds;


/// 뷰를 이미지로 변경해서 가져온다.
-(UIImage *)hwi_func55_makeImageFromUIView:(UIView*)fromView;


/// 텍스트를 받아서 음성으로 재생시킨다 (TTS) langCode example en-US, ko-KR
-(void)hwi_func56_performTTS:(NSString*)text langCode:(NSString*)langCode utteranceRate:(CGFloat)utteranceRate;




@end
