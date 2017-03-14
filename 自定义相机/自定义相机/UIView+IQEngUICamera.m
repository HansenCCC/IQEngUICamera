//
//  UIView+IQEngUICamera.m
//  IQEngIDCard
//
//  Created by 程恒盛 on 17/3/13.
//  Copyright © 2017年 力王. All rights reserved.
//

#import "UIView+IQEngUICamera.h"

@implementation UIView (IQEngUICamera)
+ (CGAffineTransform)transformWithDeviceOrientation:(UIDeviceOrientation)orientation{
    CGAffineTransform m = CGAffineTransformIdentity;
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
            m = CGAffineTransformMakeRotation(M_PI_2);
            break;
        case UIDeviceOrientationLandscapeRight:
            m = CGAffineTransformMakeRotation(-M_PI_2);
            break;
        case UIDeviceOrientationPortrait:
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            m = CGAffineTransformMakeRotation(M_PI);
            break;
        default:
            break;
    }
    return m;
}
- (void)setTransformThatFitDeviceOrientation:(UIDeviceOrientation)orientation animated:(BOOL)animted{
    CGAffineTransform m = [self.class transformWithDeviceOrientation:orientation];
    if(animted){
        [UIView animateWithDuration:0.25 animations:^{
            self.transform = m;
        }];
    }else{
        self.transform = m;
    }
}
@end
