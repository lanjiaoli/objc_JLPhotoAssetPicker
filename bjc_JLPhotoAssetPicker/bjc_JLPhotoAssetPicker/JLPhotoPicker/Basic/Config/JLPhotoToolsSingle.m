//
//  JLPhotoToolsSingle.m
//  bjc_JLPhotoAssetPicker
//
//  Created by L on 2019/3/6.
//  Copyright © 2019 L. All rights reserved.
//

#import "JLPhotoToolsSingle.h"
NSString * jl_deleteAlbumName = @"最近删除";
NSString * jl_gifIdentifier = @".gif";
@interface JLPhotoToolsSingle()
@property (nonatomic , strong) NSLock *jl_lock;
@end
@implementation JLPhotoToolsSingle

+ (JLPhotoToolsSingle *_Nullable)shareSingleton{
    static JLPhotoToolsSingle *single = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [[JLPhotoToolsSingle alloc]init];
    });
    return single;
}
- (void)setConfig:(JLPHPickerConfig *)config{
    _config = config;
    [_config.allAlbamlists removeAllObjects];
    [self jl_getAllPhotoCollection];
}

-(NSMutableArray*_Nullable)jl_getAllPhotoAssetsResource {
    NSMutableArray *arr = [NSMutableArray array];
    // 所有智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (NSInteger i = 0; i < smartAlbums.count; i++) {
        // 是否按创建时间排序
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        PHCollection *collection = smartAlbums[i];
        //遍历获取相册
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            if ([collection.localizedTitle isEqualToString:@"相机胶卷"]||[collection.localizedTitle isEqualToString:@"所有照片"]) {
                PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
                
                NSArray *assets;
                if (fetchResult.count > 0) {
                    // 某个相册里面的所有PHAsset对象
                    assets = [self jl_getAllPhotosAssetInAblumCollection:assetCollection
                                                               ascending:YES ];
                    [arr addObjectsFromArray:assets];
                }
            }
        }
    }
    //返回相机胶卷内的所有照片
    return arr;
}

#pragma mark - <  获取相册里的所有图片的PHAsset对象  >
- (NSArray *)jl_getAllPhotosAssetInAblumCollection:(PHAssetCollection *)assetCollection
                                         ascending:(BOOL)ascending
{
    // 存放所有图片对象
    NSMutableArray *assets = [NSMutableArray array];
    
    // 是否按创建时间排序
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    
    // 获取所有图片对象
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
    // 遍历
    [result enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
        [assets addObject:asset];
    }];
    return assets;
}


