//
//  JLPHPicekerConfig.m
//  bjc_JLPhotoAssetPicker
//
//  Created by L on 2019/3/6.
//  Copyright © 2019 L. All rights reserved.
//

#import "JLPHPickerConfig.h"

@implementation JLPHPickerConfig
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxNum = 9;
        self.configType = JLPhotoImageConfigTypeDefault;
    }
    return self;
}
- (instancetype)initWithConfigType:(JLPhImageConfigType)configType selectArray:(NSMutableArray *)selectArray{
    self = [self init];
    if (self) {
        self.configType = configType;
        self.selectPhotoArray  = [selectArray mutableCopy];
    }
    return self;
}
- (NSMutableArray *)selectPhotoArray{
    if (!_selectPhotoArray) {
        _selectPhotoArray  = [NSMutableArray arrayWithCapacity:1];
    }
    return _selectPhotoArray;
}
@end
