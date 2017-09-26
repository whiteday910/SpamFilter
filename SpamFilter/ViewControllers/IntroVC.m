//
//  IntroVC.m
//  SpamFilter
//
//  Created by hwi on 2017. 9. 27..
//  Copyright © 2017년 hwi. All rights reserved.
//

#import "IntroVC.h"


@implementation IntroVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[HWILib sharedObject] hwi_func01_delayAndRun:^{
        
        [self performSegueWithIdentifier:@"seg_intro_main" sender:self];
        
    } afterDelay:1.0];
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