#pragma mark - <  根据PHAsset获取图片信息  >
- (void)jl_accessToImageAccordingToTheAsset:(PHAsset *)asset
                                       size:(CGSize)size
                                 resizeMode:(PHImageRequestOptionsResizeMode)resizeMode
                                 completion:(void(^)(UIImage *image,NSDictionary *info))completion
{
    CGFloat photoWidth = size.width;
    CGSize imageSize;
    CGFloat margin = 4;
    CGFloat itemWH = (SCREEN_WIDTH - 2 * margin - 4) / 4.0 - margin;
    // 测试发现，如果scale在plus真机上取到3.0，内存会增大特别多。故这里写死成2.0
    CGFloat screenScale = 2.0;
    if (SCREEN_WIDTH > 700) {
        screenScale = 1.5;
    }
    CGSize AssetGridThumbnailSize = CGSizeMake(itemWH * screenScale, itemWH * screenScale);
    if (photoWidth < SCREEN_WIDTH/* && photoWidth < _photoPreviewMaxWidth*/) {
        imageSize = AssetGridThumbnailSize;
    } else {
        PHAsset *phAsset = (PHAsset *)asset;
        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
        CGFloat pixelWidth = photoWidth * screenScale * 1.5;
        // 超宽图片
        if (aspectRatio > 1.8) {
            pixelWidth = pixelWidth * aspectRatio;
        }
        // 超高图片
        if (aspectRatio < 0.2) {
            pixelWidth = pixelWidth * 0.5;
        }
        CGFloat pixelHeight = pixelWidth / aspectRatio;
        imageSize = CGSizeMake(pixelWidth, pixelHeight);
    }
    __block UIImage *image;
    // 修复获取图片时出现的瞬间内存过高问题
    // 下面两行代码，来自hsjcom，他的github是：https://github.com/hsjcom 表示感谢
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    int32_t imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage *result, NSDictionary *info) {
        if (result) {
            image = result;
        }
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && result) {
            //            result = [self fixOrientation:result];
            if (completion) completion(result,info);
        }     // Download image from iCloud / 从iCloud下载图片
        if ([info objectForKey:PHImageResultIsInCloudKey] && !result) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
                
            };
            options.networkAccessAllowed = YES;
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                UIImage *resultImage = [UIImage imageWithData:imageData];
                
                if (!resultImage) {
                    resultImage = image;
                }
                if (completion) completion(resultImage,info);
            }];
        }
    }];
    
}
/**获取相册里的所有图片的PHAsset对象*/
- (void)jl_getAllPhotoCollection{
    
    ///系统相册
    [self jl_fetchAssetCollectionsWithType:(PHAssetCollectionTypeSmartAlbum)];
    
    ///应用创建的相册
    [self jl_fetchAssetCollectionsWithType:(PHAssetCollectionTypeAlbum)];
    
}
#pragma mark - 获取某个资源相册
- (void)jl_fetchAssetCollectionsWithType:(PHAssetCollectionType)type{
    
    PHFetchResult *assetCollection = [PHAssetCollection fetchAssetCollectionsWithType:type
                                            subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                               options:nil];
    __weak typeof(self) weakS = self;
    [assetCollection enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakS.jl_lock lock];
        @autoreleasepool {
            // 是否按创建时间排序
            PHFetchOptions *option = [[PHFetchOptions alloc] init];
            // 照片列表是否按照片日期排序
            option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
            PHAssetCollection *assetCollection = (PHAssetCollection *)obj;
            
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection
                                                                       options:option];
            //过滤空相册
            if (fetchResult.count > 0) {
                JLPhotoModel *photoModel = [[JLPhotoModel alloc]init];
                photoModel.photoAssetName = assetCollection.localizedTitle;
                photoModel.count = fetchResult.count;
                photoModel.result = fetchResult;
                photoModel.lastAsset = fetchResult.lastObject;
                [weakS jl_enumerateObjectsWithFetchResult:fetchResult photoModel:photoModel];
              
                if (type == PHAssetCollectionTypeAlbum) {
                    [weakS.config.allAlbamlists addObject:photoModel];
                }else{
                    
                    if (![assetCollection.localizedTitle isEqualToString:jl_deleteAlbumName]||
                        ![assetCollection.localizedTitle isEqualToString:@"Deleted"]) {
                        //过滤最近删除的相册资源
                        [weakS.config.allAlbamlists addObject:photoModel];
                    }
                }
                
            }
        }
        [weakS.jl_lock unlock];

        
        }];
}

