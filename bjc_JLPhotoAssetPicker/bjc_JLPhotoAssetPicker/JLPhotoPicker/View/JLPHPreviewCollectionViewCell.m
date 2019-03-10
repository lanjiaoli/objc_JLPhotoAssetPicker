//
//  JLPHPreviewCollectionViewCell.m
//  bjc_JLPhotoAssetPicker
//
//  Created by L on 2019/3/10.
//  Copyright © 2019 L. All rights reserved.
//

#import "JLPHPreviewCollectionViewCell.h"
#import "JLPHPickerHeader.h"

@interface JLPHPreviewCollectionViewCell()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollerView;
@property (nonatomic , strong) UIImageView *assetImageView;
@end
@implementation JLPHPreviewCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.scrollerView];
        [self.scrollerView addSubview:self.assetImageView];
    }
    return self;
}
- (void)setAlbumModel:(JLPHAlbumModel *)albumModel{
    _albumModel = albumModel;
    self.assetImageView.frame = albumModel.previewCellFrame;
    __weak typeof(self) weakSelf = self;
    [[JLPhotoToolsSingle shareSingleton]jl_accessToImageAccordingToTheAsset:albumModel.asset
                                                                       size:albumModel.previewCellFrame.size
                                                                 resizeMode:(PHImageRequestOptionsResizeModeFast)
                                                                 completion:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
                                       
                                                                     weakSelf.assetImageView.image = image;
                                   
                                                                 }];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    [scrollView setZoomScale:scale animated:NO];

}
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.assetImageView;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view{
    
}

#pragma mark - lazy loading
- (UIScrollView *)scrollerView {
    if (!_scrollerView) {
        _scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollerView.delegate = self;
        [_scrollerView setMaximumZoomScale:3.0f];
        [_scrollerView setMinimumZoomScale:0.5f];
    }
    return _scrollerView;
}

- (UIImageView *)assetImageView{
    if (!_assetImageView) {
        _assetImageView = [[UIImageView alloc]init];
    }
    return _assetImageView;
}
@end
