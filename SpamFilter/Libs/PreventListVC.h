//
//  PreventListVC.h
//  SpamFilter
//
//  Created by hwi on 2017. 9. 21..
//  Copyright © 2017년 hwi. All rights reserved.
//

#import "BaseVC.h"

@interface PreventListVC : BaseVC< UITableViewDataSource, UITableViewDelegate, GADNativeExpressAdViewDelegate>

typedef NS_ENUM(NSInteger, VCMode) {
    VCModeKeyword,
    VCModeNumber
};

typedef NS_ENUM(NSInteger, KeywordVCContentMode) {
    KeywordVCContentModeEmpty,
    KeywordVCContentModeList
};


@property VCMode curVCMode;
@property (weak, nonatomic) IBOutlet UIView *view00_admob;
@property (weak, nonatomic) IBOutlet UIView *view01_01_empty;
@property (weak, nonatomic) IBOutlet UIView *view01_02_list;
@property (weak, nonatomic) IBOutlet UITableView *tableview01_content;

@property NSMutableArray *arr01_list;

@end
