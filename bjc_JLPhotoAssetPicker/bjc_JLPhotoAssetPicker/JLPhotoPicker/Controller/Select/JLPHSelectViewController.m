//
//  JLPHSelectViewController.m
//  bjc_JLPhotoAssetPicker
//
//  Created by L on 2019/3/6.
//  Copyright © 2019 L. All rights reserved.
//

#import "JLPHSelectViewController.h"
#import "JLPHPickerHeader.h"


static NSString *JLPH_CellIdentifier = @"JLPH_CellIdentifier";
CGFloat jl_flowlayoutSpacing = 5.0;

@interface JLPHotoSelectCell :UICollectionViewCell
@property (nonatomic, strong) JLPHAlbumModel *albumModel;
@property (nonatomic, strong) UIImageView * photoImageView;
@property (nonatomic, strong) UIButton * markBtn;
@property (nonatomic, strong) UILabel * seletLabel;
@property (nonatomic, strong) UIImageView * markImageLogo;

@end

@implementation JLPHotoSelectCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.photoImageView];
        [self addSubview:self.markBtn];
        [self addSubview:self.markImageLogo];
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
- (void)markAction:(id)mark{
    
}
#pragma mark - lazy loading
- (UIButton *)markBtn{
    if (!_markBtn) {
        _markBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _markBtn.frame = CGRectMake(jl_flowlayoutWidth - 40, 0, 40, 40);
        [_markBtn addTarget:self action:@selector(markAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.markBtn addSubview:self.seletLabel];
    }
    return _markBtn;
}
- (UILabel *)seletLabel{
    if (!_seletLabel) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 20, 20)];
        label.textColor = [UIColor redColor];
        label.backgroundColor = [UIColor brownColor];
        label.font = [UIFont systemFontOfSize:12.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"1";
        _seletLabel = label;
    }
    return _seletLabel;
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
- (UIImageView *)markImageLogo{
    if (!_markImageLogo) {
        _markImageLogo = [[UIImageView alloc]init];
        _markImageLogo.frame = CGRectMake(jl_flowlayoutWidth - 30, jl_flowlayoutWidth - 22, 30, 20);
        _markImageLogo.image = [UIImage imageNamed:@"gif图标"];
    }
    return _markImageLogo;
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
        _flowLayout.itemSize  = jl_flowlayoutItemSize;
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
