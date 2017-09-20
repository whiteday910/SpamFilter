//
//  HWILib.m
//  FoodFile
//
//  Created by KimJeonghwi on 2015. 11. 2..
//  Copyright © 2015년 Elimsoft. All rights reserved.
//

#import "HWILib.h"
#import <sys/utsname.h>
@import AVFoundation;


@implementation HWILib
CLLocationManager *locManager;


HWILib *_sharedObj;

void(^func12_locationCallback)(double latitude, double longitude);

BOOL func12_locationCallbackOnetimeFlag;

+(HWILib*)sharedObject
{
    if(!_sharedObj)
    {
        _sharedObj = [[HWILib alloc] init];
    }
    
    return _sharedObj;
}

- (void)hwi_func01_delayAndRun:(void (^)())block afterDelay:(NSTimeInterval)delayInSeconds
{
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        
        block(); // this will trigger your code to run
        
    });

}

-(void)hwi_func02_workInMainThread:(void (^)())block
{
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
        
    });
}

-(BOOL)hwi_func03_isValidEmail:(NSString*)emailText
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailText];
}





-(void)hwi_func04_showSimpleAlert:(NSString*)title message:(NSString*)message btnTitle:(NSString*)btnTitle btnHandler:(void (^)(UIAlertAction *action))btnHandler vc:(UIViewController*)vc
{
    UIAlertController *alertCont = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertCont addAction:[UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:btnHandler]];
    
    [vc presentViewController:alertCont animated:YES completion:nil];
    
    
}

-(UIColor*)hwi_func05_getRandomColor;
{
    int r = arc4random_uniform(256);
    int g = arc4random_uniform(256);
    int b = arc4random_uniform(256);
    return getColorWithRGB(r, g, b);
}

-(CGFloat)hwi_func06_getHeightForViewWithString:(NSString*)text font:(UIFont*)font width:(CGFloat)width
{
    UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 9999)];
    [oneLabel setNumberOfLines:0];
    oneLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [oneLabel setFont:font];
    [oneLabel setText:text];
    [oneLabel sizeToFit];

    return oneLabel.frame.size.height;
}
/*
-(void)hwi_func07_registAPNSWithCallback:(void (^)(BOOL isGranted))grantedCallback
{
    NSLog(@"registAPNS 시작");
    
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:( UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge ) completionHandler:^(BOOL granted, NSError * _Nullable error)
    {
    
        
        if(granted)
        {
            NSLog(@"푸시 노티피케이션을 사용자가 허용하였습니다.");
            
            [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                
                UNAuthorizationStatus settingVal = [settings authorizationStatus];
                
                if(settingVal == UNAuthorizationStatusNotDetermined)
                {
                    NSLog(@"푸시 노티피케이션을 사용자가 결정하지 않았습니다..");
                }
                else if(settingVal == UNAuthorizationStatusDenied)
                {
                    NSLog(@"푸시 노티피케이션을 사용자가 거부하였습니다..");
                }
                else if(settingVal == UNAuthorizationStatusAuthorized)
                {
                    NSLog(@"푸시 노티피케이션을 사용자가 최종승인하였습니다..");
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                }
                
            }];
        }
        else
        {
            NSLog(@"푸시 노티피케이션을 사용자가 거부하였습니다. ㅜㅜ  ");
        }
        
        grantedCallback(granted);
        
    }];
 
}
*/

-(CGFloat)hwi_func08_getWidthOfText:(NSString*)text font:(UIFont*)font
{
    NSString *someString = text;
    
    NSDictionary *attributes = @{NSFontAttributeName: font};
    
    
    CGSize sizeOfV = [someString sizeWithAttributes:attributes];
    
    return sizeOfV.width;
}



-(UIImage *)hwi_func09_fixrotation:(UIImage *)image
{
    
    
    if (image.imageOrientation == UIImageOrientationUp) return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
    
}

-(void)hwi_func10_makeViewRound:(UIView*)view
{
    
    [[HWILib sharedObject] hwi_func01_delayAndRun:^{
        view.layer.cornerRadius = view.frame.size.height / 2;
        view.layer.masksToBounds = YES;
        view.clipsToBounds = YES;
    
    } afterDelay:0.01];
    
    
    
}




