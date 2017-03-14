//
//  IQEngUIIDCardScanViewController.m
//  自定义相机
//
//  Created by 力王 on 16/11/28.
//  Copyright © 2016年 Herson. All rights reserved.
//

#import "IQEngUIIDCardScanViewController.h"
#import "IQEngUIBackGroundView.h"
@interface IQEngUIIDCardScanViewController ()
@property(nonatomic, strong) UIButton *takePhotoButton;
@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) UIImageView *scanBackGroundImageView;
@property(nonatomic, strong) IQEngUIBackGroundView *backGroundView;

@end

@implementation IQEngUIIDCardScanViewController
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.sessionView.devicePosition = AVCaptureDevicePositionBack;
    [self.sessionView startRunning];
    [self.view addSubview:self.sessionView];
    
    self.backGroundView = [[IQEngUIBackGroundView alloc] init];
    [self.view addSubview:self.backGroundView];
    
    self.takePhotoButton = [[UIButton alloc] init];
    self.takePhotoButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    self.takePhotoButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.takePhotoButton setBackgroundColor:[UIColor colorWithRed:252.f/255.f green:102.f/255.f blue:33.f/255.f alpha:1]];
    [self.takePhotoButton setImage:[UIImage imageNamed_IQEngUICamera:@"IQEngUICamera_img_camera.png"] forState:UIControlStateNormal];
    [self.takePhotoButton addTarget:self action:@selector(__takePhotoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.takePhotoButton];
    
    self.backButton = [[UIButton alloc] init];
    self.backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    self.backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.backButton setBackgroundColor:[UIColor colorWithRed:252.f/255.f green:102.f/255.f blue:33.f/255.f alpha:1]];
    [self.backButton setImage:[UIImage imageNamed_IQEngUICamera:@"IQEngUICamera_btn_arrows_back.png"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(__backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    self.scanBackGroundImageView = [[UIImageView alloc] init];
    [self.scanBackGroundImageView setImage:[UIImage imageNamed_IQEngUICamera:@"IQEngUICamera_imag_scan_background.png"]];
    [self.view addSubview:self.scanBackGroundImageView];
}
-(void)__backButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)__takePhotoAction{
    //拍照
    [self.sessionView takePhoto];
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    self.sessionView.frame = bounds;
    
    CGRect f1 = bounds;
    f1.size = CGSizeMake(65, 65);
    f1.origin.y = (bounds.size.height - f1.size.height)/2;
    f1.origin.x = bounds.size.width - f1.size.width - 10;
    self.takePhotoButton.layer.cornerRadius = f1.size.width/2.f;
    self.takePhotoButton.frame = f1;
    
    CGRect f2 = bounds;
    f2.size = CGSizeMake(45, 45);
    f2.origin = CGPointMake(5, 5);
    self.backButton.layer.cornerRadius = f2.size.width/2.f;
    self.backButton.frame = f2;
    
    CGRect f3 = bounds;
    f3.size.height = bounds.size.height - 50*2;
    CGSize f3_size = self.scanBackGroundImageView.image.size;
    f3.size.width = f3.size.height/f3_size.height*f3_size.width;
    f3.origin.x = (bounds.size.width - f3.size.width)/2;
    f3.origin.y = (bounds.size.height - f3.size.height)/2;
    self.scanBackGroundImageView.frame= f3;
    
    [self.sessionView setTransformThatFitDeviceOrientation:UIDeviceOrientationLandscapeRight animated:YES];
    
    self.backGroundView.frame = bounds;
    self.backGroundView.transparentFrame = f3;
}
-(CGRect)effectiveRect{
    return  self.scanBackGroundImageView.frame;
}

#pragma mark - lazy load
-(IQEngUIPhotoSessionView *)sessionView{
    if (!_sessionView) {
        _sessionView = [[IQEngUIPhotoSessionView alloc] init];
        __weak typeof(self) wself = self;
        _sessionView.whenTakePhoto = ^(UIImage *photo){
            __weak typeof(self) self = wself;
            UIImage *image = photo;
            image = [UIImage image:image scaleToSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
            image = [UIImage imageFromImage:image inRect:self.effectiveRect];
            // 写入相册
            if (self.shouldWriteToSavedPhotos) {
                UIImageWriteToSavedPhotosAlbum(image, self, nil, NULL);
            }
            if (self.whenFinsh) {
                self.whenFinsh(image);
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return _sessionView;
}
@end
