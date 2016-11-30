//
//  IQEngUIFaceViewController.m
//  自定义相机
//
//  Created by 力王 on 16/11/28.
//  Copyright © 2016年 Herson. All rights reserved.
//

#import "IQEngUIFaceViewController.h"

@interface IQEngUIFaceViewController ()<IQEngUIQRCodeSessionViewDelegate>
@property(nonatomic, strong) UIView *faceView;

@end

@implementation IQEngUIFaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = [UIColor whiteColor];
    [self.sessionView startRunning];
    self.sessionView.devicePosition = AVCaptureDevicePositionFront;

    self.faceView = [[UIView alloc] init];
    self.faceView.layer.borderWidth = 1;
    self.faceView.layer.borderColor = [UIColor yellowColor].CGColor;
    [self.sessionView addSubview:self.faceView];
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    self.sessionView.frame = bounds;
}
#pragma mark - lazy load
-(IQEngUIQRCodeSessionView *)sessionView{
    if (!_sessionView) {
        _sessionView = [[IQEngUIQRCodeSessionView alloc] init];
        _sessionView.delegate = self;
        [self.view addSubview:_sessionView];
    }
    return _sessionView;
}
#pragma mark - IQEngUIQRCodeSessionViewDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    //显示最大的脸
    CGRect f1 = CGRectZero;
    for (AVMetadataFaceObject *faceObject in metadataObjects) {
        CGRect f2 = [self.sessionView.previewLayer rectForMetadataOutputRectOfInterest:faceObject.bounds];
        if (f1.size.height*f1.size.width < f2.size.height*f2.size.width) {
            f1 = f2;
        }
    }
    self.faceView.frame = f1;
}
@end
