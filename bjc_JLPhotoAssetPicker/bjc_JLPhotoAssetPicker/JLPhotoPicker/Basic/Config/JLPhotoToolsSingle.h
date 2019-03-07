//
//  JLPhotoToolsSingle.h
//  bjc_JLPhotoAssetPicker
//
//  Created by L on 2019/3/6.
//  Copyright © 2019 L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "JLPhotoPickerHeader.h"
#import "JLPhotoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLPhotoToolsSingle : NSObject
+ (JLPhotoToolsSingle *_Nullable)shareSingleton;
/**
 获取相册所有资源
 
 @_Nullablereturn PHAsset对象
 */
-(NSMutableArray*_Nullable)jl_getAllPhotoAssetsResource;
/**
 获取相册里的所有图片的PHAsset对象
 
 @param assetCollection 相册集合
 @param ascending asscending
 @return 获取相册PHAsset对象
 */
- (NSArray *_Nullable)jl_getAllPhotosAssetInAblumCollection:(PHAssetCollection *_Nullable)assetCollection
                                                  ascending:(BOOL)ascending;
/**
 根据PHAsset获取图片信息
 
 @param asset PHAsset对象
 @param size 图片大小
 @param resizeMode PHImageRequestOptionsResizeMode
 @param completion 完成回调
 */
- (void)jl_accessToImageAccordingToTheAsset:(PHAsset *_Nullable)asset
                                       size:(CGSize)size
                                 resizeMode:(PHImageRequestOptionsResizeMode)resizeMode
                                 completion:(void(^_Nullable)(UIImage * _Nullable image,NSDictionary * _Nullable info))completion;
/**
 获取相册里的所有图片的PHAsset对象
 */
- (void)jl_getAllPhotoCollection;

/**
 第一次进入图片选择获取相册胶卷相册图片
 
 @param completion 完成回调
 */
- (void)jl_firstGetPhotoAblumlistComplete:(void(^_Nullable)
                                           (JLPhotoModel * _Nonnull assetModel,
                                                            NSDictionary * _Nonnull info))completion;

/**
 获取视频资源
 
 @param asset PHAsset
 @param resultHandler resultHandler
 */
- (void)jl_fetchViewResorurceFromAsset:(PHAsset *_Nonnull)asset
                         resultHandler:(void (^_Nullable)
                                        (AVAsset *__nullable asset,
                                         AVAudioMix *__nullable audioMix,
                                         NSDictionary *__nullable info))resultHandler;
/**
 ///删除选中状态后 选中的下标重新赋值
 
 @param photoModel 删除的Model
 */
- (void)removeAlbumPhotoModel:(JLPhotoModel *_Nullable)photoModel;

#pragma mark 获取原图
/**
 获取原图
  @return
 */
- (PHImageRequestID)jl_getOriginalPhotoDataWithAsset:(PHAsset *_Nullable)asset
                                       completion:(void (^_Nonnull)(NSData * _Nullable data,
                                                                    NSDictionary * _Nonnull info,
                                                                    BOOL isDegraded))completion;

#pragma mark -
#pragma mark  权限判断
/**
 相册权限
 
 */
- (void)jl_fetchAlbumAuthor:(void(^ _Nonnull)(BOOL status))commplete;


/**
 相机权限
 
 @return BOOL
 */
- (BOOL)jl_cameraAuthorStatus;

#pragma mark - 图片上传
- (void)jl_transitionImageDataCompressionFlag:(BOOL)flag
                                  complete:(void (^_Nonnull)(NSArray * _Nullable dataArray))complete;

@end

NS_ASSUME_NONNULL_END
