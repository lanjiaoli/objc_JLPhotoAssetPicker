//
//  JLPhotoModel.m
//  bjc_JLPhotoAssetPicker
//
//  Created by L on 2019/3/6.
//  Copyright © 2019 L. All rights reserved.
//

#import "JLPhotoModel.h"

@implementation JLPhotoModel
- (NSMutableArray *)albumPhotoList{
    if (!_albumPhotoList) {
        _albumPhotoList = [NSMutableArray arrayWithCapacity:1];
    }
    return _albumPhotoList;
}
@end


@implementation JLPHAlbumModel
/**
 获取视频的时长
 */
- (void)getNewTimeFromDurationSecond:(NSInteger)duration {
    NSString *newTime;
    if (duration < 10) {
        newTime = [NSString stringWithFormat:@"00:0%zd",duration];
    } else if (duration < 60) {
        newTime = [NSString stringWithFormat:@"00:%zd",duration];
    } else {
        NSInteger min = duration / 60;
        NSInteger sec = duration - (min * 60);
        if (sec < 10) {
            newTime = [NSString stringWithFormat:@"%zd:0%zd",min,sec];
        } else {
            newTime = [NSString stringWithFormat:@"%zd:%zd",min,sec];
        }
    }
    self.videoTime = newTime;
}
- (BOOL)markFlag{
    if (self.type == JLPHAssetMediaTypePhotoGIF) {
        return false;
    }
    return true;
}
@end


@implementation JLPHDataModel
- (BOOL)gifFlag{
    if ([[self.fileName lowercaseString]containsString:@".gif"]) {
        return YES;
    }
    return false;
}
@end
nonatomic, 