//
//  JLPhotoModel.h
//  bjc_JLPhotoAssetPicker
//
//  Created by L on 2019/3/6.
//  Copyright © 2019 L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@class JLPHAlbumModel;

typedef  NS_ENUM(NSUInteger,JLPHAssetlMediaType){
    JLPHAssetMediaTypePhoto          = 0,    //!< 照片
    JLPHAssetMediaTypeLivePhoto      = 1,    //!< LivePhoto
    JLPHAssetMediaTypePhotoGIF      = 2,    //!< gif图
    JLPHAssetMediaTypeVideo          = 3,    //!< 视频
    JLPHAssetMediaTypeAudio          = 4,    //!< 预留
    JLPHAssetMediaTypeCameraPhoto    = 5,    //!< 通过相机拍的照片
    JLPHAssetMediaTypeCameraVideo    = 6,    //!< 通过相机录制的视频
    JLPHAssetMediaTypeCamera         = 7     //!< 跳转相机
};
NS_ASSUME_NONNULL_BEGIN

//相册列表
@interface JLPhotoModel : NSObject
@property (nonatomic, copy) NSString *photoAssetName; //相册名称
@property (nonatomic, assign) NSInteger count;        //相册图片数量
/**
 封面Asset
 */
@property (strong, nonatomic) PHAsset *lastAsset;
/**
 照片集合对象
 */
@property (strong, nonatomic) PHFetchResult *result;
/**相册照片集合*/
@property (strong, nonatomic) NSMutableArray  <JLPHAlbumModel *> *albumPhotoList;
/**  当前视图  */
@property (strong, nonatomic) UIImage *image;
@end

///相片列表
NS_ASSUME_NONNULL_END
@interface JLPHAlbumModel : NSObject
@property (strong, nonatomic) PHAsset * _Nullable asset;
/**  当前照片所在相册的名称 */
@property (copy, nonatomic) NSString * _Nullable albumName;
/**  视频时长 */
@property (copy, nonatomic) NSString * _Nullable videoTime;
/**  照片类型  */
@property (assign, nonatomic) JLPHAssetlMediaType type;
/**  是否iCloud上的资源  */
@property (nonatomic, assign) BOOL isICloud;
/**  选择的下标 */
@property (assign, nonatomic) NSInteger selectedIndex;
/**  是否选中 */
@property (assign, nonatomic) BOOL selected;
/**图片原始尺寸*/
@property (nonatomic, assign) NSUInteger pixelWidth;
@property (nonatomic, assign) NSUInteger pixelHeight;
/**  预览当前的图片 */
@property (assign, nonatomic) BOOL previewSelect;

/**  选择列表根据size确定  */
@property (strong, nonatomic) UIImage * _Nullable image;
/**大图*/
@property (strong, nonatomic) UIImage * _Nullable orgImage;

- (void)getNewTimeFromDurationSecond:(NSInteger)duration;

/** 图片上传的url */
@property (nonatomic, copy) NSString *_Nonnull pictureUrlPath;

@end


@interface JLPHDataModel : NSObject

@property (nonatomic, copy)     NSString * _Nullable fileName;

@property (nonatomic, strong)   NSData * _Nullable imageData;

@property (nonatomic, assign)   BOOL gifFlag;
@end