- (void)jl_enumerateObjectsWithFetchResult:(PHFetchResult *)fetchResult
                   photoModel:(JLPhotoModel * )photoModel{
    __weak typeof(self) weakS = self;
    [fetchResult enumerateObjectsWithOptions:NSEnumerationReverse
                                  usingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop)
    {
        @autoreleasepool {
            JLPHAlbumModel *albumModel = [[JLPHAlbumModel alloc]init];
            albumModel.albumName = photoModel.photoAssetName;
            albumModel.asset = asset;
            albumModel.pixelHeight = asset.pixelHeight;
            albumModel.pixelWidth = asset.pixelWidth;
            [albumModel calculateCellFrame];
            [weakS jl_accessToImageAccordingToTheAsset:asset size:jl_flowlayoutItemSize
                                            resizeMode:(PHImageRequestOptionsResizeModeFast)
                                            completion:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
                                                albumModel.image = image;
                                            }];
            albumModel.isICloud = [[asset valueForKey:@"isCloudPlaceholder"] boolValue];
            if (asset.mediaType == PHAssetMediaTypeImage) {
                if ([[[asset valueForKey:@"filename"]lowercaseString] hasSuffix:jl_gifIdentifier]){
                    albumModel.type = JLPHAssetMediaTypePhotoGIF;
                }else{
                    albumModel.type = JLPHAssetMediaTypePhoto;
                }
                [photoModel.albumPhotoList addObject:albumModel];
            }else{
                albumModel.type = JLPHAssetMediaTypeVideo;
                [albumModel getNewTimeFromDurationSecond:asset.duration];
                if (weakS.config.configType != JLPhotoImageConfigTypeImage) {
                    [photoModel.albumPhotoList addObject:albumModel];
                }
            }
            
        }
    }];
}

/**
 第一次进入图片选择获取相册胶卷相册图片
 
 @param completion 完成回调
 */
- (void)jl_firstGetPhotoAblumlistComplete:(void(^_Nullable)
                                           (JLPhotoModel * _Nonnull assetModel,
                                            NSDictionary * _Nonnull info))completion{
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [smartAlbums enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool {
            // 是否按创建时间排序
            PHFetchOptions *option = [[PHFetchOptions alloc] init];
            // 照片列表是否按照片日期排序
            option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
            PHAssetCollection *assetCollection = (PHAssetCollection *)obj;
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
            
            if ([assetCollection.localizedTitle isEqualToString:@"相机胶卷"]) {
                
                JLPhotoModel *assetModel = [[JLPhotoModel alloc]init];
                assetModel.photoAssetName =
                assetCollection.localizedTitle;
                assetModel.count = fetchResult.count;
                assetModel.result = fetchResult;
                assetModel.lastAsset = fetchResult.lastObject;
                
                [fetchResult enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
                    @autoreleasepool {
                        JLPHAlbumModel *photoModel = [[JLPHAlbumModel alloc]init];
                        photoModel.asset = asset;
                        photoModel.pixelHeight = asset.pixelHeight;
                        photoModel.pixelWidth = asset.pixelWidth;
                        if ([[asset valueForKey:@"isCloudPlaceholder"] boolValue]) {
                            photoModel.isICloud = YES;
                        }
                        if (asset.mediaType == PHAssetMediaTypeImage) {
                            if ([[[asset valueForKey:@"filename"]lowercaseString] hasSuffix:@"gif"]){
                                photoModel.type = JLPHAssetMediaTypePhotoGIF;
                            }else{
                                photoModel.type = JLPHAssetMediaTypePhoto;
                            }
                            
                        }else{
                            photoModel.type = JLPHAssetMediaTypeVideo;
                            [photoModel getNewTimeFromDurationSecond:asset.duration];
                        }
                        [assetModel.albumPhotoList addObject:photoModel];
                        
                    }
                    
                    completion(assetModel,@{});
                }];
                *stop = YES;
            }
            
        }
    }];
}

#pragma mark - fetch Video Resource
- (void)jl_fetchViewResorurceFromAsset:(PHAsset *_Nonnull)asset
                         resultHandler:(void (^_Nullable)
                                        (AVAsset *__nullable asset,
                                         AVAudioMix *__nullable audioMix,
                                         NSDictionary *__nullable info))resultHandler{
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    
    PHImageManager *manager = [PHImageManager defaultManager];
    [manager requestAVAssetForVideo:asset options:options resultHandler:resultHandler];
    
}
/**
 ///删除选中状态后 选中的下标重新赋值
 
 @param photoModel 删除的Model
 */
- (void)removeAlbumPhotoModel:(JLPhotoModel *_Nullable)photoModel{
//    [[GTAlbumTools shareSingleton].selectPhotolist removeObject:photoModel];
//    for (NSInteger i = 0; i < [GTAlbumTools shareSingleton].selectPhotolist.count; i ++) {
//        GTWAlbumPhotoModel *selectModel = [GTAlbumTools shareSingleton].selectPhotolist[i];
//        selectModel.selectedIndex = i+1;
//    }
}