-(void)hwi_func11_makeTextBoldRangeOfString:(NSString*)wantBoldText label:(UILabel*)label customBoldFontIsWant:(UIFont*)customBoldFont
{
    
    NSRange rangeOfBold = [label.text rangeOfString:wantBoldText];

    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:label.text];
    
    UIFont *targetFont;
    
    if(customBoldFont)
    {
        targetFont = customBoldFont;
    }
    else
    {
        targetFont = [UIFont boldSystemFontOfSize:label.font.pointSize];
    }
    
    [attributedText setAttributes:@{NSFontAttributeName:targetFont}
                            range:rangeOfBold];

    
    label.attributedText = attributedText;
    
}










-(void)hwi_func12_getCurrentLocationLatitudeAndLongitudeWithCallback:( void(^)(double latitude, double longitude))callback
{
    func12_locationCallbackOnetimeFlag = NO;
    func12_locationCallback = callback;
    locManager = [[CLLocationManager alloc] init];
    locManager.desiredAccuracy = kCLLocationAccuracyBest;
    locManager.delegate = [HWILib sharedObject];
    [locManager requestWhenInUseAuthorization];
    [locManager startUpdatingLocation];
}




/// 현재 위치의 주소를 텍스트로 알아낸다. ---> locations(CLLocation) Array 를 입력받아야 한다.
-(void)hwi_func13_getCurrentLocationAddressTextWithLocation_latitude:(double)latitude longitude:(double)longitude callback:( void (^)(NSString *addressText))callback
{
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> *placemarks, NSError * error) {
        if( placemarks != nil && placemarks.count > 0 )
        {
            CLPlacemark *onePlace = [placemarks objectAtIndex:0];
            NSString *addressText = [[HWILib sharedObject] hwi_func14_getAddressTextFromPlaceMarker:onePlace];
            callback(addressText);
        }
    }];

}

/// CLPlaceMark 를 통해서 주소를 반환해온다. 
-(NSString*)hwi_func14_getAddressTextFromPlaceMarker:(CLPlacemark*)placeMark
{
    CLPlacemark *onePlace = placeMark;
    
    
    /// 주소 스트링 만들어서 텍스트에 삽입
    NSString *makedAddress = @"";
    
    if(onePlace.administrativeArea != nil && ![onePlace.administrativeArea isEqualToString:@""] )
    {
        makedAddress = [makedAddress stringByAppendingString:onePlace.administrativeArea];
    }
    if(onePlace.locality != nil && ![onePlace.locality isEqualToString:@""] )
    {
        if(![makedAddress isEqualToString:@""])
        {
            makedAddress = [NSString stringWithFormat:@"%@ %@",makedAddress,onePlace.locality];
        }
        else
        {
            makedAddress = onePlace.locality;
        }
        
    }
    if(onePlace.subLocality != nil && ![onePlace.subLocality isEqualToString:@""] )
    {
        makedAddress = [makedAddress stringByAppendingString:[NSString stringWithFormat:@" %@",onePlace.subLocality]];
    }
    
    if(onePlace.subThoroughfare != nil && ![onePlace.subThoroughfare isEqualToString:@""] )
    {
        makedAddress = [makedAddress stringByAppendingString:[NSString stringWithFormat:@" %@",onePlace.subThoroughfare]];
    }
    
    return makedAddress;
    

}





-(NSString*)hwi_func15_getCurrentLocaleCode
{
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    
    return countryCode;
}

-(NSString*)hwi_func16_getCurrentLanguageCode
{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    return language;
}

-(NSString*)hwi_func16_getCurrentLanguageCode_2char
{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    language = [language substringToIndex:2];
    language = [language lowercaseString];
    
    return language;
}



-(BOOL)hwi_func17_isNULLnilWithObj:(id)obj
{
    if( obj != (id)[NSNull null] && obj != nil)
    {
        return NO;
    }
    
    return YES;
}





-(void)hwi_func18_changeColorToLabelSpecificPart:(UILabel*)label partText:(NSString*)partText wantColor:(UIColor*)wantColor
{

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: label.attributedText];
    
    NSRange wantRange = [label.text rangeOfString:partText];
    
    [text addAttribute:NSForegroundColorAttributeName value:wantColor range:wantRange];
    [label setAttributedText: text];

}

-(void)hwi_func18_changeColorToTextViewSpecificPart:(UITextView*)textView partText:(NSString*)partText wantColor:(UIColor*)wantColor
{
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: textView.attributedText];
    
    NSRange wantRange = [textView.text rangeOfString:partText];
    
    [text addAttribute:NSForegroundColorAttributeName value:wantColor range:wantRange];
    [textView setAttributedText:text];
    
}



