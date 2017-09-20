//
//  CustomNaviCont.m
//  SpamFilter
//
//  Created by hwi on 2017. 9. 21..
//  Copyright © 2017년 hwi. All rights reserved.
//

#import "CustomNaviCont.h"


@implementation CustomNaviCont

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : getColorWithHex(0x5B6BAF)}];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
