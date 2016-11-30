//
//  IQEngUIPhotoSessionView.h
//  自定义相机
//  拍照
//  Created by 力王 on 16/11/28.
//  Copyright © 2016年 Herson. All rights reserved.
//

#import "IQEngUIAVCaptureSessionView_base.h"

@interface IQEngUIPhotoSessionView : IQEngUIAVCaptureSessionView_base <AVCapturePhotoCaptureDelegate>
//完成拍照回调
@property(nonatomic, strong) void (^whenTakePhoto) (UIImage *photo);

/**
 *  拍照
 */
-(void)takePhoto;
@end