#pragma mark 获取原图

- (PHImageRequestID)jl_getOriginalPhotoDataWithAsset:(PHAsset *_Nullable)asset
                                          completion:(void (^_Nonnull)(NSData * _Nullable data,
                                                                       NSDictionary * _Nonnull info,
                                                                       BOOL isDegraded))completion{
    return [self getOriginalPhotoDataWithAsset:asset progressHandler:nil completion:completion];
    
}
- (PHImageRequestID)getOriginalPhotoDataWithAsset:(PHAsset *)asset progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler completion:(void (^)(NSData *data,NSDictionary *info,BOOL isDegraded))completion {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.networkAccessAllowed = YES;
    if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
        // if version isn't PHImageRequestOptionsVersionOriginal, the gif may cann't play
        option.version = PHImageRequestOptionsVersionOriginal;
    }
    [option setProgressHandler:progressHandler];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    return [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                             options:option
                                                       resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                                                           
                                                           BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
                                                           if (downloadFinined && imageData) {
                                                               if (completion)
                                                                   completion(imageData,info,NO);
                                                           }
                                                       }];
}

#pragma mark -
#pragma mark  权限判断
/**
 相册权限
 
 */
- (void)jl_fetchAlbumAuthor:(void(^ _Nonnull)(BOOL status))commplete{
   [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            if (commplete) {
                commplete(true);
            }
            DLog(@"没有相册权限");
            commplete(false);
        }
    }];
   
}


/**
 相机权限
 */
- (BOOL)jl_cameraAuthorStatus{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusAuthorized){
        //获取权限
        return YES;
    }else{
        DLog(@"没有相机权限");
        return false;
    }
}

#pragma mark - 图片上传
- (void)jl_transitionImageDataCompressionFlag:(BOOL)flag
                                     complete:(void (^_Nonnull)(NSArray * _Nullable dataArray))complete{
    NSMutableArray *photoDataArray = [NSMutableArray arrayWithCapacity:1];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        for (GTWAlbumPhotoModel *photoModel in self.selectPhotolist) {
//            @autoreleasepool {
//                GTWPhotoDataModel *dataModel = [GTWPhotoDataModel new];
//                NSString *fileName = [photoModel.asset valueForKey:@"filename"];
//
//                if ([fileName containsString:@".HEIC"]) {
//                    NSArray *names = [fileName componentsSeparatedByString:@".HEIC"];
//                    if (names.count > 0 ) {
//                        fileName =[NSString stringWithFormat:@"%@.JPG",names.firstObject];
//                    }else{
//                        fileName = [NSString stringWithFormat:@"png_%.0f.JPG",[NSDate timeIntervalSinceReferenceDate]];
//                    }
//                }
//                dataModel.fileName = fileName;
//
//                if (!flag &&![[dataModel.fileName  lowercaseString]hasSuffix:@"gif"]) {
//                    [self getOriginalPhotoWithAsset:photoModel.asset newCompletion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
//                        NSData *data = [UIImage lubanCompressImage:photo];                    dataModel.imageData = data;
//                        dispatch_semaphore_signal(semaphore);
//                    }];
//                }else{
//                    [self getOriginalPhotoDataWithAsset:photoModel.asset completion:^(NSData *data, NSDictionary *info, BOOL isDegraded) {
//                        dataModel.imageData = data;
//                        dispatch_semaphore_signal(semaphore);
//                    }];
//                }
//                [photoDataArray addObject:dataModel];
//                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//            }
//
//        }
//        complete([photoDataArray copy]);
//    });
}

- (NSLock *)jl_lock{
    if (!_jl_lock) {
        _jl_lock = [[NSLock alloc]init];
    }
    return _jl_lock;
}

@end
