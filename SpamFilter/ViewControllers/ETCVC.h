//
//  ETCVC.h
//  SpamFilter
//
//  Created by hwi on 2017. 9. 21..
//  Copyright © 2017년 hwi. All rights reserved.
//

#import "BaseVC.h"

@interface ETCVC : BaseVC <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
@property NSMutableArray *arr01_menu;
@property (weak, nonatomic) IBOutlet UITableView *tableview01_content;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *const01_tableviewHeight;

@end