-(UITableView*)hwi_func19_getTableviewFromCell:(UITableViewCell*)currentCell
{
    if(![currentCell isKindOfClass:[UITableViewCell class]])
    {
        NSLog(@"파라미터로 전달된 뷰가 테이블의 셀이 아닙니다. --> 디버깅 필요!!!");
        return nil;
    }
    
    
    id view = [currentCell superview];
    while (view && [view isKindOfClass:[UITableView class]] == NO)
    {
        view = [view superview];
    }
    
    return view;
}



-(NSString*)hwi_func20_getDeviceModelString
{
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *machineName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //MARK: More official list is at
    //http://theiphonewiki.com/wiki/Models
    //MARK: You may just return machineName. Following is for convenience
    
    NSDictionary *commonNamesDictionary =
    @{
      @"i386":     @"i386 Simulator",
      @"x86_64":   @"x86_64 Simulator",
      
      @"iPhone1,1":    @"iPhone",
      @"iPhone1,2":    @"iPhone 3G",
      @"iPhone2,1":    @"iPhone 3GS",
      @"iPhone3,1":    @"iPhone 4",
      @"iPhone3,2":    @"iPhone 4(Rev A)",
      @"iPhone3,3":    @"iPhone 4(CDMA)",
      @"iPhone4,1":    @"iPhone 4S",
      @"iPhone5,1":    @"iPhone 5(GSM)",
      @"iPhone5,2":    @"iPhone 5(GSM+CDMA)",
      @"iPhone5,3":    @"iPhone 5c(GSM)",
      @"iPhone5,4":    @"iPhone 5c(GSM+CDMA)",
      @"iPhone6,1":    @"iPhone 5s(GSM)",
      @"iPhone6,2":    @"iPhone 5s(GSM+CDMA)",
      
      @"iPhone7,1":    @"iPhone 6+(GSM+CDMA)",
      @"iPhone7,2":    @"iPhone 6(GSM+CDMA)",
      
      @"iPhone8,1":    @"iPhone 6S(GSM+CDMA)",
      @"iPhone8,2":    @"iPhone 6S+(GSM+CDMA)",
      @"iPhone8,4":    @"iPhone SE(GSM+CDMA)",
      @"iPhone9,1":    @"iPhone 7(GSM+CDMA)",
      @"iPhone9,2":    @"iPhone 7+(GSM+CDMA)",
      @"iPhone9,3":    @"iPhone 7(GSM+CDMA)",
      @"iPhone9,4":    @"iPhone 7+(GSM+CDMA)",
      
      @"iPad1,1":  @"iPad",
      @"iPad2,1":  @"iPad 2(WiFi)",
      @"iPad2,2":  @"iPad 2(GSM)",
      @"iPad2,3":  @"iPad 2(CDMA)",
      @"iPad2,4":  @"iPad 2(WiFi Rev A)",
      @"iPad2,5":  @"iPad Mini 1G (WiFi)",
      @"iPad2,6":  @"iPad Mini 1G (GSM)",
      @"iPad2,7":  @"iPad Mini 1G (GSM+CDMA)",
      @"iPad3,1":  @"iPad 3(WiFi)",
      @"iPad3,2":  @"iPad 3(GSM+CDMA)",
      @"iPad3,3":  @"iPad 3(GSM)",
      @"iPad3,4":  @"iPad 4(WiFi)",
      @"iPad3,5":  @"iPad 4(GSM)",
      @"iPad3,6":  @"iPad 4(GSM+CDMA)",
      
      @"iPad4,1":  @"iPad Air(WiFi)",
      @"iPad4,2":  @"iPad Air(GSM)",
      @"iPad4,3":  @"iPad Air(GSM+CDMA)",
      
      @"iPad5,3":  @"iPad Air 2 (WiFi)",
      @"iPad5,4":  @"iPad Air 2 (GSM+CDMA)",
      
      @"iPad4,4":  @"iPad Mini 2G (WiFi)",
      @"iPad4,5":  @"iPad Mini 2G (GSM)",
      @"iPad4,6":  @"iPad Mini 2G (GSM+CDMA)",
      
      @"iPad4,7":  @"iPad Mini 3G (WiFi)",
      @"iPad4,8":  @"iPad Mini 3G (GSM)",
      @"iPad4,9":  @"iPad Mini 3G (GSM+CDMA)",
      
      @"iPod1,1":  @"iPod 1st Gen",
      @"iPod2,1":  @"iPod 2nd Gen",
      @"iPod3,1":  @"iPod 3rd Gen",
      @"iPod4,1":  @"iPod 4th Gen",
      @"iPod5,1":  @"iPod 5th Gen",
      @"iPod7,1":  @"iPod 6th Gen",
      };
    
    NSString *deviceName = commonNamesDictionary[machineName];
    
    if (deviceName == nil) {
        deviceName = machineName;
    }
    
    return deviceName;
}





