//
//  IQEngUIQRCodeSessionView.h
//  自定义相机
//  二维码扫描&人脸识别
//  Created by 力王 on 16/11/21.
//  Copyright © 2016年 Herson. All rights reserved.
//

#import "IQEngUIAVCaptureSessionView_base.h"

typedef enum : NSUInteger {
    IQEngMetadataObjectTypeQR = 0,//二维码
    IQEngMetadataObjectTypeFace,//人脸
} IQEngMetadataObjectType;

@protocol IQEngUIQRCodeSessionViewDelegate <NSObject>
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection;//识别成功回调
@end

@interface IQEngUIQRCodeSessionView : IQEngUIAVCaptureSessionView_base<AVCaptureMetadataOutputObjectsDelegate>
//输出图片
//@property(nonatomic, strong) AVCaptureMetadataOutput *qrcCodeOutput;
//扫描类型(默认人脸识别类型)
@property(nonatomic, assign) IQEngMetadataObjectType type;
//扫描成功后回调此方法
@property(nonatomic, strong) void (^whenFinish) (AVMetadataObject *codeObject);
//delegate
@property(nonatomic, strong) id<IQEngUIQRCodeSessionViewDelegate> delegate;
@end
