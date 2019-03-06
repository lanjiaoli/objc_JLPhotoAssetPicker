//
//  JLPHPicekerConfig.h
//  bjc_JLPhotoAssetPicker
//
//  Created by L on 2019/3/6.
//  Copyright © 2019 L. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef  NS_ENUM(NSUInteger, JLPhImageConfigType){
    /**默认情况下 ,视频和图片模式*/
    JLPhotoImageConfigTypeDefault = 0,
    /**单图模式*/
    JLPhotoImageConfigTypeImage = 1,
    /**单视频模式*/
    JLPhotoImageConfigTypeVideo = 2
};
@interface JLPHPickerConfig : NSObject
/**已选中照片集合*/
@property (nonatomic, strong) NSMutableArray *selectPhotoArray;
/**选择中的最大数 默认是 9个*/
@property (nonatomic, assign) NSInteger maxNum;
/**类型 */
@property (nonatomic, assign) JLPhImageConfigType configType;

- (instancetype)initWithConfigType:(JLPhImageConfigType)configType selectArray:(NSMutableArray *)selectArray;
@end

NS_ASSUME_NONNULL_END
