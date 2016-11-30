//
//  IQEngUIPhotoSessionView.m
//  自定义相机
//
//  Created by 力王 on 16/11/28.
//  Copyright © 2016年 Herson. All rights reserved.
//

#import "IQEngUIPhotoSessionView.h"

@interface IQEngUIPhotoSessionView ()
@property(nonatomic, strong) AVCapturePhotoOutput *photoOutput;

@end

@implementation IQEngUIPhotoSessionView

-(instancetype)init{
    if (self = [super init]) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return self;//判断是否支持相机
        
        if ([self.session canAddOutput:self.photoOutput]) {
            [self.session addOutput:self.photoOutput];
        }
    }
    return self;
}

-(void)takePhoto{    
    AVCaptureConnection *conntion = [self.photoOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!conntion) return;
    AVCapturePhotoSettings *photoSettings = [AVCapturePhotoSettings photoSettings];
    photoSettings.flashMode = self.flashMode;
    if (_photoOutput.photoSettingsForSceneMonitoring) {
        [self.photoOutput capturePhotoWithSettings:photoSettings delegate:self];
    }else{
        [self.photoOutput capturePhotoWithSettings:photoSettings delegate:self];
    }
}

#pragma mark - AVCapturePhotoCaptureDelegate
//成功拍照回调sessionPreset
-(void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error{
    
    NSData *data =  [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
    UIImage *photo = [UIImage imageWithData:data];
    if (self.whenTakePhoto) {
        self.whenTakePhoto(photo);
    }
}
#pragma mark - lazy load
-(AVCapturePhotoOutput *)photoOutput{
    if (!_photoOutput) {
        _photoOutput = [[AVCapturePhotoOutput alloc] init];
    }
    return _photoOutput;
}
-(AVCaptureOutput *)output{
    return self.photoOutput;
}
@end
