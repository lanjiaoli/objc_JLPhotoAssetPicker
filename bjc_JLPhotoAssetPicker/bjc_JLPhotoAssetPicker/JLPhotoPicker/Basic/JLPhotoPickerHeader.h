//
//  JLPhotoPicker.h
//  bjc_JLPhotoAssetPicker
//
//  Created by L on 2019/3/6.
//  Copyright © 2019 L. All rights reserved.
//

#define JLPhotoPickerHeader_h
#import "JLPhotoToolsSingle.h"
#import "JLPHPickerConfig.h"
#import "JLPHPickerNavController.h"
#import "JLPhotoModel.h"


#define SCREEN_BOUNDS          [[UIScreen mainScreen] bounds]
#define SCREEN_HEIGHT          SCREEN_BOUNDS.size.height
#define SCREEN_WIDTH           SCREEN_BOUNDS.size.width

#define SafeAreaStatusBarHeight (SCREEN_HEIGHT == 812.0 ? 44 : 20)//iPhoneX 距离顶部状态栏
#define SafeAreaTopHeight (SCREEN_HEIGHT == 812.0 ? 88 : 64)//iPhoneX 距离顶部+带导航栏
#define SafeAreaTabbarHeight (SCREEN_HEIGHT == 812.0 ? 83 : 49) //iPhoneX 距离底部
#define SafeAreaBottomHeight (SCREEN_HEIGHT == 812.0 ? 34 : 0)
#ifdef DEBUG
#define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#endif /* JLPhotoPicker_h */
