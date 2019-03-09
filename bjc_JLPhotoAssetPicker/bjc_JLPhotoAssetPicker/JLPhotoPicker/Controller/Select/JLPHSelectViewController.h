//
//  JLPHSelectViewController.h
//  bjc_JLPhotoAssetPicker
//
//  Created by L on 2019/3/6.
//  Copyright © 2019 L. All rights reserved.
//

#import "JLPHBasicViewController.h"
@class JLPhotoModel;

NS_ASSUME_NONNULL_BEGIN

@interface JLPHSelectViewController : JLPHBasicViewController
@property (nonatomic , strong) JLPhotoModel * photoModel;
@end

NS_ASSUME_NONNULL_END
