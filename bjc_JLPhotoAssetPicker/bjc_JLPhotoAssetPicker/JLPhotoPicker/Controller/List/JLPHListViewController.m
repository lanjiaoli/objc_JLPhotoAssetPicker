//
//  JLPHListViewController.m
//  bjc_JLPhotoAssetPicker
//
//  Created by L on 2019/3/6.
//  Copyright © 2019 L. All rights reserved.
//

#import "JLPHListViewController.h"
#import "JLPHPickerHeader.h"
#import "JLPHSelectViewController.h"

@interface JLPHListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JLPHListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [JLPhotoToolsSingle shareSingleton].config.allAlbamlists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault)
                                     reuseIdentifier:@"cell"];
    }
    JLPhotoModel *photoModel = [JLPhotoToolsSingle shareSingleton].config.allAlbamlists[indexPath.row];
    cell.textLabel.text = photoModel.photoAssetName;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JLPHSelectViewController *selecVC = [[JLPHSelectViewController alloc]init];
    JLPhotoModel *photoModel = [JLPhotoToolsSingle shareSingleton].config.allAlbamlists[indexPath.row];
    selecVC.photoModel = photoModel;
    [self.navigationController pushViewController:selecVC animated:YES];
    
}
#pragma mark -
#pragma mark - lazy loading
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStylePlain)];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
@end
