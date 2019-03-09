#### OC版本相册资源选择器

具体用法
```
 _config = [[JLPHPickerConfig alloc]initWithConfigType:(JLPhotoImageConfigTypeDefault) selectArray:[NSMutableArray array]];
 JLPHPickerNavController *pickerVC = [[JLPHPickerNavController alloc]initWithConfiguration:_config];
    [self presentViewController:pickerVC animated:YES completion:nil];
```
