//
//  UIView+IQEngUICamera.h
//  IQEngIDCard
//
//  Created by 程恒盛 on 17/3/13.
//  Copyright © 2017年 力王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IQEngUICamera)
/**
 *  自动根据当前设备的朝向,设置self.transform值
 *
 *  @param animted 是否动画,默认的动画时间为0.25秒
 */
- (void)setTransformThatFitDeviceOrientation:(UIDeviceOrientation)orientation animated:(BOOL)animted;
@end