-(NSString*)hwi_func22_addCommaThousandWithString:(NSString*)text
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[text integerValue]]];

    
    return formatted;
}

-(NSString*)hwi_func23_getVersionOfApp
{
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    return appVersionString;
}

-(UIImage*)hwi_func24_resizeImageWithOriginImage:(UIImage*)originImage newSize:(CGSize)newSize
{
    
     UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
     [originImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
     UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     return newImage;
    
}


-(NSString*)hwi_func25_getAPNSTokenFromLocal
{
    NSUserDefaults *std = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.tiltcode"];
    NSString *token = [std objectForKey:@"HWILIB_APNS_TOKEN"];
    
    if(token)
    {
        return token;
    }
    
    return @"";
}


-(void)hwi_func25_setAPNSTokenToLocal:(NSString*)token
{
    NSUserDefaults *std = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.tiltcode"];
    if( token != nil)
    {
        [std setObject:token forKey:@"HWILIB_APNS_TOKEN"];
        [std synchronize];
    }
}

-(UIImage*)hwi_func26_imageWithImage: (UIImage*) sourceImage scaledToHeight: (float) i_height
{
    float oldHeight = sourceImage.size.height;
    float scaleFactor = i_height / oldHeight;
    
    float newWidth = sourceImage.size.width* scaleFactor;
    float newHeight = oldHeight * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



-(NSString*)hwi_func27_jsonDicToJsonString:(id)dictionaryORArray isPrettyFormat:(BOOL)isPretty
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryORArray
                                                       options:(NSJSONWritingOptions)    (isPretty ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}


/// NSString 를 NSDictionary 형태로 변환
-(id)hwi_func27_JsonStringTojsonDic:(NSString*)jsonString
{
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id values = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];  // if you are expecting  the JSON string to be in form of array else use NSDictionary instead

    return values;
}




-(NSString*)hwi_func28_makeZeroWhenSmallerThan10:(int)inputInt
{
    NSString *makedString = inputInt < 10 ? [NSString stringWithFormat:@"0%d",inputInt] :[NSString stringWithFormat:@"%d",inputInt];
    
    return makedString;
}



-(BOOL)hwi_func29_isStringEmpty:(NSString*)checkString
{
    if([[HWILib sharedObject] hwi_func17_isNULLnilWithObj:checkString])
    {
        return YES;
    }
    
    NSString *trimmedString = [self hwi_func50_trimString:checkString];
    
    if([trimmedString isEqualToString:@""])
    {
        return YES;
    }
    
    
    return NO;
}








-(BOOL)hwi_func30_isContainsStringWithLongString:(NSString*)longString word:(NSString*)word
{
    NSRange range = [longString rangeOfString:word];
    
    if(range.location == NSNotFound)
    {
        return NO;
    }
    
    return YES;
}




-(void)hwi_func31_fadeOutWithView:(UIView*)targetView complete:(void (^)(void))complete
{
    
    [UIView animateWithDuration:0.3 animations:^{
        targetView.alpha = 0;
    } completion: ^(BOOL finished) {
        
        targetView.hidden = finished;
        targetView.alpha = 1;
        if(finished)
        {
            if(complete)
            {
                complete();
            }
        }
        
        
    }];
}

-(void)hwi_func31_fadeInWithView:(UIView*)targetView complete:(void (^)(void))complete
{
    targetView.alpha = 0;
    targetView.hidden = NO;

    [UIView animateWithDuration:0.3 animations:^{
        targetView.alpha = 1;
    } completion:^(BOOL finished) {
        
        if(finished)
        {
            if(complete)
            {
                complete();
            }
        }
    }];
    
    
    
    
}





-(BOOL)hwi_func32_isScrollviewReachEnd:(UIScrollView*)scrollV
{
    CGFloat contentOffsetY = scrollV.contentOffset.y;
    
    CGFloat contentSizeY = scrollV.contentSize.height;
    
    
    /// 화면이 마지막에 다다랐을 때
    if( (contentSizeY - contentOffsetY) - 100 < scrollV.frame.size.height)
    {
        return YES;
    }
    
    return NO;
}


-(CGFloat)hwi_func33_getHeightForRatioScreen_width:(CGFloat)width height:(CGFloat)height
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    CGFloat targetHeight = screenSize.width * height / width;
    
    return targetHeight;
    
}

