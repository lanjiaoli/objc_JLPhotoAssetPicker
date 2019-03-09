//
//  JLPHSelectViewController.m
//  bjc_JLPhotoAssetPicker
//
//  Created by L on 2019/3/6.
//  Copyright © 2019 L. All rights reserved.
//

#import "JLPHSelectViewController.h"
#import "JLPHPickerHeader.h"

#define jl_flowlayoutWidth ((SCREEN_WIDTH - 25)/3.0)

static NSString *JLPH_CellIdentifier = @"JLPH_CellIdentifier";
CGFloat jl_flowlayoutSpacing = 5.0;

@interface JLPHotoSelectCell :UICollectionViewCell
@property (nonatomic, strong) JLPHAlbumModel *albumModel;
@property (nonatomic, strong) UIImageView * photoImageView;

@end

@implementation JLPHotoSelectCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.photoImageView];
    }
    return self;
}
- (void)setAlbumModel:(JLPHAlbumModel *)albumModel{
    _albumModel = albumModel;
    if (albumModel.image !=nil) {
        self.photoImageView.image = albumModel.image;
    }else{
        __weak typeof(self) weak_self = self;
        [[JLPhotoToolsSingle shareSingleton]jl_accessToImageAccordingToTheAsset:albumModel.asset size:self.frame.size resizeMode:(PHImageRequestOptionsResizeModeFast) completion:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        weak_self.photoImageView.image = image;
        weak_self.albumModel.image = image;
    
        }];
    }
}


- (UIImageView *)photoImageView{
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc]init];
        _photoImageView.frame = CGRectMake(0, 0, jl_flowlayoutWidth, jl_flowlayoutWidth);
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.clipsToBounds = YES;
    }
    return _photoImageView;
}


@end


@interface JLPHSelectViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation JLPHSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:JLPHotoSelectCell.class forCellWithReuseIdentifier:JLPH_CellIdentifier];
}
#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource,
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JLPHotoSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JLPH_CellIdentifier forIndexPath:indexPath];
    JLPHAlbumModel *albumModel = self.photoModel.albumPhotoList[indexPath.item];
    cell.albumModel = albumModel;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoModel.albumPhotoList.count;
}
#pragma mark -
#pragma mark - lazy loading
-(UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.itemSize  = CGSizeMake(jl_flowlayoutWidth, jl_flowlayoutWidth);
        _flowLayout.minimumLineSpacing = jl_flowlayoutSpacing;
        _flowLayout.minimumInteritemSpacing = jl_flowlayoutSpacing;
        _flowLayout.sectionInset = UIEdgeInsetsMake(jl_flowlayoutSpacing, jl_flowlayoutSpacing, jl_flowlayoutSpacing, jl_flowlayoutSpacing);
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
