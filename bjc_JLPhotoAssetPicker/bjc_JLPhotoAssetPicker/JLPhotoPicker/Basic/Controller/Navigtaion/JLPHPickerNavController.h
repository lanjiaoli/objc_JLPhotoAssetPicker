//
//  JLPHPickerNavController.h
//  bjc_JLPhotoAssetPicker
//
//  Created by L on 2019/3/6.
//  Copyright © 2019 L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLPHPickerHeader.h"
@class JLPHPickerConfig;

NS_ASSUME_NONNULL_BEGIN

@interface JLPHPickerNavController : UINavigationController
@property (nonatomic, strong) JLPHPickerConfig *config;
/**
 初始化
 
 @param configuration 配置
 @return GTWImagePickerController
 */
- (instancetype)initWithConfiguration:(JLPHPickerConfig *)configuration;

- (void)sendAction;
@end

NS_ASSUME_NONNULL_END
