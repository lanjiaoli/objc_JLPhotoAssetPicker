//
//  JLPHPreviewController.m
//  bjc_JLPhotoAssetPicker
//
//  Created by L on 2019/3/6.
//  Copyright © 2019 L. All rights reserved.
//

#import "JLPHPreviewController.h"
#import "JLPHPickerHeader.h"
#import "JLPHCollectionViewFlowLayout.h"
#import "JLPHPreviewCollectionViewCell.h"

static NSString * jl_previewCellIdentifier = @"jl_previewCellIdentifier";

@interface JLPHPreviewController ()<UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView * backgroundCollectionView;
@property (nonatomic, strong) UIPageControl * pageControl;
@end

@implementation JLPHPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUIConfig];
}
#pragma mark - UI Config
- (void)setUIConfig{
    [self.view addSubview:self.backgroundCollectionView];
    [self.view addSubview:self.pageControl];
    self.navigationController.delegate = self;
    [self.backgroundCollectionView registerClass:JLPHPreviewCollectionViewCell.class forCellWithReuseIdentifier:jl_previewCellIdentifier];
}
#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JLPHPreviewCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:jl_previewCellIdentifier forIndexPath:indexPath];
    cell.albumModel = self.albumModel;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

#pragma mark - UINavigationControllerDelegate
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    BOOL isSelf = [viewController isKindOfClass:self.class];
//    [self.navigationController setNavigationBarHidden:isSelf animated:animated];
//}
#pragma mark -
#pragma mark - lazy loading
- (UICollectionView *)backgroundCollectionView{
    if (!_backgroundCollectionView) {
        JLPHCollectionViewFlowLayout *flowLayout = [[JLPHCollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        flowLayout.minimumLineSpacing = 5.0;
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)collectionViewLayout:flowLayout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsVerticalScrollIndicator = false;
        collectionView.showsHorizontalScrollIndicator = false;
        collectionView.pagingEnabled = YES;
        _backgroundCollectionView = collectionView;
    }
    return _backgroundCollectionView;
}
- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 30 - SafeAreaBottomHeight, SCREEN_WIDTH, 30)];
        _pageControl.tintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor groupTableViewBackgroundColor];
        _pageControl.numberOfPages = 9;
    }
    return _pageControl;
}
@end