-(void)hwi_func34_registKeyboardShowHideDelegate:(id<HWILibDelegate>)delegate
{
    
    HWILib *singleHwiLib = [HWILib sharedObject];
    singleHwiLib.delegate = delegate;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:singleHwiLib
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:singleHwiLib
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
}



-(void)keyboardWillShow:(NSNotification*)notification
{
    HWILib *singleHwiLib = [HWILib sharedObject];
    
    NSDictionary* keyboardInfo = [notification userInfo];
    
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    CGFloat keyboardHeight = keyboardFrameBeginRect.size.height;
    
    [singleHwiLib.delegate onKeyboardShow:notification keyboardHeight:keyboardHeight];
}

-(void)keyboardWillBeHidden:(NSNotification*)notification
{
    
    NSDictionary* keyboardInfo = [notification userInfo];
    
    NSValue* keyboardFrameEnd = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameEndRect = [keyboardFrameEnd CGRectValue];
    CGFloat keyboardHeight = keyboardFrameEndRect.size.height;
    
    
    HWILib *singleHwiLib = [HWILib sharedObject];
    [singleHwiLib.delegate onKeyboardHide:notification keyboardHeight:keyboardHeight];
}


-(void)hwi_func34_removeKeyboardObserverDelegate
{
    
    HWILib *singleHwiLib = [HWILib sharedObject];
    
    [[NSNotificationCenter defaultCenter] removeObserver:singleHwiLib
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:singleHwiLib
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}









/*
- (UIViewController*)hwi_func35_getCurrentTopViewController
{
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}
*/
- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}











-(void)hwi_func36_showSelect2AlertWithTitle:(NSString*)title message:(NSString*)message yesTitle:(NSString*)yesTitle yesHandler:(void (^)(UIAlertAction *action))yesHandler noTitle:(NSString*)noTitle noHandler:(void (^)(UIAlertAction *action))noHandler vc:(UIViewController*)vc
{
    UIAlertController *alertCont = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertCont addAction:[UIAlertAction actionWithTitle:yesTitle style:UIAlertActionStyleDefault handler:yesHandler]];
    
    [alertCont addAction:[UIAlertAction actionWithTitle:noTitle style:UIAlertActionStyleCancel handler:noHandler]];
    
    [vc presentViewController:alertCont animated:YES completion:nil];
    
    
}




-(UIView*)hwi_func37_makeBlurV:(UIView*)targetView
{
    if (!UIAccessibilityIsReduceTransparencyEnabled())
    {
        targetView.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = targetView.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [targetView addSubview:blurEffectView];
        
        return blurEffectView;
    }
    else
    {
        targetView.backgroundColor = [UIColor blackColor];
    }
    return nil;
}






-(NSMutableArray*)hwi_func38_changeDicToMutableDicInArr:(NSArray*)arr
{
    NSMutableArray *returnArr = [[NSMutableArray alloc] init];
    for(int i=0; i <arr.count; i++)
    {
        NSMutableDictionary *oneDic = [NSMutableDictionary dictionaryWithDictionary:arr[i]];
        [returnArr addObject:oneDic];
    }
    
    return returnArr;
}









-(NSString*)hwi_func39_getTodayString
{
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
    
    NSInteger yearInt = [components year]; // gives you year
    NSInteger monthInt = [components month]; //gives you month
    NSInteger dayInt =[components day]; //gives you day
    
    
    
    NSString *monthString = [[HWILib sharedObject] hwi_func28_makeZeroWhenSmallerThan10:(int)monthInt];
    NSString *dayString = [[HWILib sharedObject] hwi_func28_makeZeroWhenSmallerThan10:(int)dayInt];
    
    NSString *makedDateString = [NSString stringWithFormat:@"%ld.%@.%@",((long)(yearInt)),monthString,dayString];
    
    return makedDateString;
    
    
}


