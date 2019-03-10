//
//  JLPHPreviewCollectionViewCell.h
//  bjc_JLPhotoAssetPicker
//
//  Created by L on 2019/3/10.
//  Copyright © 2019 L. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JLPHAlbumModel;
NS_ASSUME_NONNULL_BEGIN

@interface JLPHPreviewCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) JLPHAlbumModel *albumModel;
@end

NS_ASSUME_NONNULL_END
