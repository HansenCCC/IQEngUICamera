//
//  IQEngUIAVCaptureSessionView_base.m
//  自定义相机
//

//  Created by 力王 on 16/11/17.
//  Copyright © 2016年 Herson. All rights reserved.
//
/*AVCaptureSessionPresetLow,AVCaptureSessionPresetHigh,AVCaptureSessionPresetPhoto,AVCaptureSessionPresetMedium,AVCaptureSessionPreset352x288,AVCaptureSessionPreset640x480,AVCaptureSessionPreset1280x720,AVCaptureSessionPreset1920x1080,AVCaptureSessionPreset3840x2160,AVCaptureSessionPresetiFrame960x540,AVCaptureSessionPresetInputPriority,AVCaptureSessionPresetiFrame1280x720*/


#import "IQEngUIAVCaptureSessionView_base.h"

DEF_EnumTypeCategories(IQEngAVCaptureSessionPreset, (
  @{
    @(IQEngAVCaptureSessionPresetLow):AVCaptureSessionPresetLow,
    @(IQEngAVCaptureSessionPresetHigh):AVCaptureSessionPresetHigh,
    @(IQEngAVCaptureSessionPresetPhoto):AVCaptureSessionPresetPhoto,
    @(IQEngAVCaptureSessionPresetMedium):AVCaptureSessionPresetMedium,
    @(IQEngAVCaptureSessionPreset352x288):AVCaptureSessionPreset352x288,
    @(IQEngAVCaptureSessionPreset640x480):AVCaptureSessionPreset640x480,
    @(IQEngAVCaptureSessionPreset1280x720):AVCaptureSessionPreset1280x720,
    @(IQEngAVCaptureSessionPreset1920x1080):AVCaptureSessionPreset1920x1080,
    @(IQEngAVCaptureSessionPreset3840x2160):AVCaptureSessionPreset3840x2160,
    @(IQEngAVCaptureSessionPresetiFrame960x540):AVCaptureSessionPresetiFrame960x540,
    @(IQEngAVCaptureSessionPresetInputPriority):AVCaptureSessionPresetInputPriority,
    @(IQEngAVCaptureSessionPresetiFrame1280x720):AVCaptureSessionPresetiFrame1280x720})
)

@interface IQEngUIAVCaptureSessionView_base ()
@property (nonatomic, strong) AVCaptureSession *session;
@property(nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property(nonatomic, strong) UIView *focusView;
@property (nonatomic ,strong) AVCaptureVideoPreviewLayer *previewLayer;
@end

@implementation IQEngUIAVCaptureSessionView_base

-(instancetype)init{
    if (self = [super init]) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return self;//判断是否支持相机
        
        _showFocusView = YES;
        _devicePosition = AVCaptureDevicePositionBack;
        _sessionPreset = IQEngAVCaptureSessionPresetPhoto;
        
        self.device = [self cameraWithPosition:self.devicePosition];
        //初始化输入设备
        self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
//        self.photoOutput = [[AVCapturePhotoOutput alloc] init];
        self.session = [[AVCaptureSession alloc] init];
        
        self.session.sessionPreset = [NSString stringWithIQEngAVCaptureSessionPreset:self.sessionPreset];
        //输入输出设备结合
        if ([self.session canAddInput:self.input]) {
            [self.session addInput:self.input];
        }
//        if ([self.session canAddOutput:self.photoOutput]) {
//            [self.session addOutput:self.photoOutput];
//        }
        //预览层的生成
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.layer addSublayer:self.previewLayer];
        
        //设置闪关灯初始状态
        _flashMode = AVCaptureFlashModeAuto;
        //添加手势
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(whenTapGesture:)];
        [self addGestureRecognizer:self.tapGestureRecognizer];
        
        self.focusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.focusView.layer.borderWidth = 1;
        self.focusView.layer.borderColor = [UIColor redColor].CGColor;
        [self addSubview:self.focusView];
        self.focusView.hidden = YES;
    }
    return self;
}

-(void)whenTapGesture:(UITapGestureRecognizer *)tap{
    [self focusAtPoint:[tap locationInView:tap.view]];
}
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    //此方法iOS 10 之后已经弃用 "Use AVCaptureDeviceDiscoverySession instead."
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
#pragma clang diagnostic pop
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ){
            return device;
        }
    return nil;
}
- (void)focusAtPoint:(CGPoint)point{
    if (!self.showFocusView) return;
    [IQEngUIAVCaptureSessionView_base cancelPreviousPerformRequestsWithTarget:self];//取消延迟加载
    
    CGSize size = self.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        //对焦模式和对焦点
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        //曝光模式和曝光点
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        //设置对焦动画
        _focusView.center = point;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                _focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [self performSelector:@selector(__hiddenFocusView) withObject:nil afterDelay:1];
            }];
        }];
    }
}
-(void)__hiddenFocusView{
    _focusView.hidden = YES;
}
//设置前后摄像头
-(void)setDevicePosition:(AVCaptureDevicePosition)devicePosition{
    _devicePosition = devicePosition;
    
    AVCaptureDevice *newCamera = nil;
    AVCaptureDeviceInput *newInput = nil;
    
    newCamera = [self cameraWithPosition:devicePosition];
    //拿到另外一个摄像头位置
//    AVCaptureDevicePosition position = [[_input device] position];
//    if (position == AVCaptureDevicePositionFront){
//        newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
//    }else {
//        newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
//    }
    //生成新的输入
    newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
    if (newInput != nil) {
        [self.session beginConfiguration];
        [self.session removeInput:self.input];
        if ([self.session canAddInput:newInput]) {
            [self.session addInput:newInput];
            self.input = newInput;
        } else {
            [self.session addInput:self.input];
        }
        [self.session commitConfiguration];
    }
}
//设置闪光灯
-(void)setFlashMode:(AVCaptureFlashMode)flashMode{
    _flashMode = flashMode;
    
    if ([_device lockForConfiguration:nil]) {
        //自动白平衡
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [_device unlockForConfiguration];
    }
}
-(void)setSessionPreset:(IQEngAVCaptureSessionPreset)sessionPreset{
    _sessionPreset = sessionPreset;
    
    if ([_device lockForConfiguration:nil]) {
        //设置图片品质
        self.session.sessionPreset = [NSString stringWithIQEngAVCaptureSessionPreset:sessionPreset];
        [_device unlockForConfiguration];
    }
}
//-(void)takePhoto{
//    AVCaptureConnection *conntion = [self.photoOutput connectionWithMediaType:AVMediaTypeVideo];
//    if (!conntion) return;
//    AVCapturePhotoSettings *photoSettings = [AVCapturePhotoSettings photoSettings];
//    photoSettings.flashMode = self.flashMode;
//    if (_photoOutput.photoSettingsForSceneMonitoring) {
//        [self.photoOutput capturePhotoWithSettings:photoSettings delegate:self];
//    }else{
//        [self.photoOutput capturePhotoWithSettings:photoSettings delegate:self];
//    }
//    
//}
-(void)startRunning{
    //设备取景开始
    [self.session startRunning];
}
- (void)stopRunning{
    [self.session stopRunning];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    self.previewLayer.frame = bounds;
}
@end