-(NSString*)hwi_func40_getTodayPlusOneDayWithTimeString
{
    NSDate *now = [NSDate date];
    int daysToAdd = 1;
    NSDate *newDate1 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
    
    
    NSDate *currentDate = newDate1;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:currentDate]; // Get necessary date components
    
    NSInteger yearInt = [components year]; // gives you year
    NSInteger monthInt = [components month]; //gives you month
    NSInteger dayInt =[components day]; //gives you day
    
    NSInteger hourInt =[components hour]; //gives you hour
    NSInteger minuteInt =[components minute]; //gives you minute
    
    
    
    NSString *monthString = [[HWILib sharedObject] hwi_func28_makeZeroWhenSmallerThan10:(int)monthInt];
    NSString *dayString = [[HWILib sharedObject] hwi_func28_makeZeroWhenSmallerThan10:(int)dayInt];
    
    NSString *hourString = [[HWILib sharedObject] hwi_func28_makeZeroWhenSmallerThan10:(int)hourInt];
    NSString *minuteString = [[HWILib sharedObject] hwi_func28_makeZeroWhenSmallerThan10:(int)minuteInt];
    
    NSString *makedDateString = [NSString stringWithFormat:@"%ld.%@.%@ %@:%@",((long)(yearInt)),monthString,dayString,hourString,minuteString];
    /// 2016.09.01 17:22
    
    return makedDateString;
}







-(double)hwi_func41_getCurrentDateNumberString_year_month_day
{
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
    
    NSInteger yearInt = [components year]; // gives you year
    NSInteger monthInt = [components month]; //gives you month
    NSInteger dayInt =[components day]; //gives you day
    
    
    
    NSString *monthString = [[HWILib sharedObject] hwi_func28_makeZeroWhenSmallerThan10:(int)monthInt];
    NSString *dayString = [[HWILib sharedObject] hwi_func28_makeZeroWhenSmallerThan10:(int)dayInt];
    
    NSString *makedDateString = [NSString stringWithFormat:@"%ld%@%@",(long)yearInt,monthString,dayString];
    
    return [makedDateString doubleValue];
}

























-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    
    
    
    [manager stopUpdatingLocation];
    manager = nil;
    
    if(!func12_locationCallbackOnetimeFlag)
    {
        func12_locationCallbackOnetimeFlag = YES;
        
        [[HWILib sharedObject] hwi_func01_delayAndRun:^{
            func12_locationCallbackOnetimeFlag = NO;
        } afterDelay:1];
        
        func12_locationCallback(currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    }
    
    

}











-(NSDate*)hwi_func42_makeNSDateFromYearMonthDay_year:(int)year month:(int)month day:(int)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];

    
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    
    NSDate *date = [calendar dateFromComponents:components];
    
    return date;
}













-(NSDictionary *)hwi_func43_parseQueryString:(NSString *)query
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    for (NSString *param in [query componentsSeparatedByString:@"&"])
    {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    
    return params;
}





-(NSString*)hwi_func44_getHumanDateStringFromTimestamp:(double)timestamp
{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(timestamp / 1000)];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    

    
    NSString *dateString = [dateFormat stringFromDate:date];
    
    return dateString;
}



-(void)hwi_func45_setFontToAllWithFont:(NSString*)fontName view:(UIView*)view
{
    if(![[HWILib sharedObject] hwi_func17_isNULLnilWithObj:view.subviews] && view.subviews.count > 0 )
    {
        NSArray *subviews = view.subviews;
        
        for(int i =0; i < subviews.count; i++)
        {
            UIView *oneV = subviews[i];
            
            if([oneV isKindOfClass:[UILabel class]])
            {
                [((UILabel*)oneV) setFont:[UIFont fontWithName:fontName size:((UILabel*)oneV).font.pointSize]];
            }
            else if([oneV isKindOfClass:[UITextField class]])
            {
                
                [((UITextField*)oneV) setFont:[UIFont fontWithName:fontName size:((UITextField*)oneV).font.pointSize]];
            }
            else if([oneV isKindOfClass:[UITextView class]])
            {
                [((UITextView*)oneV) setFont:[UIFont fontWithName:fontName size:((UITextView*)oneV).font.pointSize]];
            }
            else if([oneV isKindOfClass:[UIButton class]])
            {
                [[((UIButton*)oneV) titleLabel] setFont:[UIFont fontWithName:fontName size:[((UIButton*)oneV) titleLabel].font.pointSize]];
            }
            
            [[HWILib sharedObject] hwi_func45_setFontToAllWithFont:fontName view:oneV];
        }
    }

}




-(UIViewController*)hwi_func46_getCurrentViewControllerFromSubV:(UIView*)curV
{
    id vc = [curV nextResponder];
    while(![vc isKindOfClass:[UIViewController class]] && vc!=nil)
    {
        vc = [vc nextResponder];
    }
    
    return vc;

}

