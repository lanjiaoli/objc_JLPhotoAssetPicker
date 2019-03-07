//
//  JLPHSelectViewController.m
//  bjc_JLPhotoAssetPicker
//
//  Created by L on 2019/3/6.
//  Copyright © 2019 L. All rights reserved.
//

#import "JLPHSelectViewController.h"
#import "JLPhotoPickerHeader.h"

static NSString *JLPH_CellIdentifier = @"JLPH_CellIdentifier";

@interface JLPHSelectViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation JLPHSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:JLPH_CellIdentifier];
}
#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource,
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JLPH_CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor brownColor];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
#pragma mark -
#pragma mark - lazy loading
-(UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.itemSize  = CGSizeMake((SCREEN_WIDTH - 25)/3.0, (SCREEN_WIDTH - 25)/3.0);
        _flowLayout.minimumLineSpacing = 5;
        _flowLayout.minimumInteritemSpacing = 5;
        _flowLayout.sectionInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    }
    return _flowLayout;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
    }
    return _collectionView;
}

@end
