//
//  JLPHBasicViewController.m
//  bjc_JLPhotoAssetPicker
//
//  Created by L on 2019/3/6.
//  Copyright © 2019 L. All rights reserved.
//

#import "JLPHBasicViewController.h"

@interface JLPHBasicViewController ()

@end

@implementation JLPHBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(cancelAction:)];
}

- (void)cancelAction:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
