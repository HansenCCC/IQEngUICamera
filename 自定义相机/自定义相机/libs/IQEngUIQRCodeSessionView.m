//
//  IQEngUIQRCodeSessionView.m
//  自定义相机
//
//  Created by 力王 on 16/11/21.
//  Copyright © 2016年 Herson. All rights reserved.
//

#import "IQEngUIQRCodeSessionView.h"
#import <AVFoundation/AVFoundation.h>

@interface IQEngUIQRCodeSessionView ()
@property(nonatomic, strong) AVCaptureMetadataOutput *qrcCodeOutput;

@end

@implementation IQEngUIQRCodeSessionView
-(instancetype)init{
    if (self = [super init]) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return self;//判断是否支持相机
        
        [self.qrcCodeOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        if ([self.session canAddOutput:self.qrcCodeOutput])
            [self.session addOutput:self.qrcCodeOutput];
        self.type = IQEngMetadataObjectTypeQR;
    }
    return self;
}
-(void)setType:(IQEngMetadataObjectType)type{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;//防止在模拟器下挂掉
    _type = type;
    if (type == IQEngMetadataObjectTypeQR)
    {
        [self.qrcCodeOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,
                                                 AVMetadataObjectTypeEAN13Code,
                                                 AVMetadataObjectTypeEAN8Code,
                                                 AVMetadataObjectTypeCode128Code
                                                 ]];
    }else{
        [self.qrcCodeOutput setMetadataObjectTypes:@[AVMetadataObjectTypeFace]];
    }
}
-(AVCaptureOutput *)output{
    return self.qrcCodeOutput;
}
-(AVCaptureMetadataOutput *)qrcCodeOutput{
    if (!_qrcCodeOutput) {
        _qrcCodeOutput = [[AVCaptureMetadataOutput alloc] init];
    }
    return _qrcCodeOutput;
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{//扫描结果回调
    if (self.type == IQEngMetadataObjectTypeQR) {
        if ([metadataObjects count] >0){
            //停止扫描
            [self stopRunning];
            AVMetadataObject * metadataObject = [metadataObjects objectAtIndex:0];
            if (self.whenFinish) self.whenFinish(metadataObject);
        }
    }else if(self.type == IQEngMetadataObjectTypeFace){
        if ([self.delegate respondsToSelector:@selector(captureOutput:didOutputMetadataObjects:fromConnection:)])
            [self.delegate captureOutput:captureOutput didOutputMetadataObjects:metadataObjects fromConnection:connection];
    }
}
@end
