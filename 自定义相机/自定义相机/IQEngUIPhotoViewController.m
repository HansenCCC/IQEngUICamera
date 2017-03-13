//
//  IQEngUIPhotoViewController.m
//  自定义相机
//
//  Created by 力王 on 16/11/28.
//  Copyright © 2016年 Herson. All rights reserved.
//

#import "IQEngUIPhotoViewController.h"
#import "UIImage+IQEngUICamera.h"

@interface IQEngUIPhotoViewController ()
@property(nonatomic, strong) UIButton *takePhotoButton;

@end

@implementation IQEngUIPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.sessionView.devicePosition = AVCaptureDevicePositionBack;
    [self.sessionView startRunning];
    
    
    self.takePhotoButton = [[UIButton alloc] init];
    [self.takePhotoButton setImage:[UIImage imageNamed_IQEngUICamera:@"IQEngUICameraTakePhoto.png"] forState:UIControlStateNormal];
    [self.takePhotoButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.sessionView addSubview:self.takePhotoButton];
}

-(void)takePhoto{
    //拍照
    [self.sessionView takePhoto];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    self.sessionView.frame = bounds;
    
    CGRect f1 = bounds;
    f1.size = CGSizeMake(65, 65);
    f1.origin.x = (bounds.size.width - f1.size.width)/2;
    f1.origin.y = bounds.size.height - f1.size.height - 20;
    self.takePhotoButton.frame = f1;
}
#pragma mark - lazy load
-(IQEngUIPhotoSessionView *)sessionView{
    if (!_sessionView) {
        _sessionView = [[IQEngUIPhotoSessionView alloc] init];
        [self.view addSubview:_sessionView];
    }
    return _sessionView;
}
@end
