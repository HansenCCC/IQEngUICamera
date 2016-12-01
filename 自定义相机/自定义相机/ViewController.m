//
//  ViewController.m
//  自定义相机
//
//  Created by 程恒盛s on 16/11/17.
//  Copyright © 2016年 Herson. All rights reserved.
//

#import "ViewController.h"
#import "IQEngUIQRCodeViewController.h"
#import "IQEngUIFaceViewController.h"
#import "IQEngUIPhotoViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray <NSString *>*datas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义相机";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.tableView];
    
    self.datas = @[@"二维码扫描",@"人脸追踪识别",@"自定义相机"];
    
}
#pragma mark - UITableViewDelegate&UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = [self.datas objectAtIndex:indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            IQEngUIQRCodeViewController *iqEngVC = [[IQEngUIQRCodeViewController alloc] init];
            iqEngVC.title = [self.datas objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:iqEngVC animated:YES];
            iqEngVC.sessionView.type = IQEngMetadataObjectTypeQR;
            __weak typeof(self) wself = self;
            iqEngVC.sessionView.whenFinish = ^(AVMetadataObject *codeObject){
                AVMetadataMachineReadableCodeObject *object = (AVMetadataMachineReadableCodeObject *)codeObject;
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扫描结果" message:object.stringValue preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [wself.navigationController popViewControllerAnimated:YES];
                }]];
                [wself.navigationController presentViewController:alert animated:YES completion:nil];
            };
        }
            break;
        case 1:
        {
            IQEngUIFaceViewController *iqEngVC = [[IQEngUIFaceViewController alloc] init];
            iqEngVC.title = [self.datas objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:iqEngVC animated:YES];
            iqEngVC.sessionView.type = IQEngMetadataObjectTypeFace;
        }
            break;
        case 2:
        {
            IQEngUIPhotoViewController *iqEngVC = [[IQEngUIPhotoViewController alloc] init];
            iqEngVC.title = [self.datas objectAtIndex:indexPath.row];
            iqEngVC.sessionView.whenTakePhoto = ^(UIImage *image){
                NSLog(@"%@",image);
            };
            [self.navigationController pushViewController:iqEngVC animated:YES];
        }
            break;
        default:
            break;
    }
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGRect bounds = self.view.bounds;
    self.tableView.frame = bounds;
    
}
@end
