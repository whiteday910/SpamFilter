//
//  RequiredSettingGuideVC.m
//  SpamFilter
//
//  Created by hwi on 2017. 9. 21..
//  Copyright © 2017년 hwi. All rights reserved.
//

#import "RequiredSettingGuideVC.h"
#import "RequiredSettingGuideCell.h"

@implementation RequiredSettingGuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.arr01_guide = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *oneGuideContent;
    
    oneGuideContent = [[NSMutableDictionary alloc] init];
    [oneGuideContent setObject:@"guide01" forKey:@"imageName"];
    [oneGuideContent setObject:@"'메시지'\n항목을 설정에서 찾아주세요" forKey:@"guideText"];
    [self.arr01_guide addObject:oneGuideContent];
    
    oneGuideContent = [[NSMutableDictionary alloc] init];
    [oneGuideContent setObject:@"guide02" forKey:@"imageName"];
    [oneGuideContent setObject:@"'알 수 없는 연락처 및 스팸'\n항목을 찾아주세요" forKey:@"guideText"];
    [self.arr01_guide addObject:oneGuideContent];
    
    oneGuideContent = [[NSMutableDictionary alloc] init];
    [oneGuideContent setObject:@"guide03" forKey:@"imageName"];
    [oneGuideContent setObject:@"'SPAM BLOCK'\n항목을 활성화 해주세요" forKey:@"guideText"];
    [self.arr01_guide addObject:oneGuideContent];
    
    
    [self.pagecontrol01_guide setNumberOfPages:[self.arr01_guide count]];
    
    
    [[HWILib sharedObject] hwi_func01_delayAndRun:^{
        self.size01_sizeOfCell = self.collectionview01_content.frame.size;
        [self.collectionview01_content reloadData];
    } afterDelay:0.05];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 컬렉션뷰 델리깃

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arr01_guide.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RequiredSettingGuideCell *oneCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RequiredSettingGuideCell" forIndexPath:indexPath];
    
    NSDictionary *oneDic = self.arr01_guide[indexPath.row];
    [oneCell.imageview01_content setImage:[UIImage imageNamed:oneDic[@"imageName"]]];
    return oneCell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.size01_sizeOfCell.width != 0)
    {
        return self.size01_sizeOfCell;
    }
    else
    {
        
        return CGSizeMake(0, 0);
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
     NSInteger currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self.pagecontrol01_guide setCurrentPage:currentPage];
    
    NSDictionary *curDic = self.arr01_guide[currentPage];
    
    [self.label01_guideText setText:curDic[@"guideText"]];
    
}

- (IBAction)onOpenSettingBtnTouchUpInside:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
}

@end

