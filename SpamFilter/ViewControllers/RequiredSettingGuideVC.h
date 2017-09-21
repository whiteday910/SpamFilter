//
//  RequiredSettingGuideVC.h
//  SpamFilter
//
//  Created by hwi on 2017. 9. 21..
//  Copyright © 2017년 hwi. All rights reserved.
//

#import "BaseVC.h"

@interface RequiredSettingGuideVC : BaseVC <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property CGSize size01_sizeOfCell;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview01_content;
@property (weak, nonatomic) IBOutlet UIPageControl *pagecontrol01_guide;
@property (weak, nonatomic) IBOutlet UILabel *label01_guideText;


@property NSMutableArray *arr01_guide;

@end