-(void)hwi_func49_setLineSpacingToLabelHeightWithHeight:(CGFloat)height label:(UILabel*)label
{
    
    label.numberOfLines = 0;
    
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = height;
    style.maximumLineHeight = height;
    NSDictionary *attributtes = @{
                                  NSParagraphStyleAttributeName : style,
                                  NSFontAttributeName : label.font
                                  };
    label.attributedText = [[NSAttributedString alloc] initWithString:label.text
                                                             attributes:attributtes];
    [label sizeToFit];
    
    
}






-(NSString*)hwi_func47_getDateStringUseSNS:(double)timestamp
{
    NSDate *inputDate = [NSDate dateWithTimeIntervalSince1970:(timestamp / 1000)];
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *formatForCompare = [[NSDateFormatter alloc] init];
    [formatForCompare setDateFormat:@"yyyyMMdd"];
    
    double inputDateForCompare = [[formatForCompare stringFromDate:inputDate] doubleValue];
    double nowDateForCompare = [[formatForCompare stringFromDate:nowDate] doubleValue];
    
    NSDateFormatter *returnFormatter = [[NSDateFormatter alloc] init];
    
    
    if(inputDateForCompare == nowDateForCompare)
    {
        /// 같은 날짜일 경우.
        
        /// 시간 / 분 / 초 를 비교하기 시작한다.
        NSDateFormatter *hourCompareFormatter = [[NSDateFormatter alloc] init];
        [hourCompareFormatter setDateFormat:@"HHmmss"];
        
        inputDateForCompare = [[hourCompareFormatter stringFromDate:inputDate] doubleValue];
        nowDateForCompare = [[hourCompareFormatter stringFromDate:nowDate] doubleValue];
        
        
        double gapOfTime = (nowDateForCompare - inputDateForCompare);
        
        if( gapOfTime >=10000 )
        {
            /// 시간차가 날 경우
            
            int hourGap = (int)(gapOfTime / 10000);
            return [NSString stringWithFormat:@"%d시간 전",hourGap];
            
        }
        else if( gapOfTime >= 100 )
        {
            /// 분 차가 날 경우
            int minuteGap = (int)(gapOfTime / 100);
            return [NSString stringWithFormat:@"%d분 전",minuteGap];
        }
        else
        {
            /// 초 차가 날 경우
            int secondGap = (int)gapOfTime;
            return [NSString stringWithFormat:@"%d초 전",secondGap];
        }
        
        
    }
    else
    {
        /// 다른 날짜의 경우
        
        
        [returnFormatter setDateFormat:@"yyyy.MM.dd"];
        
        return [returnFormatter stringFromDate:inputDate];
    }
    
    /*
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    */
    
    
    
}





-(NSString*)hwi_func50_trimString:(NSString*)originString
{
    if([[HWILib sharedObject] hwi_func17_isNULLnilWithObj:originString])
    {
        return @"";
    }
    
    NSString *trimmedString = [originString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return trimmedString;
}


-(void)hwi_func51_setBackgroundColorToGradientWithStartColor:(UIColor*)startColor endColor:(UIColor*)endColor targetView:(UIView*)targetView
{
    [[HWILib sharedObject] hwi_func01_delayAndRun:^{
        CAGradientLayer *gradient = [CAGradientLayer layer];
        
        gradient.frame = targetView.bounds;
        gradient.colors = @[(id)startColor.CGColor, (id)endColor.CGColor];
        [gradient setName:@"HWI_GRADIENT"];
        
        [gradient setStartPoint:CGPointMake(0, 0.5)];
        [gradient setEndPoint:CGPointMake(1, 0.5)];
        
       
        
        for(CALayer *layer in targetView.layer.sublayers)
        {
            if([[layer name] isEqualToString:@"HWI_GRADIENT"])
            {
                [layer removeFromSuperlayer];
                break;
            }
        }
        
        
        [targetView.layer insertSublayer:gradient atIndex:0];
        
        
    } afterDelay:0.01];
    
}


-(void)hwi_func52_printAllAvailableFonts
{
    NSLog(@"========================    사용가능한 폰트 출력 =========================");
    NSArray *fontFamilies = [UIFont familyNames];
    
    for (int i = 0; i < [fontFamilies count]; i++)
    {
        NSString *fontFamily = [fontFamilies objectAtIndex:i];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
        NSLog (@"%@: %@", fontFamily, fontNames);
    }
    NSLog(@"");
    NSLog(@"");

}


-(void)hwi_func53_showLocalNotificationWithTitle:(NSString*)title subtitle:(NSString*)subtitle body:(NSString*)body identifier:(NSString*)identifier delayTime:(double)delayTime delegate:(id<UNUserNotificationCenterDelegate>)delegate
{
    UNMutableNotificationContent *notiContent = [[UNMutableNotificationContent alloc] init];
    
    if(title)
    {
        [notiContent setTitle:title];
    }
    
    if(subtitle)
    {
        [notiContent setSubtitle:subtitle];
    }
    
    if(body)
    {
        [notiContent setBody:body];
    }
    else
    {
        NSLog(@"  ========   >      예외발생    < =====  바디를 셋팅하지 않으면 노티피케이션이 작동하지 않습니다!!");
    }
    
    [notiContent setSound:[UNNotificationSound defaultSound]];
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:delayTime repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"HWILocalNotiID" content:notiContent trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] setDelegate:delegate];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
}

