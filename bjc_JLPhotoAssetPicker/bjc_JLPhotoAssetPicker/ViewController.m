//
//  ViewController.m
//  bjc_JLPhotoAssetPicker
//
//  Created by L on 2019/3/6.
//  Copyright © 2019 L. All rights reserved.
//

#import "ViewController.h"
#import "JLPHPickerHeader.h"

@interface ViewController ()
@property (nonatomic, strong) JLPHPickerConfig *config;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)selectAction:(id)sender {

    JLPHPickerNavController *pickerVC = [[JLPHPickerNavController alloc]initWithConfiguration:self.config];
    [self presentViewController:pickerVC animated:YES completion:nil];
}

- (JLPHPickerConfig *)config{
    if (!_config) {
        _config = [[JLPHPickerConfig alloc]initWithConfigType:(JLPhotoImageConfigTypeDefault) selectArray:[NSMutableArray array]];
    }
    return _config;
}
@end
