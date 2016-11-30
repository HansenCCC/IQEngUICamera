//
//  IQEngUIQRCodeViewController.m
//  自定义相机
//
//  Created by 力王 on 16/11/22.
//  Copyright © 2016年 Herson. All rights reserved.
//

#import "IQEngUIQRCodeViewController.h"
#import "IQEngUIQRCodeView.h"
@interface IQEngUIQRCodeViewController ()
@property(nonatomic, strong) IQEngUIQRCodeView *qrCodeView;

@end

@implementation IQEngUIQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.sessionView startRunning];
    
    self.qrCodeView = [[IQEngUIQRCodeView alloc] init];
    [self.sessionView addSubview:self.qrCodeView];
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    self.sessionView.frame = bounds;
    self.qrCodeView.frame = bounds;

    CGRect f1 = bounds;
    f1.size = CGSizeMake(bounds.size.width*3/4, bounds.size.width*3/4);
    f1.origin.x = (bounds.size.width - f1.size.width)/2;
    f1.origin.y = (bounds.size.height - f1.size.height)/2;
    self.qrCodeView.maskViewFrame = f1;
    
    //设置扫描区域
    CGRect f2 = [self.sessionView.previewLayer metadataOutputRectOfInterestForRect:f1];
    ((AVCaptureMetadataOutput *)self.sessionView.output).rectOfInterest = f2;
}
#pragma mark - lazy load
-(IQEngUIQRCodeSessionView *)sessionView{
    if (!_sessionView) {
        _sessionView = [[IQEngUIQRCodeSessionView alloc] init];
        _sessionView.showFocusView = NO;//取消点击对焦功能
        [self.view addSubview:_sessionView];
    }
    return _sessionView;
}
@end
