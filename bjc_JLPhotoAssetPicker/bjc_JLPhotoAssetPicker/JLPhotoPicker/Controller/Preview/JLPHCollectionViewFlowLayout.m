//
//  JLPHCollectionViewFlowLayout.m
//  bjc_JLPhotoAssetPicker
//
//  Created by L on 2019/3/10.
//  Copyright © 2019 L. All rights reserved.
//

#import "JLPHCollectionViewFlowLayout.h"

@implementation JLPHCollectionViewFlowLayout
- (void)prepareLayout{
    [super prepareLayout];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    return array;
}
@end