-(NSString*)hwi_func54_getMinutesAndSecondFromSecVal:(double)seconds
{
    if(  seconds <= 0)
    {
        return @"00:00";
    }
    
    double minutesForOutput = seconds / 60;
    double secondsForOutput = ((int)(seconds)) % 60;
    
    NSString *minutesForOutputStr = [[HWILib sharedObject] hwi_func28_makeZeroWhenSmallerThan10:((int)(minutesForOutput))];
    NSString *secondsForOutputStr = [[HWILib sharedObject] hwi_func28_makeZeroWhenSmallerThan10:((int)(secondsForOutput))];
    
    return [NSString stringWithFormat:@"%@:%@",minutesForOutputStr,secondsForOutputStr];
    
    
}


-(UIImage *)hwi_func55_makeImageFromUIView:(UIView*)fromView
{
    
    UIGraphicsBeginImageContextWithOptions(fromView.bounds.size, fromView.opaque, 0.0);
    [fromView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
    
    
}


-(void)hwi_func56_performTTS:(NSString*)text langCode:(NSString*)langCode utteranceRate:(CGFloat)utteranceRate
{
    
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    
    
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc]init];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    [utterance setVoice:[AVSpeechSynthesisVoice voiceWithLanguage:langCode]];
    
    
    [utterance setRate:utteranceRate];
    [synthesizer speakUtterance:utterance];
    
    /*  지원가능 속도
     NSLog(@"AVSpeechUtteranceMinimumSpeechRate : %f",AVSpeechUtteranceMinimumSpeechRate);
     NSLog(@"AVSpeechUtteranceDefaultSpeechRate : %f",AVSpeechUtteranceDefaultSpeechRate);
     NSLog(@"AVSpeechUtteranceMaximumSpeechRate : %f",AVSpeechUtteranceMaximumSpeechRate);
     */
    
    
    /*  지원가능 언어목록
     Arabic (Saudi Arabia) - ar-SA
     Chinese (China) - zh-CN
     Chinese (Hong Kong SAR China) - zh-HK
     Chinese (Taiwan) - zh-TW
     Czech (Czech Republic) - cs-CZ
     Danish (Denmark) - da-DK
     Dutch (Belgium) - nl-BE
     Dutch (Netherlands) - nl-NL
     English (Australia) - en-AU
     English (Ireland) - en-IE
     English (South Africa) - en-ZA
     English (United Kingdom) - en-GB
     English (United States) - en-US
     Finnish (Finland) - fi-FI
     French (Canada) - fr-CA
     French (France) - fr-FR
     German (Germany) - de-DE
     Greek (Greece) - el-GR
     Hindi (India) - hi-IN
     Hungarian (Hungary) - hu-HU
     Indonesian (Indonesia) - id-ID
     Italian (Italy) - it-IT
     Japanese (Japan) - ja-JP
     Korean (South Korea) - ko-KR
     Norwegian (Norway) - no-NO
     Polish (Poland) - pl-PL
     Portuguese (Brazil) - pt-BR
     Portuguese (Portugal) - pt-PT
     Romanian (Romania) - ro-RO
     Russian (Russia) - ru-RU
     Slovak (Slovakia) - sk-SK
     Spanish (Mexico) - es-MX
     Spanish (Spain) - es-ES
     Swedish (Sweden) - sv-SE
     Thai (Thailand) - th-TH
     Turkish (Turkey) - tr-TR
     */
     
}
@end
