//
//  JLPHPickerNavController.m
//  bjc_JLPhotoAssetPicker
//
//  Created by L on 2019/3/6.
//  Copyright © 2019 L. All rights reserved.
//

#import "JLPHPickerNavController.h"
#import "JLPHListViewController.h"
#import "JLPHSelectViewController.h"


@interface JLPHPickerNavController ()

@end

@implementation JLPHPickerNavController
- (instancetype)initWithConfiguration:(JLPHPickerConfig *)configuration{
    if (configuration == nil ||
        configuration.selectPhotoArray.count == 0) {
        
    }
    [JLPhotoToolsSingle shareSingleton].config = configuration;
    JLPHListViewController * photoListVC = [[JLPHListViewController alloc] init];
//    photoBrowserVC.hideVideos = YES;
    self = [super initWithRootViewController:photoListVC];
    if (self) {
        [self pushPhotoImageController];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark -
#pragma mark - Action Mothed
- (void)cancelAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)backButtonClicked{
    [self popViewControllerAnimated:YES];
}

- (void)pushPhotoImageController{
//    [[JLPhotoToolsSingle shareSingleton]jl_fetchAlbumAuthor:^(BOOL status) {
//        if (status) {
//            JLPHSelectViewController *photoSelectVC = [[JLPHSelectViewController alloc]init];
//            //    GTWPhotoAssetModel *assetModel = [GTAlbumTools shareSingleton].photoAssetModelList.firstObject;
//            //    photoSelectVC.navigationItem.title = assetModel.photoAssetName;
//            //    photoSelectVC.selectViewModel.albumPhotoList = assetModel.albumPhotoList;
//            [self pushViewController:photoSelectVC animated:YES];
//        }
//    }];
    JLPHSelectViewController *photoSelectVC = [[JLPHSelectViewController alloc]init];
    JLPhotoModel * photoModel = [JLPhotoToolsSingle shareSingleton].config.allAlbamlists.firstObject;
    photoSelectVC.navigationItem.title = photoModel.photoAssetName;
    photoSelectVC.photoModel = photoModel;
    [self pushViewController:photoSelectVC animated:YES];
  
}

- (void)sendAction{
//    if (self.imagePickerSendDataBlock) {
//        self.imagePickerSendDataBlock([GTAlbumTools shareSingleton].selectPhotolist,[GTAlbumTools shareSingleton].selectMediaType);
//    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAlert{
    
}

@end
